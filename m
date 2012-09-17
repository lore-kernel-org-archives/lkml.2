Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2IQBBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:01:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33833 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab2IQAvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:10 -0400
Message-Id: <20120917003633.856033518@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "danborkmann@iogearbox.net" <danborkmann@iogearbox.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 055/135] af_packet: remove BUG statement in  tpacket_destruct_skb
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "danborkmann@iogearbox.net" <danborkmann@iogearbox.net>

[ Upstream commit 7f5c3e3a80e6654cf48dfba7cf94f88c6b505467 ]

Here's a quote of the comment about the BUG macro from asm-generic/bug.h:

 Don't use BUG() or BUG_ON() unless there's really no way out; one
 example might be detecting data structure corruption in the middle
 of an operation that can't be backed out of.  If the (sub)system
 can somehow continue operating, perhaps with reduced functionality,
 it's probably not BUG-worthy.

 If you're tempted to BUG(), think again:  is completely giving up
 really the *only* solution?  There are usually better options, where
 users don't need to reboot ASAP and can mostly shut down cleanly.

In our case, the status flag of a ring buffer slot is managed from both sides,
the kernel space and the user space. This means that even though the kernel
side might work as expected, the user space screws up and changes this flag
right between the send(2) is triggered when the flag is changed to
TP_STATUS_SENDING and a given skb is destructed after some time. Then, this
will hit the BUG macro. As David suggested, the best solution is to simply
remove this statement since it cannot be used for kernel side internal
consistency checks. I've tested it and the system still behaves /stable/ in
this case, so in accordance with the above comment, we should rather remove it.

Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d9d4970..13b14dc 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1931,7 +1931,6 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 
 	if (likely(po->tx_ring.pg_vec)) {
 		ph = skb_shinfo(skb)->destructor_arg;
-		BUG_ON(__packet_get_status(po, ph) != TP_STATUS_SENDING);
 		BUG_ON(atomic_read(&po->tx_ring.pending) == 0);
 		atomic_dec(&po->tx_ring.pending);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE);


