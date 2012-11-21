Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2KUImx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:42:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:14169 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2KUImw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:42:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,291,1352102400"; 
   d="scan'208";a="170904023"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/2] dw_dmac: make usage of dw_dma_slave optional
Date: Wed, 21 Nov 2012 10:42:35 +0200
Message-Id: <1353487355-9894-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353487355-9894-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353487355-9894-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver requires a custom slave configuration to be present to be able to
make the slave transfers. Nevertheless, in some cases we need only the request
line as an additional information to the generic slave configuration.  The
request line is provided by slave_id parameter of the dma_slave_config
structure. That's why the custom slave configuration could be optional for such
cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 1100fa0..6e20746 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -50,11 +50,12 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
 		struct dw_dma_slave *__slave = (_chan->private);	\
 		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
 		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
+		bool _is_slave = is_slave_xfer(_dwc->direction);	\
 		int _dms = dwc_get_dms(__slave);		\
 		int _sms = dwc_get_sms(__slave);		\
-		u8 _smsize = __slave ? _sconfig->src_maxburst :	\
+		u8 _smsize = _is_slave ? _sconfig->src_maxburst :	\
 			DW_DMA_MSIZE_16;			\
-		u8 _dmsize = __slave ? _sconfig->dst_maxburst :	\
+		u8 _dmsize = _is_slave ? _sconfig->dst_maxburst :	\
 			DW_DMA_MSIZE_16;			\
 								\
 		(DWC_CTLL_DST_MSIZE(_dmsize)			\
@@ -325,7 +326,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	list_splice_init(&desc->tx_list, &dwc->free_list);
 	list_move(&desc->desc_node, &dwc->free_list);
 
-	if (!dwc->chan.private) {
+	if (!is_slave_xfer(dwc->direction)) {
 		struct device *parent = chan2parent(&dwc->chan);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
@@ -806,7 +807,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
-	if (unlikely(!dws || !sg_len))
+	if (unlikely(!is_slave_xfer(direction) || !sg_len))
 		return NULL;
 
 	dwc->direction = direction;
@@ -982,8 +983,8 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 
-	/* Check if it is chan is configured for slave transfers */
-	if (!chan->private)
+	/* Check if chan will be configured for slave transfers */
+	if (!is_slave_xfer(sconfig->direction))
 		return -EINVAL;
 
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
-- 
1.7.10.4

