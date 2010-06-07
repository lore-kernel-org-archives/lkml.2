Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0FGJlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:41:03 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:44523 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488Ab0FGJk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:40:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] DMAENGINE: ste_dma40: support older silicon
Date: Mon, 7 Jun 2010 11:40:47 +0200
Message-ID: <1275903647-23267-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure the DMA40 driver will also work on the oldest
silicon revisions that have the on-chip memory on another location
in the DB8500 and also requires explicit suspend before starting
or resuming a logical channel.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Dan: this patch applies on top of the previous 18 patches, sorry
for the spamming but they are atleaset quite clearly cut and broken
down.
---
 arch/arm/mach-ux500/devices-db8500.c           |    2 +
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    1 +
 drivers/dma/ste_dma40.c                        |   32 +++++++++++++++++++++---
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index e2b7c31..c62cdbe 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -213,4 +213,6 @@ void dma40_u8500ed_fixup(void)
 	dma40_plat_data.memcpy_len = 0;
 	dma40_resources[0].start = U8500_DMA_BASE_ED;
 	dma40_resources[0].end = U8500_DMA_BASE_ED + SZ_4K - 1;
+	dma40_resources[1].start = U8500_DMA_LCPA_BASE_ED;
+	dma40_resources[1].end = U8500_DMA_LCPA_BASE_ED + 2 * SZ_1K - 1;
 }
diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index 897fa35..8a8646b 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -17,6 +17,7 @@
 #define U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
 /* Use bank 4 for DMA LCPA */
 #define U8500_DMA_LCPA_BASE	U8500_ESRAM_BANK4
+#define U8500_DMA_LCPA_BASE_ED	U8500_ESRAM_BANK4 + 0x4000
 
 #define U8500_PER3_BASE		0x80000000
 #define U8500_STM_BASE		0x80100000
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0829ddb..4ab86b0 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -218,6 +218,7 @@ struct d40_chan {
  * the same physical register.
  * @dev: The device structure.
  * @virtbase: The virtual base address of the DMA's register.
+ * @rev: silicon revision detected.
  * @clk: Pointer to the DMA clock structure.
  * @phy_start: Physical memory start of the DMA registers.
  * @phy_size: Size of the DMA register map.
@@ -250,6 +251,7 @@ struct d40_base {
 	spinlock_t			 execmd_lock;
 	struct device			 *dev;
 	void __iomem			 *virtbase;
+	u8				  rev:4;
 	struct clk			 *clk;
 	phys_addr_t			  phy_start;
 	resource_size_t			  phy_size;
@@ -757,6 +759,17 @@ static dma_cookie_t d40_tx_submit(struct dma_async_tx_descriptor *tx)
 
 static int d40_start(struct d40_chan *d40c)
 {
+	if (d40c->base->rev == 0) {
+		int err;
+
+		if (d40c->log_num != D40_PHY_CHAN) {
+			err = d40_channel_execute_command(d40c,
+							  D40_DMA_SUSPEND_REQ);
+			if (err)
+				return err;
+		}
+	}
+
 	if (d40c->log_num != D40_PHY_CHAN)
 		d40_config_set_event(d40c, true);
 
@@ -1456,6 +1469,13 @@ static int d40_resume(struct dma_chan *chan)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
+	if (d40c->base->rev == 0)
+		if (d40c->log_num != D40_PHY_CHAN) {
+			res = d40_channel_execute_command(d40c,
+							  D40_DMA_SUSPEND_REQ);
+			goto no_suspend;
+		}
+
 	/* If bytes left to transfer or linked tx resume job */
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c)) {
 		if (d40c->log_num != D40_PHY_CHAN)
@@ -1463,6 +1483,7 @@ static int d40_resume(struct dma_chan *chan)
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
 	}
 
+no_suspend:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -2292,6 +2313,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	int num_log_chans = 0;
 	int num_phy_chans;
 	int i;
+	u32 val;
 
 	clk = clk_get(&pdev->dev, NULL);
 
@@ -2330,12 +2352,13 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		}
 	}
 
-	i = readl(virtbase + D40_DREG_PERIPHID2);
+	/* Get silicon revision */
+	val = readl(virtbase + D40_DREG_PERIPHID2);
 
-	if ((i & 0xf) != D40_PERIPHID2_DESIGNER) {
+	if ((val & 0xf) != D40_PERIPHID2_DESIGNER) {
 		dev_err(&pdev->dev,
 			"[%s] Unknown designer! Got %x wanted %x\n",
-			__func__, i & 0xf, D40_PERIPHID2_DESIGNER);
+			__func__, val & 0xf, D40_PERIPHID2_DESIGNER);
 		goto failure;
 	}
 
@@ -2343,7 +2366,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
 
 	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x\n",
-		 (i >> 4) & 0xf, res->start);
+		 (val >> 4) & 0xf, res->start);
 
 	plat_data = pdev->dev.platform_data;
 
@@ -2365,6 +2388,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		goto failure;
 	}
 
+	base->rev = (val >> 4) & 0xf;
 	base->clk = clk;
 	base->num_phy_chans = num_phy_chans;
 	base->num_log_chans = num_log_chans;
-- 
1.6.3.3

