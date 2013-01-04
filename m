Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3ADH5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:57:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50456 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3ADH45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:56:57 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <zonque@gmail.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <ivan.djelic@parrot.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v4 1/3] mtd: nand: omap2: Update nerrors using ecc.strength
Date: Fri, 4 Jan 2013 13:26:49 +0530
Message-ID: <1357286211-5012-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357286211-5012-1-git-send-email-avinashphilip@ti.com>
References: <1357286211-5012-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove check of ecc bytes with 13, number of errors can directly update
from nand ecc strength. This will increase re-usability of the code.
Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX for better
readability and cleaner code.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
Changes since v3:
	- Update commit message.

 drivers/mtd/nand/omap2.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 1d333497c..7d907b7 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -117,6 +117,9 @@
 
 #define OMAP24XX_DMA_GPMC		4
 
+#define BCH8_MAX_ERROR		8	/* upto 8 bit correctable */
+#define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */
+
 /* oob info generated runtime depending on ecc algorithm and layout selected */
 static struct nand_ecclayout omap_oobinfo;
 /* Define some generic bad / good block scan pattern which are used
@@ -1041,7 +1044,7 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 	struct nand_chip *chip = mtd->priv;
 	u32 val;
 
-	nerrors = (info->nand.ecc.bytes == 13) ? 8 : 4;
+	nerrors = info->nand.ecc.strength;
 	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
 	nsectors = 1;
 	/*
@@ -1218,13 +1221,14 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
 #ifdef CONFIG_MTD_NAND_OMAP_BCH8
-	const int hw_errors = 8;
+	const int hw_errors = BCH8_MAX_ERROR;
 #else
-	const int hw_errors = 4;
+	const int hw_errors = BCH4_MAX_ERROR;
 #endif
 	info->bch = NULL;
 
-	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ? 8 : 4;
+	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ?
+		BCH8_MAX_ERROR : BCH4_MAX_ERROR;
 	if (max_errors != hw_errors) {
 		pr_err("cannot configure %d-bit BCH ecc, only %d-bit supported",
 		       max_errors, hw_errors);
-- 
1.7.9.5

