Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab0HIMIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:35 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:41524 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379Ab0HIMIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 06/14] DMAENGINE: ste_dma40: removed a few magic numbers
Date: Mon, 9 Aug 2010 14:08:18 +0200
Message-ID: <1281355698-13261-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Make sure to extract the revision field explicitly and document
what bits are being accessed here without magic numbers.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |   18 ++++++++++++------
 drivers/dma/ste_dma40_ll.h |    3 +++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index a6a7d66..c042103 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -41,7 +41,7 @@
 #define D40_ALLOC_LOG_FREE	0
 
 /* Hardware designer of the block */
-#define D40_PERIPHID2_DESIGNER 0x8
+#define D40_HW_DESIGNER 0x8
 
 /**
  * enum 40_command - The different commands and/or statuses.
@@ -2438,6 +2438,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	int num_phy_chans;
 	int i;
 	u32 val;
+	u32 rev;
 
 	clk = clk_get(&pdev->dev, NULL);
 
@@ -2476,21 +2477,26 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		}
 	}
 
-	/* Get silicon revision */
+	/* Get silicon revision and designer */
 	val = readl(virtbase + D40_DREG_PERIPHID2);
 
-	if ((val & 0xf) != D40_PERIPHID2_DESIGNER) {
+	if ((val & D40_DREG_PERIPHID2_DESIGNER_MASK) !=
+	    D40_HW_DESIGNER) {
 		dev_err(&pdev->dev,
 			"[%s] Unknown designer! Got %x wanted %x\n",
-			__func__, val & 0xf, D40_PERIPHID2_DESIGNER);
+			__func__, val & D40_DREG_PERIPHID2_DESIGNER_MASK,
+			D40_HW_DESIGNER);
 		goto failure;
 	}
 
+	rev = (val & D40_DREG_PERIPHID2_REV_MASK) >>
+		D40_DREG_PERIPHID2_REV_POS;
+
 	/* The number of physical channels on this HW */
 	num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
 
 	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x\n",
-		 (val >> 4) & 0xf, res->start);
+		 rev, res->start);
 
 	plat_data = pdev->dev.platform_data;
 
@@ -2512,7 +2518,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		goto failure;
 	}
 
-	base->rev = (val >> 4) & 0xf;
+	base->rev = rev;
 	base->clk = clk;
 	base->num_phy_chans = num_phy_chans;
 	base->num_log_chans = num_log_chans;
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 0c468c3..7a6acec 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -163,6 +163,9 @@
 #define D40_DREG_PERIPHID0	0xFE0
 #define D40_DREG_PERIPHID1	0xFE4
 #define D40_DREG_PERIPHID2	0xFE8
+#define D40_DREG_PERIPHID2_REV_POS 4
+#define D40_DREG_PERIPHID2_REV_MASK (0xf << D40_DREG_PERIPHID2_REV_POS)
+#define D40_DREG_PERIPHID2_DESIGNER_MASK 0xf
 #define D40_DREG_PERIPHID3	0xFEC
 #define D40_DREG_CELLID0	0xFF0
 #define D40_DREG_CELLID1	0xFF4
-- 
1.6.3.3

