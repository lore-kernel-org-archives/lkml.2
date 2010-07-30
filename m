Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab0G3Sln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:41:43 -0400
Received: from kroah.org ([198.145.64.141]:57829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759717Ab0G3RyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:16 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.582895339@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [011/205] tcp: tcp_synack_options() fix
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit de213e5eedecdfb1b1eea7e6be28bc64cac5c078 ]

Commit 33ad798c924b4a (tcp: options clean up) introduced a problem
if MD5+SACK+timestamps were used in initial SYN message.

Some stacks (old linux for example) try to negotiate MD5+SACK+TSTAMP
sessions, but since 40 bytes of tcp options space are not enough to
store all the bits needed, we chose to disable timestamps in this case.

We send a SYN-ACK _without_ timestamp option, but socket has timestamps
enabled and all further outgoing messages contain a TS block, all with
the initial timestamp of the remote peer.

Fix is to really disable timestamps option for the whole session.

Reported-by: Bijay Singh <Bijay.Singh@guavus.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_output.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -667,7 +667,6 @@ static unsigned tcp_synack_options(struc
 	u8 cookie_plus = (xvp != NULL && !xvp->cookie_out_never) ?
 			 xvp->cookie_plus :
 			 0;
-	bool doing_ts = ireq->tstamp_ok;
 
 #ifdef CONFIG_TCP_MD5SIG
 	*md5 = tcp_rsk(req)->af_specific->md5_lookup(sk, req);
@@ -680,7 +679,7 @@ static unsigned tcp_synack_options(struc
 		 * rather than TS in order to fit in better with old,
 		 * buggy kernels, but that was deemed to be unnecessary.
 		 */
-		doing_ts &= !ireq->sack_ok;
+		ireq->tstamp_ok &= !ireq->sack_ok;
 	}
 #else
 	*md5 = NULL;
@@ -695,7 +694,7 @@ static unsigned tcp_synack_options(struc
 		opts->options |= OPTION_WSCALE;
 		remaining -= TCPOLEN_WSCALE_ALIGNED;
 	}
-	if (likely(doing_ts)) {
+	if (likely(ireq->tstamp_ok)) {
 		opts->options |= OPTION_TS;
 		opts->tsval = TCP_SKB_CB(skb)->when;
 		opts->tsecr = req->ts_recent;
@@ -703,7 +702,7 @@ static unsigned tcp_synack_options(struc
 	}
 	if (likely(ireq->sack_ok)) {
 		opts->options |= OPTION_SACK_ADVERTISE;
-		if (unlikely(!doing_ts))
+		if (unlikely(!ireq->tstamp_ok))
 			remaining -= TCPOLEN_SACKPERM_ALIGNED;
 	}
 
@@ -711,7 +710,7 @@ static unsigned tcp_synack_options(struc
 	 * If the <SYN> options fit, the same options should fit now!
 	 */
 	if (*md5 == NULL &&
-	    doing_ts &&
+	    ireq->tstamp_ok &&
 	    cookie_plus > TCPOLEN_COOKIE_BASE) {
 		int need = cookie_plus; /* has TCPOLEN_COOKIE_BASE */
 


