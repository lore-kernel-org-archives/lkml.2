Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2LJLh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:37:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:55421 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab2LJLh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:37:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="255107178"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] dmatest: implement two helpers to unmap dma memory
Date: Mon, 10 Dec 2012 13:37:43 +0200
Message-Id: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unmap_src() and unmap_dst() will be used later as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 3e777d2..b515343 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -236,6 +236,20 @@ static unsigned int min_odd(unsigned int x, unsigned int y)
 	return val % 2 ? val : val - 1;
 }
 
+static inline void unmap_src(struct device *dev, dma_addr_t *addr, size_t len,
+			     unsigned int count)
+{
+	while (count--)
+		dma_unmap_single(dev, addr[count], len, DMA_TO_DEVICE);
+}
+
+static inline void unmap_dst(struct device *dev, dma_addr_t *addr, size_t len,
+			     unsigned int count)
+{
+	while (count--)
+		dma_unmap_single(dev, addr[count], len, DMA_BIDIRECTIONAL);
+}
+
 /*
  * This function repeatedly tests DMA transfers of various lengths and
  * offsets for a given operation type until it is told to exit by
@@ -394,13 +408,8 @@ static int dmatest_func(void *data)
 		}
 
 		if (!tx) {
-			for (i = 0; i < src_cnt; i++)
-				dma_unmap_single(dev->dev, dma_srcs[i], len,
-						 DMA_TO_DEVICE);
-			for (i = 0; i < dst_cnt; i++)
-				dma_unmap_single(dev->dev, dma_dsts[i],
-						 test_buf_size,
-						 DMA_BIDIRECTIONAL);
+			unmap_src(dev->dev, dma_srcs, len, src_cnt);
+			unmap_dst(dev->dev, dma_dsts, test_buf_size, dst_cnt);
 			pr_warning("%s: #%u: prep error with src_off=0x%x "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1,
@@ -454,9 +463,7 @@ static int dmatest_func(void *data)
 		}
 
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		for (i = 0; i < dst_cnt; i++)
-			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,
-					 DMA_BIDIRECTIONAL);
+		unmap_dst(dev->dev, dma_dsts, test_buf_size, dst_cnt);
 
 		error_count = 0;
 
-- 
1.7.10.4

