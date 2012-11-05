Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2KEKEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:04:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46872 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2KEKB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:57 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b0-50978e859912
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 12/20] dmatest: do DMA unmap for XOR operations
Date: Mon, 05 Nov 2012 11:00:23 +0100
Message-id: <1352109631-3385-13-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t9jAd3WvukBBkuWKFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MRTsushf85qnYNKGHtYFxJ1cXIyeHhICJxNGzH9kgbDGJC/fW
	g9lCAosYJW7/5+5i5AKyVzNJLF2yGCzBJmAlMbF9FSOILSKgILG59xkrSBGzwDNGiRm3u5m7
	GDk4hAXsJZ61hoDUsAioSkzrfckGEuYV8JD4/qEYYpe8xNP7fWAjOYHCjQ1TWCH2uktc7jzO
	PIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MYH8/k9rBuLLB4hCjAAejEg/vTLHp
	AUKsiWXFlbmHGCU4mJVEeDkYgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNT
	UwtSi2CyTBycUg2Mjn3Xazd6MszYs/eRl51OudkP7483hZtkzLfO3L2o5Yzv0bmy2479X672
	5M+ldu625bU26snfLkkuOfxuWrqRxLXnHutYEhafMhd6e4Rr78G/O4JUZ7ce9is4+y03cdFF
	RqcQtYOP8jctPb+HJ2U663RnoZinm39v/2V5+UHL4Ss/lv604P504JcSS3FGoqEWc1FxIgDg
	oiNd8wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make driver do DMA unmap for XOR operations.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Havard Skinnemoen <hskinnemoen@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmatest.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 22655a7..eabb230 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -306,13 +306,13 @@ static int dmatest_func(void *data)
 
 	/*
 	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
-	 * (except DMA_MEMCPY operations)
+	 * (except DMA_MEMCPY and DMA_XOR operations)
 	 * dst buffers are freed by ourselves below
 	 */
 	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
 	      | DMA_COMPL_SKIP_DEST_UNMAP;
 
-	if (thread->type == DMA_MEMCPY)
+	if (thread->type == DMA_MEMCPY || thread->type == DMA_XOR)
 		flags |= DMA_COMPL_SKIP_SRC_UNMAP;
 	else
 		flags |= DMA_COMPL_SRC_UNMAP_SINGLE;
@@ -449,9 +449,11 @@ static int dmatest_func(void *data)
 		}
 
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		if (thread->type == DMA_MEMCPY)
-			dma_unmap_single(dev->dev, dma_srcs[0], len,
-					 DMA_TO_DEVICE);
+		if (thread->type == DMA_MEMCPY || thread->type == DMA_XOR) {
+			for (i = 0; i < src_cnt; i++)
+				dma_unmap_single(dev->dev, dma_srcs[i], len,
+						 DMA_TO_DEVICE);
+		}
 		for (i = 0; i < dst_cnt; i++)
 			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,
 					 DMA_BIDIRECTIONAL);
-- 
1.8.0

