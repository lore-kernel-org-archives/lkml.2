Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3AFWoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:44:34 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:50690 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255Ab3AFWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:44:21 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 8/8] dma: coh901318: cut down on platform data abstraction
Date: Sun, 6 Jan 2013 23:44:09 +0100
Message-ID: <1357512249-5848-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Since we merged the platform data into the driver we can
remove the middle-man abstraction.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/coh901318.c | 74 +++++--------------------------------------------
 1 file changed, 7 insertions(+), 67 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 0604273..a2f079a 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -199,16 +199,6 @@ struct coh_dma_channel {
 };
 
 /**
- * dma_access_memory_state_t - register dma for memory access
- *
- * @dev: The dma device
- * @active:  1 means dma intends to access memory
- *           0 means dma wont access memory
- */
-typedef void (*dma_access_memory_state_t)(struct device *dev,
-					  bool active);
-
-/**
  * struct powersave - DMA power save structure
  * @lock: lock protecting data in this struct
  * @started_channels: bit mask indicating active dma channels
@@ -218,22 +208,6 @@ struct powersave {
 	u64 started_channels;
 };
 
-/**
- * struct coh901318_platform - platform arch structure
- * @chans_slave: specifying dma slave channels
- * @chans_memcpy: specifying dma memcpy channels
- * @access_memory_state: requesting DMA memory access (on / off)
- * @chan_conf: dma channel configurations
- * @max_channels: max number of dma chanenls
- */
-struct coh901318_platform {
-	const int *chans_slave;
-	const int *chans_memcpy;
-	const dma_access_memory_state_t access_memory_state;
-	const struct coh_dma_channel *chan_conf;
-	const int max_channels;
-};
-
 /* points out all dma slave channels.
  * Syntax is [A1, B1, A2, B2, .... ,-1,-1]
  * Select all channels from A to B, end of list is marked with -1,-1
@@ -246,15 +220,6 @@ static int dma_slave_channels[] = {
 static int dma_memcpy_channels[] = {
 	U300_DMA_GENERAL_PURPOSE_0, U300_DMA_GENERAL_PURPOSE_8, -1, -1};
 
-/** register dma for memory access
- *
- * active  1 means dma intends to access memory
- *         0 means dma wont access memory
- */
-static void coh901318_access_memory_state(struct device *dev, bool active)
-{
-}
-
 #define flags_memcpy_config (COH901318_CX_CFG_CH_DISABLE | \
 			COH901318_CX_CFG_RM_MEMORY_TO_MEMORY | \
 			COH901318_CX_CFG_LCR_DISABLE | \
@@ -1291,14 +1256,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 	}
 };
 
-static struct coh901318_platform coh901318_platform = {
-	.chans_slave = dma_slave_channels,
-	.chans_memcpy = dma_memcpy_channels,
-	.access_memory_state = coh901318_access_memory_state,
-	.chan_conf = chan_config,
-	.max_channels = U300_DMA_CHANNELS,
-};
-
 #define COHC_2_DEV(cohc) (&cohc->chan.dev->device)
 
 #ifdef VERBOSE_DEBUG
@@ -1327,7 +1284,6 @@ struct coh901318_base {
 	struct dma_device dma_slave;
 	struct dma_device dma_memcpy;
 	struct coh901318_chan *chans;
-	struct coh901318_platform *platform;
 };
 
 struct coh901318_chan {
@@ -1395,7 +1351,7 @@ static int coh901318_debugfs_read(struct file *file, char __user *buf,
 
 	tmp += sprintf(tmp, "DMA -- enabled dma channels\n");
 
-	for (i = 0; i < debugfs_dma_base->platform->max_channels; i++)
+	for (i = 0; i < U300_DMA_CHANNELS; i++)
 		if (started_channels & (1 << i))
 			tmp += sprintf(tmp, "channel %d\n", i);
 
@@ -1463,13 +1419,13 @@ static inline struct coh901318_chan *to_coh901318_chan(struct dma_chan *chan)
 static inline const struct coh901318_params *
 cohc_chan_param(struct coh901318_chan *cohc)
 {
-	return &cohc->base->platform->chan_conf[cohc->id].param;
+	return &chan_config[cohc->id].param;
 }
 
 static inline const struct coh_dma_channel *
 cohc_chan_conf(struct coh901318_chan *cohc)
 {
-	return &cohc->base->platform->chan_conf[cohc->id];
+	return &chan_config[cohc->id];
 }
 
 static void enable_powersave(struct coh901318_chan *cohc)
@@ -1481,12 +1437,6 @@ static void enable_powersave(struct coh901318_chan *cohc)
 
 	pm->started_channels &= ~(1ULL << cohc->id);
 
-	if (!pm->started_channels) {
-		/* DMA no longer intends to access memory */
-		cohc->base->platform->access_memory_state(cohc->base->dev,
-							  false);
-	}
-
 	spin_unlock_irqrestore(&pm->lock, flags);
 }
 static void disable_powersave(struct coh901318_chan *cohc)
@@ -1496,12 +1446,6 @@ static void disable_powersave(struct coh901318_chan *cohc)
 
 	spin_lock_irqsave(&pm->lock, flags);
 
-	if (!pm->started_channels) {
-		/* DMA intends to access memory */
-		cohc->base->platform->access_memory_state(cohc->base->dev,
-							  true);
-	}
-
 	pm->started_channels |= (1ULL << cohc->id);
 
 	spin_unlock_irqrestore(&pm->lock, flags);
@@ -1860,7 +1804,7 @@ static int coh901318_config(struct coh901318_chan *cohc,
 	if (param)
 		p = param;
 	else
-		p = &cohc->base->platform->chan_conf[channel].param;
+		p = cohc_chan_param(cohc);
 
 	/* Clear any pending BE or TC interrupt */
 	if (channel < 32) {
@@ -2695,7 +2639,6 @@ void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 static int __init coh901318_probe(struct platform_device *pdev)
 {
 	int err = 0;
-	struct coh901318_platform *pdata;
 	struct coh901318_base *base;
 	int irq;
 	struct resource *io;
@@ -2711,11 +2654,9 @@ static int __init coh901318_probe(struct platform_device *pdev)
 				    pdev->dev.driver->name) == NULL)
 		return -ENOMEM;
 
-	pdata = &coh901318_platform,
-
 	base = devm_kzalloc(&pdev->dev,
 			    ALIGN(sizeof(struct coh901318_base), 4) +
-			    pdata->max_channels *
+			    U300_DMA_CHANNELS *
 			    sizeof(struct coh901318_chan),
 			    GFP_KERNEL);
 	if (!base)
@@ -2728,7 +2669,6 @@ static int __init coh901318_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	base->dev = &pdev->dev;
-	base->platform = pdata;
 	spin_lock_init(&base->pm.lock);
 	base->pm.started_channels = 0;
 
@@ -2750,7 +2690,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 		return err;
 
 	/* init channels for device transfers */
-	coh901318_base_init(&base->dma_slave,  base->platform->chans_slave,
+	coh901318_base_init(&base->dma_slave, dma_slave_channels,
 			    base);
 
 	dma_cap_zero(base->dma_slave.cap_mask);
@@ -2770,7 +2710,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 		goto err_register_slave;
 
 	/* init channels for memcpy */
-	coh901318_base_init(&base->dma_memcpy, base->platform->chans_memcpy,
+	coh901318_base_init(&base->dma_memcpy, dma_memcpy_channels,
 			    base);
 
 	dma_cap_zero(base->dma_memcpy.cap_mask);
-- 
1.7.11.3

