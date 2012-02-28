Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2B1H2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:28:41 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58682 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932182Ab2B1H2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:23 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 04/13] dmaengine:mmp add peripheral dma driver
Date: Tue, 28 Feb 2012 15:27:36 +0800
Message-Id: <1330414065-2949-5-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:09.0845 (UTC) FILETIME=[8589BA50:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1,add dmac driver for peripheral device

Change-Id: I65bee3b4b9e8c832f3c9ca607bc91f264fb4ed8e
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/plat-pxa/include/plat/dma.h |   33 +-
 drivers/dma/pxa_dmac.c               | 1077 ++++++++++++++++++++++++++++++++++
 2 files changed, 1109 insertions(+), 1 deletions(-)
 create mode 100644 drivers/dma/pxa_dmac.c

diff --git a/arch/arm/plat-pxa/include/plat/dma.h b/arch/arm/plat-pxa/include/plat/dma.h
index fb4c393..e30880e 100644
--- a/arch/arm/plat-pxa/include/plat/dma.h
+++ b/arch/arm/plat-pxa/include/plat/dma.h
@@ -1,6 +1,11 @@
 #ifndef __PLAT_DMA_H
 #define __PLAT_DMA_H
 
+#if defined(CONFIG_CPU_MMP2) || defined(CONFIG_CPU_MMP3)
+#include <linux/device.h>
+#include <linux/dmaengine.h>
+#endif
+
 #define DMAC_REG(x)	(*((volatile u32 *)(DMAC_REGS_VIRT + (x))))
 
 #define DCSR(n)		DMAC_REG((n) << 2)
@@ -36,6 +41,7 @@
 #define DRCMR_CHLNUM	0x1f		/* mask for Channel Number (read / write) */
 
 #define DDADR_DESCADDR	0xfffffff0	/* Address of next descriptor (mask) */
+#define DDADR_BREN	(2 << 0)	/* Enable Descriptor Branch */
 #define DDADR_STOP	(1 << 0)	/* Stop (read / write) */
 
 #define DCMD_INCSRCADDR	(1 << 31)	/* Source Address Increment Setting. */
@@ -71,13 +77,38 @@ typedef enum {
 	DMA_PRIO_LOW = 2
 } pxa_dma_prio;
 
+struct pxa_dmac_data {
+	int priority;
+	int flow_ctrl;
+	int ch_map;
+};
+
+#if defined(CONFIG_CPU_MMP2) || defined(CONFIG_CPU_MMP3)
+static inline int pxa_dmac_is_this_type(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "pxa-dmac");
+}
+
 /*
  * DMA registration
  */
 
+struct pxa_dmac_platform_data {
+	unsigned int irq_base;
+	unsigned int nr_ch;
+};
+
+
+int __init pxa_init_dma(int second_irq_start, int num_ch);
+unsigned long pxa_dmac_chan_get_src_ptr(struct dma_chan *chan);
+unsigned long pxa_dmac_chan_get_dst_ptr(struct dma_chan *chan);
+pxa_dma_prio pxa_dmac_chan_get_prio(struct dma_chan *chan);
+#else
 int __init pxa_init_dma(int irq, int num_ch);
+#endif
+int __init pxa_init_dma_irq(int mux_irq, int second_irq_start, int num_ch);
 
-int pxa_request_dma (char *name,
+int pxa_request_dma(char *name,
 			 pxa_dma_prio prio,
 			 void (*irq_handler)(int, void *),
 			 void *data);
diff --git a/drivers/dma/pxa_dmac.c b/drivers/dma/pxa_dmac.c
new file mode 100644
index 0000000..16446d4
--- /dev/null
+++ b/drivers/dma/pxa_dmac.c
@@ -0,0 +1,1077 @@
+/*
+ * drivers/dma/pxa-dmac.c
+ *
+ * Driver for Xscale PXA DMAC engine and MMP peripheral DMA
+ *
+ * Copyright 2011 Leo Yan <leoy@marvell.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ */
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/dmaengine.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+
+#include <asm/irq.h>
+#include <mach/dma.h>
+#include <plat/dma.h>
+
+#define DMAC_DESC_SIZE		512
+#define DMAC_DESC_NUM		(int)(DMAC_DESC_SIZE / \
+				sizeof(struct pxa_dma_desc))
+
+#define DMAC_ALIGNMENT		3
+#define DMAC_MAX_XFER_BYTES	((SZ_8K - 1) & ~((1 << DMAC_ALIGNMENT) - 1))
+#define DMAC_CYCLIC_LOOP	(1 << 0)
+
+u32 dma_irq_base;
+
+struct pxa_dmac_chan {
+	struct pxa_dmac_engine		*pxa_dmac;
+	struct dma_chan			chan;
+	struct dma_async_tx_descriptor	desc;
+
+	struct pxa_dma_desc		*desc_arr;
+	phys_addr_t			desc_arr_phys;
+	enum dma_data_direction		dir;
+	dma_addr_t			dev_addr;
+	u32				burst_sz;
+	enum dma_slave_buswidth		width;
+	u32				dcmd;
+
+	dma_cookie_t			last_completed;
+	enum dma_status			status;
+	unsigned int			flags;
+
+	pxa_dma_prio			prio;
+	int				irq;
+	int				idx;
+	int				ch_map;
+};
+
+struct pxa_dmac_engine {
+	struct device			*dev;
+	void __iomem			*base;
+	struct dma_device		dmac_device;
+	unsigned int			dmac_nr;
+	struct pxa_dmac_chan		dmac[0];
+};
+
+/*
+ * Debug fs
+ */
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+
+#define DMA_DEBUG_NAME		"pxa_dmac"
+
+static struct dentry *dbgfs_root, *dbgfs_state, **dbgfs_chan;
+static int num_dma_channels;
+static spinlock_t dbgfs_lock;
+
+static int dbg_show_requester_chan(struct seq_file *s, void *p)
+{
+	int pos = 0;
+	struct pxa_dmac_chan *dmac = (struct pxa_dmac_chan *)s->private;
+	int chan = dmac->idx;
+	int i;
+	u32 drcmr;
+
+	pos += seq_printf(s, "DMA channel %d requesters list :\n", chan);
+	for (i = 0; i < (num_dma_channels << 1); i++) {
+		drcmr = DRCMR(i);
+		if (!(drcmr & DRCMR_MAPVLD))
+			continue;
+		if ((drcmr & DRCMR_CHLNUM) == chan)
+			pos += seq_printf(s, "\tRequester %d (MAPVLD=%d)\n", i,
+					  !!(drcmr & DRCMR_MAPVLD));
+	}
+	return pos;
+}
+
+static inline int dbg_burst_from_dcmd(u32 dcmd)
+{
+	int burst = (dcmd >> 16) & 0x3;
+
+	return burst ? 4 << burst : 0;
+}
+
+static int is_phys_valid(unsigned long addr)
+{
+	return pfn_valid(__phys_to_pfn(addr));
+}
+
+#define DCSR_STR(flag) (dcsr & DCSR_##flag ? #flag" " : "")
+#define DCMD_STR(flag) (dcmd & DCMD_##flag ? #flag" " : "")
+
+static int dbg_show_descriptors(struct seq_file *s, void *p)
+{
+	int pos = 0;
+	struct pxa_dmac_chan *dmac = (struct pxa_dmac_chan *)s->private;
+	int chan = dmac->idx;
+	int i, max_show = 20, burst, width;
+	u32 dcsr, dcmd;
+	unsigned long phys_desc;
+	struct pxa_dma_desc *desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dbgfs_lock, flags);
+
+	dcsr       = DCSR(chan);
+	phys_desc  = DDADR(chan);
+	phys_desc &= ~(DDADR_BREN | DDADR_STOP);
+
+	if ((dcsr & DCSR_NODESC) || !phys_desc) {
+		pos += seq_printf(s, "Config to No-Descriptor Fetch\n");
+		goto out;
+	}
+
+	pos += seq_printf(s, "DMA channel %d descriptors :\n", chan);
+	pos += seq_printf(s, "[%03d] First descriptor unknown\n", 0);
+	for (i = 1; i < max_show && is_phys_valid(phys_desc); i++) {
+
+		/* means the last one */
+		if (!phys_desc)
+			break;
+
+		desc = phys_to_virt(phys_desc);
+		dcmd = desc->dcmd;
+		burst = dbg_burst_from_dcmd(dcmd);
+		width = (1 << ((dcmd >> 14) & 0x3)) >> 1;
+
+		pos += seq_printf(s, "[%03d] Desc at %08lx(virt %p)\n",
+				  i, phys_desc, desc);
+		pos += seq_printf(s, "\tDDADR = %08x\n", desc->ddadr);
+		pos += seq_printf(s, "\tDSADR = %08x\n", desc->dsadr);
+		pos += seq_printf(s, "\tDTADR = %08x\n", desc->dtadr);
+		pos += seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d"
+				  " width=%d len=%d)\n",
+				  dcmd,
+				  DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
+				  DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
+				  DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
+				  DCMD_STR(ENDIAN), burst, width,
+				  dcmd & DCMD_LENGTH);
+
+		if (phys_desc & DDADR_BREN)
+			phys_desc += 32;
+		else
+			phys_desc = desc->ddadr;
+	}
+	if (i == max_show)
+		pos += seq_printf(s,
+			"[%03d] Desc at %08lx ... max display reached\n",
+				  i, phys_desc);
+	else
+		pos += seq_printf(s, "[%03d] Desc at %08lx is %s\n",
+				  i, phys_desc, phys_desc == DDADR_STOP ?
+				  "DDADR_STOP" : "invalid");
+
+out:
+	spin_unlock_irqrestore(&dbgfs_lock, flags);
+	return pos;
+}
+
+static int dbg_show_chan_state(struct seq_file *s, void *p)
+{
+	int pos = 0;
+	struct pxa_dmac_chan *dmac = (struct pxa_dmac_chan *)s->private;
+	int chan = dmac->idx;
+	u32 dcsr, dcmd;
+	int burst, width;
+	static char *str_prio[] = { "high", "normal", "low" };
+
+	dcsr = DCSR(chan);
+	dcmd = DCMD(chan);
+	burst = dbg_burst_from_dcmd(dcmd);
+	width = (1 << ((dcmd >> 14) & 0x3)) >> 1;
+
+	pos += seq_printf(s, "DMA channel %d\n", chan);
+	pos += seq_printf(s, "\tPriority : %s\n",
+			  str_prio[dmac->prio]);
+	pos += seq_printf(s, "\tUnaligned transfer bit: %s\n",
+			  DALGN & (1 << chan) ? "yes" : "no");
+	pos += seq_printf(s,
+		"\tDCSR  = %08x (%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s)\n",
+			  dcsr, DCSR_STR(RUN), DCSR_STR(NODESC),
+			  DCSR_STR(STOPIRQEN), DCSR_STR(EORIRQEN),
+			  DCSR_STR(EORJMPEN), DCSR_STR(EORSTOPEN),
+			  DCSR_STR(SETCMPST), DCSR_STR(CLRCMPST),
+			  DCSR_STR(CMPST), DCSR_STR(EORINTR), DCSR_STR(REQPEND),
+			  DCSR_STR(STOPSTATE), DCSR_STR(ENDINTR),
+			  DCSR_STR(STARTINTR), DCSR_STR(BUSERR));
+
+	pos += seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d"
+			  " len=%d)\n",
+			  dcmd,
+			  DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
+			  DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
+			  DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
+			  DCMD_STR(ENDIAN), burst, width, dcmd & DCMD_LENGTH);
+	pos += seq_printf(s, "\tDSADR = %08x\n", DSADR(chan));
+	pos += seq_printf(s, "\tDTADR = %08x\n", DTADR(chan));
+	pos += seq_printf(s, "\tDDADR = %08x\n", DDADR(chan));
+	return pos;
+}
+
+static int dbg_show_state(struct seq_file *s, void *p)
+{
+	int pos = 0;
+
+	/* basic device status */
+	pos += seq_printf(s, "DMA engine status\n");
+	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
+
+	return pos;
+}
+
+#define DBGFS_FUNC_DECL(name) \
+static int dbg_open_##name(struct inode *inode, struct file *file) \
+{ \
+	return single_open(file, dbg_show_##name, inode->i_private); \
+} \
+static const struct file_operations dbg_fops_##name = { \
+	.owner		= THIS_MODULE, \
+	.open		= dbg_open_##name, \
+	.llseek		= seq_lseek, \
+	.read		= seq_read, \
+	.release	= single_release, \
+}
+
+DBGFS_FUNC_DECL(state);
+DBGFS_FUNC_DECL(chan_state);
+DBGFS_FUNC_DECL(descriptors);
+DBGFS_FUNC_DECL(requester_chan);
+
+static struct dentry *pxa_dmac_dbg_alloc_chan(int ch,
+		struct dentry *chandir, void *dt)
+{
+	char chan_name[11];
+	struct dentry *chan, *chan_state = NULL, *chan_descr = NULL;
+	struct dentry *chan_reqs = NULL;
+
+	scnprintf(chan_name, sizeof(chan_name), "%d", ch);
+	chan = debugfs_create_dir(chan_name, chandir);
+
+	if (chan)
+		chan_state = debugfs_create_file("state", 0400, chan, dt,
+						 &dbg_fops_chan_state);
+	if (chan_state)
+		chan_descr = debugfs_create_file("descriptors", 0400, chan, dt,
+						 &dbg_fops_descriptors);
+	if (chan_descr)
+		chan_reqs = debugfs_create_file("requesters", 0400, chan, dt,
+						&dbg_fops_requester_chan);
+	if (!chan_reqs)
+		goto err_state;
+
+	return chan;
+
+err_state:
+	debugfs_remove_recursive(chan);
+	return NULL;
+}
+
+static void pxa_dmac_init_debugfs(int nr_ch, struct pxa_dmac_chan *dmac)
+{
+	int i;
+	struct dentry *chandir;
+
+	num_dma_channels = nr_ch;
+
+	dbgfs_root = debugfs_create_dir(DMA_DEBUG_NAME, NULL);
+	if (IS_ERR(dbgfs_root) || !dbgfs_root)
+		goto err_root;
+
+	dbgfs_state = debugfs_create_file("state", 0400, dbgfs_root, NULL,
+					  &dbg_fops_state);
+	if (!dbgfs_state)
+		goto err_state;
+
+	dbgfs_chan = kmalloc(sizeof(*dbgfs_state) * num_dma_channels,
+			     GFP_KERNEL);
+	if (!dbgfs_chan)
+		goto err_alloc;
+
+	chandir = debugfs_create_dir("channels", dbgfs_root);
+	if (!chandir)
+		goto err_chandir;
+
+	for (i = 0; i < num_dma_channels; i++) {
+		dbgfs_chan[i] = pxa_dmac_dbg_alloc_chan(i, chandir, &dmac[i]);
+		if (!dbgfs_chan[i])
+			goto err_chans;
+	}
+
+	spin_lock_init(&dbgfs_lock);
+	return;
+err_chans:
+err_chandir:
+	kfree(dbgfs_chan);
+err_alloc:
+err_state:
+	debugfs_remove_recursive(dbgfs_root);
+err_root:
+	dev_dbg(dmac->pxa_dmac->dev, "pxa_dma: debugfs is not available\n");
+}
+
+static void __exit pxa_dmac_cleanup_debugfs(void)
+{
+	debugfs_remove_recursive(dbgfs_root);
+}
+#else
+static inline void pxa_dmac_init_debugfs(nr_ch) {}
+static inline void pxa_dmac_cleanup_debugfs(void) {}
+#endif
+
+#ifdef DEBUG
+static void pxa_dmac_dump_dma_list(struct pxa_dmac_chan *dmac)
+{
+	struct pxa_dma_desc *desc = dmac->desc_arr;
+	unsigned long flags;
+
+	if (!desc) {
+		dev_dbg(dmac->pxa_dmac->dev,
+			"dma description list has no node!\n");
+		return;
+	}
+
+	local_irq_save(flags);
+
+	dev_dbg(dmac->pxa_dmac->dev, "dma description list nodes:\n");
+	do {
+		dev_dbg(dmac->pxa_dmac->dev, ("---------------------\n");
+		dev_dbg(dmac->pxa_dmac->dev, "ddadr = 0x%08x\n", desc->ddadr);
+		dev_dbg(dmac->pxa_dmac->dev, "dsadr = 0x%08x\n", desc->dsadr);
+		dev_dbg(dmac->pxa_dmac->dev, "dtadr = 0x%08x\n", desc->dtadr);
+		dev_dbg(dmac->pxa_dmac->dev, "dcmd  = 0x%08x\n", desc->dcmd);
+
+		if (desc->ddadr & DDADR_STOP)
+			break;
+
+		desc = (pxa_dma_desc *)((desc->ddadr & DDADR_DESCADDR) -
+				(int)dmac->desc_arr_phys +
+				(int)dmac->desc_arr);
+
+	} while (desc != dmac->desc_arr);
+
+	local_irq_restore(flags);
+	return;
+}
+#else
+#define pxa_dmac_dump_dma_list(dmac) do { } while (0)
+#endif
+
+static struct pxa_dmac_chan *to_pxa_dmac_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct pxa_dmac_chan, chan);
+}
+
+static void pxa_dmac_enable_chan(struct pxa_dmac_chan *dmac)
+{
+	DCSR(dmac->idx) = DCSR(dmac->idx) | DCSR_RUN;
+
+	dev_dbg(dmac->pxa_dmac->dev, "%s: [%x] DCSR %x\n",
+		__func__, dmac->idx, DCSR(dmac->idx));
+}
+
+static void pxa_dmac_disable_chan(struct pxa_dmac_chan *dmac)
+{
+	DCSR(dmac->idx) = DCSR(dmac->idx) & ~DCSR_RUN;
+
+	dmac->status = DMA_SUCCESS;
+}
+
+static void pxa_dmac_resume_chan(struct pxa_dmac_chan *dmac)
+{
+	DCSR(dmac->idx) = DCSR(dmac->idx) | DCSR_RUN;
+
+	dmac->status = DMA_IN_PROGRESS;
+}
+
+static void pxa_dmac_pause_chan(struct pxa_dmac_chan *dmac)
+{
+	DCSR(dmac->idx) = DCSR(dmac->idx) & ~DCSR_RUN;
+
+	dmac->status = DMA_PAUSED;
+}
+
+static dma_cookie_t pxa_dmac_assign_cookie(struct pxa_dmac_chan *dmac)
+{
+	dma_cookie_t cookie = dmac->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	dmac->chan.cookie = cookie;
+	dmac->desc.cookie = cookie;
+
+	return cookie;
+}
+
+unsigned long pxa_dmac_chan_get_src_ptr(struct dma_chan *chan)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+
+	return DSADR(dmac->idx);
+}
+EXPORT_SYMBOL(pxa_dmac_chan_get_src_ptr);
+
+unsigned long pxa_dmac_chan_get_dst_ptr(struct dma_chan *chan)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+
+	return DTADR(dmac->idx);
+}
+EXPORT_SYMBOL(pxa_dmac_chan_get_dst_ptr);
+
+pxa_dma_prio pxa_dmac_chan_get_prio(struct dma_chan *chan)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+
+	return dmac->prio;
+}
+EXPORT_SYMBOL(pxa_dmac_chan_get_prio);
+
+static dma_cookie_t pxa_dmac_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(tx->chan);
+
+	pxa_dmac_enable_chan(dmac);
+
+	return pxa_dmac_assign_cookie(dmac);
+}
+
+static irqreturn_t pxa_dmac_int_handler(int irq, void *dev_id)
+{
+	struct pxa_dmac_chan *dmac = dev_id;
+
+	if (DCSR(dmac->idx) & DCSR_BUSERR) {
+		dev_err(dmac->pxa_dmac->dev, "%s: error in channel %d\n",
+			__func__, dmac->idx);
+
+		dmac->status = DMA_ERROR;
+	} else {
+		if (dmac->flags & DMAC_CYCLIC_LOOP)
+			dmac->status = DMA_IN_PROGRESS;
+		else
+			dmac->status = DMA_SUCCESS;
+	}
+
+	if (dmac->status == DMA_SUCCESS)
+		dmac->last_completed = dmac->desc.cookie;
+
+	/* clear irq */
+	DCSR(dmac->idx) = DCSR(dmac->idx) | DCSR_STARTINTR |
+		DCSR_ENDINTR | DCSR_BUSERR;
+
+	if (dmac->desc.callback)
+		dmac->desc.callback(dmac->desc.callback_param);
+
+	return IRQ_HANDLED;
+}
+
+static int pxa_dmac_alloc_descriptor(struct pxa_dmac_chan *dmac)
+{
+	struct pxa_dmac_engine *pxa_dmac = dmac->pxa_dmac;
+
+	dev_dbg(dmac->pxa_dmac->dev, "%s: enter\n", __func__);
+
+	dmac->desc_arr = dma_alloc_coherent(pxa_dmac->dev,
+			DMAC_DESC_SIZE, &dmac->desc_arr_phys, GFP_KERNEL);
+	if (!dmac->desc_arr)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void pxa_dmac_free_descriptor(struct pxa_dmac_chan *dmac)
+{
+	struct pxa_dmac_engine *pxa_dmac = dmac->pxa_dmac;
+
+	dma_free_coherent(pxa_dmac->dev, DMAC_DESC_SIZE,
+			dmac->desc_arr, dmac->desc_arr_phys);
+}
+
+static int pxa_dmac_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+	int ret;
+
+	dev_dbg(dmac->pxa_dmac->dev, "%s: enter\n", __func__);
+
+	ret = pxa_dmac_alloc_descriptor(dmac);
+	if (ret < 0)
+		return ret;
+
+	dma_async_tx_descriptor_init(&dmac->desc, chan);
+	dmac->desc.tx_submit = pxa_dmac_tx_submit;
+
+	/* the descriptor is ready */
+	async_tx_ack(&dmac->desc);
+
+	ret = request_irq(dmac->irq, pxa_dmac_int_handler, IRQF_DISABLED,
+			  "dmac", dmac);
+	if (ret)
+		goto err_request_irq;
+
+	/*
+	 * init command register for default config,
+	 * later user can call dmaengine_slave_config
+	 * to config more settings.
+	 */
+	dmac->dcmd = DCMD_ENDIRQEN | DCMD_BURST8;
+	return 0;
+
+err_request_irq:
+	pxa_dmac_free_descriptor(dmac);
+	return ret;
+}
+
+static void pxa_dmac_free_chan_resources(struct dma_chan *chan)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+
+	dev_dbg(dmac->pxa_dmac->dev, "%s: enter\n", __func__);
+
+	free_irq(dmac->irq, dmac);
+	pxa_dmac_disable_chan(dmac);
+	pxa_dmac_free_descriptor(dmac);
+}
+
+static int pxa_dmac_config_chan(struct pxa_dmac_chan *dmac)
+{
+	struct pxa_dmac_engine *pxa_dmac = dmac->pxa_dmac;
+	struct pxa_dmac_data *dmac_data = dmac->chan.private;
+
+	pxa_dmac_disable_chan(dmac);
+
+	if (dmac->dir == DMA_TO_DEVICE) {
+		dmac->dcmd |= DCMD_INCSRCADDR;
+		if (dmac_data->flow_ctrl)
+			dmac->dcmd |= DCMD_FLOWTRG;
+	} else if (dmac->dir == DMA_FROM_DEVICE) {
+		dmac->dcmd |= DCMD_INCTRGADDR;
+		if (dmac_data->flow_ctrl)
+			dmac->dcmd |= DCMD_FLOWSRC;
+	} else
+		dmac->dcmd |= DCMD_INCSRCADDR | DCMD_INCTRGADDR;
+
+	switch (dmac->burst_sz) {
+	case 8: /* 8 bytes */
+		dmac->dcmd |= DCMD_BURST8;
+		break;
+	case 16: /* 16 bytes */
+		dmac->dcmd |= DCMD_BURST16;
+		break;
+	case 32: /* 32 bytes */
+		dmac->dcmd |= DCMD_BURST32;
+		break;
+	default:
+		dev_err(pxa_dmac->dmac_device.dev, "invalid burst size\n");
+		return -EINVAL;
+	}
+
+	switch (dmac->width) {
+	case DMA_SLAVE_BUSWIDTH_UNDEFINED:
+		break;
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		dmac->dcmd |= DCMD_WIDTH1;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		dmac->dcmd |= DCMD_WIDTH2;
+		break;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		dmac->dcmd |= DCMD_WIDTH4;
+		break;
+	default:
+		dev_err(pxa_dmac->dmac_device.dev, "invalid width size\n");
+		return -EINVAL;
+	}
+
+	dmac->ch_map = dmac_data->ch_map;
+	if (dmac->ch_map != -1)
+		DRCMR(dmac->ch_map) = dmac->idx | DRCMR_MAPVLD;
+
+	return 0;
+}
+
+static struct dma_async_tx_descriptor *pxa_dmac_prep_memcpy(
+		struct dma_chan *chan,
+		dma_addr_t dma_dst, dma_addr_t dma_src,
+		size_t len, unsigned long flags)
+{
+	struct pxa_dmac_chan *dmac;
+	struct pxa_dma_desc *desc;
+	size_t copy;
+	int i = 0;
+
+	if (!chan || !len)
+		return NULL;
+
+	dmac = to_pxa_dmac_chan(chan);
+	dmac->status = DMA_IN_PROGRESS;
+
+	dmac->dcmd |= DCMD_INCSRCADDR | DCMD_INCTRGADDR;
+
+	dev_dbg(dmac->pxa_dmac->dev, "%s: desc_arr %p desc_arr_phys %x\n",
+		__func__, dmac->desc_arr, dmac->desc_arr_phys);
+
+	do {
+		dev_dbg(dmac->pxa_dmac->dev, "%s: dst %x src %x len %d\n",
+			__func__, dma_dst, dma_src, len);
+
+		desc = &dmac->desc_arr[i];
+		copy = min(len, (size_t)DMAC_MAX_XFER_BYTES);
+
+		desc->ddadr = dmac->desc_arr_phys + sizeof(*desc) * (i + 1);
+		desc->dsadr = dma_src;
+		desc->dtadr = dma_dst;
+		desc->dcmd  = dmac->dcmd | copy;
+
+		len -= copy;
+		dma_src += copy;
+		dma_dst += copy;
+
+		if (!len)
+			desc->ddadr |= DDADR_STOP;
+
+		i++;
+	} while (len);
+
+	DDADR(dmac->idx) = dmac->desc_arr_phys;
+
+	pxa_dmac_dump_dma_list(dmac);
+	return &dmac->desc;
+}
+
+static struct dma_async_tx_descriptor *pxa_dmac_prep_sg(struct dma_chan *chan,
+	struct scatterlist *dst_sg, unsigned int dst_nents,
+	struct scatterlist *src_sg, unsigned int src_nents,
+	unsigned long flags)
+{
+	struct pxa_dmac_chan *dmac;
+	struct pxa_dma_desc *desc = NULL;
+	size_t dst_avail, src_avail;
+	dma_addr_t dst, src;
+	size_t len;
+	int i = 0;
+
+	/* basic sanity checks */
+	if (dst_nents == 0 || src_nents == 0)
+		return NULL;
+
+	if (dst_sg == NULL || src_sg == NULL)
+		return NULL;
+
+	dmac = to_pxa_dmac_chan(chan);
+	dmac->status = DMA_IN_PROGRESS;
+
+	dmac->dcmd |= DCMD_INCSRCADDR | DCMD_INCTRGADDR;
+
+	/* get prepared for the loop */
+	dst_avail = sg_dma_len(dst_sg);
+	src_avail = sg_dma_len(src_sg);
+
+	/* run until we are out of scatterlist entries */
+	while (true) {
+
+		dev_dbg(dmac->pxa_dmac->dev, "%s: dst_avail %x src_avail %x\n",
+			__func__, dst_avail, src_avail);
+
+		/* create the largest transaction possible */
+		len = min_t(size_t, src_avail, dst_avail);
+		len = min_t(size_t, len, DMAC_MAX_XFER_BYTES);
+		if (len == 0)
+			goto fetch;
+
+		dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_avail;
+		src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_avail;
+
+		dev_dbg(dmac->pxa_dmac->dev, "%s: dst %x src %x len %x\n",
+			__func__, dst, src, len);
+
+		if (i >= DMAC_DESC_NUM)
+			goto fail;
+
+		desc = &dmac->desc_arr[i];
+		desc->ddadr = dmac->desc_arr_phys + sizeof(*desc) * (i + 1);
+		desc->dsadr = src;
+		desc->dtadr = dst;
+		desc->dcmd  = dmac->dcmd | len;
+
+		/* update metadata */
+		dst_avail -= len;
+		src_avail -= len;
+		i++;
+
+fetch:
+		/* fetch the next dst scatterlist entry */
+		if (dst_avail == 0) {
+
+			/* no more entries: we're done */
+			if (dst_nents == 0)
+				break;
+
+			/* fetch the next entry: if there are no more: done */
+			dst_sg = sg_next(dst_sg);
+			if (dst_sg == NULL)
+				break;
+
+			dst_nents--;
+			dst_avail = sg_dma_len(dst_sg);
+		}
+
+		/* fetch the next src scatterlist entry */
+		if (src_avail == 0) {
+
+			/* no more entries: we're done */
+			if (src_nents == 0)
+				break;
+
+			/* fetch the next entry: if there are no more: done */
+			src_sg = sg_next(src_sg);
+			if (src_sg == NULL)
+				break;
+
+			src_nents--;
+			src_avail = sg_dma_len(src_sg);
+		}
+	}
+
+	if (desc)
+		desc->ddadr |= DDADR_STOP;
+
+	DDADR(dmac->idx) = dmac->desc_arr_phys;
+
+	pxa_dmac_dump_dma_list(dmac);
+	return &dmac->desc;
+
+fail:
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *pxa_dmac_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long append)
+{
+	struct pxa_dmac_chan *dmac;
+	struct pxa_dma_desc *desc = NULL;
+	struct scatterlist *sg;
+	size_t avail, len;
+	dma_addr_t slave_addr;
+	unsigned int i;
+
+	if (!sgl || !sg_len)
+		return NULL;
+
+	dmac = to_pxa_dmac_chan(chan);
+	dmac->status = DMA_IN_PROGRESS;
+
+	slave_addr = dmac->dev_addr;
+	for_each_sg(sgl, sg, sg_len, i) {
+		dma_addr_t sg_addr = sg_dma_address(sg);
+		avail = sg_dma_len(sg);
+		do {
+			len = min_t(size_t, avail, DMAC_MAX_XFER_BYTES);
+
+			dev_dbg(dmac->pxa_dmac->dev,
+				"Add SG #%d@%p[%d], dma %llx\n",
+				i, sg, len, (unsigned long long)sg_addr);
+
+			if (i >= DMAC_DESC_NUM)
+				goto fail;
+
+			desc = &dmac->desc_arr[i];
+			desc->ddadr = dmac->desc_arr_phys +
+				sizeof(*desc) * (i + 1);
+			if (direction == DMA_FROM_DEVICE) {
+				desc->dtadr = sg_addr;
+				desc->dsadr = slave_addr;
+				desc->dcmd  = dmac->dcmd | len;
+			} else {
+				desc->dtadr = slave_addr;
+				desc->dsadr = sg_addr;
+				desc->dcmd  = dmac->dcmd | len;
+			}
+
+			avail -= len;
+			sg_addr += len;
+			i++;
+
+		} while (avail);
+	}
+
+	if (desc)
+		desc->ddadr |= DDADR_STOP;
+
+	DDADR(dmac->idx) = dmac->desc_arr_phys;
+
+	pxa_dmac_dump_dma_list(dmac);
+	return &dmac->desc;
+
+fail:
+	return NULL;
+}
+
+static int pxa_dmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+		unsigned long arg)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+	struct dma_slave_config *dmaengine_cfg = (void *)arg;
+	int ret = 0;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		pxa_dmac_disable_chan(dmac);
+		break;
+	case DMA_PAUSE:
+		pxa_dmac_pause_chan(dmac);
+		break;
+	case DMA_RESUME:
+		pxa_dmac_resume_chan(dmac);
+		break;
+	case DMA_SLAVE_CONFIG:
+		if (dmaengine_cfg->direction == DMA_FROM_DEVICE) {
+			dmac->dev_addr = dmaengine_cfg->src_addr;
+			dmac->burst_sz = dmaengine_cfg->src_maxburst;
+			dmac->width    = dmaengine_cfg->src_addr_width;
+		} else {
+			dmac->dev_addr = dmaengine_cfg->dst_addr;
+			dmac->burst_sz = dmaengine_cfg->dst_maxburst;
+			dmac->width    = dmaengine_cfg->dst_addr_width;
+		}
+		dmac->dir = dmaengine_cfg->direction;
+		return pxa_dmac_config_chan(dmac);
+	default:
+		ret = -ENOSYS;
+	}
+
+	return ret;
+}
+
+static enum dma_status pxa_dmac_tx_status(struct dma_chan *chan,
+			dma_cookie_t cookie, struct dma_tx_state *txstate)
+{
+	struct pxa_dmac_chan *dmac = to_pxa_dmac_chan(chan);
+	dma_cookie_t last_used;
+
+	last_used = chan->cookie;
+	dma_set_tx_state(txstate, dmac->last_completed, last_used, 0);
+
+	return dmac->status;
+}
+
+static void pxa_dmac_issue_pending(struct dma_chan *chan)
+{
+	/*
+	 * Nothing to do. We only have a single descriptor.
+	 */
+}
+
+static void pxa_dmac_irq_ack(struct irq_data *d)
+{
+	DCSR(d->irq - dma_irq_base) = DCSR(d->irq - dma_irq_base) |
+		DCSR_STARTINTR | DCSR_ENDINTR | DCSR_BUSERR;
+}
+
+static void pxa_dmac_irq_mask(struct irq_data *d)
+{
+	DCSR(d->irq - dma_irq_base) = DCSR(d->irq - dma_irq_base) &
+		~DCSR_STOPIRQEN;
+}
+
+static void pxa_dmac_irq_unmask(struct irq_data *d)
+{
+	/*
+	 * As manual say, if the STOPIRQEN bit is set
+	 * before the channel is started, an interrupt
+	 * will be generated. So let driver set this bit
+	 * after the channel has began to run.
+	 */
+}
+
+static void pxa_dma_demux_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int i, dint = DINT;
+
+	while (dint) {
+		i = __ffs(dint);
+		dint &= (dint - 1);
+		generic_handle_irq(dma_irq_base + i);
+	}
+}
+
+static struct irq_chip pxa_muxed_dma_chip = {
+	.name		= "DMAC",
+	.irq_ack	= pxa_dmac_irq_ack,
+	.irq_mask	= pxa_dmac_irq_mask,
+	.irq_unmask	= pxa_dmac_irq_unmask,
+};
+
+static int __init pxa_dmac_init_irq(int mux_irq, int second_irq_start,
+				    int num_ch)
+{
+	int i = 0, irq;
+	struct irq_data *d;
+	struct irq_chip *chip = &pxa_muxed_dma_chip;
+
+	/* init dma irq */
+	for (irq = second_irq_start; i < num_ch; irq++, i++) {
+		d = irq_get_irq_data(irq);
+
+		/* mask and clear the IRQ */
+		chip->irq_mask(d);
+		if (chip->irq_ack)
+			chip->irq_ack(d);
+
+		irq_set_chip(irq, chip);
+		set_irq_flags(irq, IRQF_VALID);
+		irq_set_handler(irq, handle_level_irq);
+	}
+	irq_set_chained_handler(mux_irq, pxa_dma_demux_handler);
+
+	return 0;
+}
+
+static int __init pxa_dmac_probe(struct platform_device *pdev)
+{
+	struct pxa_dmac_engine *pxa_dmac;
+	struct pxa_dmac_chan *dmac;
+	struct resource *iores;
+	struct pxa_dmac_platform_data *pdata = pdev->dev.platform_data;
+	int i, irq;
+	int ret;
+
+	if (!pdata)
+		return -ENODEV;
+
+	dma_irq_base = pdata->irq_base;
+
+	pxa_dmac = kzalloc(pdata->nr_ch * (sizeof(*dmac)) +
+			   sizeof(*pxa_dmac), GFP_KERNEL);
+	if (!pxa_dmac)
+		return -ENOMEM;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
+		ret = -EINVAL;
+		goto err_irq;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		dev_info(&pdev->dev, "No interrupt specified\n");
+	else
+		pxa_dmac_init_irq(irq, pdata->irq_base, pdata->nr_ch);
+
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name)) {
+		ret = -EBUSY;
+		goto err_request_region;
+	}
+
+	pxa_dmac->base = ioremap(iores->start, resource_size(iores));
+	if (!pxa_dmac->base) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	dma_cap_set(DMA_MEMCPY, pxa_dmac->dmac_device.cap_mask);
+	dma_cap_set(DMA_SLAVE, pxa_dmac->dmac_device.cap_mask);
+	dma_cap_set(DMA_SG, pxa_dmac->dmac_device.cap_mask);
+
+	INIT_LIST_HEAD(&pxa_dmac->dmac_device.channels);
+
+	/* initialize channel parameters */
+	for (i = 0; i < pdata->nr_ch; i++) {
+
+		dmac = &pxa_dmac->dmac[i];
+
+		/*
+		 * dma channel priorities on pxa2xx processors:
+		 * ch 0 - 3,  16 - 19  <--> (0) DMA_PRIO_HIGH
+		 * ch 4 - 7,  20 - 23  <--> (1) DMA_PRIO_MEDIUM
+		 * ch 8 - 15, 24 - 31  <--> (2) DMA_PRIO_LOW
+		 */
+		dmac->pxa_dmac	  = pxa_dmac;
+		dmac->chan.device = &pxa_dmac->dmac_device;
+		dmac->prio	  = min((i & 0xf) >> 2, DMA_PRIO_LOW);
+		dmac->irq	  = pdata->irq_base + i;
+		dmac->idx	  = i;
+
+		/* add the channel to tdma_chan list */
+		list_add_tail(&dmac->chan.device_node,
+			      &pxa_dmac->dmac_device.channels);
+	}
+
+	pxa_dmac->dev = &pdev->dev;
+	pxa_dmac->dmac_nr = pdata->nr_ch;
+	pxa_dmac->dmac_device.dev = &pdev->dev;
+	pxa_dmac->dmac_device.device_alloc_chan_resources =
+					pxa_dmac_alloc_chan_resources;
+	pxa_dmac->dmac_device.device_free_chan_resources =
+					pxa_dmac_free_chan_resources;
+	pxa_dmac->dmac_device.device_prep_dma_memcpy = pxa_dmac_prep_memcpy;
+	pxa_dmac->dmac_device.device_prep_slave_sg = pxa_dmac_prep_slave_sg;
+	pxa_dmac->dmac_device.device_prep_dma_sg = pxa_dmac_prep_sg;
+	pxa_dmac->dmac_device.device_tx_status = pxa_dmac_tx_status;
+	pxa_dmac->dmac_device.device_issue_pending = pxa_dmac_issue_pending;
+	pxa_dmac->dmac_device.device_control = pxa_dmac_control;
+	pxa_dmac->dmac_device.copy_align = DMAC_ALIGNMENT;
+
+	dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+
+	ret = dma_async_device_register(&pxa_dmac->dmac_device);
+	if (ret) {
+		dev_err(pxa_dmac->dmac_device.dev, "unable to register\n");
+		goto err_init;
+	}
+
+	pxa_dmac_init_debugfs(pdata->nr_ch, pxa_dmac->dmac);
+
+	dev_info(pxa_dmac->dmac_device.dev, "initialized\n");
+	return 0;
+
+err_init:
+	iounmap(pxa_dmac->base);
+err_ioremap:
+	release_mem_region(iores->start, resource_size(iores));
+err_request_region:
+err_irq:
+	kfree(pxa_dmac);
+	return ret;
+}
+
+static struct platform_driver pxa_dmac_driver = {
+	.driver		= {
+		.name	= "pxa-dmac",
+	},
+};
+
+static int __init pxa_dmac_module_init(void)
+{
+	return platform_driver_probe(&pxa_dmac_driver, pxa_dmac_probe);
+}
+subsys_initcall(pxa_dmac_module_init);
+
+MODULE_AUTHOR("Leo Yan <leoy@marvell.com>");
+MODULE_DESCRIPTION("PXA DMAC driver");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

