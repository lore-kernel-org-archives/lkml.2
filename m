Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1BFNVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:21:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1BFNVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:21:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] ACPI / Button: Avoid disabling wakeup unnecessarily on remove
Date: Sun, 6 Feb 2011 14:21:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Ferenc =?utf-8?q?W=C3=A1gner?= <wferi@niif.hu>
References: <201102061418.56202.rjw@sisk.pl>
In-Reply-To: <201102061418.56202.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102061421.18978.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If a button device had already been enabled to wake up the system
from sleep states before the button driver saw it, the driver
shouldn't disable the device's wakeup capability when being detached
from the device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/button.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -98,6 +98,7 @@ struct acpi_button {
 	struct input_dev *input;
 	char phys[32];			/* for input device */
 	unsigned long pushed;
+	bool wakeup_enabled;
 };
 
 static const struct file_operations acpi_button_info_fops = {
@@ -430,7 +431,10 @@ static int acpi_button_add(struct acpi_d
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device_set_wakeup_enable(&device->dev, true);
+		if (!device_may_wakeup(&device->dev)) {
+			device_set_wakeup_enable(&device->dev, true);
+			button->wakeup_enabled = true;
+		}
 	}
 
 	printk(KERN_INFO PREFIX "%s [%s]\n", name, acpi_device_bid(device));
@@ -452,7 +456,8 @@ static int acpi_button_remove(struct acp
 	if (device->wakeup.flags.valid) {
 		acpi_disable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device_set_wakeup_enable(&device->dev, false);
+		if (button->wakeup_enabled)
+			device_set_wakeup_enable(&device->dev, false);
 	}
 
 	acpi_button_remove_fs(device);

