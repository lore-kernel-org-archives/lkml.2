Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2LEL0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:26:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52218 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2LEL0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:26:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-4c-50bf2f50c54a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH resend 2/2] DMA: remove dma_async_memcpy_complete() macro
Date: Wed, 05 Dec 2012 12:22:37 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201212051222.37864.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQd0A/f0BBp9nS1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MJw9eMxcsFKg4uHQqcwPjbd4uRk4OCQETienT7zFD2GISF+6t
	Z+ti5OIQEpjOKLHzxmYWkISQwFImiQv/5EBsNgEriYntqxhBbBEBVYktPzvAbGEBT4mfEz+D
	2SxA8SfvjrGB2KICDhKdUyeADWUW6GaUOP3pANhQXgFBiR+T74HZzAJaEs1vNjFC2PISm9e8
	ZYaosQS67hrTBEa+WUhaZiFpmYWkZQEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4JB6
	JrWDcWWDxSFGAQ5GJR7eLL19AUKsiWXFlbmHGCU4mJVEeOfJ7A8Q4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkztvskRIgJJCeWJKanZpakFoEk2Xi4JRqYJz6Tc2Hw29C0ESZG1cWuMsaH1rZdqW8
	vFh0Te+z2H9WVYvmlH/NfXsqeVZfy4zqOU7PvtZcSJdj33Yms9NDuLNrv8Xz9vMimxKWcL6Q
	fbOUYenE+Z5zD+p/C9m779RC9k0CL0VEOvevvLZo8RyFkG0HGB0uqbjJdFn9i7Fvs//VPnPh
	L1mrCV+UWIozEg21mIuKEwEcwgwmJQIAAA==
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
