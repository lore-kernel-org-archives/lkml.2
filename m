Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2A0O0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:26:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38756 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2A0OYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:24:51 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/onenand: use string library
Date: Fri, 27 Jan 2012 23:24:50 +0900
Message-Id: <1327674295-3700-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use memchr_inv to check if the data contains all 0xFF bytes.
  It is faster than looping for each byte.

- Use memcmp to compare memory areas

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/onenand/onenand_base.c |    8 ++------
 drivers/mtd/onenand/onenand_bbt.c  |   10 +++-------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index a061bc1..374605f 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -3673,7 +3673,7 @@ static void flexonenand_get_size(struct mtd_info *mtd)
 static int flexonenand_check_blocks_erased(struct mtd_info *mtd, int start, int end)
 {
 	struct onenand_chip *this = mtd->priv;
-	int i, ret;
+	int ret;
 	int block;
 	struct mtd_oob_ops ops = {
 		.mode = MTD_OPS_PLACE_OOB,
@@ -3699,11 +3699,7 @@ static int flexonenand_check_blocks_erased(struct mtd_info *mtd, int start, int
 		if (ret)
 			return ret;
 
-		for (i = 0; i < mtd->oobsize; i++)
-			if (this->oob_buf[i] != 0xff)
-				break;
-
-		if (i != mtd->oobsize) {
+		if (memchr_inv(this->oob_buf, 0xff, mtd->oobsize)) {
 			printk(KERN_WARNING "%s: Block %d not erased.\n",
 				__func__, block);
 			return 1;
diff --git a/drivers/mtd/onenand/onenand_bbt.c b/drivers/mtd/onenand/onenand_bbt.c
index 66fe3b7..8b1277b 100644
--- a/drivers/mtd/onenand/onenand_bbt.c
+++ b/drivers/mtd/onenand/onenand_bbt.c
@@ -32,14 +32,10 @@
  */
 static int check_short_pattern(uint8_t *buf, int len, int paglen, struct nand_bbt_descr *td)
 {
-	int i;
-	uint8_t *p = buf;
-
 	/* Compare the pattern */
-	for (i = 0; i < td->len; i++) {
-		if (p[i] != td->pattern[i])
-			return -1;
-	}
+	if (memcmp(buf, td->pattern, td->len))
+		return -1;
+
         return 0;
 }
 
-- 
1.7.4.4

