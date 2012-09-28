Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032752Ab2I1V46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:56:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031959Ab2I1UWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Aleksandr Kotov <a1k@mail.ru>, Eric Leblond <eric@regit.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 022/218] af_packet: dont emit packet on orig fanout group
Date: Fri, 28 Sep 2012 13:13:59 -0700
Message-Id: <20120928201503.898839664@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Leblond <eric@regit.org>

[ Upstream commit c0de08d04215031d68fa13af36f347a6cfa252ca ]

If a packet is emitted on one socket in one group of fanout sockets,
it is transmitted again. It is thus read again on one of the sockets
of the fanout group. This result in a loop for software which
generate packets when receiving one.
This retransmission is not the intended behavior: a fanout group
must behave like a single socket. The packet should not be
transmitted on a socket if it originates from a socket belonging
to the same fanout group.

This patch fixes the issue by changing the transmission check to
take fanout group info account.

Reported-by: Aleksandr Kotov <a1k@mail.ru>
Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 ++
 net/core/dev.c            |   16 ++++++++++++++--
 net/packet/af_packet.c    |    9 +++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1496,6 +1496,8 @@ struct packet_type {
 	struct sk_buff		**(*gro_receive)(struct sk_buff **head,
 					       struct sk_buff *skb);
 	int			(*gro_complete)(struct sk_buff *skb);
+	bool			(*id_match)(struct packet_type *ptype,
+					    struct sock *sk);
 	void			*af_packet_priv;
 	struct list_head	list;
 };
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1641,6 +1641,19 @@ static inline int deliver_skb(struct sk_
 	return pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 }
 
+static inline bool skb_loop_sk(struct packet_type *ptype, struct sk_buff *skb)
+{
+	if (ptype->af_packet_priv == NULL)
+		return false;
+
+	if (ptype->id_match)
+		return ptype->id_match(ptype, skb->sk);
+	else if ((struct sock *)ptype->af_packet_priv == skb->sk)
+		return true;
+
+	return false;
+}
+
 /*
  *	Support routine. Sends outgoing frames to any network
  *	taps currently in use.
@@ -1658,8 +1671,7 @@ static void dev_queue_xmit_nit(struct sk
 		 * they originated from - MvS (miquels@drinkel.ow.org)
 		 */
 		if ((ptype->dev == dev || !ptype->dev) &&
-		    (ptype->af_packet_priv == NULL ||
-		     (struct sock *)ptype->af_packet_priv != skb->sk)) {
+		    (!skb_loop_sk(ptype, skb))) {
 			if (pt_prev) {
 				deliver_skb(skb2, pt_prev, skb->dev);
 				pt_prev = ptype;
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1280,6 +1280,14 @@ static void __fanout_unlink(struct sock
 	spin_unlock(&f->lock);
 }
 
+bool match_fanout_group(struct packet_type *ptype, struct sock * sk)
+{
+	if (ptype->af_packet_priv == (void*)((struct packet_sock *)sk)->fanout)
+		return true;
+
+	return false;
+}
+
 static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 {
 	struct packet_sock *po = pkt_sk(sk);
@@ -1332,6 +1340,7 @@ static int fanout_add(struct sock *sk, u
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.id_match = match_fanout_group;
 		dev_add_pack(&match->prot_hook);
 		list_add(&match->list, &fanout_list);
 	}


