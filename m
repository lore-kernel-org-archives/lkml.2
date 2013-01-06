Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3AFWn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:43:56 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:38502 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab3AFWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:43:51 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/8] dma: coh901318: skip hard-coded addresses
Date: Sun, 6 Jan 2013 23:43:38 +0100
Message-ID: <1357512218-5707-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Remove hard-coded target addresses altogether. Skip the prefix
"runtime_*" from the variables, since all of these are now
runtime and their names are unique enough already.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/include/mach/coh901318.h |  2 --
 drivers/dma/coh901318.c                     | 35 +++++++++++------------------
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index fc47d30..185fc59 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -56,7 +56,6 @@ struct coh901318_params {
  * @desc_nbr_max: number of preallocated descriptors
  * @priority_high: prio of channel, 0 low otherwise high.
  * @param: configuration parameters
- * @dev_addr: physical address of periphal connected to channel
  */
 struct coh_dma_channel {
 	const char name[32];
@@ -64,7 +63,6 @@ struct coh_dma_channel {
 	const int desc_nbr_max;
 	const int priority_high;
 	const struct coh901318_params param;
-	const dma_addr_t dev_addr;
 };
 
 /**
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 15e314a..7fa54fb 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1141,8 +1141,8 @@ struct coh901318_chan {
 	unsigned long nbr_active_done;
 	unsigned long busy;
 
-	u32 runtime_addr;
-	u32 runtime_ctrl;
+	u32 addr;
+	u32 ctrl;
 
 	struct coh901318_base *base;
 };
@@ -1253,15 +1253,6 @@ static inline struct coh901318_chan *to_coh901318_chan(struct dma_chan *chan)
 	return container_of(chan, struct coh901318_chan, chan);
 }
 
-static inline dma_addr_t
-cohc_dev_addr(struct coh901318_chan *cohc)
-{
-	/* Runtime supplied address will take precedence */
-	if (cohc->runtime_addr)
-		return cohc->runtime_addr;
-	return cohc->base->platform->chan_conf[cohc->id].dev_addr;
-}
-
 static inline const struct coh901318_params *
 cohc_chan_param(struct coh901318_chan *cohc)
 {
@@ -2118,9 +2109,9 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	 * sure the bits you set per peripheral channel are
 	 * cleared in the default config from the platform.
 	 */
-	ctrl_chained |= cohc->runtime_ctrl;
-	ctrl_last |= cohc->runtime_ctrl;
-	ctrl |= cohc->runtime_ctrl;
+	ctrl_chained |= cohc->ctrl;
+	ctrl_last |= cohc->ctrl;
+	ctrl |= cohc->ctrl;
 
 	if (direction == DMA_MEM_TO_DEV) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
@@ -2169,7 +2160,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	/* initiate allocated lli list */
 	ret = coh901318_lli_fill_sg(&cohc->base->pool, lli, sgl, sg_len,
-				    cohc_dev_addr(cohc),
+				    cohc->addr,
 				    ctrl_chained,
 				    ctrl,
 				    ctrl_last,
@@ -2310,7 +2301,7 @@ static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
 	dma_addr_t addr;
 	enum dma_slave_buswidth addr_width;
 	u32 maxburst;
-	u32 runtime_ctrl = 0;
+	u32 ctrl = 0;
 	int i = 0;
 
 	/* We only support mem to per or per to mem transfers */
@@ -2331,7 +2322,7 @@ static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
 		addr_width);
 	switch (addr_width)  {
 	case DMA_SLAVE_BUSWIDTH_1_BYTE:
-		runtime_ctrl |=
+		ctrl |=
 			COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS |
 			COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
 
@@ -2343,7 +2334,7 @@ static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
 
 		break;
 	case DMA_SLAVE_BUSWIDTH_2_BYTES:
-		runtime_ctrl |=
+		ctrl |=
 			COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS |
 			COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
 
@@ -2356,7 +2347,7 @@ static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
 		break;
 	case DMA_SLAVE_BUSWIDTH_4_BYTES:
 		/* Direction doesn't matter here, it's 32/32 bits */
-		runtime_ctrl |=
+		ctrl |=
 			COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
 			COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
 
@@ -2373,13 +2364,13 @@ static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
 		return;
 	}
 
-	runtime_ctrl |= burst_sizes[i].reg;
+	ctrl |= burst_sizes[i].reg;
 	dev_dbg(COHC_2_DEV(cohc),
 		"selected burst size %d bytes for address width %d bytes, maxburst %d\n",
 		burst_sizes[i].burst_8bit, addr_width, maxburst);
 
-	cohc->runtime_addr = addr;
-	cohc->runtime_ctrl = runtime_ctrl;
+	cohc->addr = addr;
+	cohc->ctrl = ctrl;
 }
 
 static int
-- 
1.7.11.3

