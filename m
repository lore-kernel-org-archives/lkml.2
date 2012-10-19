Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab2JSCyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:54:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:52511 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047Ab2JSCta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 64/76] mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver
Date: Thu, 18 Oct 2012 19:47:28 -0700
Message-Id: <20121019024400.424982142@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


index a11253a..c429abd 100644
---
 drivers/mtd/nand/nand_base.c |    8 +++-----
 include/linux/mtd/nand.h     |    3 ---
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2914,8 +2914,7 @@ static int nand_flash_detect_onfi(struct
 	if (le16_to_cpu(p->features) & 1)
 		*busw = NAND_BUSWIDTH_16;
 
-	chip->options &= ~NAND_CHIPOPTIONS_MSK;
-	chip->options |= NAND_NO_READRDY & NAND_CHIPOPTIONS_MSK;
+	chip->options |= NAND_NO_READRDY;
 
 	pr_info("ONFI flash detected\n");
 	return 1;
@@ -3080,9 +3079,8 @@ static struct nand_flash_dev *nand_get_f
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


