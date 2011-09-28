Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1I1WrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933060Ab1I1WrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.530652937@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [182/244] net_sched: prio: use qdisc_dequeue_peeked
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3557619f0f6f7496ed453d4825e24958ab1884e0 ]

commit 07bd8df5df4369487812bf85a237322ff3569b77
(sch_sfq: fix peek() implementation) changed sfq to use generic
peek helper.

This makes HFSC complain about a non-work-conserving child qdisc, if
prio with sfq child is used within hfsc:

hfsc peeks into prio qdisc, which will then peek into sfq.
returned skb is stashed in sch->gso_skb.

Next, hfsc tries to dequeue from prio, but prio will call sfq dequeue
directly, which may return NULL instead of previously peeked-at skb.

Have prio call qdisc_dequeue_peeked, so sfq->dequeue() is
not called in this case.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_prio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -112,7 +112,7 @@ static struct sk_buff *prio_dequeue(stru
 
 	for (prio = 0; prio < q->bands; prio++) {
 		struct Qdisc *qdisc = q->queues[prio];
-		struct sk_buff *skb = qdisc->dequeue(qdisc);
+		struct sk_buff *skb = qdisc_dequeue_peeked(qdisc);
 		if (skb) {
 			qdisc_bstats_update(sch, skb);
 			sch->q.qlen--;


