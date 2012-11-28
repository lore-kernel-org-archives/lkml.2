Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab2K1CWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:22:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:63450 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab2K1CWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:22:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,174,1355126400"; 
   d="scan'208";a="248227231"
Subject: [PATCH V2] watchdog: optimizing the hrtimer interval for power
 saving
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: dzickus@redhat.com, akpm@linux-foundation.org
Cc: mingo@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
In-Reply-To: <1353602906.15558.1695.camel@cliu38-desktop-build>
References: <1353602906.15558.1695.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Nov 2012 19:24:52 +0800
Message-ID: <1354101892.15558.1699.camel@cliu38-desktop-build>
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
1s + 9s + 9s ...
Or
1s + 1s..+ 9s + 9s ....

For soft lockup detection, it will have more than 5 chances to
hit, once one chance is successful, we will start 9s hrtimer
instead of 1s;

For hard lockup dection, it will have more than 2 chances to hit,
As Don said, the min window is 10s just when CPU is always running
as MAX frequency. In most case, the window is 60s, so we should
have much more than 2 chances.

With this patch, in most cases the hrtimer will be 9s instead
of 4s averagely. It can save the device power indeed.

Change log:
Since V1: In V1, Don pointed out, "12 seconds will miss the window
          repeatedly." So here set the long period < min window 10s.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/watchdog.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dd4b80a..b37d682 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -125,7 +125,24 @@ static u64 get_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
+	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 20);
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
+	 * 9s = 10s - 1s, the reason is for covering the window
+	 * of nmi interrupt 10s interval.
+	 * So at least, for hard lockup, it has >=2 chances,
+	 * for soft lockup, it has >= 5 chances.
+	 *
+	 */
+	return (watchdog_thresh * (u64)NSEC_PER_SEC) - get_sample_period();
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



