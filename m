Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406Ab1FAIMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:12:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161609Ab1FAIL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:58 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:26 2011
Message-Id: <20110601080325.911778067@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:00 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>, Jarek Poplawski <jarkao2@gmail.com>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [064/146] sch_sfq: avoid giving spurious NET_XMIT_CN signals
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 8efa885406359af300d46910642b50ca82c0fe47 ]

While chasing a possible net_sched bug, I found that IP fragments have
litle chance to pass a congestioned SFQ qdisc :

- Say SFQ qdisc is full because one flow is non responsive.
- ip_fragment() wants to send two fragments belonging to an idle flow.
- sfq_enqueue() queues first packet, but see queue limit reached :
- sfq_enqueue() drops one packet from 'big consumer', and returns
NET_XMIT_CN.
- ip_fragment() cancel remaining fragments.

This patch restores fairness, making sure we return NET_XMIT_CN only if
we dropped a packet from the same flow.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Patrick McHardy <kaber@trash.net>
CC: Jarek Poplawski <jarkao2@gmail.com>
CC: Jamal Hadi Salim <hadi@cyberus.ca>
CC: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/sch_sfq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -361,7 +361,7 @@ sfq_enqueue(struct sk_buff *skb, struct
 {
 	struct sfq_sched_data *q = qdisc_priv(sch);
 	unsigned int hash;
-	sfq_index x;
+	sfq_index x, qlen;
 	struct sfq_slot *slot;
 	int uninitialized_var(ret);
 
@@ -405,8 +405,12 @@ sfq_enqueue(struct sk_buff *skb, struct
 	if (++sch->q.qlen <= q->limit)
 		return NET_XMIT_SUCCESS;
 
+	qlen = slot->qlen;
 	sfq_drop(sch);
-	return NET_XMIT_CN;
+	/* Return Congestion Notification only if we dropped a packet
+	 * from this flow.
+	 */
+	return (qlen != slot->qlen) ? NET_XMIT_CN : NET_XMIT_SUCCESS;
 }
 
 static struct sk_buff *


