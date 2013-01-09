Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3AIV7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:59:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:41109 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab3AIUgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dmitry Kravkov <dmitry@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 001/123] net: fix a race in gro_cell_poll()
Date: Wed,  9 Jan 2013 12:34:00 -0800
Message-Id: <20130109201458.583751331@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8e8f97c11d5ff3cc47d85b97c7c35e443dcf490 ]

Dmitry Kravkov reported packet drops for GRE packets since GRO support
was added.

There is a race in gro_cell_poll() because we call napi_complete()
without any synchronization with a concurrent gro_cells_receive()

Once bug was triggered, we queued packets but did not schedule NAPI
poll.

We can fix this issue using the spinlock protected the napi_skbs queue,
as we have to hold it to perform skb dequeue anyway.

As we open-code skb_dequeue(), we no longer need to mask IRQS, as both
producer and consumer run under BH context.

Bug added in commit c9e6bc644e (net: add gro_cells infrastructure)

Reported-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/gro_cells.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/include/net/gro_cells.h
+++ b/include/net/gro_cells.h
@@ -17,7 +17,6 @@ struct gro_cells {
 
 static inline void gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
 {
-	unsigned long flags;
 	struct gro_cell *cell = gcells->cells;
 	struct net_device *dev = skb->dev;
 
@@ -35,32 +34,37 @@ static inline void gro_cells_receive(str
 		return;
 	}
 
-	spin_lock_irqsave(&cell->napi_skbs.lock, flags);
+	/* We run in BH context */
+	spin_lock(&cell->napi_skbs.lock);
 
 	__skb_queue_tail(&cell->napi_skbs, skb);
 	if (skb_queue_len(&cell->napi_skbs) == 1)
 		napi_schedule(&cell->napi);
 
-	spin_unlock_irqrestore(&cell->napi_skbs.lock, flags);
+	spin_unlock(&cell->napi_skbs.lock);
 }
 
+/* called unser BH context */
 static inline int gro_cell_poll(struct napi_struct *napi, int budget)
 {
 	struct gro_cell *cell = container_of(napi, struct gro_cell, napi);
 	struct sk_buff *skb;
 	int work_done = 0;
 
+	spin_lock(&cell->napi_skbs.lock);
 	while (work_done < budget) {
-		skb = skb_dequeue(&cell->napi_skbs);
+		skb = __skb_dequeue(&cell->napi_skbs);
 		if (!skb)
 			break;
-
+		spin_unlock(&cell->napi_skbs.lock);
 		napi_gro_receive(napi, skb);
 		work_done++;
+		spin_lock(&cell->napi_skbs.lock);
 	}
 
 	if (work_done < budget)
 		napi_complete(napi);
+	spin_unlock(&cell->napi_skbs.lock);
 	return work_done;
 }
 


