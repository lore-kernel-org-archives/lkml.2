Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2HFKjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:39:02 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:45829
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754923Ab2HFKi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:38:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>, <vinod.koul@intel.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Qiang Liu <qiang.liu@freescale.com>, Li Yang <leoli@freescale.com>
Subject: [PATCH v6 2/8] fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
Date: Mon, 6 Aug 2012 18:12:46 +0800
Message-ID: <1344247966-9156-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

Delete attribute DMA_INTERRUPT because fsl-dma doesn't support this function,
exception will be thrown if talitos is used to offload xor at the same time.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8f84761..4f2f212 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -543,35 +543,6 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 }

 static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
-{
-	struct fsldma_chan *chan;
-	struct fsl_desc_sw *new;
-
-	if (!dchan)
-		return NULL;
-
-	chan = to_fsl_chan(dchan);
-
-	new = fsl_dma_alloc_descriptor(chan);
-	if (!new) {
-		chan_err(chan, "%s\n", msg_ld_oom);
-		return NULL;
-	}
-
-	new->async_tx.cookie = -EBUSY;
-	new->async_tx.flags = flags;
-
-	/* Insert the link descriptor to the LD ring */
-	list_add_tail(&new->node, &new->tx_list);
-
-	/* Set End-of-link to the last link descriptor of new list */
-	set_ld_eol(chan, new);
-
-	return &new->async_tx;
-}
-
-static struct dma_async_tx_descriptor *
 fsl_dma_prep_memcpy(struct dma_chan *dchan,
 	dma_addr_t dma_dst, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -1352,12 +1323,10 @@ static int __devinit fsldma_of_probe(struct platform_device *op)
 	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);

 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
-	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	dma_cap_set(DMA_SG, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
-	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
 	fdev->common.device_tx_status = fsl_tx_status;
--
1.7.5.1


