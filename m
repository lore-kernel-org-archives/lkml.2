Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1KSPDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:03:43 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:51836 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1KSPDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:03:39 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 05/16] mtd/docg3: fix reading oob+data without correction
Date: Sat, 19 Nov 2011 16:02:47 +0100
Message-Id: <1321714978-24543-6-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the docg3 reads to be able to cope with all possible
data buffer / oob buffer / file mode combinations from
docg3_read_oob().
This especially ensures that raw reads do not use ECC
corrections, and AUTOOOB and PLACEOOB do use ECC
correction.

The approach is to empty docg3_read() and make it a wrapper
to docg3_read_oob(). As docg3_read_oob() handles all the
funny cases (no data buffer but oob buffer, data buffer but
no oob buffer, ...), docg3_read() is just a special use of
docg3_read_oob().

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |  194 +++++++++++++++++++++----------------------
 1 files changed, 95 insertions(+), 99 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 5834e6e..1c2f54d 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -196,8 +196,8 @@ static int doc_reset_seq(struct docg3 *docg3)
 /**
  * doc_read_data_area - Read data from data area
  * @docg3: the device
- * @buf: the buffer to fill in
- * @len: the lenght to read
+ * @buf: the buffer to fill in (might be NULL is dummy reads)
+ * @len: the length to read
  * @first: first time read, DOC_READADDRESS should be set
  *
  * Reads bytes from flash data. Handles the single byte / even bytes reads.
@@ -218,8 +218,10 @@ static void doc_read_data_area(struct docg3 *docg3, void *buf, int len,
 	dst16 = buf;
 	for (i = 0; i < len4; i += 2) {
 		data16 = doc_readw(docg3, DOC_IOSPACE_DATA);
-		*dst16 = data16;
-		dst16++;
+		if (dst16) {
+			*dst16 = data16;
+			dst16++;
+		}
 	}
 
 	if (cdr) {
@@ -229,8 +231,10 @@ static void doc_read_data_area(struct docg3 *docg3, void *buf, int len,
 		dst8 = (u8 *)dst16;
 		for (i = 0; i < cdr; i++) {
 			data8 = doc_readb(docg3, DOC_IOSPACE_DATA);
-			*dst8 = data8;
-			dst8++;
+			if (dst8) {
+				*dst8 = data8;
+				dst8++;
+			}
 		}
 	}
 }
@@ -542,96 +546,109 @@ static void calc_block_sector(loff_t from, int *block0, int *block1, int *page,
 }
 
 /**
- * doc_read - Read bytes from flash
+ * doc_read_oob - Read out of band bytes from flash
  * @mtd: the device
  * @from: the offset from first block and first page, in bytes, aligned on page
  *        size
- * @len: the number of bytes to read (must be a multiple of 4)
- * @retlen: the number of bytes actually read
- * @buf: the filled in buffer
+ * @ops: the mtd oob structure
  *
- * Reads flash memory pages. This function does not read the OOB chunk, but only
- * the page data.
+ * Reads flash memory OOB area of pages.
  *
  * Returns 0 if read successfull, of -EIO, -EINVAL if an error occured
  */
-static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
-	     size_t *retlen, u_char *buf)
+static int doc_read_oob(struct mtd_info *mtd, loff_t from,
+			struct mtd_oob_ops *ops)
 {
 	struct docg3 *docg3 = mtd->priv;
-	int block0, block1, page, readlen, ret, ofs = 0;
-	int syn[DOC_ECC_BCH_SIZE], eccconf1;
-	u8 oob[DOC_LAYOUT_OOB_SIZE];
+	int block0, block1, page, ret, ofs = 0;
+	u8 *oobbuf = ops->oobbuf;
+	u8 *buf = ops->datbuf;
+	size_t len, ooblen, nbdata, nboob;
+	u8 calc_ecc[DOC_ECC_BCH_SIZE], eccconf1;
+
+	if (buf)
+		len = ops->len;
+	else
+		len = 0;
+	if (oobbuf)
+		ooblen = ops->ooblen;
+	else
+		ooblen = 0;
+
+	if (oobbuf && ops->mode == MTD_OPS_PLACE_OOB)
+		oobbuf += ops->ooboffs;
+
+	doc_dbg("doc_read_oob(from=%lld, mode=%d, data=(%p:%zu), oob=(%p:%zu))\n",
+		from, ops->mode, buf, len, oobbuf, ooblen);
+	if ((len % DOC_LAYOUT_PAGE_SIZE) || (ooblen % DOC_LAYOUT_OOB_SIZE) ||
+	    (from % DOC_LAYOUT_PAGE_SIZE))
+		return -EINVAL;
 
 	ret = -EINVAL;
-	doc_dbg("doc_read(from=%lld, len=%zu, buf=%p)\n", from, len, buf);
-	if (from % DOC_LAYOUT_PAGE_SIZE)
-		goto err;
-	if (len % 4)
-		goto err;
-	calc_block_sector(from, &block0, &block1, &page, &ofs);
+	calc_block_sector(from + len, &block0, &block1, &page, &ofs);
 	if (block1 > docg3->max_block)
 		goto err;
 
-	*retlen = 0;
+	ops->oobretlen = 0;
+	ops->retlen = 0;
 	ret = 0;
-	readlen = min_t(size_t, len, (size_t)DOC_LAYOUT_PAGE_SIZE);
-	while (!ret && len > 0) {
-		readlen = min_t(size_t, len, (size_t)DOC_LAYOUT_PAGE_SIZE);
+	while (!ret && (len > 0 || ooblen > 0)) {
+		calc_block_sector(from, &block0, &block1, &page, &ofs);
+		nbdata = min_t(size_t, len, (size_t)DOC_LAYOUT_PAGE_SIZE);
+		nboob = min_t(size_t, ooblen, (size_t)DOC_LAYOUT_OOB_SIZE);
 		ret = doc_read_page_prepare(docg3, block0, block1, page, ofs);
 		if (ret < 0)
 			goto err;
 		ret = doc_read_page_ecc_init(docg3, DOC_ECC_BCH_COVERED_BYTES);
 		if (ret < 0)
 			goto err_in_read;
-		ret = doc_read_page_getbytes(docg3, readlen, buf, 1);
-		if (ret < readlen)
+		ret = doc_read_page_getbytes(docg3, nbdata, buf, 1);
+		if (ret < nbdata)
 			goto err_in_read;
-		ret = doc_read_page_getbytes(docg3, DOC_LAYOUT_OOB_SIZE,
-					     oob, 0);
-		if (ret < DOC_LAYOUT_OOB_SIZE)
+		doc_read_page_getbytes(docg3, DOC_LAYOUT_PAGE_SIZE - nbdata,
+				       NULL, 0);
+		ret = doc_read_page_getbytes(docg3, nboob, oobbuf, 0);
+		if (ret < nboob)
 			goto err_in_read;
+		doc_read_page_getbytes(docg3, DOC_LAYOUT_OOB_SIZE - nboob,
+				       NULL, 0);
 
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
-		/*
-		 * There should be a BCH bitstream fixing algorithm here ...
-		 * By now, a page read failure is triggered by BCH error
-		 */
-		doc_get_hw_bch_syndroms(docg3, syn);
+		doc_get_hw_bch_syndroms(docg3, calc_ecc);
 		eccconf1 = doc_register_readb(docg3, DOC_ECCCONF1);
 
-		doc_dbg("OOB - INFO: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-			 oob[0], oob[1], oob[2], oob[3], oob[4],
-			 oob[5], oob[6]);
-		doc_dbg("OOB - HAMMING: %02x\n", oob[7]);
-		doc_dbg("OOB - BCH_ECC: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-			 oob[8], oob[9], oob[10], oob[11], oob[12],
-			 oob[13], oob[14]);
-		doc_dbg("OOB - UNUSED: %02x\n", oob[15]);
+		if (nboob >= DOC_LAYOUT_OOB_SIZE) {
+			doc_dbg("OOB - INFO: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+				oobbuf[0], oobbuf[1], oobbuf[2], oobbuf[3],
+				oobbuf[4], oobbuf[5], oobbuf[6]);
+			doc_dbg("OOB - HAMMING: %02x\n", oobbuf[7]);
+			doc_dbg("OOB - BCH_ECC: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+				oobbuf[8], oobbuf[9], oobbuf[10], oobbuf[11],
+				oobbuf[12], oobbuf[13], oobbuf[14]);
+			doc_dbg("OOB - UNUSED: %02x\n", oobbuf[15]);
+		}
 		doc_dbg("ECC checks: ECCConf1=%x\n", eccconf1);
-		doc_dbg("ECC BCH syndrom: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-			syn[0], syn[1], syn[2], syn[3], syn[4], syn[5], syn[6]);
+		doc_dbg("ECC CALC_ECC: %02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+			calc_ecc[0], calc_ecc[1], calc_ecc[2],
+			calc_ecc[3], calc_ecc[4], calc_ecc[5],
+			calc_ecc[6]);
 
 		ret = -EBADMSG;
 		if (block0 >= DOC_LAYOUT_BLOCK_FIRST_DATA) {
-			if (eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR)
+			if ((eccconf1 & DOC_ECCCONF1_BCH_SYNDROM_ERR) &&
+			    (eccconf1 & DOC_ECCCONF1_PAGE_IS_WRITTEN))
 				goto err_in_read;
 			if (is_prot_seq_error(docg3))
 				goto err_in_read;
 		}
+
 		doc_read_page_finish(docg3);
+		ops->retlen += nbdata;
+		ops->oobretlen += nboob;
+		buf += nbdata;
+		oobbuf += nboob;
+		len -= nbdata;
+		ooblen -= nboob;
+		from += DOC_LAYOUT_PAGE_SIZE;
 	}
 
 	return 0;
@@ -642,54 +659,33 @@ err:
 }
 
 /**
- * doc_read_oob - Read out of band bytes from flash
+ * doc_read - Read bytes from flash
  * @mtd: the device
  * @from: the offset from first block and first page, in bytes, aligned on page
  *        size
- * @ops: the mtd oob structure
+ * @len: the number of bytes to read (must be a multiple of 4)
+ * @retlen: the number of bytes actually read
+ * @buf: the filled in buffer
  *
- * Reads flash memory OOB area of pages.
+ * Reads flash memory pages. This function does not read the OOB chunk, but only
+ * the page data.
  *
  * Returns 0 if read successfull, of -EIO, -EINVAL if an error occured
  */
-static int doc_read_oob(struct mtd_info *mtd, loff_t from,
-			struct mtd_oob_ops *ops)
+static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
+	     size_t *retlen, u_char *buf)
 {
-	struct docg3 *docg3 = mtd->priv;
-	int block0, block1, page, ofs, ret;
-	u8 *buf = ops->oobbuf;
-	size_t len = ops->ooblen;
+	struct mtd_oob_ops ops;
+	size_t ret;
 
-	doc_dbg("doc_read_oob(from=%lld, buf=%p, len=%zu)\n", from, buf, len);
-	if (len != DOC_LAYOUT_OOB_SIZE)
-		return -EINVAL;
+	memset(&ops, 0, sizeof(ops));
+	ops.datbuf = buf;
+	ops.len = len;
+	ops.mode = MTD_OPS_AUTO_OOB;
 
-	switch (ops->mode) {
-	case MTD_OPS_PLACE_OOB:
-		buf += ops->ooboffs;
-		break;
-	default:
-		break;
-	}
-
-	calc_block_sector(from, &block0, &block1, &page, &ofs);
-	if (block1 > docg3->max_block)
-		return -EINVAL;
-
-	ret = doc_read_page_prepare(docg3, block0, block1, page,
-				    ofs + DOC_LAYOUT_PAGE_SIZE);
-	if (!ret)
-		ret = doc_read_page_ecc_init(docg3, DOC_LAYOUT_OOB_SIZE);
-	if (!ret)
-		ret = doc_read_page_getbytes(docg3, DOC_LAYOUT_OOB_SIZE,
-					     buf, 1);
-	doc_read_page_finish(docg3);
-
-	if (ret > 0)
-		ops->oobretlen = ret;
-	else
-		ops->oobretlen = 0;
-	return (ret > 0) ? 0 : ret;
+	ret = doc_read_oob(mtd, from, &ops);
+	*retlen = ops.retlen;
+	return ret;
 }
 
 static int doc_reload_bbt(struct docg3 *docg3)
-- 
1.7.5.4

