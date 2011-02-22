Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1BVKv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:51:27 -0500
Received: from www.tglx.de ([62.245.132.106]:60606 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab1BVKv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:51:26 -0500
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] omap3: nand: report corrected ecc errors
From: John Ogness <john.ogness@linutronix.de>
Date: Tue, 22 Feb 2011 11:50:56 +0100
Message-ID: <87oc64qr5b.fsf@vostro.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

The number of corrected ECC errors should be reported since other MTD
systems make use of this information (such as UBI data scrubbing).

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
Patch against linux-next-20110221.

 drivers/mtd/nand/omap2.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 4e33972..a58465c 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -773,7 +773,7 @@ static int omap_compare_ecc(u8 *ecc_data1,	/* read from NAND memory */
 
 		page_data[find_byte] ^= (1 << find_bit);
 
-		return 0;
+		return 1;
 	default:
 		if (isEccFF) {
 			if (ecc_data2[0] == 0 &&
@@ -803,6 +803,7 @@ static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 							mtd);
 	int blockCnt = 0, i = 0, ret = 0;
+	int stat = 0;
 
 	/* Ex NAND_ECC_HW12_2048 */
 	if ((info->nand.ecc.mode == NAND_ECC_HW) &&
@@ -816,12 +817,13 @@ static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 			ret = omap_compare_ecc(read_ecc, calc_ecc, dat);
 			if (ret < 0)
 				return ret;
+			stat += ret;
 		}
 		read_ecc += 3;
 		calc_ecc += 3;
 		dat      += 512;
 	}
-	return 0;
+	return stat;
 }
 
 /**
-- 
1.5.6.5
