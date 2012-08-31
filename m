Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2HaMso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:48:44 -0400
Received: from mail.linlab.net ([89.244.147.154]:45051 "EHLO mail.linlab.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab2HaMsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:48:42 -0400
X-DKIM: OpenDKIM Filter v2.5.1 mail.linlab.net q7VCmWfP023388
Date: Fri, 31 Aug 2012 14:48:31 +0200
From: Alexander Bergmann <alex@linlab.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: davem@davemloft.net, hkjerry.chu@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
Message-ID: <20120831124831.GA23279@linlab.net>
References: <1345724123.5904.756.camel@edumazet-glaptop>
 <20120824.134231.41073001349178209.davem@davemloft.net>
 <20120825084819.GD430@linlab.net>
 <201208281044.40057.carsten@wolffcarsten.de>
 <1346414260.2591.8.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346414260.2591.8.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (mail.linlab.net [127.0.0.1]); Fri, 31 Aug 2012 14:48:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 04:57:40AM -0700, Eric Dumazet wrote:
> On Tue, 2012-08-28 at 10:44 +0200, Carsten Wolff wrote:
> > 
> > wouldn't it be nice, if the description of the corresponding sysctls in 
> > Documentation/networking/ip-sysctl.txt could be updated too?
> > 

Thanks Carsten for pointing that out.

> 
> Carsten had a good point, any chance you can send a v3 of your patch,
> with the Documentation/networking/ip-sysctl.txt changed as well ?
> 

Hi Eric!

I've also changed the Documentation file. As usual, comments are welcome!


Alex


>From 848f34ce27f65401940ae98e0b2d395888d3986d Mon Sep 17 00:00:00 2001
From: Alexander Bergmann <alex@linlab.net>
Date: Fri, 31 Aug 2012 14:31:00 +0200
Subject: [PATCH 1/1] tcp: Increase timeout for SYN segments

Commit 9ad7c049 changed the initRTO from 3secs to 1sec in accordance to
RFC6298 (former RFC2988bis). This reduced the time till the last SYN
retransmission packet gets sent from 93secs to 31secs.

RFC1122 is stating that the retransmission should be done for at least 3
minutes, but this seems to be quite high.

  "However, the values of R1 and R2 may be different for SYN
  and data segments.  In particular, R2 for a SYN segment MUST
  be set large enough to provide retransmission of the segment
  for at least 3 minutes.  The application can close the
  connection (i.e., give up on the open attempt) sooner, of
  course."

This patch increases the value of TCP_SYN_RETRIES to the value of 6,
providing a retransmission window of 63secs.

The comments for SYN and SYNACK retries have also been updated to
describe the current settings. The same goes for the documentation file
"Documentation/networking/ip-sysctl.txt".

Signed-off-by: Alexander Bergmann <alex@linlab.net>
---
 Documentation/networking/ip-sysctl.txt |    8 ++++++--
 include/net/tcp.h                      |   18 ++++++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ca447b3..d64e531 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -439,7 +439,9 @@ tcp_stdurg - BOOLEAN
 tcp_synack_retries - INTEGER
 	Number of times SYNACKs for a passive TCP connection attempt will
 	be retransmitted. Should not be higher than 255. Default value
-	is 5, which corresponds to ~180seconds.
+	is 5, which corresponds to 31seconds till the last retransmission
+	with the current initial RTO of 1second. With this the final timeout
+	for a passive TCP connection will happen after 63seconds.
 
 tcp_syncookies - BOOLEAN
 	Only valid when the kernel was compiled with CONFIG_SYNCOOKIES
@@ -478,7 +480,9 @@ tcp_fastopen - INTEGER
 tcp_syn_retries - INTEGER
 	Number of times initial SYNs for an active TCP connection attempt
 	will be retransmitted. Should not be higher than 255. Default value
-	is 5, which corresponds to ~180seconds.
+	is 6, which corresponds to 63seconds till the last restransmission
+	with the current initial RTO of 1second. With this the final timeout
+	for an active TCP connection attempt will happen after 127seconds.
 
 tcp_timestamps - BOOLEAN
 	Enable timestamps as defined in RFC1323.
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1f000ff..d43d6b3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -98,11 +98,21 @@ extern void tcp_time_wait(struct sock *sk, int state, int timeo);
 				 * 15 is ~13-30min depending on RTO.
 				 */
 
-#define TCP_SYN_RETRIES	 5	/* number of times to retry active opening a
-				 * connection: ~180sec is RFC minimum	*/
+#define TCP_SYN_RETRIES	 6	/*
+				 * This is how many retries it does to active
+				 * opening a connection.
+				 * RFC1122 says the minimum retry MUST be at
+				 * least 180secs. Nevertheless this value is
+				 * corresponding to 63secs of retransmission
+				 * with the current initial RTO.
+				 */
 
-#define TCP_SYNACK_RETRIES 5	/* number of times to retry passive opening a
-				 * connection: ~180sec is RFC minimum	*/
+#define TCP_SYNACK_RETRIES 5	/* 
+				 * This is how may retries it does to passive
+				 * opening a connection. 
+				 * This is corresponding to 31secs of 
+				 * retransmission with the current initial RTO.
+				 */
 
 #define TCP_TIMEWAIT_LEN (60*HZ) /* how long to wait to destroy TIME-WAIT
 				  * state, about 60 seconds	*/
-- 
1.7.8.6


