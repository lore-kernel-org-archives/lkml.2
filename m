Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946584Ab2CPX4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:56:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032126Ab2CPXi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:28 -0400
Message-Id: <20120316233448.874803604@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben McKeegan <ben@netservers.co.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/38] ppp: fix ppp_mp_reconstruct bad seq errors
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben McKeegan <ben@netservers.co.uk>

[ Upstream commit 8a49ad6e89feb5015e77ce6efeb2678947117e20 ]

This patch fixes a (mostly cosmetic) bug introduced by the patch
'ppp: Use SKB queue abstraction interfaces in fragment processing'
found here: http://www.spinics.net/lists/netdev/msg153312.html

The above patch rewrote and moved the code responsible for cleaning
up discarded fragments but the new code does not catch every case
where this is necessary.  This results in some discarded fragments
remaining in the queue, and triggering a 'bad seq' error on the
subsequent call to ppp_mp_reconstruct.  Fragments are discarded
whenever other fragments of the same frame have been lost.
This can generate a lot of unwanted and misleading log messages.

This patch also adds additional detail to the debug logging to
make it clearer which fragments were lost and which other fragments
were discarded as a result of losses. (Run pppd with 'kdebug 1'
option to enable debug logging.)

Signed-off-by: Ben McKeegan <ben@netservers.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp_generic.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -2019,14 +2019,22 @@ ppp_mp_reconstruct(struct ppp *ppp)
 			continue;
 		}
 		if (PPP_MP_CB(p)->sequence != seq) {
+			u32 oldseq;
 			/* Fragment `seq' is missing.  If it is after
 			   minseq, it might arrive later, so stop here. */
 			if (seq_after(seq, minseq))
 				break;
 			/* Fragment `seq' is lost, keep going. */
 			lost = 1;
+			oldseq = seq;
 			seq = seq_before(minseq, PPP_MP_CB(p)->sequence)?
 				minseq + 1: PPP_MP_CB(p)->sequence;
+
+			if (ppp->debug & 1)
+				netdev_printk(KERN_DEBUG, ppp->dev,
+					      "lost frag %u..%u\n",
+					      oldseq, seq-1);
+
 			goto again;
 		}
 
@@ -2071,6 +2079,10 @@ ppp_mp_reconstruct(struct ppp *ppp)
 			struct sk_buff *tmp2;
 
 			skb_queue_reverse_walk_from_safe(list, p, tmp2) {
+				if (ppp->debug & 1)
+					netdev_printk(KERN_DEBUG, ppp->dev,
+						      "discarding frag %u\n",
+						      PPP_MP_CB(p)->sequence);
 				__skb_unlink(p, list);
 				kfree_skb(p);
 			}
@@ -2086,6 +2098,17 @@ ppp_mp_reconstruct(struct ppp *ppp)
 		/* If we have discarded any fragments,
 		   signal a receive error. */
 		if (PPP_MP_CB(head)->sequence != ppp->nextseq) {
+			skb_queue_walk_safe(list, p, tmp) {
+				if (p == head)
+					break;
+				if (ppp->debug & 1)
+					netdev_printk(KERN_DEBUG, ppp->dev,
+						      "discarding frag %u\n",
+						      PPP_MP_CB(p)->sequence);
+				__skb_unlink(p, list);
+				kfree_skb(p);
+			}
+
 			if (ppp->debug & 1)
 				netdev_printk(KERN_DEBUG, ppp->dev,
 					      "  missed pkts %u..%u\n",


