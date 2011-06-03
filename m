Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1FCNJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:09:24 -0400
Received: from mail.bugwerft.de ([212.112.241.193]:35359 "EHLO
	mail.bugwerft.de" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755041Ab1FCNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:09:23 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 09:09:23 EDT
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        Lei Wen <leiwen@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        David Woodhouse <David.Woodhouse@intel.com>, stable@kernel.org
Subject: [PATCH] MTD: pxa3xx_nand: Fix blank page ECC mismatch
Date: Fri,  3 Jun 2011 15:03:18 +0200
Message-Id: <1307106198-11965-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced in f8155a40 ("mtd: pxa3xx_nand: rework irq
logic") and causes the PXA3xx NAND controller fail to operate with NAND
flash that has empty pages. According to the comment in this block, the
hardware controller will report a double-bit error for empty pages,
which can and must be ignored.

This patch restores the original behaviour of the driver.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Lei Wen <leiwen@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: stable@kernel.org
---
 drivers/mtd/nand/pxa3xx_nand.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 0c6ed72..60167d1 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -687,6 +687,8 @@ static int pxa3xx_nand_read_page_hwecc(struct mtd_info *mtd,
 		 * OOB, ignore such double bit errors
 		 */
 		if (is_buf_blank(buf, mtd->writesize))
+			info->retcode = ERR_NONE;
+		else
 			mtd->ecc_stats.failed++;
 	}
 
-- 
1.7.5.1

