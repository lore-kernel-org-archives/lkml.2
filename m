Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2JGXgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:36:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38405 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab2JGXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:37 -0400
Message-Id: <20121007225844.949893362@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 074/108] xfrm: Workaround incompatibility of ESN and async  crypto
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 3b59df46a449ec9975146d71318c4777ad086744 ]

ESN for esp is defined in RFC 4303. This RFC assumes that the
sequence number counters are always up to date. However,
this is not true if an async crypto algorithm is employed.

If the sequence number counters are not up to date on sequence
number check, we may incorrectly update the upper 32 bit of
the sequence number. This leads to a DOS.

We workaround this by comparing the upper sequence number,
(used for authentication) with the upper sequence number
computed after the async processing. We drop the packet
if these numbers are different.

To do this, we introduce a recheck function that does this
check in the ESN case.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/xfrm.h     |  3 +++
 net/xfrm/xfrm_input.c  |  2 +-
 net/xfrm/xfrm_replay.c | 15 +++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b203e14..921f627 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -269,6 +269,9 @@ struct xfrm_replay {
 	int	(*check)(struct xfrm_state *x,
 			 struct sk_buff *skb,
 			 __be32 net_seq);
+	int	(*recheck)(struct xfrm_state *x,
+			   struct sk_buff *skb,
+			   __be32 net_seq);
 	void	(*notify)(struct xfrm_state *x, int event);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 54a0dc2..ab2bb42 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -212,7 +212,7 @@ resume:
 		/* only the first xfrm gets the encap type */
 		encap_type = 0;
 
-		if (async && x->repl->check(x, skb, seq)) {
+		if (async && x->repl->recheck(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 2f6d11d..3efb07d 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -420,6 +420,18 @@ err:
 	return -EINVAL;
 }
 
+static int xfrm_replay_recheck_esn(struct xfrm_state *x,
+				   struct sk_buff *skb, __be32 net_seq)
+{
+	if (unlikely(XFRM_SKB_CB(skb)->seq.input.hi !=
+		     htonl(xfrm_replay_seqhi(x, net_seq)))) {
+			x->stats.replay_window++;
+			return -EINVAL;
+	}
+
+	return xfrm_replay_check_esn(x, skb, net_seq);
+}
+
 static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 {
 	unsigned int bitnr, nr, i;
@@ -479,6 +491,7 @@ static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 static struct xfrm_replay xfrm_replay_legacy = {
 	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
+	.recheck	= xfrm_replay_check,
 	.notify		= xfrm_replay_notify,
 	.overflow	= xfrm_replay_overflow,
 };
@@ -486,6 +499,7 @@ static struct xfrm_replay xfrm_replay_legacy = {
 static struct xfrm_replay xfrm_replay_bmp = {
 	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
+	.recheck	= xfrm_replay_check_bmp,
 	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
@@ -493,6 +507,7 @@ static struct xfrm_replay xfrm_replay_bmp = {
 static struct xfrm_replay xfrm_replay_esn = {
 	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
+	.recheck	= xfrm_replay_recheck_esn,
 	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_esn,
 };


