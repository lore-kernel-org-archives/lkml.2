Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2FWVSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:00 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab2FWVRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/21] ACPI / PM: Drop pm_message_t argument from device suspend callback
Date: Sat, 23 Jun 2012 23:08:05 +0200
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
Message-Id: <201206232308.05616.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

None of the drivers implementing the ACPI device suspend callback
uses the pm_message_t argument of it, so this argument may be dropped
entirely from that callback.  This will simplify switching the ACPI
bus type to PM handling based on struct dev_pm_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/fan.c                  |    4 ++--
 drivers/acpi/processor_idle.c       |    2 +-
 drivers/acpi/scan.c                 |    2 +-
 drivers/char/sonypi.c               |    2 +-
 drivers/platform/x86/hp_accel.c     |    2 +-
 drivers/platform/x86/sony-laptop.c  |    2 +-
 drivers/platform/x86/toshiba_acpi.c |    3 +--
 include/acpi/acpi_bus.h             |    3 +--
 include/acpi/processor.h            |    2 +-
 9 files changed, 10 insertions(+), 12 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -117,8 +117,7 @@ struct acpi_device;
 typedef int (*acpi_op_add) (struct acpi_device * device);
 typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
 typedef int (*acpi_op_start) (struct acpi_device * device);
-typedef int (*acpi_op_suspend) (struct acpi_device * device,
-				pm_message_t state);
+typedef int (*acpi_op_suspend) (struct acpi_device * device);
 typedef int (*acpi_op_resume) (struct acpi_device * device);
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
Index: linux/drivers/acpi/fan.c
===================================================================
--- linux.orig/drivers/acpi/fan.c
+++ linux/drivers/acpi/fan.c
@@ -46,7 +46,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_fan_add(struct acpi_device *device);
 static int acpi_fan_remove(struct acpi_device *device, int type);
-static int acpi_fan_suspend(struct acpi_device *device, pm_message_t state);
+static int acpi_fan_suspend(struct acpi_device *device);
 static int acpi_fan_resume(struct acpi_device *device);
 
 static const struct acpi_device_id fan_device_ids[] = {
@@ -183,7 +183,7 @@ static int acpi_fan_remove(struct acpi_d
 	return 0;
 }
 
-static int acpi_fan_suspend(struct acpi_device *device, pm_message_t state)
+static int acpi_fan_suspend(struct acpi_device *device)
 {
 	if (!device)
 		return -EINVAL;
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -296,7 +296,7 @@ static int acpi_device_suspend(struct de
 	struct acpi_driver *acpi_drv = acpi_dev->driver;
 
 	if (acpi_drv && acpi_drv->ops.suspend)
-		return acpi_drv->ops.suspend(acpi_dev, state);
+		return acpi_drv->ops.suspend(acpi_dev);
 	return 0;
 }
 
Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -241,7 +241,7 @@ static void acpi_idle_bm_rld_restore(voi
 		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_RLD, saved_bm_rld);
 }
 
-int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
+int acpi_processor_suspend(struct acpi_device * device)
 {
 	if (acpi_idle_suspend == 1)
 		return 0;
Index: linux/drivers/platform/x86/toshiba_acpi.c
===================================================================
--- linux.orig/drivers/platform/x86/toshiba_acpi.c
+++ linux/drivers/platform/x86/toshiba_acpi.c
@@ -1296,8 +1296,7 @@ static void toshiba_acpi_notify(struct a
 	}
 }
 
-static int toshiba_acpi_suspend(struct acpi_device *acpi_dev,
-				pm_message_t state)
+static int toshiba_acpi_suspend(struct acpi_device *acpi_dev)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
 	u32 result;
Index: linux/drivers/platform/x86/hp_accel.c
===================================================================
--- linux.orig/drivers/platform/x86/hp_accel.c
+++ linux/drivers/platform/x86/hp_accel.c
@@ -353,7 +353,7 @@ static int lis3lv02d_remove(struct acpi_
 
 
 #ifdef CONFIG_PM
-static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
+static int lis3lv02d_suspend(struct acpi_device *device)
 {
 	/* make sure the device is off when we suspend */
 	lis3lv02d_poweroff(&lis3_dev);
Index: linux/drivers/platform/x86/sony-laptop.c
===================================================================
--- linux.orig/drivers/platform/x86/sony-laptop.c
+++ linux/drivers/platform/x86/sony-laptop.c
@@ -4243,7 +4243,7 @@ err_free_resources:
 	return result;
 }
 
-static int sony_pic_suspend(struct acpi_device *device, pm_message_t state)
+static int sony_pic_suspend(struct acpi_device *device)
 {
 	if (sony_pic_disable(device))
 		return -ENXIO;
Index: linux/include/acpi/processor.h
===================================================================
--- linux.orig/include/acpi/processor.h
+++ linux/include/acpi/processor.h
@@ -334,7 +334,7 @@ int acpi_processor_cst_has_changed(struc
 int acpi_processor_hotplug(struct acpi_processor *pr);
 int acpi_processor_power_exit(struct acpi_processor *pr,
 			      struct acpi_device *device);
-int acpi_processor_suspend(struct acpi_device * device, pm_message_t state);
+int acpi_processor_suspend(struct acpi_device * device);
 int acpi_processor_resume(struct acpi_device * device);
 extern struct cpuidle_driver acpi_idle_driver;
 

