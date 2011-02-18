Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1BREaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:30:13 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:21081 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab1BREaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:30:10 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/2] pch_dma: fix kernel error issue
Date: Fri, 18 Feb 2011 13:31:20 +0900
Message-Id: <1298003481-12845-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the following kernel error

------------[ cut here ]------------
WARNING: at kernel/softirq.c:159 _local_bh_enable_ip.clone.5+0x35/0x71()
Hardware name: To be filled by O.E.M.
Modules linked in: pch_uart pch_dma fuse mga drm cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec matroxfb_base snd_hwdep 8250_pnp snd_seq snd_seq_device matroxfb_DAC1064 snd_pcm joydev 8250 matroxfb_accel snd_timer matroxfb_Ti3026 ppdev pegasus parport_pc snd parport matroxfb_g450 g450_pll serial_core video output matroxfb_misc soundcore snd_page_alloc serio_raw pcspkr ext4 jbd2 crc16 sdhci_pci sdhci mmc_core floppy [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.37.upstream_check+ #8
Call Trace:
 [<c0433add>] warn_slowpath_common+0x65/0x7a
 [<c043825b>] ? _local_bh_enable_ip.clone.5+0x35/0x71
 [<c0433b01>] warn_slowpath_null+0xf/0x13
 [<c043825b>] _local_bh_enable_ip.clone.5+0x35/0x71
 [<c043829f>] local_bh_enable_ip+0x8/0xa
 [<c06ec471>] _raw_spin_unlock_bh+0x10/0x12
 [<f82b57dd>] pd_prep_slave_sg+0xba/0x200 [pch_dma]
 [<f82f7b7a>] pch_uart_interrupt+0x44d/0x6aa [pch_uart]
 [<c046fa97>] handle_IRQ_event+0x1d/0x9e
 [<c047146f>] handle_fasteoi_irq+0x90/0xc7
 [<c04713df>] ? handle_fasteoi_irq+0x0/0xc7
 <IRQ>  [<c04045af>] ? do_IRQ+0x3e/0x89
 [<c04035a9>] ? common_interrupt+0x29/0x30
 [<c04400d8>] ? sys_getpriority+0x12d/0x1a2
 [<c058bb2b>] ? arch_local_irq_enable+0x5/0xb
 [<c058c740>] ? acpi_idle_enter_bm+0x22a/0x261
 [<c0648b11>] ? cpuidle_idle_call+0x70/0xa1
 [<c0401f44>] ? cpu_idle+0x49/0x6a
 [<c06d9fc4>] ? rest_init+0x58/0x5a
 [<c089e762>] ? start_kernel+0x2d0/0x2d5
 [<c089e0ce>] ? i386_start_kernel+0xce/0xd5

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 1c38418..bf2ddd6 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -366,7 +366,7 @@ static dma_cookie_t pd_tx_submit(struct dma_async_tx_descriptor *txd)
 	struct pch_dma_chan *pd_chan = to_pd_chan(txd->chan);
 	dma_cookie_t cookie;
 
-	spin_lock_bh(&pd_chan->lock);
+	spin_lock(&pd_chan->lock);
 	cookie = pdc_assign_cookie(pd_chan, desc);
 
 	if (list_empty(&pd_chan->active_list)) {
@@ -376,7 +376,7 @@ static dma_cookie_t pd_tx_submit(struct dma_async_tx_descriptor *txd)
 		list_add_tail(&desc->desc_node, &pd_chan->queue);
 	}
 
-	spin_unlock_bh(&pd_chan->lock);
+	spin_unlock(&pd_chan->lock);
 	return 0;
 }
 
@@ -386,7 +386,7 @@ static struct pch_dma_desc *pdc_alloc_desc(struct dma_chan *chan, gfp_t flags)
 	struct pch_dma *pd = to_pd(chan->device);
 	dma_addr_t addr;
 
-	desc = pci_pool_alloc(pd->pool, GFP_KERNEL, &addr);
+	desc = pci_pool_alloc(pd->pool, flags, &addr);
 	if (desc) {
 		memset(desc, 0, sizeof(struct pch_dma_desc));
 		INIT_LIST_HEAD(&desc->tx_list);
@@ -405,7 +405,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
 	struct pch_dma_desc *ret = NULL;
 	int i;
 
-	spin_lock_bh(&pd_chan->lock);
+	spin_lock(&pd_chan->lock);
 	list_for_each_entry_safe(desc, _d, &pd_chan->free_list, desc_node) {
 		i++;
 		if (async_tx_test_ack(&desc->txd)) {
@@ -415,15 +415,15 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
 		}
 		dev_dbg(chan2dev(&pd_chan->chan), "desc %p not ACKed\n", desc);
 	}
-	spin_unlock_bh(&pd_chan->lock);
+	spin_unlock(&pd_chan->lock);
 	dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
 
 	if (!ret) {
 		ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
 		if (ret) {
-			spin_lock_bh(&pd_chan->lock);
+			spin_lock(&pd_chan->lock);
 			pd_chan->descs_allocated++;
-			spin_unlock_bh(&pd_chan->lock);
+			spin_unlock(&pd_chan->lock);
 		} else {
 			dev_err(chan2dev(&pd_chan->chan),
 				"failed to alloc desc\n");
@@ -437,10 +437,10 @@ static void pdc_desc_put(struct pch_dma_chan *pd_chan,
 			 struct pch_dma_desc *desc)
 {
 	if (desc) {
-		spin_lock_bh(&pd_chan->lock);
+		spin_lock(&pd_chan->lock);
 		list_splice_init(&desc->tx_list, &pd_chan->free_list);
 		list_add(&desc->desc_node, &pd_chan->free_list);
-		spin_unlock_bh(&pd_chan->lock);
+		spin_unlock(&pd_chan->lock);
 	}
 }
 
@@ -530,9 +530,9 @@ static void pd_issue_pending(struct dma_chan *chan)
 	struct pch_dma_chan *pd_chan = to_pd_chan(chan);
 
 	if (pdc_is_idle(pd_chan)) {
-		spin_lock_bh(&pd_chan->lock);
+		spin_lock(&pd_chan->lock);
 		pdc_advance_work(pd_chan);
-		spin_unlock_bh(&pd_chan->lock);
+		spin_unlock(&pd_chan->lock);
 	}
 }
 
@@ -592,7 +592,6 @@ static struct dma_async_tx_descriptor *pd_prep_slave_sg(struct dma_chan *chan,
 			goto err_desc_get;
 		}
 
-
 		if (!first) {
 			first = desc;
 		} else {
@@ -641,13 +640,13 @@ static int pd_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	spin_unlock_bh(&pd_chan->lock);
 
-
 	return 0;
 }
 
 static void pdc_tasklet(unsigned long data)
 {
 	struct pch_dma_chan *pd_chan = (struct pch_dma_chan *)data;
+	unsigned long flags;
 
 	if (!pdc_is_idle(pd_chan)) {
 		dev_err(chan2dev(&pd_chan->chan),
@@ -655,12 +654,12 @@ static void pdc_tasklet(unsigned long data)
 		return;
 	}
 
-	spin_lock_bh(&pd_chan->lock);
+	spin_lock_irqsave(&pd_chan->lock, flags);
 	if (test_and_clear_bit(0, &pd_chan->err_status))
 		pdc_handle_error(pd_chan);
 	else
 		pdc_advance_work(pd_chan);
-	spin_unlock_bh(&pd_chan->lock);
+	spin_unlock_irqrestore(&pd_chan->lock, flags);
 }
 
 static irqreturn_t pd_irq(int irq, void *devid)
-- 
1.7.3.4

