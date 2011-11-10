Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab1KJIHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:07:05 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:45692 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895Ab1KJIG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:06:59 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 13/16] mtd/docg3: add ECC correction code
Date: Thu, 10 Nov 2011 09:05:39 +0100
Message-Id: <1320912342-30147-14-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
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
Since V1: integrate reviews from Ivan Djelic and Mike Dunn.
---
 drivers/mtd/devices/Kconfig |    9 +++
 drivers/mtd/devices/docg3.c |  116 ++++++++++++++++++++++++++++++++++--------
 drivers/mtd/devices/docg3.h |   11 ++++-
 3 files changed, 113 insertions(+), 23 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 6d91a1f..b016e2b 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -251,6 +251,8 @@ config MTD_DOC2001PLUS
 
 config MTD_DOCG3
 	tristate "M-Systems Disk-On-Chip G3"
+	select BCH
+	select BCH_CONST_PARAMS
 	---help---
 	  This provides an MTD device driver for the M-Systems DiskOnChip
 	  G3 devices.
@@ -259,6 +261,13 @@ config MTD_DOCG3
 	  M-Systems and now Sandisk. The support is very experimental,
 	  and doesn't give access to any write operations.
 
+if MTD_DOCG3
+config BCH_CONST_M
+	default 14
+config BCH_CONST_T
+	default 4
+endif
+
 config MTD_DOCPROBE
 	tristate
 	select MTD_DOCECC
diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 1f949ea..26cc179 100644
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
@@ -75,6 +76,11 @@ static struct nand_ecclayout docg3_oobinfo = {
 	.oobavail = 8,
 };
 
+/**
+ * struct docg3_bch - BCH engine
+ */
+static struct bch_control *docg3_bch;
+
 static inline u8 doc_readb(struct docg3 *docg3, u16 reg)
 {
 	u8 val = readb(docg3->base + reg);
@@ -582,6 +588,54 @@ static void doc_hamming_ecc_init(struct docg3 *docg3, int nb_bytes)
 }
 
 /**
+ * doc_correct_data - Fix if need be read data from flash
+ * @docg3: the device
+ * @buf: the buffer of read data (512 + 7 + 1 bytes)
+ * @hwecc: the hardware calculated ECC.
+ *         It's in fact recv_ecc ^ calc_ecc, where recv_ecc was read from OOB
+ *         area data, and calc_ecc the ECC calculated by the hardware generator.
+ *
+ * Checks if the received data matches the ECC, and if an error is detected,
+ * tries to fix the bit flips (at most 4) in the buffer buf.  As the docg3
+ * understands the (data, ecc, syndroms) in an inverted order in comparison to
+ * the BCH library, the function reverses the order of bits (ie. bit7 and bit0,
+ * bit6 and bit 1, ...) for all ECC data.
+ *
+ * The hardware ecc unit produces oob_ecc ^ calc_ecc.  The kernel's bch
+ * algorithm is used to decode this.  However the hw operates on page
+ * data in a bit order that is the reverse of that of the bch alg,
+ * requiring that the bits be reversed on the result.  Thanks to Ivan
+ * Djelic for his analysis.
+ *
+ * Returns number of fixed bits (0, 1, 2, 3, 4) or -EBADMSG if too many bit
+ * errors were detected and cannot be fixed.
+ */
+static int doc_ecc_bch_fix_data(struct docg3 *docg3, void *buf, u8 *hwecc)
+{
+	u8 ecc[DOC_ECC_BCH_SIZE];
+	int errorpos[DOC_ECC_BCH_T], i, numerrs;
+
+	for (i = 0; i < DOC_ECC_BCH_SIZE; i++)
+		ecc[i] = bitrev8(hwecc[i]);
+	numerrs = decode_bch(docg3_bch, NULL, DOC_ECC_BCH_COVERED_BYTES,
+			     NULL, ecc, NULL, errorpos);
+	BUG_ON(numerrs == -EINVAL);
+	if (numerrs < 0)
+		goto out;
+
+	for (i = 0; i < numerrs; i++)
+		errorpos[i] = (errorpos[i] & ~7) | (7 - (errorpos[i] & 7));
+	for (i = 0; i < numerrs; i++)
+		if (errorpos[i] < DOC_ECC_BCH_COVERED_BYTES*8)
+			/* error is located in data, correct it */
+			change_bit(errorpos[i], buf);
+out:
+	doc_dbg("doc_ecc_bch_fix_data: flipped %d bits\n", numerrs);
+	return numerrs;
+}
+
+
+/**
  * doc_read_page_prepare - Prepares reading data from a flash page
  * @docg3: the device
  * @block0: the first plane block index on flash memory
@@ -762,7 +816,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 	u8 *oobbuf = ops->oobbuf;
 	u8 *buf = ops->datbuf;
 	size_t len, ooblen, nbdata, nboob;
-	u8 calc_ecc[DOC_ECC_BCH_SIZE], eccconf1;
+	u8 hwecc[DOC_ECC_BCH_SIZE], eccconf1;
 
 	if (buf)
 		len = ops->len;
@@ -797,7 +851,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 		ret = doc_read_page_prepare(docg3, block0, block1, page, ofs);
 		if (ret < 0)
 			goto err;
-		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
+		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_TOTAL_BYTES);
 		if (ret < 0)
 			goto err_in_read;
 		ret = doc_read_page_getbytes(docg3, nbdata, buf, 1);
@@ -811,7 +865,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 		doc_read_page_getbytes(docg3, DOC_LAYOUT_OOB_SIZE - nboob,
 				       NULL, 0);
 
-		doc_get_hw_bch_syndroms(docg3, calc_ecc);
+		doc_get_hw_bch_syndroms(docg3, hwecc);
 		eccconf1 = doc_register_readb(docg3, DOC_ECCCONF1);
 
 		if (nboob >= DOC_LAYOUT_OOB_SIZE) {
@@ -825,18 +879,28 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 			doc_dbg("OOB - UNUSED: %02x\n", oobbuf[15]);
 		}
 		doc_dbg("ECC checks: ECCConf1=%x\n", eccconf1);
-		doc_dbg("ECC CALC_ECC: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-			calc_ecc[0], calc_ecc[1], calc_ecc[2],
-			calc_ecc[3], calc_ecc[4], calc_ecc[5],
-			calc_ecc[6]);
-
-		ret = -EBADMSG;
-		if (block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) {
-			if ((eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR) &&
-			    (eccconf1 & DOC_ECCCONF1_PAGE_IS_WRITTEN))
-				goto err_in_read;
-			if (is_prot_seq_error(docg3))
-				goto err_in_read;
+		doc_dbg("ECC HW_ECC: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+			hwecc[0], hwecc[1], hwecc[2], hwecc[3], hwecc[4],
+			hwecc[5], hwecc[6]);
+
+		ret = -EIO;
+		if (is_prot_seq_error(docg3))
+			goto err_in_read;
+		ret = 0;
+		if ((block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) &&
+		    (eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR) &&
+		    (eccconf1 & DOC_ECCCONF1_PAGE_IS_WRITTEN) &&
+		    (ops->mode != MTD_OPS_RAW) &&
+		    (nbdata == DOC_LAYOUT_PAGE_SIZE)) {
+			ret = doc_ecc_bch_fix_data(docg3, buf, hwecc);
+			if (ret < 0) {
+				mtd->ecc_stats.failed++;
+				ret = -EBADMSG;
+			}
+			if (ret > 0) {
+				mtd->ecc_stats.corrected += ret;
+				ret = -EUCLEAN;
+			}
 		}
 
 		doc_read_page_finish(docg3);
@@ -849,7 +913,7 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 		from += DOC_LAYOUT_PAGE_SIZE;
 	}
 
-	return 0;
+	return ret;
 err_in_read:
 	doc_read_page_finish(docg3);
 err:
@@ -1158,7 +1222,7 @@ static int doc_write_page(struct docg3 *docg3, loff_t to, const u_char *buf,
 	if (ret)
 		goto err;
 
-	doc_write_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
+	doc_write_page_ecc_init(docg3, DOC_ECC_BCH_TOTAL_BYTES);
 	doc_delay(docg3, 2);
 	doc_write_page_putbytes(docg3, DOC_LAYOUT_PAGE_SIZE, buf);
 
@@ -1721,7 +1785,11 @@ static int __init docg3_probe(struct platform_device *pdev)
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
@@ -1751,10 +1819,13 @@ notfound:
 	ret = -ENODEV;
 	dev_info(dev, "No supported DiskOnChip found\n");
 err_probe:
+	free_bch(docg3_bch);
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
@@ -1779,6 +1850,7 @@ static int __exit docg3_release(struct platform_device *pdev)
 			doc_release_device(docg3_floors[floor]);
 
 	kfree(docg3_floors);
+	free_bch(docg3_bch);
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

