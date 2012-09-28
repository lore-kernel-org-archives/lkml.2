Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2I1Syg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:54:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab2I1Sya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:54:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 009/262] af_packet: remove BUG statement in tpacket_destruct_skb
Date: Fri, 28 Sep 2012 11:48:58 -0700
Message-Id: <20120928182959.060410943@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1943,7 +1943,6 @@ static void tpacket_destruct_skb(struct
 
 	if (likely(po->tx_ring.pg_vec)) {
 		ph = skb_shinfo(skb)->destructor_arg;
-		BUG_ON(__packet_get_status(po, ph) != TP_STATUS_SENDING);
 		BUG_ON(atomic_read(&po->tx_ring.pending) == 0);
 		atomic_dec(&po->tx_ring.pending);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE);


