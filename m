Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab1KAAr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:47:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934314Ab1KAArY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:47:24 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        David Woodhouse <dwmw2@infradead.org>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl for reading registers
Date: Tue,  1 Nov 2011 01:43:10 +0100
Message-Id: <1320108191-6647-8-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* When bq27x00_battery module is loaded it take control of bq27200 i2c battery chip and then it is not possible to use i2cget program from user space (returns -EBUSY)
* This patch adds new miscdevice for each battery which has ioctl BQ27X00_READ_REG for reading battery registers from user space

* ioctl cmd:
  #define BQ27X00_READ_REG _IO(MISC_MAJOR, 0)

* ioctl arg:
  struct bq27x00_reg_parms {
    int reg; /* battery register (in) */
    int single; /* 1 - 8bit register, 0 - 16bit register (in) */
    int ret; /* register status, negative indicate error (out) */
  };

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq27x00_battery.c       |  136 +++++++++++++++++++++++++++++++--
 include/linux/power/bq27x00_battery.h |   15 ++++
 2 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 63cfb5a..15ecd42 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -29,12 +29,15 @@
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/idr.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
+#include <asm/uaccess.h>
 
 #include <linux/power/bq27x00_battery.h>
 
@@ -89,8 +92,15 @@ struct bq27x00_reg_cache {
 	int flags;
 };
 
+struct bq27x00_reg_device {
+	struct miscdevice miscdev;
+	struct bq27x00_device_info *di;
+	struct list_head list;
+};
+
 struct bq27x00_device_info {
 	struct device 		*dev;
+	struct bq27x00_reg_device *regdev;
 	int			id;
 	enum bq27x00_chip	chip;
 
@@ -131,6 +141,13 @@ module_param(poll_interval, uint, 0644);
 MODULE_PARM_DESC(poll_interval, "battery poll interval in seconds - " \
 				"0 disables polling");
 
+/* If the system has several batteries we need a different name for each
+ * of them...
+ */
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_mutex);
+static LIST_HEAD(battery_list);
+
 /*
  * Common code for BQ27x00 devices
  */
@@ -568,6 +585,114 @@ static void bq27x00_external_power_changed(struct power_supply *psy)
 	schedule_delayed_work(&di->work, 0);
 }
 
+/* Code for register device access */
+
+static struct bq27x00_reg_device * bq27x00_battery_reg_find_device(int minor)
+{
+	struct bq27x00_reg_device *regdev;
+
+	list_for_each_entry(regdev, &battery_list, list)
+		if (regdev->miscdev.minor == minor)
+			return regdev;
+
+	return NULL;
+}
+
+static long bq27x00_battery_reg_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	int minor = iminor(filp->f_dentry->d_inode);
+	struct bq27x00_reg_parms param;
+	struct bq27x00_reg_device *regdev = bq27x00_battery_reg_find_device(minor);
+
+	if (!regdev)
+		return -ENXIO;
+
+	if (cmd != BQ27X00_READ_REG)
+		return -EINVAL;
+
+	ret = copy_from_user(&param, (void __user *)arg, sizeof(param));
+	if (ret != 0)
+		return -EACCES;
+
+	param.ret = bq27x00_read(regdev->di, param.reg, param.single);
+
+	ret = copy_to_user((void __user *)arg, &param, sizeof(param));
+	if (ret != 0)
+		return -EACCES;
+
+	return 0;
+}
+
+static int bq27x00_battery_reg_open(struct inode *inode, struct file *file)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -EPERM;
+
+	return 0;
+}
+
+static int bq27x00_battery_reg_release(struct inode *inode, struct file *file)
+{
+	module_put(THIS_MODULE);
+	return 0;
+}
+
+static struct file_operations bq27x00_reg_fileops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = bq27x00_battery_reg_ioctl,
+	.open = bq27x00_battery_reg_open,
+	.release = bq27x00_battery_reg_release,
+};
+
+static int bq27x00_battery_reg_init(struct bq27x00_device_info *di)
+{
+	struct bq27x00_reg_device *regdev;
+	int ret;
+
+	di->regdev = NULL;
+
+	regdev = kzalloc(sizeof *regdev, GFP_KERNEL);
+	if (!regdev)
+		return -ENOMEM;
+
+	regdev->miscdev.minor = MISC_DYNAMIC_MINOR;
+	regdev->miscdev.name = di->bat.name;
+	regdev->miscdev.fops = &bq27x00_reg_fileops;
+
+	ret = misc_register(&regdev->miscdev);
+	if (ret != 0) {
+		kfree(regdev);
+		return ret;
+	}
+
+	regdev->di = di;
+	di->regdev = regdev;
+
+	INIT_LIST_HEAD(&regdev->list);
+
+	mutex_lock(&battery_mutex);
+	list_add(&regdev->list, &battery_list);
+	mutex_unlock(&battery_mutex);
+
+	return 0;
+}
+
+static void bq27x00_battery_reg_exit(struct bq27x00_device_info *di)
+{
+	if (!di->regdev)
+		return;
+
+	misc_deregister(&di->regdev->miscdev);
+
+	mutex_lock(&battery_mutex);
+	list_del(&di->regdev->list);
+	mutex_unlock(&battery_mutex);
+
+	kfree(di->regdev);
+	di->regdev = NULL;
+}
+
 static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 {
 	int ret;
@@ -590,6 +715,7 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
 
 	bq27x00_update(di);
+	bq27x00_battery_reg_init(di);
 
 	return 0;
 }
@@ -598,6 +724,8 @@ static void bq27x00_powersupply_unregister(struct bq27x00_device_info *di)
 {
 	cancel_delayed_work_sync(&di->work);
 
+	bq27x00_battery_reg_exit(di);
+
 	power_supply_unregister(&di->bat);
 
 	mutex_destroy(&di->lock);
@@ -607,12 +735,6 @@ static void bq27x00_powersupply_unregister(struct bq27x00_device_info *di)
 /* i2c specific code */
 #ifdef CONFIG_BATTERY_BQ27X00_I2C
 
-/* If the system has several batteries we need a different name for each
- * of them...
- */
-static DEFINE_IDR(battery_id);
-static DEFINE_MUTEX(battery_mutex);
-
 static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 {
 	struct i2c_client *client = to_i2c_client(di->dev);
@@ -635,7 +757,9 @@ static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 	else
 		msg[1].len = 2;
 
+	mutex_lock(&battery_mutex);
 	ret = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
+	mutex_unlock(&battery_mutex);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/power/bq27x00_battery.h b/include/linux/power/bq27x00_battery.h
index a857f71..02c1c6e 100644
--- a/include/linux/power/bq27x00_battery.h
+++ b/include/linux/power/bq27x00_battery.h
@@ -16,4 +16,19 @@ struct bq27000_platform_data {
 	int (*read)(struct device *dev, unsigned int);
 };
 
+
+#define BQ27X00_READ_REG _IO(MISC_MAJOR, 0)
+
+/**
+ * struct bq27x00_reg_params - User space data for ioctl BQ27X00_READ_REG
+ * @reg: Battery register (in)
+ * @single: 1 - 8bit register, 0 - 16bit register (in)
+ * @ret: register status, negative indicate error (out)
+ */
+struct bq27x00_reg_parms {
+	int reg;
+	int single;
+	int ret;
+};
+
 #endif
-- 
1.7.5.4

