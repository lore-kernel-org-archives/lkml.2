Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab1F0JgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:36:07 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51388 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757166Ab1F0JeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:34:15 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Marklund <robert.marklund@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH 4/4] dmaengine/ste_dma40: use AMBA PrimeCell helper macros
Date: Mon, 27 Jun 2011 11:33:46 +0200
Message-ID: <1309167226-23447-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The DMA40 is not a PrimeCell from ARM, but it still use the same
ID registers. So let's utilize the existing macros in the
PrimeCell header to identify manufacturer and revision of the IP
block instead of reinventing the wheel.

Cc: Robert Marklund <robert.marklund@stericsson.com>
Cc: Per Forlin <per.forlin@linaro.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c    |   72 ++++++++++++++++----------------------------
 drivers/dma/ste_dma40_ll.h |    3 --
 2 files changed, 26 insertions(+), 49 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 096167f..75ba586 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -13,6 +13,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/err.h>
+#include <linux/amba/bus.h>
 
 #include <plat/ste_dma40.h>
 
@@ -44,9 +45,6 @@
 #define D40_ALLOC_PHY		(1 << 30)
 #define D40_ALLOC_LOG_FREE	0
 
-/* Hardware designer of the block */
-#define D40_HW_DESIGNER 0x8
-
 /**
  * enum 40_command - The different commands and/or statuses.
  *
@@ -2561,25 +2559,6 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 {
-	static const struct d40_reg_val dma_id_regs[] = {
-		/* Peripheral Id */
-		{ .reg = D40_DREG_PERIPHID0, .val = 0x0040},
-		{ .reg = D40_DREG_PERIPHID1, .val = 0x0000},
-		/*
-		 * D40_DREG_PERIPHID2 Depends on HW revision:
-		 *  DB8500ed has 0x0008,
-		 *  ? has 0x0018,
-		 *  DB8500v1 has 0x0028
-		 *  DB8500v2 has 0x0038
-		 */
-		{ .reg = D40_DREG_PERIPHID3, .val = 0x0000},
-
-		/* PCell Id */
-		{ .reg = D40_DREG_CELLID0, .val = 0x000d},
-		{ .reg = D40_DREG_CELLID1, .val = 0x00f0},
-		{ .reg = D40_DREG_CELLID2, .val = 0x0005},
-		{ .reg = D40_DREG_CELLID3, .val = 0x00b1}
-	};
 	struct stedma40_platform_data *plat_data;
 	struct clk *clk = NULL;
 	void __iomem *virtbase = NULL;
@@ -2588,8 +2567,9 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	int num_log_chans = 0;
 	int num_phy_chans;
 	int i;
-	u32 val;
-	u32 rev;
+	u32 pid;
+	u32 cid;
+	u8 rev;
 
 	clk = clk_get(&pdev->dev, NULL);
 
@@ -2613,32 +2593,32 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	if (!virtbase)
 		goto failure;
 
-	/* HW version check */
-	for (i = 0; i < ARRAY_SIZE(dma_id_regs); i++) {
-		if (dma_id_regs[i].val !=
-		    readl(virtbase + dma_id_regs[i].reg)) {
-			d40_err(&pdev->dev,
-				"Unknown hardware! Expected 0x%x at 0x%x but got 0x%x\n",
-				dma_id_regs[i].val,
-				dma_id_regs[i].reg,
-				readl(virtbase + dma_id_regs[i].reg));
-			goto failure;
-		}
-	}
-
-	/* Get silicon revision and designer */
-	val = readl(virtbase + D40_DREG_PERIPHID2);
+	/* This is just a regular AMBA PrimeCell ID actually */
+	for (pid = 0, i = 0; i < 4; i++)
+		pid |= (readl(virtbase + resource_size(res) - 0x20 + 4 * i)
+			& 255) << (i * 8);
+	for (cid = 0, i = 0; i < 4; i++)
+		cid |= (readl(virtbase + resource_size(res) - 0x10 + 4 * i)
+			& 255) << (i * 8);
 
-	if ((val & D40_DREG_PERIPHID2_DESIGNER_MASK) !=
-	    D40_HW_DESIGNER) {
+	if (cid != AMBA_CID) {
+		d40_err(&pdev->dev, "Unknown hardware! No PrimeCell ID\n");
+		goto failure;
+	}
+	if (AMBA_MANF_BITS(pid) != AMBA_VENDOR_ST) {
 		d40_err(&pdev->dev, "Unknown designer! Got %x wanted %x\n",
-			val & D40_DREG_PERIPHID2_DESIGNER_MASK,
-			D40_HW_DESIGNER);
+			AMBA_MANF_BITS(pid),
+			AMBA_VENDOR_ST);
 		goto failure;
 	}
-
-	rev = (val & D40_DREG_PERIPHID2_REV_MASK) >>
-		D40_DREG_PERIPHID2_REV_POS;
+	/*
+	 * HW revision:
+	 * DB8500ed has revision 0
+	 * ? has revision 1
+	 * DB8500v1 has revision 2
+	 * DB8500v2 has revision 3
+	 */
+	rev = AMBA_REV_BITS(pid);
 
 	/* The number of physical channels on this HW */
 	num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 195ee65..b44c4551 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -184,9 +184,6 @@
 #define D40_DREG_PERIPHID0	0xFE0
 #define D40_DREG_PERIPHID1	0xFE4
 #define D40_DREG_PERIPHID2	0xFE8
-#define D40_DREG_PERIPHID2_REV_POS 4
-#define D40_DREG_PERIPHID2_REV_MASK (0xf << D40_DREG_PERIPHID2_REV_POS)
-#define D40_DREG_PERIPHID2_DESIGNER_MASK 0xf
 #define D40_DREG_PERIPHID3	0xFEC
 #define D40_DREG_CELLID0	0xFF0
 #define D40_DREG_CELLID1	0xFF4
-- 
1.7.3.2

