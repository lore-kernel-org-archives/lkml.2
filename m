Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1AFWnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:43:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab1AFWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:43:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 3/11] ACPI / PM: Use device wakeup flags for handling ACPI wakeup devices
Date: Thu, 6 Jan 2011 23:34:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201101062331.17079.rjw@sisk.pl>
In-Reply-To: <201101062331.17079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062334.22792.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There are ACPI devices (buttons and the laptop lid) that can wake up
the system from sleep states and have no "physical" companion
devices.  The ACPI subsystem uses two flags, wakeup.state.enabled and
wakeup.flags.always_enabled, for handling those devices, but they
are not accessible through the standard device wakeup infrastructure.
User space can only control them via the /proc/acpi/wakeup interface
that is not really convenient (e.g. the way in which devices are
enabled to wake up the system is not portable between different
systems, because it requires one to know the devices' "names" used in
the system's ACPI tables).

To address this problem, use standard device wakeup flags instead of
the special ACPI flags for handling those devices.  In particular,
use device_set_wakeup_capable() to mark the ACPI wakeup devices
during initialization and use device_set_wakeup_enable() to allow
or disallow them to wake up the system from sleep states.  Rework
the /proc/acpi/wakeup interface to take these changes into account.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/button.c |    4 ++--
 drivers/acpi/proc.c   |   19 +++++++++++++------
 drivers/acpi/scan.c   |    2 +-
 drivers/acpi/wakeup.c |   18 ++++++++++--------
 4 files changed, 26 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -37,11 +37,12 @@ void acpi_enable_wakeup_devices(u8 sleep
 			container_of(node, struct acpi_device, wakeup_list);
 
 		if (!dev->wakeup.flags.valid
-		    || !(dev->wakeup.state.enabled || dev->wakeup.prepare_count)
-		    || sleep_state > (u32) dev->wakeup.sleep_state)
+		    || sleep_state > (u32) dev->wakeup.sleep_state
+		    || !(device_may_wakeup(&dev->dev)
+		        || dev->wakeup.prepare_count))
 			continue;
 
-		if (dev->wakeup.state.enabled)
+		if (device_may_wakeup(&dev->dev))
 			acpi_enable_wakeup_device_power(dev, sleep_state);
 
 		/* The wake-up power should have been enabled already. */
@@ -63,14 +64,15 @@ void acpi_disable_wakeup_devices(u8 slee
 			container_of(node, struct acpi_device, wakeup_list);
 
 		if (!dev->wakeup.flags.valid
-		    || !(dev->wakeup.state.enabled || dev->wakeup.prepare_count)
-		    || (sleep_state > (u32) dev->wakeup.sleep_state))
+		    || sleep_state > (u32) dev->wakeup.sleep_state
+		    || !(device_may_wakeup(&dev->dev)
+		        || dev->wakeup.prepare_count))
 			continue;
 
 		acpi_gpe_wakeup(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
 				ACPI_GPE_DISABLE);
 
-		if (dev->wakeup.state.enabled)
+		if (device_may_wakeup(&dev->dev))
 			acpi_disable_wakeup_device_power(dev);
 	}
 }
@@ -84,8 +86,8 @@ int __init acpi_wakeup_device_init(void)
 		struct acpi_device *dev = container_of(node,
 						       struct acpi_device,
 						       wakeup_list);
-		if (dev->wakeup.flags.always_enabled)
-			dev->wakeup.state.enabled = 1;
+		if (device_can_wakeup(&dev->dev))
+			device_set_wakeup_enable(&dev->dev, true);
 	}
 	mutex_unlock(&acpi_device_lock);
 	return 0;
Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -426,7 +426,7 @@ static int acpi_button_add(struct acpi_d
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
 		device->wakeup.run_wake_count++;
-		device->wakeup.state.enabled = 1;
+		device_set_wakeup_enable(&device->dev, true);
 	}
 
 	printk(KERN_INFO PREFIX "%s [%s]\n", name, acpi_device_bid(device));
@@ -449,7 +449,7 @@ static int acpi_button_remove(struct acp
 		acpi_disable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
 		device->wakeup.run_wake_count--;
-		device->wakeup.state.enabled = 0;
+		device_set_wakeup_enable(&device->dev, false);
 	}
 
 	acpi_button_remove_fs(device);
Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -803,7 +803,7 @@ static void acpi_bus_set_run_wake_flags(
 	/* Power button, Lid switch always enable wakeup */
 	if (!acpi_match_device_ids(device, button_device_ids)) {
 		device->wakeup.flags.run_wake = 1;
-		device->wakeup.flags.always_enabled = 1;
+		device_set_wakeup_capable(&device->dev, true);
 		return;
 	}
 
Index: linux-2.6/drivers/acpi/proc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/proc.c
+++ linux-2.6/drivers/acpi/proc.c
@@ -311,7 +311,9 @@ acpi_system_wakeup_device_seq_show(struc
 			   dev->pnp.bus_id,
 			   (u32) dev->wakeup.sleep_state,
 			   dev->wakeup.flags.run_wake ? '*' : ' ',
-			   dev->wakeup.state.enabled ? "enabled" : "disabled");
+			   (device_may_wakeup(&dev->dev)
+			     || (ldev && device_may_wakeup(ldev))) ?
+			       "enabled" : "disabled");
 		if (ldev)
 			seq_printf(seq, "%s:%s",
 				   ldev->bus ? ldev->bus->name : "no-bus",
@@ -328,8 +330,10 @@ static void physical_device_enable_wakeu
 {
 	struct device *dev = acpi_get_physical_device(adev->handle);
 
-	if (dev && device_can_wakeup(dev))
-		device_set_wakeup_enable(dev, adev->wakeup.state.enabled);
+	if (dev && device_can_wakeup(dev)) {
+		bool enable = !device_may_wakeup(dev);
+		device_set_wakeup_enable(dev, enable);
+	}
 }
 
 static ssize_t
@@ -360,9 +364,12 @@ acpi_system_write_wakeup_device(struct f
 			continue;
 
 		if (!strncmp(dev->pnp.bus_id, str, 4)) {
-			dev->wakeup.state.enabled =
-			    dev->wakeup.state.enabled ? 0 : 1;
-			physical_device_enable_wakeup(dev);
+			if (device_can_wakeup(&dev->dev)) {
+				bool enable = !device_may_wakeup(&dev->dev);
+				device_set_wakeup_enable(&dev->dev, enable);
+			} else {
+				physical_device_enable_wakeup(dev);
+			}
 			break;
 		}
 	}

