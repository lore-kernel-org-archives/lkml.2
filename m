Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628Ab0GSLff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:35:35 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:49217 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760609Ab0GSLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:35:23 -0400
X-IronPort-AV: E=Sophos;i="4.55,226,1278280800"; 
   d="scan'208";a="55778620"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 1/4] posix-timers: Refactoring of CPUCLOCK* macros
Date: Mon, 19 Jul 2010 13:34:46 +0200
Message-Id: <1279539289-27628-2-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>
References: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is merely a preparation to introduce wall time
clocks for threads/processes. All occurences of
CPUCLOCK* macros were replaced by CLOCK*.

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
---
 include/linux/posix-timers.h |   24 +++++-----
 include/linux/sched.h        |    2 +-
 kernel/itimer.c              |   14 +++---
 kernel/posix-cpu-timers.c    |   96 +++++++++++++++++++++---------------------
 4 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..02444c2 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -17,22 +17,22 @@ struct cpu_timer_list {
 	int firing;
 };
 
-#define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
-#define CPUCLOCK_PERTHREAD(clock) \
-	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
-#define CPUCLOCK_PID_MASK	7
-#define CPUCLOCK_PERTHREAD_MASK	4
-#define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
-#define CPUCLOCK_CLOCK_MASK	3
-#define CPUCLOCK_PROF		0
-#define CPUCLOCK_VIRT		1
-#define CPUCLOCK_SCHED		2
-#define CPUCLOCK_MAX		3
+#define CLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
+#define CLOCK_PERTHREAD(clock) \
+	(((clock) & (clockid_t) CLOCK_PERTHREAD_MASK) != 0)
+#define CLOCK_PID_MASK	7
+#define CLOCK_PERTHREAD_MASK	4
+#define CLOCK_WHICH(clock)	((clock) & (clockid_t) CLOCK_WHICH_MASK)
+#define CLOCK_WHICH_MASK	3
+#define CLOCK_PROF		0
+#define CLOCK_VIRT		1
+#define CLOCK_SCHED		2
+#define CLOCK_MAX		3
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
 #define MAKE_THREAD_CPUCLOCK(tid, clock) \
-	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_MASK)
+	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CLOCK_PERTHREAD_MASK)
 
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 747fcae..84a5fa7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -562,7 +562,7 @@ struct signal_struct {
 
 	/*
 	 * ITIMER_PROF and ITIMER_VIRTUAL timers for the process, we use
-	 * CPUCLOCK_PROF and CPUCLOCK_VIRT for indexing array as these
+	 * CLOCK_PROF and CLOCK_VIRT for indexing array as these
 	 * values are defined to 0 and 1 respectively
 	 */
 	struct cpu_itimer it[2];
diff --git a/kernel/itimer.c b/kernel/itimer.c
index d802883..17d65e1 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -57,10 +57,10 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 		cputime_t t;
 
 		thread_group_cputimer(tsk, &cputime);
-		if (clock_id == CPUCLOCK_PROF)
+		if (clock_id == CLOCK_PROF)
 			t = cputime_add(cputime.utime, cputime.stime);
 		else
-			/* CPUCLOCK_VIRT */
+			/* CLOCK_VIRT */
 			t = cputime.utime;
 
 		if (cputime_le(cval, t))
@@ -89,10 +89,10 @@ int do_getitimer(int which, struct itimerval *value)
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		get_cpu_itimer(tsk, CPUCLOCK_VIRT, value);
+		get_cpu_itimer(tsk, CLOCK_VIRT, value);
 		break;
 	case ITIMER_PROF:
-		get_cpu_itimer(tsk, CPUCLOCK_PROF, value);
+		get_cpu_itimer(tsk, CLOCK_PROF, value);
 		break;
 	default:
 		return(-EINVAL);
@@ -171,7 +171,7 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	it->incr = ninterval;
 	it->error = error;
 	it->incr_error = incr_error;
-	trace_itimer_state(clock_id == CPUCLOCK_VIRT ?
+	trace_itimer_state(clock_id == CLOCK_VIRT ?
 			   ITIMER_VIRTUAL : ITIMER_PROF, value, nval);
 
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -228,10 +228,10 @@ again:
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		set_cpu_itimer(tsk, CPUCLOCK_VIRT, value, ovalue);
+		set_cpu_itimer(tsk, CLOCK_VIRT, value, ovalue);
 		break;
 	case ITIMER_PROF:
-		set_cpu_itimer(tsk, CPUCLOCK_PROF, value, ovalue);
+		set_cpu_itimer(tsk, CLOCK_PROF, value, ovalue);
 		break;
 	default:
 		return -EINVAL;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9829646..03e8116 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -21,7 +21,7 @@ void update_rlimit_cpu(unsigned long rlim_new)
 	cputime_t cputime = secs_to_cputime(rlim_new);
 
 	spin_lock_irq(&current->sighand->siglock);
-	set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+	set_process_cpu_timer(current, CLOCK_PROF, &cputime, NULL);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -29,9 +29,9 @@ static int check_clock(const clockid_t which_clock)
 {
 	int error = 0;
 	struct task_struct *p;
-	const pid_t pid = CPUCLOCK_PID(which_clock);
+	const pid_t pid = CLOCK_PID(which_clock);
 
-	if (CPUCLOCK_WHICH(which_clock) >= CPUCLOCK_MAX)
+	if (CLOCK_WHICH(which_clock) >= CLOCK_MAX)
 		return -EINVAL;
 
 	if (pid == 0)
@@ -39,7 +39,7 @@ static int check_clock(const clockid_t which_clock)
 
 	read_lock(&tasklist_lock);
 	p = find_task_by_vpid(pid);
-	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
+	if (!p || !(CLOCK_PERTHREAD(which_clock) ?
 		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
@@ -53,7 +53,7 @@ timespec_to_sample(const clockid_t which_clock, const struct timespec *tp)
 {
 	union cpu_time_count ret;
 	ret.sched = 0;		/* high half always zero when .cpu used */
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
+	if (CLOCK_WHICH(which_clock) == CLOCK_SCHED) {
 		ret.sched = (unsigned long long)tp->tv_sec * NSEC_PER_SEC + tp->tv_nsec;
 	} else {
 		ret.cpu = timespec_to_cputime(tp);
@@ -65,7 +65,7 @@ static void sample_to_timespec(const clockid_t which_clock,
 			       union cpu_time_count cpu,
 			       struct timespec *tp)
 {
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED)
+	if (CLOCK_WHICH(which_clock) == CLOCK_SCHED)
 		*tp = ns_to_timespec(cpu.sched);
 	else
 		cputime_to_timespec(cpu.cpu, tp);
@@ -75,7 +75,7 @@ static inline int cpu_time_before(const clockid_t which_clock,
 				  union cpu_time_count now,
 				  union cpu_time_count then)
 {
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
+	if (CLOCK_WHICH(which_clock) == CLOCK_SCHED) {
 		return now.sched < then.sched;
 	}  else {
 		return cputime_lt(now.cpu, then.cpu);
@@ -85,7 +85,7 @@ static inline void cpu_time_add(const clockid_t which_clock,
 				union cpu_time_count *acc,
 			        union cpu_time_count val)
 {
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
+	if (CLOCK_WHICH(which_clock) == CLOCK_SCHED) {
 		acc->sched += val.sched;
 	}  else {
 		acc->cpu = cputime_add(acc->cpu, val.cpu);
@@ -95,7 +95,7 @@ static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
 						union cpu_time_count a,
 						union cpu_time_count b)
 {
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
+	if (CLOCK_WHICH(which_clock) == CLOCK_SCHED) {
 		a.sched -= b.sched;
 	}  else {
 		a.cpu = cputime_sub(a.cpu, b.cpu);
@@ -128,7 +128,7 @@ static void bump_cpu_timer(struct k_itimer *timer,
 	if (timer->it.cpu.incr.sched == 0)
 		return;
 
-	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
+	if (CLOCK_WHICH(timer->it_clock) == CLOCK_SCHED) {
 		unsigned long long delta, incr;
 
 		if (now.sched < timer->it.cpu.expires.sched)
@@ -182,7 +182,7 @@ int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	if (!error) {
 		tp->tv_sec = 0;
 		tp->tv_nsec = ((NSEC_PER_SEC + HZ - 1) / HZ);
-		if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
+		if (CLOCK_WHICH(which_clock) == CLOCK_SCHED) {
 			/*
 			 * If sched_clock is using a cycle counter, we
 			 * don't have any idea of its true resolution
@@ -214,16 +214,16 @@ int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 			    union cpu_time_count *cpu)
 {
-	switch (CPUCLOCK_WHICH(which_clock)) {
+	switch (CLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
-	case CPUCLOCK_PROF:
+	case CLOCK_PROF:
 		cpu->cpu = prof_ticks(p);
 		break;
-	case CPUCLOCK_VIRT:
+	case CLOCK_VIRT:
 		cpu->cpu = virt_ticks(p);
 		break;
-	case CPUCLOCK_SCHED:
+	case CLOCK_SCHED:
 		cpu->sched = task_sched_runtime(p);
 		break;
 	}
@@ -305,18 +305,18 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 {
 	struct task_cputime cputime;
 
-	switch (CPUCLOCK_WHICH(which_clock)) {
+	switch (CLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
-	case CPUCLOCK_PROF:
+	case CLOCK_PROF:
 		thread_group_cputime(p, &cputime);
 		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
-	case CPUCLOCK_VIRT:
+	case CLOCK_VIRT:
 		thread_group_cputime(p, &cputime);
 		cpu->cpu = cputime.utime;
 		break;
-	case CPUCLOCK_SCHED:
+	case CLOCK_SCHED:
 		cpu->sched = thread_group_sched_runtime(p);
 		break;
 	}
@@ -326,7 +326,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 
 int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
-	const pid_t pid = CPUCLOCK_PID(which_clock);
+	const pid_t pid = CLOCK_PID(which_clock);
 	int error = -EINVAL;
 	union cpu_time_count rtn;
 
@@ -335,7 +335,7 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 		 * Special case constant value for our own clocks.
 		 * We don't have to do any lookup to find ourselves.
 		 */
-		if (CPUCLOCK_PERTHREAD(which_clock)) {
+		if (CLOCK_PERTHREAD(which_clock)) {
 			/*
 			 * Sampling just ourselves we can do with no locking.
 			 */
@@ -356,7 +356,7 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (p) {
-			if (CPUCLOCK_PERTHREAD(which_clock)) {
+			if (CLOCK_PERTHREAD(which_clock)) {
 				if (same_thread_group(p, current)) {
 					error = cpu_clock_sample(which_clock,
 								 p, &rtn);
@@ -389,16 +389,16 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 int posix_cpu_timer_create(struct k_itimer *new_timer)
 {
 	int ret = 0;
-	const pid_t pid = CPUCLOCK_PID(new_timer->it_clock);
+	const pid_t pid = CLOCK_PID(new_timer->it_clock);
 	struct task_struct *p;
 
-	if (CPUCLOCK_WHICH(new_timer->it_clock) >= CPUCLOCK_MAX)
+	if (CLOCK_WHICH(new_timer->it_clock) >= CLOCK_MAX)
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 
 	read_lock(&tasklist_lock);
-	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
+	if (CLOCK_PERTHREAD(new_timer->it_clock)) {
 		if (pid == 0) {
 			p = current;
 		} else {
@@ -560,14 +560,14 @@ static void arm_timer(struct k_itimer *timer)
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
 
-	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+	if (CLOCK_PERTHREAD(timer->it_clock)) {
 		head = p->cpu_timers;
 		cputime_expires = &p->cputime_expires;
 	} else {
 		head = p->signal->cpu_timers;
 		cputime_expires = &p->signal->cputime_expires;
 	}
-	head += CPUCLOCK_WHICH(timer->it_clock);
+	head += CLOCK_WHICH(timer->it_clock);
 
 	listpos = head;
 	list_for_each_entry(next, head, entry) {
@@ -587,16 +587,16 @@ static void arm_timer(struct k_itimer *timer)
 		 * and RLIMIT_CPU and for thread timers with RLIMIT_RTTIME.
 		 */
 
-		switch (CPUCLOCK_WHICH(timer->it_clock)) {
-		case CPUCLOCK_PROF:
+		switch (CLOCK_WHICH(timer->it_clock)) {
+		case CLOCK_PROF:
 			if (expires_gt(cputime_expires->prof_exp, exp->cpu))
 				cputime_expires->prof_exp = exp->cpu;
 			break;
-		case CPUCLOCK_VIRT:
+		case CLOCK_VIRT:
 			if (expires_gt(cputime_expires->virt_exp, exp->cpu))
 				cputime_expires->virt_exp = exp->cpu;
 			break;
-		case CPUCLOCK_SCHED:
+		case CLOCK_SCHED:
 			if (cputime_expires->sched_exp == 0 ||
 			    cputime_expires->sched_exp > exp->sched)
 				cputime_expires->sched_exp = exp->sched;
@@ -650,16 +650,16 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 	struct task_cputime cputime;
 
 	thread_group_cputimer(p, &cputime);
-	switch (CPUCLOCK_WHICH(which_clock)) {
+	switch (CLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
-	case CPUCLOCK_PROF:
+	case CLOCK_PROF:
 		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
-	case CPUCLOCK_VIRT:
+	case CLOCK_VIRT:
 		cpu->cpu = cputime.utime;
 		break;
-	case CPUCLOCK_SCHED:
+	case CLOCK_SCHED:
 		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
@@ -724,7 +724,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 * times (in arm_timer).  With an absolute time, we must
 	 * check if it's already passed.  In short, we need a sample.
 	 */
-	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+	if (CLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &val);
 	} else {
 		cpu_timer_sample_group(timer->it_clock, p, &val);
@@ -858,7 +858,7 @@ void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	/*
 	 * Sample the clock to take the difference with the expiry time.
 	 */
-	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+	if (CLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 		clear_dead = p->exit_state;
 	} else {
@@ -1128,9 +1128,9 @@ static void check_process_timers(struct task_struct *tsk,
 	/*
 	 * Check for the special case process timers.
 	 */
-	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_PROF], &prof_expires, ptime,
+	check_cpu_itimer(tsk, &sig->it[CLOCK_PROF], &prof_expires, ptime,
 			 SIGPROF);
-	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
+	check_cpu_itimer(tsk, &sig->it[CLOCK_VIRT], &virt_expires, utime,
 			 SIGVTALRM);
 	soft = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 	if (soft != RLIM_INFINITY) {
@@ -1188,7 +1188,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
 	 */
-	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+	if (CLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		if (unlikely(p->exit_state)) {
@@ -1382,7 +1382,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 {
 	union cpu_time_count now;
 
-	BUG_ON(clock_idx == CPUCLOCK_SCHED);
+	BUG_ON(clock_idx == CLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
@@ -1410,11 +1410,11 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	 * RLIMIT_CPU limit is earlier than prof_exp cpu timer expire.
 	 */
 	switch (clock_idx) {
-	case CPUCLOCK_PROF:
+	case CLOCK_PROF:
 		if (expires_gt(tsk->signal->cputime_expires.prof_exp, *newval))
 			tsk->signal->cputime_expires.prof_exp = *newval;
 		break;
-	case CPUCLOCK_VIRT:
+	case CLOCK_VIRT:
 		if (expires_gt(tsk->signal->cputime_expires.virt_exp, *newval))
 			tsk->signal->cputime_expires.virt_exp = *newval;
 		break;
@@ -1498,9 +1498,9 @@ int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 	/*
 	 * Diagnose required errors first.
 	 */
-	if (CPUCLOCK_PERTHREAD(which_clock) &&
-	    (CPUCLOCK_PID(which_clock) == 0 ||
-	     CPUCLOCK_PID(which_clock) == current->pid))
+	if (CLOCK_PERTHREAD(which_clock) &&
+	    (CLOCK_PID(which_clock) == 0 ||
+	     CLOCK_PID(which_clock) == current->pid))
 		return -EINVAL;
 
 	error = do_cpu_nanosleep(which_clock, flags, rqtp, &it);
@@ -1557,8 +1557,8 @@ long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 }
 
 
-#define PROCESS_CLOCK	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED)
-#define THREAD_CLOCK	MAKE_THREAD_CPUCLOCK(0, CPUCLOCK_SCHED)
+#define PROCESS_CLOCK	MAKE_PROCESS_CPUCLOCK(0, CLOCK_SCHED)
+#define THREAD_CLOCK	MAKE_THREAD_CPUCLOCK(0, CLOCK_SCHED)
 
 static int process_cpu_clock_getres(const clockid_t which_clock,
 				    struct timespec *tp)
-- 
1.6.3.3

