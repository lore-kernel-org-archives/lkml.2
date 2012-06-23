Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2FWVTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:19:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36995 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2FWVSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:18:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 19/21] ACPI / PM: Do not execute legacy driver PM callbacks
Date: Sat, 23 Jun 2012 23:20:28 +0200
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
Message-Id: <201206232320.29124.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since all ACPI drivers in the tree should have been switched
to power management handling based on struct dev_pm_ops,
modify the ACPI bus type driver so that is doesn't execute
legacy driver power management callbacks from the functions
pointed to by the members of the acpi_bus_pm structure.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/scan.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -290,51 +290,45 @@ static void acpi_device_release(struct d
 	kfree(acpi_dev);
 }
 
-#define ACPI_DEV_PM_CALLBACK(dev, callback, legacy_cb)		\
+#define ACPI_DEV_PM_CALLBACK(dev, callback)		\
 ({								\
-	struct acpi_device *__acpi_dev = to_acpi_device(dev);	\
-	struct acpi_driver *__acpi_drv = __acpi_dev->driver;	\
 	struct device_driver *__drv = dev->driver;		\
-	int __ret;						\
+	int __ret = 0;						\
 								\
-	if (__acpi_drv && __acpi_drv->ops.legacy_cb)		\
-		__ret = __acpi_drv->ops.legacy_cb(__acpi_dev);	\
-	else if (__drv && __drv->pm && __drv->pm->callback)	\
+	if (__drv && __drv->pm && __drv->pm->callback)		\
 		__ret = __drv->pm->callback(dev);		\
-	else							\
-		__ret = 0;					\
 								\
 	__ret;							\
 })
 
 static int acpi_pm_suspend(struct device *dev)
 {
-	return ACPI_DEV_PM_CALLBACK(dev, suspend, suspend);
+	return ACPI_DEV_PM_CALLBACK(dev, suspend);
 }
 
 static int acpi_pm_resume(struct device *dev)
 {
-	return ACPI_DEV_PM_CALLBACK(dev, resume, resume);
+	return ACPI_DEV_PM_CALLBACK(dev, resume);
 }
 
 static int acpi_pm_freeze(struct device *dev)
 {
-	return ACPI_DEV_PM_CALLBACK(dev, freeze, suspend);
+	return ACPI_DEV_PM_CALLBACK(dev, freeze);
 }
 
 static int acpi_pm_thaw(struct device *dev)
 {
-	return ACPI_DEV_PM_CALLBACK(dev, thaw, resume);
+	return ACPI_DEV_PM_CALLBACK(dev, thaw);
 }
 
 static int acpi_pm_poweroff(struct device *dev)
 {
-	return ACPI_DEV_PM_CALLBACK(dev, poweroff, suspend);
+	return ACPI_DEV_PM_CALLBACK(dev, poweroff);
 }
 
 static int acpi_pm_restore(struct device *dev)
 {
-	return ACPI_DEV_PM_CALLBACK(dev, restore, resume);
+	return ACPI_DEV_PM_CALLBACK(dev, restore);
 }
 
 static const struct dev_pm_ops acpi_bus_pm = {

