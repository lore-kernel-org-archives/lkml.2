Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab1LEWtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:49:01 -0500
Received: from mxout1.idt.com ([157.165.5.25]:33295 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab1LEWtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:49:00 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 17:49:00 EST
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH] rapidio/tsi721: switch to dma_zalloc_coherent
Date: Mon,  5 Dec 2011 17:33:45 -0500
Message-Id: <1323124425-24808-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces pair dma_alloc_coherent()+memset() with new dma_zalloc_coherent()
added by Andrew Morton for kernel version 3.2

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---
 drivers/rapidio/devices/tsi721.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 5225930..514c28c 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -851,14 +851,12 @@ static int tsi721_doorbell_init(struct tsi721_device *priv)
 	INIT_WORK(&priv->idb_work, tsi721_db_dpc);
 
 	/* Allocate buffer for inbound doorbells queue */
-	priv->idb_base = dma_alloc_coherent(&priv->pdev->dev,
+	priv->idb_base = dma_zalloc_coherent(&priv->pdev->dev,
 				IDB_QSIZE * TSI721_IDB_ENTRY_SIZE,
 				&priv->idb_dma, GFP_KERNEL);
 	if (!priv->idb_base)
 		return -ENOMEM;
 
-	memset(priv->idb_base, 0, IDB_QSIZE * TSI721_IDB_ENTRY_SIZE);
-
 	dev_dbg(&priv->pdev->dev, "Allocated IDB buffer @ %p (phys = %llx)\n",
 		priv->idb_base, (unsigned long long)priv->idb_dma);
 
@@ -904,7 +902,7 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
 	 */
 
 	/* Allocate space for DMA descriptors */
-	bd_ptr = dma_alloc_coherent(&priv->pdev->dev,
+	bd_ptr = dma_zalloc_coherent(&priv->pdev->dev,
 					bd_num * sizeof(struct tsi721_dma_desc),
 					&bd_phys, GFP_KERNEL);
 	if (!bd_ptr)
@@ -913,8 +911,6 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
 	priv->bdma[chnum].bd_phys = bd_phys;
 	priv->bdma[chnum].bd_base = bd_ptr;
 
-	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
-
 	dev_dbg(&priv->pdev->dev, "DMA descriptors @ %p (phys = %llx)\n",
 		bd_ptr, (unsigned long long)bd_phys);
 
@@ -922,7 +918,7 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
 	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
 					bd_num : TSI721_DMA_MINSTSSZ;
 	sts_size = roundup_pow_of_two(sts_size);
-	sts_ptr = dma_alloc_coherent(&priv->pdev->dev,
+	sts_ptr = dma_zalloc_coherent(&priv->pdev->dev,
 				     sts_size * sizeof(struct tsi721_dma_sts),
 				     &sts_phys, GFP_KERNEL);
 	if (!sts_ptr) {
@@ -938,8 +934,6 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
 	priv->bdma[chnum].sts_base = sts_ptr;
 	priv->bdma[chnum].sts_size = sts_size;
 
-	memset(sts_ptr, 0, sts_size);
-
 	dev_dbg(&priv->pdev->dev,
 		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
 		sts_ptr, (unsigned long long)sts_phys, sts_size);
@@ -1400,7 +1394,7 @@ static int tsi721_open_outb_mbox(struct rio_mport *mport, void *dev_id,
 
 	/* Outbound message descriptor status FIFO allocation */
 	priv->omsg_ring[mbox].sts_size = roundup_pow_of_two(entries + 1);
-	priv->omsg_ring[mbox].sts_base = dma_alloc_coherent(&priv->pdev->dev,
+	priv->omsg_ring[mbox].sts_base = dma_zalloc_coherent(&priv->pdev->dev,
 			priv->omsg_ring[mbox].sts_size *
 						sizeof(struct tsi721_dma_sts),
 			&priv->omsg_ring[mbox].sts_phys, GFP_KERNEL);
@@ -1412,9 +1406,6 @@ static int tsi721_open_outb_mbox(struct rio_mport *mport, void *dev_id,
 		goto out_desc;
 	}
 
-	memset(priv->omsg_ring[mbox].sts_base, 0,
-		entries * sizeof(struct tsi721_dma_sts));
-
 	/*
 	 * Configure Outbound Messaging Engine
 	 */
-- 
1.7.6

