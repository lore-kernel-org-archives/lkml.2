Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab1BPAWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:16 -0500
Received: from kroah.org ([198.145.64.141]:39470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab1BPAWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001439.241165282@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [142/272] net_sched: pfifo_head_drop problem
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 44b8288308ac9da27eab7d7bdbf1375a568805c3 ]

commit 57dbb2d83d100ea (sched: add head drop fifo queue)
introduced pfifo_head_drop, and broke the invariant that
sch->bstats.bytes and sch->bstats.packets are COUNTER (increasing
counters only)

This can break estimators because est_timer() handles unsigned deltas
only. A decreasing counter can then give a huge unsigned delta.

My mid term suggestion would be to change things so that
sch->bstats.bytes and sch->bstats.packets are incremented in dequeue()
only, not at enqueue() time. We also could add drop_bytes/drop_packets
and provide estimations of drop rates.

It would be more sensible anyway for very low speeds, and big bursts.
Right now, if we drop packets, they still are accounted in byte/packets
abolute counters and rate estimators.

Before this mid term change, this patch makes pfifo_head_drop behavior
similar to other qdiscs in case of drops :
Dont decrement sch->bstats.bytes and sch->bstats.packets

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_fifo.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -54,8 +54,6 @@ static int pfifo_tail_enqueue(struct sk_
 
 	/* queue full, remove one skb to fulfill the limit */
 	skb_head = qdisc_dequeue_head(sch);
-	sch->bstats.bytes -= qdisc_pkt_len(skb_head);
-	sch->bstats.packets--;
 	sch->qstats.drops++;
 	kfree_skb(skb_head);
 


