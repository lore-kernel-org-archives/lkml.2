Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161652Ab1FAIMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:12:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161605Ab1FAIMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:12:09 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:29 2011
Message-Id: <20110601080328.111428174@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:02 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jarek Poplawski <jarkao2@gmail.com>, Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <hawk@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [066/146] sch_sfq: fix peek() implementation
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 07bd8df5df4369487812bf85a237322ff3569b77 ]

Since commit eeaeb068f139 (sch_sfq: allow big packets and be fair),
sfq_peek() can return a different skb that would be normally dequeued by
sfq_dequeue() [ if current slot->allot is negative ]

Use generic qdisc_peek_dequeued() instead of custom implementation, to
get consistent result.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jarek Poplawski <jarkao2@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
CC: Jesper Dangaard Brouer <hawk@diku.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_sfq.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -414,18 +414,6 @@ sfq_enqueue(struct sk_buff *skb, struct
 }
 
 static struct sk_buff *
-sfq_peek(struct Qdisc *sch)
-{
-	struct sfq_sched_data *q = qdisc_priv(sch);
-
-	/* No active slots */
-	if (q->tail == NULL)
-		return NULL;
-
-	return q->slots[q->tail->next].skblist_next;
-}
-
-static struct sk_buff *
 sfq_dequeue(struct Qdisc *sch)
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
@@ -683,7 +671,7 @@ static struct Qdisc_ops sfq_qdisc_ops __
 	.priv_size	=	sizeof(struct sfq_sched_data),
 	.enqueue	=	sfq_enqueue,
 	.dequeue	=	sfq_dequeue,
-	.peek		=	sfq_peek,
+	.peek		=	qdisc_peek_dequeued,
 	.drop		=	sfq_drop,
 	.init		=	sfq_init,
 	.reset		=	sfq_reset,


