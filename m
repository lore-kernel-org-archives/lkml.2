Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2KEKCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:02:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26177 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2KEKB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:59 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-27-50978e961453
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 15/20] dmatest: do DMA unmap for PQ operations
Date: Mon, 05 Nov 2012 11:00:26 +0100
Message-id: <1352109631-3385-16-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd1pfdMDDB5e17C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZZ6d9ZCzo56+4dLmPqYFxKk8XIyeHhICJxNyeN0wQtpjEhXvr
	2boYuTiEBBYxSqz+O5kRwlnNJLFqwT12kCo2ASuJie2rGEFsEQEFic29z1hBipgFnjFKzLjd
	zQySEBawk7i9/DJYEYuAqsSVb4eBxnJw8Ap4SHQut4PYJi/x9H4fG4jNCRRubJjCCmILCbhL
	XO48zjyBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjGCfP5PawbiyweIQowAHoxIP
	70yx6QFCrIllxZW5hxglOJiVRHg5GIBCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZs9UgKEBNIT
	S1KzU1MLUotgskwcnFINjJzr2G132rycW3hu66dbqW5Mt8Qf817PXz51vfZxc+ErPRN7n69f
	JxN4f3dR6NKl09SDLrC0fX75IX6R3H+HD5LbLFi/XfgpkCjK6bph8geZjT0vtz74Po+VM/mj
	gsOGGYFl3xwmv1DyvaN17CeHut3UnQrHXq9dHrcg0EuKRb5wW1r0ppDDt1qUWIozEg21mIuK
	EwGoTJcH9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make driver do DMA unmap for PQ operations.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Havard Skinnemoen <hskinnemoen@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmatest.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index eabb230..3b36890 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -304,18 +304,9 @@ static int dmatest_func(void *data)
 
 	set_user_nice(current, 10);
 
-	/*
-	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
-	 * (except DMA_MEMCPY and DMA_XOR operations)
-	 * dst buffers are freed by ourselves below
-	 */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
-	      | DMA_COMPL_SKIP_DEST_UNMAP;
-
-	if (thread->type == DMA_MEMCPY || thread->type == DMA_XOR)
-		flags |= DMA_COMPL_SKIP_SRC_UNMAP;
-	else
-		flags |= DMA_COMPL_SRC_UNMAP_SINGLE;
+	/* src and dst buffers are freed by ourselves below */
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
+		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 
 	while (!kthread_should_stop()
 	       && !(iterations && total_tests >= iterations)) {
@@ -448,12 +439,11 @@ static int dmatest_func(void *data)
 			continue;
 		}
 
-		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		if (thread->type == DMA_MEMCPY || thread->type == DMA_XOR) {
-			for (i = 0; i < src_cnt; i++)
-				dma_unmap_single(dev->dev, dma_srcs[i], len,
-						 DMA_TO_DEVICE);
-		}
+		/* Unmap by myself */
+		for (i = 0; i < src_cnt; i++)
+			dma_unmap_single(dev->dev, dma_srcs[i], len,
+					 DMA_TO_DEVICE);
+
 		for (i = 0; i < dst_cnt; i++)
 			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,
 					 DMA_BIDIRECTIONAL);
-- 
1.8.0

