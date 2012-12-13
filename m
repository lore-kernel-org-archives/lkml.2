Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2LMOTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:19:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460Ab2LMOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: liu chuansheng <chuansheng.liu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 227/241] watchdog: using u64 in get_sample_period()
Date: Thu, 13 Dec 2012 11:59:52 -0200
Message-Id: <1355407206-17100-228-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit 8ffeb9b0e6369135bf03a073514f571ef10606b9 usptream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4b1dfba..775fa0f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -113,7 +113,7 @@ static unsigned long get_timestamp(int this_cpu)
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static unsigned long get_sample_period(void)
+static u64 get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -122,7 +122,7 @@ static unsigned long get_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
-- 
1.7.9.5

