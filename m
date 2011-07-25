Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1GYPZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:25:19 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:57025 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1GYPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4E2D8A6E.5020205@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:23:26 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/10] lis3: Change exported function to use given
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change exported functions to use the device given as parameter
instead of the global one.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/misc/lis3lv02d/lis3lv02d.c     |    6 +++---
 drivers/misc/lis3lv02d/lis3lv02d.h     |    4 ++--
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    2 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    2 +-
 drivers/platform/x86/hp_accel.c        |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 3ab8389..83ff7b4 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -629,7 +629,7 @@ static struct miscdevice lis3lv02d_misc_device = {
 	.fops    = &lis3lv02d_misc_fops,
 };
 
-int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(struct lis3lv02d *lis3)
 {
 	struct input_dev *input_dev;
 	int err;
@@ -687,7 +687,7 @@ int lis3lv02d_joystick_enable(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
 
-void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(struct lis3lv02d *lis3)
 {
 	if (lis3_dev.irq)
 		free_irq(lis3_dev.irq, &lis3_dev);
@@ -957,7 +957,7 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
 		pm_runtime_enable(lis3->pm_dev);
 	}
 
-	if (lis3lv02d_joystick_enable())
+	if (lis3lv02d_joystick_enable(lis3))
 		pr_err("joystick initialization failed\n");
 
 	/* passing in platform specific data is purely optional and only
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index 57c64bb..b94e723 100644
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
 int lis3lv02d_poweron(struct lis3lv02d *lis3);
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
index 89c5cb5..f93a47b 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -323,7 +323,7 @@ static int lis3lv02d_add(struct acpi_device *device)
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
-		lis3lv02d_joystick_disable();
+		lis3lv02d_joystick_disable(&lis3_dev);
 		lis3lv02d_poweroff(&lis3_dev);
 		flush_work(&hpled_led.work);
 		return ret;
@@ -337,7 +337,7 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
 	if (!device)
 		return -EINVAL;
 
-	lis3lv02d_joystick_disable();
+	lis3lv02d_joystick_disable(&lis3_dev);
 	lis3lv02d_poweroff(&lis3_dev);
 
 	led_classdev_unregister(&hpled_led.led_classdev);
-- 
1.7.6

