Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0FQPnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:43:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0FQPnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI / PM: Do not enable GPEs for system wakeup in advance
Date: Thu, 17 Jun 2010 17:40:57 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Michal Hocko <mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006171740.57315.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After commit 9630bdd9b15d2f489c646d8bc04b60e53eb5ec78
(ACPI: Use GPE reference counting to support shared GPEs) the wakeup
enable mask bits of GPEs are set as soon as the GPEs are enabled to
wake up the system.  Unfortunately, this leads to a regression
reported by Michal Hocko, where a system is woken up from ACPI S5 by
a device that is not supposed to do that, because the wakeup enable
mask bit of this device's GPE is always set when
acpi_enter_sleep_state() calls acpi_hw_enable_all_wakeup_gpes(),
although it should only be set if the device is supposed to wake up
the system from the target state.

To work around this issue, rework the ACPI power management code so
that GPEs are not enabled to wake up the system upfront, but only
during a system state transition when the target state of the system
is known.  [Of course, this means that the reference counting of
"wakeup" GPEs doesn't really make sense and it is sufficient to
set/unset the wakeup mask bits for them during system sleep
transitions.  This will allow us to simplify the GPE handling code
quite a bit, but that change is too intrusive for 2.6.35.]

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=15951

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Michal Hocko <mhocko@suse.cz>
---
Hi Len,

This is on top of the GPE fixes I send before that are in your tree.

Please apply.

Rafael
---
 drivers/acpi/button.c |    4 ++--
 drivers/acpi/wakeup.c |   20 +++++++-------------
 2 files changed, 9 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -425,7 +425,7 @@ static int acpi_button_add(struct acpi_d
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number,
-				ACPI_GPE_TYPE_WAKE_RUN);
+				ACPI_GPE_TYPE_RUNTIME);
 		device->wakeup.run_wake_count++;
 		device->wakeup.state.enabled = 1;
 	}
@@ -449,7 +449,7 @@ static int acpi_button_remove(struct acp
 	if (device->wakeup.flags.valid) {
 		acpi_disable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number,
-				ACPI_GPE_TYPE_WAKE_RUN);
+				ACPI_GPE_TYPE_RUNTIME);
 		device->wakeup.run_wake_count--;
 		device->wakeup.state.enabled = 0;
 	}
Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -64,16 +64,13 @@ void acpi_enable_wakeup_device(u8 sleep_
 		struct acpi_device *dev =
 			container_of(node, struct acpi_device, wakeup_list);
 
-		if (!dev->wakeup.flags.valid)
-			continue;
-
-		if ((!dev->wakeup.state.enabled && !dev->wakeup.prepare_count)
+		if (!dev->wakeup.flags.valid || !dev->wakeup.state.enabled
 		    || sleep_state > (u32) dev->wakeup.sleep_state)
 			continue;
 
 		/* The wake-up power should have been enabled already. */
-		acpi_set_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
-				ACPI_GPE_ENABLE);
+		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
+				ACPI_GPE_TYPE_WAKE);
 	}
 }
 
@@ -96,6 +93,8 @@ void acpi_disable_wakeup_device(u8 sleep
 		    || (sleep_state > (u32) dev->wakeup.sleep_state))
 			continue;
 
+		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
+				ACPI_GPE_TYPE_WAKE);
 		acpi_disable_wakeup_device_power(dev);
 	}
 }
@@ -109,13 +108,8 @@ int __init acpi_wakeup_device_init(void)
 		struct acpi_device *dev = container_of(node,
 						       struct acpi_device,
 						       wakeup_list);
-		/* In case user doesn't load button driver */
-		if (!dev->wakeup.flags.always_enabled ||
-		    dev->wakeup.state.enabled)
-			continue;
- 		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
- 				ACPI_GPE_TYPE_WAKE);
-		dev->wakeup.state.enabled = 1;
+		if (dev->wakeup.flags.always_enabled)
+			dev->wakeup.state.enabled = 1;
 	}
 	mutex_unlock(&acpi_device_lock);
 	return 0;
