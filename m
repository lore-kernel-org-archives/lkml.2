Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1J1Rx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:53:58 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40460 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab1J1RxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:53:07 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 10/13] mtd/docg3: add erase functions
Date: Fri, 28 Oct 2011 19:51:29 +0200
Message-Id: <1319824292-11085-11-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add erase capability to the docg3 driver. The erase block is
made of 2 physical blocks, as both share all 64 pages. That
makes an erase block of at least 64 kBytes.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |   90 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 92522e0..6e323f3 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1037,6 +1037,96 @@ out:
 }
 
 /**
+ * doc_erase_block - Erase a couple of blocks
+ * @docg3: the device
+ * @block0: the first block to erase (leftmost plane)
+ * @block1: the second block to erase (rightmost plane)
+ *
+ * Erase both blocks, and return operation status
+ *
+ * Returns 0 if erase successful, -EIO if erase issue, -ETIMEOUT if chip not
+ * ready for too long
+ */
+static int doc_erase_block(struct docg3 *docg3, int block0, int block1)
+{
+	int ret, sector;
+
+	doc_dbg("doc_erase_block(blocks=(%d,%d))\n", block0, block1);
+	ret = doc_reset_seq(docg3);
+	if (ret)
+		return -EIO;
+
+	doc_set_reliable_mode(docg3);
+	doc_flash_sequence(docg3, DOC_SEQ_ERASE);
+
+	sector = block0 << DOC_ADDR_BLOCK_SHIFT;
+	doc_flash_command(docg3, DOC_CMD_PROG_BLOCK_ADDR);
+	doc_setup_addr_sector(docg3, sector);
+	sector = block1 << DOC_ADDR_BLOCK_SHIFT;
+	doc_flash_command(docg3, DOC_CMD_PROG_BLOCK_ADDR);
+	doc_setup_addr_sector(docg3, sector);
+	doc_delay(docg3, 1);
+
+	doc_flash_command(docg3, DOC_CMD_ERASECYCLE2);
+	doc_delay(docg3, 2);
+
+	if (is_prot_seq_error(docg3)) {
+		doc_err("Erase blocks %d,%d error\n", block0, block1);
+		return -EIO;
+	}
+
+	return doc_write_erase_wait_status(docg3);
+}
+
+/**
+ * doc_erase - Erase a portion of the chip
+ * @mtd: the device
+ * @info: the erase info
+ *
+ * Erase a bunch of contiguous blocks, by pairs, as a "mtd" page of 1024 is
+ * split into 2 pages of 512 bytes on 2 contiguous blocks.
+ *
+ * Returns 0 if erase successful, -EINVAL if adressing error, -EIO if erase
+ * issue
+ */
+static int doc_erase(struct mtd_info *mtd, struct erase_info *info)
+{
+	struct docg3 *docg3 = mtd->priv;
+	uint64_t len;
+	int block0, block1, page, ret, ofs = 0;
+
+	doc_dbg("doc_erase(from=%lld, len=%lld\n", info->addr, info->len);
+	doc_set_device_id(docg3, docg3->device_id);
+
+	info->state = MTD_ERASE_PENDING;
+	calc_block_sector(info->addr + info->len,
+			  &block0, &block1, &page, &ofs);
+	ret = -EINVAL;
+	if (block1 > docg3->max_block || page || ofs)
+		goto reset_err;
+
+	ret = 0;
+	calc_block_sector(info->addr, &block0, &block1, &page, &ofs);
+	doc_set_reliable_mode(docg3);
+	for (len = info->len; !ret && len > 0; len -= mtd->erasesize) {
+		info->state = MTD_ERASING;
+		ret = doc_erase_block(docg3, block0, block1);
+		block0 += 2;
+		block1 += 2;
+	}
+
+	if (ret)
+		goto reset_err;
+
+	info->state = MTD_ERASE_DONE;
+	return 0;
+
+reset_err:
+	info->state = MTD_ERASE_FAILED;
+	return ret;
+}
+
+/**
  * doc_write_page - Write a single page to the chip
  * @docg3: the device
  * @to: the offset from first block and first page, in bytes, aligned on page
-- 
1.7.5.4

