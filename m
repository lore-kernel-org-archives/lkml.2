Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab2KOEpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:45:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:48565 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992690Ab2KOEKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Petr Matousek <pmatouse@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 29/38] net: fix divide by zero in tcp algorithm illinois
Date: Wed, 14 Nov 2012 20:10:26 -0800
Message-Id: <20121115040934.690217830@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 8f363b77ee4fbf7c3bbcf5ec2c5ca482d396d664 ]

Reading TCP stats when using TCP Illinois congestion control algorithm
can cause a divide by zero kernel oops.

The division by zero occur in tcp_illinois_info() at:
 do_div(t, ca->cnt_rtt);
where ca->cnt_rtt can become zero (when rtt_reset is called)

Steps to Reproduce:
 1. Register tcp_illinois:
     # sysctl -w net.ipv4.tcp_congestion_control=illinois
 2. Monitor internal TCP information via command "ss -i"
     # watch -d ss -i
 3. Establish new TCP conn to machine

Either it fails at the initial conn, or else it needs to wait
for a loss or a reset.

This is only related to reading stats.  The function avg_delay() also
performs the same divide, but is guarded with a (ca->cnt_rtt > 0) at its
calling point in update_params().  Thus, simply fix tcp_illinois_info().

Function tcp_illinois_info() / get_info() is called without
socket lock.  Thus, eliminate any race condition on ca->cnt_rtt
by using a local stack variable.  Simply reuse info.tcpv_rttcnt,
as its already set to ca->cnt_rtt.
Function avg_delay() is not affected by this race condition, as
its called with the socket lock.

Cc: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_illinois.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -313,11 +313,13 @@ static void tcp_illinois_info(struct soc
 			.tcpv_rttcnt = ca->cnt_rtt,
 			.tcpv_minrtt = ca->base_rtt,
 		};
-		u64 t = ca->sum_rtt;
 
-		do_div(t, ca->cnt_rtt);
-		info.tcpv_rtt = t;
+		if (info.tcpv_rttcnt > 0) {
+			u64 t = ca->sum_rtt;
 
+			do_div(t, info.tcpv_rttcnt);
+			info.tcpv_rtt = t;
+		}
 		nla_put(skb, INET_DIAG_VEGASINFO, sizeof(info), &info);
 	}
 }


