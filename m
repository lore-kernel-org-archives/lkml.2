Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0ERP2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:28:15 -0400
Received: from www.tglx.de ([62.245.132.106]:54686 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab0ERP2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:28:12 -0400
Date: Tue, 18 May 2010 17:27:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT Pull] timer core for 2.6.35
Message-ID: <alpine.LFD.2.00.1005181725210.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1267210375-1274196436=:3368"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1267210375-1274196436=:3368
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
Arjan van de Ven (1):
      timers: Introduce the concept of timer slack for legacy timers

Carsten Emde (2):
      hrtimers: Provide schedule_hrtimeout for CLOCK_REALTIME
      mqueue: Convert message queue timeout to use hrtimers

John Stultz (6):
      time: Clean up warp_clock()
      time: Add xtime, wall_to_monotonic to feature-removal-schedule
      ntp: Make time_adjust static
      ntp: Remove tickadj
      time: Remove xtime_cache
      clocksource: Add clocksource_register_hz/khz interface

Stanislaw Gruszka (6):
      cpu-timers: Simplify RLIMIT_CPU handling
      cpu-timers: Cleanup arm_timer()
      cpu-timers: Return correct previous timer reload value
      cpu-timers: Change SIGEV_NONE timer implementation
      cpu-timers: Avoid iterating over all threads in fastpath_timer_check()
      posix-cpu-timers: Optimize run_posix_cpu_timers()

Thomas Gleixner (2):
      timer: Split out timer function call
      timer: Try to survive timer callback preempt_count leak

Uwe Kleine-König (1):
      timer: Print function name for timer callbacks modifying preemption count


 Documentation/feature-removal-schedule.txt |   10 +
 include/linux/clocksource.h                |   19 ++-
 include/linux/hrtimer.h                    |    2 +
 include/linux/time.h                       |    1 -
 include/linux/timer.h                      |   10 +-
 include/linux/timex.h                      |    5 -
 ipc/mqueue.c                               |   74 +++-----
 kernel/hrtimer.c                           |   67 ++++---
 kernel/posix-cpu-timers.c                  |  298 ++++++++++------------------
 kernel/time.c                              |   11 +-
 kernel/time/clocksource.c                  |   48 +++++
 kernel/time/ntp.c                          |    2 +-
 kernel/time/timekeeping.c                  |   35 ++--
 kernel/timer.c                             |  137 +++++++++----
 14 files changed, 376 insertions(+), 343 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 05df0b7..b93b781 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -564,6 +564,16 @@ Who:	Avi Kivity <avi@redhat.com>
 
 ----------------------------
 
+What:	xtime, wall_to_monotonic
+When:	2.6.36+
+Files:	kernel/time/timekeeping.c include/linux/time.h
+Why:	Cleaning up timekeeping internal values. Please use
+	existing timekeeping accessor functions to access
+	the equivalent functionality.
+Who:	John Stultz <johnstul@us.ibm.com>
+
+----------------------------
+
 What:	KVM kernel-allocated memory slots
 When:	July 2010
 Why:	Since 2.6.25, kvm supports user-allocated memory slots, which are
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..5ea3c60 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -273,7 +273,6 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 }
 
 
-/* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
@@ -287,6 +286,24 @@ extern void clocksource_mark_unstable(struct clocksource *cs);
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
+/*
+ * Don't call __clocksource_register_scale directly, use
+ * clocksource_register_hz/khz
+ */
+extern int
+__clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
+
+static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
+{
+	return __clocksource_register_scale(cs, 1, hz);
+}
+
+static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
+{
+	return __clocksource_register_scale(cs, 1000, khz);
+}
+
+
 static inline void
 clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 {
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 5d86fb2..fd0c1b8 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -422,6 +422,8 @@ extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 
 extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 						const enum hrtimer_mode mode);
+extern int schedule_hrtimeout_range_clock(ktime_t *expires,
+		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
 /* Soft interrupt function to run the hrtimer queues: */
diff --git a/include/linux/time.h b/include/linux/time.h
index 6e026e4..ea3559f 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -150,7 +150,6 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
-extern void update_xtime_cache(u64 nsec);
 extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
diff --git a/include/linux/timer.h b/include/linux/timer.h
index a2d1eb6..ea965b8 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -10,13 +10,19 @@
 struct tvec_base;
 
 struct timer_list {
+	/*
+	 * All fields that change during normal runtime grouped to the
+	 * same cacheline
+	 */
 	struct list_head entry;
 	unsigned long expires;
+	struct tvec_base *base;
 
 	void (*function)(unsigned long);
 	unsigned long data;
 
-	struct tvec_base *base;
+	int slack;
+
 #ifdef CONFIG_TIMER_STATS
 	void *start_site;
 	char start_comm[16];
@@ -165,6 +171,8 @@ extern int mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pending(struct timer_list *timer, unsigned long expires);
 extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
+extern void set_timer_slack(struct timer_list *time, int slack_hz);
+
 #define TIMER_NOT_PINNED	0
 #define TIMER_PINNED		1
 /*
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 7a082b3..32d852f 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -232,13 +232,11 @@ struct timex {
  */
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* ACTHZ          period (nsec) */
-extern int tickadj;			/* amount of adjustment per tick */
 
 /*
  * phase-lock loop variables
  */
 extern int time_status;		/* clock synchronization status bits */
-extern long time_adjust;	/* The amount of adjtime left */
 
 extern void ntp_init(void);
 extern void ntp_clear(void);
@@ -271,9 +269,6 @@ extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
 
-/* Don't use! Compatibility define for existing users. */
-#define tickadj	(500/HZ ? : 1)
-
 int read_current_timer(unsigned long *timer_val);
 
 /* The clock frequency of the i8253/i8254 PIT */
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 722b013..d6c09c4 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -429,7 +429,7 @@ static void wq_add(struct mqueue_inode_info *info, int sr,
  * sr: SEND or RECV
  */
 static int wq_sleep(struct mqueue_inode_info *info, int sr,
-			long timeout, struct ext_wait_queue *ewp)
+		    ktime_t *timeout, struct ext_wait_queue *ewp)
 {
 	int retval;
 	signed long time;
@@ -440,7 +440,8 @@ static int wq_sleep(struct mqueue_inode_info *info, int sr,
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
-		time = schedule_timeout(timeout);
+		time = schedule_hrtimeout_range_clock(timeout,
+		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
@@ -552,31 +553,16 @@ static void __do_notify(struct mqueue_inode_info *info)
 	wake_up(&info->wait_q);
 }
 
-static long prepare_timeout(struct timespec *p)
+static int prepare_timeout(const struct timespec __user *u_abs_timeout,
+			   ktime_t *expires, struct timespec *ts)
 {
-	struct timespec nowts;
-	long timeout;
-
-	if (p) {
-		if (unlikely(p->tv_nsec < 0 || p->tv_sec < 0
-			|| p->tv_nsec >= NSEC_PER_SEC))
-			return -EINVAL;
-		nowts = CURRENT_TIME;
-		/* first subtract as jiffies can't be too big */
-		p->tv_sec -= nowts.tv_sec;
-		if (p->tv_nsec < nowts.tv_nsec) {
-			p->tv_nsec += NSEC_PER_SEC;
-			p->tv_sec--;
-		}
-		p->tv_nsec -= nowts.tv_nsec;
-		if (p->tv_sec < 0)
-			return 0;
-
-		timeout = timespec_to_jiffies(p) + 1;
-	} else
-		return MAX_SCHEDULE_TIMEOUT;
+	if (copy_from_user(ts, u_abs_timeout, sizeof(struct timespec)))
+		return -EFAULT;
+	if (!timespec_valid(ts))
+		return -EINVAL;
 
-	return timeout;
+	*expires = timespec_to_ktime(*ts);
+	return 0;
 }
 
 static void remove_notification(struct mqueue_inode_info *info)
@@ -862,22 +848,21 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	struct ext_wait_queue *receiver;
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
-	struct timespec ts, *p = NULL;
-	long timeout;
+	ktime_t expires, *timeout = NULL;
+	struct timespec ts;
 	int ret;
 
 	if (u_abs_timeout) {
-		if (copy_from_user(&ts, u_abs_timeout, 
-					sizeof(struct timespec)))
-			return -EFAULT;
-		p = &ts;
+		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
+		if (res)
+			return res;
+		timeout = &expires;
 	}
 
 	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
 		return -EINVAL;
 
-	audit_mq_sendrecv(mqdes, msg_len, msg_prio, p);
-	timeout = prepare_timeout(p);
+	audit_mq_sendrecv(mqdes, msg_len, msg_prio, timeout ? &ts : NULL);
 
 	filp = fget(mqdes);
 	if (unlikely(!filp)) {
@@ -919,9 +904,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
@@ -954,24 +936,23 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		size_t, msg_len, unsigned int __user *, u_msg_prio,
 		const struct timespec __user *, u_abs_timeout)
 {
-	long timeout;
 	ssize_t ret;
 	struct msg_msg *msg_ptr;
 	struct file *filp;
 	struct inode *inode;
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
-	struct timespec ts, *p = NULL;
+	ktime_t expires, *timeout = NULL;
+	struct timespec ts;
 
 	if (u_abs_timeout) {
-		if (copy_from_user(&ts, u_abs_timeout, 
-					sizeof(struct timespec)))
-			return -EFAULT;
-		p = &ts;
+		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
+		if (res)
+			return res;
+		timeout = &expires;
 	}
 
-	audit_mq_sendrecv(mqdes, msg_len, 0, p);
-	timeout = prepare_timeout(p);
+	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
 
 	filp = fget(mqdes);
 	if (unlikely(!filp)) {
@@ -1003,11 +984,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-			msg_ptr = NULL;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
-			msg_ptr = NULL;
 		} else {
 			wait.task = current;
 			wait.state = STATE_NONE;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..b9b134b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1749,35 +1749,15 @@ void __init hrtimers_init(void)
 }
 
 /**
- * schedule_hrtimeout_range - sleep until timeout
+ * schedule_hrtimeout_range_clock - sleep until timeout
  * @expires:	timeout value (ktime_t)
  * @delta:	slack in expires timeout (ktime_t)
  * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
- *
- * Make the current task sleep until the given expiry time has
- * elapsed. The routine will return immediately unless
- * the current task state has been set (see set_current_state()).
- *
- * The @delta argument gives the kernel the freedom to schedule the
- * actual wakeup to a time that is both power and performance friendly.
- * The kernel give the normal best effort behavior for "@expires+@delta",
- * but may decide to fire the timer earlier, but no earlier than @expires.
- *
- * You can set the task state as follows -
- *
- * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
- * pass before the routine returns.
- *
- * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
- * delivered to the current task.
- *
- * The current task state is guaranteed to be TASK_RUNNING when this
- * routine returns.
- *
- * Returns 0 when the timer has expired otherwise -EINTR
+ * @clock:	timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
  */
-int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
-			       const enum hrtimer_mode mode)
+int __sched
+schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
+			       const enum hrtimer_mode mode, int clock)
 {
 	struct hrtimer_sleeper t;
 
@@ -1799,7 +1779,7 @@ int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 		return -EINTR;
 	}
 
-	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, mode);
+	hrtimer_init_on_stack(&t.timer, clock, mode);
 	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 
 	hrtimer_init_sleeper(&t, current);
@@ -1818,6 +1798,41 @@ int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
 
 	return !t.task ? 0 : -EINTR;
 }
+
+/**
+ * schedule_hrtimeout_range - sleep until timeout
+ * @expires:	timeout value (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t)
+ * @mode:	timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
+ *
+ * Make the current task sleep until the given expiry time has
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * The @delta argument gives the kernel the freedom to schedule the
+ * actual wakeup to a time that is both power and performance friendly.
+ * The kernel give the normal best effort behavior for "@expires+@delta",
+ * but may decide to fire the timer earlier, but no earlier than @expires.
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout time is guaranteed to
+ * pass before the routine returns.
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task.
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Returns 0 when the timer has expired otherwise -EINTR
+ */
+int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
+				     const enum hrtimer_mode mode)
+{
+	return schedule_hrtimeout_range_clock(expires, delta, mode,
+					      CLOCK_MONOTONIC);
+}
 EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
 
 /**
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bc7704b..00bb252 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -11,19 +11,18 @@
 #include <trace/events/timer.h>
 
 /*
- * Called after updating RLIMIT_CPU to set timer expiration if necessary.
+ * Called after updating RLIMIT_CPU to run cpu timer and update
+ * tsk->signal->cputime_expires expiration cache if necessary. Needs
+ * siglock protection since other code may update expiration cache as
+ * well.
  */
 void update_rlimit_cpu(unsigned long rlim_new)
 {
 	cputime_t cputime = secs_to_cputime(rlim_new);
-	struct signal_struct *const sig = current->signal;
 
-	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
-	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
-		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	spin_lock_irq(&current->sighand->siglock);
+	set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+	spin_unlock_irq(&current->sighand->siglock);
 }
 
 static int check_clock(const clockid_t which_clock)
@@ -548,111 +547,62 @@ static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 	       cputime_gt(expires, new_exp);
 }
 
-static inline int expires_le(cputime_t expires, cputime_t new_exp)
-{
-	return !cputime_eq(expires, cputime_zero) &&
-	       cputime_le(expires, new_exp);
-}
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
- * for reading, and interrupts disabled.
+ * for reading, interrupts disabled and p->sighand->siglock taken.
  */
-static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
+static void arm_timer(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	struct list_head *head, *listpos;
+	struct task_cputime *cputime_expires;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
-	unsigned long i;
 
-	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
-		p->cpu_timers : p->signal->cpu_timers);
+	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+		head = p->cpu_timers;
+		cputime_expires = &p->cputime_expires;
+	} else {
+		head = p->signal->cpu_timers;
+		cputime_expires = &p->signal->cputime_expires;
+	}
 	head += CPUCLOCK_WHICH(timer->it_clock);
 
-	BUG_ON(!irqs_disabled());
-	spin_lock(&p->sighand->siglock);
-
 	listpos = head;
-	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
-		list_for_each_entry(next, head, entry) {
-			if (next->expires.sched > nt->expires.sched)
-				break;
-			listpos = &next->entry;
-		}
-	} else {
-		list_for_each_entry(next, head, entry) {
-			if (cputime_gt(next->expires.cpu, nt->expires.cpu))
-				break;
-			listpos = &next->entry;
-		}
+	list_for_each_entry(next, head, entry) {
+		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
+			break;
+		listpos = &next->entry;
 	}
 	list_add(&nt->entry, listpos);
 
 	if (listpos == head) {
+		union cpu_time_count *exp = &nt->expires;
+
 		/*
-		 * We are the new earliest-expiring timer.
-		 * If we are a thread timer, there can always
-		 * be a process timer telling us to stop earlier.
+		 * We are the new earliest-expiring POSIX 1.b timer, hence
+		 * need to update expiration cache. Take into account that
+		 * for process timers we share expiration cache with itimers
+		 * and RLIMIT_CPU and for thread timers with RLIMIT_RTTIME.
 		 */
 
-		if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-			union cpu_time_count *exp = &nt->expires;
-
-			switch (CPUCLOCK_WHICH(timer->it_clock)) {
-			default:
-				BUG();
-			case CPUCLOCK_PROF:
-				if (expires_gt(p->cputime_expires.prof_exp,
-					       exp->cpu))
-					p->cputime_expires.prof_exp = exp->cpu;
-				break;
-			case CPUCLOCK_VIRT:
-				if (expires_gt(p->cputime_expires.virt_exp,
-					       exp->cpu))
-					p->cputime_expires.virt_exp = exp->cpu;
-				break;
-			case CPUCLOCK_SCHED:
-				if (p->cputime_expires.sched_exp == 0 ||
-				    p->cputime_expires.sched_exp > exp->sched)
-					p->cputime_expires.sched_exp =
-								exp->sched;
-				break;
-			}
-		} else {
-			struct signal_struct *const sig = p->signal;
-			union cpu_time_count *exp = &timer->it.cpu.expires;
-
-			/*
-			 * For a process timer, set the cached expiration time.
-			 */
-			switch (CPUCLOCK_WHICH(timer->it_clock)) {
-			default:
-				BUG();
-			case CPUCLOCK_VIRT:
-				if (expires_le(sig->it[CPUCLOCK_VIRT].expires,
-					       exp->cpu))
-					break;
-				sig->cputime_expires.virt_exp = exp->cpu;
-				break;
-			case CPUCLOCK_PROF:
-				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
-					       exp->cpu))
-					break;
-				i = sig->rlim[RLIMIT_CPU].rlim_cur;
-				if (i != RLIM_INFINITY &&
-				    i <= cputime_to_secs(exp->cpu))
-					break;
-				sig->cputime_expires.prof_exp = exp->cpu;
-				break;
-			case CPUCLOCK_SCHED:
-				sig->cputime_expires.sched_exp = exp->sched;
-				break;
-			}
+		switch (CPUCLOCK_WHICH(timer->it_clock)) {
+		case CPUCLOCK_PROF:
+			if (expires_gt(cputime_expires->prof_exp, exp->cpu))
+				cputime_expires->prof_exp = exp->cpu;
+			break;
+		case CPUCLOCK_VIRT:
+			if (expires_gt(cputime_expires->virt_exp, exp->cpu))
+				cputime_expires->virt_exp = exp->cpu;
+			break;
+		case CPUCLOCK_SCHED:
+			if (cputime_expires->sched_exp == 0 ||
+			    cputime_expires->sched_exp > exp->sched)
+				cputime_expires->sched_exp = exp->sched;
+			break;
 		}
 	}
-
-	spin_unlock(&p->sighand->siglock);
 }
 
 /*
@@ -660,7 +610,12 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
  */
 static void cpu_timer_fire(struct k_itimer *timer)
 {
-	if (unlikely(timer->sigq == NULL)) {
+	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
+		/*
+		 * User don't want any signal.
+		 */
+		timer->it.cpu.expires.sched = 0;
+	} else if (unlikely(timer->sigq == NULL)) {
 		/*
 		 * This a special case for clock_nanosleep,
 		 * not a normal timer from sys_timer_create.
@@ -721,7 +676,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count old_expires, new_expires, val;
+	union cpu_time_count old_expires, new_expires, old_incr, val;
 	int ret;
 
 	if (unlikely(p == NULL)) {
@@ -752,6 +707,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	BUG_ON(!irqs_disabled());
 
 	ret = 0;
+	old_incr = timer->it.cpu.incr;
 	spin_lock(&p->sighand->siglock);
 	old_expires = timer->it.cpu.expires;
 	if (unlikely(timer->it.cpu.firing)) {
@@ -759,7 +715,6 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		ret = TIMER_RETRY;
 	} else
 		list_del_init(&timer->it.cpu.entry);
-	spin_unlock(&p->sighand->siglock);
 
 	/*
 	 * We need to sample the current value to convert the new
@@ -813,6 +768,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		 * disable this firing since we are already reporting
 		 * it as an overrun (thanks to bump_cpu_timer above).
 		 */
+		spin_unlock(&p->sighand->siglock);
 		read_unlock(&tasklist_lock);
 		goto out;
 	}
@@ -828,11 +784,11 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 */
 	timer->it.cpu.expires = new_expires;
 	if (new_expires.sched != 0 &&
-	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    cpu_time_before(timer->it_clock, val, new_expires)) {
-		arm_timer(timer, val);
+		arm_timer(timer);
 	}
 
+	spin_unlock(&p->sighand->siglock);
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -853,7 +809,6 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	timer->it_overrun = -1;
 
 	if (new_expires.sched != 0 &&
-	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    !cpu_time_before(timer->it_clock, val, new_expires)) {
 		/*
 		 * The designated time already passed, so we notify
@@ -867,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
  out:
 	if (old) {
 		sample_to_timespec(timer->it_clock,
-				   timer->it.cpu.incr, &old->it_interval);
+				   old_incr, &old->it_interval);
 	}
 	return ret;
 }
@@ -927,25 +882,6 @@ void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		read_unlock(&tasklist_lock);
 	}
 
-	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
-		if (timer->it.cpu.incr.sched == 0 &&
-		    cpu_time_before(timer->it_clock,
-				    timer->it.cpu.expires, now)) {
-			/*
-			 * Do-nothing timer expired and has no reload,
-			 * so it's as if it was never set.
-			 */
-			timer->it.cpu.expires.sched = 0;
-			itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
-			return;
-		}
-		/*
-		 * Account for any expirations and reloads that should
-		 * have happened.
-		 */
-		bump_cpu_timer(timer, now);
-	}
-
 	if (unlikely(clear_dead)) {
 		/*
 		 * We've noticed that the thread is dead, but
@@ -1066,16 +1002,9 @@ static void stop_process_timers(struct signal_struct *sig)
 	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
-	if (!cputimer->running)
-		return;
-
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
-
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1112,6 +1041,23 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 	}
 }
 
+/**
+ * task_cputime_zero - Check a task_cputime struct for all zero fields.
+ *
+ * @cputime:	The struct to compare.
+ *
+ * Checks @cputime to see if all fields are zero.  Returns true if all fields
+ * are zero, false if any field is nonzero.
+ */
+static inline int task_cputime_zero(const struct task_cputime *cputime)
+{
+	if (cputime_eq(cputime->utime, cputime_zero) &&
+	    cputime_eq(cputime->stime, cputime_zero) &&
+	    cputime->sum_exec_runtime == 0)
+		return 1;
+	return 0;
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1129,19 +1075,6 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long soft;
 
 	/*
-	 * Don't sample the current process CPU clocks if there are no timers.
-	 */
-	if (list_empty(&timers[CPUCLOCK_PROF]) &&
-	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
-	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
-	    list_empty(&timers[CPUCLOCK_VIRT]) &&
-	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
-	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(sig);
-		return;
-	}
-
-	/*
 	 * Collect the current process totals.
 	 */
 	thread_group_cputimer(tsk, &cputime);
@@ -1230,18 +1163,11 @@ static void check_process_timers(struct task_struct *tsk,
 		}
 	}
 
-	if (!cputime_eq(prof_expires, cputime_zero) &&
-	    (cputime_eq(sig->cputime_expires.prof_exp, cputime_zero) ||
-	     cputime_gt(sig->cputime_expires.prof_exp, prof_expires)))
-		sig->cputime_expires.prof_exp = prof_expires;
-	if (!cputime_eq(virt_expires, cputime_zero) &&
-	    (cputime_eq(sig->cputime_expires.virt_exp, cputime_zero) ||
-	     cputime_gt(sig->cputime_expires.virt_exp, virt_expires)))
-		sig->cputime_expires.virt_exp = virt_expires;
-	if (sched_expires != 0 &&
-	    (sig->cputime_expires.sched_exp == 0 ||
-	     sig->cputime_expires.sched_exp > sched_expires))
-		sig->cputime_expires.sched_exp = sched_expires;
+	sig->cputime_expires.prof_exp = prof_expires;
+	sig->cputime_expires.virt_exp = virt_expires;
+	sig->cputime_expires.sched_exp = sched_expires;
+	if (task_cputime_zero(&sig->cputime_expires))
+		stop_process_timers(sig);
 }
 
 /*
@@ -1270,6 +1196,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			goto out;
 		}
 		read_lock(&tasklist_lock); /* arm_timer needs it.  */
+		spin_lock(&p->sighand->siglock);
 	} else {
 		read_lock(&tasklist_lock);
 		if (unlikely(p->signal == NULL)) {
@@ -1290,6 +1217,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
+		spin_lock(&p->sighand->siglock);
 		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		/* Leave the tasklist_lock locked for the call below.  */
@@ -1298,7 +1226,9 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
-	arm_timer(timer, now);
+	BUG_ON(!irqs_disabled());
+	arm_timer(timer);
+	spin_unlock(&p->sighand->siglock);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -1310,23 +1240,6 @@ out:
 }
 
 /**
- * task_cputime_zero - Check a task_cputime struct for all zero fields.
- *
- * @cputime:	The struct to compare.
- *
- * Checks @cputime to see if all fields are zero.  Returns true if all fields
- * are zero, false if any field is nonzero.
- */
-static inline int task_cputime_zero(const struct task_cputime *cputime)
-{
-	if (cputime_eq(cputime->utime, cputime_zero) &&
-	    cputime_eq(cputime->stime, cputime_zero) &&
-	    cputime->sum_exec_runtime == 0)
-		return 1;
-	return 0;
-}
-
-/**
  * task_cputime_expired - Compare two task_cputime entities.
  *
  * @sample:	The task_cputime structure to be checked for expiration.
@@ -1382,7 +1295,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	}
 
 	sig = tsk->signal;
-	if (!task_cputime_zero(&sig->cputime_expires)) {
+	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
 		thread_group_cputimer(tsk, &group_sample);
@@ -1390,7 +1303,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 			return 1;
 	}
 
-	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
+	return 0;
 }
 
 /*
@@ -1419,7 +1332,12 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * put them on the firing list.
 	 */
 	check_thread_timers(tsk, &firing);
-	check_process_timers(tsk, &firing);
+	/*
+	 * If there are any active process wide timers (POSIX 1.b, itimers,
+	 * RLIMIT_CPU) cputimer must be running.
+	 */
+	if (tsk->signal->cputimer.running)
+		check_process_timers(tsk, &firing);
 
 	/*
 	 * We must release these locks before taking any timer's lock.
@@ -1456,21 +1374,23 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 }
 
 /*
- * Set one of the process-wide special case CPU timers.
+ * Set one of the process-wide special case CPU timers or RLIMIT_CPU.
  * The tsk->sighand->siglock must be held by the caller.
- * The *newval argument is relative and we update it to be absolute, *oldval
- * is absolute and we update it to be relative.
  */
 void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval)
 {
 	union cpu_time_count now;
-	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
+		/*
+		 * We are setting itimer. The *oldval is absolute and we update
+		 * it to be relative, *newval argument is relative and we update
+		 * it to be absolute.
+		 */
 		if (!cputime_eq(*oldval, cputime_zero)) {
 			if (cputime_le(*oldval, now.cpu)) {
 				/* Just about to fire. */
@@ -1483,33 +1403,21 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		if (cputime_eq(*newval, cputime_zero))
 			return;
 		*newval = cputime_add(*newval, now.cpu);
-
-		/*
-		 * If the RLIMIT_CPU timer will expire before the
-		 * ITIMER_PROF timer, we have nothing else to do.
-		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
-		    < cputime_to_secs(*newval))
-			return;
 	}
 
 	/*
-	 * Check whether there are any process timers already set to fire
-	 * before this one.  If so, we don't have anything more to do.
+	 * Update expiration cache if we are the earliest timer, or eventually
+	 * RLIMIT_CPU limit is earlier than prof_exp cpu timer expire.
 	 */
-	head = &tsk->signal->cpu_timers[clock_idx];
-	if (list_empty(head) ||
-	    cputime_ge(list_first_entry(head,
-				  struct cpu_timer_list, entry)->expires.cpu,
-		       *newval)) {
-		switch (clock_idx) {
-		case CPUCLOCK_PROF:
+	switch (clock_idx) {
+	case CPUCLOCK_PROF:
+		if (expires_gt(tsk->signal->cputime_expires.prof_exp, *newval))
 			tsk->signal->cputime_expires.prof_exp = *newval;
-			break;
-		case CPUCLOCK_VIRT:
+		break;
+	case CPUCLOCK_VIRT:
+		if (expires_gt(tsk->signal->cputime_expires.virt_exp, *newval))
 			tsk->signal->cputime_expires.virt_exp = *newval;
-			break;
-		}
+		break;
 	}
 }
 
diff --git a/kernel/time.c b/kernel/time.c
index 656dccf..50612fa 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -132,12 +132,11 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
  */
 static inline void warp_clock(void)
 {
-	write_seqlock_irq(&xtime_lock);
-	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
-	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
+	struct timespec delta, adjust;
+	delta.tv_sec = sys_tz.tz_minuteswest * 60;
+	delta.tv_nsec = 0;
+	adjust = timespec_add_safe(current_kernel_time(), delta);
+	do_settimeofday(&adjust);
 }
 
 /*
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..f08e99c 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -625,6 +625,54 @@ static void clocksource_enqueue(struct clocksource *cs)
 	list_add(&cs->list, entry);
 }
 
+
+/*
+ * Maximum time we expect to go between ticks. This includes idle
+ * tickless time. It provides the trade off between selecting a
+ * mult/shift pair that is very precise but can only handle a short
+ * period of time, vs. a mult/shift pair that can handle long periods
+ * of time but isn't as precise.
+ *
+ * This is a subsystem constant, and actual hardware limitations
+ * may override it (ie: clocksources that wrap every 3 seconds).
+ */
+#define MAX_UPDATE_LENGTH 5 /* Seconds */
+
+/**
+ * __clocksource_register_scale - Used to install new clocksources
+ * @t:		clocksource to be registered
+ * @scale:	Scale factor multiplied against freq to get clocksource hz
+ * @freq:	clocksource frequency (cycles per second) divided by scale
+ *
+ * Returns -EBUSY if registration fails, zero otherwise.
+ *
+ * This *SHOULD NOT* be called directly! Please use the
+ * clocksource_register_hz() or clocksource_register_khz helper functions.
+ */
+int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+{
+
+	/*
+	 * Ideally we want to use  some of the limits used in
+	 * clocksource_max_deferment, to provide a more informed
+	 * MAX_UPDATE_LENGTH. But for now this just gets the
+	 * register interface working properly.
+	 */
+	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
+				      NSEC_PER_SEC/scale,
+				      MAX_UPDATE_LENGTH*scale);
+	cs->max_idle_ns = clocksource_max_deferment(cs);
+
+	mutex_lock(&clocksource_mutex);
+	clocksource_enqueue(cs);
+	clocksource_select();
+	clocksource_enqueue_watchdog(cs);
+	mutex_unlock(&clocksource_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__clocksource_register_scale);
+
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 7c0f180..c631168 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -69,7 +69,7 @@ static s64			time_freq;
 /* time at last adjustment (secs):					*/
 static long			time_reftime;
 
-long				time_adjust;
+static long			time_adjust;
 
 /* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
 static s64			ntp_tick_adj;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 39f6177..caf8d4d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -165,13 +165,6 @@ struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
-void update_xtime_cache(u64 nsec)
-{
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
-}
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
@@ -332,8 +325,6 @@ int do_settimeofday(struct timespec *tv)
 
 	xtime = *tv;
 
-	update_xtime_cache(0);
-
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
@@ -559,7 +550,6 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -593,7 +583,6 @@ static int timekeeping_resume(struct sys_device *dev)
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
 		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
 	}
-	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
@@ -788,7 +777,6 @@ void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
-	u64 nsecs;
 	int shift = 0, maxshift;
 
 	/* Make sure we're fully resumed: */
@@ -847,7 +835,9 @@ void update_wall_time(void)
 		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
 	}
 
-	/* store full nanoseconds into xtime after rounding it up and
+
+	/*
+	 * Store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
 	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
@@ -855,8 +845,15 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
-	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
-	update_xtime_cache(nsecs);
+	/*
+	 * Finally, make sure that after the rounding
+	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
+	 */
+	if (unlikely(xtime.tv_nsec >= NSEC_PER_SEC)) {
+		xtime.tv_nsec -= NSEC_PER_SEC;
+		xtime.tv_sec++;
+		second_overflow();
+	}
 
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
@@ -896,13 +893,13 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return xtime_cache.tv_sec;
+	return xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return xtime_cache;
+	return xtime;
 }
 
 struct timespec current_kernel_time(void)
@@ -913,7 +910,7 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	return now;
@@ -928,7 +925,7 @@ struct timespec get_monotonic_coarse(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime_cache;
+		now = xtime;
 		mono = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
diff --git a/kernel/timer.c b/kernel/timer.c
index aeb6a54..9199f3c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -319,6 +319,24 @@ unsigned long round_jiffies_up_relative(unsigned long j)
 }
 EXPORT_SYMBOL_GPL(round_jiffies_up_relative);
 
+/**
+ * set_timer_slack - set the allowed slack for a timer
+ * @slack_hz: the amount of time (in jiffies) allowed for rounding
+ *
+ * Set the amount of time, in jiffies, that a certain timer has
+ * in terms of slack. By setting this value, the timer subsystem
+ * will schedule the actual timer somewhere between
+ * the time mod_timer() asks for, and that time plus the slack.
+ *
+ * By setting the slack to -1, a percentage of the delay is used
+ * instead.
+ */
+void set_timer_slack(struct timer_list *timer, int slack_hz)
+{
+	timer->slack = slack_hz;
+}
+EXPORT_SYMBOL_GPL(set_timer_slack);
+
 
 static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)
@@ -550,6 +568,7 @@ static void __init_timer(struct timer_list *timer,
 {
 	timer->entry.next = NULL;
 	timer->base = __raw_get_cpu_var(tvec_bases);
+	timer->slack = -1;
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
@@ -715,6 +734,41 @@ int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 }
 EXPORT_SYMBOL(mod_timer_pending);
 
+/*
+ * Decide where to put the timer while taking the slack into account
+ *
+ * Algorithm:
+ *   1) calculate the maximum (absolute) time
+ *   2) calculate the highest bit where the expires and new max are different
+ *   3) use this bit to make a mask
+ *   4) use the bitmask to round down the maximum time, so that all last
+ *      bits are zeros
+ */
+static inline
+unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
+{
+	unsigned long expires_limit, mask;
+	int bit;
+
+	expires_limit = expires + timer->slack;
+
+	if (timer->slack < 0) /* auto slack: use 0.4% */
+		expires_limit = expires + (expires - jiffies)/256;
+
+	mask = expires ^ expires_limit;
+
+	if (mask == 0)
+		return expires;
+
+	bit = find_last_bit(&mask, BITS_PER_LONG);
+
+	mask = (1 << bit) - 1;
+
+	expires_limit = expires_limit & ~(mask);
+
+	return expires_limit;
+}
+
 /**
  * mod_timer - modify a timer's timeout
  * @timer: the timer to be modified
@@ -745,6 +799,8 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
+	expires = apply_slack(timer, expires);
+
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
@@ -955,6 +1011,47 @@ static int cascade(struct tvec_base *base, struct tvec *tv, int index)
 	return index;
 }
 
+static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
+			  unsigned long data)
+{
+	int preempt_count = preempt_count();
+
+#ifdef CONFIG_LOCKDEP
+	/*
+	 * It is permissible to free the timer from inside the
+	 * function that is called from it, this we need to take into
+	 * account for lockdep too. To avoid bogus "held lock freed"
+	 * warnings as well as problems when looking into
+	 * timer->lockdep_map, make a copy and use that here.
+	 */
+	struct lockdep_map lockdep_map = timer->lockdep_map;
+#endif
+	/*
+	 * Couple the lock chain with the lock chain at
+	 * del_timer_sync() by acquiring the lock_map around the fn()
+	 * call here and in del_timer_sync().
+	 */
+	lock_map_acquire(&lockdep_map);
+
+	trace_timer_expire_entry(timer);
+	fn(data);
+	trace_timer_expire_exit(timer);
+
+	lock_map_release(&lockdep_map);
+
+	if (preempt_count != preempt_count()) {
+		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
+			  fn, preempt_count, preempt_count());
+		/*
+		 * Restore the preempt count. That gives us a decent
+		 * chance to survive and extract information. If the
+		 * callback kept a lock held, bad luck, but not worse
+		 * than the BUG() we had.
+		 */
+		preempt_count() = preempt_count;
+	}
+}
+
 #define INDEX(N) ((base->timer_jiffies >> (TVR_BITS + (N) * TVN_BITS)) & TVN_MASK)
 
 /**
@@ -998,45 +1095,7 @@ static inline void __run_timers(struct tvec_base *base)
 			detach_timer(timer, 1);
 
 			spin_unlock_irq(&base->lock);
-			{
-				int preempt_count = preempt_count();
-
-#ifdef CONFIG_LOCKDEP
-				/*
-				 * It is permissible to free the timer from
-				 * inside the function that is called from
-				 * it, this we need to take into account for
-				 * lockdep too. To avoid bogus "held lock
-				 * freed" warnings as well as problems when
-				 * looking into timer->lockdep_map, make a
-				 * copy and use that here.
-				 */
-				struct lockdep_map lockdep_map =
-					timer->lockdep_map;
-#endif
-				/*
-				 * Couple the lock chain with the lock chain at
-				 * del_timer_sync() by acquiring the lock_map
-				 * around the fn() call here and in
-				 * del_timer_sync().
-				 */
-				lock_map_acquire(&lockdep_map);
-
-				trace_timer_expire_entry(timer);
-				fn(data);
-				trace_timer_expire_exit(timer);
-
-				lock_map_release(&lockdep_map);
-
-				if (preempt_count != preempt_count()) {
-					printk(KERN_ERR "huh, entered %p "
-					       "with preempt_count %08x, exited"
-					       " with %08x?\n",
-					       fn, preempt_count,
-					       preempt_count());
-					BUG();
-				}
-			}
+			call_timer_fn(timer, fn, data);
 			spin_lock_irq(&base->lock);
 		}
 	}
--8323328-1267210375-1274196436=:3368--
