Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2KEKBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46621 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2KEKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e9-50978e5bf221
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 02/20] ioat: add missing DMA unmap to ioat_dma_self_test()
Date: Mon, 05 Nov 2012 11:00:13 +0100
Message-id: <1352109631-3385-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jAd3ovukBBlv7FCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhes3mQoaBSu2XFzP3sA4la+LkZNDQsBEYsHGSewQtpjEhXvr
	2boYuTiEBBYxSnTumMsCkhASWM0kcfVHFIjNJmAlMbF9FSOILSKgILG59xkrSAOzwDNGiRm3
	u5lBEsICXhIPp+5n6mLk4GARUJW4PNsIJMwr4C7xpQ2iV0JAXuLp/T42EJtTwEOisWEKK8Qu
	d4nLnceZJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR7PFn0jsYVzVYHGIU4GBU
	4uH9JDE9QIg1say4MvcQowQHs5IILwcDUIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvs0dKgJBA
	emJJanZqakFqEUyWiYNTqoHRIP/K+0sRGxUZvntMXZ/YOeXkPkkWizhX+396fq6P7xq5L5y6
	7tqbw0t3zW7fd6npOuOhxzv17a8Geq458W6n4+EotQmz+ndNYWv3X/4tZfms3gQ/FaMMe84A
	0fLSs0p8YWtcn5z71OFm3bzw5bQuV9m2BRenW99dcyz4bpGheEqcC+f2PzdFlFiKMxINtZiL
	ihMBFuAy8/QBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ioat_dma_self_test() do DMA unmapping itself and fix handling
of failure cases.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/ioat/dma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 73b2b65..464138a 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -833,14 +833,14 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
-	flags = DMA_COMPL_SRC_UNMAP_SINGLE | DMA_COMPL_DEST_UNMAP_SINGLE |
+	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
 		DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
 						   IOAT_TEST_SIZE, flags);
 	if (!tx) {
 		dev_err(dev, "Self-test prep failed, disabling\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto unmap_dma;
 	}
 
 	async_tx_ack(tx);
@@ -851,7 +851,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 	if (cookie < 0) {
 		dev_err(dev, "Self-test setup failed, disabling\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto unmap_dma;
 	}
 	dma->device_issue_pending(dma_chan);
 
@@ -862,7 +862,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 					!= DMA_SUCCESS) {
 		dev_err(dev, "Self-test copy timed out, disabling\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto unmap_dma;
 	}
 	if (memcmp(src, dest, IOAT_TEST_SIZE)) {
 		dev_err(dev, "Self-test copy failed compare, disabling\n");
@@ -870,6 +870,9 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 		goto free_resources;
 	}
 
+unmap_dma:
+	dma_unmap_single(dev, dma_src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma_dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
 free_resources:
 	dma->device_free_chan_resources(dma_chan);
 out:
-- 
1.8.0

