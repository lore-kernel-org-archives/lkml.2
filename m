Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2KUByL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:54:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:55243 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2KUByJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:54:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,290,1352102400"; 
   d="scan'208";a="250295497"
Subject: [PATCH] watchdog: using u64 in get_sample_period()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: akpm@linux-foundation.org, dzickus@redhat.com, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Nov 2012 18:56:07 +0800
Message-ID: <1353495367.15558.1690.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In get_sample_period(), unsigned long is not enough:
watchdog_thresh * 2 * (NSEC_PER_SEC / 5)

case1: watchdog_thresh is 10 by default,
the sample value will be: 0xEE6B 2800

case2: set watchdog_thresh is 20,
the sample value will be: 0x1 DCD6 5000

>From case2, we need use u64 to express the sample period.
Otherwise, Changing the threshold thru proc often can
not be successful.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/watchdog.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 9d4c8d5..dd4b80a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -116,7 +116,7 @@ static unsigned long get_timestamp(int this_cpu)
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static unsigned long get_sample_period(void)
+static u64 get_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -125,7 +125,7 @@ static unsigned long get_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
-- 
1.7.0.4



