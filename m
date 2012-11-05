Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2KEKFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:05:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26058 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2KEKBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:14 -0500
X-AuditID: cbfee61b-b7f616d00000319b-18-50978e63297f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 04/20] carma-fpga: pass correct flags to
 ->device_prep_dma_memcpy()
Date: Mon, 05 Nov 2012 11:00:15 +0100
Message-id: <1352109631-3385-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd2UvukBBrvfslpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MzdP/sxUc5qpo/viItYHxBkcXIyeHhICJxOuTh5ggbDGJC/fW
	s3UxcnEICSxilDgxYxk7hLOaSeLtg/8sIFVsAlYSE9tXMYLYIgIKEpt7n7GCFDELPGOUmHG7
	mxkkISwQKrGhewVQEQcHi4CqxMM5YSBhXgF3iUctDawQ2+Qlnt7vYwOxOQU8JBobpoDFhYBq
	LnceZ57AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRrDPn0nvYFzVYHGIUYCDUYmH
	95PE9AAh1sSy4srcQ4wSHMxKIrwcDEAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJ
	JanZqakFqUUwWSYOTqkGxtTz/N2/Vup/NnoYdv3JF720FRw1Yjq8u8v7Lgm+eXj+coHrYbad
	i2euftx/I//nmgOnl1+scRRY23p+40WzQpYa2w9/eqZqr8ldX37QNmrClqnKa722f2ZY/+yF
	svm7R5Fn53WzxPYcckh8vGiyzZTZnKduZp7+LGG8SzWDofzg7KD+K+w/ky2VWIozEg21mIuK
	EwEAGQOX9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA unmapping is handled by a driver so tell fsldma.c driver
(which is the DMA engine driver used by carma-fpga) to skip
unmapping destination and source buffers.

Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/carma/carma-fpga.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 8835eab..6b43f8c 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -631,6 +631,8 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 	dma_addr_t dst, src;
+	unsigned long dma_flags = DMA_COMPL_SKIP_DEST_UNMAP |
+				  DMA_COMPL_SKIP_SRC_UNMAP;
 
 	dst_sg = buf->vb.sglist;
 	dst_nents = buf->vb.sglen;
@@ -666,7 +668,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	src = SYS_FPGA_BLOCK;
 	tx = chan->device->device_prep_dma_memcpy(chan, dst, src,
 						  REG_BLOCK_SIZE,
-						  0);
+						  dma_flags);
 	if (!tx) {
 		dev_err(priv->dev, "unable to prep SYS-FPGA DMA\n");
 		return -ENOMEM;
-- 
1.8.0

