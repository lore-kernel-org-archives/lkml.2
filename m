Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0IMIdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:33:15 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:42179 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab0IMIdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:33:14 -0400
Message-ID: <4C8DE1BE.30304@stericsson.com>
Date: Mon, 13 Sep 2010 10:33:02 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100824 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        elinwal <linus.walleij@stericsson.com>
Subject: [PATCH 2/3] MFD: AB8500 debugfs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the possibility to read and write registers
via the debug_fs. It also adds ranges of registers sorted by bank
which makes it possible to read all defined registers in a bank.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
Fixed comment from Mark Brown.
AB8500_DEBUG is enabled default if DEBUG_FS=y
---
 drivers/mfd/Kconfig          |    8 +
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/ab8500-core.c    |    5 +
 drivers/mfd/ab8500-debugfs.c |  652 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 666 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/ab8500-debugfs.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c957c3a..a7f3d47 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -481,6 +481,14 @@ config AB8500_CORE
          read/write functions for the devices to get access to this chip.
          This chip embeds various other multimedia funtionalities as well.

+config AB8500_DEBUG
+       bool "Enable debug info via debugfs"
+       depends on AB8500_CORE && DEBUG_FS
+       default y if DEBUG_FS
+       help
+         Select this option if you want debug information using the debug
+         filesystem, debugfs.
+
 config AB3550_CORE
         bool "ST-Ericsson AB3550 Mixed Signal Circuit core functions"
        select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index feaeeae..610b074 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_AB3100_CORE)     += ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)       += ab3100-otp.o
 obj-$(CONFIG_AB3550_CORE)      += ab3550-core.o
 obj-$(CONFIG_AB8500_CORE)      += ab8500-core.o ab8500-spi.o
+obj-$(CONFIG_AB8500_DEBUG)     += ab8500-debugfs.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)     += adp5520.o
 obj-$(CONFIG_LPC_SCH)          += lpc_sch.o
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 35a2d58..6548f50 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -379,6 +379,11 @@ static struct resource ab8500_rtc_resources[] = {
 };

 static struct mfd_cell ab8500_devs[] = {
+#ifdef CONFIG_DEBUG_FS
+       {
+               .name = "ab8500-debug",
+       },
+#endif
        {
                .name = "ab8500-gpadc",
                .num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
new file mode 100644
index 0000000..fff5662
--- /dev/null
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -0,0 +1,652 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com> for ST-Ericsson.
+ * License Terms: GNU General Public License v2
+ */
+
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/ab8500.h>
+
+static u32 debug_bank;
+static u32 debug_address;
+
+/**
+ * struct ab8500_reg_range
+ * @first: the first address of the range
+ * @last: the last address of the range
+ * @perm: access permissions for the range
+ */
+struct ab8500_reg_range {
+       u8 first;
+       u8 last;
+       u8 perm;
+};
+
+/**
+ * struct ab8500_i2c_ranges
+ * @num_ranges: the number of ranges in the list
+ * @bankid: bank identifier
+ * @range: the list of register ranges
+ */
+struct ab8500_i2c_ranges {
+       u8 num_ranges;
+       u8 bankid;
+       const struct ab8500_reg_range *range;
+};
+
+#define AB8500_NAME_STRING "ab8500"
+#define AB8500_NUM_BANKS 22
+
+#define AB8500_REV_REG 0x80
+
+static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
+       [0x0] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [AB8500_SYS_CTRL1_BLOCK] = {
+               .num_ranges = 3,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x02,
+                       },
+                       {
+                               .first = 0x42,
+                               .last = 0x42,
+                       },
+                       {
+                               .first = 0x80,
+                               .last = 0x81,
+                       },
+               },
+       },
+       [AB8500_SYS_CTRL2_BLOCK] = {
+               .num_ranges = 4,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x0D,
+                       },
+                       {
+                               .first = 0x0F,
+                               .last = 0x17,
+                       },
+                       {
+                               .first = 0x30,
+                               .last = 0x30,
+                       },
+                       {
+                               .first = 0x32,
+                               .last = 0x33,
+                       },
+               },
+       },
+       [AB8500_REGU_CTRL1] = {
+               .num_ranges = 3,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x00,
+                       },
+                       {
+                               .first = 0x03,
+                               .last = 0x10,
+                       },
+                       {
+                               .first = 0x80,
+                               .last = 0x84,
+                       },
+               },
+       },
+       [AB8500_REGU_CTRL2] = {
+               .num_ranges = 5,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x15,
+                       },
+                       {
+                               .first = 0x17,
+                               .last = 0x19,
+                       },
+                       {
+                               .first = 0x1B,
+                               .last = 0x1D,
+                       },
+                       {
+                               .first = 0x1F,
+                               .last = 0x22,
+                       },
+                       {
+                               .first = 0x40,
+                               .last = 0x44,
+                       },
+                       /* 0x80-0x8B is SIM registers and should
+                        * not be accessed from here */
+               },
+       },
+       [AB8500_USB] = {
+               .num_ranges = 2,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x80,
+                               .last = 0x83,
+                       },
+                       {
+                               .first = 0x87,
+                               .last = 0x8A,
+                       },
+               },
+       },
+       [AB8500_TVOUT] = {
+               .num_ranges = 9,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x12,
+                       },
+                       {
+                               .first = 0x15,
+                               .last = 0x17,
+                       },
+                       {
+                               .first = 0x19,
+                               .last = 0x21,
+                       },
+                       {
+                               .first = 0x27,
+                               .last = 0x2C,
+                       },
+                       {
+                               .first = 0x41,
+                               .last = 0x41,
+                       },
+                       {
+                               .first = 0x45,
+                               .last = 0x5B,
+                       },
+                       {
+                               .first = 0x5D,
+                               .last = 0x5D,
+                       },
+                       {
+                               .first = 0x69,
+                               .last = 0x69,
+                       },
+                       {
+                               .first = 0x80,
+                               .last = 0x81,
+                       },
+               },
+       },
+       [AB8500_DBI] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [AB8500_ECI_AV_ACC] = {
+               .num_ranges = 1,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x80,
+                               .last = 0x82,
+                       },
+               },
+       },
+       [0x9] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [AB8500_GPADC] = {
+               .num_ranges = 1,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x08,
+                       },
+               },
+       },
+       [AB8500_CHARGER] = {
+               .num_ranges = 8,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x03,
+                       },
+                       {
+                               .first = 0x05,
+                               .last = 0x05,
+                       },
+                       {
+                               .first = 0x40,
+                               .last = 0x40,
+                       },
+                       {
+                               .first = 0x42,
+                               .last = 0x42,
+                       },
+                       {
+                               .first = 0x44,
+                               .last = 0x44,
+                       },
+                       {
+                               .first = 0x50,
+                               .last = 0x55,
+                       },
+                       {
+                               .first = 0x80,
+                               .last = 0x82,
+                       },
+                       {
+                               .first = 0xC0,
+                               .last = 0xC2,
+                       },
+               },
+       },
+       [AB8500_GAS_GAUGE] = {
+               .num_ranges = 3,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x00,
+                       },
+                       {
+                               .first = 0x07,
+                               .last = 0x0A,
+                       },
+                       {
+                               .first = 0x10,
+                               .last = 0x14,
+                       },
+               },
+       },
+       [AB8500_AUDIO] = {
+               .num_ranges = 1,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x6F,
+                       },
+               },
+       },
+       [AB8500_INTERRUPT] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [AB8500_RTC] = {
+               .num_ranges = 1,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x0F,
+                       },
+               },
+       },
+       [AB8500_MISC] = {
+               .num_ranges = 8,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x00,
+                               .last = 0x05,
+                       },
+                       {
+                               .first = 0x10,
+                               .last = 0x15,
+                       },
+                       {
+                               .first = 0x20,
+                               .last = 0x25,
+                       },
+                       {
+                               .first = 0x30,
+                               .last = 0x35,
+                       },
+                       {
+                               .first = 0x40,
+                               .last = 0x45,
+                       },
+                       {
+                               .first = 0x50,
+                               .last = 0x50,
+                       },
+                       {
+                               .first = 0x60,
+                               .last = 0x67,
+                       },
+                       {
+                               .first = 0x80,
+                               .last = 0x80,
+                       },
+               },
+       },
+       [0x11] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [0x12] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [0x13] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [0x14] = {
+               .num_ranges = 0,
+               .range = 0,
+       },
+       [AB8500_OTP_EMUL] = {
+               .num_ranges = 1,
+               .range = (struct ab8500_reg_range[]) {
+                       {
+                               .first = 0x01,
+                               .last = 0x0F,
+                       },
+               },
+       },
+};
+
+static int ab8500_registers_print(struct seq_file *s, void *p)
+{
+       struct device *dev = s->private;
+       unsigned int i;
+       u32 bank = debug_bank;
+
+       seq_printf(s, AB8500_NAME_STRING " register values:\n");
+
+       seq_printf(s, " bank %u:\n", bank);
+       for (i = 0; i < debug_ranges[bank].num_ranges; i++) {
+               u32 reg;
+
+               for (reg = debug_ranges[bank].range[i].first;
+                       reg <= debug_ranges[bank].range[i].last;
+                       reg++) {
+                       u8 value;
+                       int err;
+
+                       err = abx500_get_register_interruptible(dev,
+                               (u8)bank, (u8)reg, &value);
+                       if (err < 0) {
+                               dev_err(dev, "ab->read fail %d\n", err);
+                               return err;
+                       }
+
+                       err = seq_printf(s, "  [%u/0x%02X]: 0x%02X\n", bank,
+                               reg, value);
+                       if (err < 0) {
+                               dev_err(dev, "seq_printf overflow\n");
+                               /* Error is not returned here since
+                                * the output is wanted in any case */
+                               return 0;
+                       }
+               }
+       }
+       return 0;
+}
+
+static int ab8500_registers_open(struct inode *inode, struct file *file)
+{
+       return single_open(file, ab8500_registers_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_registers_fops = {
+       .open = ab8500_registers_open,
+       .read = seq_read,
+       .llseek = seq_lseek,
+       .release = single_release,
+       .owner = THIS_MODULE,
+};
+
+static int ab8500_bank_print(struct seq_file *s, void *p)
+{
+       return seq_printf(s, "%d\n", debug_bank);
+}
+
+static int ab8500_bank_open(struct inode *inode, struct file *file)
+{
+       return single_open(file, ab8500_bank_print, inode->i_private);
+}
+
+static ssize_t ab8500_bank_write(struct file *file,
+       const char __user *user_buf,
+       size_t count, loff_t *ppos)
+{
+       struct device *dev = ((struct seq_file *)(file->private_data))->private;
+       char buf[32];
+       int buf_size;
+       unsigned long user_bank;
+       int err;
+
+       /* Get userspace string and assure termination */
+       buf_size = min(count, (sizeof(buf) - 1));
+       if (copy_from_user(buf, user_buf, buf_size))
+               return -EFAULT;
+       buf[buf_size] = 0;
+
+       err = strict_strtoul(buf, 0, &user_bank);
+       if (err)
+               return -EINVAL;
+
+       if (user_bank >= AB8500_NUM_BANKS) {
+               dev_err(dev, "debugfs error input > number of banks\n");
+               return -EINVAL;
+       }
+
+       debug_bank = user_bank;
+
+       return buf_size;
+}
+
+static int ab8500_address_print(struct seq_file *s, void *p)
+{
+       return seq_printf(s, "0x%02X\n", debug_address);
+}
+
+static int ab8500_address_open(struct inode *inode, struct file *file)
+{
+       return single_open(file, ab8500_address_print, inode->i_private);
+}
+
+static ssize_t ab8500_address_write(struct file *file,
+       const char __user *user_buf,
+       size_t count, loff_t *ppos)
+{
+       struct device *dev = ((struct seq_file *)(file->private_data))->private;
+       char buf[32];
+       int buf_size;
+       unsigned long user_address;
+       int err;
+
+       /* Get userspace string and assure termination */
+       buf_size = min(count, (sizeof(buf) - 1));
+       if (copy_from_user(buf, user_buf, buf_size))
+               return -EFAULT;
+       buf[buf_size] = 0;
+
+       err = strict_strtoul(buf, 0, &user_address);
+       if (err)
+               return -EINVAL;
+       if (user_address > 0xff) {
+               dev_err(dev, "debugfs error input > 0xff\n");
+               return -EINVAL;
+       }
+       debug_address = user_address;
+       return buf_size;
+}
+
+static int ab8500_val_print(struct seq_file *s, void *p)
+{
+       struct device *dev = s->private;
+       int ret;
+       u8 regvalue;
+
+       ret = abx500_get_register_interruptible(dev,
+               (u8)debug_bank, (u8)debug_address, &regvalue);
+       if (ret < 0) {
+               dev_err(dev, "abx500_get_reg fail %d, %d\n",
+                       ret, __LINE__);
+               return -EINVAL;
+       }
+       seq_printf(s, "0x%02X\n", regvalue);
+
+       return 0;
+}
+
+static int ab8500_val_open(struct inode *inode, struct file *file)
+{
+       return single_open(file, ab8500_val_print, inode->i_private);
+}
+
+static ssize_t ab8500_val_write(struct file *file,
+       const char __user *user_buf,
+       size_t count, loff_t *ppos)
+{
+       struct device *dev = ((struct seq_file *)(file->private_data))->private;
+       char buf[32];
+       int buf_size;
+       unsigned long user_val;
+       int err;
+
+       /* Get userspace string and assure termination */
+       buf_size = min(count, (sizeof(buf)-1));
+       if (copy_from_user(buf, user_buf, buf_size))
+               return -EFAULT;
+       buf[buf_size] = 0;
+
+       err = strict_strtoul(buf, 0, &user_val);
+       if (err)
+               return -EINVAL;
+       if (user_val > 0xff) {
+               dev_err(dev, "debugfs error input > 0xff\n");
+               return -EINVAL;
+       }
+       err = abx500_set_register_interruptible(dev,
+               (u8)debug_bank, debug_address, (u8)user_val);
+       if (err < 0) {
+               printk(KERN_ERR "abx500_set_reg failed %d, %d", err, __LINE__);
+               return -EINVAL;
+       }
+
+       return buf_size;
+}
+
+static const struct file_operations ab8500_bank_fops = {
+       .open = ab8500_bank_open,
+       .write = ab8500_bank_write,
+       .read = seq_read,
+       .llseek = seq_lseek,
+       .release = single_release,
+       .owner = THIS_MODULE,
+};
+
+static const struct file_operations ab8500_address_fops = {
+       .open = ab8500_address_open,
+       .write = ab8500_address_write,
+       .read = seq_read,
+       .llseek = seq_lseek,
+       .release = single_release,
+       .owner = THIS_MODULE,
+};
+
+static const struct file_operations ab8500_val_fops = {
+       .open = ab8500_val_open,
+       .write = ab8500_val_write,
+       .read = seq_read,
+       .llseek = seq_lseek,
+       .release = single_release,
+       .owner = THIS_MODULE,
+};
+
+static struct dentry *ab8500_dir;
+static struct dentry *ab8500_reg_file;
+static struct dentry *ab8500_bank_file;
+static struct dentry *ab8500_address_file;
+static struct dentry *ab8500_val_file;
+
+static int __devinit ab8500_debug_probe(struct platform_device *plf)
+{
+       debug_bank = AB8500_MISC;
+       debug_address = AB8500_REV_REG & 0x00FF;
+
+       ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
+       if (!ab8500_dir)
+               goto exit_no_debugfs;
+
+       ab8500_reg_file = debugfs_create_file("all-bank-registers",
+               S_IRUGO, ab8500_dir, &plf->dev, &ab8500_registers_fops);
+       if (!ab8500_reg_file)
+               goto exit_destroy_dir;
+
+       ab8500_bank_file = debugfs_create_file("register-bank",
+               (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev, &ab8500_bank_fops);
+       if (!ab8500_bank_file)
+               goto exit_destroy_reg;
+
+       ab8500_address_file = debugfs_create_file("register-address",
+               (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
+               &ab8500_address_fops);
+       if (!ab8500_address_file)
+               goto exit_destroy_bank;
+
+       ab8500_val_file = debugfs_create_file("register-value",
+               (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev, &ab8500_val_fops);
+       if (!ab8500_val_file)
+               goto exit_destroy_address;
+
+       return 0;
+
+exit_destroy_address:
+       debugfs_remove(ab8500_address_file);
+exit_destroy_bank:
+       debugfs_remove(ab8500_bank_file);
+exit_destroy_reg:
+       debugfs_remove(ab8500_reg_file);
+exit_destroy_dir:
+       debugfs_remove(ab8500_dir);
+exit_no_debugfs:
+       dev_err(&plf->dev, "failed to create debugfs entries.\n");
+       return -ENOMEM;
+}
+
+static int __devexit ab8500_debug_remove(struct platform_device *plf)
+{
+       debugfs_remove(ab8500_val_file);
+       debugfs_remove(ab8500_address_file);
+       debugfs_remove(ab8500_bank_file);
+       debugfs_remove(ab8500_reg_file);
+       debugfs_remove(ab8500_dir);
+
+       return 0;
+}
+
+static struct platform_driver ab8500_debug_driver = {
+       .driver = {
+               .name = "ab8500-debug",
+               .owner = THIS_MODULE,
+       },
+       .probe  = ab8500_debug_probe,
+       .remove = __devexit_p(ab8500_debug_remove)
+};
+
+static int __init ab8500_debug_init(void)
+{
+       return platform_driver_register(&ab8500_debug_driver);
+}
+
+static void __exit ab8500_debug_exit(void)
+{
+       platform_driver_unregister(&ab8500_debug_driver);
+}
+subsys_initcall(ab8500_debug_init);
+module_exit(ab8500_debug_exit);
+
+MODULE_AUTHOR("Mattias WALLIN <mattias.wallin@stericsson.com");
+MODULE_DESCRIPTION("AB8500 DEBUG");
+MODULE_LICENSE("GPL v2");
--
1.6.3.3

