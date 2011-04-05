Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1DEOs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:48:27 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50660 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1DEOrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:47 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: eric.piel@tremplin-utc.net, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        samu.p.onkalo@nokia.com, ilkka.koskinen@nokia.com
Subject: [RFC PATCHv2 3/5] hwmon: lis3: Change exported function to use given device
Date: Tue,  5 Apr 2011 17:45:12 +0300
Message-Id: <1302014714-7334-4-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change exported functions to use the device given as parameter
instead of the global one.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/misc/lis3lv02d/lis3lv02d.c     |    6 +++---
 drivers/misc/lis3lv02d/lis3lv02d.h     |    4 ++--
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    2 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    2 +-
 drivers/platform/x86/hp_accel.c        |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index cb32945..b548afc 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -609,7 +609,7 @@ static struct miscdevice lis3lv02d_misc_device = {
 	.fops    = &lis3lv02d_misc_fops,
 };
 
-int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(struct lis3lv02d *lis3)
 {
 	struct input_dev *input_dev;
 	int err;
@@ -667,7 +667,7 @@ int lis3lv02d_joystick_enable(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
-void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(struct lis3lv02d *lis3)
 {
 	if (lis3_dev.irq)
 		free_irq(lis3_dev.irq, &lis3_dev);
@@ -933,7 +933,7 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
 		pm_runtime_enable(lis3->pm_dev);
 	}
 
-	if (lis3lv02d_joystick_enable())
+	if (lis3lv02d_joystick_enable(lis3))
 		pr_err("joystick initialization failed\n");
 
 	/* passing in platform specific data is purely optional and only
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index a193958..49cb1f1 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -282,8 +282,8 @@ struct lis3lv02d {
 };
 
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
-int lis3lv02d_joystick_enable(void);
-void lis3lv02d_joystick_disable(void);
+int lis3lv02d_joystick_enable(struct lis3lv02d *lis3);
+void lis3lv02d_joystick_disable(struct lis3lv02d *lis3);
 void lis3lv02d_poweroff(struct lis3lv02d *lis3);
 void lis3lv02d_poweron(struct lis3lv02d *lis3);
 int lis3lv02d_remove_fs(struct lis3lv02d *lis3);
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index ea9159c..6cdc38f 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -182,7 +182,7 @@ static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
 
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_remove_fs(&lis3_dev);
 
 	if (lis3_dev.reg_ctrl)
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_spi.c b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
index c1f8a8f..b2c1be1 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -83,7 +83,7 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 static int __devexit lis302dl_spi_remove(struct spi_device *spi)
 {
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_poweroff(lis3);
 
 	return lis3lv02d_remove_fs(&lis3_dev);
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 1b52d00..2148d77 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -320,7 +320,7 @@ static int lis3lv02d_add(struct acpi_device *device)
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
-		lis3lv02d_joystick_disable();
+		lis3lv02d_joystick_disable(&lis3_dev);
 		lis3lv02d_poweroff(&lis3_dev);
 		flush_work(&hpled_led.work);
 		return ret;
@@ -334,7 +334,7 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
 	if (!device)
 		return -EINVAL;
 
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(&lis3_dev);
 	lis3lv02d_poweroff(&lis3_dev);
 
 	led_classdev_unregister(&hpled_led.led_classdev);
-- 
1.7.0.4

