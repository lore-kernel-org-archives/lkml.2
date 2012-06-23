Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2FWVSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab2FWVRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 10/21] ACPI: Use struct dev_pm_ops for power management in the power driver
Date: Sat, 23 Jun 2012 23:14:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl>
In-Reply-To: <201206232306.06602.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232314.14303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI power resource driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/power.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -60,7 +60,6 @@ ACPI_MODULE_NAME("power");
 
 static int acpi_power_add(struct acpi_device *device);
 static int acpi_power_remove(struct acpi_device *device, int type);
-static int acpi_power_resume(struct acpi_device *device);
 
 static const struct acpi_device_id power_device_ids[] = {
 	{ACPI_POWER_HID, 0},
@@ -68,6 +67,9 @@ static const struct acpi_device_id power
 };
 MODULE_DEVICE_TABLE(acpi, power_device_ids);
 
+static int acpi_power_resume(struct device *dev);
+static SIMPLE_DEV_PM_OPS(acpi_power_pm, NULL, acpi_power_resume);
+
 static struct acpi_driver acpi_power_driver = {
 	.name = "power",
 	.class = ACPI_POWER_CLASS,
@@ -75,8 +77,8 @@ static struct acpi_driver acpi_power_dri
 	.ops = {
 		.add = acpi_power_add,
 		.remove = acpi_power_remove,
-		.resume = acpi_power_resume,
 		},
+	.drv.pm = &acpi_power_pm,
 };
 
 /*
@@ -771,14 +773,16 @@ static int acpi_power_remove(struct acpi
 	return 0;
 }
 
-static int acpi_power_resume(struct acpi_device *device)
+static int acpi_power_resume(struct device *dev)
 {
 	int result = 0, state;
+	struct acpi_device *device;
 	struct acpi_power_resource *resource;
 
-	if (!device)
+	if (!dev)
 		return -EINVAL;
 
+	device = to_acpi_device(dev);
 	resource = acpi_driver_data(device);
 	if (!resource)
 		return -EINVAL;

