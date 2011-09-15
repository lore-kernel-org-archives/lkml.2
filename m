Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1IOKHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:07:31 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:36809 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1IOKH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:07:29 -0400
From: Barry Song <Baohua.Song@csr.com>
To: <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <workgroup.linux@csr.com>,
        Barry Song <Baohua.Song@csr.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Piotr Ziecik <kosmo@semihalf.com>,
        Yong Wang <yong.y.wang@intel.com>,
        Jaswinder Singh <jassi.brar@samsung.com>,
        Pelagicore AB <info@pelagicore.com>
Subject: [PATCH] dmaengine: delete redundant chan_id and chancnt initialization in dma drivers
Date: Thu, 15 Sep 2011 03:06:30 -0700
Message-ID: <1316081190-29777-1-git-send-email-Baohua.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_async_device_register will re-init chan_id and chancnt,
so whatever chan_id and chancnt are set in drivers, they will
be re-written by dma_async_device_register.

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Piotr Ziecik <kosmo@semihalf.com>
Cc: Yong Wang <yong.y.wang@intel.com>
Cc: Jaswinder Singh <jassi.brar@samsung.com>
Cc: Pelagicore AB <info@pelagicore.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 drivers/dma/at_hdmac.c      |    5 ++---
 drivers/dma/dw_dmac.c       |    5 ++---
 drivers/dma/intel_mid_dma.c |    2 --
 drivers/dma/mpc512x_dma.c   |    1 -
 drivers/dma/pch_dma.c       |    2 --
 drivers/dma/pl330.c         |    2 --
 drivers/dma/timb_dma.c      |    3 +--
 7 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6a483ea..c1b8c15 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1260,12 +1260,11 @@ static int __init at_dma_probe(struct platform_device *pdev)
 
 	/* initialize channels related values */
 	INIT_LIST_HEAD(&atdma->dma_common.channels);
-	for (i = 0; i < pdata->nr_channels; i++, atdma->dma_common.chancnt++) {
+	for (i = 0; i < pdata->nr_channels; i++) {
 		struct at_dma_chan	*atchan = &atdma->chan[i];
 
 		atchan->chan_common.device = &atdma->dma_common;
 		atchan->chan_common.cookie = atchan->completed_cookie = 1;
-		atchan->chan_common.chan_id = i;
 		list_add_tail(&atchan->chan_common.device_node,
 				&atdma->dma_common.channels);
 
@@ -1308,7 +1307,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Atmel AHB DMA Controller ( %s%s), %d channels\n",
 	  dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask) ? "cpy " : "",
 	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
-	  atdma->dma_common.chancnt);
+	  pdata->nr_channels);
 
 	dma_async_device_register(&atdma->dma_common);
 
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 4d180ca..9bfd6d3 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1407,12 +1407,11 @@ static int __init dw_probe(struct platform_device *pdev)
 	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
 
 	INIT_LIST_HEAD(&dw->dma.channels);
-	for (i = 0; i < pdata->nr_channels; i++, dw->dma.chancnt++) {
+	for (i = 0; i < pdata->nr_channels; i++) {
 		struct dw_dma_chan	*dwc = &dw->chan[i];
 
 		dwc->chan.device = &dw->dma;
 		dwc->chan.cookie = dwc->completed = 1;
-		dwc->chan.chan_id = i;
 		if (pdata->chan_allocation_order == CHAN_ALLOCATION_ASCENDING)
 			list_add_tail(&dwc->chan.device_node,
 					&dw->dma.channels);
@@ -1468,7 +1467,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
 	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-			dev_name(&pdev->dev), dw->dma.chancnt);
+			dev_name(&pdev->dev), pdata->nr_channels);
 
 	dma_async_device_register(&dw->dma);
 
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 8a3fdd8..cf74a66 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1114,7 +1114,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 
 		midch->chan.device = &dma->common;
 		midch->chan.cookie =  1;
-		midch->chan.chan_id = i;
 		midch->ch_id = dma->chan_base + i;
 		pr_debug("MDMA:Init CH %d, ID %d\n", i, midch->ch_id);
 
@@ -1150,7 +1149,6 @@ static int mid_setup_dma(struct pci_dev *pdev)
 	dma_cap_set(DMA_SLAVE, dma->common.cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma->common.cap_mask);
 	dma->common.dev = &pdev->dev;
-	dma->common.chancnt = dma->max_chan;
 
 	dma->common.device_alloc_chan_resources =
 					intel_mid_dma_alloc_chan_resources;
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index b9bae94..8ba4edc 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -741,7 +741,6 @@ static int __devinit mpc_dma_probe(struct platform_device *op)
 		mchan = &mdma->channels[i];
 
 		mchan->chan.device = dma;
-		mchan->chan.chan_id = i;
 		mchan->chan.cookie = 1;
 		mchan->completed_cookie = mchan->chan.cookie;
 
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 1ac8d4b..5b65362 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -926,7 +926,6 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
 	}
 
 	pd->dma.dev = &pdev->dev;
-	pd->dma.chancnt = nr_channels;
 
 	INIT_LIST_HEAD(&pd->dma.channels);
 
@@ -935,7 +934,6 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
 
 		pd_chan->chan.device = &pd->dma;
 		pd_chan->chan.cookie = 1;
-		pd_chan->chan.chan_id = i;
 
 		pd_chan->membase = &regs->desc[i];
 
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 00eee59..7f86e7d 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -747,11 +747,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		spin_lock_init(&pch->lock);
 		pch->pl330_chid = NULL;
 		pch->chan.device = pd;
-		pch->chan.chan_id = i;
 		pch->dmac = pdmac;
 
 		/* Add the channel to the DMAC list */
-		pd->chancnt++;
 		list_add_tail(&pch->chan.device_node, &pd->channels);
 	}
 
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index f69f90a..6dbdf45 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -753,7 +753,7 @@ static int __devinit td_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&td->dma.channels);
 
-	for (i = 0; i < pdata->nr_channels; i++, td->dma.chancnt++) {
+	for (i = 0; i < pdata->nr_channels; i++) {
 		struct timb_dma_chan *td_chan = &td->channels[i];
 		struct timb_dma_platform_data_channel *pchan =
 			pdata->channels + i;
@@ -767,7 +767,6 @@ static int __devinit td_probe(struct platform_device *pdev)
 
 		td_chan->chan.device = &td->dma;
 		td_chan->chan.cookie = 1;
-		td_chan->chan.chan_id = i;
 		spin_lock_init(&td_chan->lock);
 		INIT_LIST_HEAD(&td_chan->active_list);
 		INIT_LIST_HEAD(&td_chan->queue);
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
