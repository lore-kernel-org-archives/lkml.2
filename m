Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1KSPEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:04:23 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:53006 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1KSPEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:04:20 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 15/16] mtd/docg3: add fast mode
Date: Sat, 19 Nov 2011 16:02:57 +0100
Message-Id: <1321714978-24543-16-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Docg3 chips can work in 3 modes : normal MLC mode, fast
mode and reliable mode. Normally, as docg3 is a MLC chip, it
should be configured to work in normal mode.

In both normal mode, each page is distinct. This
means that writing to page 12 of blocks 14,15 writes only to
that page, and reading from page 12 of blocks 14,15 reads
only from that page.

In reliable and fast modes, pages are coupled by pairs, and
are clones one of each other. This means that the available
capacity of the chip is halved. Pages are coupled in each
block, and page of index 2*n contains the same data as page
2*n+1 of the same block.

In fast mode, the reads occur a bit faster, but are a bit
less reliable that in normal mode.

When reading from page 2*n, the chip reads bytes from both
page 2*n and page 2*n+1, makes a logical and for each byte,
and returns the result. As programming a page means
"clearing bits", even if a bit was not cleared on one page
because the flash is worn out, the other page has the bit
cleared, and the result of the "AND" gives a correct result.

When writing to page 2*n, the chip writes data to both page
2*n and page 2*n+1.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |   86 +++++++++++++++++++++++++++++++++---------
 drivers/mtd/devices/docg3.h |    9 ++++-
 2 files changed, 75 insertions(+), 20 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index d94c759..35df377 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -61,6 +61,11 @@
  *
  */
 
+static unsigned int reliable_mode = 0;
+module_param(reliable_mode, uint, 0);
+MODULE_PARM_DESC(reliable_mode, "Set the docg3 mode (0=normal MLC, 1=fast, "
+		 "2=reliable) : MLC normal operations are in normal mode");
+
 /**
  * struct docg3_oobinfo - DiskOnChip G3 OOB layout
  * @eccbytes: 8 bytes are used (1 for Hamming ECC, 7 for BCH ECC)
@@ -291,19 +296,41 @@ static void doc_write_data_area(struct docg3 *docg3, const void *buf, int len)
 }
 
 /**
- * doc_set_data_mode - Sets the flash to reliable data mode
+ * doc_set_data_mode - Sets the flash to normal or reliable data mode
  * @docg3: the device
  *
  * The reliable data mode is a bit slower than the fast mode, but less errors
  * occur.  Entering the reliable mode cannot be done without entering the fast
  * mode first.
+ *
+ * In reliable mode, pages 2*n and 2*n+1 are clones. Writing to page 0 of blocks
+ * (4,5) make the hardware write also to page 1 of blocks blocks(4,5). Reading
+ * from page 0 of blocks (4,5) or from page 1 of blocks (4,5) gives the same
+ * result, which is a logical and between bytes from page 0 and page 1 (which is
+ * consistent with the fact that writing to a page is _clearing_ bits of that
+ * page).
  */
 static void doc_set_reliable_mode(struct docg3 *docg3)
 {
-	doc_dbg("doc_set_reliable_mode()\n");
-	doc_flash_sequence(docg3, DOC_SEQ_SET_MODE);
-	doc_flash_command(docg3, DOC_CMD_FAST_MODE);
-	doc_flash_command(docg3, DOC_CMD_RELIABLE_MODE);
+	static char *strmode[] = { "normal", "fast", "reliable", "invalid" };
+
+	doc_dbg("doc_set_reliable_mode(%s)\n", strmode[docg3->reliable]);
+	switch (docg3->reliable) {
+	case 0:
+		break;
+	case 1:
+		doc_flash_sequence(docg3, DOC_SEQ_SET_FASTMODE);
+		doc_flash_command(docg3, DOC_CMD_FAST_MODE);
+		break;
+	case 2:
+		doc_flash_sequence(docg3, DOC_SEQ_SET_RELIABLEMODE);
+		doc_flash_command(docg3, DOC_CMD_FAST_MODE);
+		doc_flash_command(docg3, DOC_CMD_RELIABLE_MODE);
+		break;
+	default:
+		doc_err("doc_set_reliable_mode(): invalid mode\n");
+		break;
+	}
 	doc_delay(docg3, 2);
 }
 
@@ -778,18 +805,29 @@ static void doc_read_page_finish(struct docg3 *docg3)
  * @block1: second plane block index calculated
  * @page: page calculated
  * @ofs: offset in page
+ * @reliable: 0 if docg3 in normal mode, 1 if docg3 in fast mode, 2 if docg3 in
+ * reliable mode.
+ *
+ * The calculation is based on the reliable/normal mode. In normal mode, the 64
+ * pages of a block are available. In reliable mode, as pages 2*n and 2*n+1 are
+ * clones, only 32 pages per block are available.
  */
 static void calc_block_sector(loff_t from, int *block0, int *block1, int *page,
-			      int *ofs)
+			      int *ofs, int reliable)
 {
-	uint sector;
+	uint sector, pages_biblock;
+
+	pages_biblock = DOC_LAYOUT_PAGES_PER_BLOCK * DOC_LAYOUT_NBPLANES;
+	if (reliable == 1 || reliable == 2)
+		pages_biblock /= 2;
 
 	sector = from / DOC_LAYOUT_PAGE_SIZE;
-	*block0 = sector / (DOC_LAYOUT_PAGES_PER_BLOCK * DOC_LAYOUT_NBPLANES)
-		* DOC_LAYOUT_NBPLANES;
+	*block0 = sector / pages_biblock * DOC_LAYOUT_NBPLANES;
 	*block1 = *block0 + 1;
-	*page = sector % (DOC_LAYOUT_PAGES_PER_BLOCK * DOC_LAYOUT_NBPLANES);
+	*page = sector % pages_biblock;
 	*page /= DOC_LAYOUT_NBPLANES;
+	if (reliable == 1 || reliable == 2)
+		*page *= 2;
 	if (sector % 2)
 		*ofs = DOC_LAYOUT_PAGE_OOB_SIZE;
 	else
@@ -836,7 +874,8 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 		return -EINVAL;
 
 	ret = -EINVAL;
-	calc_block_sector(from + len, &block0, &block1, &page, &ofs);
+	calc_block_sector(from + len, &block0, &block1, &page, &ofs,
+			  docg3->reliable);
 	if (block1 > docg3->max_block)
 		goto err;
 
@@ -844,7 +883,8 @@ static int doc_read_oob(struct mtd_info *mtd, loff_t from,
 	ops->retlen = 0;
 	ret = 0;
 	while (!ret && (len > 0 || ooblen > 0)) {
-		calc_block_sector(from, &block0, &block1, &page, &ofs);
+		calc_block_sector(from, &block0, &block1, &page, &ofs,
+			docg3->reliable);
 		nbdata = min_t(size_t, len, (size_t)DOC_LAYOUT_PAGE_SIZE);
 		nboob = min_t(size_t, ooblen, (size_t)DOC_LAYOUT_OOB_SIZE);
 		ret = doc_read_page_prepare(docg3, block0, block1, page, ofs);
@@ -983,7 +1023,8 @@ static int doc_block_isbad(struct mtd_info *mtd, loff_t from)
 	struct docg3 *docg3 = mtd->priv;
 	int block0, block1, page, ofs, is_good;
 
-	calc_block_sector(from, &block0, &block1, &page, &ofs);
+	calc_block_sector(from, &block0, &block1, &page, &ofs,
+		docg3->reliable);
 	doc_dbg("doc_block_isbad(from=%lld) => block=(%d,%d), page=%d, ofs=%d\n",
 		from, block0, block1, page, ofs);
 
@@ -1015,7 +1056,7 @@ static int doc_get_erase_count(struct docg3 *docg3, loff_t from)
 	doc_dbg("doc_get_erase_count(from=%lld, buf=%p)\n", from, buf);
 	if (from % DOC_LAYOUT_PAGE_SIZE)
 		return -EINVAL;
-	calc_block_sector(from, &block0, &block1, &page, &ofs);
+	calc_block_sector(from, &block0, &block1, &page, &ofs, docg3->reliable);
 	if (block1 > docg3->max_block)
 		return -EINVAL;
 
@@ -1156,14 +1197,15 @@ static int doc_erase(struct mtd_info *mtd, struct erase_info *info)
 	doc_set_device_id(docg3, docg3->device_id);
 
 	info->state = MTD_ERASE_PENDING;
-	calc_block_sector(info->addr + info->len,
-			  &block0, &block1, &page, &ofs);
+	calc_block_sector(info->addr + info->len, &block0, &block1, &page,
+			  &ofs, docg3->reliable);
 	ret = -EINVAL;
 	if (block1 > docg3->max_block || page || ofs)
 		goto reset_err;
 
 	ret = 0;
-	calc_block_sector(info->addr, &block0, &block1, &page, &ofs);
+	calc_block_sector(info->addr, &block0, &block1, &page, &ofs,
+			  docg3->reliable);
 	doc_set_reliable_mode(docg3);
 	for (len = info->len; !ret && len > 0; len -= mtd->erasesize) {
 		info->state = MTD_ERASING;
@@ -1209,7 +1251,7 @@ static int doc_write_page(struct docg3 *docg3, loff_t to, const u_char *buf,
 	u8 syn[DOC_ECC_BCH_SIZE], hamming;
 
 	doc_dbg("doc_write_page(to=%lld)\n", to);
-	calc_block_sector(to, &block0, &block1, &page, &ofs);
+	calc_block_sector(to, &block0, &block1, &page, &ofs, docg3->reliable);
 
 	doc_set_device_id(docg3, docg3->device_id);
 	ret = doc_reset_seq(docg3);
@@ -1396,7 +1438,8 @@ static int doc_write_oob(struct mtd_info *mtd, loff_t ofs,
 		return -EINVAL;
 
 	ret = -EINVAL;
-	calc_block_sector(ofs + len, &block0, &block1, &page, &pofs);
+	calc_block_sector(ofs + len, &block0, &block1, &page, &pofs,
+			  docg3->reliable);
 	if (block1 > docg3->max_block)
 		goto err;
 
@@ -1638,6 +1681,7 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 
 	cfg = doc_register_readb(docg3, DOC_CONFIGURATION);
 	docg3->if_cfg = (cfg & DOC_CONF_IF_CFG ? 1 : 0);
+	docg3->reliable = reliable_mode;
 
 	switch (chip_id) {
 	case DOC_CHIPID_G3:
@@ -1649,7 +1693,11 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 	mtd->type = MTD_NANDFLASH;
 	mtd->flags = MTD_CAP_NANDFLASH;
 	mtd->size = (docg3->max_block + 1) * DOC_LAYOUT_BLOCK_SIZE;
+	if (docg3->reliable == 2)
+		mtd->size /= 2;
 	mtd->erasesize = DOC_LAYOUT_BLOCK_SIZE * DOC_LAYOUT_NBPLANES;
+	if (docg3->reliable == 2)
+		mtd->erasesize /= 2;
 	mtd->writesize = DOC_LAYOUT_PAGE_SIZE;
 	mtd->oobsize = DOC_LAYOUT_OOB_SIZE;
 	mtd->owner = THIS_MODULE;
diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index cd70b18..07182f9 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -135,7 +135,8 @@
  */
 #define DOC_SEQ_RESET			0x00
 #define DOC_SEQ_PAGE_SIZE_532		0x03
-#define DOC_SEQ_SET_MODE		0x09
+#define DOC_SEQ_SET_FASTMODE		0x05
+#define DOC_SEQ_SET_RELIABLEMODE	0x09
 #define DOC_SEQ_READ			0x12
 #define DOC_SEQ_SET_PLANE1		0x0e
 #define DOC_SEQ_SET_PLANE2		0x10
@@ -257,6 +258,11 @@
  * @base: mapped IO space
  * @device_id: number of the cascaded DoCG3 device (0, 1, 2 or 3)
  * @if_cfg: if true, reads are on 16bits, else reads are on 8bits
+
+ * @reliable: if 0, docg3 in normal mode, if 1 docg3 in fast mode, if 2 in
+ *            reliable mode
+ *            Fast mode implies more errors than normal mode.
+ *            Reliable mode implies that page 2*n and 2*n+1 are clones.
  * @bbt: bad block table cache
  * @oob_write_ofs: offset of the MTD where this OOB should belong (ie. in next
  *                 page_write)
@@ -270,6 +276,7 @@ struct docg3 {
 	void __iomem *base;
 	unsigned int device_id:4;
 	unsigned int if_cfg:1;
+	unsigned int reliable:2;
 	int max_block;
 	u8 *bbt;
 	loff_t oob_write_ofs;
-- 
1.7.5.4

