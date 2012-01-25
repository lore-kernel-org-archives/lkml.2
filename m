Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2AYG0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:26:12 -0500
Received: from mail2.nsc.com ([12.238.8.132]:59651 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755452Ab2AYG0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:26:10 -0500
X-WSS-ID: 0LYCCJI-0A-5UZ-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Richard Purdie" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 22:25:49 -0800
Subject: RE: [PATCH v2] backlight: new backlight driver for LP855x
 devices
Thread-Topic: [PATCH v2] backlight: new backlight driver for LP855x
 devices
Thread-Index: AczbKe6AqdDCFC9VR/mz1c7mUHrTGQAAAwqg
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3EE6@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 63017FFB1LS9911934-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* patch based on kernel 3.0.1

-----Original Message-----
From: Kim, Milo
Sent: Wednesday, January 25, 2012 3:24 PM
To: 'Andrew Morton'; 'linux-kernel@vger.kernel.org'
Cc: 'Richard Purdie'
Subject: [PATCH v2] backlight: new backlight driver for LP855x devices

This patch supports TI LP8550/LP8551/LP8852/LP8553/LP8556 backlight driver.

The brightness can be controlled by the I2C or PWM input.
The lp855x driver provides both modes.
For the PWM control, pwm-specific functions can be defined in the platform data.
And some information can be read via the sysfs(lp855x device attributes).

For the details, please refer to 'Documentation/backlight/lp855x-driver.txt'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |   81 +++++++
 drivers/video/backlight/Kconfig           |    7 +
 drivers/video/backlight/Makefile          |    1 +
 drivers/video/backlight/lp855x_bl.c       |  331 +++++++++++++++++++++++++++++
 include/linux/lp855x.h                    |  133 ++++++++++++
 5 files changed, 553 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/backlight/lp855x-driver.txt
 create mode 100644 drivers/video/backlight/lp855x_bl.c
 create mode 100644 include/linux/lp855x.h

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
new file mode 100644
index 0000000..321351e
--- /dev/null
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -0,0 +1,81 @@
+Kernel driver lp855x
+====================
+
+Backlight driver for LP855x ICs
+
+Supported chips:
+       Texas Instruments LP8550, LP8551, LP8552, LP8553 and LP8556
+
+Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+-----------
+
+* Brightness control
+
+Brightness can be controlled by the pwm input or the i2c command.
+The lp855x driver supports both cases.
+
+* Device attributes
+
+1) bl_ctl_mode
+Backlight control mode.
+Value : pwm based or register based
+
+2) chip_id
+The lp855x chip id.
+Value : lp8550/lp8551/lp8552/lp8553/lp8556
+
+Platform data for lp855x
+------------------------
+
+For supporting platform specific data, the lp855x platform data can be used.
+
+* name : Backlight driver name. If it is not defined, default name is set.
+* mode : Brightness control mode. PWM or register based.
+* device_control : Value of DEVICE CONTROL register.
+* initial_brightness : Initial value of backlight brightness.
+* max_brightness : Maximum value of backlight brightness.
+* pwm_data : Platform specific pwm generation functions.
+            Only valid when brightness is pwm input mode.
+            Functions should be implemented by PWM driver.
+            - pwm_set_intensity() : set duty of PWM
+            - pwm_get_intensity() : get current duty of PWM
+* load_new_rom_data :
+       0 : use default configuration data
+       1 : update values of eeprom or eprom registers on loading driver
+* size_program : Total size of lp855x_rom_data.
+* rom_data : List of new eeprom/eprom registers.
+
+example 1) lp8552 platform data : i2c register mode with new eeprom data
+
+#define EEPROM_A5_ADDR 0xA5
+#define EEPROM_A5_VAL  0x4f    /* EN_VSYNC=0 */
+
+static struct lp855x_rom_data lp8552_eeprom_arr[] = {
+       {EEPROM_A5_ADDR, EEPROM_A5_VAL},
+};
+
+static struct lp855x_platform_data lp8552_pdata = {
+       .name = "lcd-bl",
+       .mode = REGISTER_BASED,
+       .device_control = I2C_CONFIG(LP8552),
+       .initial_brightness = INITIAL_BRT,
+       .max_brightness = MAX_BRT,
+       .load_new_rom_data = 1,
+       .size_program = ARRAY_SIZE(lp8552_eeprom_arr),
+       .rom_data = lp8552_eeprom_arr,
+};
+
+example 2) lp8556 platform data : pwm input mode with default rom data
+
+static struct lp855x_platform_data lp8556_pdata = {
+       .mode = PWM_BASED,
+       .device_control = PWM_CONFIG(LP8556),
+       .initial_brightness = INITIAL_BRT,
+       .max_brightness = MAX_BRT,
+       .pwm_data = {
+                    .pwm_set_intensity = platform_pwm_set_intensity,
+                    .pwm_get_intensity = platform_pwm_get_intensity,
+                    },
+};
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 2d93c8d..995088a 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -327,6 +327,13 @@ config BACKLIGHT_PCF50633
          If you have a backlight driven by a NXP PCF50633 MFD, say Y here to
          enable its driver.

+config BACKLIGHT_LP855X
+       tristate "Backlight driver for TI LP855X"
+       depends on BACKLIGHT_CLASS_DEVICE && I2C
+       help
+         This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
+         backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE

 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index ee72adb..27788c9 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -37,4 +37,5 @@ obj-$(CONFIG_BACKLIGHT_ADP8860)       += adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)        += adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)       += pcf50633-backlight.o
+obj-$(CONFIG_BACKLIGHT_LP855X) += lp855x_bl.o

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
new file mode 100644
index 0000000..d2d072d
--- /dev/null
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -0,0 +1,331 @@
+/*
+ * TI LP855x Backlight Driver
+ *
+ *                     Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/lp855x.h>
+
+/* Registers */
+#define BRIGHTNESS_CTRL                (0x00)
+#define DEVICE_CTRL            (0x01)
+
+#define BUF_SIZE               (20)
+#define DEFAULT_BL_NAME                "lcd-backlight"
+
+struct lp855x {
+       const char *chipid;
+       struct i2c_client *client;
+       struct backlight_device *bl;
+       struct device *dev;
+       struct mutex xfer_lock;
+       struct lp855x_platform_data *pdata;
+};
+
+static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
+{
+       int ret;
+
+       mutex_lock(&lp->xfer_lock);
+       ret = i2c_smbus_read_byte_data(lp->client, reg);
+       if (ret < 0) {
+               dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
+               return ret;
+       }
+       mutex_unlock(&lp->xfer_lock);
+
+       *data = (u8)ret;
+       return 0;
+}
+
+static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
+{
+       int ret;
+
+       mutex_lock(&lp->xfer_lock);
+       ret = i2c_smbus_write_byte_data(lp->client, reg, data);
+       mutex_unlock(&lp->xfer_lock);
+
+       return ret;
+}
+
+static int lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
+{
+       const char *id = lp->chipid;
+       u8 start, end;
+
+       if (strstr(id, "lp8550") || strstr(id, "lp8551")
+           || strstr(id, "lp8552") || strstr(id, "lp8553")) {
+               start = EEPROM_START;
+               end = EEPROM_END;
+       } else if (strstr(id, "lp8556")) {
+               start = EPROM_START;
+               end = EPROM_END;
+       }
+
+       return (addr >= start && addr <= end) ? 1 : 0;
+}
+
+static int lp855x_init_registers(struct lp855x *lp)
+{
+       u8 val, addr;
+       int i, ret;
+       struct lp855x_platform_data *pd = lp->pdata;
+
+       val = pd->initial_brightness;
+       ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+       if (ret)
+               return ret;
+
+       val = pd->device_control;
+       ret = lp855x_write_byte(lp, DEVICE_CTRL, val);
+       if (ret)
+               return ret;
+
+       if (pd->load_new_rom_data && pd->size_program) {
+               for (i = 0; i < pd->size_program; i++) {
+                       addr = pd->rom_data[i].addr;
+                       val = pd->rom_data[i].val;
+                       if (!lp855x_is_valid_rom_area(lp, addr))
+                               continue;
+
+                       ret = lp855x_write_byte(lp, addr, val);
+                       if (ret)
+                               return ret;
+               }
+       }
+
+       return ret;
+}
+
+static int lp855x_bl_update_status(struct backlight_device *bl)
+{
+       struct lp855x *lp = bl_get_data(bl);
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+
+       if (bl->props.state & BL_CORE_SUSPENDED)
+               bl->props.brightness = 0;
+
+       if (mode == PWM_BASED) {
+               struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
+               int br = bl->props.brightness;
+               int max_br = bl->props.max_brightness;
+
+               if (pd->pwm_set_intensity)
+                       pd->pwm_set_intensity(br, max_br);
+
+       } else if (mode == REGISTER_BASED) {
+               u8 val = bl->props.brightness;
+               lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+       }
+
+       return (bl->props.brightness);
+}
+
+static int lp855x_bl_get_brightness(struct backlight_device *bl)
+{
+       struct lp855x *lp = bl_get_data(bl);
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+
+       if (mode == PWM_BASED) {
+               struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
+               int max_br = bl->props.max_brightness;
+
+               if (pd->pwm_get_intensity)
+                       bl->props.brightness = pd->pwm_get_intensity(max_br);
+
+       } else if (mode == REGISTER_BASED) {
+               u8 val = 0;
+
+               lp855x_read_byte(lp, BRIGHTNESS_CTRL, &val);
+               bl->props.brightness = val;
+       }
+
+       return (bl->props.brightness);
+}
+
+static const struct backlight_ops lp855x_bl_ops = {
+       .options = BL_CORE_SUSPENDRESUME,
+       .update_status = lp855x_bl_update_status,
+       .get_brightness = lp855x_bl_get_brightness,
+};
+
+static int lp855x_backlight_register(struct lp855x *lp)
+{
+       struct backlight_device *bl;
+       struct backlight_properties props;
+       struct lp855x_platform_data *pdata = lp->pdata;
+       char *name = pdata->name ? : DEFAULT_BL_NAME;
+
+       props.type = BACKLIGHT_PLATFORM;
+       props.brightness = pdata->initial_brightness;
+       props.max_brightness =
+               (pdata->max_brightness < pdata->initial_brightness) ?
+               255 : pdata->max_brightness;
+
+       bl = backlight_device_register(name, lp->dev, lp,
+                                      &lp855x_bl_ops, &props);
+       if (IS_ERR(bl))
+               return PTR_ERR(bl);
+
+       lp->bl = bl;
+
+       return 0;
+}
+
+static void lp855x_backlight_unregister(struct lp855x *lp)
+{
+       if (lp->bl)
+               backlight_device_unregister(lp->bl);
+}
+
+static ssize_t lp855x_get_chip_id(struct device *dev,
+                               struct device_attribute *attr, char *buf)
+{
+       struct lp855x *lp = dev_get_drvdata(dev);
+       return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipid);
+}
+
+static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
+                                    struct device_attribute *attr, char *buf)
+{
+       struct lp855x *lp = dev_get_drvdata(dev);
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+       char *strmode = NULL;
+
+       if (mode == PWM_BASED)
+               strmode = "pwm based";
+       else if (mode == REGISTER_BASED)
+               strmode = "register based";
+
+       return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+}
+
+static DEVICE_ATTR(chip_id, S_IRUGO, lp855x_get_chip_id, NULL);
+static DEVICE_ATTR(bl_ctl_mode, S_IRUGO, lp855x_get_bl_ctl_mode, NULL);
+
+static struct attribute *lp855x_attributes[] = {
+       &dev_attr_chip_id.attr,
+       &dev_attr_bl_ctl_mode.attr,
+       NULL,
+};
+
+static const struct attribute_group lp855x_attr_group = {
+       .attrs = lp855x_attributes,
+};
+
+static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+       struct lp855x *lp;
+       struct lp855x_platform_data *pdata = cl->dev.platform_data;
+       int ret;
+
+       if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
+               goto err_io;
+
+       lp = kzalloc(sizeof(struct lp855x), GFP_KERNEL);
+       if (!lp)
+               goto err_mem;
+
+       lp->client = cl;
+       lp->dev = &cl->dev;
+       lp->pdata = pdata;
+       lp->chipid = id->name;
+       i2c_set_clientdata(cl, lp);
+
+       mutex_init(&lp->xfer_lock);
+
+       ret = lp855x_init_registers(lp);
+       if (ret)
+               goto err_i2c;
+
+       ret = lp855x_backlight_register(lp);
+       if (ret)
+               goto err_bldev;
+
+       ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
+       if (ret)
+               goto err_sysfs;
+
+       backlight_update_status(lp->bl);
+       return ret;
+
+err_io:
+       return -EIO;
+err_mem:
+       return -ENOMEM;
+err_i2c:
+       dev_err(lp->dev, "i2c communication err: %d", ret);
+       kfree(lp);
+       return ret;
+err_bldev:
+       dev_err(lp->dev, "can not register backlight device. err: %d\n", ret);
+       kfree(lp);
+       return ret;
+err_sysfs:
+       dev_err(lp->dev, "can not register sysfs. err: %d\n", ret);
+       lp855x_backlight_unregister(lp);
+       kfree(lp);
+       return ret;
+}
+
+static int __devexit lp855x_remove(struct i2c_client *cl)
+{
+       struct lp855x *lp = i2c_get_clientdata(cl);
+
+       lp->bl->props.brightness = 0;
+       backlight_update_status(lp->bl);
+       sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
+       lp855x_backlight_unregister(lp);
+       kfree(lp);
+
+       return 0;
+}
+
+static const struct i2c_device_id lp855x_ids[] = {
+       {"lp8550", LP8550},
+       {"lp8551", LP8551},
+       {"lp8552", LP8552},
+       {"lp8553", LP8553},
+       {"lp8556", LP8556},
+       {},
+};
+MODULE_DEVICE_TABLE(i2c, lp855x_ids);
+
+static struct i2c_driver lp855x_driver = {
+       .driver = {
+                  .name = "lp855x",
+                  },
+       .probe = lp855x_probe,
+       .remove = __devexit_p(lp855x_remove),
+       .id_table = lp855x_ids,
+};
+
+static int __init lp855x_init(void)
+{
+       return i2c_add_driver(&lp855x_driver);
+}
+
+static void __exit lp855x_exit(void)
+{
+       i2c_del_driver(&lp855x_driver);
+}
+
+module_init(lp855x_init);
+module_exit(lp855x_exit);
+
+MODULE_DESCRIPTION("Texas Instruments LP855x Backlight driver");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/lp855x.h b/include/linux/lp855x.h
new file mode 100644
index 0000000..dd46713
--- /dev/null
+++ b/include/linux/lp855x.h
@@ -0,0 +1,133 @@
+/*
+ * LP855x Backlight Driver
+ *
+ *                     Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LP855X_H
+#define _LP855X_H
+
+#define BL_CTL_SHFT    (0)
+#define BRT_MODE_SHFT  (1)
+#define BRT_MODE_MASK  (0x06)
+
+/* Enable backlight. Only valid when BRT_MODE=10(I2C only) */
+#define ENABLE_BL      (1)
+#define DISABLE_BL     (0)
+
+#define I2C_CONFIG(id) id ## _I2C_CONFIG
+#define PWM_CONFIG(id) id ## _PWM_CONFIG
+
+/* DEVICE CONTROL register - LP8550 */
+#define LP8550_PWM_CONFIG      (LP8550_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8550_I2C_CONFIG      ((ENABLE_BL << BL_CTL_SHFT) | \
+                               (LP8550_I2C_ONLY << BRT_MODE_SHFT))
+
+/* DEVICE CONTROL register - LP8551 */
+#define LP8551_PWM_CONFIG      LP8550_PWM_CONFIG
+#define LP8551_I2C_CONFIG      LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8552 */
+#define LP8552_PWM_CONFIG      LP8550_PWM_CONFIG
+#define LP8552_I2C_CONFIG      LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8553 */
+#define LP8553_PWM_CONFIG      LP8550_PWM_CONFIG
+#define LP8553_I2C_CONFIG      LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8556 */
+#define LP8556_PWM_CONFIG      (LP8556_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8556_COMB1_CONFIG    (LP8556_COMBINED1 << BRT_MODE_SHFT)
+#define LP8556_I2C_CONFIG      ((ENABLE_BL << BL_CTL_SHFT) | \
+                               (LP8556_I2C_ONLY << BRT_MODE_SHFT))
+#define LP8556_COMB2_CONFIG    (LP8556_COMBINED2 << BRT_MODE_SHFT)
+
+/* ROM area boundary */
+#define EEPROM_START   (0xA0)
+#define EEPROM_END     (0xA7)
+#define EPROM_START    (0xA0)
+#define EPROM_END      (0xAF)
+
+enum lp855x_chip_id {
+       LP8550,
+       LP8551,
+       LP8552,
+       LP8553,
+       LP8556,
+};
+
+enum lp855x_brightness_ctrl_mode {
+       PWM_BASED = 1,
+       REGISTER_BASED,
+};
+
+enum lp8550_brighntess_source {
+       LP8550_PWM_ONLY,
+       LP8550_I2C_ONLY = 2,
+};
+
+enum lp8551_brighntess_source {
+       LP8551_PWM_ONLY = LP8550_PWM_ONLY,
+       LP8551_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8552_brighntess_source {
+       LP8552_PWM_ONLY = LP8550_PWM_ONLY,
+       LP8552_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8553_brighntess_source {
+       LP8553_PWM_ONLY = LP8550_PWM_ONLY,
+       LP8553_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8556_brightness_source {
+       LP8556_PWM_ONLY,
+       LP8556_COMBINED1,       /* pwm + i2c before the shaper block */
+       LP8556_I2C_ONLY,
+       LP8556_COMBINED2,       /* pwm + i2c after the shaper block */
+};
+
+struct lp855x_pwm_data {
+       void (*pwm_set_intensity) (int brightness, int max_brightness);
+       int (*pwm_get_intensity) (int max_brightness);
+};
+
+struct lp855x_rom_data {
+       u8 addr;
+       u8 val;
+};
+
+/**
+ * struct lp855x_platform_data
+ * @name : Backlight driver name. If it is not defined, default name is set.
+ * @mode : brightness control by pwm or lp855x register
+ * @device_control : value of DEVICE CONTROL register
+ * @initial_brightness : initial value of backlight brightness
+ * @max_brightness : maximum value of backlight brightness
+ * @pwm_data : platform specific pwm generation functions.
+               Only valid when mode is PWM_BASED.
+ * @load_new_rom_data :
+       0 : use default configuration data
+       1 : update values of eeprom or eprom registers on loading driver
+ * @size_program : total size of lp855x_rom_data
+ * @rom_data : list of new eeprom/eprom registers
+ */
+struct lp855x_platform_data {
+       char *name;
+       enum lp855x_brightness_ctrl_mode mode;
+       u8 device_control;
+       int initial_brightness;
+       int max_brightness;
+       struct lp855x_pwm_data pwm_data;
+       u8 load_new_rom_data;
+       int size_program;
+       struct lp855x_rom_data *rom_data;
+};
+
+#endif
--
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated

