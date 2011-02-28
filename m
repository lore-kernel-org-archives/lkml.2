Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1B1Km6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:42:58 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:56180 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab1B1Kmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:42:51 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>, <shiraz.hashim@st.com>,
        <amit.goel@st.com>, <armando.visconti@st.com>
Subject: [PATCH 8/8 resend] dw_dmac.c: Pass Channel Priority from platform_data
Date: Mon, 28 Feb 2011 16:11:23 +0530
Message-ID: <12a1cd2df6804fbd27adf57d73b5fb0c0fb6145c.1298889267.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Synopsys designware, channel priority is programmable. This patch adds
support for passing channel priority through platform data. By default Ascending
channel priority will be followed, i.e. channel 0 will get highest priority and
channel 7 will get lowest.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c      |   11 ++++++++++-
 drivers/dma/dw_dmac_regs.h |    3 +++
 include/linux/dw_dmac.h    |    4 +++-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 37ffd2c..edb3d3b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -896,8 +896,11 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 		BUG_ON(!dws->dma_dev || dws->dma_dev != dw->dma.dev);
 
 		cfghi = dws->cfg_hi;
-		cfglo = dws->cfg_lo;
+		cfglo = dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
 	}
+
+	cfglo |= DWC_CFGL_CH_PRIOR(dwc->priority);
+
 	channel_writel(dwc, CFG_LO, cfglo);
 	channel_writel(dwc, CFG_HI, cfghi);
 
@@ -1320,6 +1323,12 @@ static int __init dw_probe(struct platform_device *pdev)
 		else
 			list_add(&dwc->chan.device_node, &dw->dma.channels);
 
+		/* 7 is highest priority & 0 is lowest. */
+		if (pdata->chan_priority == CHAN_PRIORITY_ASCENDING)
+			dwc->priority = 7 - i;
+		else
+			dwc->priority = i;
+
 		dwc->ch_regs = &__dw_regs(dw)->CHAN[i];
 		spin_lock_init(&dwc->lock);
 		dwc->mask = 1 << i;
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index d9a939f..6a8e6d3 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -101,6 +101,8 @@ struct dw_dma_regs {
 #define DWC_CTLH_BLOCK_TS_MASK	0x00000fff
 
 /* Bitfields in CFG_LO. Platform-configurable bits are in <linux/dw_dmac.h> */
+#define DWC_CFGL_CH_PRIOR_MASK	(0x7 << 5)	/* priority mask */
+#define DWC_CFGL_CH_PRIOR(x)	((x) << 5)	/* priority */
 #define DWC_CFGL_CH_SUSP	(1 << 8)	/* pause xfer */
 #define DWC_CFGL_FIFO_EMPTY	(1 << 9)	/* pause xfer */
 #define DWC_CFGL_HS_DST		(1 << 10)	/* handshake w/dst */
@@ -134,6 +136,7 @@ struct dw_dma_chan {
 	struct dma_chan		chan;
 	void __iomem		*ch_regs;
 	u8			mask;
+	u8			priority;
 
 	spinlock_t		lock;
 
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 057e883..53072c8 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -22,6 +22,9 @@ struct dw_dma_platform_data {
 #define CHAN_ALLOCATION_ASCENDING	0	/* zero to seven */
 #define CHAN_ALLOCATION_DESCENDING	1	/* seven to zero */
 	unsigned int	chan_allocation_order;
+#define CHAN_PRIORITY_ASCENDING		0	/* chan0 highest */
+#define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
+	unsigned int	chan_priority;
 };
 
 /**
@@ -65,7 +68,6 @@ struct dw_dma_slave {
 #define DWC_CFGH_DST_PER(x)	((x) << 11)
 
 /* Platform-configurable bits in CFG_LO */
-#define DWC_CFGL_PRIO(x)	((x) << 5)	/* priority */
 #define DWC_CFGL_LOCK_CH_XFER	(0 << 12)	/* scope of LOCK_CH */
 #define DWC_CFGL_LOCK_CH_BLOCK	(1 << 12)
 #define DWC_CFGL_LOCK_CH_XACT	(2 << 12)
-- 
1.7.2.2

