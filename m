Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab0G3Shh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:37:37 -0400
Received: from kroah.org ([198.145.64.141]:57965 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759781Ab0G3Ryi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:36 2010
Message-Id: <20100730175136.471274361@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [032/205] net: fix problem in reading sock TX queue
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tom Herbert <therbert@google.com>

commit b0f77d0eae0c58a5a9691a067ada112ceeae2d00 upstream.

Fix problem in reading the tx_queue recorded in a socket.  In
dev_pick_tx, the TX queue is read by doing a check with
sk_tx_queue_recorded on the socket, followed by a sk_tx_queue_get.
The problem is that there is not mutual exclusion across these
calls in the socket so it it is possible that the queue in the
sock can be invalidated after sk_tx_queue_recorded is called so
that sk_tx_queue get returns -1, which sets 65535 in queue_index
and thus dev_pick_tx returns 65536 which is a bogus queue and
can cause crash in dev_queue_xmit.

We fix this by only calling sk_tx_queue_get which does the proper
checks.  The interface is that sk_tx_queue_get returns the TX queue
if the sock argument is non-NULL and TX queue is recorded, else it
returns -1.  sk_tx_queue_recorded is no longer used so it can be
completely removed.

Signed-off-by: Tom Herbert <therbert@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/sock.h |    7 +------
 net/core/dev.c     |    7 +++----
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1146,12 +1146,7 @@ static inline void sk_tx_queue_clear(str
 
 static inline int sk_tx_queue_get(const struct sock *sk)
 {
-	return sk->sk_tx_queue_mapping;
-}
-
-static inline bool sk_tx_queue_recorded(const struct sock *sk)
-{
-	return (sk && sk->sk_tx_queue_mapping >= 0);
+	return sk ? sk->sk_tx_queue_mapping : -1;
 }
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1972,12 +1972,11 @@ static inline u16 dev_cap_txqueue(struct
 static struct netdev_queue *dev_pick_tx(struct net_device *dev,
 					struct sk_buff *skb)
 {
-	u16 queue_index;
+	int queue_index;
 	struct sock *sk = skb->sk;
 
-	if (sk_tx_queue_recorded(sk)) {
-		queue_index = sk_tx_queue_get(sk);
-	} else {
+	queue_index = sk_tx_queue_get(sk);
+	if (queue_index < 0) {
 		const struct net_device_ops *ops = dev->netdev_ops;
 
 		if (ops->ndo_select_queue) {


