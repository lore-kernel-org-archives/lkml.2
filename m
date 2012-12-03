Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2LCOg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43851 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab2LCOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:45 -0500
Message-Id: <20121203143154.089088886@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 47/89] watchdog: using u64 in get_sample_period()
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit 8ffeb9b0e6369135bf03a073514f571ef10606b9 upstream.

In get_sample_period(), unsigned long is not enough:

  watchdog_thresh * 2 * (NSEC_PER_SEC / 5)

case1:
  watchdog_thresh is 10 by default, the sample value will be: 0xEE6B2800

case2:
 set watchdog_thresh is 20, the sample value will be: 0x1 DCD6 5000

In case2, we need use u64 to express the sample period.  Otherwise,
changing the threshold thru proc often can not be successful.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -113,7 +113,7 @@ static unsigned long get_timestamp(int t
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static unsigned long get_sample_period(void)
+static u64 get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -121,7 +121,7 @@ static unsigned long get_sample_period(v
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */


