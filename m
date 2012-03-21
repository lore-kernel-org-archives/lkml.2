Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2CUVSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:18:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47498 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab2CUVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:16:40 -0400
Message-Id: <20120321211448.676904040@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:14:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Simon Kirby <sim@netnation.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 5/8] tcp: fix syncookie regression
In-Reply-To: <20120321211522.GA28233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit dfd25ffffc132c00070eed64200e8950da5d7e9d ]

commit ea4fc0d619 (ipv4: Don't use rt->rt_{src,dst} in ip_queue_xmit())
added a serious regression on synflood handling.

Simon Kirby discovered a successful connection was delayed by 20 seconds
before being responsive.

In my tests, I discovered that xmit frames were lost, and needed ~4
retransmits and a socket dst rebuild before being really sent.

In case of syncookie initiated connection, we use a different path to
initialize the socket dst, and inet->cork.fl.u.ip4 is left cleared.

As ip_queue_xmit() now depends on inet flow being setup, fix this by
copying the temp flowi4 we use in cookie_v4_check().

Reported-by: Simon Kirby <sim@netnation.com>
Bisected-by: Simon Kirby <sim@netnation.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/syncookies.c |   30 ++++++++++++++++--------------
 net/ipv4/tcp_ipv4.c   |   10 +++++++---
 2 files changed, 23 insertions(+), 17 deletions(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -277,6 +277,7 @@ struct sock *cookie_v4_check(struct sock
 	struct rtable *rt;
 	__u8 rcv_wscale;
 	bool ecn_ok = false;
+	struct flowi4 fl4;
 
 	if (!sysctl_tcp_syncookies || !th->ack || th->rst)
 		goto out;
@@ -344,20 +345,16 @@ struct sock *cookie_v4_check(struct sock
 	 * hasn't changed since we received the original syn, but I see
 	 * no easy way to do this.
 	 */
-	{
-		struct flowi4 fl4;
-
-		flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
-				   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
-				   inet_sk_flowi_flags(sk),
-				   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
-				   ireq->loc_addr, th->source, th->dest);
-		security_req_classify_flow(req, flowi4_to_flowi(&fl4));
-		rt = ip_route_output_key(sock_net(sk), &fl4);
-		if (IS_ERR(rt)) {
-			reqsk_free(req);
-			goto out;
-		}
+	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
+			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
+			   inet_sk_flowi_flags(sk),
+			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
+			   ireq->loc_addr, th->source, th->dest);
+	security_req_classify_flow(req, flowi4_to_flowi(&fl4));
+	rt = ip_route_output_key(sock_net(sk), &fl4);
+	if (IS_ERR(rt)) {
+		reqsk_free(req);
+		goto out;
 	}
 
 	/* Try to redo what tcp_v4_send_synack did. */
@@ -371,5 +368,10 @@ struct sock *cookie_v4_check(struct sock
 	ireq->rcv_wscale  = rcv_wscale;
 
 	ret = get_cookie_sock(sk, skb, req, &rt->dst);
+	/* ip_queue_xmit() depends on our flow being setup
+	 * Normal sockets get it right from inet_csk_route_child_sock()
+	 */
+	if (ret)
+		inet_sk(ret)->cork.fl.u.ip4 = fl4;
 out:	return ret;
 }
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1454,9 +1454,13 @@ struct sock *tcp_v4_syn_recv_sock(struct
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 	newinet->inet_id = newtp->write_seq ^ jiffies;
 
-	if (!dst && (dst = inet_csk_route_child_sock(sk, newsk, req)) == NULL)
-		goto put_and_exit;
-
+	if (!dst) {
+		dst = inet_csk_route_child_sock(sk, newsk, req);
+		if (!dst)
+			goto put_and_exit;
+	} else {
+		/* syncookie case : see end of cookie_v4_check() */
+	}
 	sk_setup_caps(newsk, dst);
 
 	tcp_mtup_init(newsk);


