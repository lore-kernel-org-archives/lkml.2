Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab0JFJFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:05:52 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:33704 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756973Ab0JFJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:05:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Per Forlin <per.friden@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH 2/3] DMAENGINE: Remove stedma40_set_psize and pre_transfer hook in ste_dma40
Date: Wed, 6 Oct 2010 11:05:28 +0200
Message-ID: <1286355929-31226-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286355929-31226-2-git-send-email-linus.walleij@stericsson.com>
References: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
 <1286355929-31226-2-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.friden@stericsson.com>

Remove obsolete pre_transfer hook in stedma40_chan_cfg. The
intent of this hook is merely to handle burst size
compensation for ux500 variant MMCI. Remove obsolete stedma40_set_psize
since it is only called from pre_transfer. DMAEngine device_control
replaces the functionality of stedma40_set_psize.

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   24 +----------
 drivers/dma/ste_dma40.c                        |   52 +-----------------------
 2 files changed, 2 insertions(+), 74 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 1127af2..660552d 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) ST-Ericsson SA 2007-2010
- * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson
+ * Author: Per Forlin <per.forlin@stericsson.com> for ST-Ericsson
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
  */
@@ -123,10 +123,6 @@ struct stedma40_half_channel_info {
  * @dst_dev_type: Dst device type
  * @src_info: Parameters for dst half channel
  * @dst_info: Parameters for dst half channel
- * @pre_transfer_data: Data to be passed on to the pre_transfer() function.
- * @pre_transfer: Callback used if needed before preparation of transfer.
- * Only called if device is set. size of bytes to transfer
- * (in case of multiple element transfer size is size of the first element).
  *
  *
  * This structure has to be filled by the client drivers.
@@ -140,10 +136,6 @@ struct stedma40_chan_cfg {
 	int					 dst_dev_type;
 	struct stedma40_half_channel_info	 src_info;
 	struct stedma40_half_channel_info	 dst_info;
-	void					*pre_transfer_data;
-	int (*pre_transfer)			(struct dma_chan *chan,
-						 void *data,
-						 int size);
 };
 
 /**
@@ -171,20 +163,6 @@ struct stedma40_platform_data {
 };
 
 /**
- * setdma40_set_psize() - Used for changing the package size of an
- * already configured dma channel.
- *
- * @chan: dmaengine handle
- * @src_psize: new package side for src. (STEDMA40_PSIZE*)
- * @src_psize: new package side for dst. (STEDMA40_PSIZE*)
- *
- * returns 0 on ok, otherwise negative error number.
- */
-int stedma40_set_psize(struct dma_chan *chan,
-		       int src_psize,
-		       int dst_psize);
-
-/**
  * stedma40_filter() - Provides stedma40_chan_cfg to the
  * ste_dma40 dma driver via the dmaengine framework.
  * does some checking of what's provided.
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ad8d6df..662d7e3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) ST-Ericsson SA 2007-2010
- * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson
+ * Author: Per Forlin <per.forlin@stericsson.com> for ST-Ericsson
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
  */
@@ -1593,51 +1593,6 @@ static u32 stedma40_residue(struct dma_chan *chan)
 	return bytes_left;
 }
 
-/* Public DMA functions in addition to the DMA engine framework */
-
-int stedma40_set_psize(struct dma_chan *chan,
-		       int src_psize,
-		       int dst_psize)
-{
-	struct d40_chan *d40c =
-		container_of(chan, struct d40_chan, chan);
-	unsigned long flags;
-
-	spin_lock_irqsave(&d40c->lock, flags);
-
-	if (d40c->log_num != D40_PHY_CHAN) {
-		d40c->log_def.lcsp1 &= ~D40_MEM_LCSP1_SCFG_PSIZE_MASK;
-		d40c->log_def.lcsp3 &= ~D40_MEM_LCSP1_SCFG_PSIZE_MASK;
-		d40c->log_def.lcsp1 |= src_psize <<
-			D40_MEM_LCSP1_SCFG_PSIZE_POS;
-		d40c->log_def.lcsp3 |= dst_psize <<
-			D40_MEM_LCSP1_SCFG_PSIZE_POS;
-		goto out;
-	}
-
-	if (src_psize == STEDMA40_PSIZE_PHY_1)
-		d40c->src_def_cfg &= ~(1 << D40_SREG_CFG_PHY_PEN_POS);
-	else {
-		d40c->src_def_cfg |= 1 << D40_SREG_CFG_PHY_PEN_POS;
-		d40c->src_def_cfg &= ~(STEDMA40_PSIZE_PHY_16 <<
-				       D40_SREG_CFG_PSIZE_POS);
-		d40c->src_def_cfg |= src_psize << D40_SREG_CFG_PSIZE_POS;
-	}
-
-	if (dst_psize == STEDMA40_PSIZE_PHY_1)
-		d40c->dst_def_cfg &= ~(1 << D40_SREG_CFG_PHY_PEN_POS);
-	else {
-		d40c->dst_def_cfg |= 1 << D40_SREG_CFG_PHY_PEN_POS;
-		d40c->dst_def_cfg &= ~(STEDMA40_PSIZE_PHY_16 <<
-				       D40_SREG_CFG_PSIZE_POS);
-		d40c->dst_def_cfg |= dst_psize << D40_SREG_CFG_PSIZE_POS;
-	}
-out:
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return 0;
-}
-EXPORT_SYMBOL(stedma40_set_psize);
-
 struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 						   struct scatterlist *sgl_dst,
 						   struct scatterlist *sgl_src,
@@ -2075,11 +2030,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (d40c->dma_cfg.pre_transfer)
-		d40c->dma_cfg.pre_transfer(chan,
-					   d40c->dma_cfg.pre_transfer_data,
-					   sg_dma_len(sgl));
-
 	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
 
-- 
1.6.3.3

