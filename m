Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2LEL0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:26:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11101 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2LEL0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:26:13 -0500
X-AuditID: cbfee61b-b7f616d00000319b-dc-50bf2f51b90d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH resend] async_tx: fix checking of dma_wait_for_async_tx()
 return value
Date: Wed, 05 Dec 2012 12:25:23 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201212051225.24283.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jQd1A/f0BBlt/6Fpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDyseMBc84qm429XC0sB4i6uLkZNDQsBE4uCr46wQtpjEhXvr
	2UBsIYHpjBK3zqt0MXIB2UuZJKbdPM4CkmATsJKY2L6KEcQWEVCV2PKzA8wWFoiQWNnTDWRz
	cLAAxXcuNQYJiwo4SHROncAGModZoJtR4vSnA2BzeAUEJX5MvgdmMwtoSTS/2cQIYctLbF7z
	lhmixlLiwtH5TBMY+WYhaZmFpGUWkpYFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYID
	6pn0DsZVDRaHGAU4GJV4eCWM9wUIsSaWFVfmHmKU4GBWEuGdJ7M/QIg3JbGyKrUoP76oNCe1
	+BCjNAeLkjhvs0dKgJBAemJJanZqakFqEUyWiYNTqoExzeK53ioVvSgOX3Gfrdp9PwuPndbL
	Y52juyTYMS7pQrDwPr+c6uhJDna6vSV6c65G+Il/717AunHpjPlFoRPyY6oNnl+59HJHxfLT
	719zikz6WeZ3eAb/DK0giYkf3RK4GR/IrOErrbi6ef6PoqiV3Jubrv/6kWr9Olx1vbGlg8w3
	9cur12opsRRnJBpqMRcVJwIAh72ZViQCAAA=
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
