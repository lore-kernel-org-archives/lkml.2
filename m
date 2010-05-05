Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0EEEOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 00:14:07 -0400
Received: from [69.28.251.93] ([69.28.251.93]:41068 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab0EEEOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 00:14:01 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 4 May 2010 20:58:10 -0700
Subject: [PATCHv2 2/2] mtd: nand: Support alternate BB marker locations on MLC
Message-Id: <73903cdde20c6be375703e18849282bd3f2a2ff1@localhost.localdomain>
In-Reply-To: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain>
References: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain>
To: <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       <Reuben.Dowle@navico.com>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a slightly modified version of a patch submitted last year by
Reuben Dowle <reuben.dowle@navico.com>.  His original comments follow:

This patch adds support for some MLC NAND flashes that place the BB
marker in the LAST page of the bad block rather than the FIRST page used
for SLC NAND and other types of MLC nand.

Lifted from Samsung datasheet for K9LG8G08U0A (1Gbyte MLC NAND):
"
Identifying Initial Invalid Block(s)
All device locations are erased(FFh) except locations where the initial
invalid block(s) information is written prior to shipping. The initial
invalid block(s) status is defined by the 1st byte in the spare area.
Samsung makes sure that the last page of every initial invalid block has
non-FFh data at the column address of 2,048.
...
"

As far as I can tell, this is the same for all Samsung MLC nand, and in
fact the samsung bsp for the processor used in our project (s3c6410)
actually contained a hack similar to this patch but less portable to
enable use of their NAND parts. I discovered this problem when trying to
use a Micron NAND which does not used this layout - I wish samsung would
put their stuff in main-line to avoid this type of problem.

Currently this patch causes all MLC nand with manufacturer codes from
Samsung and ST(Numonyx) to use this alternative location, since these
are the manufactures that I know of that use this layout.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   15 +++++++++++++++
 drivers/mtd/nand/nand_bbt.c  |    3 +++
 include/linux/mtd/nand.h     |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 85891dc..4a7b864 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -347,6 +347,9 @@ static int nand_block_bad(struct mtd_info *mtd, loff_t ofs, int getchip)
 	struct nand_chip *chip = mtd->priv;
 	u16 bad;
 
+	if (chip->options & NAND_BB_LAST_PAGE)
+		ofs += mtd->erasesize - mtd->writesize;
+
 	page = (int)(ofs >> chip->page_shift) & chip->pagemask;
 
 	if (getchip) {
@@ -396,6 +399,9 @@ static int nand_default_block_markbad(struct mtd_info *mtd, loff_t ofs)
 	uint8_t buf[2] = { 0, 0 };
 	int block, ret;
 
+	if (chip->options & NAND_BB_LAST_PAGE)
+		ofs += mtd->erasesize - mtd->writesize;
+
 	/* Get block number */
 	block = (int)(ofs >> chip->bbt_erase_shift);
 	if (chip->bbt)
@@ -2933,6 +2939,15 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 	if (*maf_id != NAND_MFR_SAMSUNG && !type->pagesize)
 		chip->options &= ~NAND_SAMSUNG_LP_OPTIONS;
 
+	/*
+	 * Bad block marker is stored in the last page of each block
+	 * on Samsung and Hynix MLC devices
+	 */
+	if ((chip->cellinfo & NAND_CI_CELLTYPE_MSK) &&
+			(*maf_id == NAND_MFR_SAMSUNG ||
+			 *maf_id == NAND_MFR_HYNIX))
+		chip->options |= NAND_BB_LAST_PAGE;
+
 	/* Check for AND chips with 4 page planes */
 	if (chip->options & NAND_4PAGE_ARRAY)
 		chip->erase_cmd = multi_erase_cmd;
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 387c45c..ad97c0c 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -432,6 +432,9 @@ static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
 		from = (loff_t)startblock << (this->bbt_erase_shift - 1);
 	}
 
+	if (this->options & NAND_BB_LAST_PAGE)
+		from += mtd->erasesize - (mtd->writesize * len);
+
 	for (i = startblock; i < numblocks;) {
 		int ret;
 
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 50f3aa0..a81b185 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -181,6 +181,8 @@ typedef enum {
 #define NAND_NO_READRDY		0x00000100
 /* Chip does not allow subpage writes */
 #define NAND_NO_SUBPAGE_WRITE	0x00000200
+/* Chip stores bad block marker on the last page of the eraseblock */
+#define NAND_BB_LAST_PAGE	0x00000400
 
 /* Device is one of 'new' xD cards that expose fake nand command set */
 #define NAND_BROKEN_XD		0x00000400
-- 
1.6.5

