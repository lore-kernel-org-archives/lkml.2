Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0JVMAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:00:37 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:30016 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0JVL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:49 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] hwmon: lis3: pm_runtime support
Date: Fri, 22 Oct 2010 14:57:23 +0300
Message-Id: <1287748654-2626-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pm_runtime support to lis3 core driver.
Add pm_runtime support to lis3 i2c driver.

spi and hp_accel drivers are not yet supported. Old always
on functionality remains for those.

For sysfs there is 5 second delay before turning off the
chip to avoid long ramp up delay.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c     |   60 +++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/lis3lv02d.h     |    1 +
 drivers/hwmon/lis3lv02d_i2c.c |   54 ++++++++++++++++++++++++++++---------
 3 files changed, 102 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index fc591ae..412ddc3 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -34,6 +34,7 @@
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
+#include <linux/pm_runtime.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
 
@@ -43,6 +44,9 @@
 #define MDPS_POLL_INTERVAL 50
 #define MDPS_POLL_MIN	   0
 #define MDPS_POLL_MAX	   2000
+
+#define LIS3_SYSFS_POWERDOWN_DELAY 5000 /* In milliseconds */
+
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
  * because they are generated even if the data do not change. So it's better
@@ -262,6 +266,18 @@ static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
 	mutex_unlock(&lis3_dev.mutex);
 }
 
+static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
+{
+	if (lis3_dev.pm_dev)
+		pm_runtime_get_sync(lis3_dev.pm_dev);
+}
+
+static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
+{
+	if (lis3_dev.pm_dev)
+		pm_runtime_put(lis3_dev.pm_dev);
+}
+
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
 	if (!test_bit(0, &lis3_dev.misc_opened))
@@ -356,6 +372,9 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
+	if (lis3_dev.pm_dev)
+		pm_runtime_get_sync(lis3_dev.pm_dev);
+
 	atomic_set(&lis3_dev.count, 0);
 	return 0;
 }
@@ -364,6 +383,8 @@ static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 {
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
+	if (lis3_dev.pm_dev)
+		pm_runtime_put(lis3_dev.pm_dev);
 	return 0;
 }
 
@@ -460,6 +481,8 @@ int lis3lv02d_joystick_enable(void)
 		return -ENOMEM;
 
 	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
+	lis3_dev.idev->open = lis3lv02d_joystick_open;
+	lis3_dev.idev->close = lis3lv02d_joystick_close;
 	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
 	lis3_dev.idev->poll_interval_min = MDPS_POLL_MIN;
 	lis3_dev.idev->poll_interval_max = MDPS_POLL_MAX;
@@ -512,12 +535,30 @@ void lis3lv02d_joystick_disable(void)
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
 /* Sysfs stuff */
+static void lis3lv02d_sysfs_poweron(struct lis3lv02d *lis3)
+{
+	/*
+	 * SYSFS functions are fast visitors so put-call
+	 * immediately after the get-call. However, keep
+	 * chip running for a while and schedule delayed
+	 * suspend. This way periodic sysfs calls doesn't
+	 * suffer from relatively long power up time.
+	 */
+
+	if (lis3->pm_dev) {
+		pm_runtime_get_sync(lis3->pm_dev);
+		pm_runtime_put_noidle(lis3->pm_dev);
+		pm_schedule_suspend(lis3->pm_dev, LIS3_SYSFS_POWERDOWN_DELAY);
+	}
+}
+
 static ssize_t lis3lv02d_selftest_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	int result;
 	s16 values[3];
 
+	lis3lv02d_sysfs_poweron(&lis3_dev);
 	result = lis3lv02d_selftest(&lis3_dev, values);
 	return sprintf(buf, "%s %d %d %d\n", result == 0 ? "OK" : "FAIL",
 		values[0], values[1], values[2]);
@@ -528,6 +569,7 @@ static ssize_t lis3lv02d_position_show(struct device *dev,
 {
 	int x, y, z;
 
+	lis3lv02d_sysfs_poweron(&lis3_dev);
 	mutex_lock(&lis3_dev.mutex);
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
 	mutex_unlock(&lis3_dev.mutex);
@@ -537,6 +579,7 @@ static ssize_t lis3lv02d_position_show(struct device *dev,
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
+	lis3lv02d_sysfs_poweron(&lis3_dev);
 	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
 }
 
@@ -549,6 +592,7 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
 	if (strict_strtoul(buf, 0, &rate))
 		return -EINVAL;
 
+	lis3lv02d_sysfs_poweron(&lis3_dev);
 	if (lis3lv02d_set_odr(rate))
 		return -EINVAL;
 
@@ -585,6 +629,17 @@ int lis3lv02d_remove_fs(struct lis3lv02d *lis3)
 {
 	sysfs_remove_group(&lis3->pdev->dev.kobj, &lis3lv02d_attribute_group);
 	platform_device_unregister(lis3->pdev);
+	if (lis3->pm_dev) {
+		/* Barrier after the sysfs remove */
+		pm_runtime_barrier(lis3->pm_dev);
+
+		/* SYSFS may have left chip running. Turn off if necessary */
+		if (!pm_runtime_suspended(lis3->pm_dev))
+			lis3lv02d_poweroff(&lis3_dev);
+
+		pm_runtime_disable(lis3->pm_dev);
+		pm_runtime_set_suspended(lis3->pm_dev);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
@@ -685,6 +740,11 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	lis3lv02d_add_fs(dev);
 	lis3lv02d_poweron(dev);
 
+	if (dev->pm_dev) {
+		pm_runtime_set_active(dev->pm_dev);
+		pm_runtime_enable(dev->pm_dev);
+	}
+
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 8540913..3e8a208 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -214,6 +214,7 @@ struct axis_conversion {
 
 struct lis3lv02d {
 	void			*bus_priv; /* used by the bus layer only */
+	struct device		*pm_dev; /* for pm_runtime purposes */
 	int (*init) (struct lis3lv02d *lis3);
 	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
 	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
index 8e5933b..6e965d7 100644
--- a/drivers/hwmon/lis3lv02d_i2c.c
+++ b/drivers/hwmon/lis3lv02d_i2c.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
+#include <linux/pm_runtime.h>
 #include "lis3lv02d.h"
 
 #define DRV_NAME 	"lis3lv02d_i2c"
@@ -95,6 +96,7 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 	lis3_dev.write	  = lis3_i2c_write;
 	lis3_dev.irq	  = client->irq;
 	lis3_dev.ac	  = lis3lv02d_axis_map;
+	lis3_dev.pm_dev	  = &client->dev;
 
 	i2c_set_clientdata(client, &lis3_dev);
 	ret = lis3lv02d_init_device(&lis3_dev);
@@ -104,21 +106,20 @@ fail:
 
 static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
 {
-	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
 
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
 
 	lis3lv02d_joystick_disable();
-	lis3lv02d_poweroff(lis3);
 
 	return lis3lv02d_remove_fs(&lis3_dev);
 }
 
 #ifdef CONFIG_PM
-static int lis3lv02d_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+static int lis3lv02d_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
 	if (!lis3->pdata || !lis3->pdata->wakeup_flags)
@@ -126,18 +127,21 @@ static int lis3lv02d_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
 	return 0;
 }
 
-static int lis3lv02d_i2c_resume(struct i2c_client *client)
+static int lis3lv02d_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	if (!lis3->pdata || !lis3->pdata->wakeup_flags)
+	/*
+	 * pm_runtime documentation says that devices should always
+	 * be powered on at resume. Pm_runtime turns them off after system
+	 * wide resume is complete.
+	 */
+	if (!lis3->pdata || !lis3->pdata->wakeup_flags ||
+		pm_runtime_suspended(dev))
 		lis3lv02d_poweron(lis3);
-	return 0;
-}
 
-static void lis3lv02d_i2c_shutdown(struct i2c_client *client)
-{
-	lis3lv02d_i2c_suspend(client, PMSG_SUSPEND);
+	return 0;
 }
 #else
 #define lis3lv02d_i2c_suspend	NULL
@@ -145,6 +149,24 @@ static void lis3lv02d_i2c_shutdown(struct i2c_client *client)
 #define lis3lv02d_i2c_shutdown	NULL
 #endif
 
+static int lis3_i2c_runtime_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
+
+	lis3lv02d_poweroff(lis3);
+	return 0;
+}
+
+static int lis3_i2c_runtime_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
+
+	lis3lv02d_poweron(lis3);
+	return 0;
+}
+
 static const struct i2c_device_id lis3lv02d_id[] = {
 	{"lis3lv02d", 0 },
 	{}
@@ -152,14 +174,20 @@ static const struct i2c_device_id lis3lv02d_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, lis3lv02d_id);
 
+static const struct dev_pm_ops lis3_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(lis3lv02d_i2c_suspend,
+				lis3lv02d_i2c_resume)
+	SET_RUNTIME_PM_OPS(lis3_i2c_runtime_suspend,
+			   lis3_i2c_runtime_resume,
+			   NULL)
+};
+
 static struct i2c_driver lis3lv02d_i2c_driver = {
 	.driver	 = {
 		.name   = DRV_NAME,
 		.owner  = THIS_MODULE,
+		.pm     = &lis3_pm_ops,
 	},
-	.suspend = lis3lv02d_i2c_suspend,
-	.shutdown = lis3lv02d_i2c_shutdown,
-	.resume = lis3lv02d_i2c_resume,
 	.probe	= lis3lv02d_i2c_probe,
 	.remove	= __devexit_p(lis3lv02d_i2c_remove),
 	.id_table = lis3lv02d_id,
-- 
1.6.0.4

