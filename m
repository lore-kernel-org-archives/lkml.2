Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1DRKvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:51:33 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:50025 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982Ab1DRKut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:50:49 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <jamie@jamieiles.com>, <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 4/6] dmaengine/dw_dmac: don't call callback routine in case dmaengine_terminate_all() is called
Date: Mon, 18 Apr 2011 16:20:02 +0530
Message-ID: <cbd92929c57f8daf383d08076bc7c6d782d96375.1303123511.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dmaengine_terminate_all() is called for dma channel, then it doesn't make
much sense to call registered callback routine. While in case of success or
failure it must be called.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index b49d7f3..9d8ed35 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -198,10 +198,11 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 /*----------------------------------------------------------------------*/
 
 static void
-dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
+dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
+		bool callback_required)
 {
-	dma_async_tx_callback		callback;
-	void				*param;
+	dma_async_tx_callback		callback = NULL;
+	void				*param = NULL;
 	struct dw_dma			*dw = to_dw_dma(dwc->chan.device);
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	struct dw_desc			*child;
@@ -209,8 +210,10 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	dev_vdbg(chan2dev(&dwc->chan), "descriptor %u complete\n", txd->cookie);
 
 	dwc->completed = txd->cookie;
-	callback = txd->callback;
-	param = txd->callback_param;
+	if (callback_required) {
+		callback = txd->callback;
+		param = txd->callback_param;
+	}
 
 	dwc_sync_desc_for_cpu(dwc, desc);
 
@@ -242,10 +245,12 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 		}
 	}
 
-	spin_unlock_irqrestore(&dwc->lock, dw->flags);
-	if (callback)
-		callback(param);
-	spin_lock_irqsave(&dwc->lock, dw->flags);
+	if (callback_required) {
+		spin_unlock_irqrestore(&dwc->lock, dw->flags);
+		if (callback)
+			callback(param);
+		spin_lock_irqsave(&dwc->lock, dw->flags);
+	}
 }
 
 static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -274,7 +279,7 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	}
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, 1);
 }
 
 static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -324,7 +329,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		 * No descriptors so far seem to be in progress, i.e.
 		 * this one must be done.
 		 */
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, 1);
 	}
 
 	dev_dbg(chan2dev(&dwc->chan),
@@ -386,7 +391,7 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_dump_lli(dwc, &child->lli);
 
 	/* Pretend the descriptor completed successfully */
-	dwc_descriptor_complete(dwc, bad_desc);
+	dwc_descriptor_complete(dwc, bad_desc, 1);
 }
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
@@ -832,7 +837,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, 0);
 
 	spin_unlock_irqrestore(&dwc->lock, dw->flags);
 
-- 
1.7.2.2

