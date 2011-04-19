Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1DSIc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:32:57 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:39645 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847Ab1DSIcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:32:52 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-kernel@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <amit.goel@st.com>, <viresh.linux@gmail.com>,
        <linus.walleij@linaro.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 4/7] dmaengine/dw_dmac: don't call callback routine in case dmaengine_terminate_all() is called
Date: Tue, 19 Apr 2011 14:02:09 +0530
Message-ID: <14106a88c7c86261732080be3e08b1dd5a826362.1303194836.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1303194835.git.viresh.kumar@st.com>
References: <cover.1303194835.git.viresh.kumar@st.com>
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
 drivers/dma/dw_dmac.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c211460..d8aad28 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -195,7 +195,8 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
 /*----------------------------------------------------------------------*/
 
 static void
-dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
+dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
+		bool callback_required)
 {
 	dma_async_tx_callback		callback = NULL;
 	void				*param = NULL;
@@ -205,8 +206,10 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	dev_vdbg(chan2dev(&dwc->chan), "descriptor %u complete\n", txd->cookie);
 
 	dwc->completed = txd->cookie;
-	callback = txd->callback;
-	param = txd->callback_param;
+	if (callback_required) {
+		callback = txd->callback;
+		param = txd->callback_param;
+	}
 
 	dwc_sync_desc_for_cpu(dwc, desc);
 
@@ -238,10 +241,12 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 		}
 	}
 
-	spin_unlock_irqrestore(&dwc->lock, dw->flags);
-	if (callback)
-		callback(param);
-	spin_lock_irqsave(&dwc->lock, dw->flags);
+	if (callback_required) {
+		spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
+		if (callback)
+			callback(param);
+		spin_lock_irqsave(&dwc->lock, dwc->lflags);
+	}
 }
 
 static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -270,7 +275,7 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	}
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, 1);
 }
 
 static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -320,7 +325,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		 * No descriptors so far seem to be in progress, i.e.
 		 * this one must be done.
 		 */
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, 1);
 	}
 
 	dev_dbg(chan2dev(&dwc->chan),
@@ -382,7 +387,7 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_dump_lli(dwc, &child->lli);
 
 	/* Pretend the descriptor completed successfully */
-	dwc_descriptor_complete(dwc, bad_desc);
+	dwc_descriptor_complete(dwc, bad_desc, 1);
 }
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
@@ -827,7 +832,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, 0);
 
 	spin_unlock_irqrestore(&dwc->lock, dwc->lflags);
 
-- 
1.7.2.2

