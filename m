Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1EEMBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:01:14 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:60751 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab1EEMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:01:12 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <linux-arm-kernel@lists.infradead.org>,
        <viresh.linux@gmail.com>, <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V4 1/5] dmaengine/dw_dmac: don't call callback routine in case dmaengine_terminate_all() is called
Date: Thu, 5 May 2011 17:30:29 +0530
Message-ID: <8d1b15be425a70cdbd30725b88bd303cc74e706d.1304596524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1304596524.git.viresh.kumar@st.com>
References: <cover.1304596524.git.viresh.kumar@st.com>
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
 drivers/dma/dw_dmac.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1bd4803..d28cd84 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -195,18 +195,21 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
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
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	struct dw_desc			*child;
 
 	dev_vdbg(chan2dev(&dwc->chan), "descriptor %u complete\n", txd->cookie);
 
 	dwc->completed = txd->cookie;
-	callback = txd->callback;
-	param = txd->callback_param;
+	if (callback_required) {
+		callback = txd->callback;
+		param = txd->callback_param;
+	}
 
 	dwc_sync_desc_for_cpu(dwc, desc);
 
@@ -238,12 +241,10 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 		}
 	}
 
-	/*
-	 * The API requires that no submissions are done from a
-	 * callback, so we don't need to drop the lock here
-	 */
-	if (callback)
-		callback(param);
+	if (callback_required) {
+		if (callback)
+			callback(param);
+	}
 }
 
 static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -272,7 +273,7 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	}
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, true);
 }
 
 static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -322,7 +323,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		 * No descriptors so far seem to be in progress, i.e.
 		 * this one must be done.
 		 */
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, true);
 	}
 
 	dev_dbg(chan2dev(&dwc->chan),
@@ -384,7 +385,7 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		dwc_dump_lli(dwc, &child->lli);
 
 	/* Pretend the descriptor completed successfully */
-	dwc_descriptor_complete(dwc, bad_desc);
+	dwc_descriptor_complete(dwc, bad_desc, true);
 }
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
@@ -831,7 +832,7 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	/* Flush all pending and queued descriptors */
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
-		dwc_descriptor_complete(dwc, desc);
+		dwc_descriptor_complete(dwc, desc, false);
 
 	return 0;
 }
-- 
1.7.2.2

