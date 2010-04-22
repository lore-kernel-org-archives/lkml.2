Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0DVTin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:38:43 -0400
Received: from kroah.org ([198.145.64.141]:41448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0DVT3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:40 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:22 2010
Message-Id: <20100422190921.970595804@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "David S. Miller" <davem@davemloft.net>,
       maximilian attems <max@stro.at>
Subject: [163/197] tcp: fix ICMP-RTO war
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Damian Lukowski <damian@tvk.rwth-aachen.de>

commit 598856407d4e20ebb4de01a91a93d89325924d43 upstream.

Make sure, that TCP has a nonzero RTT estimation after three-way
handshake. Currently, a listening TCP has a value of 0 for srtt,
rttvar and rto right after the three-way handshake is completed
with TCP timestamps disabled.
This will lead to corrupt RTO recalculation and retransmission
flood when RTO is recalculated on backoff reversion as introduced
in "Revert RTO on ICMP destination unreachable"
(f1ecd5d9e7366609d640ff4040304ea197fbc618).
This behaviour can be provoked by connecting to a server which
"responds first" (like SMTP) and rejecting every packet after
the handshake with dest-unreachable, which will lead to softirq
load on the server (up to 30% per socket in some tests).

Thanks to Ilpo Jarvinen for providing debug patches and to
Denys Fedoryshchenko for reporting and testing.

Changes since v3: Removed bad characters in patchfile.

Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Damian Lukowski <damian@tvk.rwth-aachen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_input.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5699,11 +5699,9 @@ int tcp_rcv_state_process(struct sock *s
 
 				/* tcp_ack considers this ACK as duplicate
 				 * and does not calculate rtt.
-				 * Fix it at least with timestamps.
+				 * Force it here.
 				 */
-				if (tp->rx_opt.saw_tstamp &&
-				    tp->rx_opt.rcv_tsecr && !tp->srtt)
-					tcp_ack_saw_tstamp(sk, 0);
+				tcp_ack_update_rtt(sk, 0, 0);
 
 				if (tp->rx_opt.tstamp_ok)
 					tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;


