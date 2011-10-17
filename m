Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1JQMRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:17:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:56358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQMRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:17:14 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
	 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
	 <20111013232521.GA5654@hostway.ca>
	 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Oct 2011 12:34:18 +0200
Message-ID: <1318847658.6594.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 18:39 -0700, Linus Torvalds wrote:

> Quite frankly, I personally consider it to be broken - why are we
> introducing this new lock for this very special thing? A spinlock to
> protect a *single* word of counter seems broken.

Well, I thought atomic64_t would be more expensive on 32bit archs, i386
uses the horridly expensive cmpxchg8b thing to implement it.

That said, I'm more than glad to use it.

> However, I don't see why that spinlock is needed at all. Why aren't
> those fields just atomics (or at least just "sum_exec_runtime")? 

Done.

> And
> why does "cputime_add()" exist at all? It seems to always be just a
> plain add, and nothing else would seem to ever make sense *anyway*?

Martin and me were discussing the merit of that only a few weeks ago ;-)

BTW what would we all think about a coccinelle generated patch that
fixes atomic*_add()'s argument order?

---
Subject: cputimer: Cure lock inversion
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Oct 17 11:50:30 CEST 2011

There's a lock inversion between the cputimer->lock and rq->lock; notably
the two callchains involved are:

 update_rlimit_cpu()
   sighand->siglock
   set_process_cpu_timer()
     cpu_timer_sample_group()
       thread_group_cputimer()
         cputimer->lock
         thread_group_cputime()
           task_sched_runtime()
             ->pi_lock
             rq->lock

 scheduler_tick()
   rq->lock
   task_tick_fair()
     update_curr()
       account_group_exec()
         cputimer->lock

Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and the
second one is keeping up-to-date.

Note that e8abccb7193 ("posix-cpu-timers: Cure SMP accounting oddities") didn't
introduce this problem, but merely made it much more likely to happen, see how
cpu_timer_sample_group() for the CPUCLOCK_SCHED case also takes rq->lock.

Cure this inversion by removing the need to acquire cputimer->lock in the
update path by converting task_cputime::sum_exec_runtime to an atomic64_t.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h     |    4 ++--
 kernel/fork.c             |    2 +-
 kernel/posix-cpu-timers.c |   41 ++++++++++++++++++++++++-----------------
 kernel/sched.c            |    2 +-
 kernel/sched_rt.c         |    6 ++++--
 kernel/sched_stats.h      |    4 +---
 6 files changed, 33 insertions(+), 26 deletions(-)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -474,7 +474,7 @@ struct cpu_itimer {
 struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
-	unsigned long long sum_exec_runtime;
+	atomic64_t sum_exec_runtime;
 };
 /* Alternate field names when used to cache expirations. */
 #define prof_exp	stime
@@ -485,7 +485,7 @@ struct task_cputime {
 	(struct task_cputime) {					\
 		.utime = cputime_zero,				\
 		.stime = cputime_zero,				\
-		.sum_exec_runtime = 0,				\
+		.sum_exec_runtime = ATOMIC64_INIT(0),		\
 	}
 
 /*
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1033,7 +1033,7 @@ static void posix_cpu_timers_init(struct
 {
 	tsk->cputime_expires.prof_exp = cputime_zero;
 	tsk->cputime_expires.virt_exp = cputime_zero;
-	tsk->cputime_expires.sched_exp = 0;
+	atomic64_set(&tsk->cputime_expires.sched_exp, 0);
 	INIT_LIST_HEAD(&tsk->cpu_timers[0]);
 	INIT_LIST_HEAD(&tsk->cpu_timers[1]);
 	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -239,7 +239,7 @@ void thread_group_cputime(struct task_st
 
 	times->utime = sig->utime;
 	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
+	atomic64_set(&times->sum_exec_runtime, sig->sum_sched_runtime);
 
 	rcu_read_lock();
 	/* make sure we can trust tsk->thread_group list */
@@ -250,7 +250,7 @@ void thread_group_cputime(struct task_st
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime += task_sched_runtime(t);
+		atomic64_add(task_sched_runtime(t), &times->sum_exec_runtime);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -264,8 +264,11 @@ static void update_gt_cputime(struct tas
 	if (cputime_gt(b->stime, a->stime))
 		a->stime = b->stime;
 
-	if (b->sum_exec_runtime > a->sum_exec_runtime)
-		a->sum_exec_runtime = b->sum_exec_runtime;
+	if (atomic64_read(&b->sum_exec_runtime) >
+			atomic64_read(&a->sum_exec_runtime)) {
+		atomic64_set(&a->sum_exec_runtime,
+				atomic64_read(&b->sum_exec_runtime));
+	}
 }
 
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
@@ -287,6 +290,8 @@ void thread_group_cputimer(struct task_s
 		update_gt_cputime(&cputimer->cputime, &sum);
 	}
 	*times = cputimer->cputime;
+	atomic64_set(&times->sum_exec_runtime,
+			atomic64_read(&cputimer->cputime.sum_exec_runtime));
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
@@ -313,7 +318,7 @@ static int cpu_clock_sample_group(const 
 		break;
 	case CPUCLOCK_SCHED:
 		thread_group_cputime(p, &cputime);
-		cpu->sched = cputime.sum_exec_runtime;
+		cpu->sched = atomic64_read(&cputime.sum_exec_runtime);
 		break;
 	}
 	return 0;
@@ -593,9 +598,9 @@ static void arm_timer(struct k_itimer *t
 				cputime_expires->virt_exp = exp->cpu;
 			break;
 		case CPUCLOCK_SCHED:
-			if (cputime_expires->sched_exp == 0 ||
-			    cputime_expires->sched_exp > exp->sched)
-				cputime_expires->sched_exp = exp->sched;
+			if (atomic64_read(&cputime_expires->sched_exp) == 0 ||
+			    atomic64_read(&cputime_expires->sched_exp) > exp->sched)
+				atomic64_set(&cputime_expires->sched_exp, exp->sched);
 			break;
 		}
 	}
@@ -656,7 +661,7 @@ static int cpu_timer_sample_group(const 
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = atomic64_read(&cputime.sum_exec_runtime) + task_delta_exec(p);
 		break;
 	}
 	return 0;
@@ -947,13 +952,14 @@ static void check_thread_timers(struct t
 
 	++timers;
 	maxfire = 20;
-	tsk->cputime_expires.sched_exp = 0;
+	atomic64_set(&tsk->cputime_expires.sched_exp, 0);
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
-			tsk->cputime_expires.sched_exp = t->expires.sched;
+			atomic64_set(&tsk->cputime_expires.sched_exp,
+				     t->expires.sched);
 			break;
 		}
 		t->firing = 1;
@@ -1049,7 +1055,7 @@ static inline int task_cputime_zero(cons
 {
 	if (cputime_eq(cputime->utime, cputime_zero) &&
 	    cputime_eq(cputime->stime, cputime_zero) &&
-	    cputime->sum_exec_runtime == 0)
+	    atomic64_read(&cputime->sum_exec_runtime) == 0)
 		return 1;
 	return 0;
 }
@@ -1076,7 +1082,7 @@ static void check_process_timers(struct 
 	thread_group_cputimer(tsk, &cputime);
 	utime = cputime.utime;
 	ptime = cputime_add(utime, cputime.stime);
-	sum_sched_runtime = cputime.sum_exec_runtime;
+	sum_sched_runtime = atomic64_read(&cputime.sum_exec_runtime);
 	maxfire = 20;
 	prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
@@ -1161,7 +1167,7 @@ static void check_process_timers(struct 
 
 	sig->cputime_expires.prof_exp = prof_expires;
 	sig->cputime_expires.virt_exp = virt_expires;
-	sig->cputime_expires.sched_exp = sched_expires;
+	atomic64_set(&sig->cputime_expires.sched_exp, sched_expires);
 	if (task_cputime_zero(&sig->cputime_expires))
 		stop_process_timers(sig);
 }
@@ -1255,8 +1261,9 @@ static inline int task_cputime_expired(c
 	    cputime_ge(cputime_add(sample->utime, sample->stime),
 		       expires->stime))
 		return 1;
-	if (expires->sum_exec_runtime != 0 &&
-	    sample->sum_exec_runtime >= expires->sum_exec_runtime)
+	if (atomic64_read(&expires->sum_exec_runtime) != 0 &&
+	    atomic64_read(&sample->sum_exec_runtime) >=
+			atomic64_read(&expires->sum_exec_runtime))
 		return 1;
 	return 0;
 }
@@ -1279,7 +1286,7 @@ static inline int fastpath_timer_check(s
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
 			.stime = tsk->stime,
-			.sum_exec_runtime = tsk->se.sum_exec_runtime
+			.sum_exec_runtime = ATOMIC64_INIT(tsk->se.sum_exec_runtime),
 		};
 
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4075,7 +4075,7 @@ void thread_group_times(struct task_stru
 	thread_group_cputime(p, &cputime);
 
 	total = cputime_add(cputime.utime, cputime.stime);
-	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
+	rtime = nsecs_to_cputime(atomic64_read(&cputime.sum_exec_runtime));
 
 	if (total) {
 		u64 temp = rtime;
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1763,8 +1763,10 @@ static void watchdog(struct rq *rq, stru
 
 		p->rt.timeout++;
 		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
-		if (p->rt.timeout > next)
-			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
+		if (p->rt.timeout > next) {
+			atomic64_set(&p->cputime_expires.sched_exp,
+					p->se.sum_exec_runtime);
+		}
 	}
 }
 
Index: linux-2.6/kernel/sched_stats.h
===================================================================
--- linux-2.6.orig/kernel/sched_stats.h
+++ linux-2.6/kernel/sched_stats.h
@@ -330,7 +330,5 @@ static inline void account_group_exec_ru
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
-	cputimer->cputime.sum_exec_runtime += ns;
-	spin_unlock(&cputimer->lock);
+	atomic64_add(ns, &cputimer->cputime.sum_exec_runtime);
 }

