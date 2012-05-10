Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab2EJRe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760605Ab2EJRey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:54 -0400
Message-Id: <20120510173135.526757723@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/52] tcp: fix infinite cwnd in tcp_complete_cwr()
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2866,11 +2866,14 @@ static inline void tcp_complete_cwr(stru
 
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


