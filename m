Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1BQH0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:26:20 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:32797 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab1BQH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:26:06 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 6/7] dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK after xfer finish
Date: Thu, 17 Feb 2011 12:54:56 +0530
Message-ID: <2bcfe620d5ebcda014cdc74efe7bdb417eef2a5f.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
References: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dwc_desc_get checks all descriptors for DMA_CTRL_ACK before allocating them for
transfers. And descriptors are not marked with DMA_CRTL_ACK after transfer
finishes. Thus descriptor once used is not usable again. This patch marks
descriptors with DMA_CRTL_ACK after dma xfer finishes

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c40b89f..01f783d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -196,6 +196,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	dma_async_tx_callback		callback;
 	void				*param;
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
+	struct dw_desc	*child;
 
 	dev_vdbg(chan2dev(&dwc->chan), "descriptor %u complete\n", txd->cookie);
 
@@ -204,6 +205,12 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
 	param = txd->callback_param;
 
 	dwc_sync_desc_for_cpu(dwc, desc);
+
+	/* async_tx_ack */
+	list_for_each_entry(child, &desc->tx_list, desc_node)
+		async_tx_ack(&child->txd);
+	async_tx_ack(&desc->txd);
+
 	list_splice_init(&desc->tx_list, &dwc->free_list);
 	list_move(&desc->desc_node, &dwc->free_list);
 
-- 
1.7.2.2

