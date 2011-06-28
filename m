Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1F1KPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:15:45 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:51446 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1F1KLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:11:03 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 2/3] dmaengine: at_hdmac: improve power management routines
Date: Tue, 28 Jun 2011 13:17:56 +0200
Message-Id: <e8b0dceb5995556214d03477662f4ff7caf734e1.1309259835.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
References: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
In-Reply-To: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
References: <fb4657207f9eb34784c10333e11c48b5638542ed.1309259835.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save/restore dma controller state across a suspend-resume sequence.
The prepare() function will wait for the non-cyclic channels to become idle.
It also deals with cyclic operations with the start at next period while
resuming.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/dma/at_hdmac.c      |   88 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/dma/at_hdmac_regs.h |    7 +++
 2 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index fd87b96..7096adb 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1385,27 +1385,113 @@ static void at_dma_shutdown(struct platform_device *pdev)
 	clk_disable(atdma->clk);
 }
 
+static int at_dma_prepare(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct at_dma *atdma = platform_get_drvdata(pdev);
+	struct dma_chan *chan, *_chan;
+
+	list_for_each_entry_safe(chan, _chan, &atdma->dma_common.channels,
+			device_node) {
+		struct at_dma_chan *atchan = to_at_dma_chan(chan);
+		/* wait for transaction completion (except in cyclic case) */
+		if (atc_chan_is_enabled(atchan) &&
+			!test_bit(ATC_IS_CYCLIC, &atchan->status))
+			return -EAGAIN;
+	}
+	return 0;
+}
+
+static void atc_suspend_cyclic(struct at_dma_chan *atchan)
+{
+	struct dma_chan	*chan = &atchan->chan_common;
+
+	/* Channel should be paused by user
+	 * do it anyway even if it is not done already */
+	if (!test_bit(ATC_IS_PAUSED, &atchan->status)) {
+		dev_warn(chan2dev(chan),
+		"cyclic channel not paused, should be done by channel user\n");
+		atc_control(chan, DMA_PAUSE, 0);
+	}
+
+	/* now preserve additional data for cyclic operations */
+	/* next descriptor address in the cyclic list */
+	atchan->save_dscr = channel_readl(atchan, DSCR);
+
+	vdbg_dump_regs(atchan);
+}
+
 static int at_dma_suspend_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct at_dma *atdma = platform_get_drvdata(pdev);
+	struct dma_chan *chan, *_chan;
 
-	at_dma_off(platform_get_drvdata(pdev));
+	/* preserve data */
+	list_for_each_entry_safe(chan, _chan, &atdma->dma_common.channels,
+			device_node) {
+		struct at_dma_chan *atchan = to_at_dma_chan(chan);
+
+		if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+			atc_suspend_cyclic(atchan);
+		atchan->save_cfg = channel_readl(atchan, CFG);
+	}
+	atdma->save_imr = dma_readl(atdma, EBCIMR);
+
+	/* disable DMA controller */
+	at_dma_off(atdma);
 	clk_disable(atdma->clk);
 	return 0;
 }
 
+static void atc_resume_cyclic(struct at_dma_chan *atchan)
+{
+	struct at_dma	*atdma = to_at_dma(atchan->chan_common.device);
+
+	/* restore channel status for cyclic descriptors list:
+	 * next descriptor in the cyclic list at the time of suspend */
+	channel_writel(atchan, SADDR, 0);
+	channel_writel(atchan, DADDR, 0);
+	channel_writel(atchan, CTRLA, 0);
+	channel_writel(atchan, CTRLB, 0);
+	channel_writel(atchan, DSCR, atchan->save_dscr);
+	dma_writel(atdma, CHER, atchan->mask);
+
+	/* channel pause status should be removed by channel user
+	 * We cannot take the initiative to do it here */
+
+	vdbg_dump_regs(atchan);
+}
+
 static int at_dma_resume_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct at_dma *atdma = platform_get_drvdata(pdev);
+	struct dma_chan *chan, *_chan;
 
+	/* bring back DMA controller */
 	clk_enable(atdma->clk);
 	dma_writel(atdma, EN, AT_DMA_ENABLE);
+
+	/* clear any pending interrupt */
+	while (dma_readl(atdma, EBCISR))
+		cpu_relax();
+
+	/* restore saved data */
+	dma_writel(atdma, EBCIER, atdma->save_imr);
+	list_for_each_entry_safe(chan, _chan, &atdma->dma_common.channels,
+			device_node) {
+		struct at_dma_chan *atchan = to_at_dma_chan(chan);
+
+		channel_writel(atchan, CFG, atchan->save_cfg);
+		if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+			atc_resume_cyclic(atchan);
+	}
 	return 0;
 }
 
 static const struct dev_pm_ops at_dma_dev_pm_ops = {
+	.prepare = at_dma_prepare,
 	.suspend_noirq = at_dma_suspend_noirq,
 	.resume_noirq = at_dma_resume_noirq,
 };
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 087dbf1..6f0c4a3 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -204,6 +204,9 @@ enum atc_status {
  * @status: transmit status information from irq/prep* functions
  *                to tasklet (use atomic operations)
  * @tasklet: bottom half to finish transaction work
+ * @save_cfg: configuration register that is saved on suspend/resume cycle
+ * @save_dscr: for cyclic operations, preserve next descriptor address in
+ *             the cyclic list on suspend/resume cycle
  * @lock: serializes enqueue/dequeue operations to descriptors lists
  * @completed_cookie: identifier for the most recently completed operation
  * @active_list: list of descriptors dmaengine is being running on
@@ -218,6 +221,8 @@ struct at_dma_chan {
 	u8			mask;
 	unsigned long		status;
 	struct tasklet_struct	tasklet;
+	u32			save_cfg;
+	u32			save_dscr;
 
 	spinlock_t		lock;
 
@@ -248,6 +253,7 @@ static inline struct at_dma_chan *to_at_dma_chan(struct dma_chan *dchan)
  * @chan_common: common dmaengine dma_device object members
  * @ch_regs: memory mapped register base
  * @clk: dma controller clock
+ * @save_imr: interrupt mask register that is saved on suspend/resume cycle
  * @all_chan_mask: all channels availlable in a mask
  * @dma_desc_pool: base of DMA descriptor region (DMA address)
  * @chan: channels table to store at_dma_chan structures
@@ -256,6 +262,7 @@ struct at_dma {
 	struct dma_device	dma_common;
 	void __iomem		*regs;
 	struct clk		*clk;
+	u32			save_imr;
 
 	u8			all_chan_mask;
 
-- 
1.7.3

