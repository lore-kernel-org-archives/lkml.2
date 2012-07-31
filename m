Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2GaGgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:36:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43510 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2GaGgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:36:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [PATCH 2/2] [RFC] time: Limit time values that would overflow ktime_t
Date: Tue, 31 Jul 2012 02:35:48 -0400
Message-Id: <1343716548-38742-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073106-7408-0000-0000-00000739B20D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could observe unexpected behavior if the time is set
to a value large enough to overflow a 64bit ktime_t
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
Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 96179ab..78bccd0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -92,7 +92,7 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-
+#define TWENTY_YEARS (20LL*365*24*60*60)
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -387,6 +387,9 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
+	if ((unsigned long long)tv->tv_sec >= KTIME_SEC_MAX)
+		return -EINVAL;
+
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	timekeeping_forward_now();
@@ -418,6 +421,8 @@ EXPORT_SYMBOL(do_settimeofday);
 int timekeeping_inject_offset(struct timespec *ts)
 {
 	unsigned long flags;
+	struct timespec tmp;
+	int ret = 0;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
@@ -426,10 +431,17 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_forward_now();
 
-	timekeeper.xtime = timespec_add(timekeeper.xtime, *ts);
+	/* Make sure the increased value won't cause ktime_t trouble */
+	tmp = timespec_add(timekeeper.xtime, *ts);
+	if ((unsigned long long)tmp.tv_sec >= KTIME_SEC_MAX) {
+		ret= -EINVAL;
+		goto error;
+	}
+	timekeeper.xtime = tmp;
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
+error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -437,7 +449,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	/* signal hrtimers about time change */
 	clock_was_set();
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(timekeeping_inject_offset);
 
@@ -599,6 +611,16 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
+	/*
+	 * Check to make sure the persistent clock
+	 * didn't return something crazy.
+	 */
+	if (now.tv_sec > (KTIME_SEC_MAX - TWENTY_YEARS)) {
+		printk("WARNING: Persistent clock returned a year greater then"
+			" 2242. Capping at 2242.\n");
+		now.tv_sec = KTIME_SEC_MAX - TWENTY_YEARS;
+	}
+
 	seqlock_init(&timekeeper.lock);
 
 	ntp_init();
-- 
1.7.9.5

