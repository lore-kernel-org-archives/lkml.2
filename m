Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab2EJW6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:58:06 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58763 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2EJW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:58:03 -0400
Message-ID: <4FAC47F6.6080903@hrz.tu-chemnitz.de>
Date: Fri, 11 May 2012 00:57:58 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120503180056.GB13988@ioremap.net> <4FAAD584.70102@hrz.tu-chemnitz.de> <20120509220636.GA27659@kroah.com> <4FAAECB7.8070904@hrz.tu-chemnitz.de> <20120509222411.GA24302@kroah.com> <4FAAF1C4.2050500@hrz.tu-chemnitz.de> <20120509235723.GA7404@ioremap.net> <20120510000126.GA2357@kroah.com> <20120510004350.GA8362@ioremap.net> <4FAB4A4D.8080901@hrz.tu-chemnitz.de> <20120510151639.GE17472@kroah.com>
In-Reply-To: <20120510151639.GE17472@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: nick.hrz.tu-chemnitz.de;2012-05-11 00:58:00;59021116f51b2100a81ccba75bbaf87c
X-Scan-SA: nick.hrz.tu-chemnitz.de;2012-05-11 00:58:01;a99b27aa6a13fd28e15033febbc7d8f4
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

Am 10.05.2012 17:16, schrieb Greg KH:

> I don't remember anything anymore, you will have to send the patch for
> me to be able to properly review it and determine this.


here comes the updated patch.

>From 3ef34f86788bfe39fa5bdb07b7e0598d3fda1f4f Mon Sep 17 00:00:00 2001
From: Markus Franke <franm@hrz.tu-chemnitz.de>
Date: Fri, 11 May 2012 00:41:35 +0200
Subject: [PATCH] Add 1-wire slave device driver for DS28E04-100


Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>
---
 Documentation/w1/slaves/w1_ds28e04 |   36 +++
 drivers/w1/slaves/Kconfig          |   13 +
 drivers/w1/slaves/Makefile         |    1 +
 drivers/w1/slaves/w1_ds28e04.c     |  476 ++++++++++++++++++++++++++++++++++++
 drivers/w1/w1_family.h             |    1 +
 5 files changed, 527 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/w1/slaves/w1_ds28e04
 create mode 100644 drivers/w1/slaves/w1_ds28e04.c

diff --git a/Documentation/w1/slaves/w1_ds28e04 b/Documentation/w1/slaves/w1_ds28e04
new file mode 100644
index 0000000..7d5993c
--- /dev/null
+++ b/Documentation/w1/slaves/w1_ds28e04
@@ -0,0 +1,36 @@
+Kernel driver w1_ds28e04
+========================
+
+Supported chips:
+  * Maxim DS28E04-100 4096-Bit Addressable 1-Wire EEPROM with PIO
+
+supported family codes:
+	W1_FAMILY_DS28E04	0x1C
+
+Author: Markus Franke, <franke.m@sebakmt.com> <franm@hrz.tu-chemnitz.de>
+
+Description
+-----------
+
+Support is provided through the sysfs files "eeprom" and "pio". CRC checking
+during memory accesses can optionally be enabled/disabled via the device
+attribute "crccheck". The strong pull-up can optionally be enabled/disabled
+via the module parameter "w1_strong_pullup".
+
+Memory Access
+
+	A read operation on the "eeprom" file reads the given amount of bytes
+	from the EEPROM of the DS28E04.
+
+	A write operation on the "eeprom" file writes the given byte sequence
+	to the EEPROM of the DS28E04. If CRC checking mode is enabled only
+	fully alligned blocks of 32 bytes with valid CRC16 values (in bytes 30
+	and 31) are allowed to be written.
+
+PIO Access
+
+	The 2 PIOs of the DS28E04-100 are accessible via the "pio" sysfs file.
+
+	The current status of the PIO's is returned as an 8 bit value. Bit 0/1
+	represent the state of PIO_0/PIO_1. Bits 2..7 do not care. The PIO's are
+	driven low-active, i.e. the driver delivers/expects low-active values.
diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index eb9e376..6752669 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -94,6 +94,19 @@ config W1_SLAVE_DS2781
 
 	  If you are unsure, say N.
 
+config W1_SLAVE_DS28E04
+	tristate "4096-Bit Addressable 1-Wire EEPROM with PIO (DS28E04-100)"
+	depends on W1
+	select CRC16
+	help
+	  If you enable this you will have the DS28E04-100
+	  chip support.
+
+	  Say Y here if you want to use a 1-wire
+	  4kb EEPROM with PIO family device (DS28E04).
+
+	  If you are unsure, say N.
+
 config W1_SLAVE_BQ27000
 	tristate "BQ27000 slave support"
 	depends on W1
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index c4f1859..05188f6 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
 obj-$(CONFIG_W1_SLAVE_DS2780)	+= w1_ds2780.o
 obj-$(CONFIG_W1_SLAVE_DS2781)	+= w1_ds2781.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
+obj-$(CONFIG_W1_SLAVE_DS28E04)	+= w1_ds28e04.o
diff --git a/drivers/w1/slaves/w1_ds28e04.c b/drivers/w1/slaves/w1_ds28e04.c
new file mode 100644
index 0000000..56bad73
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -0,0 +1,476 @@
+/*
+ *	w1_ds28e04.c - w1 family 1C (DS28E04) driver
+ *
+ * Copyright (c) 2012 Markus Franke <franke.m@sebakmt.com>
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
+#include <linux/crc16.h>
+#include <linux/uaccess.h>
+
+#define CRC16_INIT		0
+#define CRC16_VALID		0xb001
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Markus Franke <franke.m@sebakmt.com>, <franm@hrz.tu-chemnitz.de>");
+MODULE_DESCRIPTION("w1 family 1C driver for DS28E04, 4kb EEPROM and PIO");
+
+/* Allow the strong pullup to be disabled, but default to enabled.
+ * If it was disabled a parasite powered device might not get the required
+ * current to copy the data from the scratchpad to EEPROM.  If it is enabled
+ * parasite powered devices have a better chance of getting the current
+ * required.
+ */
+static int w1_strong_pullup = 1;
+module_param_named(strong_pullup, w1_strong_pullup, int, 0);
+
+/* enable/disable CRC checking on DS28E04-100 memory accesses */
+static char w1_enable_crccheck = 1;
+
+#define W1_EEPROM_SIZE		512
+#define W1_PAGE_COUNT		16
+#define W1_PAGE_SIZE		32
+#define W1_PAGE_BITS		5
+#define W1_PAGE_MASK		0x1F
+
+#define W1_F1C_READ_EEPROM	0xF0
+#define W1_F1C_WRITE_SCRATCH	0x0F
+#define W1_F1C_READ_SCRATCH	0xAA
+#define W1_F1C_COPY_SCRATCH	0x55
+#define W1_F1C_ACCESS_WRITE	0x5A
+
+#define W1_1C_REG_LOGIC_STATE	0x220
+
+struct w1_f1C_data {
+	u8	memory[W1_EEPROM_SIZE];
+	u32	validcrc;
+};
+
+/**
+ * Check the file size bounds and adjusts count as needed.
+ * This would not be needed if the file size didn't reset to 0 after a write.
+ */
+static inline size_t w1_f1C_fix_count(loff_t off, size_t count, size_t size)
+{
+	if (off > size)
+		return 0;
+
+	if ((off + count) > size)
+		return size - off;
+
+	return count;
+}
+
+static int w1_f1C_refresh_block(struct w1_slave *sl, struct w1_f1C_data *data,
+				int block)
+{
+	u8	wrbuf[3];
+	int	off = block * W1_PAGE_SIZE;
+
+	if (data->validcrc & (1 << block))
+		return 0;
+
+	if (w1_reset_select_slave(sl)) {
+		data->validcrc = 0;
+		return -EIO;
+	}
+
+	wrbuf[0] = W1_F1C_READ_EEPROM;
+	wrbuf[1] = off & 0xff;
+	wrbuf[2] = off >> 8;
+	w1_write_block(sl->master, wrbuf, 3);
+	w1_read_block(sl->master, &data->memory[off], W1_PAGE_SIZE);
+
+	/* cache the block if the CRC is valid */
+	if (crc16(CRC16_INIT, &data->memory[off], W1_PAGE_SIZE) == CRC16_VALID)
+		data->validcrc |= (1 << block);
+
+	return 0;
+}
+
+static int w1_f1C_read(struct w1_slave *sl, int addr, int len, char *data)
+{
+	u8 wrbuf[3];
+
+	/* read directly from the EEPROM */
+	if (w1_reset_select_slave(sl))
+		return -EIO;
+
+	wrbuf[0] = W1_F1C_READ_EEPROM;
+	wrbuf[1] = addr & 0xff;
+	wrbuf[2] = addr >> 8;
+
+	w1_write_block(sl->master, wrbuf, sizeof(wrbuf));
+	return w1_read_block(sl->master, data, len);
+}
+
+static ssize_t w1_f1C_read_bin(struct file *filp, struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	struct w1_f1C_data *data = sl->family_data;
+	int i, min_page, max_page;
+
+	count = w1_f1C_fix_count(off, count, W1_EEPROM_SIZE);
+	if (count == 0)
+		return 0;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_enable_crccheck) {
+		min_page = (off >> W1_PAGE_BITS);
+		max_page = (off + count - 1) >> W1_PAGE_BITS;
+		for (i = min_page; i <= max_page; i++) {
+			if (w1_f1C_refresh_block(sl, data, i)) {
+				count = -EIO;
+				goto out_up;
+			}
+		}
+		memcpy(buf, &data->memory[off], count);
+	} else {
+		count = w1_f1C_read(sl, off, count, buf);
+	}
+
+out_up:
+	mutex_unlock(&sl->master->mutex);
+
+	return count;
+}
+
+/**
+ * Writes to the scratchpad and reads it back for verification.
+ * Then copies the scratchpad to EEPROM.
+ * The data must be on one page.
+ * The master must be locked.
+ *
+ * @param sl	The slave structure
+ * @param addr	Address for the write
+ * @param len   length must be <= (W1_PAGE_SIZE - (addr & W1_PAGE_MASK))
+ * @param data	The data to write
+ * @return	0=Success -1=failure
+ */
+static int w1_f1C_write(struct w1_slave *sl, int addr, int len, const u8 *data)
+{
+	u8 wrbuf[4];
+	u8 rdbuf[W1_PAGE_SIZE + 3];
+	u8 es = (addr + len - 1) & 0x1f;
+	unsigned int tm = 10;
+	int i;
+	struct w1_f1C_data *f1C = sl->family_data;
+
+	/* Write the data to the scratchpad */
+	if (w1_reset_select_slave(sl))
+		return -1;
+
+	wrbuf[0] = W1_F1C_WRITE_SCRATCH;
+	wrbuf[1] = addr & 0xff;
+	wrbuf[2] = addr >> 8;
+
+	w1_write_block(sl->master, wrbuf, 3);
+	w1_write_block(sl->master, data, len);
+
+	/* Read the scratchpad and verify */
+	if (w1_reset_select_slave(sl))
+		return -1;
+
+	w1_write_8(sl->master, W1_F1C_READ_SCRATCH);
+	w1_read_block(sl->master, rdbuf, len + 3);
+
+	/* Compare what was read against the data written */
+	if ((rdbuf[0] != wrbuf[1]) || (rdbuf[1] != wrbuf[2]) ||
+	    (rdbuf[2] != es) || (memcmp(data, &rdbuf[3], len) != 0))
+		return -1;
+
+	/* Copy the scratchpad to EEPROM */
+	if (w1_reset_select_slave(sl))
+		return -1;
+
+	wrbuf[0] = W1_F1C_COPY_SCRATCH;
+	wrbuf[3] = es;
+
+	for (i = 0; i < sizeof(wrbuf); ++i) {
+		/* issue 10ms strong pullup (or delay) on the last byte
+		   for writing the data from the scratchpad to EEPROM */
+		if (w1_strong_pullup && i == sizeof(wrbuf)-1)
+			w1_next_pullup(sl->master, tm);
+
+		w1_write_8(sl->master, wrbuf[i]);
+	}
+
+	if (!w1_strong_pullup)
+		msleep(tm);
+
+	if (w1_enable_crccheck) {
+		/* invalidate cached data */
+		f1C->validcrc &= ~(1 << (addr >> W1_PAGE_BITS));
+	}
+
+	/* Reset the bus to wake up the EEPROM (this may not be needed) */
+	w1_reset_bus(sl->master);
+
+	return 0;
+}
+
+static ssize_t w1_f1C_write_bin(struct file *filp, struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
+
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	int addr, len, idx;
+
+	count = w1_f1C_fix_count(off, count, W1_EEPROM_SIZE);
+	if (count == 0)
+		return 0;
+
+	if (w1_enable_crccheck) {
+		/* can only write full blocks in cached mode */
+		if ((off & W1_PAGE_MASK) || (count & W1_PAGE_MASK)) {
+			dev_err(&sl->dev, "invalid offset/count off=%d cnt=%zd\n",
+				(int)off, count);
+			return -EINVAL;
+		}
+
+		/* make sure the block CRCs are valid */
+		for (idx = 0; idx < count; idx += W1_PAGE_SIZE) {
+			if (crc16(CRC16_INIT, &buf[idx], W1_PAGE_SIZE)
+				!= CRC16_VALID) {
+				dev_err(&sl->dev, "bad CRC at offset %d\n",
+					(int)off);
+				return -EINVAL;
+			}
+		}
+	}
+
+	mutex_lock(&sl->master->mutex);
+
+	/* Can only write data to one page at a time */
+	idx = 0;
+	while (idx < count) {
+		addr = off + idx;
+		len = W1_PAGE_SIZE - (addr & W1_PAGE_MASK);
+		if (len > (count - idx))
+			len = count - idx;
+
+		if (w1_f1C_write(sl, addr, len, &buf[idx]) < 0) {
+			count = -EIO;
+			goto out_up;
+		}
+		idx += len;
+	}
+
+out_up:
+	mutex_unlock(&sl->master->mutex);
+
+	return count;
+}
+
+static ssize_t w1_f1C_read_pio(struct file *filp, struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
+
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	int ret;
+
+	/* check arguments */
+	if (off != 0 || count != 1 || buf == NULL)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+	ret = w1_f1C_read(sl, W1_1C_REG_LOGIC_STATE, count, buf);
+	mutex_unlock(&sl->master->mutex);
+
+	return ret;
+}
+
+static ssize_t w1_f1C_write_pio(struct file *filp, struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	u8 wrbuf[3];
+	u8 ack;
+
+	/* check arguments */
+	if (off != 0 || count != 1 || buf == NULL)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+
+	/* Write the PIO data */
+	if (w1_reset_select_slave(sl)) {
+		mutex_unlock(&sl->master->mutex);
+		return -1;
+	}
+
+	/* set bit 7..2 to value '1' */
+	*buf = *buf | 0xFC;
+
+	wrbuf[0] = W1_F1C_ACCESS_WRITE;
+	wrbuf[1] = *buf;
+	wrbuf[2] = ~(*buf);
+	w1_write_block(sl->master, wrbuf, 3);
+
+	w1_read_block(sl->master, &ack, sizeof(ack));
+
+	mutex_unlock(&sl->master->mutex);
+
+	/* check for acknowledgement */
+	if (ack != 0xAA)
+		return -EIO;
+
+	return count;
+}
+
+static ssize_t w1_f1C_show_crccheck(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	if (put_user(w1_enable_crccheck + 0x30, buf))
+		return -EFAULT;
+
+	return sizeof(w1_enable_crccheck);
+}
+
+static ssize_t w1_f1C_store_crccheck(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	char val;
+
+	if (count != 1 || !buf)
+		return -EINVAL;
+
+	if (get_user(val, buf))
+		return -EFAULT;
+
+	/* convert to decimal */
+	val = val - 0x30;
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
+	/* set the new value */
+	w1_enable_crccheck = val;
+
+	return sizeof(w1_enable_crccheck);
+}
+
+#define NB_SYSFS_BIN_FILES 2
+static struct bin_attribute w1_f1C_bin_attr[NB_SYSFS_BIN_FILES] = {
+	{
+		.attr = {
+			.name = "eeprom",
+			.mode = S_IRUGO | S_IWUSR,
+		},
+		.size = W1_EEPROM_SIZE,
+		.read = w1_f1C_read_bin,
+		.write = w1_f1C_write_bin,
+	},
+	{
+		.attr = {
+			.name = "pio",
+			.mode = S_IRUGO | S_IWUSR,
+		},
+		.size = 1,
+		.read = w1_f1C_read_pio,
+		.write = w1_f1C_write_pio,
+	}
+};
+
+static DEVICE_ATTR(crccheck, S_IWUSR | S_IRUGO,
+		   w1_f1C_show_crccheck, w1_f1C_store_crccheck);
+
+static int w1_f1C_add_slave(struct w1_slave *sl)
+{
+	int err = 0;
+	int i;
+	struct w1_f1C_data *data = NULL;
+
+	if (w1_enable_crccheck) {
+		data = kzalloc(sizeof(struct w1_f1C_data), GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+		sl->family_data = data;
+	}
+
+	/* create binary sysfs attributes */
+	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
+		err = sysfs_create_bin_file(
+			&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
+
+	if (err)
+		goto out;
+
+	/* create device attributes */
+	err = device_create_file(&sl->dev, &dev_attr_crccheck);
+
+	if (err) {
+		/* remove binary sysfs attributes */
+		for (i = 0; i < NB_SYSFS_BIN_FILES; ++i)
+			sysfs_remove_bin_file(
+				&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
+	}
+
+out:
+	if (err) {
+		if (w1_enable_crccheck)
+			kfree(data);
+	}
+
+	return err;
+}
+
+static void w1_f1C_remove_slave(struct w1_slave *sl)
+{
+	int i;
+
+	if (w1_enable_crccheck) {
+		kfree(sl->family_data);
+		sl->family_data = NULL;
+	}
+
+	/* remove device attributes */
+	device_remove_file(&sl->dev, &dev_attr_crccheck);
+
+	/* remove binary sysfs attributes */
+	for (i = 0; i < NB_SYSFS_BIN_FILES; ++i)
+		sysfs_remove_bin_file(&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
+}
+
+static struct w1_family_ops w1_f1C_fops = {
+	.add_slave      = w1_f1C_add_slave,
+	.remove_slave   = w1_f1C_remove_slave,
+};
+
+static struct w1_family w1_family_1C = {
+	.fid = W1_FAMILY_DS28E04,
+	.fops = &w1_f1C_fops,
+};
+
+static int __init w1_f1C_init(void)
+{
+	return w1_register_family(&w1_family_1C);
+}
+
+static void __exit w1_f1C_fini(void)
+{
+	w1_unregister_family(&w1_family_1C);
+}
+
+module_init(w1_f1C_init);
+module_exit(w1_f1C_fini);
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 874aeb0..b00ada4 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -30,6 +30,7 @@
 #define W1_FAMILY_SMEM_01	0x01
 #define W1_FAMILY_SMEM_81	0x81
 #define W1_THERM_DS18S20 	0x10
+#define W1_FAMILY_DS28E04	0x1C
 #define W1_COUNTER_DS2423	0x1D
 #define W1_THERM_DS1822  	0x22
 #define W1_EEPROM_DS2433  	0x23
-- 
1.7.5.4
