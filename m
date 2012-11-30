Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2K3S6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:58:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:58794 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab2K3S5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:57:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        liu chuansheng <chuansheng.liu@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 49/56] watchdog: using u64 in get_sample_period()
Date: Fri, 30 Nov 2012 10:55:41 -0800
Message-Id: <20121130185123.328988171@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -112,7 +112,7 @@ static unsigned long get_timestamp(int t
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static unsigned long get_sample_period(void)
+static u64 get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -121,7 +121,7 @@ static unsigned long get_sample_period(v
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */


