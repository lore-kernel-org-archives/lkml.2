Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2KVTLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:11:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:57496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab2KVTLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:11:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,298,1352102400"; 
   d="scan'208";a="250943288"
Subject: [PATCH] watchdog: optimizing the hrtimer interval for power saving
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: akpm@linux-foundation.org, dzickus@redhat.com, mingo@kernel.org,
        rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Nov 2012 00:48:26 +0800
Message-ID: <1353602906.15558.1695.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By default, the watchdog threshold is 10, it means every 4s
every CPU will receive one hrtimer interrupt, for low power
device, it will cause 4-5mV power impact when device is deep
sleep.

So here want to optimize it as below:
4s + 4s + 4s + 4s + 4s
== >
12s + 2s + 2s + 2s + 2s
3/5   1/10 1/10 1/10 1/10

In 5 chances, once one chance is hit, then we can start the
hrtimer with a longer period sample(12s). Until the current
chance is not hit, will start the hrtimer with a shorted
period sample(2s).

With this patch, in most case the hrtimer will be 12s instead
of 4s averagely. It can save the device power indeed.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/watchdog.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dd4b80a..6457e62 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -125,7 +125,24 @@ static u64 get_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 10);
+}
+
+static u64 get_long_sample_period(void)
+{
+	/*
+	 * convert watchdog_thresh from seconds to ns
+	 * We want to give 5 chances to detect softlockup,
+	 * for power saving, once one chance is succeeding,
+	 * we can set long period to avoid power consumption.
+	 * Currently, set the long sample period is:
+	 * 20s * 3/5 = 12s, once this 12s chance is not hit,
+	 * we will divide the left 8s into 4 pieces, give every
+	 * chance every 2s, so it will be likely:
+	 * 12s + 2s + 2s + 2s + 2s,
+	 * Anyway, we just use 12s is enough in normal case.
+	 */
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC * 3 / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -267,6 +284,10 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
+	bool is_touched;
+
+	is_touched = (__this_cpu_read(hrtimer_interrupts) ==
+		__this_cpu_read(soft_lockup_hrtimer_cnt));
 
 	/* kick the hardlockup detector */
 	watchdog_interrupt_count();
@@ -275,7 +296,12 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	wake_up_process(__this_cpu_read(softlockup_watchdog));
 
 	/* .. and repeat */
-	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+	if (is_touched) {
+		hrtimer_forward_now(hrtimer,
+			ns_to_ktime(get_long_sample_period()));
+	} else {
+		hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+	}
 
 	if (touch_ts == 0) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
-- 
1.7.0.4



