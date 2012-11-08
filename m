Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2KHKHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:07:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19689 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2KHKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:07:23 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0a-509b845959c9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] async_tx: fix checking of dma_wait_for_async_tx() return value
Date: Thu, 08 Nov 2012 11:03:16 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081103.16707.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd3IltkBBhs2illc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDyseMBc84qm429XC0sB4i6uLkZNDQsBE4uCFa6wQtpjEhXvr
	2boYuTiEBBYxSky4t4cVwlnKJPG3Zw87SBWbgJXExPZVjCC2iICCxObeZ2DdwgL+ErenrwWq
	4eBgEVCVmNFlBxIWFXCQ6Jw6AWwos8AERolfaw+zgCR4BQQlfky+B2YzC2hJNL/ZxAhhy0ts
	XvOWGaLGUuLVovdMExj5ZiFpmYWkZRaSlgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcx
	gkPqmfQOxlUNFocYBTgYlXh4NSRnBwixJpYVV+YeYpTgYFYS4V3mDBTiTUmsrEotyo8vKs1J
	LT7EKM3BoiTO2+yREiAkkJ5YkpqdmlqQWgSTZeLglGpgTJ7QIuJoyXI/LqH2mJXallqmRXYb
	l7xkNdZ1vut1NN6uzETMS3WDf/Mx7b+mEY/8Gie5Ptn+3+zy55KP8+fYfwly2Kbm/PycPbPt
	Q9msrzdzzyw10lAu4uP2Mt1wWFR36/QN/XE7E8K66mfOdH3isnxLwf2Xos8Tmv6Itmk6yX01
	lltwt3qmEktxRqKhFnNRcSIAhYApCSUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] async_tx: fix checking of dma_wait_for_async_tx() return value

dma_wait_for_async_tx() can also return DMA_PAUSED (which
should be considered as error).

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_tx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: b/crypto/async_tx/async_tx.c
===================================================================
--- a/crypto/async_tx/async_tx.c	2012-11-07 16:30:47.940875970 +0100
+++ b/crypto/async_tx/async_tx.c	2012-11-07 16:31:34.888875965 +0100
@@ -128,8 +128,8 @@ async_tx_channel_switch(struct dma_async
 		}
 		device->device_issue_pending(chan);
 	} else {
-		if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
-			panic("%s: DMA_ERROR waiting for depend_tx\n",
+		if (dma_wait_for_async_tx(depend_tx) != DMA_SUCCESS)
+			panic("%s: DMA error waiting for depend_tx\n",
 			      __func__);
 		tx->tx_submit(tx);
 	}
@@ -280,8 +280,9 @@ void async_tx_quiesce(struct dma_async_t
 		 * we are referring to the correct operation
 		 */
 		BUG_ON(async_tx_test_ack(*tx));
-		if (dma_wait_for_async_tx(*tx) == DMA_ERROR)
-			panic("DMA_ERROR waiting for transaction\n");
+		if (dma_wait_for_async_tx(*tx) != DMA_SUCCESS)
+			panic("%s: DMA error waiting for transaction\n",
+			      __func__);
 		async_tx_ack(*tx);
 		*tx = NULL;
 	}
