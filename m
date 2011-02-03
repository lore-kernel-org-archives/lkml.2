Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1BCTOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:14:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42512 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab1BCTOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:14:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Remove the wakeup.run_wake_count device field
Date: Thu, 3 Feb 2011 20:14:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102032014.18102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The wakeup.run_wake_count ACPI device field is only used by the PCI
runtime PM code to "protect" devices from being prepared for
generating wakeup signals more than once in a row.  However, it
really doesn't provide any protection, because (1) all of the
functions it is supposed to protect use their own reference counters
effectively ensuring that the device will be set up for generating
wakeup signals just once and (2) the PCI runtime PM code uses
wakeup.run_wake_count in a racy way, since nothing prevents
acpi_dev_run_wake() from being called concurrently from two different
threads for the same device.

Remove the wakeup.run_wake_count ACPI device field which is
unnecessary, confusing and used in a wrong way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/button.c   |    2 --
 drivers/acpi/scan.c     |    1 -
 drivers/pci/pci-acpi.c  |   16 ++++------------
 include/acpi/acpi_bus.h |    1 -
 4 files changed, 4 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -430,7 +430,6 @@ static int acpi_button_add(struct acpi_d
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device->wakeup.run_wake_count++;
 		device_set_wakeup_enable(&device->dev, true);
 	}
 
@@ -453,7 +452,6 @@ static int acpi_button_remove(struct acp
 	if (device->wakeup.flags.valid) {
 		acpi_disable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device->wakeup.run_wake_count--;
 		device_set_wakeup_enable(&device->dev, false);
 	}
 
Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -797,7 +797,6 @@ static void acpi_bus_set_run_wake_flags(
 	acpi_status status;
 	acpi_event_status event_status;
 
-	device->wakeup.run_wake_count = 0;
 	device->wakeup.flags.notifier_present = 0;
 
 	/* Power button, Lid switch always enable wakeup */
Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -293,19 +293,11 @@ static int acpi_dev_run_wake(struct devi
 	}
 
 	if (enable) {
-		if (!dev->wakeup.run_wake_count++) {
-			acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
-			acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
-		}
-	} else if (dev->wakeup.run_wake_count > 0) {
-		if (!--dev->wakeup.run_wake_count) {
-			acpi_disable_gpe(dev->wakeup.gpe_device,
-					 dev->wakeup.gpe_number);
-			acpi_disable_wakeup_device_power(dev);
-		}
+		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
+		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
 	} else {
-		error = -EALREADY;
+		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
+		acpi_disable_wakeup_device_power(dev);
 	}
 
 	return error;
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -250,7 +250,6 @@ struct acpi_device_wakeup {
 	struct acpi_handle_list resources;
 	struct acpi_device_wakeup_flags flags;
 	int prepare_count;
-	int run_wake_count;
 };
 
 /* Device */
