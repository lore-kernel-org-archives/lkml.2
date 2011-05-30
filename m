Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1E3IRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:17:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12752 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1E3IRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:17:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 30 May 2011 01:17:40 -0700
From: Jin Park <jinyoungp@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>
Subject: [PATCH 1/1] aat2870: Adding backlight, regulator and mfd driver
Date: Mon, 30 May 2011 17:17:32 +0900
Message-Id: <1306743452-26386-2-git-send-email-jinyoungp@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306743452-26386-1-git-send-email-jinyoungp@nvidia.com>
References: <1306743452-26386-1-git-send-email-jinyoungp@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding backlight, regulator and mfd driver for AnalogicTech AAT2870.

Signed-off-by: Jin Park <jinyoungp@nvidia.com>
---
 drivers/mfd/Kconfig                   |    7 +
 drivers/mfd/Makefile                  |    1 +
 drivers/mfd/aat2870-core.c            |  532 +++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig             |    7 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/aat2870-regulator.c |  265 ++++++++++++++++
 drivers/video/backlight/Kconfig       |    7 +
 drivers/video/backlight/Makefile      |    1 +
 drivers/video/backlight/aat2870_bl.c  |  246 +++++++++++++++
 include/linux/mfd/aat2870.h           |  182 +++++++++++
 10 files changed, 1249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/aat2870-core.c
 create mode 100644 drivers/regulator/aat2870-regulator.c
 create mode 100644 drivers/video/backlight/aat2870_bl.c
 create mode 100644 include/linux/mfd/aat2870.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0f09c05..5d3e906 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -728,6 +728,13 @@ config MFD_TPS65910
 	  if you say yes here you get support for the TPS65910 series of
 	  Power Management chips.
 
+config MFD_AAT2870_CORE
+	bool "Support for the AnlogicTech AAT2870"
+	select MFD_CORE
+	depends on I2C=y && GPIOLIB
+	help
+	  If you say yes here you get support for the AAT2870.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index efe3cc3..498eb42 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -94,3 +94,4 @@ obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
+obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
new file mode 100644
index 0000000..0d9687a
--- /dev/null
+++ b/drivers/mfd/aat2870-core.c
@@ -0,0 +1,532 @@
+/*
+ * linux/drivers/mfd/aat2870-core.c
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ * Author: Jin Park <jinyoungp@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/aat2870.h>
+#include <linux/regulator/machine.h>
+
+static struct aat2870_register aat2870_regs[AAT2870_REG_NUM] = {
+	/* readable, writeable, value */
+	{ 0, 1, 0x00 },	/* 0x00 AAT2870_BL_CH_EN */
+	{ 0, 1, 0x16 },	/* 0x01 AAT2870_BLM */
+	{ 0, 1, 0x16 },	/* 0x02 AAT2870_BLS */
+	{ 0, 1, 0x56 },	/* 0x03 AAT2870_BL1 */
+	{ 0, 1, 0x56 },	/* 0x04 AAT2870_BL2 */
+	{ 0, 1, 0x56 },	/* 0x05 AAT2870_BL3 */
+	{ 0, 1, 0x56 },	/* 0x06 AAT2870_BL4 */
+	{ 0, 1, 0x56 },	/* 0x07 AAT2870_BL5 */
+	{ 0, 1, 0x56 },	/* 0x08 AAT2870_BL6 */
+	{ 0, 1, 0x56 },	/* 0x09 AAT2870_BL7 */
+	{ 0, 1, 0x56 },	/* 0x0A AAT2870_BL8 */
+	{ 0, 1, 0x00 },	/* 0x0B AAT2870_FLR */
+	{ 0, 1, 0x03 },	/* 0x0C AAT2870_FM */
+	{ 0, 1, 0x03 },	/* 0x0D AAT2870_FS */
+	{ 0, 1, 0x10 },	/* 0x0E AAT2870_ALS_CFG0 */
+	{ 0, 1, 0x06 },	/* 0x0F AAT2870_ALS_CFG1 */
+	{ 0, 1, 0x00 },	/* 0x10 AAT2870_ALS_CFG2 */
+	{ 1, 0, 0x00 },	/* 0x11 AAT2870_AMB */
+	{ 0, 1, 0x00 },	/* 0x12 AAT2870_ALS0 */
+	{ 0, 1, 0x00 },	/* 0x13 AAT2870_ALS1 */
+	{ 0, 1, 0x00 },	/* 0x14 AAT2870_ALS2 */
+	{ 0, 1, 0x00 },	/* 0x15 AAT2870_ALS3 */
+	{ 0, 1, 0x00 },	/* 0x16 AAT2870_ALS4 */
+	{ 0, 1, 0x00 },	/* 0x17 AAT2870_ALS5 */
+	{ 0, 1, 0x00 },	/* 0x18 AAT2870_ALS6 */
+	{ 0, 1, 0x00 },	/* 0x19 AAT2870_ALS7 */
+	{ 0, 1, 0x00 },	/* 0x1A AAT2870_ALS8 */
+	{ 0, 1, 0x00 },	/* 0x1B AAT2870_ALS9 */
+	{ 0, 1, 0x00 },	/* 0x1C AAT2870_ALSA */
+	{ 0, 1, 0x00 },	/* 0x1D AAT2870_ALSB */
+	{ 0, 1, 0x00 },	/* 0x1E AAT2870_ALSC */
+	{ 0, 1, 0x00 },	/* 0x1F AAT2870_ALSD */
+	{ 0, 1, 0x00 },	/* 0x20 AAT2870_ALSE */
+	{ 0, 1, 0x00 },	/* 0x21 AAT2870_ALSF */
+	{ 0, 1, 0x00 },	/* 0x22 AAT2870_SUB_SET */
+	{ 0, 1, 0x00 },	/* 0x23 AAT2870_SUB_CTRL */
+	{ 0, 1, 0x00 },	/* 0x24 AAT2870_LDO_AB */
+	{ 0, 1, 0x00 },	/* 0x25 AAT2870_LDO_CD */
+	{ 0, 1, 0x00 },	/* 0x26 AAT2870_LDO_EN */
+};
+
+static struct mfd_cell aat2870_devs[] = {
+	{
+		.name = "aat2870-backlight",
+		.id = AAT2870_ID_BL,
+		.pdata_size = sizeof(struct aat2870_bl_platform_data),
+	},
+	{
+		.name = "aat2870-regulator",
+		.id = AAT2870_ID_LDOA,
+		.pdata_size = sizeof(struct regulator_init_data),
+	},
+	{
+		.name = "aat2870-regulator",
+		.id = AAT2870_ID_LDOB,
+		.pdata_size = sizeof(struct regulator_init_data),
+	},
+	{
+		.name = "aat2870-regulator",
+		.id = AAT2870_ID_LDOC,
+		.pdata_size = sizeof(struct regulator_init_data),
+	},
+	{
+		.name = "aat2870-regulator",
+		.id = AAT2870_ID_LDOD,
+		.pdata_size = sizeof(struct regulator_init_data),
+	},
+};
+
+static int aat2870_read(struct aat2870_data *aat2870, u8 addr, u8 *val)
+{
+	struct i2c_client *client = aat2870->client;
+	int ret = 0;
+
+	if (addr >= AAT2870_REG_NUM) {
+		dev_err(aat2870->dev, "Invalid address, 0x%02x\n", addr);
+		return -EINVAL;
+	}
+
+	mutex_lock(&aat2870->io_lock);
+
+	if (!aat2870->reg_cache[addr].readable) {
+		*val = aat2870->reg_cache[addr].value;
+		goto out_unlock;
+	}
+
+	ret = i2c_master_send(client, &addr, 1);
+	if (ret < 0)
+		goto out_unlock;
+	if (ret != 1) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	ret = i2c_master_recv(client, val, 1);
+	if (ret < 0)
+		goto out_unlock;
+	if (ret != 1) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	ret = 0;
+
+out_unlock:
+	mutex_unlock(&aat2870->io_lock);
+	dev_dbg(&client->dev, "read: addr=0x%02x, val=0x%02x\n", addr, *val);
+
+	return ret;
+}
+
+static int aat2870_write(struct aat2870_data *aat2870, u8 addr, u8 val)
+{
+	struct i2c_client *client = aat2870->client;
+	u8 msg[2];
+	int ret = 0;
+
+	if (addr >= AAT2870_REG_NUM) {
+		dev_err(aat2870->dev, "Invalid address, 0x%02x\n", addr);
+		return -EINVAL;
+	}
+
+	if (!aat2870->reg_cache[addr].writeable) {
+		dev_err(aat2870->dev, "Address 0x%02x is not writeable\n",
+			addr);
+		return -EINVAL;
+	}
+
+	mutex_lock(&aat2870->io_lock);
+
+	msg[0] = addr;
+	msg[1] = val;
+	ret = i2c_master_send(client, msg, 2);
+	if (ret < 0)
+		goto out_unlock;
+	if (ret != 2) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	aat2870->reg_cache[addr].value = val;
+	ret = 0;
+
+out_unlock:
+	mutex_unlock(&aat2870->io_lock);
+	dev_dbg(&client->dev, "write: addr=0x%02x, val=0x%02x\n", addr, val);
+
+	return ret;
+}
+
+static int aat2870_update_bits(struct aat2870_data *aat2870, u8 addr,
+			       u8 mask, u8 val)
+{
+	int change;
+	u8 old_val, new_val;
+	int ret;
+
+	ret = aat2870->read(aat2870, addr, &old_val);
+	if (ret)
+		return ret;
+
+	new_val = (old_val & ~mask) | val;
+	change = old_val != new_val;
+	if (change)
+		ret = aat2870->write(aat2870, addr, new_val);
+
+	dev_dbg(&aat2870->client->dev,
+		"update_bits: change=%d, addr=0x%02x, old=0x%02x, new=0x%02x\n",
+		change, addr, old_val, new_val);
+
+	return ret;
+}
+
+static inline void aat2870_enable(struct aat2870_data *aat2870)
+{
+	if (aat2870->en_pin >= 0)
+		gpio_set_value(aat2870->en_pin, 1);
+
+	aat2870->is_enable = 1;
+}
+
+static inline void aat2870_disable(struct aat2870_data *aat2870)
+{
+	if (aat2870->en_pin >= 0)
+		gpio_set_value(aat2870->en_pin, 0);
+
+	aat2870->is_enable = 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static ssize_t aat2870_dump_reg(struct aat2870_data *aat2870, char *buf)
+{
+	u8 addr, val;
+	ssize_t count = 0;
+	int ret;
+
+	count += sprintf(buf, "aat2870 registers\n");
+	for (addr = 0; addr < AAT2870_REG_NUM; addr++) {
+		count += sprintf(buf + count, "0x%02x: ", addr);
+		if (count >= PAGE_SIZE - 1)
+			break;
+
+		ret = aat2870->read(aat2870, addr, &val);
+		if (ret == 0)
+			count += snprintf(buf + count, PAGE_SIZE - count,
+					  "0x%02x", val);
+		else
+			count += snprintf(buf + count, PAGE_SIZE - count,
+					  "<read fail: %d>", ret);
+
+		if (count >= PAGE_SIZE - 1)
+			break;
+
+		count += snprintf(buf + count, PAGE_SIZE - count, "\n");
+		if (count >= PAGE_SIZE - 1)
+			break;
+	}
+
+	/* Truncate count; min() would cause a warning */
+	if (count >= PAGE_SIZE)
+		count = PAGE_SIZE - 1;
+
+	return count;
+}
+
+static int aat2870_reg_open_file(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t aat2870_reg_read_file(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct aat2870_data *aat2870 = file->private_data;
+	char *buf;
+	ssize_t ret;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = aat2870_dump_reg(aat2870, buf);
+	if (ret >= 0)
+		ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+
+	return ret;
+}
+
+static ssize_t aat2870_reg_write_file(struct file *file,
+				      const char __user *user_buf, size_t count,
+				      loff_t *ppos)
+{
+	struct aat2870_data *aat2870 = file->private_data;
+	char buf[32];
+	int buf_size;
+	char *start = buf;
+	unsigned long addr, val;
+	int ret;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size)) {
+		dev_err(aat2870->dev, "Failed to copy from user\n");
+		return -EFAULT;
+	}
+	buf[buf_size] = 0;
+
+	while (*start == ' ')
+		start++;
+
+	addr = simple_strtoul(start, &start, 16);
+	if (addr >= AAT2870_REG_NUM) {
+		dev_err(aat2870->dev, "Invalid address, 0x%lx\n", addr);
+		return -EINVAL;
+	}
+
+	while (*start == ' ')
+		start++;
+
+	if (strict_strtoul(start, 16, &val))
+		return -EINVAL;
+
+	ret = aat2870->write(aat2870, (u8)addr, (u8)val);
+	if (ret)
+		return ret;
+
+	return buf_size;
+}
+
+static const struct file_operations aat2870_reg_fops = {
+	.open = aat2870_reg_open_file,
+	.read = aat2870_reg_read_file,
+	.write = aat2870_reg_write_file,
+};
+
+static void aat2870_init_debugfs(struct aat2870_data *aat2870)
+{
+	aat2870->dentry_root = debugfs_create_dir("aat2870", NULL);
+	if (!aat2870->dentry_root) {
+		dev_warn(aat2870->dev,
+			 "Failed to create debugfs root directory\n");
+		return;
+	}
+
+	aat2870->dentry_reg = debugfs_create_file("regs", 0644,
+						  aat2870->dentry_root,
+						  aat2870, &aat2870_reg_fops);
+	if (!aat2870->dentry_reg)
+		dev_warn(aat2870->dev,
+			 "Failed to create debugfs register file\n");
+}
+
+static void aat2870_uninit_debugfs(struct aat2870_data *aat2870)
+{
+	debugfs_remove_recursive(aat2870->dentry_root);
+}
+#else
+static inline void aat2870_init_debugfs(struct aat2870_data *aat2870)
+{
+}
+
+static inline void aat2870_uninit_debugfs(struct aat2870_data *aat2870)
+{
+}
+#endif /* CONFIG_DEBUG_FS */
+
+static int aat2870_i2c_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
+{
+	struct aat2870_platform_data *pdata = client->dev.platform_data;
+	struct aat2870_data *aat2870;
+	int i, j;
+	int ret = 0;
+
+	aat2870 = kzalloc(sizeof(struct aat2870_data), GFP_KERNEL);
+	if (!aat2870) {
+		dev_err(&client->dev,
+			"Failed to allocate memory for aat2870\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	aat2870->dev = &client->dev;
+	dev_set_drvdata(aat2870->dev, aat2870);
+
+	aat2870->client = client;
+	i2c_set_clientdata(client, aat2870);
+
+	aat2870->reg_cache = aat2870_regs;
+
+	if (pdata->en_pin < 0)
+		aat2870->en_pin = -1;
+	else
+		aat2870->en_pin = pdata->en_pin;
+
+	aat2870->init = pdata->init;
+	aat2870->uninit = pdata->uninit;
+	aat2870->read = aat2870_read;
+	aat2870->write = aat2870_write;
+	aat2870->update_bits = aat2870_update_bits;
+
+	mutex_init(&aat2870->io_lock);
+
+	if (aat2870->init)
+		aat2870->init(aat2870);
+
+	if (aat2870->en_pin >= 0) {
+		ret = gpio_request(aat2870->en_pin, "aat2870-en");
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"Failed to request GPIO %d\n", aat2870->en_pin);
+			goto out_kfree;
+		}
+		gpio_direction_output(aat2870->en_pin, 1);
+	}
+
+	aat2870_enable(aat2870);
+
+	for (i = 0; i < pdata->num_subdevs; i++) {
+		for (j = 0; j < ARRAY_SIZE(aat2870_devs); j++) {
+			if ((pdata->subdevs[i].id == aat2870_devs[j].id) &&
+					!strcmp(pdata->subdevs[i].name,
+						aat2870_devs[j].name)) {
+				aat2870_devs[j].platform_data =
+					pdata->subdevs[i].platform_data;
+				break;
+			}
+		}
+	}
+
+	ret = mfd_add_devices(aat2870->dev, 0, aat2870_devs,
+			      ARRAY_SIZE(aat2870_devs), NULL, 0);
+	if (ret != 0) {
+		dev_err(aat2870->dev, "Failed to add subdev: %d\n", ret);
+		goto out_disable;
+	}
+
+	aat2870_init_debugfs(aat2870);
+
+	return 0;
+
+out_disable:
+	aat2870_disable(aat2870);
+	if (aat2870->en_pin >= 0)
+		gpio_free(aat2870->en_pin);
+out_kfree:
+	kfree(aat2870);
+out:
+	return ret;
+}
+
+static int aat2870_i2c_remove(struct i2c_client *client)
+{
+	struct aat2870_data *aat2870 = i2c_get_clientdata(client);
+
+	aat2870_uninit_debugfs(aat2870);
+
+	mfd_remove_devices(aat2870->dev);
+	aat2870_disable(aat2870);
+	if (aat2870->en_pin >= 0)
+		gpio_free(aat2870->en_pin);
+	if (aat2870->uninit)
+		aat2870->uninit(aat2870);
+	kfree(aat2870);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int aat2870_i2c_suspend(struct i2c_client *client, pm_message_t state)
+{
+	struct aat2870_data *aat2870 = i2c_get_clientdata(client);
+
+	aat2870_disable(aat2870);
+
+	return 0;
+}
+
+static int aat2870_i2c_resume(struct i2c_client *client)
+{
+	struct aat2870_data *aat2870 = i2c_get_clientdata(client);
+	struct aat2870_register *reg = NULL;
+	int i;
+
+	aat2870_enable(aat2870);
+
+	/* restore registers */
+	for (i = 0; i < AAT2870_REG_NUM; i++) {
+		reg = &aat2870->reg_cache[i];
+		if (reg->writeable)
+			aat2870->write(aat2870, i, reg->value);
+	}
+
+	return 0;
+}
+#else
+#define aat2870_i2c_suspend	NULL
+#define aat2870_i2c_resume	NULL
+#endif /* CONFIG_PM */
+
+static struct i2c_device_id aat2870_i2c_id_table[] = {
+	{ "aat2870", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, aat2870_i2c_id_table);
+
+static struct i2c_driver aat2870_i2c_driver = {
+	.driver = {
+		.name	= "aat2870",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aat2870_i2c_probe,
+	.remove		= aat2870_i2c_remove,
+	.suspend	= aat2870_i2c_suspend,
+	.resume		= aat2870_i2c_resume,
+	.id_table	= aat2870_i2c_id_table,
+};
+
+static int __init aat2870_init(void)
+{
+	return i2c_add_driver(&aat2870_i2c_driver);
+}
+subsys_initcall(aat2870_init);
+
+static void __exit aat2870_exit(void)
+{
+	i2c_del_driver(&aat2870_i2c_driver);
+}
+module_exit(aat2870_exit);
+
+MODULE_DESCRIPTION("Core support for the AnalogicTech AAT2870");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jin Park <jinyoungp@nvidia.com>");
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index d7ed20f..0f37466 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -303,5 +303,12 @@ config REGULATOR_TPS65910
 	help
 	  This driver supports TPS65910 voltage regulator chips.
 
+config REGULATOR_AAT2870
+	bool "AnalogicTech AAT2870 Regulators"
+	depends on MFD_AAT2870_CORE
+	help
+	  If you have a AnalogicTech AAT2870 say Y to enable the
+	  regulator driver.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 3932d2e..8b8f3bc 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -43,5 +43,6 @@ obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
+obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
new file mode 100644
index 0000000..e751c06
--- /dev/null
+++ b/drivers/regulator/aat2870-regulator.c
@@ -0,0 +1,265 @@
+/*
+ * linux/drivers/regulator/aat2870-regulator.c
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ * Author: Jin Park <jinyoungp@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/aat2870.h>
+
+struct aat2870_regulator {
+	struct platform_device *pdev;
+	struct regulator_desc desc;
+
+	int *voltages; /* uV */
+
+	int min_uV;
+	int max_uV;
+
+	u8 enable_addr;
+	u8 enable_shift;
+	u8 enable_mask;
+
+	u8 voltage_addr;
+	u8 voltage_shift;
+	u8 voltage_mask;
+};
+
+static int aat2870_ldo_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+
+	return ri->voltages[selector];
+}
+
+static int aat2870_ldo_set_voltage(struct regulator_dev *rdev,
+				   int min_uV, int max_uV, unsigned *selector)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	u8 val;
+	int uV;
+	int i;
+
+	if ((min_uV < ri->min_uV) || (max_uV > ri->max_uV)) {
+		dev_err(&rdev->dev,
+			"Invalid voltage, min %duV(>=%duV), max %duV(<=%duV)\n",
+			min_uV, ri->min_uV, max_uV, ri->max_uV);
+		return -EDOM;
+	}
+
+	for (i = 0; i < ri->desc.n_voltages; i++) {
+		uV = ri->voltages[i];
+		if ((min_uV <= uV) && (uV <= max_uV)) {
+			val = (i << ri->voltage_shift) & ri->voltage_mask;
+			break;
+		}
+	}
+
+	if (i >= ri->desc.n_voltages)
+		return -EINVAL;
+
+	*selector = i;
+
+	return aat2870->update_bits(aat2870, ri->voltage_addr,
+				    ri->voltage_mask, val);
+}
+
+static int aat2870_ldo_get_voltage(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	u8 val;
+	int ret;
+
+	ret = aat2870->read(aat2870, ri->voltage_addr, &val);
+	if (ret)
+		return ret;
+
+	val = (val & ri->voltage_mask) >> ri->voltage_shift;
+	if (val >= ri->desc.n_voltages)
+		return -EIO;
+
+	return ri->voltages[val];
+}
+
+static int aat2870_ldo_enable(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+
+	return aat2870->update_bits(aat2870, ri->enable_addr,
+				    ri->enable_mask, ri->enable_mask);
+}
+
+static int aat2870_ldo_disable(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+
+	return aat2870->update_bits(aat2870, ri->enable_addr,
+				    ri->enable_mask, 0);
+}
+
+static int aat2870_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
+	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
+	u8 val;
+	int ret;
+
+	ret = aat2870->read(aat2870, ri->enable_addr, &val);
+	if (ret)
+		return ret;
+
+	return val & ri->enable_mask ? 1 : 0;
+}
+
+static struct regulator_ops aat2870_ldo_ops = {
+	.list_voltage = aat2870_ldo_list_voltage,
+	.set_voltage = aat2870_ldo_set_voltage,
+	.get_voltage = aat2870_ldo_get_voltage,
+	.enable = aat2870_ldo_enable,
+	.disable = aat2870_ldo_disable,
+	.is_enabled = aat2870_ldo_is_enabled,
+};
+
+static int aat2870_ldo_voltages[] = {
+	1200000, 1300000, 1500000, 1600000,
+	1800000, 2000000, 2200000, 2500000,
+	2600000, 2700000, 2800000, 2900000,
+	3000000, 3100000, 3200000, 3300000,
+};
+
+#define AAT2870_LDO(ids)				\
+	{						\
+		.desc = {				\
+			.name = #ids,			\
+			.id = AAT2870_ID_##ids,		\
+			.n_voltages = ARRAY_SIZE(aat2870_ldo_voltages),	\
+			.ops = &aat2870_ldo_ops,	\
+			.type = REGULATOR_VOLTAGE,	\
+			.owner = THIS_MODULE,		\
+		},					\
+		.voltages = aat2870_ldo_voltages,	\
+		.min_uV = 1200000,			\
+		.max_uV = 3300000,			\
+	}
+
+static struct aat2870_regulator aat2870_regulators[] = {
+	AAT2870_LDO(LDOA),
+	AAT2870_LDO(LDOB),
+	AAT2870_LDO(LDOC),
+	AAT2870_LDO(LDOD),
+};
+
+static struct aat2870_regulator *aat2870_get_regulator(int id)
+{
+	struct aat2870_regulator *ri = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(aat2870_regulators); i++) {
+		ri = &aat2870_regulators[i];
+		if (ri->desc.id == id)
+			break;
+	}
+
+	if (!ri)
+		return NULL;
+
+	ri->enable_addr = AAT2870_LDO_EN;
+	ri->enable_shift = id - AAT2870_ID_LDOA;
+	ri->enable_mask = 0x1 << ri->enable_shift;
+
+	ri->voltage_addr = (id - AAT2870_ID_LDOA) / 2 ?
+			   AAT2870_LDO_CD : AAT2870_LDO_AB;
+	ri->voltage_shift = (id - AAT2870_ID_LDOA) % 2 ? 0 : 4;
+	ri->voltage_mask = 0xF << ri->voltage_shift;
+
+	return ri;
+}
+
+static int aat2870_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_init_data *init_data = pdev->dev.platform_data;
+	struct aat2870_regulator *ri;
+	struct regulator_dev *rdev;
+
+	if (!init_data) {
+		dev_err(&pdev->dev, "No regulator init data\n");
+		return -ENXIO;
+	}
+
+	ri = aat2870_get_regulator(pdev->id);
+	if (!ri) {
+		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
+		return -EINVAL;
+	}
+	ri->pdev = pdev;
+
+	rdev = regulator_register(&ri->desc, &pdev->dev, init_data, ri);
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "Failed to register regulator %s\n",
+			ri->desc.name);
+		return PTR_ERR(rdev);
+	}
+	platform_set_drvdata(pdev, rdev);
+
+	return 0;
+}
+
+static int __devexit aat2870_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+	return 0;
+}
+
+static struct platform_driver aat2870_regulator_driver = {
+	.driver = {
+		.name	= "aat2870-regulator",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= aat2870_regulator_probe,
+	.remove	= __devexit_p(aat2870_regulator_remove),
+};
+
+static int __init aat2870_regulator_init(void)
+{
+	return platform_driver_register(&aat2870_regulator_driver);
+}
+subsys_initcall(aat2870_regulator_init);
+
+static void __exit aat2870_regulator_exit(void)
+{
+	platform_driver_unregister(&aat2870_regulator_driver);
+}
+module_exit(aat2870_regulator_exit);
+
+MODULE_DESCRIPTION("AnalogicTech AAT2870 Regulator");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jin Park <jinyoungp@nvidia.com>");
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 0c9373b..3fde1ec 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -315,6 +315,13 @@ config BACKLIGHT_PCF50633
 	  If you have a backlight driven by a NXP PCF50633 MFD, say Y here to
 	  enable its driver.
 
+config BACKLIGHT_AAT2870
+	bool "AnalogicTech AAT2870 Backlight"
+	depends on ( BACKLIGHT_CLASS_DEVICE = y ) && MFD_AAT2870_CORE
+	help
+	  If you have a AnalogicTech AAT2870 say Y to enable the
+	  backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index b9ca849..2a08271 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -36,4 +36,5 @@ obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
+obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
 
diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
new file mode 100644
index 0000000..4952a61
--- /dev/null
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -0,0 +1,246 @@
+/*
+ * linux/drivers/video/backlight/aat2870_bl.c
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ * Author: Jin Park <jinyoungp@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/mfd/aat2870.h>
+
+struct aat2870_bl_driver_data {
+	struct platform_device *pdev;
+	struct backlight_device *bd;
+
+	int channels;
+	int max_current;
+	int brightness; /* current brightness */
+};
+
+static inline int aat2870_brightness(struct aat2870_bl_driver_data *aat2870_bl,
+				     int brightness)
+{
+	struct backlight_device *bd = aat2870_bl->bd;
+	int val;
+
+	val = brightness * aat2870_bl->max_current;
+	val /= bd->props.max_brightness;
+
+	return val;
+}
+
+static inline int aat2870_bl_enable(struct aat2870_bl_driver_data *aat2870_bl)
+{
+	struct aat2870_data *aat2870
+			= dev_get_drvdata(aat2870_bl->pdev->dev.parent);
+
+	return aat2870->write(aat2870, AAT2870_BL_CH_EN,
+			      (u8)aat2870_bl->channels);
+}
+
+static inline int aat2870_bl_disable(struct aat2870_bl_driver_data *aat2870_bl)
+{
+	struct aat2870_data *aat2870
+			= dev_get_drvdata(aat2870_bl->pdev->dev.parent);
+
+	return aat2870->write(aat2870, AAT2870_BL_CH_EN, 0x0);
+}
+
+static int aat2870_bl_get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static int aat2870_bl_update_status(struct backlight_device *bd)
+{
+	struct aat2870_bl_driver_data *aat2870_bl = dev_get_drvdata(&bd->dev);
+	struct aat2870_data *aat2870 =
+			dev_get_drvdata(aat2870_bl->pdev->dev.parent);
+	int brightness = bd->props.brightness;
+	int ret;
+
+	if ((brightness < 0) || (bd->props.max_brightness < brightness)) {
+		dev_err(&bd->dev, "invalid brightness, %d\n", brightness);
+		return -EINVAL;
+	}
+
+	dev_dbg(&bd->dev, "brightness=%d, power=%d, state=%d\n",
+		 bd->props.brightness, bd->props.power, bd->props.state);
+
+	if ((bd->props.power != FB_BLANK_UNBLANK) ||
+			(bd->props.state & BL_CORE_FBBLANK) ||
+			(bd->props.state & BL_CORE_SUSPENDED))
+		brightness = 0;
+
+	ret = aat2870->write(aat2870, AAT2870_BLM,
+			     (u8)aat2870_brightness(aat2870_bl, brightness));
+	if (ret < 0)
+		return ret;
+
+	if (brightness == 0) {
+		ret = aat2870_bl_disable(aat2870_bl);
+		if (ret < 0)
+			return ret;
+	} else if (aat2870_bl->brightness == 0) {
+		ret = aat2870_bl_enable(aat2870_bl);
+		if (ret < 0)
+			return ret;
+	}
+
+	aat2870_bl->brightness = brightness;
+
+	return 0;
+}
+
+static int aat2870_bl_check_fb(struct backlight_device *bd, struct fb_info *fi)
+{
+	return 1;
+}
+
+static const struct backlight_ops aat2870_bl_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.get_brightness = aat2870_bl_get_brightness,
+	.update_status = aat2870_bl_update_status,
+	.check_fb = aat2870_bl_check_fb,
+};
+
+static int aat2870_bl_probe(struct platform_device *pdev)
+{
+	struct aat2870_bl_platform_data *pdata = pdev->dev.platform_data;
+	struct aat2870_bl_driver_data *aat2870_bl;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	int ret = 0;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (pdev->id != AAT2870_ID_BL) {
+		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	aat2870_bl = kzalloc(sizeof(struct aat2870_bl_driver_data), GFP_KERNEL);
+	if (!aat2870_bl) {
+		dev_err(&pdev->dev,
+			"Failed to allocate memory for aat2870 backlight\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+
+	props.type = BACKLIGHT_RAW;
+	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
+				       aat2870_bl, &aat2870_bl_ops, &props);
+	if (!bd) {
+		dev_err(&pdev->dev,
+			"Failed allocate memory for backlight device\n");
+		ret = -ENOMEM;
+		goto out_kfree;
+	}
+
+	aat2870_bl->pdev = pdev;
+	platform_set_drvdata(pdev, aat2870_bl);
+
+	aat2870_bl->bd = bd;
+
+	if (pdata->channels > 0)
+		aat2870_bl->channels = pdata->channels;
+	else
+		aat2870_bl->channels = AAT2870_BL_CH_ALL;
+
+	if (pdata->max_brightness > 0)
+		aat2870_bl->max_current = pdata->max_current;
+	else
+		aat2870_bl->max_current = AAT2870_CURRENT_27_9;
+
+	if (pdata->max_brightness > 0)
+		bd->props.max_brightness = pdata->max_brightness;
+	else
+		bd->props.max_brightness = 255;
+
+	aat2870_bl->brightness = 0;
+	bd->props.power = FB_BLANK_UNBLANK;
+	bd->props.brightness = bd->props.max_brightness;
+
+	ret = aat2870_bl_update_status(bd);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize\n");
+		goto out_bl_dev_unregister;
+	}
+
+	return 0;
+
+out_bl_dev_unregister:
+	backlight_device_unregister(bd);
+out_kfree:
+	kfree(aat2870_bl);
+out:
+	return ret;
+}
+
+static int aat2870_bl_remove(struct platform_device *pdev)
+{
+	struct aat2870_bl_driver_data *aat2870_bl = platform_get_drvdata(pdev);
+	struct backlight_device *bd = aat2870_bl->bd;
+
+	bd->props.power = FB_BLANK_POWERDOWN;
+	bd->props.brightness = 0;
+	backlight_update_status(bd);
+
+	backlight_device_unregister(bd);
+	kfree(aat2870_bl);
+
+	return 0;
+}
+
+static struct platform_driver aat2870_bl_driver = {
+	.driver = {
+		.name	= "aat2870-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aat2870_bl_probe,
+	.remove		= aat2870_bl_remove,
+};
+
+static int __init aat2870_bl_init(void)
+{
+	return platform_driver_register(&aat2870_bl_driver);
+}
+subsys_initcall(aat2870_bl_init);
+
+static void __exit aat2870_bl_exit(void)
+{
+	platform_driver_unregister(&aat2870_bl_driver);
+}
+module_exit(aat2870_bl_exit);
+
+MODULE_DESCRIPTION("AnalogicTech AAT2870 Backlight");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jin Park <jinyoungp@nvidia.com>");
diff --git a/include/linux/mfd/aat2870.h b/include/linux/mfd/aat2870.h
new file mode 100644
index 0000000..d9ea3a2
--- /dev/null
+++ b/include/linux/mfd/aat2870.h
@@ -0,0 +1,182 @@
+/*
+ * linux/include/linux/mfd/aat2870.h
+ *
+ * Copyright (c) 2011, NVIDIA Corporation.
+ * Author: Jin Park <jinyoungp@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_MFD_AAT2870_H
+#define __LINUX_MFD_AAT2870_H
+
+#include <linux/debugfs.h>
+#include <linux/i2c.h>
+
+/* Register offsets */
+#define AAT2870_BL_CH_EN	0x00
+#define AAT2870_BLM		0x01
+#define AAT2870_BLS		0x02
+#define AAT2870_BL1		0x03
+#define AAT2870_BL2		0x04
+#define AAT2870_BL3		0x05
+#define AAT2870_BL4		0x06
+#define AAT2870_BL5		0x07
+#define AAT2870_BL6		0x08
+#define AAT2870_BL7		0x09
+#define AAT2870_BL8		0x0A
+#define AAT2870_FLR		0x0B
+#define AAT2870_FM		0x0C
+#define AAT2870_FS		0x0D
+#define AAT2870_ALS_CFG0	0x0E
+#define AAT2870_ALS_CFG1	0x0F
+#define AAT2870_ALS_CFG2	0x10
+#define AAT2870_AMB		0x11
+#define AAT2870_ALS0		0x12
+#define AAT2870_ALS1		0x13
+#define AAT2870_ALS2		0x14
+#define AAT2870_ALS3		0x15
+#define AAT2870_ALS4		0x16
+#define AAT2870_ALS5		0x17
+#define AAT2870_ALS6		0x18
+#define AAT2870_ALS7		0x19
+#define AAT2870_ALS8		0x1A
+#define AAT2870_ALS9		0x1B
+#define AAT2870_ALSA		0x1C
+#define AAT2870_ALSB		0x1D
+#define AAT2870_ALSC		0x1E
+#define AAT2870_ALSD		0x1F
+#define AAT2870_ALSE		0x20
+#define AAT2870_ALSF		0x21
+#define AAT2870_SUB_SET		0x22
+#define AAT2870_SUB_CTRL	0x23
+#define AAT2870_LDO_AB		0x24
+#define AAT2870_LDO_CD		0x25
+#define AAT2870_LDO_EN		0x26
+#define AAT2870_REG_NUM		0x27
+
+/* Device IDs */
+enum aat2870_id {
+	AAT2870_ID_BL,
+	AAT2870_ID_LDOA,
+	AAT2870_ID_LDOB,
+	AAT2870_ID_LDOC,
+	AAT2870_ID_LDOD
+};
+
+/* Backlight channels */
+#define AAT2870_BL_CH1		0x01
+#define AAT2870_BL_CH2		0x02
+#define AAT2870_BL_CH3		0x04
+#define AAT2870_BL_CH4		0x08
+#define AAT2870_BL_CH5		0x10
+#define AAT2870_BL_CH6		0x20
+#define AAT2870_BL_CH7		0x40
+#define AAT2870_BL_CH8		0x80
+#define AAT2870_BL_CH_ALL	0xFF
+
+/* Backlight current magnitude (mA) */
+enum aat2870_current {
+	AAT2870_CURRENT_0_45 = 0,
+	AAT2870_CURRENT_0_90,
+	AAT2870_CURRENT_1_80,
+	AAT2870_CURRENT_2_70,
+	AAT2870_CURRENT_3_60,
+	AAT2870_CURRENT_4_50,
+	AAT2870_CURRENT_5_40,
+	AAT2870_CURRENT_6_30,
+	AAT2870_CURRENT_7_20,
+	AAT2870_CURRENT_8_10,
+	AAT2870_CURRENT_9_00 = 10,
+	AAT2870_CURRENT_9_90,
+	AAT2870_CURRENT_10_8,
+	AAT2870_CURRENT_11_7,
+	AAT2870_CURRENT_12_6,
+	AAT2870_CURRENT_13_5,
+	AAT2870_CURRENT_14_4,
+	AAT2870_CURRENT_15_3,
+	AAT2870_CURRENT_16_2,
+	AAT2870_CURRENT_17_1,
+	AAT2870_CURRENT_18_0 = 20,
+	AAT2870_CURRENT_18_9,
+	AAT2870_CURRENT_19_8,
+	AAT2870_CURRENT_20_7,
+	AAT2870_CURRENT_21_6,
+	AAT2870_CURRENT_22_5,
+	AAT2870_CURRENT_23_4,
+	AAT2870_CURRENT_24_3,
+	AAT2870_CURRENT_25_2,
+	AAT2870_CURRENT_26_1,
+	AAT2870_CURRENT_27_0 = 30,
+	AAT2870_CURRENT_27_9
+};
+
+struct aat2870_register {
+	int readable;
+	int writeable;
+	u8 value;
+};
+
+struct aat2870_data {
+	struct device *dev;
+	struct i2c_client *client;
+
+	struct mutex io_lock;
+	struct aat2870_register *reg_cache; /* register cache */
+	int en_pin; /* enable GPIO pin (if < 0, ignore this value) */
+	int is_enable;
+
+	/* init and uninit for platform specified */
+	int (*init)(struct aat2870_data *aat2870);
+	void (*uninit)(struct aat2870_data *aat2870);
+
+	/* i2c io funcntions */
+	int (*read)(struct aat2870_data *aat2870, u8 addr, u8 *val);
+	int (*write)(struct aat2870_data *aat2870, u8 addr, u8 val);
+	int (*update_bits)(struct aat2870_data *aat2870, u8 addr, u8 mask,
+			   u8 val);
+
+	/* for debugfs */
+	struct dentry *dentry_root;
+	struct dentry *dentry_reg;
+};
+
+struct aat2870_subdev_info {
+	int id;
+	const char *name;
+	void *platform_data;
+};
+
+struct aat2870_platform_data {
+	int en_pin; /* enable GPIO pin (if < 0, ignore this value) */
+
+	struct aat2870_subdev_info *subdevs;
+	int num_subdevs;
+
+	/* init and uninit for platform specified */
+	int (*init)(struct aat2870_data *aat2870);
+	void (*uninit)(struct aat2870_data *aat2870);
+};
+
+struct aat2870_bl_platform_data {
+	/* backlight channels, default is AAT2870_BL_CH_ALL */
+	int channels;
+	/* backlight current magnitude, default is AAT2870_CURRENT_27_9 */
+	int max_current;
+	/* maximum brightness, default is 255 */
+	int max_brightness;
+};
+
+#endif /* __LINUX_MFD_AAT2870_H */
-- 
1.7.1

