Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758Ab2HGXEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:04:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030706Ab2HGWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:40:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Mark Gordon <msg@google.com>,
        Andreas Terzis <aterzis@google.com>, Yuchung Cheng <ycheng@google.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 078/109] netem: add limitation to reordered packets
Date: Tue,  7 Aug 2012 15:35:37 -0700
Message-Id: <20120807222049.950071291@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 960fb66e520a405dde39ff883f17ff2669c13d85 ]

Fix two netem bugs :

1) When a frame was dropped by tfifo_enqueue(), drop counter
   was incremented twice.

2) When reordering is triggered, we enqueue a packet without
   checking queue limit. This can OOM pretty fast when this
   is repeated enough, since skbs are orphaned, no socket limit
   can help in this situation.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mark Gordon <msg@google.com>
Cc: Andreas Terzis <aterzis@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |   42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -329,29 +329,22 @@ static psched_time_t packet_len_2_sched_
 	return PSCHED_NS2TICKS(ticks);
 }
 
-static int tfifo_enqueue(struct sk_buff *nskb, struct Qdisc *sch)
+static void tfifo_enqueue(struct sk_buff *nskb, struct Qdisc *sch)
 {
 	struct sk_buff_head *list = &sch->q;
 	psched_time_t tnext = netem_skb_cb(nskb)->time_to_send;
-	struct sk_buff *skb;
+	struct sk_buff *skb = skb_peek_tail(list);
 
-	if (likely(skb_queue_len(list) < sch->limit)) {
-		skb = skb_peek_tail(list);
-		/* Optimize for add at tail */
-		if (likely(!skb || tnext >= netem_skb_cb(skb)->time_to_send))
-			return qdisc_enqueue_tail(nskb, sch);
-
-		skb_queue_reverse_walk(list, skb) {
-			if (tnext >= netem_skb_cb(skb)->time_to_send)
-				break;
-		}
+	/* Optimize for add at tail */
+	if (likely(!skb || tnext >= netem_skb_cb(skb)->time_to_send))
+		return __skb_queue_tail(list, nskb);
 
-		__skb_queue_after(list, skb, nskb);
-		sch->qstats.backlog += qdisc_pkt_len(nskb);
-		return NET_XMIT_SUCCESS;
+	skb_queue_reverse_walk(list, skb) {
+		if (tnext >= netem_skb_cb(skb)->time_to_send)
+			break;
 	}
 
-	return qdisc_reshape_fail(nskb, sch);
+	__skb_queue_after(list, skb, nskb);
 }
 
 /*
@@ -366,7 +359,6 @@ static int netem_enqueue(struct sk_buff
 	/* We don't fill cb now as skb_unshare() may invalidate it */
 	struct netem_skb_cb *cb;
 	struct sk_buff *skb2;
-	int ret;
 	int count = 1;
 
 	/* Random duplication */
@@ -414,6 +406,11 @@ static int netem_enqueue(struct sk_buff
 		skb->data[net_random() % skb_headlen(skb)] ^= 1<<(net_random() % 8);
 	}
 
+	if (unlikely(skb_queue_len(&sch->q) >= sch->limit))
+		return qdisc_reshape_fail(skb, sch);
+
+	sch->qstats.backlog += qdisc_pkt_len(skb);
+
 	cb = netem_skb_cb(skb);
 	if (q->gap == 0 ||		/* not doing reordering */
 	    q->counter < q->gap - 1 ||	/* inside last reordering gap */
@@ -445,7 +442,7 @@ static int netem_enqueue(struct sk_buff
 
 		cb->time_to_send = now + delay;
 		++q->counter;
-		ret = tfifo_enqueue(skb, sch);
+		tfifo_enqueue(skb, sch);
 	} else {
 		/*
 		 * Do re-ordering by putting one out of N packets at the front
@@ -455,16 +452,7 @@ static int netem_enqueue(struct sk_buff
 		q->counter = 0;
 
 		__skb_queue_head(&sch->q, skb);
-		sch->qstats.backlog += qdisc_pkt_len(skb);
 		sch->qstats.requeues++;
-		ret = NET_XMIT_SUCCESS;
-	}
-
-	if (ret != NET_XMIT_SUCCESS) {
-		if (net_xmit_drop_count(ret)) {
-			sch->qstats.drops++;
-			return ret;
-		}
 	}
 
 	return NET_XMIT_SUCCESS;


