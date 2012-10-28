Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2J1X07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:26:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41747 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab2J1X04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:56 -0400
Message-Id: <20121028231538.636389099@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 005/105] mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[Brian Norris: This is a backport for v3.2 stable.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/nand/nand_base.c |    9 +++------
 include/linux/mtd/nand.h     |    3 ---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 3ed9c5e..daed698 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2903,9 +2903,7 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
 	if (le16_to_cpu(p->features) & 1)
 		*busw = NAND_BUSWIDTH_16;
 
-	chip->options &= ~NAND_CHIPOPTIONS_MSK;
-	chip->options |= (NAND_NO_READRDY |
-			NAND_NO_AUTOINCR) & NAND_CHIPOPTIONS_MSK;
+	chip->options |= NAND_NO_READRDY | NAND_NO_AUTOINCR;
 
 	return 1;
 }
@@ -3069,9 +3067,8 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
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
index 904131b..b25b09b 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -215,9 +215,6 @@ typedef enum {
 #define NAND_SUBPAGE_READ(chip) ((chip->ecc.mode == NAND_ECC_SOFT) \
 					&& (chip->page_shift > 9))
 
-/* Mask to zero out the chip options, which come from the id table */
-#define NAND_CHIPOPTIONS_MSK	(0x0000ffff & ~NAND_NO_AUTOINCR)
-
 /* Non chip related options */
 /* This option skips the bbt scan during initialization. */
 #define NAND_SKIP_BBTSCAN	0x00010000


