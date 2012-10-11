Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab2JKCMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:12:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51377 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933349Ab2JKCMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:12:37 -0400
X-Sasl-enc: DJ1EDqrfsq3matgn/0Cjj9iFVYCDq2h11oRv9w7Si1KE 1349921556
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Graf <tgraf@suug.ch>, Vlad Yasevich <vyasevic@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: [ 29/84] sctp: Dont charge for data in sndbuf again when transmitting packet
Date: Thu, 11 Oct 2012 11:03:13 +0900
Message-Id: <20121011015422.321142576@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit 4c3a5bdae293f75cdf729c6c00124e8489af2276 ]

SCTP charges wmem_alloc via sctp_set_owner_w() in sctp_sendmsg() and via
skb_set_owner_w() in sctp_packet_transmit(). If a sender runs out of
sndbuf it will sleep in sctp_wait_for_sndbuf() and expects to be waken up
by __sctp_write_space().

Buffer space charged via sctp_set_owner_w() is released in sctp_wfree()
which calls __sctp_write_space() directly.

Buffer space charged via skb_set_owner_w() is released via sock_wfree()
which calls sk->sk_write_space() _if_ SOCK_USE_WRITE_QUEUE is not set.
sctp_endpoint_init() sets SOCK_USE_WRITE_QUEUE on all sockets.

Therefore if sctp_packet_transmit() manages to queue up more than sndbuf
bytes, sctp_wait_for_sndbuf() will never be woken up again unless it is
interrupted by a signal.

This could be fixed by clearing the SOCK_USE_WRITE_QUEUE flag but ...

Charging for the data twice does not make sense in the first place, it
leads to overcharging sndbuf by a factor 2. Therefore this patch only
charges a single byte in wmem_alloc when transmitting an SCTP packet to
ensure that the socket stays alive until the packet has been released.

This means that control chunks are no longer accounted for in wmem_alloc
which I believe is not a problem as skb->truesize will typically lead
to overcharging anyway and thus compensates for any control overhead.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
CC: Vlad Yasevich <vyasevic@redhat.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: David Miller <davem@davemloft.net>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/output.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -334,6 +334,25 @@ finish:
 	return retval;
 }
 
+static void sctp_packet_release_owner(struct sk_buff *skb)
+{
+	sk_free(skb->sk);
+}
+
+static void sctp_packet_set_owner_w(struct sk_buff *skb, struct sock *sk)
+{
+	skb_orphan(skb);
+	skb->sk = sk;
+	skb->destructor = sctp_packet_release_owner;
+
+	/*
+	 * The data chunks have already been accounted for in sctp_sendmsg(),
+	 * therefore only reserve a single byte to keep socket around until
+	 * the packet has been transmitted.
+	 */
+	atomic_inc(&sk->sk_wmem_alloc);
+}
+
 /* All packets are sent to the network through this function from
  * sctp_outq_tail().
  *
@@ -375,7 +394,7 @@ int sctp_packet_transmit(struct sctp_pac
 	/* Set the owning socket so that we know where to get the
 	 * destination IP address.
 	 */
-	skb_set_owner_w(nskb, sk);
+	sctp_packet_set_owner_w(nskb, sk);
 
 	if (!sctp_transport_dst_check(tp)) {
 		sctp_transport_route(tp, NULL, sctp_sk(sk));


