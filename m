Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2KHKHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:07:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2KHKHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:07:34 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-63-509b8457f990
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] DMA: remove dma_async_memcpy_complete() macro
Date: Thu, 08 Nov 2012 11:01:01 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081101.01566.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAd3wltkBBs+fW1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MJw9eMxcsFKg4uHQqcwPjbd4uRk4OCQETiWOfXrBB2GISF+6t
	B7K5OIQEFjFKLLwxgxHCWcok0TmvgRWkik3ASmJi+ypGEFtEQEFic+8zsLiwgJPE3iMTwGwW
	AVWJk/PeMYHYogIOEp1TJ4BNZRaYwCjxa+1hFpAEr4CgxI/J98BsZgEtieY3mxghbHmJzWve
	MkPUWEps3XqeaQIj3ywkLbOQtMxC0rKAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBQ
	PZPawbiyweIQowAHoxIPr4bk7AAh1sSy4srcQ4wSHMxKIrzLnIFCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeZs9UgKEBNITS1KzU1MLUotgskwcnFINjHH+66u8Js6akXFm+S+JvafWrIxawPlI
	JvgM28XnOqG7GMVuzPnTwbz7cO23j/cUvXc/+HFi3+dwKxnfdT0yOTbCNon/8tt+Vstncucz
	i7hNnP9zivfPdRsaHJclH657yeaQ5yZ3zenKTpm60icPU+4GsVyaErKvwu6N0i/FggUvNlaa
	rJnb2KPEUpyRaKjFXFScCAAK6e8OJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 2/2] DMA: remove dma_async_memcpy_complete() macro

Just use dma_async_is_tx_complete() directly.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/dmaengine.h |    5 +----
 net/ipv4/tcp.c            |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: b/include/linux/dmaengine.h
===================================================================
--- a/include/linux/dmaengine.h	2012-11-07 16:04:41.028876159 +0100
+++ b/include/linux/dmaengine.h	2012-11-07 16:05:22.004876153 +0100
@@ -927,16 +927,13 @@ static inline enum dma_status dma_async_
 	return status;
 }
 
-#define dma_async_memcpy_complete(chan, cookie, last, used)\
-	dma_async_is_tx_complete(chan, cookie, last, used)
-
 /**
  * dma_async_is_complete - test a cookie against chan state
  * @cookie: transaction identifier to test status of
  * @last_complete: last know completed transaction
  * @last_used: last cookie value handed out
  *
- * dma_async_is_complete() is used in dma_async_memcpy_complete()
+ * dma_async_is_complete() is used in dma_async_is_tx_complete()
  * the test logic is separated for lightweight testing of multiple cookies
  */
 static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
Index: b/net/ipv4/tcp.c
===================================================================
--- a/net/ipv4/tcp.c	2012-11-07 16:04:11.700876163 +0100
+++ b/net/ipv4/tcp.c	2012-11-07 16:04:26.444876161 +0100
@@ -1413,7 +1413,7 @@ static void tcp_service_net_dma(struct s
 	dma_async_issue_pending(tp->ucopy.dma_chan);
 
 	do {
-		if (dma_async_memcpy_complete(tp->ucopy.dma_chan,
+		if (dma_async_is_tx_complete(tp->ucopy.dma_chan,
 					      last_issued, &done,
 					      &used) == DMA_SUCCESS) {
 			/* Safe to free early-copied skbs now */
