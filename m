Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2GTTqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:46:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43143 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680Ab2GTTq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:46:29 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Robin.Holt@sgi.com, Nathan Zimmer <nzimmer@sgi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC] net: further seperate dst_entry.__refcnt from cache contention
Date: Fri, 20 Jul 2012 14:46:27 -0500
Message-Id: <1342813587-31601-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some investigation on large machines I found that
dst_entry.__refcnt particpates in false cache sharing issues that show
when scaling past 12 threads who communicate via tcp with loopback addresses.
I adjusted refcnt to be on its own cache line and that helped quite a bit.
But perhaps a bit of a waste of space?  Is there some better way?

Here is some preliminary data I had gathered.  It shows nicely improved scaling.

Threads baseline   afterchange
2       1328.03    1340.67
4       2430.31    2282.09
6       3087.65    3258.12
8       3560.34    4165.88
10      3900.34    4962.28
12      3933.38    5613.76
14      3876.98    6113.85
16      3706.01    6338.00
18      3742.48    6634.77
20      3670.15    6641.25
22      3660.98    6799.55
24      3503.13    6613.45
26      3525.73    6702.67
28      3440.16    6801.27
30      3497.59    6911.52
32      3498.25    6540.06

I should say something about this test.  It is a dead simple test in which a
pair of threads simply pass data to each other.  They were placed in the same
socket to avoid cross node overhead.

CC: "David S. Miller" <davem@davemloft.net> 
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>

---
 include/net/dst.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 8197ead..3898643 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -84,7 +84,7 @@ struct dst_entry {
 	 * input/output/ops or performance tanks badly
 	 */
 	atomic_t		__refcnt;	/* client references	*/
-	int			__use;
+	int			__use	____cacheline_aligned;
 	unsigned long		lastuse;
 	union {
 		struct dst_entry	*next;
-- 
1.6.0.2

