Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0LVSj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:39:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab0LVSj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:39:57 -0500
Date: Wed, 22 Dec 2010 19:39:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>,
        =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH] tcp: cleanup of cwnd initialization in tcp_init_metrics()
Message-ID: <alpine.LNX.2.00.1012221938030.16569@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case when 
congestion window initialization has been mistakenly omitted by 
introducing cwnd label and putting backwards jump from the end of the 
function.

This makes the code unnecessarily tricky to read and understand on a first 
sight.

Shuffle the code around a little bit to make it more obvious.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 net/ipv4/tcp_input.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6d8ab1c..dddff6d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -915,11 +915,7 @@ static void tcp_init_metrics(struct sock *sk)
 	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
 		goto reset;
 
-cwnd:
-	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
-	tp->snd_cwnd_stamp = tcp_time_stamp;
-	return;
-
+	goto out;
 reset:
 	/* Play conservative. If timestamps are not
 	 * supported, TCP will fail to recalculate correct
@@ -930,7 +926,9 @@ reset:
 		tp->mdev = tp->mdev_max = tp->rttvar = TCP_TIMEOUT_INIT;
 		inet_csk(sk)->icsk_rto = TCP_TIMEOUT_INIT;
 	}
-	goto cwnd;
+out:
+	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
+	tp->snd_cwnd_stamp = tcp_time_stamp;
 }
 
 static void tcp_update_reordering(struct sock *sk, const int metric,
-- 
1.7.3.1

