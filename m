Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0KSV7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:59:13 -0500
Received: from kroah.org ([198.145.64.141]:45319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab0KSV7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:02 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215644.664495015@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Damian Lukowski <damian@tvk.rwth-aachen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [72/82] net-2.6: SYN retransmits: Add new parameter to retransmits_timed_out()
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Damian Lukowski <damian@tvk.rwth-aachen.de>

[ Upstream commit 4d22f7d372f5769c6c0149e427ed6353e2dcfe61 ]

Fixes kernel Bugzilla Bug 18952

This patch adds a syn_set parameter to the retransmits_timed_out()
routine and updates its callers. If not set, TCP_RTO_MIN is taken
as the calculation basis as before. If set, TCP_TIMEOUT_INIT is
used instead, so that sysctl_syn_retries represents the actual
amount of SYN retransmissions in case no SYNACKs are received when
establishing a new connection.

Signed-off-by: Damian Lukowski <damian@tvk.rwth-aachen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_timer.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -136,13 +136,16 @@ static void tcp_mtu_probing(struct inet_
 
 /* This function calculates a "timeout" which is equivalent to the timeout of a
  * TCP connection after "boundary" unsuccessful, exponentially backed-off
- * retransmissions with an initial RTO of TCP_RTO_MIN.
+ * retransmissions with an initial RTO of TCP_RTO_MIN or TCP_TIMEOUT_INIT if
+ * syn_set flag is set.
  */
 static bool retransmits_timed_out(struct sock *sk,
-				  unsigned int boundary)
+				  unsigned int boundary,
+				  bool syn_set)
 {
 	unsigned int timeout, linear_backoff_thresh;
 	unsigned int start_ts;
+	unsigned int rto_base = syn_set ? TCP_TIMEOUT_INIT : TCP_RTO_MIN;
 
 	if (!inet_csk(sk)->icsk_retransmits)
 		return false;
@@ -152,12 +155,12 @@ static bool retransmits_timed_out(struct
 	else
 		start_ts = tcp_sk(sk)->retrans_stamp;
 
-	linear_backoff_thresh = ilog2(TCP_RTO_MAX/TCP_RTO_MIN);
+	linear_backoff_thresh = ilog2(TCP_RTO_MAX/rto_base);
 
 	if (boundary <= linear_backoff_thresh)
-		timeout = ((2 << boundary) - 1) * TCP_RTO_MIN;
+		timeout = ((2 << boundary) - 1) * rto_base;
 	else
-		timeout = ((2 << linear_backoff_thresh) - 1) * TCP_RTO_MIN +
+		timeout = ((2 << linear_backoff_thresh) - 1) * rto_base +
 			  (boundary - linear_backoff_thresh) * TCP_RTO_MAX;
 
 	return (tcp_time_stamp - start_ts) >= timeout;
@@ -168,14 +171,15 @@ static int tcp_write_timeout(struct sock
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	int retry_until;
-	bool do_reset;
+	bool do_reset, syn_set = 0;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		if (icsk->icsk_retransmits)
 			dst_negative_advice(sk);
 		retry_until = icsk->icsk_syn_retries ? : sysctl_tcp_syn_retries;
+		syn_set = 1;
 	} else {
-		if (retransmits_timed_out(sk, sysctl_tcp_retries1)) {
+		if (retransmits_timed_out(sk, sysctl_tcp_retries1, 0)) {
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
@@ -188,14 +192,14 @@ static int tcp_write_timeout(struct sock
 
 			retry_until = tcp_orphan_retries(sk, alive);
 			do_reset = alive ||
-				   !retransmits_timed_out(sk, retry_until);
+				   !retransmits_timed_out(sk, retry_until, 0);
 
 			if (tcp_out_of_resources(sk, do_reset))
 				return 1;
 		}
 	}
 
-	if (retransmits_timed_out(sk, retry_until)) {
+	if (retransmits_timed_out(sk, retry_until, syn_set)) {
 		/* Has it gone just too far? */
 		tcp_write_err(sk);
 		return 1;
@@ -437,7 +441,7 @@ out_reset_timer:
 		icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);
 	}
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS, icsk->icsk_rto, TCP_RTO_MAX);
-	if (retransmits_timed_out(sk, sysctl_tcp_retries1 + 1))
+	if (retransmits_timed_out(sk, sysctl_tcp_retries1 + 1, 0))
 		__sk_dst_reset(sk);
 
 out:;


