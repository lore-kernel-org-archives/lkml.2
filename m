Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1AYKT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:27 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:44925 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab1AYKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:12 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 06/32] dma40: use helpers for error functions
Date: Tue, 25 Jan 2011 11:18:09 +0100
Message-ID: <1295950715-22340-7-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Almost every use of dev_err in this driver prints the function name.  Abstract
out wrappers to help with this and reduce code duplication.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |  201 +++++++++++++++++-----------------------------
 1 files changed, 74 insertions(+), 127 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0073988..ab3ca6af 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -322,6 +322,12 @@ static void __iomem *chan_base(struct d40_chan *chan)
 	       chan->phy_chan->num * D40_DREG_PCDELTA;
 }
 
+#define d40_err(dev, format, arg...)		\
+	dev_err(dev, "[%s] " format, __func__, ## arg)
+
+#define chan_err(d40c, format, arg...)		\
+	d40_err(chan2dev(d40c), format, ## arg)
+
 static int d40_pool_lli_alloc(struct d40_desc *d40d,
 			      int lli_len, bool is_log)
 {
@@ -673,9 +679,9 @@ static int d40_channel_execute_command(struct d40_chan *d40c,
 		}
 
 		if (i == D40_SUSPEND_MAX_IT) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s]: unable to suspend the chl %d (log: %d) status %x\n",
-				__func__, d40c->phy_chan->num, d40c->log_num,
+			chan_err(d40c,
+				"unable to suspend the chl %d (log: %d) status %x\n",
+				d40c->phy_chan->num, d40c->log_num,
 				status);
 			dump_stack();
 			ret = -EBUSY;
@@ -1143,9 +1149,8 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		if (!il[row].is_error)
 			dma_tc_handle(d40c);
 		else
-			dev_err(base->dev,
-				"[%s] IRQ chan: %ld offset %d idx %d\n",
-				__func__, chan, il[row].offset, idx);
+			d40_err(base->dev, "IRQ chan: %ld offset %d idx %d\n",
+				chan, il[row].offset, idx);
 
 		spin_unlock(&d40c->lock);
 	}
@@ -1164,8 +1169,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
 
 	if (!conf->dir) {
-		dev_err(&d40c->chan.dev->device, "[%s] Invalid direction.\n",
-			__func__);
+		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
 	}
 
@@ -1173,46 +1177,40 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	    d40c->base->plat_data->dev_tx[conf->dst_dev_type] == 0 &&
 	    d40c->runtime_addr == 0) {
 
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Invalid TX channel address (%d)\n",
-			__func__, conf->dst_dev_type);
+		chan_err(d40c, "Invalid TX channel address (%d)\n",
+			 conf->dst_dev_type);
 		res = -EINVAL;
 	}
 
 	if (conf->src_dev_type != STEDMA40_DEV_SRC_MEMORY &&
 	    d40c->base->plat_data->dev_rx[conf->src_dev_type] == 0 &&
 	    d40c->runtime_addr == 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Invalid RX channel address (%d)\n",
-			__func__, conf->src_dev_type);
+		chan_err(d40c, "Invalid RX channel address (%d)\n",
+			conf->src_dev_type);
 		res = -EINVAL;
 	}
 
 	if (conf->dir == STEDMA40_MEM_TO_PERIPH &&
 	    dst_event_group == STEDMA40_DEV_DST_MEMORY) {
-		dev_err(&d40c->chan.dev->device, "[%s] Invalid dst\n",
-			__func__);
+		chan_err(d40c, "Invalid dst\n");
 		res = -EINVAL;
 	}
 
 	if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
 	    src_event_group == STEDMA40_DEV_SRC_MEMORY) {
-		dev_err(&d40c->chan.dev->device, "[%s] Invalid src\n",
-			__func__);
+		chan_err(d40c, "Invalid src\n");
 		res = -EINVAL;
 	}
 
 	if (src_event_group == STEDMA40_DEV_SRC_MEMORY &&
 	    dst_event_group == STEDMA40_DEV_DST_MEMORY && is_log) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] No event line\n", __func__);
+		chan_err(d40c, "No event line\n");
 		res = -EINVAL;
 	}
 
 	if (conf->dir == STEDMA40_PERIPH_TO_PERIPH &&
 	    (src_event_group != dst_event_group)) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Invalid event group\n", __func__);
+		chan_err(d40c, "Invalid event group\n");
 		res = -EINVAL;
 	}
 
@@ -1221,9 +1219,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		 * DMAC HW supports it. Will be added to this driver,
 		 * in case any dma client requires it.
 		 */
-		dev_err(&d40c->chan.dev->device,
-			"[%s] periph to periph not supported\n",
-			__func__);
+		chan_err(d40c, "periph to periph not supported\n");
 		res = -EINVAL;
 	}
 
@@ -1236,9 +1232,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		 * src (burst x width) == dst (burst x width)
 		 */
 
-		dev_err(&d40c->chan.dev->device,
-			"[%s] src (burst x width) != dst (burst x width)\n",
-			__func__);
+		chan_err(d40c, "src (burst x width) != dst (burst x width)\n");
 		res = -EINVAL;
 	}
 
@@ -1441,8 +1435,7 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = *d40c->base->plat_data->memcpy_conf_phy;
 	} else {
-		dev_err(&d40c->chan.dev->device, "[%s] No memcpy\n",
-			__func__);
+		chan_err(d40c, "No memcpy\n");
 		return -EINVAL;
 	}
 
@@ -1473,15 +1466,13 @@ static int d40_free_dma(struct d40_chan *d40c)
 		}
 
 	if (phy == NULL) {
-		dev_err(&d40c->chan.dev->device, "[%s] phy == null\n",
-			__func__);
+		chan_err(d40c, "phy == null\n");
 		return -EINVAL;
 	}
 
 	if (phy->allocated_src == D40_ALLOC_FREE &&
 	    phy->allocated_dst == D40_ALLOC_FREE) {
-		dev_err(&d40c->chan.dev->device, "[%s] channel already free\n",
-			__func__);
+		chan_err(d40c, "channel already free\n");
 		return -EINVAL;
 	}
 
@@ -1493,15 +1484,13 @@ static int d40_free_dma(struct d40_chan *d40c)
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
 		is_src = true;
 	} else {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unknown direction\n", __func__);
+		chan_err(d40c, "Unknown direction\n");
 		return -EINVAL;
 	}
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 	if (res) {
-		dev_err(&d40c->chan.dev->device, "[%s] suspend failed\n",
-			__func__);
+		chan_err(d40c, "suspend failed\n");
 		return res;
 	}
 
@@ -1521,9 +1510,8 @@ static int d40_free_dma(struct d40_chan *d40c)
 				res = d40_channel_execute_command(d40c,
 								  D40_DMA_RUN);
 				if (res) {
-					dev_err(&d40c->chan.dev->device,
-						"[%s] Executing RUN command\n",
-						__func__);
+					chan_err(d40c,
+						"Executing RUN command\n");
 					return res;
 				}
 			}
@@ -1536,8 +1524,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 	/* Release physical channel */
 	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
 	if (res) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Failed to stop channel\n", __func__);
+		chan_err(d40c, "Failed to stop channel\n");
 		return res;
 	}
 	d40c->phy_chan = NULL;
@@ -1581,8 +1568,7 @@ static bool d40_is_paused(struct d40_chan *d40c)
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
 		status = readl(chanbase + D40_CHAN_REG_SSLNK);
 	} else {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unknown direction\n", __func__);
+		chan_err(d40c, "Unknown direction\n");
 		goto _exit;
 	}
 
@@ -1625,8 +1611,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 	unsigned long flags;
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unallocated channel.\n", __func__);
+		chan_err(d40c, "Unallocated channel.\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1640,8 +1625,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					d40c->dma_cfg.src_info.data_width,
 					d40c->dma_cfg.dst_info.data_width);
 	if (d40d->lli_len < 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unaligned size\n", __func__);
+		chan_err(d40c, "Unaligned size\n");
 		goto err;
 	}
 
@@ -1651,8 +1635,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 	if (chan_is_logical(d40c)) {
 
 		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s] Out of memory\n", __func__);
+			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
 
@@ -1671,8 +1654,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40c->dma_cfg.src_info.data_width);
 	} else {
 		if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s] Out of memory\n", __func__);
+			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
 
@@ -1758,9 +1740,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (!d40c->configured) {
 		err = d40_config_memcpy(d40c);
 		if (err) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s] Failed to configure memcpy channel\n",
-				__func__);
+			chan_err(d40c, "Failed to configure memcpy channel\n");
 			goto fail;
 		}
 	}
@@ -1768,8 +1748,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 
 	err = d40_allocate_channel(d40c);
 	if (err) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Failed to allocate channel\n", __func__);
+		chan_err(d40c, "Failed to allocate channel\n");
 		goto fail;
 	}
 
@@ -1810,8 +1789,7 @@ static void d40_free_chan_resources(struct dma_chan *chan)
 	unsigned long flags;
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Cannot free unallocated channel\n", __func__);
+		chan_err(d40c, "Cannot free unallocated channel\n");
 		return;
 	}
 
@@ -1821,8 +1799,7 @@ static void d40_free_chan_resources(struct dma_chan *chan)
 	err = d40_free_dma(d40c);
 
 	if (err)
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Failed to free channel\n", __func__);
+		chan_err(d40c, "Failed to free channel\n");
 	spin_unlock_irqrestore(&d40c->lock, flags);
 }
 
@@ -1838,8 +1815,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	unsigned long flags;
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Channel is not allocated.\n", __func__);
+		chan_err(d40c, "Channel is not allocated.\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1847,8 +1823,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	d40d = d40_desc_get(d40c);
 
 	if (d40d == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Descriptor is NULL\n", __func__);
+		chan_err(d40c, "Descriptor is NULL\n");
 		goto err;
 	}
 
@@ -1857,8 +1832,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 					  d40c->dma_cfg.src_info.data_width,
 					  d40c->dma_cfg.dst_info.data_width);
 	if (d40d->lli_len < 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unaligned size\n", __func__);
+		chan_err(d40c, "Unaligned size\n");
 		goto err;
 	}
 
@@ -1870,8 +1844,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	if (chan_is_logical(d40c)) {
 
 		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s] Out of memory\n", __func__);
+			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
 		d40d->lli_current = 0;
@@ -1897,8 +1870,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	} else {
 
 		if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
-			dev_err(&d40c->chan.dev->device,
-				"[%s] Out of memory\n", __func__);
+			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
 
@@ -1966,14 +1938,12 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 					d40c->dma_cfg.src_info.data_width,
 					d40c->dma_cfg.dst_info.data_width);
 	if (d40d->lli_len < 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unaligned size\n", __func__);
+		chan_err(d40c, "Unaligned size\n");
 		return -EINVAL;
 	}
 
 	if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Out of memory\n", __func__);
+		chan_err(d40c, "Out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -2022,14 +1992,12 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 					d40c->dma_cfg.src_info.data_width,
 					d40c->dma_cfg.dst_info.data_width);
 	if (d40d->lli_len < 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Unaligned size\n", __func__);
+		chan_err(d40c, "Unaligned size\n");
 		return -EINVAL;
 	}
 
 	if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Out of memory\n", __func__);
+		chan_err(d40c, "Out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -2092,8 +2060,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	int err;
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Cannot prepare unallocated channel\n", __func__);
+		chan_err(d40c, "Cannot prepare unallocated channel\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2110,9 +2077,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 		err = d40_prep_slave_sg_phy(d40d, d40c, sgl, sg_len,
 					    direction, dma_flags);
 	if (err) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Failed to prepare %s slave sg job: %d\n",
-			__func__,
+		chan_err(d40c, "Failed to prepare %s slave sg job: %d\n",
 			chan_is_logical(d40c) ? "log" : "phy", err);
 		goto err;
 	}
@@ -2143,9 +2108,7 @@ static enum dma_status d40_tx_status(struct dma_chan *chan,
 	int ret;
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Cannot read status of unallocated channel\n",
-			__func__);
+		chan_err(d40c, "Cannot read status of unallocated channel\n");
 		return -EINVAL;
 	}
 
@@ -2169,8 +2132,7 @@ static void d40_issue_pending(struct dma_chan *chan)
 	unsigned long flags;
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Channel is not allocated!\n", __func__);
+		chan_err(d40c, "Channel is not allocated!\n");
 		return;
 	}
 
@@ -2321,8 +2283,7 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 
 	if (d40c->phy_chan == NULL) {
-		dev_err(&d40c->chan.dev->device,
-			"[%s] Channel is not allocated!\n", __func__);
+		chan_err(d40c, "Channel is not allocated!\n");
 		return -EINVAL;
 	}
 
@@ -2404,9 +2365,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	err = dma_async_device_register(&base->dma_slave);
 
 	if (err) {
-		dev_err(base->dev,
-			"[%s] Failed to register slave channels\n",
-			__func__);
+		d40_err(base->dev, "Failed to register slave channels\n");
 		goto failure1;
 	}
 
@@ -2435,9 +2394,8 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	err = dma_async_device_register(&base->dma_memcpy);
 
 	if (err) {
-		dev_err(base->dev,
-			"[%s] Failed to regsiter memcpy only channels\n",
-			__func__);
+		d40_err(base->dev,
+			"Failed to regsiter memcpy only channels\n");
 		goto failure2;
 	}
 
@@ -2462,9 +2420,8 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	err = dma_async_device_register(&base->dma_both);
 
 	if (err) {
-		dev_err(base->dev,
-			"[%s] Failed to register logical and physical capable channels\n",
-			__func__);
+		d40_err(base->dev,
+			"Failed to register logical and physical capable channels\n");
 		goto failure3;
 	}
 	return 0;
@@ -2566,8 +2523,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	clk = clk_get(&pdev->dev, NULL);
 
 	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "[%s] No matching clock found\n",
-			__func__);
+		d40_err(&pdev->dev, "No matching clock found\n");
 		goto failure;
 	}
 
@@ -2590,9 +2546,8 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(dma_id_regs); i++) {
 		if (dma_id_regs[i].val !=
 		    readl(virtbase + dma_id_regs[i].reg)) {
-			dev_err(&pdev->dev,
-				"[%s] Unknown hardware! Expected 0x%x at 0x%x but got 0x%x\n",
-				__func__,
+			d40_err(&pdev->dev,
+				"Unknown hardware! Expected 0x%x at 0x%x but got 0x%x\n",
 				dma_id_regs[i].val,
 				dma_id_regs[i].reg,
 				readl(virtbase + dma_id_regs[i].reg));
@@ -2605,9 +2560,8 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	if ((val & D40_DREG_PERIPHID2_DESIGNER_MASK) !=
 	    D40_HW_DESIGNER) {
-		dev_err(&pdev->dev,
-			"[%s] Unknown designer! Got %x wanted %x\n",
-			__func__, val & D40_DREG_PERIPHID2_DESIGNER_MASK,
+		d40_err(&pdev->dev, "Unknown designer! Got %x wanted %x\n",
+			val & D40_DREG_PERIPHID2_DESIGNER_MASK,
 			D40_HW_DESIGNER);
 		goto failure;
 	}
@@ -2637,7 +2591,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		       sizeof(struct d40_chan), GFP_KERNEL);
 
 	if (base == NULL) {
-		dev_err(&pdev->dev, "[%s] Out of memory\n", __func__);
+		d40_err(&pdev->dev, "Out of memory\n");
 		goto failure;
 	}
 
@@ -2809,9 +2763,8 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 						base->lcla_pool.pages);
 		if (!page_list[i]) {
 
-			dev_err(base->dev,
-				"[%s] Failed to allocate %d pages.\n",
-				__func__, base->lcla_pool.pages);
+			d40_err(base->dev, "Failed to allocate %d pages.\n",
+				base->lcla_pool.pages);
 
 			for (j = 0; j < i; j++)
 				free_pages(page_list[j], base->lcla_pool.pages);
@@ -2881,9 +2834,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lcpa");
 	if (!res) {
 		ret = -ENOENT;
-		dev_err(&pdev->dev,
-			"[%s] No \"lcpa\" memory resource\n",
-			__func__);
+		d40_err(&pdev->dev, "No \"lcpa\" memory resource\n");
 		goto failure;
 	}
 	base->lcpa_size = resource_size(res);
@@ -2892,9 +2843,9 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (request_mem_region(res->start, resource_size(res),
 			       D40_NAME " I/O lcpa") == NULL) {
 		ret = -EBUSY;
-		dev_err(&pdev->dev,
-			"[%s] Failed to request LCPA region 0x%x-0x%x\n",
-			__func__, res->start, res->end);
+		d40_err(&pdev->dev,
+			"Failed to request LCPA region 0x%x-0x%x\n",
+			res->start, res->end);
 		goto failure;
 	}
 
@@ -2910,16 +2861,13 @@ static int __init d40_probe(struct platform_device *pdev)
 	base->lcpa_base = ioremap(res->start, resource_size(res));
 	if (!base->lcpa_base) {
 		ret = -ENOMEM;
-		dev_err(&pdev->dev,
-			"[%s] Failed to ioremap LCPA region\n",
-			__func__);
+		d40_err(&pdev->dev, "Failed to ioremap LCPA region\n");
 		goto failure;
 	}
 
 	ret = d40_lcla_allocate(base);
 	if (ret) {
-		dev_err(&pdev->dev, "[%s] Failed to allocate LCLA area\n",
-			__func__);
+		d40_err(&pdev->dev, "Failed to allocate LCLA area\n");
 		goto failure;
 	}
 
@@ -2928,9 +2876,8 @@ static int __init d40_probe(struct platform_device *pdev)
 	base->irq = platform_get_irq(pdev, 0);
 
 	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
-
 	if (ret) {
-		dev_err(&pdev->dev, "[%s] No IRQ defined\n", __func__);
+		d40_err(&pdev->dev, "No IRQ defined\n");
 		goto failure;
 	}
 
@@ -2973,7 +2920,7 @@ failure:
 		kfree(base);
 	}
 
-	dev_err(&pdev->dev, "[%s] probe failed\n", __func__);
+	d40_err(&pdev->dev, "probe failed\n");
 	return ret;
 }
 
-- 
1.7.3.2

