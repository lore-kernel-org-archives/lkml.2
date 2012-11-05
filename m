Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2KEKBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46779 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2KEKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:26 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-39-50978e75842c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 08/20] ioat3: add missing DMA unmap to ioat_xor_val_self_test()
Date: Mon, 05 Nov 2012 11:00:19 +0100
Message-id: <1352109631-3385-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd3SvukBBrMfyFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MdbPnshS8t6l4cGU3ewPjEYMuRk4OCQETiZ0rzzBC2GISF+6t
	Z+ti5OIQEljEKHF80UpGCGc1k8Ss01PYQKrYBKwkJravAusQEVCQ2Nz7jBWkiFngGaPEjNvd
	zCAJYQF/ibfbZrOC2CwCqhJ3pk8Fa+AVcJf4d3gFK8Q6eYmn9/vAhnIKeEg0NkwBiwsB1Vzu
	PM48gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYxgrz+T2sG4ssHiEKMAB6MSD+9M
	sekBQqyJZcWVuYcYJTiYlUR4ORiAQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tS
	s1NTC1KLYLJMHJxSDYwmvOZ8vNOuVrVErc2J3OIiWNpttqVv7+do5eunDs+Rdv7mILV9z+HI
	CKdAo8WeWyzvnHXdcCwyK99Q/fQMnXkWl+TWving+3Xrpoj3UQ7LCi1Vo/Qn2fbnO/cXzeaZ
	f0SPOTDXaPrpC0UcTKxZ3t6HE1/vunT4cvu2+saauobwPSeWqEzVnqfEUpyRaKjFXFScCACw
	Vkk49gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ioat_xor_val_self_test() do DMA unmapping itself and fix handling
of failure cases.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/ioat/dma_v3.c | 76 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index f7f1dc6..6456f7d 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -863,6 +863,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	unsigned long tmo;
 	struct device *dev = &device->pdev->dev;
 	struct dma_device *dma = &device->common;
+	u8 op = 0;
 
 	dev_dbg(dev, "%s\n", __func__);
 
@@ -908,18 +909,22 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	}
 
 	/* test xor */
+	op = IOAT_OP_XOR;
+
 	dest_dma = dma_map_page(dev, dest, 0, PAGE_SIZE, DMA_FROM_DEVICE);
 	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
 		dma_srcs[i] = dma_map_page(dev, xor_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
 				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
-				      DMA_PREP_INTERRUPT);
+				      DMA_PREP_INTERRUPT |
+				      DMA_COMPL_SKIP_SRC_UNMAP |
+				      DMA_COMPL_SKIP_DEST_UNMAP);
 
 	if (!tx) {
 		dev_err(dev, "Self-test xor prep failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
 	async_tx_ack(tx);
@@ -930,7 +935,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (cookie < 0) {
 		dev_err(dev, "Self-test xor setup failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 	dma->device_issue_pending(dma_chan);
 
@@ -939,9 +944,13 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test xor timed out\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
+	dma_unmap_page(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
+		dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE, DMA_TO_DEVICE);
+
 	dma_sync_single_for_cpu(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 	for (i = 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
 		u32 *ptr = page_address(dest);
@@ -957,6 +966,8 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (!dma_has_cap(DMA_XOR_VAL, dma_chan->device->cap_mask))
 		goto free_resources;
 
+	op = IOAT_OP_XOR_VAL;
+
 	/* validate the sources with the destintation page */
 	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
 		xor_val_srcs[i] = xor_srcs[i];
@@ -969,11 +980,13 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT);
+					  &xor_val_result, DMA_PREP_INTERRUPT |
+					  DMA_COMPL_SKIP_SRC_UNMAP |
+					  DMA_COMPL_SKIP_DEST_UNMAP);
 	if (!tx) {
 		dev_err(dev, "Self-test zero prep failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
 	async_tx_ack(tx);
@@ -984,7 +997,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (cookie < 0) {
 		dev_err(dev, "Self-test zero setup failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 	dma->device_issue_pending(dma_chan);
 
@@ -993,9 +1006,12 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test validate timed out\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
+	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+		dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE, DMA_TO_DEVICE);
+
 	if (xor_val_result != 0) {
 		dev_err(dev, "Self-test validate failed compare\n");
 		err = -ENODEV;
@@ -1007,14 +1023,18 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 		goto free_resources;
 
 	/* test memset */
+	op = IOAT_OP_FILL;
+
 	dma_addr = dma_map_page(dev, dest, 0,
 			PAGE_SIZE, DMA_FROM_DEVICE);
 	tx = dma->device_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
-					 DMA_PREP_INTERRUPT);
+					 DMA_PREP_INTERRUPT |
+					 DMA_COMPL_SKIP_SRC_UNMAP |
+					 DMA_COMPL_SKIP_DEST_UNMAP);
 	if (!tx) {
 		dev_err(dev, "Self-test memset prep failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
 	async_tx_ack(tx);
@@ -1025,7 +1045,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (cookie < 0) {
 		dev_err(dev, "Self-test memset setup failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 	dma->device_issue_pending(dma_chan);
 
@@ -1034,9 +1054,11 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test memset timed out\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
+	dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+
 	for (i = 0; i < PAGE_SIZE/sizeof(u32); i++) {
 		u32 *ptr = page_address(dest);
 		if (ptr[i]) {
@@ -1047,17 +1069,21 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	}
 
 	/* test for non-zero parity sum */
+	op = IOAT_OP_XOR_VAL;
+
 	xor_val_result = 0;
 	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
 		dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT);
+					  &xor_val_result, DMA_PREP_INTERRUPT |
+					  DMA_COMPL_SKIP_SRC_UNMAP |
+					  DMA_COMPL_SKIP_DEST_UNMAP);
 	if (!tx) {
 		dev_err(dev, "Self-test 2nd zero prep failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
 	async_tx_ack(tx);
@@ -1068,7 +1094,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (cookie < 0) {
 		dev_err(dev, "Self-test  2nd zero setup failed\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 	dma->device_issue_pending(dma_chan);
 
@@ -1077,15 +1103,31 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
 		dev_err(dev, "Self-test 2nd validate timed out\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
 	if (xor_val_result != SUM_CHECK_P_RESULT) {
 		dev_err(dev, "Self-test validate failed compare\n");
 		err = -ENODEV;
-		goto free_resources;
+		goto dma_unmap;
 	}
 
+	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+		dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE, DMA_TO_DEVICE);
+
+	goto free_resources;
+dma_unmap:
+	if (op == IOAT_OP_XOR) {
+		dma_unmap_page(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
+			dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
+				       DMA_TO_DEVICE);
+	} else if (op == IOAT_OP_XOR_VAL) {
+		for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+			dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
+				       DMA_TO_DEVICE);
+	} else if (op == IOAT_OP_FILL)
+		dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
 free_resources:
 	dma->device_free_chan_resources(dma_chan);
 out:
-- 
1.8.0

