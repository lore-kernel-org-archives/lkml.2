Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2FWVR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:17:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab2FWVRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/21] ACPI / PM: Make acpi_bus_type use driver struct dev_pm_ops callbacks
Date: Sat, 23 Jun 2012 23:09:42 +0200
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
Message-Id: <201206232309.42554.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify acpi_bus_type so that it executes PM callbacks provided
by drivers through their struct dev_pm_ops objects, if present,
while still allowing the legacy ACPI PM callbacks to take precedence.
This will make it possible to convert ACPI drivers one by one to
handling PM through struct dev_pm_ops instead of the legacy way.

The code added by this change is temporary and will be removed
when all of the drivers in question have been switched over to
the PM handling based on struct dev_pm_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/scan.c |   60 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 13 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -290,27 +290,61 @@ static void acpi_device_release(struct d
 	kfree(acpi_dev);
 }
 
-static int acpi_device_suspend(struct device *dev)
+#define ACPI_DEV_PM_CALLBACK(dev, callback, legacy_cb)		\
+({								\
+	struct acpi_device *__acpi_dev = to_acpi_device(dev);	\
+	struct acpi_driver *__acpi_drv = __acpi_dev->driver;	\
+	struct device_driver *__drv = dev->driver;		\
+	int __ret;						\
+								\
+	if (__acpi_drv && __acpi_drv->ops.legacy_cb)		\
+		__ret = __acpi_drv->ops.legacy_cb(__acpi_dev);	\
+	else if (__drv && __drv->pm && __drv->pm->callback)	\
+		__ret = __drv->pm->callback(dev);		\
+	else							\
+		__ret = 0;					\
+								\
+	__ret;							\
+})
+
+static int acpi_pm_suspend(struct device *dev)
 {
-	struct acpi_device *acpi_dev = to_acpi_device(dev);
-	struct acpi_driver *acpi_drv = acpi_dev->driver;
+	return ACPI_DEV_PM_CALLBACK(dev, suspend, suspend);
+}
 
-	if (acpi_drv && acpi_drv->ops.suspend)
-		return acpi_drv->ops.suspend(acpi_dev);
-	return 0;
+static int acpi_pm_resume(struct device *dev)
+{
+	return ACPI_DEV_PM_CALLBACK(dev, resume, resume);
 }
 
-static int acpi_device_resume(struct device *dev)
+static int acpi_pm_freeze(struct device *dev)
 {
-	struct acpi_device *acpi_dev = to_acpi_device(dev);
-	struct acpi_driver *acpi_drv = acpi_dev->driver;
+	return ACPI_DEV_PM_CALLBACK(dev, freeze, suspend);
+}
 
-	if (acpi_drv && acpi_drv->ops.resume)
-		return acpi_drv->ops.resume(acpi_dev);
-	return 0;
+static int acpi_pm_thaw(struct device *dev)
+{
+	return ACPI_DEV_PM_CALLBACK(dev, thaw, resume);
+}
+
+static int acpi_pm_poweroff(struct device *dev)
+{
+	return ACPI_DEV_PM_CALLBACK(dev, poweroff, suspend);
+}
+
+static int acpi_pm_restore(struct device *dev)
+{
+	return ACPI_DEV_PM_CALLBACK(dev, restore, resume);
 }
 
-static SIMPLE_DEV_PM_OPS(acpi_bus_pm, acpi_device_suspend, acpi_device_resume);
+static const struct dev_pm_ops acpi_bus_pm = {
+	.suspend = acpi_pm_suspend,
+	.resume = acpi_pm_resume,
+	.freeze = acpi_pm_freeze,
+	.thaw = acpi_pm_thaw,
+	.poweroff = acpi_pm_poweroff,
+	.restore = acpi_pm_restore,
+};
 
 static int acpi_bus_match(struct device *dev, struct device_driver *drv)
 {

