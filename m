Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031111Ab2ERDHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:07:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40444 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762576Ab2ERCwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:32 -0400
Message-Id: <20120518023256.772790399@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/53] tcp: fix infinite cwnd in tcp_complete_cwr()
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 1cebce36d660c83bd1353e41f3e66abd4686f215 ]

When the cwnd reduction is done, ssthresh may be infinite
if TCP enters CWR via ECN or F-RTO. If cwnd is not undone, i.e.,
undo_marker is set, tcp_complete_cwr() falsely set cwnd to the
infinite ssthresh value. The correct operation is to keep cwnd
intact because it has been updated in ECN or F-RTO.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e4d1e4a..b9c6567 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2864,11 +2864,14 @@ static inline void tcp_complete_cwr(struct sock *sk)
 
 	/* Do not moderate cwnd if it's already undone in cwr or recovery. */
 	if (tp->undo_marker) {
-		if (inet_csk(sk)->icsk_ca_state == TCP_CA_CWR)
+		if (inet_csk(sk)->icsk_ca_state == TCP_CA_CWR) {
 			tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_ssthresh);
-		else /* PRR */
+			tp->snd_cwnd_stamp = tcp_time_stamp;
+		} else if (tp->snd_ssthresh < TCP_INFINITE_SSTHRESH) {
+			/* PRR algorithm. */
 			tp->snd_cwnd = tp->snd_ssthresh;
-		tp->snd_cwnd_stamp = tcp_time_stamp;
+			tp->snd_cwnd_stamp = tcp_time_stamp;
+		}
 	}
 	tcp_ca_event(sk, CA_EVENT_COMPLETE_CWR);
 }
-- 
1.7.10.1




