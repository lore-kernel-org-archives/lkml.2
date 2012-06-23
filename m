Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2FWVSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab2FWVRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 6/21] ACPI: Use struct dev_pm_ops for power management in processor driver
Date: Sat, 23 Jun 2012 23:11:55 +0200
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
Message-Id: <201206232311.55588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI processor driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/processor_driver.c |    6 ++++--
 drivers/acpi/processor_idle.c   |    4 ++--
 include/acpi/processor.h        |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

Index: linux/drivers/acpi/processor_driver.c
===================================================================
--- linux.orig/drivers/acpi/processor_driver.c
+++ linux/drivers/acpi/processor_driver.c
@@ -93,6 +93,9 @@ static const struct acpi_device_id proce
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
 
+static SIMPLE_DEV_PM_OPS(acpi_processor_pm,
+			 acpi_processor_suspend, acpi_processor_resume);
+
 static struct acpi_driver acpi_processor_driver = {
 	.name = "processor",
 	.class = ACPI_PROCESSOR_CLASS,
@@ -100,10 +103,9 @@ static struct acpi_driver acpi_processor
 	.ops = {
 		.add = acpi_processor_add,
 		.remove = acpi_processor_remove,
-		.suspend = acpi_processor_suspend,
-		.resume = acpi_processor_resume,
 		.notify = acpi_processor_notify,
 		},
+	.drv.pm = &acpi_processor_pm,
 };
 
 #define INSTALL_NOTIFY_HANDLER		1
Index: linux/include/acpi/processor.h
===================================================================
--- linux.orig/include/acpi/processor.h
+++ linux/include/acpi/processor.h
@@ -334,8 +334,8 @@ int acpi_processor_cst_has_changed(struc
 int acpi_processor_hotplug(struct acpi_processor *pr);
 int acpi_processor_power_exit(struct acpi_processor *pr,
 			      struct acpi_device *device);
-int acpi_processor_suspend(struct acpi_device * device);
-int acpi_processor_resume(struct acpi_device * device);
+int acpi_processor_suspend(struct device *dev);
+int acpi_processor_resume(struct device *dev);
 extern struct cpuidle_driver acpi_idle_driver;
 
 /* in processor_thermal.c */
Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -241,7 +241,7 @@ static void acpi_idle_bm_rld_restore(voi
 		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_RLD, saved_bm_rld);
 }
 
-int acpi_processor_suspend(struct acpi_device * device)
+int acpi_processor_suspend(struct device *dev)
 {
 	if (acpi_idle_suspend == 1)
 		return 0;
@@ -251,7 +251,7 @@ int acpi_processor_suspend(struct acpi_d
 	return 0;
 }
 
-int acpi_processor_resume(struct acpi_device * device)
+int acpi_processor_resume(struct device *dev)
 {
 	if (acpi_idle_suspend == 0)
 		return 0;

