Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1BBV73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:59:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:50549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab1BBV7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:59:20 -0500
Date: Wed, 2 Feb 2011 21:59:06 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.518851246@linutronix.de>
References: <20110201134418.518851246@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Convert clock_settime to clockid_to_kclock()
Message-ID: <tip-26f9a4796af330173d790c8d2b5e2efcc489e755@git.kernel.org>
Git-Commit-ID: 26f9a4796af330173d790c8d2b5e2efcc489e755
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:59:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26f9a4796af330173d790c8d2b5e2efcc489e755
Gitweb:     http://git.kernel.org/tip/26f9a4796af330173d790c8d2b5e2efcc489e755
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:14 +0100

posix-timers: Convert clock_settime to clockid_to_kclock()

Use the new kclock decoding function in clock_settime and cleanup all
kclocks which use the default functions. Rename the misnomed
common_clock_set() to posix_clock_realtime_set().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.518851246@linutronix.de>
---
 include/linux/posix-timers.h |    3 ---
 kernel/posix-cpu-timers.c    |    2 --
 kernel/posix-timers.c        |   31 ++++++++++++-------------------
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index cd6da06..4aaf0c5 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -89,9 +89,6 @@ extern struct k_clock clock_posix_cpu;
 
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
-/* error handlers for timer_create, nanosleep and settime */
-int do_posix_clock_nosettime(const clockid_t, const struct timespec *tp);
-
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8dc4cd7..504fbab 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1604,7 +1604,6 @@ static __init int init_posix_cpu_timers(void)
 	struct k_clock process = {
 		.clock_getres	= process_cpu_clock_getres,
 		.clock_get	= process_cpu_clock_get,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= process_cpu_timer_create,
 		.nsleep		= process_cpu_nsleep,
 		.nsleep_restart	= process_cpu_nsleep_restart,
@@ -1612,7 +1611,6 @@ static __init int init_posix_cpu_timers(void)
 	struct k_clock thread = {
 		.clock_getres	= thread_cpu_clock_getres,
 		.clock_get	= thread_cpu_clock_get,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= thread_cpu_timer_create,
 	};
 	struct timespec ts;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4762986..49f358c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -199,12 +199,6 @@ static int common_clock_get(clockid_t which_clock, struct timespec *tp)
 	return 0;
 }
 
-static inline int common_clock_set(const clockid_t which_clock,
-				   const struct timespec *tp)
-{
-	return do_sys_settimeofday(tp, NULL);
-}
-
 static int common_timer_create(struct k_itimer *new_timer)
 {
 	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
@@ -232,6 +226,13 @@ static inline int invalid_clockid(const clockid_t which_clock)
 	return 1;
 }
 
+/* Set clock_realtime */
+static int posix_clock_realtime_set(const clockid_t which_clock,
+				    const struct timespec *tp)
+{
+	return do_sys_settimeofday(tp, NULL);
+}
+
 /*
  * Get monotonic time for posix timers
  */
@@ -276,32 +277,29 @@ static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
 		.clock_getres	= hrtimer_get_res,
+		.clock_set	= posix_clock_realtime_set,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_ktime_get_ts,
-		.clock_set	= do_posix_clock_nosettime,
 		.nsleep		= common_nsleep,
 		.nsleep_restart	= hrtimer_nanosleep_restart,
 	};
 	struct k_clock clock_monotonic_raw = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_monotonic_raw,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
 	};
 	struct k_clock clock_realtime_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_realtime_coarse,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
 	};
 	struct k_clock clock_monotonic_coarse = {
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
-		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= no_timer_create,
 	};
 
@@ -940,24 +938,19 @@ void exit_itimers(struct signal_struct *sig)
 	}
 }
 
-/* Not available / possible... functions */
-int do_posix_clock_nosettime(const clockid_t clockid, const struct timespec *tp)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(do_posix_clock_nosettime);
-
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 		const struct timespec __user *, tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec new_tp;
 
-	if (invalid_clockid(which_clock))
+	if (!kc || !kc->clock_set)
 		return -EINVAL;
+
 	if (copy_from_user(&new_tp, tp, sizeof (*tp)))
 		return -EFAULT;
 
-	return CLOCK_DISPATCH(which_clock, clock_set, (which_clock, &new_tp));
+	return kc->clock_set(which_clock, &new_tp);
 }
 
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
