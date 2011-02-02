Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1BBWEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:04:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:50108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab1BBWEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:04:05 -0500
Date: Wed, 2 Feb 2011 22:03:49 GMT
From: tip-bot for John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        richard.cochran@omicron.at
In-Reply-To: <20110201134419.584311693@linutronix.de>
References: <20110201134419.584311693@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Introduce timekeeping_inject_offset
Message-ID: <tip-c528f7c6c208f1fae6b4025957173dec045e5f21@git.kernel.org>
Git-Commit-ID: c528f7c6c208f1fae6b4025957173dec045e5f21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:03:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c528f7c6c208f1fae6b4025957173dec045e5f21
Gitweb:     http://git.kernel.org/tip/c528f7c6c208f1fae6b4025957173dec045e5f21
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Tue, 1 Feb 2011 13:52:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:18 +0100

time: Introduce timekeeping_inject_offset

This adds a kernel-internal timekeeping interface to add or subtract
a fixed amount from CLOCK_REALTIME. This makes it so kernel users or
interfaces trying to do so do not have to read the time, then add an
offset and then call settimeofday(), which adds some extra error in
comparision to just simply adding the offset in the kernel timekeeping
core.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134419.584311693@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 7c44e77..379b903 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -166,6 +166,7 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void timekeeping_leap_insert(int leapsecond);
+extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4f9f65b..6262c1d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -387,6 +387,42 @@ int do_settimeofday(const struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
+
+/**
+ * timekeeping_inject_offset - Adds or subtracts from the current time.
+ * @tv:		pointer to the timespec variable containing the offset
+ *
+ * Adds or subtracts an offset value from the current time.
+ */
+int timekeeping_inject_offset(struct timespec *ts)
+{
+	unsigned long flags;
+
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	timekeeping_forward_now();
+
+	xtime = timespec_add(xtime, *ts);
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
+
+	timekeeper.ntp_error = 0;
+	ntp_clear();
+
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+EXPORT_SYMBOL(timekeeping_inject_offset);
+
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
