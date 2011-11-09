Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1KIEgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 23:36:40 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51998 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792Ab1KIEgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 23:36:39 -0500
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <linus.walleij@stericsson.com>, <rabin.vincent@stericsson.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Subject: [PATCH] dmaengine/ste_dma40: support pm in dma40
Date: Wed, 9 Nov 2011 10:06:24 +0530
Message-ID: <1320813384-13651-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds power management support to the dma40
driver. The DMA registers are backed up and restored,
during suspend/resume. Also flags to track the dma usage
have been introduced to facilitate this. Patch also includes
few other minor changes, related to formatting, grammar.

Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c    |  412 +++++++++++++++++++++++++++++++++++++++-----
 drivers/dma/ste_dma40_ll.h |   11 ++
 2 files changed, 378 insertions(+), 45 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 13259ca..9b1bef0 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -14,6 +14,8 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/err.h>
 #include <linux/amba/bus.h>
 
@@ -32,6 +34,9 @@
 /* Maximum iterations taken before giving up suspending a channel */
 #define D40_SUSPEND_MAX_IT 500
 
+/* Milliseconds */
+#define DMA40_AUTOSUSPEND_DELAY	100
+
 /* Hardware requirement on LCLA alignment */
 #define LCLA_ALIGNMENT 0x40000
 
@@ -62,6 +67,51 @@ enum d40_command {
 	D40_DMA_SUSPENDED	= 3
 };
 
+/*
+ * These are the registers that has to be saved and later restored
+ * when the DMA hw is powered off.
+ * TODO: Add save/restore of D40_DREG_GCC on dma40 v3 or later, if that works.
+ */
+static u32 d40_backup_regs[] = {
+	D40_DREG_LCPA,
+	D40_DREG_LCLA,
+	D40_DREG_PRMSE,
+	D40_DREG_PRMSO,
+	D40_DREG_PRMOE,
+	D40_DREG_PRMOO,
+};
+
+/* TODO: Check if all these registers have to be saved/restored on dma40 v3 */
+static u32 d40_backup_regs_v3[] = {
+	D40_DREG_PSEG1,
+	D40_DREG_PSEG2,
+	D40_DREG_PSEG3,
+	D40_DREG_PSEG4,
+	D40_DREG_PCEG1,
+	D40_DREG_PCEG2,
+	D40_DREG_PCEG3,
+	D40_DREG_PCEG4,
+	D40_DREG_RSEG1,
+	D40_DREG_RSEG2,
+	D40_DREG_RSEG3,
+	D40_DREG_RSEG4,
+	D40_DREG_RCEG1,
+	D40_DREG_RCEG2,
+	D40_DREG_RCEG3,
+	D40_DREG_RCEG4,
+};
+
+static u32 d40_backup_regs_chan[] = {
+	D40_CHAN_REG_SSCFG,
+	D40_CHAN_REG_SSELT,
+	D40_CHAN_REG_SSPTR,
+	D40_CHAN_REG_SSLNK,
+	D40_CHAN_REG_SDCFG,
+	D40_CHAN_REG_SDELT,
+	D40_CHAN_REG_SDPTR,
+	D40_CHAN_REG_SDLNK,
+};
+
 /**
  * struct d40_lli_pool - Structure for keeping LLIs in memory
  *
@@ -96,7 +146,7 @@ struct d40_lli_pool {
  * during a transfer.
  * @node: List entry.
  * @is_in_client_list: true if the client owns this descriptor.
- * the previous one.
+ * @cyclic: true if this is a cyclic job
  *
  * This descriptor is used for both logical and physical transfers.
  */
@@ -143,6 +193,7 @@ struct d40_lcla_pool {
  * channels.
  *
  * @lock: A lock protection this entity.
+ * @reserved: True if used by secure world or otherwise.
  * @num: The physical channel number of this entity.
  * @allocated_src: Bit mapped to show which src event line's are mapped to
  * this physical channel. Can also be free or physically allocated.
@@ -152,6 +203,7 @@ struct d40_lcla_pool {
  */
 struct d40_phy_res {
 	spinlock_t lock;
+	bool	   reserved;
 	int	   num;
 	u32	   allocated_src;
 	u32	   allocated_dst;
@@ -185,7 +237,6 @@ struct d40_base;
  * @src_def_cfg: Default cfg register setting for src.
  * @dst_def_cfg: Default cfg register setting for dst.
  * @log_def: Default logical channel settings.
- * @lcla: Space for one dst src pair for logical channel transfers.
  * @lcpa: Pointer to dst and src lcpa settings.
  * @runtime_addr: runtime configured address.
  * @runtime_direction: runtime configured direction.
@@ -241,6 +292,7 @@ struct d40_chan {
  * @dma_both: dma_device channels that can do both memcpy and slave transfers.
  * @dma_slave: dma_device channels that can do only do slave transfers.
  * @dma_memcpy: dma_device channels that can do only do memcpy transfers.
+ * @phy_chans: Room for all possible physical channels in system.
  * @log_chans: Room for all possible logical channels in system.
  * @lookup_log_chans: Used to map interrupt number to logical channel. Points
  * to log_chans entries.
@@ -254,6 +306,15 @@ struct d40_chan {
  * @phy_lcpa: The physical address of the LCPA.
  * @lcpa_size: The size of the LCPA area.
  * @desc_slab: cache for descriptors.
+ * @usage: The number of dma executions. Used by suspend to determite if
+ * the dma can suspend or not.
+ * @usage_lock: lock for usage count.
+ * @reg_val_backup: Here the values of some hardware registers are stored
+ * before the DMA is powered off. They are restored when the power is back on.
+ * @reg_val_backup_v3: Backup of registers that only exits on dma40 v3 and
+ * later.
+ * @reg_val_backup_chan: Backup data for standard channel parameter registers.
+ * @initialized: true if the dma has been initialized
  */
 struct d40_base {
 	spinlock_t			 interrupt_lock;
@@ -282,6 +343,14 @@ struct d40_base {
 	dma_addr_t			  phy_lcpa;
 	resource_size_t			  lcpa_size;
 	struct kmem_cache		 *desc_slab;
+	int				  usage;
+	spinlock_t			  usage_lock;
+	u32				  reg_val_backup
+					  [ARRAY_SIZE(d40_backup_regs)];
+	u32				  reg_val_backup_v3
+					  [ARRAY_SIZE(d40_backup_regs_v3)];
+	u32				 *reg_val_backup_chan;
+	bool				  initialized;
 };
 
 /**
@@ -479,13 +548,14 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 		struct d40_desc *d;
 		struct d40_desc *_d;
 
-		list_for_each_entry_safe(d, _d, &d40c->client, node)
+		list_for_each_entry_safe(d, _d, &d40c->client, node) {
 			if (async_tx_test_ack(&d->txd)) {
 				d40_desc_remove(d);
 				desc = d;
-				memset(desc, 0, sizeof(*desc));
+				memset(desc, 0, sizeof(struct d40_desc));
 				break;
 			}
+			}
 	}
 
 	if (!desc)
@@ -740,8 +810,169 @@ static int d40_sg_2_dmalen(struct scatterlist *sgl, int sg_len,
 	return len;
 }
 
-/* Support functions for logical channels */
 
+#ifdef CONFIG_PM
+static void dma40_backup(void __iomem *baseaddr, u32 *backup,
+			 u32 *regaddr, int num, bool save)
+{
+	int i;
+
+	for (i = 0; i < num; i++) {
+		void __iomem *addr = baseaddr + regaddr[i];
+
+		if (save)
+			backup[i] = readl_relaxed(addr);
+		else
+			writel_relaxed(backup[i], addr);
+	}
+}
+
+static void d40_save_restore_registers(struct d40_base *base, bool save)
+{
+	int i;
+
+	/* Enable all clocks -- revisit after HW bug is fixed */
+	if (!save)
+		writel_relaxed(D40_DREG_GCC_ENABLE_ALL,
+			       base->virtbase + D40_DREG_GCC);
+
+	/* Save/Restore channel specific registers */
+	for (i = 0; i < base->num_phy_chans; i++) {
+		void __iomem *addr;
+		int idx;
+
+		if (base->phy_res[i].reserved)
+			continue;
+
+		addr = base->virtbase + D40_DREG_PCBASE + i * D40_DREG_PCDELTA;
+		idx = i * ARRAY_SIZE(d40_backup_regs_chan);
+
+		dma40_backup(addr, &base->reg_val_backup_chan[idx],
+			     d40_backup_regs_chan,
+			     ARRAY_SIZE(d40_backup_regs_chan),
+			     save);
+	}
+
+	/* Save/Restore global registers */
+	dma40_backup(base->virtbase, base->reg_val_backup,
+		     d40_backup_regs, ARRAY_SIZE(d40_backup_regs),
+		     save);
+
+	/* Save/Restore registers only existing on dma40 v3 and later */
+	if (base->rev >= 3)
+		dma40_backup(base->virtbase, base->reg_val_backup_v3,
+			     d40_backup_regs_v3,
+			     ARRAY_SIZE(d40_backup_regs_v3),
+			     save);
+}
+#else
+static void d40_save_restore_registers(struct d40_base *base, bool save)
+{
+}
+#endif
+
+static void d40_power_off(struct d40_base *base, int phy_num)
+{
+	u32 gcc;
+	int i;
+	int j;
+	int p;
+
+	/*
+	 * Disable the rest of the code because of GCC register HW bugs on v1
+	 * which are not worth working around.  Revisit later.
+	 */
+	return;
+
+	/*
+	 * Power off event group related to physical channel, if
+	 * the other physical channels that belong to the same
+	 * event group are not in use
+	 */
+
+	for (j = 0; j < base->num_phy_chans; j += D40_GROUP_SIZE) {
+
+		for (i = 0; i < 2; i++) {
+			p = (((phy_num & (base->num_phy_chans - 1)) + i)
+			     & (D40_GROUP_SIZE - 1)) + j;
+			if (p == phy_num)
+				continue;
+			/*
+			 * If another physical channel in the same group is
+			 * allocated, just return.
+			 */
+			if (base->phy_res[p].allocated_dst == D40_ALLOC_PHY ||
+			    base->phy_res[p].allocated_src == D40_ALLOC_PHY) {
+				return;
+			}
+		}
+	}
+
+	/* The GCC register is protected via the usage_lock */
+	gcc = readl(base->virtbase + D40_DREG_GCC);
+
+	gcc &= ~D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
+					D40_DREG_GCC_SRC);
+	gcc &= ~D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
+					D40_DREG_GCC_DST);
+
+	writel(gcc, base->virtbase + D40_DREG_GCC);
+}
+
+static void d40_power_on(struct d40_base *base, int phy_num)
+{
+	u32 gcc;
+
+	/*
+	 * Disable the rest of the code because of GCC register HW bugs on v1
+	 * which are not worth working around.  Revisit later.
+	 */
+	return;
+
+	/* The GCC register is protected via the usage_lock */
+	gcc = readl(base->virtbase + D40_DREG_GCC);
+
+	gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
+				       D40_DREG_GCC_SRC);
+	gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
+				       D40_DREG_GCC_DST);
+
+	writel(gcc, base->virtbase + D40_DREG_GCC);
+}
+
+static void d40_usage_inc(struct d40_chan *d40c)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&d40c->base->usage_lock, flags);
+
+	d40c->base->usage++;
+
+	if (d40c->base->usage == 1)
+		pm_runtime_get_sync(d40c->base->dev);
+
+	d40_power_on(d40c->base, d40c->phy_chan->num);
+
+	spin_unlock_irqrestore(&d40c->base->usage_lock, flags);
+}
+
+static void d40_usage_dec(struct d40_chan *d40c)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&d40c->base->usage_lock, flags);
+
+	d40_power_off(d40c->base, d40c->phy_chan->num);
+
+	d40c->base->usage--;
+
+	if (d40c->base->usage == 0) {
+		pm_runtime_mark_last_busy(d40c->base->dev);
+		pm_runtime_put_autosuspend(d40c->base->dev);
+	}
+
+	spin_unlock_irqrestore(&d40c->base->usage_lock, flags);
+}
 static int d40_channel_execute_command(struct d40_chan *d40c,
 				       enum d40_command command)
 {
@@ -1013,6 +1244,7 @@ static int d40_pause(struct d40_chan *d40c)
 	if (!d40c->busy)
 		return 0;
 
+	d40_usage_inc(d40c);
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
@@ -1025,7 +1257,7 @@ static int d40_pause(struct d40_chan *d40c)
 								  D40_DMA_RUN);
 		}
 	}
-
+	d40_usage_dec(d40c);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1039,7 +1271,7 @@ static int d40_resume(struct d40_chan *d40c)
 		return 0;
 
 	spin_lock_irqsave(&d40c->lock, flags);
-
+	d40_usage_inc(d40c);
 	if (d40c->base->rev == 0)
 		if (chan_is_logical(d40c)) {
 			res = d40_channel_execute_command(d40c,
@@ -1057,6 +1289,7 @@ static int d40_resume(struct d40_chan *d40c)
 	}
 
 no_suspend:
+	d40_usage_dec(d40c);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1129,7 +1362,10 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 	d40d = d40_first_queued(d40c);
 
 	if (d40d != NULL) {
-		d40c->busy = true;
+		if (!d40c->busy) {
+			d40_usage_inc(d40c);
+			d40c->busy = true;
+		}
 
 		/* Remove from queue */
 		d40_desc_remove(d40d);
@@ -1190,6 +1426,7 @@ static void dma_tc_handle(struct d40_chan *d40c)
 
 		if (d40_queue_start(d40c) == NULL)
 			d40c->busy = false;
+		d40_usage_dec(d40c);
 	}
 
 	d40c->pending_tx++;
@@ -1643,6 +1880,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
+	d40_usage_inc(d40c);
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 	if (res) {
 		chan_err(d40c, "suspend failed\n");
@@ -1680,8 +1918,14 @@ static int d40_free_dma(struct d40_chan *d40c)
 	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
 	if (res) {
 		chan_err(d40c, "Failed to stop channel\n");
+		d40_usage_dec(d40c);
 		return res;
 	}
+	d40_usage_dec(d40c);
+	if (d40c->busy)
+		d40_usage_dec(d40c);
+	d40c->busy = false;
+
 	d40c->phy_chan = NULL;
 	d40c->configured = false;
 	d40c->base->lookup_phy_chans[phy->num] = NULL;
@@ -1999,6 +2243,9 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	struct d40_chan *d40c =
 		container_of(chan, struct d40_chan, chan);
 	bool is_free_phy;
+
+	d40_usage_inc(d40c);
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	d40c->completed = chan->cookie = 1;
@@ -2016,6 +2263,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	err = d40_allocate_channel(d40c);
 	if (err) {
 		chan_err(d40c, "Failed to allocate channel\n");
+		d40c->configured = false;
 		goto fail;
 	}
 
@@ -2046,6 +2294,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
 fail:
+	d40_usage_dec(d40c);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
 }
@@ -2117,36 +2366,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	return d40_prep_sg(chan, sgl, sgl, sg_len, direction, dma_flags);
 }
 
-static struct dma_async_tx_descriptor *
-dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
-		     size_t buf_len, size_t period_len,
-		     enum dma_data_direction direction)
-{
-	unsigned int periods = buf_len / period_len;
-	struct dma_async_tx_descriptor *txd;
-	struct scatterlist *sg;
-	int i;
-
-	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_NOWAIT);
-	for (i = 0; i < periods; i++) {
-		sg_dma_address(&sg[i]) = dma_addr;
-		sg_dma_len(&sg[i]) = period_len;
-		dma_addr += period_len;
-	}
-
-	sg[periods].offset = 0;
-	sg[periods].length = 0;
-	sg[periods].page_link =
-		((unsigned long)sg | 0x01) & ~0x02;
-
-	txd = d40_prep_sg(chan, sg, sg, periods, direction,
-			  DMA_PREP_INTERRUPT);
-
-	kfree(sg);
-
-	return txd;
-}
-
 static enum dma_status d40_tx_status(struct dma_chan *chan,
 				     dma_cookie_t cookie,
 				     struct dma_tx_state *txstate)
@@ -2392,6 +2611,36 @@ static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	return -ENXIO;
 }
 
+static struct dma_async_tx_descriptor *
+dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
+		     size_t buf_len, size_t period_len,
+		     enum dma_data_direction direction)
+{
+	unsigned int periods = buf_len / period_len;
+	struct dma_async_tx_descriptor *txd;
+	struct scatterlist *sg;
+	int i;
+
+	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_ATOMIC);
+	for (i = 0; i < periods; i++) {
+		sg_dma_address(&sg[i]) = dma_addr;
+		sg_dma_len(&sg[i]) = period_len;
+		dma_addr += period_len;
+	}
+
+	sg[periods].offset = 0;
+	sg[periods].length = 0;
+	sg[periods].page_link =
+		((unsigned long)sg | 0x01) & ~0x02;
+
+	txd = d40_prep_sg(chan, sg, sg, periods, direction,
+			  DMA_PREP_INTERRUPT);
+
+	kfree(sg);
+
+	return txd;
+}
+
 /* Initialization functions */
 
 static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
@@ -2519,6 +2768,56 @@ failure1:
 	return err;
 }
 
+/* Suspend resume functionality */
+#ifdef CONFIG_PM
+static int dma40_pm_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct d40_base *base = platform_get_drvdata(pdev);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&base->usage_lock, flags);
+
+	if (base->usage)
+		ret = -EBUSY;
+
+	spin_unlock_irqrestore(&base->usage_lock, flags);
+	return ret;
+}
+
+static int dma40_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct d40_base *base = platform_get_drvdata(pdev);
+
+	d40_save_restore_registers(base, true);
+
+	return 0;
+}
+
+static int dma40_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct d40_base *base = platform_get_drvdata(pdev);
+
+	if (base->initialized)
+		d40_save_restore_registers(base, false);
+
+	return 0;
+}
+
+
+static const struct dev_pm_ops dma40_pm_ops = {
+	.suspend		= dma40_pm_suspend,
+	.runtime_suspend	= dma40_runtime_suspend,
+	.runtime_resume		= dma40_runtime_resume,
+};
+#define DMA40_PM_OPS	(&dma40_pm_ops)
+#else
+#define DMA40_PM_OPS	NULL
+#endif
+
 /* Initialization functions. */
 
 static int __init d40_phy_res_init(struct d40_base *base)
@@ -2538,9 +2837,12 @@ static int __init d40_phy_res_init(struct d40_base *base)
 			/* Mark security only channels as occupied */
 			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
 			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
+			base->phy_res[i].reserved = true;
+
 		} else {
 			base->phy_res[i].allocated_src = D40_ALLOC_FREE;
 			base->phy_res[i].allocated_dst = D40_ALLOC_FREE;
+			base->phy_res[i].reserved = false;
 			num_phy_chans_avail++;
 		}
 		spin_lock_init(&base->phy_res[i].lock);
@@ -2552,6 +2854,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 		base->phy_res[chan].allocated_src = D40_ALLOC_PHY;
 		base->phy_res[chan].allocated_dst = D40_ALLOC_PHY;
+		base->phy_res[chan].reserved = true;
 		num_phy_chans_avail--;
 	}
 
@@ -2675,6 +2978,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	base->dev = &pdev->dev;
 	base->phy_chans = ((void *)base) + ALIGN(sizeof(struct d40_base), 4);
 	base->log_chans = &base->phy_chans[num_phy_chans];
+	base->usage = 1;
 
 	base->phy_res = kzalloc(num_phy_chans * sizeof(struct d40_phy_res),
 				GFP_KERNEL);
@@ -2699,10 +3003,15 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 			goto failure;
 	}
 
-	base->lcla_pool.alloc_map = kzalloc(num_phy_chans *
-					    sizeof(struct d40_desc *) *
-					    D40_LCLA_LINK_PER_EVENT_GRP,
+	base->reg_val_backup_chan = kmalloc(base->num_phy_chans *
+					    sizeof(d40_backup_regs_chan),
 					    GFP_KERNEL);
+	if (!base->reg_val_backup_chan)
+		goto failure;
+
+	base->lcla_pool.alloc_map =
+		kzalloc(num_phy_chans * sizeof(struct d40_desc *)
+			* D40_LCLA_LINK_PER_EVENT_GRP, GFP_KERNEL);
 	if (!base->lcla_pool.alloc_map)
 		goto failure;
 
@@ -2741,9 +3050,9 @@ failure:
 static void __init d40_hw_init(struct d40_base *base)
 {
 
-	static const struct d40_reg_val dma_init_reg[] = {
+	static struct d40_reg_val dma_init_reg[] = {
 		/* Clock every part of the DMA block from start */
-		{ .reg = D40_DREG_GCC,    .val = 0x0000ff01},
+		{ .reg = D40_DREG_GCC,    .val = D40_DREG_GCC_ENABLE_ALL},
 
 		/* Interrupts on all logical channels */
 		{ .reg = D40_DREG_LCMIS0, .val = 0xFFFFFFFF},
@@ -2853,8 +3162,8 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 		base->lcla_pool.base = (void *)page_list[i];
 	} else {
 		/*
-		 * After many attempts and no succees with finding the correct
-		 * alignment, try with allocating a big buffer.
+		 * After many attempts, no succees with finding the correct
+		 * alignment try with allocating a big buffer.
 		 */
 		dev_warn(base->dev,
 			 "[%s] Failed to get %d pages @ 18 bit align.\n",
@@ -2896,6 +3205,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	struct resource *res = NULL;
 	int num_reserved_chans;
 	u32 val;
+	unsigned long flags;
 
 	base = d40_hw_detect_init(pdev);
 
@@ -2908,6 +3218,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	spin_lock_init(&base->interrupt_lock);
 	spin_lock_init(&base->execmd_lock);
+	spin_lock_init(&base->usage_lock);
 
 	/* Get IO for logical channel parameter address */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lcpa");
@@ -2960,12 +3271,22 @@ static int __init d40_probe(struct platform_device *pdev)
 		goto failure;
 	}
 
+	pm_runtime_irq_safe(base->dev);
+	pm_runtime_set_autosuspend_delay(base->dev, DMA40_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(base->dev);
+	pm_runtime_enable(base->dev);
+	pm_runtime_resume(base->dev);
+	base->initialized = true;
 	err = d40_dmaengine_init(base, num_reserved_chans);
 	if (err)
 		goto failure;
 
 	d40_hw_init(base);
 
+	spin_lock_irqsave(&base->usage_lock, flags);
+	base->usage--;
+	spin_unlock_irqrestore(&base->usage_lock, flags);
+
 	dev_info(base->dev, "initialized\n");
 	return 0;
 
@@ -3013,6 +3334,7 @@ static struct platform_driver d40_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = D40_NAME,
+		.pm = DMA40_PM_OPS,
 	},
 };
 
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index b44c4551..8d3d490 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -16,6 +16,8 @@
 
 #define D40_TYPE_TO_GROUP(type) (type / 16)
 #define D40_TYPE_TO_EVENT(type) (type % 16)
+#define D40_GROUP_SIZE 8
+#define D40_PHYS_TO_GROUP(phys) ((phys & (D40_GROUP_SIZE - 1)) / 2)
 
 /* Most bits of the CFG register are the same in log as in phy mode */
 #define D40_SREG_CFG_MST_POS		15
@@ -123,6 +125,15 @@
 
 /* DMA Register Offsets */
 #define D40_DREG_GCC		0x000
+#define D40_DREG_GCC_ENA	0x1
+/* This assumes that there are only 4 event groups */
+#define D40_DREG_GCC_ENABLE_ALL	0xff01
+#define D40_DREG_GCC_EVTGRP_POS 8
+#define D40_DREG_GCC_SRC 0
+#define D40_DREG_GCC_DST 1
+#define D40_DREG_GCC_EVTGRP_ENA(x, y) \
+	(1 << (D40_DREG_GCC_EVTGRP_POS + 2 * x + y))
+
 #define D40_DREG_PRTYP		0x004
 #define D40_DREG_PRSME		0x008
 #define D40_DREG_PRSMO		0x00C
-- 
1.7.4.3

