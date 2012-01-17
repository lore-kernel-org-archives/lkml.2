Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2AQEFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 23:05:04 -0500
Received: from mail2.nsc.com ([12.238.8.132]:53308 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758Ab2AQEFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 23:05:01 -0500
X-WSS-ID: 0LXXCOA-0A-83Q-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Kim, Milo" <Milo.Kim@nsc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rchard.purdie@linuxfoundation.org" 
	<rchard.purdie@linuxfoundation.org>
cc: "Kim, Milo" <Milo.Kim@nsc.com>
Date: Mon, 16 Jan 2012 20:04:44 -0800
Subject: RE: [PATCH] backlight: add new lp855x backlight driver
Thread-Topic: [PATCH] backlight: add new lp855x backlight driver
Thread-Index: Acy4HHSHjjUjBQ+BRW2kTQi2zvjY2AAAPxCwAAApbaAFCC21kAIjjqyQ
Message-ID: <B567DBAB974C0544994013492B949F8E3812BEF22E@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812710288@EXMAIL03.scwf.nsc.com>
 <B567DBAB974C0544994013492B949F8E381271028A@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630A2CEB1LS9726174-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(a) add MODULE_DEVICE_TABLE() for module lp855x
(b) For better readability, code of lp855x_platform_data can be shortened.
: lp->pdata => pdata

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 7a2d891..21fc267 100755
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -358,15 +358,16 @@ static int lp855x_backlight_register(struct lp855x *lp)
 {
        struct backlight_device *bl;
        struct backlight_properties props;
-       const char *name = lp->pdata->name;
+       struct lp855x_platform_data *pdata = lp->pdata;
+       const char *name = pdata->name;

        if (!name)
                return -ENODEV;

-       props.brightness = lp->pdata->initial_brightness;
+       props.brightness = pdata->initial_brightness;
        props.max_brightness =
-               (lp->pdata->max_brightness < lp->pdata->initial_brightness) ?
-               255 : lp->pdata->max_brightness;
+               (pdata->max_brightness < pdata->initial_brightness) ?
+               255 : pdata->max_brightness;

        bl = backlight_device_register(name, lp->dev, lp,
                                       &lp855x_bl_ops, &props);
@@ -445,7 +446,9 @@ static const struct i2c_device_id lp855x_ids[] = {
        {"lp8552", LP8552},
        {"lp8553", LP8553},
        {"lp8556", LP8556},
+       { }
 };
+MODULE_DEVICE_TABLE(i2c, lp855x_ids);

 static struct i2c_driver lp855x_driver = {
        .driver = {
--
1.7.4.1

-----Original Message-----
From: Kim, Milo
Sent: Friday, January 06, 2012 4:00 PM
To: 'linux-kernel@vger.kernel.org'; 'rchard.purdie@linuxfoundation.org'
Cc: 'milo.kim@ti.com'
Subject: [PATCH] backlight: add new lp855x backlight driver

This patch supports TI LP8550/LP8551/LP8852/LP8553/LP8556 backlight driver.

The brightness can be controlled by the I2C or PWM input.
The lp855x driver provides both modes.
For the PWM control, pwm-specific functions can be defined in the platform data.
And some information can be read via the debugfs.

For the details, please refer to 'Documentation/backlight/lp855x-driver.txt'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |   89 ++++++
 drivers/video/backlight/Kconfig           |    7 +
 drivers/video/backlight/Makefile          |    1 +
 drivers/video/backlight/lp855x_bl.c       |  474 +++++++++++++++++++++++++++++
 include/linux/lp855x.h                    |  133 ++++++++
 5 files changed, 704 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/backlight/lp855x-driver.txt
 create mode 100755 drivers/video/backlight/lp855x_bl.c
 create mode 100644 include/linux/lp855x.h

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
new file mode 100644
index 0000000..0879c1e
--- /dev/null
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -0,0 +1,89 @@
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
+* Debugfs nodes
+
+For debug information, 3 files are exported in the debugfs.
+
+1) bl_ctl_mode
+Backlight control mode.
+Value : pwm based or register based
+
+2) chip_id
+The lp855x chip id.
+Value : lp8550/lp8551/lp8552/lp8553/lp8556
+
+3) registers
+We can control the lp855x registers via the debugfs.
+Read/Write/Dump mode are supported.
+
+
+Platform data for lp855x
+------------------------
+
+For supporting platform specific data, the lp855x platform data can be used.
+
+* name : Backlight driver name.
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
+       .name = "lcd-backlight",
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
+       .name = "lcd-backlight",
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
index 278aeaa..4d98c2a 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -342,6 +342,13 @@ config BACKLIGHT_AAT2870
          If you have a AnalogicTech AAT2870 say Y to enable the
          backlight driver.

+config BACKLIGHT_LP855X
+       tristate "Backlight driver for Texas Instruments LP855X"
+       depends on BACKLIGHT_CLASS_DEVICE && I2C
+       help
+         This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
+         backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE

 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index fdd1fc4..91ae232 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -39,4 +39,5 @@ obj-$(CONFIG_BACKLIGHT_ADP8870)       += adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)       += pcf50633-backlight.o
 obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
+obj-$(CONFIG_BACKLIGHT_LP855X) += lp855x_bl.o

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
new file mode 100755
index 0000000..7a2d891
--- /dev/null
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -0,0 +1,474 @@
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
+#define BRIGHTNESS_CTRL        (0x00)
+#define DEVICE_CTRL    (0x01)
+
+#ifdef CONFIG_DEBUG_FS
+struct debug_dentry {
+       struct dentry *dir;
+       struct dentry *reg;
+       struct dentry *chip;
+       struct dentry *blmode;
+};
+#endif
+
+struct lp855x {
+       const char *chipid;
+       struct i2c_client *client;
+       struct backlight_device *bl;
+       struct device *dev;
+       struct mutex xfer_lock;
+       struct lp855x_platform_data *pdata;
+#ifdef CONFIG_DEBUG_FS
+       struct debug_dentry dd;
+#endif
+};
+
+static int lp855x_i2c_read(struct lp855x *lp, u8 reg, u8 *data, u8 len)
+{
+       s32 ret;
+
+       mutex_lock(&lp->xfer_lock);
+       ret = i2c_smbus_read_i2c_block_data(lp->client, reg, len, data);
+       mutex_unlock(&lp->xfer_lock);
+
+       return (ret != len) ? -EIO : 0;
+}
+
+static int lp855x_i2c_write(struct lp855x *lp, u8 reg, u8 *data, u8 len)
+{
+       s32 ret;
+
+       mutex_lock(&lp->xfer_lock);
+       ret = i2c_smbus_write_i2c_block_data(lp->client, reg, len, data);
+       mutex_unlock(&lp->xfer_lock);
+
+       return ret;
+}
+
+static inline int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
+{
+       return lp855x_i2c_read(lp, reg, data, 1);
+}
+
+static inline int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
+{
+       u8 written = data;
+       return lp855x_i2c_write(lp, reg, &written, 1);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int lp855x_dbg_open(struct inode *inode, struct file *file)
+{
+       file->private_data = inode->i_private;
+       return 0;
+}
+
+static ssize_t lp855x_help_register(struct file *file, char __user *userbuf,
+                                   size_t count, loff_t *ppos)
+{
+       char buf[320];
+       unsigned int len;
+       const char *help = "\n How to read/write LP855x registers\n\n \
+       (example) To read 0x00 register,\n \
+       echo 0x00 r > /sys/kernel/debug/lp855x/registers\n \
+       To write 0xff into 0x1 address,\n \
+       echo 0x00 0xff w > /sys/kernel/debug/lp855x/registers \n \
+       To dump values from 0x00 to 0x06 address,\n \
+       echo 0x00 0x06 d > /sys/kernel/debug/lp855x/registers\n";
+
+       len = snprintf(buf, sizeof(buf), "%s\n", help);
+       if (len > sizeof(buf))
+               len = sizeof(buf);
+
+       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+
+static char *lp855x_parse_register_cmd(const char *cmd, u8 *byte)
+{
+       char tmp[10];
+       char *blank;
+       unsigned long arg;
+
+       blank = strchr(cmd, ' ');
+       memset(tmp, 0x0, sizeof(tmp));
+       memcpy(tmp, cmd, blank - cmd);
+
+       if (strict_strtol(tmp, 16, &arg) < 0)
+               return NULL;
+
+       *byte = arg;
+       return blank;
+}
+
+static ssize_t lp855x_ctrl_register(struct file *file,
+                                   const char __user *userbuf, size_t count,
+                                   loff_t *ppos)
+{
+       char mode, buf[20];
+       char *pos, *pos2;
+       u8 i, arg1, arg2, val;
+       struct lp855x *lp = file->private_data;
+
+       if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+               return -EFAULT;
+
+       mode = buf[count - 2];
+       switch (mode) {
+       case 'r':
+               if (!lp855x_parse_register_cmd(buf, &arg1))
+                       return -EINVAL;
+
+               lp855x_read_byte(lp, arg1, &val);
+               dev_info(lp->dev, "Read [0x%.2x] = 0x%.2x\n", arg1, val);
+               break;
+       case 'w':
+               pos = lp855x_parse_register_cmd(buf, &arg1);
+               if (!pos)
+                       return -EINVAL;
+               pos2 = lp855x_parse_register_cmd(pos + 1, &arg2);
+               if (!pos2)
+                       return -EINVAL;
+
+               lp855x_write_byte(lp, arg1, arg2);
+               dev_info(lp->dev, "Written [0x%.2x] = 0x%.2x\n", arg1, arg2);
+               break;
+       case 'd':
+               pos = lp855x_parse_register_cmd(buf, &arg1);
+               if (!pos)
+                       return -EINVAL;
+               pos2 = lp855x_parse_register_cmd(pos + 1, &arg2);
+               if (!pos2)
+                       return -EINVAL;
+
+               for (i = arg1; i <= arg2; i++) {
+                       lp855x_read_byte(lp, i, &val);
+                       dev_info(lp->dev, "Read [0x%.2x] = 0x%.2x\n", i, val);
+               }
+               break;
+       default:
+               break;
+       }
+
+       return count;
+}
+
+static ssize_t lp855x_get_chipid(struct file *file, char __user *userbuf,
+                                size_t count, loff_t *ppos)
+{
+       struct lp855x *lp = file->private_data;
+       char buf[10];
+       unsigned int len;
+
+       len = snprintf(buf, sizeof(buf), "%s\n", lp->chipid);
+
+       if (len > sizeof(buf))
+               len = sizeof(buf);
+
+       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+
+static ssize_t lp855x_get_bl_mode(struct file *file, char __user *userbuf,
+                                 size_t count, loff_t *ppos)
+{
+       char buf[20];
+       unsigned int len;
+       char *strmode = NULL;
+       struct lp855x *lp = file->private_data;
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+
+       if (mode == PWM_BASED)
+               strmode = "pwm based";
+       else if (mode == REGISTER_BASED)
+               strmode = "register based";
+
+       len = snprintf(buf, sizeof(buf), "%s\n", strmode);
+
+       if (len > sizeof(buf))
+               len = sizeof(buf);
+
+       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+
+#define LP855X_DBG_ENTRY(name, pread, pwrite) \
+static const struct file_operations dbg_##name##_fops = { \
+       .open = lp855x_dbg_open, \
+       .read = pread, \
+       .write = pwrite, \
+       .owner = THIS_MODULE, \
+       .llseek = default_llseek, \
+}
+
+LP855X_DBG_ENTRY(registers, lp855x_help_register, lp855x_ctrl_register);
+LP855X_DBG_ENTRY(chip, lp855x_get_chipid, NULL);
+LP855X_DBG_ENTRY(blmode, lp855x_get_bl_mode, NULL);
+
+static void lp855x_create_debugfs(struct lp855x *lp)
+{
+       struct debug_dentry *dd = &lp->dd;
+
+       dd->dir = debugfs_create_dir("lp855x", NULL);
+
+       dd->reg = debugfs_create_file("registers", S_IWUSR | S_IRUGO,
+                                     dd->dir, lp, &dbg_registers_fops);
+
+       dd->chip = debugfs_create_file("chip_id", S_IRUGO,
+                                      dd->dir, lp, &dbg_chip_fops);
+
+       dd->blmode = debugfs_create_file("bl_ctl_mode", S_IRUGO,
+                                        dd->dir, lp, &dbg_blmode_fops);
+}
+
+static void lp855x_remove_debugfs(struct lp855x *lp)
+{
+       struct debug_dentry *dd = &lp->dd;
+
+       debugfs_remove(dd->blmode);
+       debugfs_remove(dd->chip);
+       debugfs_remove(dd->reg);
+       debugfs_remove(dd->dir);
+}
+#else
+static inline void lp855x_create_debugfs(struct lp855x *lp)
+{
+       return;
+}
+
+static inline void lp855x_remove_debugfs(struct lp855x *lp)
+{
+       return;
+}
+#endif
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
+static void lp855x_init_device(struct lp855x *lp)
+{
+       u8 val, addr;
+       int i, ret;
+       struct lp855x_platform_data *pd = lp->pdata;
+
+       val = pd->initial_brightness;
+       ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+
+       val = pd->device_control;
+       ret |= lp855x_write_byte(lp, DEVICE_CTRL, val);
+
+       if (pd->load_new_rom_data && pd->size_program) {
+               for (i = 0; i < pd->size_program; i++) {
+                       addr = pd->rom_data[i].addr;
+                       val = pd->rom_data[i].val;
+                       if (!lp855x_is_valid_rom_area(lp, addr))
+                               continue;
+
+                       ret |= lp855x_write_byte(lp, addr, val);
+               }
+       }
+
+       if (ret)
+               dev_err(lp->dev, "i2c write err\n");
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
+               u8 val;
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
+       const char *name = lp->pdata->name;
+
+       if (!name)
+               return -ENODEV;
+
+       props.brightness = lp->pdata->initial_brightness;
+       props.max_brightness =
+               (lp->pdata->max_brightness < lp->pdata->initial_brightness) ?
+               255 : lp->pdata->max_brightness;
+
+       bl = backlight_device_register(name, lp->dev, lp,
+                                      &lp855x_bl_ops, &props);
+       if (IS_ERR(bl))
+               return -EIO;
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
+       lp855x_init_device(lp);
+       ret = lp855x_backlight_register(lp);
+       if (ret)
+               goto err_dev;
+
+       backlight_update_status(lp->bl);
+       lp855x_create_debugfs(lp);
+
+       return ret;
+
+err_io:
+       return -EIO;
+err_mem:
+       return -ENOMEM;
+err_dev:
+       dev_err(lp->dev, "can not register backlight device. errcode = %d\n",
+               ret);
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
+       lp855x_remove_debugfs(lp);
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
+};
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
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>, Dainel Jeong <daniel.jeong@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/lp855x.h b/include/linux/lp855x.h
new file mode 100644
index 0000000..16e2474
--- /dev/null
+++ b/include/linux/lp855x.h
@@ -0,0 +1,133 @@
+/*
+ * lp855x.h - TI LP8556 Backlight Driver
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
+ * @name : backlight driver name
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
+       const char *name;
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


Best Regards

Milo (Woogyom) Kim
Texas Instruments Incorporated


