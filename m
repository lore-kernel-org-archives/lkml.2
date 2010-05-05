Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0EEENz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 00:13:55 -0400
Received: from [69.28.251.93] ([69.28.251.93]:41057 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab0EEENx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 00:13:53 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 4 May 2010 20:58:03 -0700
Subject: [PATCHv2 1/2] mtd: nand: Extend NAND flash detection to new MLC chips
Message-Id: <10137ab89de6e6d229798d6f397688b0807024da@localhost.localdomain>
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

Some of the newer MLC devices have a 6-byte ID sequence in which
several field definitions differ from older chips in a manner that is
not backward compatible.  For instance:

Samsung K9GAG08U0M (5-byte sequence): ec d5 14 b6 74
4th byte, bits 1:0 encode the page size: 0=1KiB, 1=2KiB, 2=4KiB, 3=8KiB
4th byte, bits 5:4 encode the block size: 0=64KiB, 1=128KiB, ...
4th byte, bit 6 encodes the OOB size: 0=8B/512B, 1=16B/512B

Samsung K9GAG08U0D (6-byte sequence): ec d5 94 29 34 41
4th byte, bits 1:0 encode the page size: 0=2KiB, 1=4KiB, 3=8KiB, 4=rsvd
4th byte, bits 7;5:4 encode the block size: 0=128KiB, 1=256KiB, ...
4th byte, bits 6;3:2 encode the OOB size: 1=128B/page, 2=218B/page

This patch uses the new 6-byte scheme if the following conditions are
all true:

1) The ID code wraps around after exactly 6 bytes

2) Manufacturer is Samsung

3) 6th byte is zero

The patch also extends the maximum OOB size from 128B to 256B.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   64 ++++++++++++++++++++++++++++-------------
 include/linux/mtd/nand.h     |    2 +-
 2 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index b9dc65c..85891dc 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2774,8 +2774,8 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 						  int busw, int *maf_id,
 						  struct nand_flash_dev *type)
 {
-	int dev_id, maf_idx;
-	int tmp_id, tmp_manf;
+	int i, dev_id, maf_idx;
+	u8 id_data[8];
 
 	/* Select the device */
 	chip->select_chip(mtd, 0);
@@ -2801,15 +2801,15 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 
 	chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);
 
-	/* Read manufacturer and device IDs */
+	/* Read entire ID string */
 
-	tmp_manf = chip->read_byte(mtd);
-	tmp_id = chip->read_byte(mtd);
+	for (i = 0; i < 8; i++)
+		id_data[i] = chip->read_byte(mtd);
 
-	if (tmp_manf != *maf_id || tmp_id != dev_id) {
+	if (id_data[0] != *maf_id || id_data[1] != dev_id) {
 		printk(KERN_INFO "%s: second ID read did not match "
 		       "%02x,%02x against %02x,%02x\n", __func__,
-		       *maf_id, dev_id, tmp_manf, tmp_id);
+		       *maf_id, dev_id, id_data[0], id_data[1]);
 		return ERR_PTR(-ENODEV);
 	}
 
@@ -2832,21 +2832,45 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 	if (!type->pagesize) {
 		int extid;
 		/* The 3rd id byte holds MLC / multichip data */
-		chip->cellinfo = chip->read_byte(mtd);
+		chip->cellinfo = id_data[2];
 		/* The 4th id byte is the important one */
-		extid = chip->read_byte(mtd);
-		/* Calc pagesize */
-		mtd->writesize = 1024 << (extid & 0x3);
-		extid >>= 2;
-		/* Calc oobsize */
-		mtd->oobsize = (8 << (extid & 0x01)) * (mtd->writesize >> 9);
-		extid >>= 2;
-		/* Calc blocksize. Blocksize is multiples of 64KiB */
-		mtd->erasesize = (64 * 1024) << (extid & 0x03);
-		extid >>= 2;
-		/* Get buswidth information */
-		busw = (extid & 0x01) ? NAND_BUSWIDTH_16 : 0;
+		extid = id_data[3];
 
+		/*
+		 * Field definitions are in the following datasheets:
+		 * Old style (4,5 byte ID): Samsung K9GAG08U0M (p.32)
+		 * New style   (6 byte ID): Samsung K9GAG08U0D (p.40)
+		 *
+		 * Check for wraparound + Samsung ID + nonzero 6th byte
+		 * to decide what to do.
+		 */
+		if (id_data[0] == id_data[6] && id_data[1] == id_data[7] &&
+				id_data[0] == NAND_MFR_SAMSUNG &&
+				id_data[5] != 0x00) {
+			/* Calc pagesize */
+			mtd->writesize = 2048 << (extid & 0x03);
+			extid >>= 2;
+			/* Calc oobsize */
+			mtd->oobsize = (extid & 0x03) == 0x01 ? 128 : 218;
+			extid >>= 2;
+			/* Calc blocksize */
+			mtd->erasesize = (128 * 1024) <<
+				(((extid >> 1) & 0x04) | (extid & 0x03));
+			busw = 0;
+		} else {
+			/* Calc pagesize */
+			mtd->writesize = 1024 << (extid & 0x03);
+			extid >>= 2;
+			/* Calc oobsize */
+			mtd->oobsize = (8 << (extid & 0x01)) *
+				(mtd->writesize >> 9);
+			extid >>= 2;
+			/* Calc blocksize. Blocksize is multiples of 64KiB */
+			mtd->erasesize = (64 * 1024) << (extid & 0x03);
+			extid >>= 2;
+			/* Get buswidth information */
+			busw = (extid & 0x01) ? NAND_BUSWIDTH_16 : 0;
+		}
 	} else {
 		/*
 		 * Old devices have chip data hardcoded in the device id table
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 8bdacb8..50f3aa0 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -53,7 +53,7 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
  * is supported now. If you add a chip with bigger oobsize/page
  * adjust this accordingly.
  */
-#define NAND_MAX_OOBSIZE	128
+#define NAND_MAX_OOBSIZE	256
 #define NAND_MAX_PAGESIZE	4096
 
 /*
-- 
1.6.5

