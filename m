Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2LJLh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:37:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:55421 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab2LJLh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="255107180"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] dmatest: check for dma mapping error
Date: Mon, 10 Dec 2012 13:37:44 +0200
Message-Id: <1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get a warning if CONFIG_DMA_API_DEBUG=y

[   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
[   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index b515343..7be60f1 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -378,15 +378,35 @@ static int dmatest_func(void *data)
 
 			dma_srcs[i] = dma_map_single(dev->dev, buf, len,
 						     DMA_TO_DEVICE);
+			ret = dma_mapping_error(dev->dev, dma_srcs[i]);
+			if (ret) {
+				unmap_src(dev->dev, dma_srcs, len, i);
+				pr_warn("%s: #%u: mapping error %d with "
+					"src_off=0x%x len=0x%x\n",
+					thread_name, total_tests - 1, ret,
+					src_off, len);
+				failed_tests++;
+				continue;
+			}
 		}
 		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
 		for (i = 0; i < dst_cnt; i++) {
 			dma_dsts[i] = dma_map_single(dev->dev, thread->dsts[i],
 						     test_buf_size,
 						     DMA_BIDIRECTIONAL);
+			ret = dma_mapping_error(dev->dev, dma_dsts[i]);
+			if (ret) {
+				unmap_src(dev->dev, dma_srcs, len, src_cnt);
+				unmap_dst(dev->dev, dma_dsts, test_buf_size, i);
+				pr_warn("%s: #%u: mapping error %d with "
+					"dst_off=0x%x len=0x%x\n",
+					thread_name, total_tests - 1, ret,
+					dst_off, test_buf_size);
+				failed_tests++;
+				continue;
+			}
 		}
 
-
 		if (thread->type == DMA_MEMCPY)
 			tx = dev->device_prep_dma_memcpy(chan,
 							 dma_dsts[0] + dst_off,
-- 
1.7.10.4

