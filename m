Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2HAXVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:21:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49078 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2HAXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:21:30 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] time: Limit time values that would overflow ktime_t
Date: Wed,  1 Aug 2012 19:21:16 -0400
Message-Id: <1343863276-30340-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080123-5806-0000-0000-000017ED15AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo,
	This is against tip/timers/urgent. Let me know
if you'd like to see any further changes

-john

Unexpected behavior could occur if the time is set to
a value large enough to overflow a 64bit ktime_t
(which is something larger then the year 2264).

So check timekeeping inputs to make sure we don't set
the time to a value that overflows ktime_t.

Note: This does not protect from setting the time close to
overflowing ktime_t and then letting natural accumulation
cause the overflow.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: stable@vger.kernel.org
Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2988bc8..6a31968 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -88,6 +88,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+#define TWENTY_YEARS (20LL*365*24*60*60)
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -430,6 +432,9 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
+	if ((unsigned long long)tv->tv_sec >= KTIME_SEC_MAX)
+		return -EINVAL;
+
 	write_seqlock_irqsave(&tk->lock, flags);
 
 	timekeeping_forward_now(tk);
@@ -463,6 +468,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
+	long long tmp;
+	int ret = 0;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
@@ -471,10 +478,17 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_forward_now(tk);
 
+	/* Make sure the increased value won't cause ktime_t trouble */
+	tmp = tk->xtime_sec + ts->tv_sec;
+	if (tmp >= KTIME_SEC_MAX) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	tk_xtime_add(tk, ts);
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
+error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(tk, true);
 
 	write_sequnlock_irqrestore(&tk->lock, flags);
@@ -482,7 +496,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	/* signal hrtimers about time change */
 	clock_was_set();
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(timekeeping_inject_offset);
 
@@ -651,6 +665,16 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
+	/*
+	 * Check to make sure the persistent clock
+	 * didn't return something crazy.
+	 */
+	if (now.tv_sec > (KTIME_SEC_MAX - TWENTY_YEARS)) {
+		pr_warn("WARNING: Persistent clock returned > year 2242!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		now.tv_sec = KTIME_SEC_MAX - TWENTY_YEARS;
+	}
+
 	seqlock_init(&tk->lock);
 
 	ntp_init();
-- 
1.7.9.5

