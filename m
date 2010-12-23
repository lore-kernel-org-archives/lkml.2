Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0LWJXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:23:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab0LWJXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:23:40 -0500
Date: Thu, 23 Dec 2010 10:23:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Subject: Re: [PATCH] tcp: cleanup of cwnd initialization in
 tcp_init_metrics()
In-Reply-To: <1293095663.7789.3.camel@edumazet-laptop>
Message-ID: <alpine.LNX.2.00.1012231022430.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012221938030.16569@pobox.suse.cz>  <1293092671.2679.44.camel@edumazet-laptop>  <alpine.LNX.2.00.1012231002310.16569@pobox.suse.cz> <1293095663.7789.3.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010, Eric Dumazet wrote:

> > > > Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case when 
> > > > congestion window initialization has been mistakenly omitted by 
> > > > introducing cwnd label and putting backwards jump from the end of the 
> > > > function.
> > > > 
> > > > This makes the code unnecessarily tricky to read and understand on a first 
> > > > sight.
> > > > 
> > > > Shuffle the code around a little bit to make it more obvious.
> > > 
> > > Well in fine you have
> > > 
> > > 	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
> > > 		goto reset;
> > > 	goto out;
> > > reset:
> > > 
> > > Is that really more obvious ? ;)
> > 
> > To me it seems much more obvious than goto from the very end of the 
> > function somewhere into the middle and returning from there, but 
> > definitely a matter of personal taste.
> > 
> 
> You dont understand what I said. Please read again.
> 
> To me I prefer you _finish_ the cleanup so that we have :
> 
> 	if (some condition) {
> reset:
> 	}
> 
> out:
> 
> You remove two "goto" in the process.
> 
> Is that clear now ?

Right, that's even better. Updated patch below.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] tcp: cleanup of cwnd initialization in tcp_init_metrics()

Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case
when congestion window initialization has been mistakenly omitted
by introducing cwnd label and putting backwards goto from the
end of the function.

This makes the code unnecessarily tricky to read and understand
on a first sight.

Shuffle the code around a little bit to make it more obvious.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 net/ipv4/tcp_input.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6d8ab1c..3d1e015 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -912,25 +912,20 @@ static void tcp_init_metrics(struct sock *sk)
 		tp->mdev_max = tp->rttvar = max(tp->mdev, tcp_rto_min(sk));
 	}
 	tcp_set_rto(sk);
-	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
-		goto reset;
-
-cwnd:
-	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
-	tp->snd_cwnd_stamp = tcp_time_stamp;
-	return;
-
+	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp) {
 reset:
-	/* Play conservative. If timestamps are not
-	 * supported, TCP will fail to recalculate correct
-	 * rtt, if initial rto is too small. FORGET ALL AND RESET!
-	 */
-	if (!tp->rx_opt.saw_tstamp && tp->srtt) {
-		tp->srtt = 0;
-		tp->mdev = tp->mdev_max = tp->rttvar = TCP_TIMEOUT_INIT;
-		inet_csk(sk)->icsk_rto = TCP_TIMEOUT_INIT;
+		/* Play conservative. If timestamps are not
+		 * supported, TCP will fail to recalculate correct
+		 * rtt, if initial rto is too small. FORGET ALL AND RESET!
+		 */
+		if (!tp->rx_opt.saw_tstamp && tp->srtt) {
+			tp->srtt = 0;
+			tp->mdev = tp->mdev_max = tp->rttvar = TCP_TIMEOUT_INIT;
+			inet_csk(sk)->icsk_rto = TCP_TIMEOUT_INIT;
+		}
 	}
-	goto cwnd;
+	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
+	tp->snd_cwnd_stamp = tcp_time_stamp;
 }
 
 static void tcp_update_reordering(struct sock *sk, const int metric,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
