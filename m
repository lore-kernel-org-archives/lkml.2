Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2LELLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:11:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9529 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2LELL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-64-50bf2bddd8eb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 2/7] ioat: add missing DMA unmap to ioat_dma_self_test()
Date: Wed, 05 Dec 2012 12:10:40 +0100
Message-id: <1354705845-29439-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
References: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jAd272vsDDHbM1rK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZvVsWsxdMEKzY1cPawLiEr4uRk0NCwETiysZvTBC2mMSFe+vZ
	uhi5OIQEFjFKzLj3nRnCWc0kcbq/jxmkik3ASmJi+ypGEFtEQEJi+7M+dpAiZoF3jBJN6/6C
	jRIW8JdYeAyiiEVAVeL55vdgNq+Ah0T7wnVQ6+Qlnt7vYwOxOQU8JR5MncnSxcgBtM1DYtaB
	kAmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBHv8mdQOxpUNFocYBTgYlXh4s/T2
	BQixJpYVV+YeYpTgYFYS4Z0nsz9AiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6Yklq
	dmpqQWoRTJaJg1OqgbFvutGvKXe/P3OTPGL0+l3L/GutNU2Hzm55s3E+z8v/AnsWCu5I8Vji
	I7lq1v353Xs7jr3im2tWnlFTW/ZxcoJrq6ec08mNp48uLFuiZ1FWfnXd9CuVlq+Yzh6pWMH7
	V+iS/hlGo4AHuYfFdHasdj2az+Yxae6bZYJ1syNFTa4Lfy1hOKCm9muDEktxRqKhFnNRcSIA
	uVGg7vQBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ioat_dma_self_test() do DMA unmapping itself and fix handling
of failure cases.

Acked-by: Dan Williams <djbw@fb.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
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

