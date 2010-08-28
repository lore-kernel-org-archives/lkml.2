Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0H1Ucs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 16:32:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45091 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0H1Ucr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 16:32:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mtd: Blackfin NFC: fix invalid free in remove()
Date: Sat, 28 Aug 2010 16:42:04 -0400
Message-Id: <1283028125-6027-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since info->mtd isn't dynamically allocated, we shouldn't attempt to
kfree() it.  Otherwise we get random fun corruption when unloading
the driver built as a module.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
note: this should be merged for 2.6.36 and probably sent to stable trees

 drivers/mtd/nand/bf5xx_nand.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 162c5ea..6fbeefa 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -682,7 +682,6 @@ static int __devinit bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
 static int __devexit bf5xx_nand_remove(struct platform_device *pdev)
 {
 	struct bf5xx_nand_info *info = to_nand_info(pdev);
-	struct mtd_info *mtd = NULL;
 
 	platform_set_drvdata(pdev, NULL);
 
@@ -690,11 +689,7 @@ static int __devexit bf5xx_nand_remove(struct platform_device *pdev)
 	 * and their partitions, then go through freeing the
 	 * resources used
 	 */
-	mtd = &info->mtd;
-	if (mtd) {
-		nand_release(mtd);
-		kfree(mtd);
-	}
+	nand_release(&info->mtd);
 
 	peripheral_free_list(bfin_nfc_pin_req);
 	bf5xx_nand_dma_remove(info);
-- 
1.7.2.2

