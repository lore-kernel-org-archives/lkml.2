Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1J1RxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:53:20 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40750 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1J1RxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:53:16 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 12/13] mtd/docg3: add ECC correction code
Date: Fri, 28 Oct 2011 19:51:31 +0200
Message-Id: <1319824292-11085-13-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Credit for discovering the BCH algorith parameters, and bit
reversing algorithm is to be give to Mike Dunn and Ivan
Djelic.

The BCH correction code relied upon the BCH library, where
all data and ECC is bit-reversed. The BCH library works
correctly when each input byte is bit-reversed, and
accordingly ECC output is also bit-reversed.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/Kconfig |    1 +
 drivers/mtd/devices/docg3.c |  118 ++++++++++++++++++++++++++++++++-----------
 drivers/mtd/devices/docg3.h |   11 ++++-
 3 files changed, 99 insertions(+), 31 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 6d91a1f..ae138c3 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -251,6 +251,7 @@ config MTD_DOC2001PLUS
 
 config MTD_DOCG3
 	tristate "M-Systems Disk-On-Chip G3"
+	select BCH
 	---help---
 	  This provides an MTD device driver for the M-Systems DiskOnChip
 	  G3 devices.
diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 9983594..3c4f7ed 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -29,6 +29,9 @@
 #include <linux/delay.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/bitmap.h>
+#include <linux/bitrev.h>
+#include <linux/bch.h>
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -42,7 +45,6 @@
  * As no specification is available from M-Systems/Sandisk, this drivers lacks
  * several functions available on the chip, as :
  *  - IPL write
- *  - ECC fixing (lack of BCH algorith understanding)
  *  - powerdown / powerup
  *
  * The bus data width (8bits versus 16bits) is not handled (if_cfg flag), and
@@ -51,8 +53,7 @@
  * DocG3 relies on 2 ECC algorithms, which are handled in hardware :
  *  - a 1 byte Hamming code stored in the OOB for each page
  *  - a 7 bytes BCH code stored in the OOB for each page
- * The BCH part is only used for check purpose, no correction is available as
- * some information is missing. What is known is that :
+ * The BCH ECC is :
  *  - BCH is in GF(2^14)
  *  - BCH is over data of 520 bytes (512 page + 7 page_info bytes
  *                                   + 1 hamming byte)
@@ -73,6 +74,11 @@ static struct nand_ecclayout docg3_oobinfo = {
 	.oobfree = {{0, 7}, {15, 1} }
 };
 
+/**
+ * struct docg3_bch - BCH engine
+ */
+static struct bch_control *docg3_bch;
+
 static inline u8 doc_readb(struct docg3 *docg3, u16 reg)
 {
 	u8 val = readb(docg3->base + reg);
@@ -576,6 +582,43 @@ static void doc_hamming_ecc_init(struct docg3 *docg3, int nb_bytes)
 }
 
 /**
+ * doc_correct_data - Fix if need be read data from flash
+ * @docg3: the device
+ * @buf: the buffer of read data (512 + 7 + 1 bytes)
+ * @calc_ecc: the hardware calculated ECC
+ *
+ * Checks if the received data matches the ECC, and if an error is detected,
+ * tries to fix the bit flips (at most 4) in the buffer buf.  As the docg3
+ * understands the (data, ecc, syndroms) in an inverted order in comparison to
+ * the BCH library, the function reverses the order of bits (ie. bit7 and bit0,
+ * bit6 and bit 1, ...) for all ECC data.
+ *
+ * Returns number of fixed bits (0, 1, 2, 3, 4) or -EBADMSG if too many bit
+ * errors were detected and cannot be fixed.
+ */
+static int doc_ecc_bch_fix_data(struct docg3 *docg3, void *buf, u8 *calc_ecc)
+{
+	u8 ecc[DOC_ECC_BCH_T + 1];
+	int errorpos[DOC_ECC_BCH_T + 1], i, numerrs;
+
+	for (i = 0; i < DOC_ECC_BCH_SIZE; i++)
+		ecc[i] = bitrev8(calc_ecc[i]);
+	numerrs = decode_bch(docg3_bch, NULL, DOC_ECC_BCH_COVERED_BYTES,
+			     NULL, ecc, NULL, errorpos);
+	if (numerrs < 0)
+		return numerrs;
+
+	for (i = 0; i < numerrs; i++)
+		errorpos[i] = (errorpos[i] & ~7) | (7 - (errorpos[i] & 7));
+	for (i = 0; i < numerrs; i++)
+		change_bit(errorpos[i], buf);
+
+	doc_dbg("doc_ecc_bch_fix_data: flipped %d bits\n", numerrs);
+	return numerrs;
+}
+
+
+/**
  * doc_read_page_prepare - Prepares reading data from a flash page
  * @docg3: the device
  * @block0: the first plane block index on flash memory
@@ -756,7 +799,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 {
 	struct docg3 *docg3 = mtd->priv;
 	int block0, block1, page, readlen, ret, ofs = 0;
-	u8 syn[DOC_ECC_BCH_SIZE], eccconf1;
+	u8 calc_ecc[DOC_ECC_BCH_SIZE], eccconf1;
 	u8 oob[DOC_LAYOUT_OOB_SIZE];
 
 	ret = -EINVAL;
@@ -777,7 +820,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 		ret = doc_read_page_prepare(docg3, block0, block1, page, ofs);
 		if (ret < 0)
 			goto err;
-		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
+		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_TOTAL_BYTES);
 		if (ret < 0)
 			goto err_in_read;
 		ret = doc_read_page_getbytes(docg3, readlen, buf, 1);
@@ -788,24 +831,11 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 		if (ret < DOC_LAYOUT_OOB_SIZE)
 			goto err_in_read;
 
-		*retlen += readlen;
-		buf += readlen;
-		len -= readlen;
-
-		ofs ^= DOC_LAYOUT_PAGE_OOB_SIZE;
-		if (ofs == 0)
-			page += 2;
-		if (page > DOC_ADDR_PAGE_MASK) {
-			page = 0;
-			block0 += 2;
-			block1 += 2;
-		}
-
 		/*
 		 * There should be a BCH bitstream fixing algorithm here ...
 		 * By now, a page read failure is triggered by BCH error
 		 */
-		doc_get_hw_bch_syndroms(docg3, syn);
+		doc_get_hw_bch_syndroms(docg3, calc_ecc);
 		eccconf1 = doc_register_readb(docg3, DOC_ECCCONF1);
 
 		doc_dbg("OOB - INFO: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -817,20 +847,41 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 			 oob[13], oob[14]);
 		doc_dbg("OOB - UNUSED: %02x\n", oob[15]);
 		doc_dbg("ECC checks: ECCConf1=%x\n", eccconf1);
-		doc_dbg("ECC BCH syndrom: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-			syn[0], syn[1], syn[2], syn[3], syn[4], syn[5], syn[6]);
+		doc_dbg("ECC CALC_ECC: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+			calc_ecc[0], calc_ecc[1], calc_ecc[2], calc_ecc[3],
+			calc_ecc[4], calc_ecc[5], calc_ecc[6]);
 
 		ret = -EBADMSG;
-		if (block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) {
-			if (eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR)
-				goto err_in_read;
-			if (is_prot_seq_error(docg3))
-				goto err_in_read;
+		if (is_prot_seq_error(docg3))
+			goto err_in_read;
+		ret = 0;
+		if ((block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) &&
+		    (eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR)) {
+			ret = doc_ecc_bch_fix_data(docg3, buf, calc_ecc);
+			if (ret < 0)
+				mtd->ecc_stats.failed++;
+			if (ret > 0) {
+				mtd->ecc_stats.corrected += ret;
+				ret = 0;
+			}
 		}
+
 		doc_read_page_finish(docg3);
+		*retlen += readlen;
+		buf += readlen;
+		len -= readlen;
+
+		ofs ^= DOC_LAYOUT_PAGE_OOB_SIZE;
+		if (ofs == 0)
+			page += 2;
+		if (page > DOC_ADDR_PAGE_MASK) {
+			page = 0;
+			block0 += 2;
+			block1 += 2;
+		}
 	}
 
-	return 0;
+	return ret;
 err_in_read:
 	doc_read_page_finish(docg3);
 err:
@@ -1162,7 +1213,7 @@ static int doc_write_page(struct docg3 *docg3, loff_t to, const u_char *buf,
 	if (ret)
 		goto err;
 
-	doc_write_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
+	doc_write_page_ecc_init(docg3, DOC_ECC_BCH_TOTAL_BYTES);
 	doc_delay(docg3, 2);
 	doc_write_page_putbytes(docg3, DOC_LAYOUT_PAGE_SIZE, buf);
 
@@ -1602,7 +1653,11 @@ static int __init docg3_probe(struct platform_device *pdev)
 	docg3_floors = kzalloc(sizeof(*docg3_floors) * DOC_MAX_NBFLOORS,
 			       GFP_KERNEL);
 	if (!docg3_floors)
-		goto nomem;
+		goto nomem1;
+	docg3_bch = init_bch(DOC_ECC_BCH_M, DOC_ECC_BCH_T,
+			     DOC_ECC_BCH_PRIMPOLY);
+	if (!docg3_bch)
+		goto nomem2;
 
 	ret = 0;
 	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++) {
@@ -1635,7 +1690,9 @@ err_probe:
 	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++)
 		if (docg3_floors[floor])
 			doc_release_device(docg3_floors[floor]);
-nomem:
+nomem2:
+	kfree(docg3_floors);
+nomem1:
 	iounmap(base);
 noress:
 	return ret;
@@ -1660,6 +1717,7 @@ static int __exit docg3_release(struct platform_device *pdev)
 			doc_release_device(docg3_floors[floor]);
 
 	kfree(docg3_floors);
+	kfree(docg3_bch);
 	iounmap(base);
 	return 0;
 }
diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index 397e461..33db727 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -51,10 +51,19 @@
 #define DOC_LAYOUT_WEAR_OFFSET		(DOC_LAYOUT_PAGE_OOB_SIZE * 2)
 #define DOC_LAYOUT_BLOCK_SIZE					\
 	(DOC_LAYOUT_PAGES_PER_BLOCK * DOC_LAYOUT_PAGE_SIZE)
+
+/*
+ * ECC related constants
+ */
+#define DOC_ECC_BCH_M			14
+#define DOC_ECC_BCH_T			4
+#define DOC_ECC_BCH_PRIMPOLY		0x4443
 #define DOC_ECC_BCH_SIZE		7
 #define DOC_ECC_BCH_COVERED_BYTES				\
 	(DOC_LAYOUT_PAGE_SIZE + DOC_LAYOUT_OOB_PAGEINFO_SZ +	\
-	 DOC_LAYOUT_OOB_HAMMING_SZ + DOC_LAYOUT_OOB_BCH_SZ)
+	 DOC_LAYOUT_OOB_HAMMING_SZ)
+#define DOC_ECC_BCH_TOTAL_BYTES					\
+	(DOC_ECC_BCH_COVERED_BYTES + DOC_LAYOUT_OOB_BCH_SZ)
 
 /*
  * Blocks distribution
-- 
1.7.5.4

