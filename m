Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0GSLfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:35:37 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44855 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760610Ab0GSLfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:35:24 -0400
X-IronPort-AV: E=Sophos;i="4.55,226,1278280800"; 
   d="scan'208";a="55778622"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 2/4] posix-cpu-timers: Introduction of wall clocks
Date: Mon, 19 Jul 2010 13:34:47 +0200
Message-Id: <1279539289-27628-3-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr>
References: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>
 <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently Linux lacks a good way to get an elapsed time
of a process/thread. This patch adds the interface to
obtain this piece of information. The access to the new
thread/process clock is restricted according to the same
rules as the access to the CPU clocks.

CLOCK_WALL occupies previously unused value (CLOCK_MAX)
in the clockid_t representation of a clock.

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
---
 include/linux/posix-timers.h |   27 ++++++
 include/linux/time.h         |    2 +
 kernel/posix-cpu-timers.c    |  214 +++++++++++++++++++++++++++++++++++++++---
 kernel/posix-timers.c        |   25 ++++-
 4 files changed, 252 insertions(+), 16 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 02444c2..1282958 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -27,12 +27,22 @@ struct cpu_timer_list {
 #define CLOCK_PROF		0
 #define CLOCK_VIRT		1
 #define CLOCK_SCHED		2
+#define CLOCK_WALL		3
 #define CLOCK_MAX		3
 
+#define IS_CPU_CLOCK(clock)  ((clock) < 0 &&  \
+		(CLOCK_WHICH(clock) ^ CLOCK_WALL))
+#define IS_WALL_CLOCK(clock)  ((clock) < 0 && \
+		!(CLOCK_WHICH(clock) ^ CLOCK_WALL))
+
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
 #define MAKE_THREAD_CPUCLOCK(tid, clock) \
 	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CLOCK_PERTHREAD_MASK)
+#define MAKE_PROCESS_WALLCLOCK(pid) \
+	MAKE_PROCESS_CPUCLOCK(pid, CLOCK_WALL)
+#define MAKE_THREAD_WALLCLOCK(pid) \
+	MAKE_THREAD_CPUCLOCK(pid, CLOCK_WALL)
 
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
@@ -94,6 +104,8 @@ int do_posix_clock_nosettime(const clockid_t, struct timespec *tp);
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
 
+/* CPU clocks */
+
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
 int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
 int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
@@ -119,4 +131,19 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 
 void update_rlimit_cpu(unsigned long rlim_new);
 
+/* Wall clocks */
+
+int wall_clock_getres(clockid_t which_clock, struct timespec *tp);
+int wall_clock_get(clockid_t which_clock, struct timespec *tp);
+int wall_clock_set(const clockid_t which_clock, struct timespec *tp);
+int wall_nsleep(const clockid_t which_clock, int flags,
+		struct timespec *tsave, struct timespec __user *rmtp);
+long wall_nsleep_restart(struct restart_block *restart_block);
+int wall_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting);
+int wall_timer_create(struct k_itimer *new_timer);
+int wall_timer_set(struct k_itimer *timr, int flags,
+			struct itimerspec *new_setting,
+			struct itimerspec *old_setting);
+int wall_timer_del(struct k_itimer *timer);
+
 #endif
diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..596e6fb 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -275,6 +275,8 @@ struct itimerval {
 #define CLOCK_MONOTONIC_RAW		4
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
+#define CLOCK_PROCESS_WALLTIME_ID	7
+#define CLOCK_THREAD_WALLTIME_ID	8
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 03e8116..7495593 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -25,29 +25,201 @@ void update_rlimit_cpu(unsigned long rlim_new)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-static int check_clock(const clockid_t which_clock)
+static int check_task_clock(const clockid_t which_clock)
 {
 	int error = 0;
 	struct task_struct *p;
 	const pid_t pid = CLOCK_PID(which_clock);
 
-	if (CLOCK_WHICH(which_clock) >= CLOCK_MAX)
-		return -EINVAL;
-
 	if (pid == 0)
 		return 0;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (!p || !(CLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return error;
 }
 
+static inline int check_cpu_clock(const clockid_t which_clock)
+{
+	return !IS_CPU_CLOCK(which_clock) ?
+		-EINVAL : check_task_clock(which_clock);
+}
+
+static inline int check_wall_clock(const clockid_t which_clock)
+{
+	return !IS_WALL_CLOCK(which_clock) ?
+		-EINVAL : check_task_clock(which_clock);
+}
+
+/* Wall time clocks */
+
+/* Get the start time of the process/thread referenced by the wall clock.
+ * RCU lock required. */
+
+static int get_start_time(clockid_t which_clock, struct timespec *start)
+{
+	struct task_struct *p =
+		find_task_by_vpid(CLOCK_PID(which_clock));
+	if (p && (
+		(CLOCK_PERTHREAD(which_clock) &&
+			same_thread_group(p, current)) ||
+		(!CLOCK_PERTHREAD(which_clock) &&
+			thread_group_leader(p) && p->sighand))) {
+		*start = p->start_time;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/* monotonic clock is used to get start_time and uptime
+ * so the precision is twice the precision of the monotonic clock */
+
+int wall_clock_getres(clockid_t which_clock, struct timespec *tp)
+{
+	int error = check_wall_clock(which_clock);
+	if (error)
+		return error;
+	error = hrtimer_get_res(CLOCK_MONOTONIC, tp);
+	if (error)
+		return error;
+	*tp = timespec_add_safe(*tp, *tp);
+	return 0;
+}
+
+int wall_clock_get(clockid_t which_clock, struct timespec *tp)
+{
+	struct timespec uptime, start;
+	int error = -EINVAL;
+
+	if (!IS_WALL_CLOCK(which_clock))
+		return error;
+
+	if (CLOCK_PID(which_clock) == 0) {
+		start = (CLOCK_PERTHREAD(which_clock) ?
+			current : current->group_leader)->start_time;
+		error = 0;
+	} else {
+		rcu_read_lock();
+		error = get_start_time(which_clock, &start);
+		rcu_read_unlock();
+	}
+
+	if (error)
+		return error;
+
+	do_posix_clock_monotonic_gettime(&uptime);
+	*tp = timespec_sub(uptime, start);
+
+	return 0;
+}
+
+int wall_clock_set(const clockid_t which_clock,
+				   struct timespec *tp)
+{
+	return check_wall_clock(which_clock) ?: -EPERM;
+}
+
+int wall_nsleep(const clockid_t which_clock, int flags,
+		struct timespec *tsave, struct timespec __user *rmtp)
+{
+	if (!IS_WALL_CLOCK(which_clock))
+		return -EINVAL;
+
+	if (flags & TIMER_ABSTIME) {
+		int error;
+		struct timespec start;
+
+		rcu_read_lock();
+		error = get_start_time(which_clock, &start);
+		rcu_read_unlock();
+
+		if (error)
+			return error;
+		*tsave = timespec_add_safe(*tsave, start);
+	}
+	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
+				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
+				 CLOCK_MONOTONIC);
+}
+
+long wall_nsleep_restart(struct restart_block *restart_block)
+{
+	return -EINVAL;
+}
+
+int wall_timer_get(struct k_itimer *timr,
+		struct itimerspec *cur_setting)
+{
+	return -EINVAL;
+}
+
+int wall_timer_create(struct k_itimer *new_timer)
+{
+	return -EINVAL;
+}
+
+int wall_timer_set(struct k_itimer *timr, int flags,
+			struct itimerspec *new_setting,
+			struct itimerspec *old_setting)
+{
+	return -EINVAL;
+}
+
+int wall_timer_del(struct k_itimer *timer)
+{
+	return -EINVAL;
+}
+
+#define PROCESS_WALLCLOCK	MAKE_PROCESS_WALLCLOCK(0)
+#define THREAD_WALLCLOCK	MAKE_THREAD_WALLCLOCK(0)
+
+static int process_wall_getres(const clockid_t which_clock,
+				    struct timespec *tp)
+{
+	return wall_clock_getres(PROCESS_WALLCLOCK, tp);
+}
+static int process_wall_get(const clockid_t which_clock, struct timespec *tp)
+{
+	return wall_clock_get(PROCESS_WALLCLOCK, tp);
+}
+static int process_wall_nsleep(const clockid_t which_clock, int flags,
+			      struct timespec *rqtp,
+			      struct timespec __user *rmtp)
+{
+	return wall_nsleep(PROCESS_WALLCLOCK, flags, rqtp, rmtp);
+}
+static long process_wall_nsleep_restart(struct restart_block *restart_block)
+{
+	return -EINVAL;
+}
+static int thread_wall_getres(const clockid_t which_clock,
+				   struct timespec *tp)
+{
+	return wall_clock_getres(THREAD_WALLCLOCK, tp);
+}
+static int thread_wall_get(const clockid_t which_clock, struct timespec *tp)
+{
+	return wall_clock_get(THREAD_WALLCLOCK, tp);
+}
+static int thread_wall_nsleep(const clockid_t which_clock, int flags,
+			      struct timespec *rqtp,
+			      struct timespec __user *rmtp)
+{
+	return wall_nsleep(THREAD_WALLCLOCK, flags, rqtp, rmtp);
+}
+static long thread_wall_nsleep_restart(struct restart_block *restart_block)
+{
+	return -EINVAL;
+}
+
+/* CPU time clocks */
+
 static inline union cpu_time_count
 timespec_to_sample(const clockid_t which_clock, const struct timespec *tp)
 {
@@ -178,7 +350,7 @@ static inline cputime_t virt_ticks(struct task_struct *p)
 
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
-	int error = check_clock(which_clock);
+	int error = check_cpu_clock(which_clock);
 	if (!error) {
 		tp->tv_sec = 0;
 		tp->tv_nsec = ((NSEC_PER_SEC + HZ - 1) / HZ);
@@ -200,7 +372,7 @@ int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 	 * You can never reset a CPU clock, but we check for other errors
 	 * in the call before failing with EPERM.
 	 */
-	int error = check_clock(which_clock);
+	int error = check_cpu_clock(which_clock);
 	if (error == 0) {
 		error = -EPERM;
 	}
@@ -1612,7 +1784,7 @@ static long thread_cpu_nsleep_restart(struct restart_block *restart_block)
 
 static __init int init_posix_cpu_timers(void)
 {
-	struct k_clock process = {
+	struct k_clock cpu_process = {
 		.clock_getres = process_cpu_clock_getres,
 		.clock_get = process_cpu_clock_get,
 		.clock_set = do_posix_clock_nosettime,
@@ -1620,7 +1792,7 @@ static __init int init_posix_cpu_timers(void)
 		.nsleep = process_cpu_nsleep,
 		.nsleep_restart = process_cpu_nsleep_restart,
 	};
-	struct k_clock thread = {
+	struct k_clock cpu_thread = {
 		.clock_getres = thread_cpu_clock_getres,
 		.clock_get = thread_cpu_clock_get,
 		.clock_set = do_posix_clock_nosettime,
@@ -1628,10 +1800,28 @@ static __init int init_posix_cpu_timers(void)
 		.nsleep = thread_cpu_nsleep,
 		.nsleep_restart = thread_cpu_nsleep_restart,
 	};
+	struct k_clock wall_process = {
+		.clock_getres = process_wall_getres,
+		.clock_get = process_wall_get,
+		.clock_set = wall_clock_set,
+		.timer_create = wall_timer_create,
+		.nsleep = process_wall_nsleep,
+		.nsleep_restart = process_wall_nsleep_restart,
+	};
+	struct k_clock wall_thread = {
+		.clock_getres = thread_wall_getres,
+		.clock_get = thread_wall_get,
+		.clock_set = wall_clock_set,
+		.timer_create = wall_timer_create,
+		.nsleep = thread_wall_nsleep,
+		.nsleep_restart = thread_wall_nsleep_restart,
+	};
 	struct timespec ts;
 
-	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
-	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
+	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &cpu_process);
+	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &cpu_thread);
+	register_posix_clock(CLOCK_PROCESS_WALLTIME_ID, &wall_process);
+	register_posix_clock(CLOCK_THREAD_WALLTIME_ID, &wall_thread);
 
 	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ad72342..beaef9e 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -153,12 +153,29 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 }
 
 /*
+ * Call either POSIX CPU clocks or wall clocks.
+ */
+
+#define CLOCK_DISPATCH_PERTASK(clock, call, arglist) \
+	(IS_CPU_CLOCK(clock) ? \
+		posix_cpu_##call arglist : wall_##call arglist)
+
+/*
  * Call the k_clock hook function if non-null, or the default function.
  */
+
+#define CLOCK_DISPATCH_NORMAL(clock, call, arglist) \
+	(posix_clocks[clock].call != NULL ? \
+		(*posix_clocks[clock].call) arglist : common_##call arglist)
+
+/*
+ * Dispatch between thread/process clocks and global clocks.
+ */
+
 #define CLOCK_DISPATCH(clock, call, arglist) \
- 	((clock) < 0 ? posix_cpu_##call arglist : \
- 	 (posix_clocks[clock].call != NULL \
- 	  ? (*posix_clocks[clock].call) arglist : common_##call arglist))
+	((clock) < 0 ? \
+		CLOCK_DISPATCH_PERTASK((clock), call, arglist) : \
+		CLOCK_DISPATCH_NORMAL((clock), call, arglist))
 
 /*
  * Default clock hook functions when the struct k_clock passed
@@ -213,7 +230,7 @@ static int no_nsleep(const clockid_t which_clock, int flags,
  */
 static inline int invalid_clockid(const clockid_t which_clock)
 {
-	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
+	if (which_clock < 0)	/* per task clock, checked later */
 		return 0;
 	if ((unsigned) which_clock >= MAX_CLOCKS)
 		return 1;
-- 
1.6.3.3

