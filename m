Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1AFWp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:45:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37866 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab1AFWnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:43:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/11] ACPI / PM: Do not enable multiple devices to wake up simultaneously
Date: Thu, 6 Jan 2011 23:33:30 +0100
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
Message-Id: <201101062333.30960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If a device is enabled to wake up the system from sleep states via
/proc/acpi/wakeup and there are other devices associated with the
same wakeup GPE, all of these devices are automatically enabled to
wake up the system.  This isn't correct, because the fact the GPE is
shared need not imply that wakeup power has to be enabled for all the
devices at the same time (i.e. it is possible that one device will
have its wakeup power enabled and it will wake up the system from a
sleep state if the shared wakeup GPE is enabled, while another device
having its wakeup power disabled will not wake up the system even
though the GPE is enabled).  Rework acpi_system_write_wakeup_device()
so that it only enables wakeup for one device at a time.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/proc.c |   26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

Index: linux-2.6/drivers/acpi/proc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/proc.c
+++ linux-2.6/drivers/acpi/proc.c
@@ -341,7 +341,6 @@ acpi_system_write_wakeup_device(struct f
 	char strbuf[5];
 	char str[5] = "";
 	unsigned int len = count;
-	struct acpi_device *found_dev = NULL;
 
 	if (len > 4)
 		len = 4;
@@ -363,33 +362,10 @@ acpi_system_write_wakeup_device(struct f
 		if (!strncmp(dev->pnp.bus_id, str, 4)) {
 			dev->wakeup.state.enabled =
 			    dev->wakeup.state.enabled ? 0 : 1;
-			found_dev = dev;
+			physical_device_enable_wakeup(dev);
 			break;
 		}
 	}
-	if (found_dev) {
-		physical_device_enable_wakeup(found_dev);
-		list_for_each_safe(node, next, &acpi_wakeup_device_list) {
-			struct acpi_device *dev = container_of(node,
-							       struct
-							       acpi_device,
-							       wakeup_list);
-
-			if ((dev != found_dev) &&
-			    (dev->wakeup.gpe_number ==
-			     found_dev->wakeup.gpe_number)
-			    && (dev->wakeup.gpe_device ==
-				found_dev->wakeup.gpe_device)) {
-				printk(KERN_WARNING
-				       "ACPI: '%s' and '%s' have the same GPE, "
-				       "can't disable/enable one separately\n",
-				       dev->pnp.bus_id, found_dev->pnp.bus_id);
-				dev->wakeup.state.enabled =
-				    found_dev->wakeup.state.enabled;
-				physical_device_enable_wakeup(dev);
-			}
-		}
-	}
 	mutex_unlock(&acpi_device_lock);
 	return count;
 }

