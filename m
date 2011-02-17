Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1BQHoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:44:25 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:36960 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab1BQHoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:44:21 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: [PATCH 2/7] dw_dmac: Move single descriptor from dwc->queue to dwc->active_list in dwc_complete_all
Date: Thu, 17 Feb 2011 12:54:52 +0530
Message-ID: <122e2a9f5af7ec24a42f823b66707cfe7e6115cc.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
References: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh KUMAR <viresh.kumar@st.com>

dwc_complete_all and other routines was removing all descriptors from dwc->queue
and pushing them to dwc->active_list. Only one was required to be removed. Also
we are calling dwc_dostart, once list is fixed.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a3991ab..6dd03b0 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -84,11 +84,6 @@ static struct dw_desc *dwc_first_active(struct dw_dma_chan *dwc)
 	return list_entry(dwc->active_list.next, struct dw_desc, desc_node);
 }
 
-static struct dw_desc *dwc_first_queued(struct dw_dma_chan *dwc)
-{
-	return list_entry(dwc->queue.next, struct dw_desc, desc_node);
-}
-
 static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
 {
 	struct dw_desc *desc, *_desc;
@@ -259,10 +254,11 @@ static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	 * Submit queued descriptors ASAP, i.e. before we go through
 	 * the completed ones.
 	 */
-	if (!list_empty(&dwc->queue))
-		dwc_dostart(dwc, dwc_first_queued(dwc));
 	list_splice_init(&dwc->active_list, &list);
-	list_splice_init(&dwc->queue, &dwc->active_list);
+	if (!list_empty(&dwc->queue)) {
+		list_move(dwc->queue.next, &dwc->active_list);
+		dwc_dostart(dwc, dwc_first_active(dwc));
+	}
 
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		dwc_descriptor_complete(dwc, desc);
@@ -319,8 +315,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		cpu_relax();
 
 	if (!list_empty(&dwc->queue)) {
-		dwc_dostart(dwc, dwc_first_queued(dwc));
-		list_splice_init(&dwc->queue, &dwc->active_list);
+		list_move(dwc->queue.next, &dwc->active_list);
+		dwc_dostart(dwc, dwc_first_active(dwc));
 	}
 }
 
@@ -346,7 +342,7 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	 */
 	bad_desc = dwc_first_active(dwc);
 	list_del_init(&bad_desc->desc_node);
-	list_splice_init(&dwc->queue, dwc->active_list.prev);
+	list_move(dwc->queue.next, dwc->active_list.prev);
 
 	/* Clear the error flag and try to restart the controller */
 	dma_writel(dw, CLEAR.ERROR, dwc->mask);
@@ -541,8 +537,8 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (list_empty(&dwc->active_list)) {
 		dev_vdbg(chan2dev(tx->chan), "tx_submit: started %u\n",
 				desc->txd.cookie);
-		dwc_dostart(dwc, desc);
 		list_add_tail(&desc->desc_node, &dwc->active_list);
+		dwc_dostart(dwc, dwc_first_active(dwc));
 	} else {
 		dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
 				desc->txd.cookie);
-- 
1.7.2.2

