Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab2JKCMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:12:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36262 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932948Ab2JKCMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:12:01 -0400
X-Sasl-enc: umEK9srGuq8pCQk9MUOWaFDatEw9eJnsuo7W+Te5qTJ3 1349921519
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 10/84] xfrm: Workaround incompatibility of ESN and async crypto
Date: Thu, 11 Oct 2012 11:02:54 +0900
Message-Id: <20121011015418.911649944@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xfrm.h     |    3 +++
 net/xfrm/xfrm_input.c  |    2 +-
 net/xfrm/xfrm_replay.c |   15 +++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

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
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -437,6 +437,18 @@ err:
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
@@ -508,6 +520,7 @@ static void xfrm_replay_advance_esn(stru
 static struct xfrm_replay xfrm_replay_legacy = {
 	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
+	.recheck	= xfrm_replay_check,
 	.notify		= xfrm_replay_notify,
 	.overflow	= xfrm_replay_overflow,
 };
@@ -515,6 +528,7 @@ static struct xfrm_replay xfrm_replay_le
 static struct xfrm_replay xfrm_replay_bmp = {
 	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
+	.recheck	= xfrm_replay_check_bmp,
 	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
@@ -522,6 +536,7 @@ static struct xfrm_replay xfrm_replay_bm
 static struct xfrm_replay xfrm_replay_esn = {
 	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
+	.recheck	= xfrm_replay_recheck_esn,
 	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_esn,
 };


