Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2HXMRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:17:45 -0400
Received: from mail.linlab.net ([89.244.147.154]:47271 "EHLO mail.linlab.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2HXMRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:17:40 -0400
X-DKIM: OpenDKIM Filter v2.5.1 mail.linlab.net q7OCHR1w010036
Message-ID: <503770D8.8040906@linlab.net>
Date: Fri, 24 Aug 2012 14:17:28 +0200
From: Alex Bergmann <alex@linlab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
References: <503419D3.1080700@linlab.net>  <CAFbMe2M7ekc94bQk7vTS1LhScPd49VZ-zKOCUXhqwxXtL-nkuA@mail.gmail.com>  <50361AEA.6010807@linlab.net> <1345724123.5904.756.camel@edumazet-glaptop>  <50362407.9070805@linlab.net> <1345726185.5904.835.camel@edumazet-glaptop>
In-Reply-To: <1345726185.5904.835.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.6 (mail.linlab.net [IPv6:2001:470:7142:a0::3]); Fri, 24 Aug 2012 14:17:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> 
> A change of the comment might be good, to help future readers.
> 

Okay, I've also changed the comments of SYN and SYNACK retries. 

Alex

>From 11a292b1cff772f930a02fda02d5b741f8ea5033 Mon Sep 17 00:00:00 2001
From: Alexander Bergmann <alex@linlab.net>
Date: Fri, 24 Aug 2012 14:09:49 +0200
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
describe the current settings.

Signed-off-by: Alexander Bergmann <alex@linlab.net>
---
 include/net/tcp.h |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1f000ff..d43d6b3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -98,11 +98,21 @@ extern void tcp_time_wait(struct sock *sk, int state, int timeo);
                                 * 15 is ~13-30min depending on RTO.
                                 */
 
-#define TCP_SYN_RETRIES         5      /* number of times to retry active opening a
-                                * connection: ~180sec is RFC minimum   */
+#define TCP_SYN_RETRIES         6      /*
+                                * This is how many retries it does to active
+                                * opening a connection.
+                                * RFC1122 says the minimum retry MUST be at
+                                * least 180secs. Nevertheless this value is
+                                * corresponding to 63secs of retransmission
+                                * with the current initial RTO.
+                                */
 
-#define TCP_SYNACK_RETRIES 5   /* number of times to retry passive opening a
-                                * connection: ~180sec is RFC minimum   */
+#define TCP_SYNACK_RETRIES 5   /* 
+                                * This is how may retries it does to passive
+                                * opening a connection. 
+                                * This is corresponding to 31secs of 
+                                * retransmission with the current initial RTO.
+                                */
 
 #define TCP_TIMEWAIT_LEN (60*HZ) /* how long to wait to destroy TIME-WAIT
                                  * state, about 60 seconds     */
-- 
1.7.8.6

