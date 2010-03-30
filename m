Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0C3XXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:23:06 -0400
Received: from kroah.org ([198.145.64.141]:46852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab0C3XWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:12 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:55 2010
Message-Id: <20100330224855.359001565@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [146/156] tcp: Fix tcp_make_synack()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 28b2774a0d5852236dab77a4147b8b88548110f1 ]

Commit 4957faad (TCPCT part 1g: Responder Cookie => Initiator), part
of TCP_COOKIE_TRANSACTION implementation, forgot to correctly size
synack skb in case user data must be included.

Many thanks to Mika Pentillä for spotting this error.

Reported-by: Penttillä Mika <mika.penttila@ixonos.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_output.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2393,13 +2393,17 @@ struct sk_buff *tcp_make_synack(struct s
 	struct tcp_extend_values *xvp = tcp_xv(rvp);
 	struct inet_request_sock *ireq = inet_rsk(req);
 	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_cookie_values *cvp = tp->cookie_values;
 	struct tcphdr *th;
 	struct sk_buff *skb;
 	struct tcp_md5sig_key *md5;
 	int tcp_header_size;
 	int mss;
+	int s_data_desired = 0;
 
-	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15, 1, GFP_ATOMIC);
+	if (cvp != NULL && cvp->s_data_constant && cvp->s_data_desired)
+		s_data_desired = cvp->s_data_desired;
+	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1, GFP_ATOMIC);
 	if (skb == NULL)
 		return NULL;
 
@@ -2454,16 +2458,12 @@ struct sk_buff *tcp_make_synack(struct s
 			     TCPCB_FLAG_SYN | TCPCB_FLAG_ACK);
 
 	if (OPTION_COOKIE_EXTENSION & opts.options) {
-		const struct tcp_cookie_values *cvp = tp->cookie_values;
-
-		if (cvp != NULL &&
-		    cvp->s_data_constant &&
-		    cvp->s_data_desired > 0) {
-			u8 *buf = skb_put(skb, cvp->s_data_desired);
+		if (s_data_desired) {
+			u8 *buf = skb_put(skb, s_data_desired);
 
 			/* copy data directly from the listening socket. */
-			memcpy(buf, cvp->s_data_payload, cvp->s_data_desired);
-			TCP_SKB_CB(skb)->end_seq += cvp->s_data_desired;
+			memcpy(buf, cvp->s_data_payload, s_data_desired);
+			TCP_SKB_CB(skb)->end_seq += s_data_desired;
 		}
 
 		if (opts.hash_size > 0) {


