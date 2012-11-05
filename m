Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2KEKEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:04:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26058 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2KEKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:15 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b7-50978e6829bc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 05/20] dmatest: do DMA unmap for MEMCPY operations
Date: Mon, 05 Nov 2012 11:00:16 +0100
Message-id: <1352109631-3385-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jAd2MvukBBvtnc1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MJzvUCn5yV+w+c5+9gfE6ZxcjB4eEgIlE00GpLkZOIFNM4sK9
	9WxdjFwcQgKLGCX+v7jLDOGsZpI4sbiRCaSKTcBKYmL7KkYQW0RAQWJz7zNWkCJmgWeMEjNu
	dzODJIQFnCQuXV/IDmKzCKhK7HxzhgXE5hVwl1h29xozxDp5iaf3+9hAbE4BD4nGhimsILYQ
	UM3lzuPMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQI9vgzqR2MKxssDjEKcDAq
	8fDOFJseIMSaWFZcmXuIUYKDWUmEl4MBKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMlQEgg
	PbEkNTs1tSC1CCbLxMEp1cAYp3xhfpnn7Lsdbqaz9ytG3lVKilPf73821Uq/Rtmfn5Pty98+
	c6WzJYUTJXWFXefdknGVfzlH8Zi74cOU3U9bnm1Jv9i2cf3TvaeLK91yhJ9Vbm7O7vnW3ST/
	i3Vbt7HHbi2Jl5zHPnNoH25tU9qjuXDh1cIT620Ei2QDWqJMN34TnW3YdF+JpTgj0VCLuag4
	EQAVBG5J9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make driver do DMA unmap for MEMCPY operations.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Havard Skinnemoen <hskinnemoen@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmatest.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 24225f0..22655a7 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -306,10 +306,16 @@ static int dmatest_func(void *data)
 
 	/*
 	 * src buffers are freed by the DMAEngine code with dma_unmap_single()
+	 * (except DMA_MEMCPY operations)
 	 * dst buffers are freed by ourselves below
 	 */
 	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT
-	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
+	      | DMA_COMPL_SKIP_DEST_UNMAP;
+
+	if (thread->type == DMA_MEMCPY)
+		flags |= DMA_COMPL_SKIP_SRC_UNMAP;
+	else
+		flags |= DMA_COMPL_SRC_UNMAP_SINGLE;
 
 	while (!kthread_should_stop()
 	       && !(iterations && total_tests >= iterations)) {
@@ -443,6 +449,9 @@ static int dmatest_func(void *data)
 		}
 
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
+		if (thread->type == DMA_MEMCPY)
+			dma_unmap_single(dev->dev, dma_srcs[0], len,
+					 DMA_TO_DEVICE);
 		for (i = 0; i < dst_cnt; i++)
 			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,
 					 DMA_BIDIRECTIONAL);
-- 
1.8.0

