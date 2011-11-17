Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1KQL47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:56:59 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:36861 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab1KQL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:56:57 -0500
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>
Cc: <linus.walleij@stericsson.com>, <rabin.vincent@stericsson.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Subject: [PATCH v2] dmaengine/ste_dma40: support pm in dma40
Date: Thu, 17 Nov 2011 17:26:41 +0530
Message-ID: <1321531001-1090-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
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
few other minor changes, related to formatting, comments.

Change-Id: I4da140e5aca462c22490146b5c03cff72a7bd803
Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c    |  267 ++++++++++++++++++++++++++++++++++++++++---
 drivers/dma/ste_dma40_ll.h |   11 ++
 2 files changed, 259 insertions(+), 19 deletions(-)

In this V2 version I have cleaned up the implementation, removing
the usage counters and managing using the pm_runtime_xxx() functions.

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 13259ca..909cf0d 100644
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
 
@@ -62,6 +67,55 @@ enum d40_command {
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
+#define BACKUP_REGS_SZ ARRAY_SIZE(d40_backup_regs)
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
+#define BACKUP_REGS_SZ_V3 ARRAY_SIZE(d40_backup_regs_v3)
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
@@ -96,7 +150,7 @@ struct d40_lli_pool {
  * during a transfer.
  * @node: List entry.
  * @is_in_client_list: true if the client owns this descriptor.
- * the previous one.
+ * @cyclic: true if this is a cyclic job
  *
  * This descriptor is used for both logical and physical transfers.
  */
@@ -143,6 +197,7 @@ struct d40_lcla_pool {
  * channels.
  *
  * @lock: A lock protection this entity.
+ * @reserved: True if used by secure world or otherwise.
  * @num: The physical channel number of this entity.
  * @allocated_src: Bit mapped to show which src event line's are mapped to
  * this physical channel. Can also be free or physically allocated.
@@ -152,6 +207,7 @@ struct d40_lcla_pool {
  */
 struct d40_phy_res {
 	spinlock_t lock;
+	bool	   reserved;
 	int	   num;
 	u32	   allocated_src;
 	u32	   allocated_dst;
@@ -185,7 +241,6 @@ struct d40_base;
  * @src_def_cfg: Default cfg register setting for src.
  * @dst_def_cfg: Default cfg register setting for dst.
  * @log_def: Default logical channel settings.
- * @lcla: Space for one dst src pair for logical channel transfers.
  * @lcpa: Pointer to dst and src lcpa settings.
  * @runtime_addr: runtime configured address.
  * @runtime_direction: runtime configured direction.
@@ -241,6 +296,7 @@ struct d40_chan {
  * @dma_both: dma_device channels that can do both memcpy and slave transfers.
  * @dma_slave: dma_device channels that can do only do slave transfers.
  * @dma_memcpy: dma_device channels that can do only do memcpy transfers.
+ * @phy_chans: Room for all possible physical channels in system.
  * @log_chans: Room for all possible logical channels in system.
  * @lookup_log_chans: Used to map interrupt number to logical channel. Points
  * to log_chans entries.
@@ -254,6 +310,13 @@ struct d40_chan {
  * @phy_lcpa: The physical address of the LCPA.
  * @lcpa_size: The size of the LCPA area.
  * @desc_slab: cache for descriptors.
+ * @reg_val_backup: Here the values of some hardware registers are stored
+ * before the DMA is powered off. They are restored when the power is back on.
+ * @reg_val_backup_v3: Backup of registers that only exits on dma40 v3 and
+ * later.
+ * @reg_val_backup_chan: Backup data for standard channel parameter registers.
+ * @gcc_pwr_off_mask: Mask to maintain the channels that can be turned off.
+ * @initialized: true if the dma has been initialized
  */
 struct d40_base {
 	spinlock_t			 interrupt_lock;
@@ -282,6 +345,11 @@ struct d40_base {
 	dma_addr_t			  phy_lcpa;
 	resource_size_t			  lcpa_size;
 	struct kmem_cache		 *desc_slab;
+	u32				  reg_val_backup[BACKUP_REGS_SZ];
+	u32				  reg_val_backup_v3[BACKUP_REGS_SZ_V3];
+	u32				 *reg_val_backup_chan;
+	u16				  gcc_pwr_off_mask;
+	bool				  initialized;
 };
 
 /**
@@ -479,13 +547,14 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 		struct d40_desc *d;
 		struct d40_desc *_d;
 
-		list_for_each_entry_safe(d, _d, &d40c->client, node)
+		list_for_each_entry_safe(d, _d, &d40c->client, node) {
 			if (async_tx_test_ack(&d->txd)) {
 				d40_desc_remove(d);
 				desc = d;
 				memset(desc, 0, sizeof(*desc));
 				break;
 			}
+		}
 	}
 
 	if (!desc)
@@ -740,7 +809,61 @@ static int d40_sg_2_dmalen(struct scatterlist *sgl, int sg_len,
 	return len;
 }
 
-/* Support functions for logical channels */
+
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
 
 static int d40_channel_execute_command(struct d40_chan *d40c,
 				       enum d40_command command)
@@ -1013,6 +1136,7 @@ static int d40_pause(struct d40_chan *d40c)
 	if (!d40c->busy)
 		return 0;
 
+	pm_runtime_get_sync(d40c->base->dev);
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
@@ -1025,7 +1149,8 @@ static int d40_pause(struct d40_chan *d40c)
 								  D40_DMA_RUN);
 		}
 	}
-
+	pm_runtime_mark_last_busy(d40c->base->dev);
+	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1039,7 +1164,7 @@ static int d40_resume(struct d40_chan *d40c)
 		return 0;
 
 	spin_lock_irqsave(&d40c->lock, flags);
-
+	pm_runtime_get_sync(d40c->base->dev);
 	if (d40c->base->rev == 0)
 		if (chan_is_logical(d40c)) {
 			res = d40_channel_execute_command(d40c,
@@ -1057,6 +1182,8 @@ static int d40_resume(struct d40_chan *d40c)
 	}
 
 no_suspend:
+	pm_runtime_mark_last_busy(d40c->base->dev);
+	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1129,7 +1256,10 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 	d40d = d40_first_queued(d40c);
 
 	if (d40d != NULL) {
-		d40c->busy = true;
+		if (!d40c->busy)
+			d40c->busy = true;
+
+		pm_runtime_get_sync(d40c->base->dev);
 
 		/* Remove from queue */
 		d40_desc_remove(d40d);
@@ -1190,6 +1320,8 @@ static void dma_tc_handle(struct d40_chan *d40c)
 
 		if (d40_queue_start(d40c) == NULL)
 			d40c->busy = false;
+		pm_runtime_mark_last_busy(d40c->base->dev);
+		pm_runtime_put_autosuspend(d40c->base->dev);
 	}
 
 	d40c->pending_tx++;
@@ -1643,10 +1775,11 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
+	pm_runtime_get_sync(d40c->base->dev);
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 	if (res) {
 		chan_err(d40c, "suspend failed\n");
-		return res;
+		goto out;
 	}
 
 	if (chan_is_logical(d40c)) {
@@ -1664,13 +1797,11 @@ static int d40_free_dma(struct d40_chan *d40c)
 			if (d40_chan_has_events(d40c)) {
 				res = d40_channel_execute_command(d40c,
 								  D40_DMA_RUN);
-				if (res) {
+				if (res)
 					chan_err(d40c,
 						"Executing RUN command\n");
-					return res;
-				}
 			}
-			return 0;
+			goto out;
 		}
 	} else {
 		(void) d40_alloc_mask_free(phy, is_src, 0);
@@ -1680,13 +1811,23 @@ static int d40_free_dma(struct d40_chan *d40c)
 	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
 	if (res) {
 		chan_err(d40c, "Failed to stop channel\n");
-		return res;
+		goto out;
 	}
+
+	if (d40c->busy) {
+		pm_runtime_mark_last_busy(d40c->base->dev);
+		pm_runtime_put_autosuspend(d40c->base->dev);
+	}
+
+	d40c->busy = false;
 	d40c->phy_chan = NULL;
 	d40c->configured = false;
 	d40c->base->lookup_phy_chans[phy->num] = NULL;
+out:
 
-	return 0;
+	pm_runtime_mark_last_busy(d40c->base->dev);
+	pm_runtime_put_autosuspend(d40c->base->dev);
+	return res;
 }
 
 static bool d40_is_paused(struct d40_chan *d40c)
@@ -2016,9 +2157,11 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	err = d40_allocate_channel(d40c);
 	if (err) {
 		chan_err(d40c, "Failed to allocate channel\n");
+		d40c->configured = false;
 		goto fail;
 	}
 
+	pm_runtime_get_sync(d40c->base->dev);
 	/* Fill in basic CFG register values */
 	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
 		    &d40c->dst_def_cfg, chan_is_logical(d40c));
@@ -2046,6 +2189,8 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
 fail:
+	pm_runtime_mark_last_busy(d40c->base->dev);
+	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
 }
@@ -2519,6 +2664,55 @@ failure1:
 	return err;
 }
 
+/* Suspend resume functionality */
+#ifdef CONFIG_PM
+static int dma40_pm_suspend(struct device *dev)
+{
+	if (!pm_runtime_suspended(dev))
+		return -EBUSY;
+
+	return 0;
+}
+
+static int dma40_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct d40_base *base = platform_get_drvdata(pdev);
+
+	d40_save_restore_registers(base, true);
+
+	/* Don't disable/enable clocks for v1 due to HW bugs */
+	if (base->rev != 1)
+		writel_relaxed(base->gcc_pwr_off_mask,
+			       base->virtbase + D40_DREG_GCC);
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
+	writel_relaxed(D40_DREG_GCC_ENABLE_ALL,
+		       base->virtbase + D40_DREG_GCC);
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
@@ -2527,6 +2721,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
 	int num_phy_chans_avail = 0;
 	u32 val[2];
 	int odd_even_bit = -2;
+	int gcc = D40_DREG_GCC_ENA;
 
 	val[0] = readl(base->virtbase + D40_DREG_PRSME);
 	val[1] = readl(base->virtbase + D40_DREG_PRSMO);
@@ -2538,9 +2733,17 @@ static int __init d40_phy_res_init(struct d40_base *base)
 			/* Mark security only channels as occupied */
 			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
 			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
+			base->phy_res[i].reserved = true;
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+						       D40_DREG_GCC_SRC);
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+						       D40_DREG_GCC_DST);
+
+
 		} else {
 			base->phy_res[i].allocated_src = D40_ALLOC_FREE;
 			base->phy_res[i].allocated_dst = D40_ALLOC_FREE;
+			base->phy_res[i].reserved = false;
 			num_phy_chans_avail++;
 		}
 		spin_lock_init(&base->phy_res[i].lock);
@@ -2552,6 +2755,11 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 		base->phy_res[chan].allocated_src = D40_ALLOC_PHY;
 		base->phy_res[chan].allocated_dst = D40_ALLOC_PHY;
+		base->phy_res[chan].reserved = true;
+		gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(chan),
+					       D40_DREG_GCC_SRC);
+		gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(chan),
+					       D40_DREG_GCC_DST);
 		num_phy_chans_avail--;
 	}
 
@@ -2572,6 +2780,15 @@ static int __init d40_phy_res_init(struct d40_base *base)
 		val[0] = val[0] >> 2;
 	}
 
+	/*
+	 * To keep things simple, Enable all clocks initially.
+	 * The clocks will get managed later post channel allocation.
+	 * The clocks for the event lines on which reserved channels exists
+	 * are not managed here.
+	 */
+	writel(D40_DREG_GCC_ENABLE_ALL, base->virtbase + D40_DREG_GCC);
+	base->gcc_pwr_off_mask = gcc;
+
 	return num_phy_chans_avail;
 }
 
@@ -2699,10 +2916,15 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
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
 
@@ -2741,9 +2963,9 @@ failure:
 static void __init d40_hw_init(struct d40_base *base)
 {
 
-	static const struct d40_reg_val dma_init_reg[] = {
+	static struct d40_reg_val dma_init_reg[] = {
 		/* Clock every part of the DMA block from start */
-		{ .reg = D40_DREG_GCC,    .val = 0x0000ff01},
+		{ .reg = D40_DREG_GCC,    .val = D40_DREG_GCC_ENABLE_ALL},
 
 		/* Interrupts on all logical channels */
 		{ .reg = D40_DREG_LCMIS0, .val = 0xFFFFFFFF},
@@ -2960,6 +3182,12 @@ static int __init d40_probe(struct platform_device *pdev)
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
@@ -3013,6 +3241,7 @@ static struct platform_driver d40_driver = {
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

