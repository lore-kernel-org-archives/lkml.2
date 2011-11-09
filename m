Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278Ab1KJFGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:06:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469Ab1KJD1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:15 2011
Message-Id: <20111109212715.303123485@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [146/262] make PACKET_STATISTICS getsockopt report consistently between ring and non-ring
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 7091fbd82cd5686444ffe9935ed6a8190101fe9d ]

This is a minor change.

Up until kernel 2.6.32, getsockopt(fd, SOL_PACKET, PACKET_STATISTICS,
...) would return total and dropped packets since its last invocation. The
introduction of socket queue overflow reporting [1] changed drop
rate calculation in the normal packet socket path, but not when using a
packet ring. As a result, the getsockopt now returns different statistics
depending on the reception method used. With a ring, it still returns the
count since the last call, as counts are incremented in tpacket_rcv and
reset in getsockopt. Without a ring, it returns 0 if no drops occurred
since the last getsockopt and the total drops over the lifespan of
the socket otherwise. The culprit is this line in packet_rcv, executed
on a drop:

drop_n_acct:
        po->stats.tp_drops = atomic_inc_return(&sk->sk_drops);

As it shows, the new drop number it taken from the socket drop counter,
which is not reset at getsockopt. I put together a small example
that demonstrates the issue [2]. It runs for 10 seconds and overflows
the queue/ring on every odd second. The reported drop rates are:
ring: 16, 0, 16, 0, 16, ...
non-ring: 0, 15, 0, 30, 0, 46, 0, 60, 0 , 74.

Note how the even ring counts monotonically increase. Because the
getsockopt adds tp_drops to tp_packets, total counts are similarly
reported cumulatively. Long story short, reinstating the original code, as
the below patch does, fixes the issue at the cost of additional per-packet
cycles. Another solution that does not introduce per-packet overhead
is be to keep the current data path, record the value of sk_drops at
getsockopt() at call N in a new field in struct packetsock and subtract
that when reporting at call N+1. I'll be happy to code that, instead,
it's just more messy.

[1] http://patchwork.ozlabs.org/patch/35665/
[2] http://kernel.googlecode.com/files/test-packetsock-getstatistics.c

Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/packet/af_packet.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -654,7 +654,10 @@ static int packet_rcv(struct sk_buff *sk
 	return 0;
 
 drop_n_acct:
-	po->stats.tp_drops = atomic_inc_return(&sk->sk_drops);
+	spin_lock(&sk->sk_receive_queue.lock);
+	po->stats.tp_drops++;
+	atomic_inc(&sk->sk_drops);
+	spin_unlock(&sk->sk_receive_queue.lock);
 
 drop_n_restore:
 	if (skb_head != skb->data && skb_shared(skb)) {


