Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2LEL1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:27:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11101 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2LEL0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:26:10 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ca-50bf2f4f0f67
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH resend 1/2] DMA: remove dma_async_memcpy_issue_pending() macro
Date: Wed, 05 Dec 2012 12:21:33 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201212051221.34185.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQV1//f0BBs1T9S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGz1nX2Qv+SVasereGrYHxm2gXIyeHhICJxLuHH9khbDGJC/fW
	s3UxcnEICUxnlFjctpQJwlnKJLG/bzFYFZuAlcTE9lWMILaIgKrElp8dYLawgJ/E71NzwWwW
	oPijpXNYQWxRAQeJzqkTwKYyC3QzSpz+dIAFJMErICjxY/I9MJtZQEui+c0mRghbXmLzmrfM
	EDWWEs8anjNOYOSbhaRlFpKWWUhaFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIDqpn
	0jsYVzVYHGIU4GBU4uGVMN4XIMSaWFZcmXuIUYKDWUmEd57M/gAh3pTEyqrUovz4otKc1OJD
	jNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkGxnBBiytOPsf2rtdZskAz6eQd9v9PK2SF
	79Ue23N+v9qmvwZTpkT+8e+Zc3XVSt8gZxXNbzU2D6an7uKve8gz75zl+9rHBx2M2m8u9J8a
	yhZ1f6eQPs9JUS5OudRlN66JTmj+GPHosOmPHbP+xf0sPmmWFuHTVOH2PVX0wPYt2oz/Nt14
	o9HzPlGJpTgj0VCLuag4EQALZdslJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 1/2] DMA: remove dma_async_memcpy_issue_pending() macro

Just use dma_async_issue_pending() directly.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/carma/carma-fpga-program.c |    2 +-
 drivers/misc/carma/carma-fpga.c         |    2 +-
 include/linux/dmaengine.h               |    2 --
 net/ipv4/tcp.c                          |    6 +++---
 4 files changed, 5 insertions(+), 7 deletions(-)

Index: b/drivers/misc/carma/carma-fpga-program.c
===================================================================
--- a/drivers/misc/carma/carma-fpga-program.c	2012-11-07 16:00:59.680876184 +0100
+++ b/drivers/misc/carma/carma-fpga-program.c	2012-11-07 16:01:05.612876185 +0100
@@ -546,7 +546,7 @@ static noinline int fpga_program_dma(str
 		goto out_dma_unmap;
 	}
 
-	dma_async_memcpy_issue_pending(chan);
+	dma_async_issue_pending(chan);
 
 	/* Set the total byte count */
 	fpga_set_byte_count(priv->regs, priv->bytes);
Index: b/drivers/misc/carma/carma-fpga.c
===================================================================
--- a/drivers/misc/carma/carma-fpga.c	2012-11-07 16:01:17.304876183 +0100
+++ b/drivers/misc/carma/carma-fpga.c	2012-11-07 16:01:23.568876183 +0100
@@ -749,7 +749,7 @@ static irqreturn_t data_irq(int irq, voi
 	submitted = true;
 
 	/* Start the DMA Engine */
-	dma_async_memcpy_issue_pending(priv->chan);
+	dma_async_issue_pending(priv->chan);
 
 out:
 	/* If no DMA was submitted, re-enable interrupts */
Index: b/include/linux/dmaengine.h
===================================================================
--- a/include/linux/dmaengine.h	2012-11-07 16:01:31.720876180 +0100
+++ b/include/linux/dmaengine.h	2012-11-07 16:01:45.072876180 +0100
@@ -902,8 +902,6 @@ static inline void dma_async_issue_pendi
 	chan->device->device_issue_pending(chan);
 }
 
-#define dma_async_memcpy_issue_pending(chan) dma_async_issue_pending(chan)
-
 /**
  * dma_async_is_tx_complete - poll for transaction completion
  * @chan: DMA channel
Index: b/net/ipv4/tcp.c
===================================================================
--- a/net/ipv4/tcp.c	2012-11-07 16:01:52.496876179 +0100
+++ b/net/ipv4/tcp.c	2012-11-07 16:02:13.924876175 +0100
@@ -1410,7 +1410,7 @@ static void tcp_service_net_dma(struct s
 		return;
 
 	last_issued = tp->ucopy.dma_cookie;
-	dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+	dma_async_issue_pending(tp->ucopy.dma_chan);
 
 	do {
 		if (dma_async_memcpy_complete(tp->ucopy.dma_chan,
@@ -1744,7 +1744,7 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 				tcp_service_net_dma(sk, true);
 				tcp_cleanup_rbuf(sk, copied);
 			} else
-				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+				dma_async_issue_pending(tp->ucopy.dma_chan);
 		}
 #endif
 		if (copied >= target) {
@@ -1837,7 +1837,7 @@ do_prequeue:
 					break;
 				}
 
-				dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);
+				dma_async_issue_pending(tp->ucopy.dma_chan);
 
 				if ((offset + used) == skb->len)
 					copied_early = true;
