Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab2KZRC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2KZRCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 038/270] mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver
Date: Mon, 26 Nov 2012 14:55:28 -0200
Message-Id: <1353949160-26803-39-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit bf7a01bf7987b63b121d572b240c132ec44129c4 upstream.

The NAND_CHIPOPTIONS_MSK has limited utility and is causing real bugs. It
silently masks off at least one flag that might be set by the driver
(NAND_NO_SUBPAGE_WRITE). This breaks the GPMI NAND driver and possibly
others.

Really, as long as driver writers exercise a small amount of care with
NAND_* options, this mask is not necessary at all; it was only here to
prevent certain options from accidentally being set by the driver. But the
original thought turns out to be a bad idea occasionally. Thus, kill it.

Note, this patch fixes some major gpmi-nand breakage.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Tested-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mtd/nand/nand_base.c |    8 +++-----
 include/linux/mtd/nand.h     |    3 ---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index a11253a..c429abd 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2914,8 +2914,7 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
 	if (le16_to_cpu(p->features) & 1)
 		*busw = NAND_BUSWIDTH_16;
 
-	chip->options &= ~NAND_CHIPOPTIONS_MSK;
-	chip->options |= NAND_NO_READRDY & NAND_CHIPOPTIONS_MSK;
+	chip->options |= NAND_NO_READRDY;
 
 	pr_info("ONFI flash detected\n");
 	return 1;
@@ -3080,9 +3079,8 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 			mtd->erasesize <<= ((id_data[3] & 0x03) << 1);
 		}
 	}
-	/* Get chip options, preserve non chip based options */
-	chip->options &= ~NAND_CHIPOPTIONS_MSK;
-	chip->options |= type->options & NAND_CHIPOPTIONS_MSK;
+	/* Get chip options */
+	chip->options |= type->options;
 
 	/*
 	 * Check if chip is not a Samsung device. Do not clear the
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 57977c6..e5cf2c8 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -212,9 +212,6 @@ typedef enum {
 #define NAND_SUBPAGE_READ(chip) ((chip->ecc.mode == NAND_ECC_SOFT) \
 					&& (chip->page_shift > 9))
 
-/* Mask to zero out the chip options, which come from the id table */
-#define NAND_CHIPOPTIONS_MSK	0x0000ffff
-
 /* Non chip related options */
 /* This option skips the bbt scan during initialization. */
 #define NAND_SKIP_BBTSCAN	0x00010000
-- 
1.7.9.5

