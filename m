Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1DSURO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:14 -0400
Received: from kroah.org ([198.145.64.141]:47674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1DSURK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201045.913635404@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [26/70] tcp: avoid cwnd moderation in undo
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 67d4120a1793138bc9f4a6eb61d0fc5298ed97e0 ]

In the current undo logic, cwnd is moderated after it was restored
to the value prior entering fast-recovery. It was moderated first
in tcp_try_undo_recovery then again in tcp_complete_cwr.

Since the undo indicates recovery was false, these moderations
are not necessary. If the undo is triggered when most of the
outstanding data have been acknowledged, the (restored) cwnd is
falsely pulled down to a small value.

This patch removes these cwnd moderations if cwnd is undone
  a) during fast-recovery
	b) by receiving DSACKs past fast-recovery

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_input.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2659,7 +2659,7 @@ static void DBGUNDO(struct sock *sk, con
 #define DBGUNDO(x...) do { } while (0)
 #endif
 
-static void tcp_undo_cwr(struct sock *sk, const int undo)
+static void tcp_undo_cwr(struct sock *sk, const int undo_ssthresh)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2671,14 +2671,13 @@ static void tcp_undo_cwr(struct sock *sk
 		else
 			tp->snd_cwnd = max(tp->snd_cwnd, tp->snd_ssthresh << 1);
 
-		if (undo && tp->prior_ssthresh > tp->snd_ssthresh) {
+		if (undo_ssthresh && tp->prior_ssthresh > tp->snd_ssthresh) {
 			tp->snd_ssthresh = tp->prior_ssthresh;
 			TCP_ECN_withdraw_cwr(tp);
 		}
 	} else {
 		tp->snd_cwnd = max(tp->snd_cwnd, tp->snd_ssthresh);
 	}
-	tcp_moderate_cwnd(tp);
 	tp->snd_cwnd_stamp = tcp_time_stamp;
 }
 
@@ -2822,8 +2821,11 @@ static int tcp_try_undo_loss(struct sock
 static inline void tcp_complete_cwr(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_ssthresh);
-	tp->snd_cwnd_stamp = tcp_time_stamp;
+	/* Do not moderate cwnd if it's already undone in cwr or recovery */
+	if (tp->undo_marker && tp->snd_cwnd > tp->snd_ssthresh) {
+		tp->snd_cwnd = tp->snd_ssthresh;
+		tp->snd_cwnd_stamp = tcp_time_stamp;
+	}
 	tcp_ca_event(sk, CA_EVENT_COMPLETE_CWR);
 }
 


