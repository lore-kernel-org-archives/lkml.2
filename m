Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2LDB4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:56:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:19822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2LDB4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:56:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,211,1355126400"; 
   d="scan'208";a="251402012"
Subject: [PATCH] watchdog: store the watchdog sample period as a variable
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: dzickus@redhat.com, akpm@linux-foundation.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Dec 2012 18:58:42 +0800
Message-ID: <1354618722.15558.1705.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently getting the sample period is always thru complex
calculation: get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5).
But just like the watchdog_thresh, which is not changed often.

So we can store the sample period as a variable, and set it as
__read_mostly type.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/watchdog.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dd4b80a..7a32b20 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,6 +31,7 @@
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
 static int __read_mostly watchdog_disabled;
+static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -116,7 +117,7 @@ static unsigned long get_timestamp(int this_cpu)
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static u64 get_sample_period(void)
+static void set_sample_period(void)
 {
 	/*
 	 * convert watchdog_thresh from seconds to ns
@@ -125,7 +126,7 @@ static u64 get_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
+	sample_period = get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -275,7 +276,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	wake_up_process(__this_cpu_read(softlockup_watchdog));
 
 	/* .. and repeat */
-	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
 	if (touch_ts == 0) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
@@ -356,7 +357,7 @@ static void watchdog_enable(unsigned int cpu)
 	hrtimer->function = watchdog_timer_fn;
 
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
-	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
+	hrtimer_start(hrtimer, ns_to_ktime(sample_period),
 		      HRTIMER_MODE_REL_PINNED);
 
 	/* initialize timestamp */
@@ -383,7 +384,7 @@ static int watchdog_should_run(unsigned int cpu)
 /*
  * The watchdog thread function - touches the timestamp.
  *
- * It only runs once every get_sample_period() seconds (4 seconds by
+ * It only runs once every sample_period seconds (4 seconds by
  * default) to reset the softlockup timestamp. If this gets delayed
  * for more than 2*watchdog_thresh seconds then the debug-printout
  * triggers in watchdog_timer_fn().
@@ -516,6 +517,7 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 	if (ret || !write)
 		return ret;
 
+	set_sample_period();
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
@@ -537,6 +539,7 @@ static struct smp_hotplug_thread watchdog_threads = {
 
 void __init lockup_detector_init(void)
 {
+	set_sample_period();
 	if (smpboot_register_percpu_thread(&watchdog_threads)) {
 		pr_err("Failed to create watchdog threads, disabled\n");
 		watchdog_disabled = -ENODEV;
-- 
1.7.0.4



