Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1BGOLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:11:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1BGOLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=juQfpZ4guPnfzlbzvbR4eSop4zSvlVU6kixuUhKesyPK3GfodMKjYa34Cz1UkHhiFp
         w701lmh0W8ZU/Dof5hUmoz4zeq0Hq3jl20K+MSb5WlzBuM1VByhsiBwJ3eJclwsjkdGD
         xBhdKFwcPc+45W4d+ciD98EkgiixQVg2ayhLY=
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Ivan Djelic <ivan.djelic@parrot.com>
Subject: [PATCH/RFC v2 2/3] mtd: nand: add software BCH ECC support
Date: Mon,  7 Feb 2011 15:09:31 +0100
Message-Id: <060c60bb01986bfccdb314a9fba218745c758d28.2296641159.git.ivan.djelic@parrot.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds software BCH ECC support to mtd, in order to handle recent
NAND device ecc requirements (4 bits or more).

It does so by adding a new ecc mode (NAND_ECC_SOFT_BCH) for use by board
drivers, and a new Kconfig option to enable BCH support. It relies on the
generic BCH library introduced in a previous patch.

When a board driver uses mode NAND_ECC_SOFT_BCH, it should also set fields
chip->ecc.size and chip->ecc.bytes to select BCH ecc data size and required
error correction capability. See nand_bch_init() documentation for details.

It has been tested on the following platforms using mtd-utils, UBI and
UBIFS: x86 (with nandsim), arm926ejs.

Signed-off-by: Ivan Djelic <ivan.djelic@parrot.com>
---
v2 changelog:
- do not handle small page devices as we do not provide ecc layouts for them

 drivers/mtd/nand/Kconfig     |   15 +++
 drivers/mtd/nand/Makefile    |    1 +
 drivers/mtd/nand/nand_base.c |   40 +++++++-
 drivers/mtd/nand/nand_bch.c  |  245 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h     |    3 +
 include/linux/mtd/nand_bch.h |   74 +++++++++++++
 6 files changed, 377 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mtd/nand/nand_bch.c
 create mode 100644 include/linux/mtd/nand_bch.h

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index c895922..78205ac 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -31,6 +31,21 @@ config MTD_NAND_VERIFY_WRITE
 	  device thinks the write was successful, a bit could have been
 	  flipped accidentally due to device wear or something else.
 
+config MTD_NAND_BCH
+	tristate
+	select BCH
+	depends on MTD_NAND_ECC_BCH
+	default MTD_NAND
+
+config MTD_NAND_ECC_BCH
+	bool "Support software BCH ECC"
+	default n
+	help
+	  This enables support for software BCH error correction. Binary BCH
+	  codes are more powerful and cpu intensive than traditional Hamming
+	  ECC codes. They are used with NAND devices requiring more than 1 bit
+	  of error correction.
+
 config MTD_SM_COMMON
 	tristate
 	default n
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 8ad6fae..5745d83 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_MTD_NAND)			+= nand.o
 obj-$(CONFIG_MTD_NAND_ECC)		+= nand_ecc.o
+obj-$(CONFIG_MTD_NAND_BCH)		+= nand_bch.o
 obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o
 obj-$(CONFIG_MTD_SM_COMMON) 		+= sm_common.o
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 4915067..48ef5e1 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -42,6 +42,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/nand_ecc.h>
+#include <linux/mtd/nand_bch.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/leds.h>
@@ -3248,7 +3249,7 @@ int nand_scan_tail(struct mtd_info *mtd)
 	/*
 	 * If no default placement scheme is given, select an appropriate one
 	 */
-	if (!chip->ecc.layout) {
+	if (!chip->ecc.layout && (chip->ecc.mode != NAND_ECC_SOFT_BCH)) {
 		switch (mtd->oobsize) {
 		case 8:
 			chip->ecc.layout = &nand_oob_8;
@@ -3351,6 +3352,40 @@ int nand_scan_tail(struct mtd_info *mtd)
 		chip->ecc.bytes = 3;
 		break;
 
+	case NAND_ECC_SOFT_BCH:
+		if (!mtd_nand_has_bch()) {
+			printk(KERN_WARNING "CONFIG_MTD_ECC_BCH not enabled\n");
+			BUG();
+		}
+		chip->ecc.calculate = nand_bch_calculate_ecc;
+		chip->ecc.correct = nand_bch_correct_data;
+		chip->ecc.read_page = nand_read_page_swecc;
+		chip->ecc.read_subpage = nand_read_subpage;
+		chip->ecc.write_page = nand_write_page_swecc;
+		chip->ecc.read_page_raw = nand_read_page_raw;
+		chip->ecc.write_page_raw = nand_write_page_raw;
+		chip->ecc.read_oob = nand_read_oob_std;
+		chip->ecc.write_oob = nand_write_oob_std;
+		/*
+		 * Board driver should supply ecc.size and ecc.bytes values to
+		 * select how many bits are correctable; see nand_bch_init()
+		 * for details.
+		 * Otherwise, default to 4 bits for large page devices
+		 */
+		if (!chip->ecc.size && (mtd->oobsize >= 64)) {
+			chip->ecc.size = 512;
+			chip->ecc.bytes = 7;
+		}
+		chip->ecc.priv = nand_bch_init(mtd,
+					       chip->ecc.size,
+					       chip->ecc.bytes,
+					       &chip->ecc.layout);
+		if (!chip->ecc.priv) {
+			printk(KERN_WARNING "BCH ECC initialization failed!\n");
+			BUG();
+		}
+		break;
+
 	case NAND_ECC_NONE:
 		printk(KERN_WARNING "NAND_ECC_NONE selected by board driver. "
 		       "This is not recommended !!\n");
@@ -3501,6 +3536,9 @@ void nand_release(struct mtd_info *mtd)
 {
 	struct nand_chip *chip = mtd->priv;
 
+	if (chip->ecc.mode == NAND_ECC_SOFT_BCH)
+		nand_bch_free((struct nand_bch_control *)chip->ecc.priv);
+
 #ifdef CONFIG_MTD_PARTITIONS
 	/* Deregister partitions */
 	del_mtd_partitions(mtd);
diff --git a/drivers/mtd/nand/nand_bch.c b/drivers/mtd/nand/nand_bch.c
new file mode 100644
index 0000000..5e5f8df
--- /dev/null
+++ b/drivers/mtd/nand/nand_bch.c
@@ -0,0 +1,245 @@
+/*
+ * drivers/mtd/nand/nand_bch.c
+ *
+ * This file provides ECC correction for more than 1 bit per block of data,
+ * using binary BCH codes. It relies on the generic BCH library lib/bch.c.
+ *
+ * Copyright (C) 2011 Ivan Djelic <ivan.djelic@parrot.com>
+ *
+ * This file is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 or (at your option) any
+ * later version.
+ *
+ * This file is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this file; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/nand_bch.h>
+#include <linux/bch.h>
+
+/**
+ * struct nand_bch_control - private NAND BCH control structure
+ * @bch:       BCH control structure
+ * @ecclayout: private ecc layout for this BCH configuration
+ * @errloc:    error location array
+ * @eccmask:   XOR ecc mask, allows erased pages to be decoded as valid
+ */
+struct nand_bch_control {
+	struct bch_control   *bch;
+	struct nand_ecclayout ecclayout;
+	unsigned int         *errloc;
+	unsigned char        *eccmask;
+};
+
+/**
+ * nand_bch_calculate_ecc - [NAND Interface] Calculate ECC for data block
+ * @mtd:	MTD block structure
+ * @buf:	input buffer with raw data
+ * @code:	output buffer with ECC
+ */
+int nand_bch_calculate_ecc(struct mtd_info *mtd, const unsigned char *buf,
+			   unsigned char *code)
+{
+	const struct nand_chip *chip = mtd->priv;
+	struct nand_bch_control *nbc = chip->ecc.priv;
+	unsigned int i;
+
+	memset(code, 0, chip->ecc.bytes);
+	encode_bch(nbc->bch, buf, chip->ecc.size, code);
+
+	/* apply mask so that an erased page is a valid codeword */
+	for (i = 0; i < chip->ecc.bytes; i++)
+		code[i] ^= nbc->eccmask[i];
+
+	return 0;
+}
+EXPORT_SYMBOL(nand_bch_calculate_ecc);
+
+/**
+ * nand_bch_correct_data - [NAND Interface] Detect and correct bit error(s)
+ * @mtd:	MTD block structure
+ * @buf:	raw data read from the chip
+ * @read_ecc:	ECC from the chip
+ * @calc_ecc:	the ECC calculated from raw data
+ *
+ * Detect and correct bit errors for a data byte block
+ */
+int nand_bch_correct_data(struct mtd_info *mtd, unsigned char *buf,
+			  unsigned char *read_ecc, unsigned char *calc_ecc)
+{
+	const struct nand_chip *chip = mtd->priv;
+	struct nand_bch_control *nbc = chip->ecc.priv;
+	unsigned int *errloc = nbc->errloc;
+	int i, count;
+
+	count = decode_bch(nbc->bch, NULL, chip->ecc.size, read_ecc, calc_ecc,
+			   NULL, errloc);
+	if (count > 0) {
+		for (i = 0; i < count; i++) {
+			if (errloc[i] < (chip->ecc.size*8))
+				/* error is located in data, correct it */
+				buf[errloc[i] >> 3] ^= (1 << (errloc[i] & 7));
+			/* else error in ecc, no action needed */
+
+			DEBUG(MTD_DEBUG_LEVEL0, "%s: corrected bitflip %u\n",
+			      __func__, errloc[i]);
+		}
+	} else if (count < 0) {
+		printk(KERN_ERR "ecc unrecoverable error\n");
+		count = -1;
+	}
+	return count;
+}
+EXPORT_SYMBOL(nand_bch_correct_data);
+
+/**
+ * nand_bch_init - [NAND Interface] Initialize NAND BCH error correction
+ * @mtd:	MTD block structure
+ * @eccsize:	ecc block size in bytes
+ * @eccbytes:	ecc length in bytes
+ * @ecclayout:	output default layout
+ *
+ * Returns:
+ *  a pointer to a new NAND BCH control structure, or NULL upon failure
+ *
+ * Initialize NAND BCH error correction. Parameters @eccsize and @eccbytes
+ * are used to compute BCH parameters m (Galois field order) and t (error
+ * correction capability). @eccbytes should be equal to the number of bytes
+ * required to store m*t bits, where m is such that 2^m-1 > @eccsize*8.
+ *
+ * Example: to configure 4 bit correction per 512 bytes, you should pass
+ * @eccsize = 512  (thus, m=13 is the smallest integer such that 2^m-1 > 512*8)
+ * @eccbytes = 7   (7 bytes are required to store m*t = 13*4 = 52 bits)
+ */
+struct nand_bch_control *
+nand_bch_init(struct mtd_info *mtd, unsigned int eccsize, unsigned int eccbytes,
+	      struct nand_ecclayout **ecclayout)
+{
+	unsigned int m, t, eccsteps, i;
+	struct nand_ecclayout *layout;
+	struct nand_bch_control *nbc = NULL;
+	unsigned char *erased_page;
+
+	if (!eccsize || !eccbytes) {
+		printk(KERN_WARNING "ecc parameters not supplied\n");
+		goto fail;
+	}
+
+	m = fls(1+8*eccsize);
+	t = (eccbytes*8)/m;
+
+	nbc = kzalloc(sizeof(*nbc), GFP_KERNEL);
+	if (!nbc)
+		goto fail;
+
+	nbc->bch = init_bch(m, t, 0);
+	if (!nbc->bch)
+		goto fail;
+
+	/* verify that eccbytes has the expected value */
+	if (nbc->bch->ecc_bytes != eccbytes) {
+		printk(KERN_WARNING "invalid eccbytes %u, should be %u\n",
+		       eccbytes, nbc->bch->ecc_bytes);
+		goto fail;
+	}
+
+	eccsteps = mtd->writesize/eccsize;
+
+	/* if no ecc placement scheme was provided, build one */
+	if (!*ecclayout) {
+
+		/* handle large page devices only */
+		if (mtd->oobsize < 64) {
+			printk(KERN_WARNING "must provide an oob scheme for "
+			       "oobsize %d\n", mtd->oobsize);
+			goto fail;
+		}
+
+		layout = &nbc->ecclayout;
+		layout->eccbytes = eccsteps*eccbytes;
+
+		/* reserve 2 bytes for bad block marker */
+		if (layout->eccbytes+2 > mtd->oobsize) {
+			printk(KERN_WARNING "no suitable oob scheme available "
+			       "for oobsize %d eccbytes %u\n", mtd->oobsize,
+			       eccbytes);
+			goto fail;
+		}
+		/* put ecc bytes at oob tail */
+		for (i = 0; i < layout->eccbytes; i++)
+			layout->eccpos[i] = mtd->oobsize-layout->eccbytes+i;
+
+		layout->oobfree[0].offset = 2;
+		layout->oobfree[0].length = mtd->oobsize-2-layout->eccbytes;
+
+		*ecclayout = layout;
+	}
+
+	/* sanity checks */
+	if (8*(eccsize+eccbytes) >= (1 << m)) {
+		printk(KERN_WARNING "eccsize %u is too large\n", eccsize);
+		goto fail;
+	}
+	if ((*ecclayout)->eccbytes != (eccsteps*eccbytes)) {
+		printk(KERN_WARNING "invalid ecc layout\n");
+		goto fail;
+	}
+
+	nbc->eccmask = kmalloc(eccbytes, GFP_KERNEL);
+	nbc->errloc = kmalloc(t*sizeof(*nbc->errloc), GFP_KERNEL);
+	if (!nbc->eccmask || !nbc->errloc)
+		goto fail;
+	/*
+	 * compute and store the inverted ecc of an erased ecc block
+	 */
+	erased_page = kmalloc(eccsize, GFP_KERNEL);
+	if (!erased_page)
+		goto fail;
+
+	memset(erased_page, 0xff, eccsize);
+	memset(nbc->eccmask, 0, eccbytes);
+	encode_bch(nbc->bch, erased_page, eccsize, nbc->eccmask);
+	kfree(erased_page);
+
+	for (i = 0; i < eccbytes; i++)
+		nbc->eccmask[i] ^= 0xff;
+
+	return nbc;
+fail:
+	nand_bch_free(nbc);
+	return NULL;
+}
+EXPORT_SYMBOL(nand_bch_init);
+
+/**
+ * nand_bch_free - [NAND Interface] Release NAND BCH ECC resources
+ * @nbc:	NAND BCH control structure
+ */
+void nand_bch_free(struct nand_bch_control *nbc)
+{
+	if (nbc) {
+		free_bch(nbc->bch);
+		kfree(nbc->errloc);
+		kfree(nbc->eccmask);
+		kfree(nbc);
+	}
+}
+EXPORT_SYMBOL(nand_bch_free);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ivan Djelic <ivan.djelic@parrot.com>");
+MODULE_DESCRIPTION("NAND software BCH ECC support");
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 1f489b2..ae67ef5 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -140,6 +140,7 @@ typedef enum {
 	NAND_ECC_HW,
 	NAND_ECC_HW_SYNDROME,
 	NAND_ECC_HW_OOB_FIRST,
+	NAND_ECC_SOFT_BCH,
 } nand_ecc_modes_t;
 
 /*
@@ -339,6 +340,7 @@ struct nand_hw_control {
  * @prepad:	padding information for syndrome based ecc generators
  * @postpad:	padding information for syndrome based ecc generators
  * @layout:	ECC layout control struct pointer
+ * @priv:	pointer to private ecc control data
  * @hwctl:	function to control hardware ecc generator. Must only
  *		be provided if an hardware ECC is available
  * @calculate:	function for ecc calculation or readback from ecc hardware
@@ -362,6 +364,7 @@ struct nand_ecc_ctrl {
 	int prepad;
 	int postpad;
 	struct nand_ecclayout	*layout;
+	void *priv;
 	void (*hwctl)(struct mtd_info *mtd, int mode);
 	int (*calculate)(struct mtd_info *mtd, const uint8_t *dat,
 			uint8_t *ecc_code);
diff --git a/include/linux/mtd/nand_bch.h b/include/linux/mtd/nand_bch.h
new file mode 100644
index 0000000..94c206b
--- /dev/null
+++ b/include/linux/mtd/nand_bch.h
@@ -0,0 +1,74 @@
+/*
+ * include/mtd/nand_bch.h
+ *
+ * Copyright (C) 2011 Ivan Djelic <ivan.djelic@parrot.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file is the header for the NAND BCH ECC implementation.
+ */
+
+#ifndef __MTD_NAND_BCH_H__
+#define __MTD_NAND_BCH_H__
+
+struct mtd_info;
+struct nand_bch_control;
+
+#if defined(CONFIG_MTD_NAND_ECC_BCH)
+
+static inline int mtd_nand_has_bch(void) { return 1; }
+
+/*
+ * Calculate BCH ecc code
+ */
+int nand_bch_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
+			   u_char *ecc_code);
+
+/*
+ * Detect and correct bit errors
+ */
+int nand_bch_correct_data(struct mtd_info *mtd, u_char *dat, u_char *read_ecc,
+			  u_char *calc_ecc);
+/*
+ * Initialize BCH encoder/decoder
+ */
+struct nand_bch_control *
+nand_bch_init(struct mtd_info *mtd, unsigned int eccsize,
+	      unsigned int eccbytes, struct nand_ecclayout **ecclayout);
+/*
+ * Release BCH encoder/decoder resources
+ */
+void nand_bch_free(struct nand_bch_control *nbc);
+
+#else /* !CONFIG_MTD_NAND_ECC_BCH */
+
+static inline int mtd_nand_has_bch(void) { return 0; }
+
+static inline int
+nand_bch_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
+		       u_char *ecc_code)
+{
+	return -1;
+}
+
+static inline int
+nand_bch_correct_data(struct mtd_info *mtd, unsigned char *buf,
+		      unsigned char *read_ecc, unsigned char *calc_ecc)
+{
+	return -1;
+}
+
+static inline struct nand_bch_control *
+nand_bch_init(struct mtd_info *mtd, unsigned int eccsize,
+	      unsigned int eccbytes, struct nand_ecclayout **ecclayout)
+{
+	return NULL;
+}
+
+static inline void nand_bch_free(struct nand_bch_control *nbc) {}
+
+#endif /* CONFIG_MTD_NAND_ECC_BCH */
+
+#endif /* __MTD_NAND_BCH_H__ */
-- 
1.7.2.3

