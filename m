Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1D0Jhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:37:35 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:33387 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600Ab1D0Jha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:37:30 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V3 4/7] dmaengine/dw_dmac: Enable resubmission from callback routine.
Date: Wed, 27 Apr 2011 15:06:46 +0530
Message-ID: <adbd175c9fc15e65b584d342b65cd1c3c0c58322.1303896567.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303896566.git.viresh.kumar@st.com>
References: <cover.1303896566.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmission of new transfer must be allowed from callbacks. For this release
lock before calling callback routine and enable them again.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index f590109..3285ae9 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -199,10 +199,10 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 
 static void
 dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
-		bool callback_required)
+		bool callback_required, unsigned long flags)
 {
-	dma_async_tx_callback		callback;
-	void				*param;
+	dma_async_tx_callback		callback = NULL;
+	void				*param = NULL;
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	struct dw_desc			*child;
 
@@ -245,12 +245,15 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	}
 
 	if (callback_required) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
 		if (callback)
 			callback(param);
+		spin_lock_irqsave(&dwc->lock, flags);
 	}
 }
 
-static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
+static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc,
+		unsigned long flags)
 {
 	struct dw_desc *desc, *_desc;
 	LIST_HEAD(list);
@@ -276,10 +279,11 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	}
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc, 1);
+		dwc_descriptor_complete(dwc, desc, 1, flags);
 }
 
-static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
+static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc,
+		unsigned long flags)
 {
 	dma_addr_t llp;
 	struct dw_desc *desc, *_desc;
@@ -298,7 +302,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	if (status_xfer & dwc->mask) {
 		/* Everything we've submitted is done */
 		dma_writel(dw, CLEAR.XFER, dwc->mask);
-		dwc_complete_all(dw, dwc);
+		dwc_complete_all(dw, dwc, flags);
 		return;
 	}
 
@@ -326,7 +330,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		 * No descriptors so far seem to be in progress, i.e.
 		 * this one must be done.
 		 */
-		dwc_descriptor_complete(dwc, desc, 1);
+		dwc_descriptor_complete(dwc, desc, 1, flags);
 	}
 
 	dev_err(chan2dev(&dwc->chan),
@@ -351,12 +355,13 @@ static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
 			lli->ctlhi, lli->ctllo);
 }
 
-static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
+static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc,
+		unsigned long flags)
 {
 	struct dw_desc *bad_desc;
 	struct dw_desc *child;
 
-	dwc_scan_descriptors(dw, dwc);
+	dwc_scan_descriptors(dw, dwc, flags);
 
 	/*
 	 * The descriptor currently at the head of the active list is
@@ -388,7 +393,7 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_dump_lli(dwc, &child->lli);
 
 	/* Pretend the descriptor completed successfully */
-	dwc_descriptor_complete(dwc, bad_desc, 1);
+	dwc_descriptor_complete(dwc, bad_desc, 1, flags);
 }
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
@@ -493,9 +498,9 @@ static void dw_dma_tasklet(unsigned long data)
 			dwc_handle_cyclic(dw, dwc, status_block, status_err,
 					status_xfer);
 		else if (status_err & (1 << i))
-			dwc_handle_error(dw, dwc);
+			dwc_handle_error(dw, dwc, flags);
 		else if ((status_block | status_xfer) & (1 << i))
-			dwc_scan_descriptors(dw, dwc);
+			dwc_scan_descriptors(dw, dwc, flags);
 		spin_unlock_irqrestore(&dwc->lock, flags);
 	}
 
@@ -838,7 +843,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc, 0);
+		dwc_descriptor_complete(dwc, desc, 0, flags);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -862,7 +867,7 @@ dwc_tx_status(struct dma_chan *chan,
 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
 		spin_lock_irqsave(&dwc->lock, flags);
-		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+		dwc_scan_descriptors(to_dw_dma(chan->device), dwc, flags);
 		spin_unlock_irqrestore(&dwc->lock, flags);
 
 		last_complete = dwc->completed;
@@ -883,7 +888,7 @@ static void dwc_issue_pending(struct dma_chan *chan)
 
 	spin_lock_irqsave(&dwc->lock, flags);
 	if (!list_empty(&dwc->queue))
-		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+		dwc_scan_descriptors(to_dw_dma(chan->device), dwc, flags);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 
-- 
1.7.3.4

