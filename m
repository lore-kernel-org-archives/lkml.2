Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2KHKHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:07:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19689 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2KHKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:07:22 -0500
X-AuditID: cbfee61b-b7f616d00000319b-06-509b8458bb55
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] DMA: add cpu_relax() to busy-loop in dma_sync_wait()
Date: Thu, 08 Nov 2012 11:02:07 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081102.07811.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd2IltkBBiuvqllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtZvmMRWc4Kh4cquLrYFxNnsXIyeHhICJxJ6f7xghbDGJC/fW
	s3UxcnEICSxilPhz+DULhLOUSeLE+b+sIFVsAlYSE9tXgXWICChIbO59BhTn4BAWcJV4/rcC
	JMwioCox6e4HZhBbVMBBonPqBLChzAITGCV+rT3MApLgFRCU+DH5HpjNLKAl0fxmEyOELS+x
	ec1bZogaS4mj81awTWDkm4WkZRaSlllIWhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CA6pZ9I7GFc1WBxiFOBgVOLh1ZCcHSDEmlhWXJl7iFGCg1lJhHeZM1CINyWxsiq1KD++qDQn
	tfgQozQHi5I4b7NHSoCQQHpiSWp2ampBahFMlomDU6qBsbBqY+n0q567tlzU3GKs+UQ8Md3M
	cu1xrTu1NQtmT5HeujjX6n2g/0veQwInlP9/eJn7wWt1O/fia82ninZMe5vfxJvbHLxjv/50
	7t7npyca/eGf/svq6FarcDPxm+edZ63Us21I2P/+km1h54Lyttgzb0pPlogd6v3SmPV0psoC
	B3W3tE/RzUosxRmJhlrMRcWJAIkV7WslAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] DMA: add cpu_relax() to busy-loop in dma_sync_wait()

Removal of the busy-loop from dma_sync_wait() is not a trivial
task so just add cpu_relax() to the loop for now.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmaengine.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/dma/dmaengine.c
===================================================================
--- a/drivers/dma/dmaengine.c	2012-11-07 16:12:41.776876102 +0100
+++ b/drivers/dma/dmaengine.c	2012-11-07 16:13:04.956876097 +0100
@@ -266,7 +266,10 @@ enum dma_status dma_sync_wait(struct dma
 			pr_err("%s: timeout!\n", __func__);
 			return DMA_ERROR;
 		}
-	} while (status == DMA_IN_PROGRESS);
+		if (status != DMA_IN_PROGRESS)
+			break;
+		cpu_relax();
+	} while (1);
 
 	return status;
 }
