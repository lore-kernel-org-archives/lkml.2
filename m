Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab1ESSI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52983 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab1ESSIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:25 -0400
X-Sasl-enc: 25sKYQwIFg8024gWx3I+pIfB6n1pjCs/1KeymmFm2/Wn 1305828504
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180556.996293996@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [28/71] net: ip_expire() must revalidate route
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 64f3b9e203bd06855072e295557dca1485a2ecba upstream.

Commit 4a94445c9a5c (net: Use ip_route_input_noref() in input path)
added a bug in IP defragmentation handling, in case timeout is fired.

When a frame is defragmented, we use last skb dst field when building
final skb. Its dst is valid, since we are in rcu read section.

But if a timeout occurs, we take first queued fragment to build one ICMP
TIME EXCEEDED message. Problem is all queued skb have weak dst pointers,
since we escaped RCU critical section after their queueing. icmp_send()
might dereference a now freed (and possibly reused) part of memory.

Calling skb_dst_drop() and ip_route_input_noref() to revalidate route is
the only possible choice.

Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_fragment.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -223,31 +223,30 @@ static void ip_expire(unsigned long arg)
 
 	if ((qp->q.last_in & INET_FRAG_FIRST_IN) && qp->q.fragments != NULL) {
 		struct sk_buff *head = qp->q.fragments;
+		const struct iphdr *iph;
+		int err;
 
 		rcu_read_lock();
 		head->dev = dev_get_by_index_rcu(net, qp->iif);
 		if (!head->dev)
 			goto out_rcu_unlock;
 
+		/* skb dst is stale, drop it, and perform route lookup again */
+		skb_dst_drop(head);
+		iph = ip_hdr(head);
+		err = ip_route_input_noref(head, iph->daddr, iph->saddr,
+					   iph->tos, head->dev);
+		if (err)
+			goto out_rcu_unlock;
+
 		/*
-		 * Only search router table for the head fragment,
-		 * when defraging timeout at PRE_ROUTING HOOK.
+		 * Only an end host needs to send an ICMP
+		 * "Fragment Reassembly Timeout" message, per RFC792.
 		 */
-		if (qp->user == IP_DEFRAG_CONNTRACK_IN && !skb_dst(head)) {
-			const struct iphdr *iph = ip_hdr(head);
-			int err = ip_route_input(head, iph->daddr, iph->saddr,
-						 iph->tos, head->dev);
-			if (unlikely(err))
-				goto out_rcu_unlock;
-
-			/*
-			 * Only an end host needs to send an ICMP
-			 * "Fragment Reassembly Timeout" message, per RFC792.
-			 */
-			if (skb_rtable(head)->rt_type != RTN_LOCAL)
-				goto out_rcu_unlock;
+		if (qp->user == IP_DEFRAG_CONNTRACK_IN &&
+		    skb_rtable(head)->rt_type != RTN_LOCAL)
+			goto out_rcu_unlock;
 
-		}
 
 		/* Send an ICMP "Fragment Reassembly Timeout" message. */
 		icmp_send(head, ICMP_TIME_EXCEEDED, ICMP_EXC_FRAGTIME, 0);


