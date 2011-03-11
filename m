Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1CKVi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:38:58 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37169 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab1CKVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=O4qvpwC8DFN5cUgV4/0EIxlX6peVsYIN9IJwwHMi89B2IbCoYDIXwrO54Cd9ZR8ycs
         zYsKts6Ckp4AyG3yqkQYJnpehJQz2AfwpAu57erHypohP/o197ivwo+ftACDmi8dLcmV
         SLff8gdvrteyYEhmcOTcoov0k29KIyhmQ8ZYo=
From: "=?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?=" <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnpol@2ka.mipt.ru,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>
Subject: [w1 PATCHES 2/3] Add 1-wire (w1) DS2408 8-Channel Addressable Switch support
Date: Fri, 11 Mar 2011 16:38:32 -0500
Message-Id: <1299879513-14884-3-git-send-email-dagenaisj@sonatest.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
References: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This DS2408 w1 slave driver is not complete for all the
features of the chip, but its sufficient if you use it as
a simple IO expander.

Signed-off-by: Jean-François Dagenais <dagenaisj@sonatest.com>
---
:100644 100644 f0c9096... cd1b724... M	drivers/w1/slaves/Kconfig
:100644 100644 3c76350... 75e3913... M	drivers/w1/slaves/Makefile
:000000 100644 0000000... 3547e80... A	drivers/w1/slaves/w1_ds2408.c
:100644 100644 f3b636d... 7513759... M	drivers/w1/w1_family.h
 drivers/w1/slaves/Kconfig     |    7 +
 drivers/w1/slaves/Makefile    |    1 +
 drivers/w1/slaves/w1_ds2408.c |  402 +++++++++++++++++++++++++++++++++++++++++
 drivers/w1/w1_family.h        |    1 +
 4 files changed, 411 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index f0c9096..cd1b724 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -16,6 +16,13 @@ config W1_SLAVE_SMEM
 	  Say Y here if you want to connect 1-wire
 	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
+config W1_SLAVE_DS2408
+        tristate "8-Channel Addressable Switch (IO Expander) 0x29 family support (DS2408)"
+        help
+          Say Y here if you want to use a 1-wire
+
+		  DS2408 8-Channel Addressable Switch device support
+
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
 	select CRC16
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 3c76350..75e3913 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
+obj-$(CONFIG_W1_SLAVE_DS2408)   += w1_ds2408.o
 obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds2423.o
 obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
new file mode 100644
index 0000000..3547e80
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -0,0 +1,402 @@
+/*
+ *	w1_ds2408.c - w1 family 29 (DS2408) driver
+ *
+ * Copyright (c) 2010 Jean-Francois Dagenais <dagenaisj@sonatest.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jean-Francois Dagenais <dagenaisj@sonatest.com>");
+MODULE_DESCRIPTION("w1 family 29 driver for DS2408 8 Pin IO");
+
+
+#define W1_F29_RETRIES		3
+
+#define W1_F29_REG_LOGIG_STATE             0x88 /* R */
+#define W1_F29_REG_OUTPUT_LATCH_STATE      0x89 /* R */
+#define W1_F29_REG_ACTIVITY_LATCH_STATE    0x8A /* R */
+#define W1_F29_REG_COND_SEARCH_SELECT_MASK 0x8B /* RW */
+#define W1_F29_REG_COND_SEARCH_POL_SELECT  0x8C /* RW */
+#define W1_F29_REG_CONTROL_AND_STATUS      0x8D /* RW */
+
+#define W1_F29_FUNC_READ_PIO_REGS          0xF0
+#define W1_F29_FUNC_CHANN_ACCESS_READ      0xF5
+#define W1_F29_FUNC_CHANN_ACCESS_WRITE     0x5A
+/* also used to write the control/status reg (0x8D): */
+#define W1_F29_FUNC_WRITE_COND_SEARCH_REG  0xCC
+#define W1_F29_FUNC_RESET_ACTIVITY_LATCHES 0xC3
+
+#define W1_F29_SUCCESS_CONFIRM_BYTE        0xAA
+
+static int _read_reg(struct w1_slave *sl, u8 address, unsigned char* buf)
+{
+	u8 wrbuf[3];
+	dev_dbg(&sl->dev,
+			"Reading with slave: %p, reg addr: %0#4x, buff addr: %p",
+			sl, (unsigned int)address, buf);
+
+	if (!buf)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex locked");
+
+	if (w1_reset_select_slave(sl)) {
+		mutex_unlock(&sl->master->mutex);
+		return -EIO;
+	}
+
+	wrbuf[0] = W1_F29_FUNC_READ_PIO_REGS;
+	wrbuf[1] = address;
+	wrbuf[2] = 0;
+	w1_write_block(sl->master, wrbuf, 3);
+	*buf = w1_read_8(sl->master);
+
+	mutex_unlock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex unlocked");
+	return 1;
+}
+
+static ssize_t w1_f29_read_state(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count != 1 || off != 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj), W1_F29_REG_LOGIG_STATE, buf);
+}
+
+static ssize_t w1_f29_read_output(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count != 1 || off != 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+					 W1_F29_REG_OUTPUT_LATCH_STATE, buf);
+}
+
+static ssize_t w1_f29_read_activity(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count != 1 || off != 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+					 W1_F29_REG_ACTIVITY_LATCH_STATE, buf);
+}
+
+static ssize_t w1_f29_read_cond_search_mask(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
+		"Reading %s kobj: %p, off: %0#10x, count: %lu, buff addr: %p",
+		bin_attr->attr.name, kobj, (unsigned int)off, count, buf);
+	if (count != 1 || off != 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+		W1_F29_REG_COND_SEARCH_SELECT_MASK, buf);
+}
+
+static ssize_t w1_f29_read_cond_search_polarity(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	if (count != 1 || off != 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+		W1_F29_REG_COND_SEARCH_POL_SELECT, buf);
+}
+
+static ssize_t w1_f29_read_status_control(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	if (count != 1 || off != 0)
+		return -EFAULT;
+	return _read_reg(kobj_to_w1_slave(kobj),
+		W1_F29_REG_CONTROL_AND_STATUS, buf);
+}
+
+
+
+
+static ssize_t w1_f29_write_output(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	u8 w1_buf[3];
+	u8 readBack;
+	unsigned int retries = W1_F29_RETRIES;
+
+	if (count != 1 || off != 0)
+		return -EFAULT;
+
+	dev_dbg(&sl->dev, "locking mutex for write_output");
+	mutex_lock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex locked");
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	while (retries--) {
+		w1_buf[0] = W1_F29_FUNC_CHANN_ACCESS_WRITE;
+		w1_buf[1] = *buf;
+		w1_buf[2] = ~(*buf);
+		w1_write_block(sl->master, w1_buf, 3);
+
+		readBack = w1_read_8(sl->master);
+		/* here the master could read another byte which
+		   would be the PIO reg (the actual pin logic state)
+		   since in this driver we don't know which pins are
+		   in and outs, there's no value to read the state and
+		   compare. with (*buf) so end this command abruptly: */
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+
+		if (readBack != 0xAA) {
+			/* try again, the slave is ready for a command */
+			continue;
+		}
+
+		/* go read back the output latches */
+		/* (the direct effect of the write above) */
+		w1_buf[0] = W1_F29_FUNC_READ_PIO_REGS;
+		w1_buf[1] = W1_F29_REG_OUTPUT_LATCH_STATE;
+		w1_buf[2] = 0;
+		w1_write_block(sl->master, w1_buf, 3);
+		/* read the result of the READ_PIO_REGS command */
+		if (w1_read_8(sl->master) == *buf) {
+			/* success! */
+			mutex_unlock(&sl->master->mutex);
+			dev_dbg(&sl->dev,
+				"mutex unlocked, retries:%d", retries);
+			return 1;
+		}
+	}
+error:
+	mutex_unlock(&sl->master->mutex);
+	dev_dbg(&sl->dev, "mutex unlocked in error, retries:%d", retries);
+
+	return -EIO;
+}
+
+
+/**
+ * Writing to the activity file resets the activity latches.
+ */
+static ssize_t w1_f29_write_activity(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	unsigned int retries = W1_F29_RETRIES;
+
+	if (count != 1 || off != 0)
+		return -EFAULT;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	while (retries--) {
+		w1_write_8(sl->master, W1_F29_FUNC_RESET_ACTIVITY_LATCHES);
+		if (w1_read_8(sl->master) == W1_F29_SUCCESS_CONFIRM_BYTE) {
+			mutex_unlock(&sl->master->mutex);
+			return 1;
+		}
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+	}
+
+error:
+	mutex_unlock(&sl->master->mutex);
+	return -EIO;
+}
+
+static ssize_t w1_f29_write_status_control(
+	struct file *filp,
+	struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf,
+	loff_t off,
+	size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	u8 w1_buf[4];
+	unsigned int retries = W1_F29_RETRIES;
+
+	if (count != 1 || off != 0)
+		return -EFAULT;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	while (retries--) {
+		w1_buf[0] = W1_F29_FUNC_WRITE_COND_SEARCH_REG;
+		w1_buf[1] = W1_F29_REG_CONTROL_AND_STATUS;
+		w1_buf[2] = 0;
+		w1_buf[3] = *buf;
+
+		w1_write_block(sl->master, w1_buf, 4);
+		if (w1_reset_resume_command(sl->master))
+			goto error;
+
+		w1_buf[0] = W1_F29_FUNC_READ_PIO_REGS;
+		w1_buf[1] = W1_F29_REG_CONTROL_AND_STATUS;
+		w1_buf[2] = 0;
+
+		w1_write_block(sl->master, w1_buf, 3);
+		if (w1_read_8(sl->master) == *buf) {
+			/* success! */
+			mutex_unlock(&sl->master->mutex);
+			return 1;
+		}
+	}
+error:
+	mutex_unlock(&sl->master->mutex);
+
+	return -EIO;
+}
+
+
+
+#define NB_SYSFS_BIN_FILES 6
+static struct bin_attribute w1_f29_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
+	{
+		.attr =	{
+			.name = "state",
+			.mode = S_IRUGO,
+		},
+		.size = 1,
+		.read = w1_f29_read_state,
+	},
+	{
+		.attr =	{
+			.name = "output",
+			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
+		},
+		.size = 1,
+		.read = w1_f29_read_output,
+		.write = w1_f29_write_output,
+	},
+	{
+		.attr =	{
+			.name = "activity",
+			.mode = S_IRUGO,
+		},
+		.size = 1,
+		.read = w1_f29_read_activity,
+		.write = w1_f29_write_activity,
+	},
+	{
+		.attr =	{
+			.name = "cond_search_mask",
+			.mode = S_IRUGO,
+		},
+		.size = 1,
+		.read = w1_f29_read_cond_search_mask,
+		.write = 0,
+	},
+	{
+		.attr =	{
+			.name = "cond_search_polarity",
+			.mode = S_IRUGO,
+		},
+		.size = 1,
+		.read = w1_f29_read_cond_search_polarity,
+		.write = 0,
+	},
+	{
+		.attr =	{
+			.name = "status_control",
+			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
+		},
+		.size = 1,
+		.read = w1_f29_read_status_control,
+		.write = w1_f29_write_status_control,
+	}
+};
+
+static int w1_f29_add_slave(struct w1_slave *sl)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
+		err = sysfs_create_bin_file(
+			&sl->dev.kobj,
+			&(w1_f29_sysfs_bin_files[i]));
+	if (err)
+		while (--i >= 0)
+			sysfs_remove_bin_file(&sl->dev.kobj,
+				&(w1_f29_sysfs_bin_files[i]));
+	return err;
+}
+
+static void w1_f29_remove_slave(struct w1_slave *sl)
+{
+	int i;
+	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
+		sysfs_remove_bin_file(&sl->dev.kobj,
+			&(w1_f29_sysfs_bin_files[i]));
+}
+
+static struct w1_family_ops w1_f29_fops = {
+	.add_slave      = w1_f29_add_slave,
+	.remove_slave   = w1_f29_remove_slave,
+};
+
+static struct w1_family w1_family_29 = {
+	.fid = W1_FAMILY_DS2408,
+	.fops = &w1_f29_fops,
+};
+
+static int __init w1_f29_init(void)
+{
+	return w1_register_family(&w1_family_29);
+}
+
+static void __exit w1_f29_exit(void)
+{
+	w1_unregister_family(&w1_family_29);
+}
+
+module_init(w1_f29_init);
+module_exit(w1_f29_exit);
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index f3b636d..7513759 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -34,6 +34,7 @@
 #define W1_THERM_DS1822  	0x22
 #define W1_EEPROM_DS2433  	0x23
 #define W1_THERM_DS18B20 	0x28
+#define W1_FAMILY_DS2408	0x29
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 
-- 
1.7.4.1

