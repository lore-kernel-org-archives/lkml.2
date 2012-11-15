Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767998Ab2KOOVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:21:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:9795 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767850Ab2KOOVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:21:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,257,1352102400"; 
   d="scan'208";a="168749708"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
Date: Thu, 15 Nov 2012 16:20:48 +0200
Message-Id: <1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently for the slave transfers the driver requires a custom slave
configuration to be present. Nevertheless, in some cases we need only the
request line as an additional information to the generic slave configuration.
The request line is provided by slave_id parameter of the dma_slave_config
structure. That's why the custom slave configuration could be optional for such
cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 771aa15..baebf81 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -41,6 +41,11 @@ static inline bool is_slave_direction(enum dma_transfer_direction direction)
 	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
 }
 
+static inline bool dwc_is_slave(struct dma_slave_config *sconfig)
+{
+	return is_slave_direction(sconfig->direction);
+}
+
 static inline unsigned int dwc_get_dms(struct dw_dma_slave *slave)
 {
 	return slave ? slave->dst_master : 0;
@@ -55,11 +60,12 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
 		struct dw_dma_slave *__slave = (_chan->private);	\
 		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
 		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
+		bool _is_slave = dwc_is_slave(_sconfig);	\
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
@@ -330,7 +336,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	list_splice_init(&desc->tx_list, &dwc->free_list);
 	list_move(&desc->desc_node, &dwc->free_list);
 
-	if (!dwc->chan.private) {
+	if (!dwc_is_slave(&dwc->dma_sconfig)) {
 		struct device *parent = chan2parent(&dwc->chan);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
@@ -809,9 +815,11 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
-	if (unlikely(!dws || !sg_len))
+	if (unlikely(!is_slave_direction(direction) || !sg_len))
 		return NULL;
 
+	sconfig->direction = direction;
+
 	prev = first = NULL;
 
 	switch (direction) {
@@ -983,8 +991,8 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 
-	/* Check if it is chan is configured for slave transfers */
-	if (!chan->private)
+	/* Check if chan will be configured for slave transfers */
+	if (!dwc_is_slave(sconfig))
 		return -EINVAL;
 
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
@@ -1344,6 +1352,8 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	if (unlikely(!is_slave_direction(direction)))
 		goto out_err;
 
+	sconfig->direction = direction;
+
 	if (direction == DMA_MEM_TO_DEV)
 		reg_width = __ffs(sconfig->dst_addr_width);
 	else
@@ -1718,6 +1728,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
 		dwc->dw = dw;
+		dwc->dma_sconfig.direction = DMA_TRANS_NONE;
 
 		/* hardware configuration */
 		if (autocfg) {
-- 
1.7.10.4

