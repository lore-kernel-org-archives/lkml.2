Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1EDUFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:05:05 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33044 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab1EDUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:05:00 -0400
Date: Wed, 4 May 2011 13:04:56 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>, Sangtae Ha <sangtae.ha@gmail.com>,
        Injong Rhee <injongrhee@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, rdunlap@xenotime.net, lkml@techboom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp_cubic: limit delayed_ack ratio to prevent divide error
Message-ID: <20110504130456.425dee68@nehalam>
In-Reply-To: <20110504.124053.260068550.davem@davemloft.net>
References: <20110504113351.4643a0c9@nehalam>
	<16668.1304537481@localhost>
	<20110504123738.7bb4d1ee@nehalam>
	<20110504.124053.260068550.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TCP Cubic keeps a metric that estimates the amount of delayed
acknowledgements to use in adjusting the window. If an abnormally
large number of packets are acknowledged at once, then the update
could wrap and reach zero. This kind of ACK could only
happen when there was a large window and huge number of
ACK's were lost.

This patch limits the value of delayed ack ratio. The choice of 32
is just a conservative value since normally it should be range of 
1 to 4 packets.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Patch against 2.6.39-rc5+


--- a/net/ipv4/tcp_cubic.c	2011-05-04 11:58:49.666027155 -0700
+++ b/net/ipv4/tcp_cubic.c	2011-05-04 12:52:34.716767304 -0700
@@ -93,6 +93,7 @@ struct bictcp {
 	u32	ack_cnt;	/* number of acks */
 	u32	tcp_cwnd;	/* estimated tcp cwnd */
 #define ACK_RATIO_SHIFT	4
+#define ACK_RATIO_LIMIT (32u << ACK_RATIO_SHIFT)
 	u16	delayed_ack;	/* estimate the ratio of Packets/ACKs << 4 */
 	u8	sample_cnt;	/* number of samples to decide curr_rtt */
 	u8	found;		/* the exit point is found? */
@@ -398,8 +399,12 @@ static void bictcp_acked(struct sock *sk
 	u32 delay;
 
 	if (icsk->icsk_ca_state == TCP_CA_Open) {
-		cnt -= ca->delayed_ack >> ACK_RATIO_SHIFT;
-		ca->delayed_ack += cnt;
+		u32 ratio = ca->delayed_ack;
+
+		ratio -= ca->delayed_ack >> ACK_RATIO_SHIFT;
+		ratio += cnt;
+
+		ca->delayed_ack = min(ratio, ACK_RATIO_LIMIT);
 	}
 
 	/* Some calls are for duplicates without timetamps */
