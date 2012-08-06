Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2HFKkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:40:53 -0400
Received: from [216.32.180.184] ([216.32.180.184]:22057 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755855Ab2HFKks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:40:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>, <vinod.koul@intel.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Qiang Liu <qiang.liu@freescale.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v6 3/8] fsl-dma: add fsl_dma_free_descriptor() to reduce code duplication
Date: Mon, 6 Aug 2012 18:13:23 +0800
Message-ID: <1344248003-9193-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

There are several places where descriptors are freed using identical
code. Put this code into a function to reduce code duplication.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4f2f212..d4720d3 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -427,6 +427,21 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 }

 /**
+ * fsl_dma_free_descriptor - Free descriptor from channel's DMA pool.
+ * @chan : Freescale DMA channel
+ * @desc: descriptor to be freed
+ */
+static void fsl_dma_free_descriptor(struct fsldma_chan *chan,
+		struct fsl_desc_sw *desc)
+{
+	list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+	chan_dbg(chan, "LD %p free\n", desc);
+#endif
+	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
+}
+
+/**
  * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
  * @chan : Freescale DMA channel
  *
@@ -500,13 +515,8 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
 {
 	struct fsl_desc_sw *desc, *_desc;

-	list_for_each_entry_safe(desc, _desc, list, node) {
-		list_del(&desc->node);
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p free\n", desc);
-#endif
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
-	}
+	list_for_each_entry_safe(desc, _desc, list, node)
+		fsl_dma_free_descriptor(chan, desc);
 }

 static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
@@ -514,13 +524,8 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 {
 	struct fsl_desc_sw *desc, *_desc;

-	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
-		list_del(&desc->node);
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p free\n", desc);
-#endif
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
-	}
+	list_for_each_entry_safe_reverse(desc, _desc, list, node)
+		fsl_dma_free_descriptor(chan, desc);
 }

 /**
@@ -855,10 +860,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
 	}

-#ifdef FSL_DMA_LD_DEBUG
-	chan_dbg(chan, "LD %p free\n", desc);
-#endif
-	dma_pool_free(chan->desc_pool, desc, txd->phys);
+	fsl_dma_free_descriptor(chan, desc);
 }

 /**
--
1.7.5.1


