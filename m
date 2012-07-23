Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2GWCEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:04:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54091 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab2GWBmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:39 -0400
Message-Id: <20120723010705.117800782@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 090/108] net: remove skb_orphan_try()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 62b1a8ab9b3660bb820d8dfe23148ed6cda38574 upstream.

Orphaning skb in dev_hard_start_xmit() makes bonding behavior
unfriendly for applications sending big UDP bursts : Once packets
pass the bonding device and come to real device, they might hit a full
qdisc and be dropped. Without orphaning, the sender is automatically
throttled because sk->sk_wmemalloc reaches sk->sk_sndbuf (assuming
sk_sndbuf is not too big)

We could try to defer the orphaning adding another test in
dev_hard_start_xmit(), but all this seems of little gain,
now that BQL tends to make packets more likely to be parked
in Qdisc queues instead of NIC TX ring, in cases where performance
matters.

Reverts commits :
fc6055a5ba31 net: Introduce skb_orphan_try()
87fd308cfc6b net: skb_tx_hash() fix relative to skb_orphan_try()
and removes SKBTX_DRV_NEEDS_SK_REF flag

Reported-and-bisected-by: Jean-Michel Hautbois <jhautbois@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2:
 - Adjust context
 - SKBTX_WIFI_STATUS is not defined]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -213,11 +213,8 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS = 1 << 2,
 
-	/* ensure the originating sk reference is available on driver level */
-	SKBTX_DRV_NEEDS_SK_REF = 1 << 3,
-
 	/* device driver supports TX zero-copy buffers */
-	SKBTX_DEV_ZEROCOPY = 1 << 4,
+	SKBTX_DEV_ZEROCOPY = 1 << 3,
 };
 
 /*
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -681,9 +681,6 @@ static int raw_sendmsg(struct kiocb *ioc
 	if (err < 0)
 		goto free_skb;
 
-	/* to be able to check the received tx sock reference in raw_rcv() */
-	skb_shinfo(skb)->tx_flags |= SKBTX_DRV_NEEDS_SK_REF;
-
 	skb->dev = dev;
 	skb->sk  = sk;
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2079,25 +2079,6 @@ static int dev_gso_segment(struct sk_buf
 	return 0;
 }
 
-/*
- * Try to orphan skb early, right before transmission by the device.
- * We cannot orphan skb if tx timestamp is requested or the sk-reference
- * is needed on driver level for other reasons, e.g. see net/can/raw.c
- */
-static inline void skb_orphan_try(struct sk_buff *skb)
-{
-	struct sock *sk = skb->sk;
-
-	if (sk && !skb_shinfo(skb)->tx_flags) {
-		/* skb_tx_hash() wont be able to get sk.
-		 * We copy sk_hash into skb->rxhash
-		 */
-		if (!skb->rxhash)
-			skb->rxhash = sk->sk_hash;
-		skb_orphan(skb);
-	}
-}
-
 static bool can_checksum_protocol(unsigned long features, __be16 protocol)
 {
 	return ((features & NETIF_F_GEN_CSUM) ||
@@ -2182,8 +2163,6 @@ int dev_hard_start_xmit(struct sk_buff *
 		if (!list_empty(&ptype_all))
 			dev_queue_xmit_nit(skb, dev);
 
-		skb_orphan_try(skb);
-
 		features = netif_skb_features(skb);
 
 		if (vlan_tx_tag_present(skb) &&
@@ -2293,7 +2272,7 @@ u16 __skb_tx_hash(const struct net_devic
 	if (skb->sk && skb->sk->sk_hash)
 		hash = skb->sk->sk_hash;
 	else
-		hash = (__force u16) skb->protocol ^ skb->rxhash;
+		hash = (__force u16) skb->protocol;
 	hash = jhash_1word(hash, hashrnd);
 
 	return (u16) (((u64) hash * qcount) >> 32) + qoffset;
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -380,7 +380,6 @@ static int afiucv_hs_send(struct iucv_me
 			skb_trim(skb, skb->dev->mtu);
 	}
 	skb->protocol = ETH_P_AF_IUCV;
-	skb_shinfo(skb)->tx_flags |= SKBTX_DRV_NEEDS_SK_REF;
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return -ENOMEM;


