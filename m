Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2BQMO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:14:57 -0500
Received: from mailbackup.inode.at ([213.229.60.24]:47872 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2BQMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:14:56 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Feb 2012 07:14:55 EST
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, michael@thalmeier.at,
        Michael Thalmeier <michael.thalmeier@hale.at>
Subject: [PATCH 3/3] w1: add slave driver for DS1996 and DS1963L
Date: Fri, 17 Feb 2012 13:07:02 +0100
Message-Id: <1329480422-7616-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: q1HC8Msj024160
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1330085306.53821@/R1U8CQun2Nh25UySqJBWA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Stering <wolfram.stering@hale.at>

This driver adds support for some Dallas non-volatile memory 1-wire slave
devices.

At the moment the following devices are supported:

 * family 0x0c: DS1996 64Kb Memory iButton
 * family 0x1A: DS1963L 4kbit Monetary

Access to memory is done via pages exportedi in sysfs.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/w1/slaves/Kconfig     |   15 +
 drivers/w1/slaves/Makefile    |    1 +
 drivers/w1/slaves/w1_ds1996.c |  610 +++++++++++++++++++++++++++++++++++++++++
 drivers/w1/w1_family.h        |    2 +
 4 files changed, 628 insertions(+), 0 deletions(-)
 create mode 100644 drivers/w1/slaves/w1_ds1996.c

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index d0cb01b..b455d83 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -34,6 +34,21 @@ config W1_SLAVE_DS2423
 	  Say Y here if you want to use a 1-wire
 	  counter family device (DS2423).
 
+config W1_SLAVE_DS1996
+	tristate "64kb Memory iBbutton family support (DS1996)"
+	help
+	  Say Y here if you want to use a 1-wire
+	  64kb Memory iButton family device (DS1996).
+
+config W1_SLAVE_DS1996_CRC
+	bool "Protect DS1996 data with a CRC16"
+	depends on W1_SLAVE_DS1996
+	select CRC16
+	help
+	  Say Y here to protect DS1996 data with a CRC16.
+	  Each block has 30 bytes of data and a two byte CRC16.
+	  Full block writes are only allowed if the CRC is valid.
+
 config W1_SLAVE_DS2431
 	tristate "1kb EEPROM family support (DS2431)"
 	help
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 1f31e9f..b243641 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2408)   += w1_ds2408.o
 obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds2423.o
+obj-$(CONFIG_W1_SLAVE_DS1996)	+= w1_ds1996.o
 obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
diff --git a/drivers/w1/slaves/w1_ds1996.c b/drivers/w1/slaves/w1_ds1996.c
new file mode 100644
index 0000000..5ec18e7
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds1996.c
@@ -0,0 +1,610 @@
+/*
+ *  w1_ds1996.c - w1 family 0C (DS1996) driver
+ *
+ * Copyright (c) 2011 Wolfram Stering <wolfram.stering@hale.at>
+ *
+ * Inspired by Ben Gardner's <bgardner@wabtec.com> family 23 (DS2433) driver.
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
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+#include <linux/crc16.h>
+
+#define CRC16_INIT		0
+#define CRC16_VALID		0xb001
+
+#endif
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Wolfram Stering <wolfram.stering@hale.at>");
+MODULE_DESCRIPTION("w1 family 0C driver for DS1996, 64kb memory iButton");
+
+#define W1_F0C_NVMEM_SIZE	8192
+#define W1_F0C_PAGE_COUNT	256
+
+#define W1_F1A_NVMEM_SIZE	512
+#define W1_F1A_PAGE_COUNT	16
+
+#define W1_PAGE_SIZE		32
+#define W1_PAGE_BITS		5
+#define W1_PAGE_MASK		0x1F
+
+#define W1_READ_EEPROM		0xF0
+#define W1_WRITE_SCRATCH	0x0F
+#define W1_READ_SCRATCH		0xAA
+#define W1_COPY_SCRATCH		0x55
+
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP((nr), BITS_PER_BYTE * sizeof(u8))
+
+struct page_attribute {
+	struct bin_attribute	bin_attr;
+	int			pagenr;
+	char			name[10];	/* space for 'page.NNNN\0' */
+};
+
+struct w1_nvmem_data {
+	int			nr_pages;
+	struct page_attribute	*pages_attrs;	/* sysfs binary page files */
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	u8			cache[0];	/* cache bitmap starts here. */
+#define CACHE_BITMAP_ADDR(d)	((unsigned long *)(d)->cache)
+#define CACHE_BITMAP_SIZE(d)	(BITS_TO_LONGS((d)->nr_pages) \
+				* sizeof(unsigned long))
+#define CACHE_DATA_ADDR(d)	((d)->cache + CACHE_BITMAP_SIZE(d))
+#endif
+};
+
+struct w1_f0c_data {
+	struct w1_nvmem_data	nv_data;
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	/* One bit per page; if set, respective page in cache is valid. */
+	DECLARE_BITMAP(validcrc, W1_F0C_PAGE_COUNT);
+	u8			memory[W1_F0C_NVMEM_SIZE];
+#endif
+};
+
+struct w1_f1a_data {
+	struct w1_nvmem_data	nv_data;
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	/* One bit per page; if set, respective page in cache is valid. */
+	DECLARE_BITMAP(validcrc, W1_F1A_PAGE_COUNT);
+	u8			memory[W1_F1A_NVMEM_SIZE];
+#endif
+};
+
+
+/*
+ * Check the file size bounds and adjusts count as needed.
+ * This would not be needed if the file size didn't reset to 0 after a write.
+ */
+static inline size_t w1_nvmem_fix_count(loff_t off, size_t count, size_t size)
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
+/*
+ * Read directly from a slave's non-volatile memory.
+ */
+static int w1_nvmem_read(struct w1_slave *sl, char *buf,
+			 loff_t off, size_t count)
+{
+	u8	wrbuf[3];
+
+	if (w1_reset_select_slave(sl))
+		return -EIO;
+
+	wrbuf[0] = W1_READ_EEPROM;
+	wrbuf[1] = off & 0xff;
+	wrbuf[2] = off >> 8;
+	w1_write_block(sl->master, wrbuf, 3);
+	w1_read_block(sl->master, buf, count);
+
+	return 0;
+}
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+static int w1_nvmem_refresh_block(struct w1_slave *sl,
+				  struct w1_nvmem_data *data,
+				  int block)
+{
+	int	off = block * W1_PAGE_SIZE;
+	int	crc;
+
+	if (test_bit(block, CACHE_BITMAP_ADDR(data)))
+		return 0;
+
+	if (w1_nvmem_read(sl, CACHE_DATA_ADDR(data) + off, off, W1_PAGE_SIZE)) {
+		memset(data->cache, 0, CACHE_BITMAP_SIZE(data));
+		return -EIO;
+	}
+
+	/* cache the block if the CRC is valid */
+	crc = crc16(CRC16_INIT, CACHE_DATA_ADDR(data) + off, W1_PAGE_SIZE);
+	if (crc == CRC16_VALID)
+		__set_bit(block, CACHE_BITMAP_ADDR(data));
+
+	return 0;
+}
+#endif	/* CONFIG_W1_SLAVE_DS1996_CRC */
+
+static ssize_t w1_nvmem_read_bin(struct file *filp, struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	struct page_attribute *pa = bin_attr->private;
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	struct w1_nvmem_data *data = sl->family_data;
+	int i, min_page, max_page;
+#endif
+
+	if (pa == NULL) {
+		/* read from the 'nvmem' bin file. */
+		count = w1_nvmem_fix_count(off,
+					   count,
+					   data->nr_pages << W1_PAGE_BITS);
+		if (count == 0)
+			return 0;
+	} else {
+		/* read from a 'page.NNN' bin file. */
+		count = w1_nvmem_fix_count(off, count, W1_PAGE_SIZE);
+		if (count == 0)
+			return 0;
+		off += pa->pagenr * W1_PAGE_SIZE;
+	}
+
+	mutex_lock(&sl->master->mutex);
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	min_page = (off >> W1_PAGE_BITS);
+	max_page = (off + count - 1) >> W1_PAGE_BITS;
+	for (i = min_page; i <= max_page; i++) {
+		if (w1_nvmem_refresh_block(sl, data, i)) {
+			count = -EIO;
+			goto out_up;
+		}
+	}
+	memcpy(buf, CACHE_DATA_ADDR(data) + off, count);
+
+#else	/* CONFIG_W1_SLAVE_DS1996_CRC */
+
+	/* read directly from the EEPROM */
+	if (w1_nvmem_read(sl, buf, off, count)) {
+		count = -EIO;
+		goto out_up;
+	}
+#endif	/* CONFIG_W1_SLAVE_DS1996_CRC */
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
+static int w1_nvmem_write(struct w1_slave *sl,
+			  int addr,
+			  int len,
+			  const u8 *data)
+{
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	struct w1_nvmem_data *nvd = sl->family_data;
+#endif
+	u8 wrbuf[4];
+	u8 rdbuf[W1_PAGE_SIZE + 3];
+	u8 es = (addr + len - 1) & 0x1f;
+
+	/* Write the data to the scratchpad */
+	if (w1_reset_select_slave(sl))
+		return -1;
+
+	wrbuf[0] = W1_WRITE_SCRATCH;
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
+	w1_write_8(sl->master, W1_READ_SCRATCH);
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
+	wrbuf[0] = W1_COPY_SCRATCH;
+	wrbuf[3] = es;
+	w1_write_block(sl->master, wrbuf, 4);
+
+	/* Sleep for 5 ms to wait for the write to complete */
+	msleep(5);
+
+	/* Reset the bus to wake up the EEPROM (this may not be needed) */
+	w1_reset_bus(sl->master);
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	__clear_bit(addr >> W1_PAGE_BITS, CACHE_BITMAP_ADDR(nvd));
+#endif
+	return 0;
+}
+
+static ssize_t w1_nvmem_write_bin(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	struct page_attribute *pa = bin_attr->private;
+	struct w1_nvmem_data *data = sl->family_data;
+	int addr, len, idx;
+
+dev_info(&sl->dev, "%s - off %llu, count %zd.\n", __func__, off, count);
+
+	if (pa == NULL) {
+		/* write to the 'nvmem' bin file. */
+		count = w1_nvmem_fix_count(off,
+					   count,
+					   data->nr_pages << W1_PAGE_BITS);
+		if (count == 0)
+			return 0;
+	} else {
+		/* write to a 'page.NNN' bin file. */
+		count = w1_nvmem_fix_count(off, count, W1_PAGE_SIZE);
+		if (count == 0)
+			return 0;
+		off += pa->pagenr * W1_PAGE_SIZE;
+	}
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	/* can only write full blocks in cached mode */
+	if ((off & W1_PAGE_MASK) || (count & W1_PAGE_MASK)) {
+		dev_err(&sl->dev, "invalid offset/count off=%d cnt=%zd\n",
+			(int)off, count);
+		return -EINVAL;
+	}
+
+	/* make sure the block CRCs are valid */
+	for (idx = 0; idx < count; idx += W1_PAGE_SIZE) {
+		if (crc16(CRC16_INIT, &buf[idx], W1_PAGE_SIZE) != CRC16_VALID) {
+			dev_err(&sl->dev, "bad CRC at offset %d, expected %#x, got %#x (%#x,%#x)\n",
+				(int)off,
+				(u16)~crc16(CRC16_INIT, &buf[idx],
+					W1_PAGE_SIZE - 2),
+				*((u16 *)&buf[idx+W1_PAGE_SIZE-2]),
+				(u16)crc16(CRC16_INIT, &buf[idx], W1_PAGE_SIZE),
+				CRC16_VALID);
+			return -EINVAL;
+		}
+	}
+#endif	/* CONFIG_W1_SLAVE_DS1996_CRC */
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
+		if (w1_nvmem_write(sl, addr, len, &buf[idx]) < 0) {
+			count = -EIO;
+			goto out_up;
+		}
+		idx += len;
+	}
+
+out_up:
+	mutex_unlock(&sl->master->mutex);
+dev_info(&sl->dev, "write done, count %zd\n", count);
+	return count;
+}
+
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+
+static ssize_t w1_cache_read_bin(struct file *filp, struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	struct w1_nvmem_data *data = sl->family_data;
+
+	count = w1_nvmem_fix_count(off, count, CACHE_BITMAP_SIZE(data));
+	if (count == 0)
+		return 0;
+
+	memcpy(buf, data->cache + off, count);
+	return count;
+}
+#endif
+
+static void setup_page_attr(struct page_attribute *pf, int pn)
+{
+	snprintf(pf->name, sizeof pf->name, "page.%03d", pn);
+	pf->pagenr = pn;
+	attr_name(pf->bin_attr) = pf->name;
+	pf->bin_attr.attr.mode = 0660;
+	pf->bin_attr.size = W1_PAGE_SIZE;
+	pf->bin_attr.private = pf;
+	pf->bin_attr.read = w1_nvmem_read_bin;
+	pf->bin_attr.write = w1_nvmem_write_bin;
+	pf->bin_attr.mmap = NULL;
+}
+
+static void destroy_pages_attrs(struct w1_slave *sl)
+{
+	struct w1_nvmem_data *fdata = sl->family_data;
+	int i;
+
+	for (i = 0; i < fdata->nr_pages; ++i)
+		if (attr_name(fdata->pages_attrs[i].bin_attr))
+			sysfs_remove_bin_file(&sl->dev.kobj,
+				&fdata->pages_attrs[i].bin_attr);
+
+	kfree(fdata->pages_attrs);
+	fdata->pages_attrs = NULL;
+}
+
+static int create_pages_attrs(struct w1_slave *sl)
+{
+	struct w1_nvmem_data *fdata = sl->family_data;
+	int i, error;
+
+	if (!fdata || fdata->nr_pages == 0)
+		return 0;
+
+	fdata->pages_attrs =
+		kzalloc(fdata->nr_pages * sizeof(struct page_attribute),
+			GFP_KERNEL);
+	if (!fdata->pages_attrs)
+		return -ENOMEM;
+
+	for (i = error = 0; i < fdata->nr_pages && !error; ++i) {
+		setup_page_attr(&fdata->pages_attrs[i], i);
+		error = sysfs_create_bin_file(&sl->dev.kobj,
+					      &fdata->pages_attrs[i].bin_attr);
+	}
+
+	dev_dbg(&sl->dev, "Created %d pages: %02x-%012llx: error=%d\n",
+		i, sl->reg_num.family, (unsigned long long)sl->reg_num.id,
+		error);
+
+	if (!error)
+		return 0;
+
+	destroy_pages_attrs(sl);
+	return error;
+}
+
+
+/*
+ * DS1996 -- 64kb Memory iButton, family 0x0C.
+ */
+
+static struct bin_attribute w1_f0c_bin_attr[] = {
+	{
+		.attr = {
+			.name = "nvmem",
+			.mode = S_IRUGO | S_IWUSR,
+		},
+		.size = W1_F0C_NVMEM_SIZE,
+		.read = w1_nvmem_read_bin,
+		.write = w1_nvmem_write_bin,
+	},
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	{
+		.attr = {
+			.name = "cache",
+			.mode = 0440,
+		},
+		.size = BITS_TO_BYTES(W1_F0C_PAGE_COUNT),
+		.read = w1_cache_read_bin,
+		.write = NULL,
+	},
+#endif
+};
+
+static int w1_f0c_add_slave(struct w1_slave *sl)
+{
+	int err;
+	struct w1_f0c_data *data;
+
+	data = kzalloc(sizeof(struct w1_f0c_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	data->nv_data.nr_pages = W1_F0C_PAGE_COUNT;
+	sl->family_data = data;
+
+	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f0c_bin_attr[0]);
+	if (err)
+		goto out_err;
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f0c_bin_attr[1]);
+	if (err)
+		goto out_err_nvmem;
+#endif
+	err = create_pages_attrs(sl);
+	if (!err)
+		return 0;
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f0c_bin_attr[1]);
+out_err_nvmem:
+#endif
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f0c_bin_attr[0]);
+out_err:
+	kfree(data);
+	return err;
+}
+
+static void w1_f0c_remove_slave(struct w1_slave *sl)
+{
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f0c_bin_attr[0]);
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f0c_bin_attr[1]);
+#endif
+	destroy_pages_attrs(sl);
+
+	kfree(sl->family_data);
+	sl->family_data = NULL;
+}
+
+static struct w1_family_ops w1_f0c_fops = {
+	.add_slave      = w1_f0c_add_slave,
+	.remove_slave   = w1_f0c_remove_slave,
+};
+
+static struct w1_family w1_family_0c = {
+	.fid = W1_EEPROM_DS1996,
+	.fops = &w1_f0c_fops,
+};
+
+
+static struct bin_attribute w1_f1a_bin_attr[] = {
+	{
+		.attr = {
+			.name = "nvmem",
+			.mode = S_IRUGO | S_IWUSR,
+		},
+		.size = W1_F1A_NVMEM_SIZE,
+		.read = w1_nvmem_read_bin,
+		.write = w1_nvmem_write_bin,
+	},
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	{
+		.attr = {
+			.name = "cache",
+			.mode = 0440,
+		},
+		.size = BITS_TO_BYTES(W1_F1A_PAGE_COUNT),
+		.read = w1_cache_read_bin,
+		.write = NULL,
+	},
+#endif
+};
+
+
+/*
+ * DS1963L -- Monetary iButton, family 0x1A.
+ */
+
+static int w1_f1a_add_slave(struct w1_slave *sl)
+{
+	int err;
+	struct w1_f1a_data *data;
+
+	data = kzalloc(sizeof(struct w1_f1a_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	data->nv_data.nr_pages = W1_F1A_PAGE_COUNT;
+	sl->family_data = data;
+
+	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f1a_bin_attr[0]);
+	if (err)
+		goto out_err;
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f1a_bin_attr[1]);
+	if (err)
+		goto out_err_nvmem;
+#endif
+	err = create_pages_attrs(sl);
+	if (!err)
+		return 0;
+
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f1a_bin_attr[1]);
+out_err_nvmem:
+#endif
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f1a_bin_attr[0]);
+out_err:
+	kfree(data);
+	return err;
+}
+
+static void w1_f1a_remove_slave(struct w1_slave *sl)
+{
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f1a_bin_attr[0]);
+#ifdef CONFIG_W1_SLAVE_DS1996_CRC
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f1a_bin_attr[1]);
+#endif
+	destroy_pages_attrs(sl);
+
+	kfree(sl->family_data);
+	sl->family_data = NULL;
+}
+
+static struct w1_family_ops w1_f1a_fops = {
+	.add_slave      = w1_f1a_add_slave,
+	.remove_slave   = w1_f1a_remove_slave,
+};
+
+static struct w1_family w1_family_1a = {
+	.fid = W1_FAMILY_DS1963L,
+	.fops = &w1_f1a_fops,
+};
+
+
+static int __init w1_nvmem_init(void)
+{
+	int err = w1_register_family(&w1_family_0c);
+	printk(KERN_INFO "w1 nvmem slave driver; %d, 0C: %d, 1A: %d bytes.\n",
+		sizeof(struct w1_nvmem_data), sizeof(struct w1_f0c_data),
+		sizeof(struct w1_f1a_data));
+	if (!err) {
+		err = w1_register_family(&w1_family_1a);
+		if (err)
+			w1_unregister_family(&w1_family_0c);
+	}
+	return err;
+}
+
+static void __exit w1_nvmem_fini(void)
+{
+	w1_unregister_family(&w1_family_1a);
+	w1_unregister_family(&w1_family_0c);
+}
+
+module_init(w1_nvmem_init);
+module_exit(w1_nvmem_fini);
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 490cda2..3724048 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -39,6 +39,8 @@
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
 #define W1_THERM_DS28EA00	0x42
+#define W1_EEPROM_DS1996	0x0C
+#define W1_FAMILY_DS1963L	0x1A
 
 #define MAXNAMELEN		32
 
-- 
1.7.7.6



--
Scanned by MailScanner.

