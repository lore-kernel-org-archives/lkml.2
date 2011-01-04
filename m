Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1ADQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:01:10 -0500
Received: from ms01.sssup.it ([193.205.80.99]:40325 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751357Ab1ADQBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:01:07 -0500
Subject: [RFC][PATCH 1/3] sched: rename sched_entity to sched_cfs_entity.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co, lucas.de.marchi@gmail.com
In-Reply-To: <1294156524.6169.147.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QcWKPA396/s5Ldl/28UW"
Date: Tue, 04 Jan 2011 17:00:41 +0100
Message-ID: <1294156841.6169.149.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QcWKPA396/s5Ldl/28UW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Using the name `struct sched_entity' for the scheduling entity
of the fair scheduling class is not fair to the other scheduling
classes, which have to use things like `struct sched_rt_entity'.

Moreover, changing that would make it possible to put all the
`struct sched_*_entity' of all the scheduling classes in a more
general structure (which will also contains all the common fields).
This would make the code easier to understand and, if we manage in
using an union for the class-specific fields, it would also save
some memory.

Therefore, this commit turns `sched_entity' into `sched_cfs_entity',
wherever it is being used.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 fs/proc/base.c            |    2 +-
 include/linux/init_task.h |    4 +-
 include/linux/sched.h     |    6 +-
 kernel/delayacct.c        |    2 +-
 kernel/exit.c             |    2 +-
 kernel/posix-cpu-timers.c |   10 +-
 kernel/sched.c            |  152 ++++++------
 kernel/sched_debug.c      |  117 +++++-----
 kernel/sched_fair.c       |  611 +++++++++++++++++++++++------------------=
----
 kernel/sched_rt.c         |   26 +-
 kernel/sched_stoptask.c   |    2 +-
 11 files changed, 479 insertions(+), 455 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 08cba2c..9591d6e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -356,7 +356,7 @@ static int proc_pid_stack(struct seq_file *m, struct pi=
d_namespace *ns,
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
 	return sprintf(buffer, "%llu %llu %lu\n",
-			(unsigned long long)task->se.sum_exec_runtime,
+			(unsigned long long)task->cfs.sum_exec_runtime,
 			(unsigned long long)task->sched_info.run_delay,
 			task->sched_info.pcount);
 }
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..8baee0b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -142,8 +142,8 @@ extern struct cred init_cred;
 	.cpus_allowed	=3D CPU_MASK_ALL,					\
 	.mm		=3D NULL,						\
 	.active_mm	=3D &init_mm,					\
-	.se		=3D {						\
-		.group_node 	=3D LIST_HEAD_INIT(tsk.se.group_node),	\
+	.cfs		=3D {						\
+		.group_node 	=3D LIST_HEAD_INIT(tsk.cfs.group_node),	\
 	},								\
 	.rt		=3D {						\
 		.run_list	=3D LIST_HEAD_INIT(tsk.rt.run_list),	\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777cd01..55adf37 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1137,7 +1137,7 @@ struct sched_statistics {
 };
 #endif
=20
-struct sched_entity {
+struct sched_cfs_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
 	struct list_head	group_node;
@@ -1155,7 +1155,7 @@ struct sched_entity {
 #endif
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	struct sched_entity	*parent;
+	struct sched_cfs_entity *parent;
 	/* rq on which this entity is (to be) queued: */
 	struct cfs_rq		*cfs_rq;
 	/* rq "owned" by this entity/group: */
@@ -1206,7 +1206,7 @@ struct task_struct {
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;
 	const struct sched_class *sched_class;
-	struct sched_entity se;
+	struct sched_cfs_entity cfs;
 	struct sched_rt_entity rt;
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index ead9b61..f314f56 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -128,7 +128,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct tas=
k_struct *tsk)
 	 */
 	t1 =3D tsk->sched_info.pcount;
 	t2 =3D tsk->sched_info.run_delay;
-	t3 =3D tsk->se.sum_exec_runtime;
+	t3 =3D tsk->cfs.sum_exec_runtime;
=20
 	d->cpu_count +=3D t1;
=20
diff --git a/kernel/exit.c b/kernel/exit.c
index 676149a..01087fc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -132,7 +132,7 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->inblock +=3D task_io_get_inblock(tsk);
 		sig->oublock +=3D task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig->sum_sched_runtime +=3D tsk->se.sum_exec_runtime;
+		sig->sum_sched_runtime +=3D tsk->cfs.sum_exec_runtime;
 	}
=20
 	sig->nr_threads--;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 05bb717..801169c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -248,7 +248,7 @@ void thread_group_cputime(struct task_struct *tsk, stru=
ct task_cputime *times)
 	do {
 		times->utime =3D cputime_add(times->utime, t->utime);
 		times->stime =3D cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime +=3D t->se.sum_exec_runtime;
+		times->sum_exec_runtime +=3D t->cfs.sum_exec_runtime;
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -508,7 +508,7 @@ static void cleanup_timers(struct list_head *head,
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
+		       tsk->utime, tsk->stime, tsk->cfs.sum_exec_runtime);
=20
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
@@ -518,7 +518,7 @@ void posix_cpu_timers_exit_group(struct task_struct *ts=
k)
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime_add(tsk->utime, sig->utime),
 		       cputime_add(tsk->stime, sig->stime),
-		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
+		       tsk->cfs.sum_exec_runtime + sig->sum_sched_runtime);
 }
=20
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count n=
ow)
@@ -949,7 +949,7 @@ static void check_thread_timers(struct task_struct *tsk=
,
 		struct cpu_timer_list *t =3D list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
+		if (!--maxfire || tsk->cfs.sum_exec_runtime < t->expires.sched) {
 			tsk->cputime_expires.sched_exp =3D t->expires.sched;
 			break;
 		}
@@ -1276,7 +1276,7 @@ static inline int fastpath_timer_check(struct task_st=
ruct *tsk)
 		struct task_cputime task_sample =3D {
 			.utime =3D tsk->utime,
 			.stime =3D tsk->stime,
-			.sum_exec_runtime =3D tsk->se.sum_exec_runtime
+			.sum_exec_runtime =3D tsk->cfs.sum_exec_runtime
 		};
=20
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
diff --git a/kernel/sched.c b/kernel/sched.c
index 5ec0615..5d68fb0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -251,7 +251,7 @@ struct task_group {
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
-	struct sched_entity **se;
+	struct sched_cfs_entity **cfs_se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
@@ -326,7 +326,7 @@ struct cfs_rq {
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr, *next, *last;
+	struct sched_cfs_entity *curr, *next, *last;
=20
 	unsigned int nr_spread_over;
=20
@@ -622,8 +622,8 @@ static inline struct task_group *task_group(struct task=
_struct *p)
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq =3D task_group(p)->cfs_rq[cpu];
-	p->se.parent =3D task_group(p)->se[cpu];
+	p->cfs.cfs_rq =3D task_group(p)->cfs_rq[cpu];
+	p->cfs.parent =3D task_group(p)->cfs_se[cpu];
 #endif
=20
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -1555,7 +1555,7 @@ static int tg_load_down(struct task_group *tg, void *=
data)
 		load =3D cpu_rq(cpu)->load.weight;
 	} else {
 		load =3D tg->parent->cfs_rq[cpu]->h_load;
-		load *=3D tg->se[cpu]->load.weight;
+		load *=3D tg->cfs_se[cpu]->load.weight;
 		load /=3D tg->parent->cfs_rq[cpu]->load.weight + 1;
 	}
=20
@@ -1733,13 +1733,13 @@ static void set_load_weight(struct task_struct *p)
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy =3D=3D SCHED_IDLE) {
-		p->se.load.weight =3D WEIGHT_IDLEPRIO;
-		p->se.load.inv_weight =3D WMULT_IDLEPRIO;
+		p->cfs.load.weight =3D WEIGHT_IDLEPRIO;
+		p->cfs.load.inv_weight =3D WMULT_IDLEPRIO;
 		return;
 	}
=20
-	p->se.load.weight =3D prio_to_weight[p->static_prio - MAX_RT_PRIO];
-	p->se.load.inv_weight =3D prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	p->cfs.load.weight =3D prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->cfs.load.inv_weight =3D prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
=20
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1747,7 +1747,7 @@ static void enqueue_task(struct rq *rq, struct task_s=
truct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
-	p->se.on_rq =3D 1;
+	p->cfs.on_rq =3D 1;
 }
=20
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1755,7 +1755,7 @@ static void dequeue_task(struct rq *rq, struct task_s=
truct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, flags);
-	p->se.on_rq =3D 0;
+	p->cfs.on_rq =3D 0;
 }
=20
 /*
@@ -2058,7 +2058,7 @@ static void check_preempt_curr(struct rq *rq, struct =
task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->cfs.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update =3D 1;
 }
=20
@@ -2081,8 +2081,8 @@ task_hot(struct task_struct *p, u64 now, struct sched=
_domain *sd)
 	 * Buddy candidates are cache hot:
 	 */
 	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
-			(&p->se =3D=3D cfs_rq_of(&p->se)->next ||
-			 &p->se =3D=3D cfs_rq_of(&p->se)->last))
+			(&p->cfs =3D=3D cfs_rq_of(&p->cfs)->next ||
+			 &p->cfs =3D=3D cfs_rq_of(&p->cfs)->last))
 		return 1;
=20
 	if (sysctl_sched_migration_cost =3D=3D -1)
@@ -2090,7 +2090,7 @@ task_hot(struct task_struct *p, u64 now, struct sched=
_domain *sd)
 	if (sysctl_sched_migration_cost =3D=3D 0)
 		return 0;
=20
-	delta =3D now - p->se.exec_start;
+	delta =3D now - p->cfs.exec_start;
=20
 	return delta < (s64)sysctl_sched_migration_cost;
 }
@@ -2109,7 +2109,7 @@ void set_task_cpu(struct task_struct *p, unsigned int=
 new_cpu)
 	trace_sched_migrate_task(p, new_cpu);
=20
 	if (task_cpu(p) !=3D new_cpu) {
-		p->se.nr_migrations++;
+		p->cfs.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 	}
=20
@@ -2133,7 +2133,7 @@ static bool migrate_task(struct task_struct *p, struc=
t rq *rq)
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->se.on_rq || task_running(rq, p);
+	return p->cfs.on_rq || task_running(rq, p);
 }
=20
 /*
@@ -2193,7 +2193,7 @@ unsigned long wait_task_inactive(struct task_struct *=
p, long match_state)
 		rq =3D task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running =3D task_running(rq, p);
-		on_rq =3D p->se.on_rq;
+		on_rq =3D p->cfs.on_rq;
 		ncsw =3D 0;
 		if (!match_state || p->state =3D=3D match_state)
 			ncsw =3D p->nvcsw | LONG_MIN; /* sets MSB */
@@ -2358,15 +2358,15 @@ static inline void ttwu_activate(struct task_struct=
 *p, struct rq *rq,
 				 bool is_sync, bool is_migrate, bool is_local,
 				 unsigned long en_flags)
 {
-	schedstat_inc(p, se.statistics.nr_wakeups);
+	schedstat_inc(p, cfs.statistics.nr_wakeups);
 	if (is_sync)
-		schedstat_inc(p, se.statistics.nr_wakeups_sync);
+		schedstat_inc(p, cfs.statistics.nr_wakeups_sync);
 	if (is_migrate)
-		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
+		schedstat_inc(p, cfs.statistics.nr_wakeups_migrate);
 	if (is_local)
-		schedstat_inc(p, se.statistics.nr_wakeups_local);
+		schedstat_inc(p, cfs.statistics.nr_wakeups_local);
 	else
-		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+		schedstat_inc(p, cfs.statistics.nr_wakeups_remote);
=20
 	activate_task(rq, p, en_flags);
 }
@@ -2428,7 +2428,7 @@ static int try_to_wake_up(struct task_struct *p, unsi=
gned int state,
 	if (!(p->state & state))
 		goto out;
=20
-	if (p->se.on_rq)
+	if (p->cfs.on_rq)
 		goto out_running;
=20
 	cpu =3D task_cpu(p);
@@ -2523,7 +2523,7 @@ static void try_to_wake_up_local(struct task_struct *=
p)
 	if (!(p->state & TASK_NORMAL))
 		return;
=20
-	if (!p->se.on_rq) {
+	if (!p->cfs.on_rq) {
 		if (likely(!task_running(rq, p))) {
 			schedstat_inc(rq, ttwu_count);
 			schedstat_inc(rq, ttwu_local);
@@ -2564,18 +2564,18 @@ int wake_up_state(struct task_struct *p, unsigned i=
nt state)
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->se.exec_start		=3D 0;
-	p->se.sum_exec_runtime		=3D 0;
-	p->se.prev_sum_exec_runtime	=3D 0;
-	p->se.nr_migrations		=3D 0;
+	p->cfs.exec_start		=3D 0;
+	p->cfs.sum_exec_runtime		=3D 0;
+	p->cfs.prev_sum_exec_runtime	=3D 0;
+	p->cfs.nr_migrations		=3D 0;
=20
 #ifdef CONFIG_SCHEDSTATS
-	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
+	memset(&p->cfs.statistics, 0, sizeof(p->cfs.statistics));
 #endif
=20
 	INIT_LIST_HEAD(&p->rt.run_list);
-	p->se.on_rq =3D 0;
-	INIT_LIST_HEAD(&p->se.group_node);
+	p->cfs.on_rq =3D 0;
+	INIT_LIST_HEAD(&p->cfs.group_node);
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -3447,7 +3447,7 @@ static u64 do_task_delta_exec(struct task_struct *p, =
struct rq *rq)
=20
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns =3D rq->clock_task - p->se.exec_start;
+		ns =3D rq->clock_task - p->cfs.exec_start;
 		if ((s64)ns < 0)
 			ns =3D 0;
 	}
@@ -3480,7 +3480,7 @@ unsigned long long task_sched_runtime(struct task_str=
uct *p)
 	u64 ns =3D 0;
=20
 	rq =3D task_rq_lock(p, &flags);
-	ns =3D p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	ns =3D p->cfs.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
=20
 	return ns;
@@ -3709,7 +3709,7 @@ void task_times(struct task_struct *p, cputime_t *ut,=
 cputime_t *st)
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	rtime =3D nsecs_to_cputime(p->se.sum_exec_runtime);
+	rtime =3D nsecs_to_cputime(p->cfs.sum_exec_runtime);
=20
 	if (total) {
 		u64 temp =3D rtime;
@@ -3897,7 +3897,7 @@ static inline void schedule_debug(struct task_struct =
*prev)
=20
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->se.on_rq)
+	if (prev->cfs.on_rq)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
@@ -4556,7 +4556,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio=
)
 	trace_sched_pi_setprio(p, prio);
 	oldprio =3D p->prio;
 	prev_class =3D p->sched_class;
-	on_rq =3D p->se.on_rq;
+	on_rq =3D p->cfs.on_rq;
 	running =3D task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
@@ -4605,7 +4605,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		p->static_prio =3D NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq =3D p->se.on_rq;
+	on_rq =3D p->cfs.on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
=20
@@ -4739,7 +4739,7 @@ static struct task_struct *find_process_by_pid(pid_t =
pid)
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->se.on_rq);
+	BUG_ON(p->cfs.on_rq);
=20
 	p->policy =3D policy;
 	p->rt_priority =3D prio;
@@ -4888,7 +4888,7 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	on_rq =3D p->se.on_rq;
+	on_rq =3D p->cfs.on_rq;
 	running =3D task_current(rq, p);
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -5539,7 +5539,7 @@ void __cpuinit init_idle(struct task_struct *idle, in=
t cpu)
=20
 	__sched_fork(idle);
 	idle->state =3D TASK_RUNNING;
-	idle->se.exec_start =3D sched_clock();
+	idle->cfs.exec_start =3D sched_clock();
=20
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	/*
@@ -5747,7 +5747,7 @@ static int __migrate_task(struct task_struct *p, int =
src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->se.on_rq) {
+	if (p->cfs.on_rq) {
 		deactivate_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
@@ -7839,27 +7839,27 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct =
rq *rq)
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq=
,
-				struct sched_entity *se, int cpu,
-				struct sched_entity *parent)
+				struct sched_cfs_entity *cfs_se, int cpu,
+				struct sched_cfs_entity *parent)
 {
 	struct rq *rq =3D cpu_rq(cpu);
 	tg->cfs_rq[cpu] =3D cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg =3D tg;
=20
-	tg->se[cpu] =3D se;
-	/* se could be NULL for init_task_group */
-	if (!se)
+	tg->cfs_se[cpu] =3D cfs_se;
+	/* cfs_se could be NULL for init_task_group */
+	if (!cfs_se)
 		return;
=20
 	if (!parent)
-		se->cfs_rq =3D &rq->cfs;
+		cfs_se->cfs_rq =3D &rq->cfs;
 	else
-		se->cfs_rq =3D parent->my_q;
+		cfs_se->cfs_rq =3D parent->my_q;
=20
-	se->my_q =3D cfs_rq;
-	update_load_set(&se->load, 0);
-	se->parent =3D parent;
+	cfs_se->my_q =3D cfs_rq;
+	update_load_set(&cfs_se->load, 0);
+	cfs_se->parent =3D parent;
 }
 #endif
=20
@@ -7908,7 +7908,7 @@ void __init sched_init(void)
 		ptr =3D (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.se =3D (struct sched_entity **)ptr;
+		init_task_group.cfs_se =3D (struct sched_cfs_entity **)ptr;
 		ptr +=3D nr_cpu_ids * sizeof(void **);
=20
 		init_task_group.cfs_rq =3D (struct cfs_rq **)ptr;
@@ -7980,7 +7980,7 @@ void __init sched_init(void)
 		 *	A0's bandwidth =3D 1024 / (10*1024 + 1024 + 1024) =3D 8.33%
 		 *
 		 * We achieve this by letting init_task_group's tasks sit
-		 * directly in rq->cfs (i.e init_task_group->se[] =3D NULL).
+		 * directly in rq->cfs (i.e init_task_group->cfs_se[] =3D NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
 #endif
@@ -8116,7 +8116,7 @@ static void normalize_task(struct rq *rq, struct task=
_struct *p)
 {
 	int on_rq;
=20
-	on_rq =3D p->se.on_rq;
+	on_rq =3D p->cfs.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -8140,11 +8140,11 @@ void normalize_rt_tasks(void)
 		if (!p->mm)
 			continue;
=20
-		p->se.exec_start		=3D 0;
+		p->cfs.exec_start		=3D 0;
 #ifdef CONFIG_SCHEDSTATS
-		p->se.statistics.wait_start	=3D 0;
-		p->se.statistics.sleep_start	=3D 0;
-		p->se.statistics.block_start	=3D 0;
+		p->cfs.statistics.wait_start	=3D 0;
+		p->cfs.statistics.sleep_start	=3D 0;
+		p->cfs.statistics.block_start	=3D 0;
 #endif
=20
 		if (!rt_task(p)) {
@@ -8226,27 +8226,27 @@ static void free_fair_sched_group(struct task_group=
 *tg)
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
-		if (tg->se)
-			kfree(tg->se[i]);
+		if (tg->cfs_se)
+			kfree(tg->cfs_se[i]);
 	}
=20
 	kfree(tg->cfs_rq);
-	kfree(tg->se);
+	kfree(tg->cfs_se);
 }
=20
 static
 int alloc_fair_sched_group(struct task_group *tg, struct task_group *paren=
t)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se;
+	struct sched_cfs_entity *cfs_se;
 	struct rq *rq;
 	int i;
=20
 	tg->cfs_rq =3D kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
-	tg->se =3D kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->se)
+	tg->cfs_se =3D kzalloc(sizeof(cfs_se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->cfs_se)
 		goto err;
=20
 	tg->shares =3D NICE_0_LOAD;
@@ -8259,12 +8259,12 @@ int alloc_fair_sched_group(struct task_group *tg, s=
truct task_group *parent)
 		if (!cfs_rq)
 			goto err;
=20
-		se =3D kzalloc_node(sizeof(struct sched_entity),
-				  GFP_KERNEL, cpu_to_node(i));
-		if (!se)
+		cfs_se =3D kzalloc_node(sizeof(struct sched_cfs_entity),
+				      GFP_KERNEL, cpu_to_node(i));
+		if (!cfs_se)
 			goto err_free_rq;
=20
-		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
+		init_tg_cfs_entry(tg, cfs_rq, cfs_se, i, parent->cfs_se[i]);
 	}
=20
 	return 1;
@@ -8447,7 +8447,7 @@ void sched_destroy_group(struct task_group *tg)
=20
 /* change task's runqueue when it moves between groups.
  *	The caller of this function should have put the task in its new group
- *	by now. This function just updates tsk->se.cfs_rq and tsk->se.parent to
+ *	by now. This function just updates tsk->cfs.cfs_rq and tsk->cfs.parent =
to
  *	reflect its new group.
  */
 void sched_move_task(struct task_struct *tsk)
@@ -8459,7 +8459,7 @@ void sched_move_task(struct task_struct *tsk)
 	rq =3D task_rq_lock(tsk, &flags);
=20
 	running =3D task_current(rq, tsk);
-	on_rq =3D tsk->se.on_rq;
+	on_rq =3D tsk->cfs.on_rq;
=20
 	if (on_rq)
 		dequeue_task(rq, tsk, 0);
@@ -8493,7 +8493,7 @@ int sched_group_set_shares(struct task_group *tg, uns=
igned long shares)
 	/*
 	 * We can't change the weight of the root cgroup.
 	 */
-	if (!tg->se[0])
+	if (!tg->cfs_se[0])
 		return -EINVAL;
=20
 	if (shares < MIN_SHARES)
@@ -8508,13 +8508,13 @@ int sched_group_set_shares(struct task_group *tg, u=
nsigned long shares)
 	tg->shares =3D shares;
 	for_each_possible_cpu(i) {
 		struct rq *rq =3D cpu_rq(i);
-		struct sched_entity *se;
+		struct sched_cfs_entity *cfs_se;
=20
-		se =3D tg->se[i];
+		cfs_se =3D tg->cfs_se[i];
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
-		for_each_sched_entity(se)
-			update_cfs_shares(group_cfs_rq(se), 0);
+		for_each_sched_entity(cfs_se)
+			update_cfs_shares(group_cfs_rq(cfs_se), 0);
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
=20
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1dfae3d..16d0b10 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -56,8 +56,9 @@ static unsigned long nsec_low(unsigned long long nsec)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task=
_group *tg)
 {
-	struct sched_entity *se =3D tg->se[cpu];
-	if (!se)
+	struct sched_cfs_entity *cfs_se =3D tg->cfs_se[cpu];
+
+	if (!cfs_se)
 		return;
=20
 #define P(F) \
@@ -65,22 +66,22 @@ static void print_cfs_group_stats(struct seq_file *m, i=
nt cpu, struct task_group
 #define PN(F) \
 	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
=20
-	PN(se->exec_start);
-	PN(se->vruntime);
-	PN(se->sum_exec_runtime);
+	PN(cfs_se->exec_start);
+	PN(cfs_se->vruntime);
+	PN(cfs_se->sum_exec_runtime);
 #ifdef CONFIG_SCHEDSTATS
-	PN(se->statistics.wait_start);
-	PN(se->statistics.sleep_start);
-	PN(se->statistics.block_start);
-	PN(se->statistics.sleep_max);
-	PN(se->statistics.block_max);
-	PN(se->statistics.exec_max);
-	PN(se->statistics.slice_max);
-	PN(se->statistics.wait_max);
-	PN(se->statistics.wait_sum);
-	P(se->statistics.wait_count);
+	PN(cfs_se->statistics.wait_start);
+	PN(cfs_se->statistics.sleep_start);
+	PN(cfs_se->statistics.block_start);
+	PN(cfs_se->statistics.sleep_max);
+	PN(cfs_se->statistics.block_max);
+	PN(cfs_se->statistics.exec_max);
+	PN(cfs_se->statistics.slice_max);
+	PN(cfs_se->statistics.wait_max);
+	PN(cfs_se->statistics.wait_sum);
+	P(cfs_se->statistics.wait_count);
 #endif
-	P(se->load.weight);
+	P(cfs_se->load.weight);
 #undef PN
 #undef P
 }
@@ -96,14 +97,14 @@ print_task(struct seq_file *m, struct rq *rq, struct ta=
sk_struct *p)
=20
 	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
 		p->comm, p->pid,
-		SPLIT_NS(p->se.vruntime),
+		SPLIT_NS(p->cfs.vruntime),
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
 #ifdef CONFIG_SCHEDSTATS
 	SEQ_printf(m, "%9Ld.%06ld %9Ld.%06ld %9Ld.%06ld",
-		SPLIT_NS(p->se.vruntime),
-		SPLIT_NS(p->se.sum_exec_runtime),
-		SPLIT_NS(p->se.statistics.sum_sleep_runtime));
+		SPLIT_NS(p->cfs.vruntime),
+		SPLIT_NS(p->cfs.sum_exec_runtime),
+		SPLIT_NS(p->cfs.statistics.sum_sleep_runtime));
 #else
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
@@ -127,7 +128,7 @@ static void print_rq(struct seq_file *m, struct rq *rq,=
 int rq_cpu)
 	read_lock_irqsave(&tasklist_lock, flags);
=20
 	do_each_thread(g, p) {
-		if (!p->se.on_rq || task_cpu(p) !=3D rq_cpu)
+		if (!p->cfs.on_rq || task_cpu(p) !=3D rq_cpu)
 			continue;
=20
 		print_task(m, rq, p);
@@ -141,7 +142,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct c=
fs_rq *cfs_rq)
 	s64 MIN_vruntime =3D -1, min_vruntime, max_vruntime =3D -1,
 		spread, rq0_min_vruntime, spread0;
 	struct rq *rq =3D cpu_rq(cpu);
-	struct sched_entity *last;
+	struct sched_cfs_entity *last;
 	unsigned long flags;
=20
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
@@ -382,55 +383,55 @@ void proc_sched_show_task(struct task_struct *p, stru=
ct seq_file *m)
 #define PN(F) \
 	SEQ_printf(m, "%-35s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
=20
-	PN(se.exec_start);
-	PN(se.vruntime);
-	PN(se.sum_exec_runtime);
+	PN(cfs.exec_start);
+	PN(cfs.vruntime);
+	PN(cfs.sum_exec_runtime);
=20
 	nr_switches =3D p->nvcsw + p->nivcsw;
=20
 #ifdef CONFIG_SCHEDSTATS
-	PN(se.statistics.wait_start);
-	PN(se.statistics.sleep_start);
-	PN(se.statistics.block_start);
-	PN(se.statistics.sleep_max);
-	PN(se.statistics.block_max);
-	PN(se.statistics.exec_max);
-	PN(se.statistics.slice_max);
-	PN(se.statistics.wait_max);
-	PN(se.statistics.wait_sum);
-	P(se.statistics.wait_count);
-	PN(se.statistics.iowait_sum);
-	P(se.statistics.iowait_count);
+	PN(cfs.statistics.wait_start);
+	PN(cfs.statistics.sleep_start);
+	PN(cfs.statistics.block_start);
+	PN(cfs.statistics.sleep_max);
+	PN(cfs.statistics.block_max);
+	PN(cfs.statistics.exec_max);
+	PN(cfs.statistics.slice_max);
+	PN(cfs.statistics.wait_max);
+	PN(cfs.statistics.wait_sum);
+	P(cfs.statistics.wait_count);
+	PN(cfs.statistics.iowait_sum);
+	P(cfs.statistics.iowait_count);
 	P(sched_info.bkl_count);
-	P(se.nr_migrations);
-	P(se.statistics.nr_migrations_cold);
-	P(se.statistics.nr_failed_migrations_affine);
-	P(se.statistics.nr_failed_migrations_running);
-	P(se.statistics.nr_failed_migrations_hot);
-	P(se.statistics.nr_forced_migrations);
-	P(se.statistics.nr_wakeups);
-	P(se.statistics.nr_wakeups_sync);
-	P(se.statistics.nr_wakeups_migrate);
-	P(se.statistics.nr_wakeups_local);
-	P(se.statistics.nr_wakeups_remote);
-	P(se.statistics.nr_wakeups_affine);
-	P(se.statistics.nr_wakeups_affine_attempts);
-	P(se.statistics.nr_wakeups_passive);
-	P(se.statistics.nr_wakeups_idle);
+	P(cfs.nr_migrations);
+	P(cfs.statistics.nr_migrations_cold);
+	P(cfs.statistics.nr_failed_migrations_affine);
+	P(cfs.statistics.nr_failed_migrations_running);
+	P(cfs.statistics.nr_failed_migrations_hot);
+	P(cfs.statistics.nr_forced_migrations);
+	P(cfs.statistics.nr_wakeups);
+	P(cfs.statistics.nr_wakeups_sync);
+	P(cfs.statistics.nr_wakeups_migrate);
+	P(cfs.statistics.nr_wakeups_local);
+	P(cfs.statistics.nr_wakeups_remote);
+	P(cfs.statistics.nr_wakeups_affine);
+	P(cfs.statistics.nr_wakeups_affine_attempts);
+	P(cfs.statistics.nr_wakeups_passive);
+	P(cfs.statistics.nr_wakeups_idle);
=20
 	{
 		u64 avg_atom, avg_per_cpu;
=20
-		avg_atom =3D p->se.sum_exec_runtime;
+		avg_atom =3D p->cfs.sum_exec_runtime;
 		if (nr_switches)
 			do_div(avg_atom, nr_switches);
 		else
 			avg_atom =3D -1LL;
=20
-		avg_per_cpu =3D p->se.sum_exec_runtime;
-		if (p->se.nr_migrations) {
+		avg_per_cpu =3D p->cfs.sum_exec_runtime;
+		if (p->cfs.nr_migrations) {
 			avg_per_cpu =3D div64_u64(avg_per_cpu,
-						p->se.nr_migrations);
+						p->cfs.nr_migrations);
 		} else {
 			avg_per_cpu =3D -1LL;
 		}
@@ -445,7 +446,7 @@ void proc_sched_show_task(struct task_struct *p, struct=
 seq_file *m)
 	SEQ_printf(m, "%-35s:%21Ld\n",
 		   "nr_involuntary_switches", (long long)p->nivcsw);
=20
-	P(se.load.weight);
+	P(cfs.load.weight);
 	P(policy);
 	P(prio);
 #undef PN
@@ -467,6 +468,6 @@ void proc_sched_show_task(struct task_struct *p, struct=
 seq_file *m)
 void proc_sched_set_task(struct task_struct *p)
 {
 #ifdef CONFIG_SCHEDSTATS
-	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
+	memset(&p->cfs.statistics, 0, sizeof(p->cfs.statistics));
 #endif
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..1ae7a17 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -111,33 +111,33 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 }
=20
 /* An entity is a task if it doesn't "own" a runqueue */
-#define entity_is_task(se)	(!se->my_q)
+#define cfs_entity_is_task(cfs_se)	(!cfs_se->my_q)
=20
-static inline struct task_struct *task_of(struct sched_entity *se)
+static inline struct task_struct *cfs_task_of(struct sched_cfs_entity *cfs=
_se)
 {
 #ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(!entity_is_task(se));
+	WARN_ON_ONCE(!cfs_entity_is_task(cfs_se));
 #endif
-	return container_of(se, struct task_struct, se);
+	return container_of(cfs_se, struct task_struct, cfs);
 }
=20
 /* Walk up scheduling entities hierarchy */
-#define for_each_sched_entity(se) \
-		for (; se; se =3D se->parent)
+#define for_each_sched_cfs_entity(cfs_se) \
+		for (; cfs_se; cfs_se =3D cfs_se->parent)
=20
 static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
-	return p->se.cfs_rq;
+	return p->cfs.cfs_rq;
 }
=20
 /* runqueue on which this entity is (to be) queued */
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+static inline struct cfs_rq *cfs_rq_of(struct sched_cfs_entity *cfs_se)
 {
-	return se->cfs_rq;
+	return cfs_se->cfs_rq;
 }
=20
 /* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+static inline struct cfs_rq *group_cfs_rq(struct sched_cfs_entity *grp)
 {
 	return grp->my_q;
 }
@@ -186,32 +186,35 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq=
 *cfs_rq)
=20
 /* Do the two (enqueued) entities belong to the same group ? */
 static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
+is_same_group(struct sched_cfs_entity *cfs_se,
+	      struct sched_cfs_entity *cfs_pse)
 {
-	if (se->cfs_rq =3D=3D pse->cfs_rq)
+	if (cfs_se->cfs_rq =3D=3D cfs_pse->cfs_rq)
 		return 1;
=20
 	return 0;
 }
=20
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
+static inline
+struct sched_cfs_entity *parent_entity(struct sched_cfs_entity *cfs_se)
 {
-	return se->parent;
+	return cfs_se->parent;
 }
=20
 /* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
+static inline int depth_se(struct sched_cfs_entity *cfs_se)
 {
 	int depth =3D 0;
=20
-	for_each_sched_entity(se)
+	for_each_sched_cfs_entity(cfs_se)
 		depth++;
=20
 	return depth;
 }
=20
 static void
-find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+find_matching_se(struct sched_cfs_entity **cfs_se,
+		 struct sched_cfs_entity **cfs_pse)
 {
 	int se_depth, pse_depth;
=20
@@ -223,30 +226,30 @@ find_matching_se(struct sched_entity **se, struct sch=
ed_entity **pse)
 	 */
=20
 	/* First walk up until both entities are at same depth */
-	se_depth =3D depth_se(*se);
-	pse_depth =3D depth_se(*pse);
+	se_depth =3D depth_se(*cfs_se);
+	pse_depth =3D depth_se(*cfs_pse);
=20
 	while (se_depth > pse_depth) {
 		se_depth--;
-		*se =3D parent_entity(*se);
+		*cfs_se =3D parent_entity(*cfs_se);
 	}
=20
 	while (pse_depth > se_depth) {
 		pse_depth--;
-		*pse =3D parent_entity(*pse);
+		*cfs_pse =3D parent_entity(*cfs_pse);
 	}
=20
-	while (!is_same_group(*se, *pse)) {
-		*se =3D parent_entity(*se);
-		*pse =3D parent_entity(*pse);
+	while (!is_same_group(*cfs_se, *cfs_pse)) {
+		*cfs_se =3D parent_entity(*cfs_se);
+		*cfs_pse =3D parent_entity(*cfs_pse);
 	}
 }
=20
 #else	/* !CONFIG_FAIR_GROUP_SCHED */
=20
-static inline struct task_struct *task_of(struct sched_entity *se)
+static inline struct task_struct *cfs_task_of(struct sched_cfs_entity *cfs=
_se)
 {
-	return container_of(se, struct task_struct, se);
+	return container_of(cfs_se, struct task_struct, cfs);
 }
=20
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -254,26 +257,26 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 	return container_of(cfs_rq, struct rq, cfs);
 }
=20
-#define entity_is_task(se)	1
+#define cfs_entity_is_task(cfs_se)	1
=20
-#define for_each_sched_entity(se) \
-		for (; se; se =3D NULL)
+#define for_each_sched_cfs_entity(cfs_se) \
+		for (; cfs_se; cfs_se =3D NULL)
=20
 static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
 	return &task_rq(p)->cfs;
 }
=20
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+static inline struct cfs_rq *cfs_rq_of(struct sched_cfs_entity *cfs_se)
 {
-	struct task_struct *p =3D task_of(se);
+	struct task_struct *p =3D cfs_task_of(cfs_se);
 	struct rq *rq =3D task_rq(p);
=20
 	return &rq->cfs;
 }
=20
 /* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+static inline struct cfs_rq *group_cfs_rq(struct sched_cfs_entity *grp)
 {
 	return NULL;
 }
@@ -294,19 +297,20 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq=
 *cfs_rq)
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq =3D &rq->cfs; cfs_rq; cfs_rq =3D NULL)
=20
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
+static inline int is_same_group(struct sched_cfs_entity *cfs_se,
+				struct sched_cfs_entity *cfs_pse)
 {
 	return 1;
 }
=20
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
+static inline
+struct sched_cfs_entity *parent_entity(struct sched_cfs_entity *cfs_se)
 {
 	return NULL;
 }
=20
-static inline void
-find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+static inline void find_matching_se(struct sched_cfs_entity **cfs_se,
+				    struct sched_cfs_entity **cfs_pse)
 {
 }
=20
@@ -335,15 +339,16 @@ static inline u64 min_vruntime(u64 min_vruntime, u64 =
vruntime)
 	return min_vruntime;
 }
=20
-static inline int entity_before(struct sched_entity *a,
-				struct sched_entity *b)
+static inline int entity_before(struct sched_cfs_entity *a,
+				struct sched_cfs_entity *b)
 {
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
=20
-static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *s=
e)
+static inline s64
+entity_key(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
-	return se->vruntime - cfs_rq->min_vruntime;
+	return cfs_se->vruntime - cfs_rq->min_vruntime;
 }
=20
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
@@ -354,14 +359,14 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq=
)
 		vruntime =3D cfs_rq->curr->vruntime;
=20
 	if (cfs_rq->rb_leftmost) {
-		struct sched_entity *se =3D rb_entry(cfs_rq->rb_leftmost,
-						   struct sched_entity,
-						   run_node);
+		struct sched_cfs_entity *cfs_se =3D rb_entry(cfs_rq->rb_leftmost,
+							struct sched_cfs_entity,
+							run_node);
=20
 		if (!cfs_rq->curr)
-			vruntime =3D se->vruntime;
+			vruntime =3D cfs_se->vruntime;
 		else
-			vruntime =3D min_vruntime(vruntime, se->vruntime);
+			vruntime =3D min_vruntime(vruntime, cfs_se->vruntime);
 	}
=20
 	cfs_rq->min_vruntime =3D max_vruntime(cfs_rq->min_vruntime, vruntime);
@@ -370,12 +375,13 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq=
)
 /*
  * Enqueue an entity into the rb-tree:
  */
-static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *s=
e)
+static void
+__enqueue_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
 	struct rb_node **link =3D &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent =3D NULL;
-	struct sched_entity *entry;
-	s64 key =3D entity_key(cfs_rq, se);
+	struct sched_cfs_entity *entry;
+	s64 key =3D entity_key(cfs_rq, cfs_se);
 	int leftmost =3D 1;
=20
 	/*
@@ -383,7 +389,7 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, str=
uct sched_entity *se)
 	 */
 	while (*link) {
 		parent =3D *link;
-		entry =3D rb_entry(parent, struct sched_entity, run_node);
+		entry =3D rb_entry(parent, struct sched_cfs_entity, run_node);
 		/*
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
@@ -401,42 +407,43 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, s=
truct sched_entity *se)
 	 * used):
 	 */
 	if (leftmost)
-		cfs_rq->rb_leftmost =3D &se->run_node;
+		cfs_rq->rb_leftmost =3D &cfs_se->run_node;
=20
-	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_link_node(&cfs_se->run_node, parent, link);
+	rb_insert_color(&cfs_se->run_node, &cfs_rq->tasks_timeline);
 }
=20
-static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *s=
e)
+static void
+__dequeue_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
-	if (cfs_rq->rb_leftmost =3D=3D &se->run_node) {
+	if (cfs_rq->rb_leftmost =3D=3D &cfs_se->run_node) {
 		struct rb_node *next_node;
=20
-		next_node =3D rb_next(&se->run_node);
+		next_node =3D rb_next(&cfs_se->run_node);
 		cfs_rq->rb_leftmost =3D next_node;
 	}
=20
-	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_erase(&cfs_se->run_node, &cfs_rq->tasks_timeline);
 }
=20
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_cfs_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left =3D cfs_rq->rb_leftmost;
=20
 	if (!left)
 		return NULL;
=20
-	return rb_entry(left, struct sched_entity, run_node);
+	return rb_entry(left, struct sched_cfs_entity, run_node);
 }
=20
-static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
+static struct sched_cfs_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last =3D rb_last(&cfs_rq->tasks_timeline);
=20
 	if (!last)
 		return NULL;
=20
-	return rb_entry(last, struct sched_entity, run_node);
+	return rb_entry(last, struct sched_cfs_entity, run_node);
 }
=20
 /**************************************************************
@@ -472,10 +479,10 @@ int sched_proc_update_handler(struct ctl_table *table=
, int write,
  * delta /=3D w
  */
 static inline unsigned long
-calc_delta_fair(unsigned long delta, struct sched_entity *se)
+calc_delta_fair(unsigned long delta, struct sched_cfs_entity *cfs_se)
 {
-	if (unlikely(se->load.weight !=3D NICE_0_LOAD))
-		delta =3D calc_delta_mine(delta, NICE_0_LOAD, &se->load);
+	if (unlikely(cfs_se->load.weight !=3D NICE_0_LOAD))
+		delta =3D calc_delta_mine(delta, NICE_0_LOAD, &cfs_se->load);
=20
 	return delta;
 }
@@ -507,24 +514,24 @@ static u64 __sched_period(unsigned long nr_running)
  *
  * s =3D p*P[w/rw]
  */
-static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs=
_se)
 {
-	u64 slice =3D __sched_period(cfs_rq->nr_running + !se->on_rq);
+	u64 slice =3D __sched_period(cfs_rq->nr_running + !cfs_se->on_rq);
=20
-	for_each_sched_entity(se) {
+	for_each_sched_cfs_entity(cfs_se) {
 		struct load_weight *load;
 		struct load_weight lw;
=20
-		cfs_rq =3D cfs_rq_of(se);
+		cfs_rq =3D cfs_rq_of(cfs_se);
 		load =3D &cfs_rq->load;
=20
-		if (unlikely(!se->on_rq)) {
+		if (unlikely(!cfs_se->on_rq)) {
 			lw =3D cfs_rq->load;
=20
-			update_load_add(&lw, se->load.weight);
+			update_load_add(&lw, cfs_se->load.weight);
 			load =3D &lw;
 		}
-		slice =3D calc_delta_mine(slice, se->load.weight, load);
+		slice =3D calc_delta_mine(slice, cfs_se->load.weight, load);
 	}
 	return slice;
 }
@@ -534,9 +541,10 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct s=
ched_entity *se)
  *
  * vs =3D s/w
  */
-static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static u64
+sched_vslice(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
-	return calc_delta_fair(sched_slice(cfs_rq, se), se);
+	return calc_delta_fair(sched_slice(cfs_rq, cfs_se), cfs_se);
 }
=20
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
@@ -547,7 +555,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, lo=
ng weight_delta);
  * are not in our scheduling class.
  */
 static inline void
-__update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
+__update_curr(struct cfs_rq *cfs_rq, struct sched_cfs_entity *curr,
 	      unsigned long delta_exec)
 {
 	unsigned long delta_exec_weighted;
@@ -569,7 +577,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entit=
y *curr,
=20
 static void update_curr(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *curr =3D cfs_rq->curr;
+	struct sched_cfs_entity *curr =3D cfs_rq->curr;
 	u64 now =3D rq_of(cfs_rq)->clock_task;
 	unsigned long delta_exec;
=20
@@ -588,8 +596,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start =3D now;
=20
-	if (entity_is_task(curr)) {
-		struct task_struct *curtask =3D task_of(curr);
+	if (cfs_entity_is_task(curr)) {
+		struct task_struct *curtask =3D cfs_task_of(curr);
=20
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
@@ -598,62 +606,66 @@ static void update_curr(struct cfs_rq *cfs_rq)
 }
=20
 static inline void
-update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
+update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cf=
s_se)
 {
-	schedstat_set(se->statistics.wait_start, rq_of(cfs_rq)->clock);
+	schedstat_set(cfs_se->statistics.wait_start, rq_of(cfs_rq)->clock);
 }
=20
 /*
  * Task is being enqueued - update stats:
  */
-static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entit=
y *se)
+static void
+update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_s=
e)
 {
 	/*
 	 * Are we enqueueing a waiting task? (for current tasks
 	 * a dequeue/enqueue event is a NOP)
 	 */
-	if (se !=3D cfs_rq->curr)
-		update_stats_wait_start(cfs_rq, se);
+	if (cfs_se !=3D cfs_rq->curr)
+		update_stats_wait_start(cfs_rq, cfs_se);
 }
=20
 static void
-update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
-			rq_of(cfs_rq)->clock - se->statistics.wait_start));
-	schedstat_set(se->statistics.wait_count, se->statistics.wait_count + 1);
-	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
-			rq_of(cfs_rq)->clock - se->statistics.wait_start);
+update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_=
se)
+{
+	schedstat_set(cfs_se->statistics.wait_max,
+		      max(cfs_se->statistics.wait_max,
+			  rq_of(cfs_rq)->clock-cfs_se->statistics.wait_start));
+	schedstat_set(cfs_se->statistics.wait_count,
+		      cfs_se->statistics.wait_count + 1);
+	schedstat_set(cfs_se->statistics.wait_sum,
+		      cfs_se->statistics.wait_sum + rq_of(cfs_rq)->clock -
+		      cfs_se->statistics.wait_start);
 #ifdef CONFIG_SCHEDSTATS
-	if (entity_is_task(se)) {
-		trace_sched_stat_wait(task_of(se),
-			rq_of(cfs_rq)->clock - se->statistics.wait_start);
+	if (cfs_entity_is_task(cfs_se)) {
+		trace_sched_stat_wait(cfs_task_of(cfs_se),
+			rq_of(cfs_rq)->clock - cfs_se->statistics.wait_start);
 	}
 #endif
-	schedstat_set(se->statistics.wait_start, 0);
+	schedstat_set(cfs_se->statistics.wait_start, 0);
 }
=20
 static inline void
-update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
+update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_s=
e)
 {
 	/*
 	 * Mark the end of the wait period if dequeueing a
 	 * waiting task:
 	 */
-	if (se !=3D cfs_rq->curr)
-		update_stats_wait_end(cfs_rq, se);
+	if (cfs_se !=3D cfs_rq->curr)
+		update_stats_wait_end(cfs_rq, cfs_se);
 }
=20
 /*
  * We are picking a new current task - update its stats:
  */
 static inline void
-update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
+update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cf=
s_se)
 {
 	/*
 	 * We are starting a new run period:
 	 */
-	se->exec_start =3D rq_of(cfs_rq)->clock_task;
+	cfs_se->exec_start =3D rq_of(cfs_rq)->clock_task;
 }
=20
 /**************************************************
@@ -674,27 +686,27 @@ add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned l=
ong weight)
 #endif
=20
 static void
-account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	update_load_add(&cfs_rq->load, se->load.weight);
-	if (!parent_entity(se))
-		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se)) {
-		add_cfs_task_weight(cfs_rq, se->load.weight);
-		list_add(&se->group_node, &cfs_rq->tasks);
+account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs=
_se)
+{
+	update_load_add(&cfs_rq->load, cfs_se->load.weight);
+	if (!parent_entity(cfs_se))
+		inc_cpu_load(rq_of(cfs_rq), cfs_se->load.weight);
+	if (cfs_entity_is_task(cfs_se)) {
+		add_cfs_task_weight(cfs_rq, cfs_se->load.weight);
+		list_add(&cfs_se->group_node, &cfs_rq->tasks);
 	}
 	cfs_rq->nr_running++;
 }
=20
 static void
-account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	update_load_sub(&cfs_rq->load, se->load.weight);
-	if (!parent_entity(se))
-		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se)) {
-		add_cfs_task_weight(cfs_rq, -se->load.weight);
-		list_del_init(&se->group_node);
+account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs=
_se)
+{
+	update_load_sub(&cfs_rq->load, cfs_se->load.weight);
+	if (!parent_entity(cfs_se))
+		dec_cpu_load(rq_of(cfs_rq), cfs_se->load.weight);
+	if (cfs_entity_is_task(cfs_se)) {
+		add_cfs_task_weight(cfs_rq, -cfs_se->load.weight);
+		list_del_init(&cfs_se->group_node);
 	}
 	cfs_rq->nr_running--;
 }
@@ -762,34 +774,35 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, in=
t global_update)
 		list_del_leaf_cfs_rq(cfs_rq);
 }
=20
-static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se=
,
+static void reweight_entity(struct cfs_rq *cfs_rq,
+			    struct sched_cfs_entity *cfs_se,
 			    unsigned long weight)
 {
-	if (se->on_rq) {
+	if (cfs_se->on_rq) {
 		/* commit outstanding execution time */
-		if (cfs_rq->curr =3D=3D se)
+		if (cfs_rq->curr =3D=3D cfs_se)
 			update_curr(cfs_rq);
-		account_entity_dequeue(cfs_rq, se);
+		account_entity_dequeue(cfs_rq, cfs_se);
 	}
=20
-	update_load_set(&se->load, weight);
+	update_load_set(&cfs_se->load, weight);
=20
-	if (se->on_rq)
-		account_entity_enqueue(cfs_rq, se);
+	if (cfs_se->on_rq)
+		account_entity_enqueue(cfs_rq, cfs_se);
 }
=20
 static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 	struct task_group *tg;
-	struct sched_entity *se;
+	struct sched_cfs_entity *cfs_se;
 	long load_weight, load, shares;
=20
 	if (!cfs_rq)
 		return;
=20
 	tg =3D cfs_rq->tg;
-	se =3D tg->se[cpu_of(rq_of(cfs_rq))];
-	if (!se)
+	cfs_se =3D tg->cfs_se[cpu_of(rq_of(cfs_rq))];
+	if (!cfs_se)
 		return;
=20
 	load =3D cfs_rq->load.weight + weight_delta;
@@ -807,7 +820,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, lo=
ng weight_delta)
 	if (shares > tg->shares)
 		shares =3D tg->shares;
=20
-	reweight_entity(cfs_rq_of(se), se, shares);
+	reweight_entity(cfs_rq_of(cfs_se), cfs_se, shares);
 }
=20
 static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
@@ -831,47 +844,48 @@ static inline void update_entity_shares_tick(struct c=
fs_rq *cfs_rq)
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
=20
-static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se=
)
+static void
+enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct task_struct *tsk =3D NULL;
=20
-	if (entity_is_task(se))
-		tsk =3D task_of(se);
+	if (cfs_entity_is_task(cfs_se))
+		tsk =3D cfs_task_of(cfs_se);
=20
-	if (se->statistics.sleep_start) {
-		u64 delta =3D rq_of(cfs_rq)->clock - se->statistics.sleep_start;
+	if (cfs_se->statistics.sleep_start) {
+		u64 delta =3D rq_of(cfs_rq)->clock - cfs_se->statistics.sleep_start;
=20
 		if ((s64)delta < 0)
 			delta =3D 0;
=20
-		if (unlikely(delta > se->statistics.sleep_max))
-			se->statistics.sleep_max =3D delta;
+		if (unlikely(delta > cfs_se->statistics.sleep_max))
+			cfs_se->statistics.sleep_max =3D delta;
=20
-		se->statistics.sleep_start =3D 0;
-		se->statistics.sum_sleep_runtime +=3D delta;
+		cfs_se->statistics.sleep_start =3D 0;
+		cfs_se->statistics.sum_sleep_runtime +=3D delta;
=20
 		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
 			trace_sched_stat_sleep(tsk, delta);
 		}
 	}
-	if (se->statistics.block_start) {
-		u64 delta =3D rq_of(cfs_rq)->clock - se->statistics.block_start;
+	if (cfs_se->statistics.block_start) {
+		u64 delta =3D rq_of(cfs_rq)->clock - cfs_se->statistics.block_start;
=20
 		if ((s64)delta < 0)
 			delta =3D 0;
=20
-		if (unlikely(delta > se->statistics.block_max))
-			se->statistics.block_max =3D delta;
+		if (unlikely(delta > cfs_se->statistics.block_max))
+			cfs_se->statistics.block_max =3D delta;
=20
-		se->statistics.block_start =3D 0;
-		se->statistics.sum_sleep_runtime +=3D delta;
+		cfs_se->statistics.block_start =3D 0;
+		cfs_se->statistics.sum_sleep_runtime +=3D delta;
=20
 		if (tsk) {
 			if (tsk->in_iowait) {
-				se->statistics.iowait_sum +=3D delta;
-				se->statistics.iowait_count++;
+				cfs_se->statistics.iowait_sum +=3D delta;
+				cfs_se->statistics.iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
 			}
=20
@@ -891,10 +905,11 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, st=
ruct sched_entity *se)
 #endif
 }
=20
-static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void
+check_spread(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
 #ifdef CONFIG_SCHED_DEBUG
-	s64 d =3D se->vruntime - cfs_rq->min_vruntime;
+	s64 d =3D cfs_se->vruntime - cfs_rq->min_vruntime;
=20
 	if (d < 0)
 		d =3D -d;
@@ -905,7 +920,8 @@ static void check_spread(struct cfs_rq *cfs_rq, struct =
sched_entity *se)
 }
=20
 static void
-place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
+place_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se,
+	     int initial)
 {
 	u64 vruntime =3D cfs_rq->min_vruntime;
=20
@@ -916,7 +932,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity=
 *se, int initial)
 	 * stays open at the end.
 	 */
 	if (initial && sched_feat(START_DEBIT))
-		vruntime +=3D sched_vslice(cfs_rq, se);
+		vruntime +=3D sched_vslice(cfs_rq, cfs_se);
=20
 	/* sleeps up to a single latency don't count. */
 	if (!initial) {
@@ -933,88 +949,92 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_enti=
ty *se, int initial)
 	}
=20
 	/* ensure we never gain time by being placed backwards. */
-	vruntime =3D max_vruntime(se->vruntime, vruntime);
+	vruntime =3D max_vruntime(cfs_se->vruntime, vruntime);
=20
-	se->vruntime =3D vruntime;
+	cfs_se->vruntime =3D vruntime;
 }
=20
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se,
+	       int flags)
 {
 	/*
 	 * Update the normalized vruntime before updating min_vruntime
 	 * through callig update_curr().
 	 */
 	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
-		se->vruntime +=3D cfs_rq->min_vruntime;
+		cfs_se->vruntime +=3D cfs_rq->min_vruntime;
=20
 	/*
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	update_cfs_shares(cfs_rq, se->load.weight);
-	account_entity_enqueue(cfs_rq, se);
+	update_cfs_shares(cfs_rq, cfs_se->load.weight);
+	account_entity_enqueue(cfs_rq, cfs_se);
=20
 	if (flags & ENQUEUE_WAKEUP) {
-		place_entity(cfs_rq, se, 0);
-		enqueue_sleeper(cfs_rq, se);
+		place_entity(cfs_rq, cfs_se, 0);
+		enqueue_sleeper(cfs_rq, cfs_se);
 	}
=20
-	update_stats_enqueue(cfs_rq, se);
-	check_spread(cfs_rq, se);
-	if (se !=3D cfs_rq->curr)
-		__enqueue_entity(cfs_rq, se);
-	se->on_rq =3D 1;
+	update_stats_enqueue(cfs_rq, cfs_se);
+	check_spread(cfs_rq, cfs_se);
+	if (cfs_se !=3D cfs_rq->curr)
+		__enqueue_entity(cfs_rq, cfs_se);
+	cfs_se->on_rq =3D 1;
=20
 	if (cfs_rq->nr_running =3D=3D 1)
 		list_add_leaf_cfs_rq(cfs_rq);
 }
=20
-static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se=
)
+static void
+__clear_buddies(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
-	if (!se || cfs_rq->last =3D=3D se)
+	if (!cfs_se || cfs_rq->last =3D=3D cfs_se)
 		cfs_rq->last =3D NULL;
=20
-	if (!se || cfs_rq->next =3D=3D se)
+	if (!cfs_se || cfs_rq->next =3D=3D cfs_se)
 		cfs_rq->next =3D NULL;
 }
=20
-static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void
+clear_buddies(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
-	for_each_sched_entity(se)
-		__clear_buddies(cfs_rq_of(se), se);
+	for_each_sched_cfs_entity(cfs_se)
+		__clear_buddies(cfs_rq_of(cfs_se), cfs_se);
 }
=20
 static void
-dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
+dequeue_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se,
+	       int flags)
 {
 	/*
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
=20
-	update_stats_dequeue(cfs_rq, se);
+	update_stats_dequeue(cfs_rq, cfs_se);
 	if (flags & DEQUEUE_SLEEP) {
 #ifdef CONFIG_SCHEDSTATS
-		if (entity_is_task(se)) {
-			struct task_struct *tsk =3D task_of(se);
+		if (cfs_entity_is_task(cfs_se)) {
+			struct task_struct *tsk =3D cfs_task_of(cfs_se);
=20
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->statistics.sleep_start =3D rq_of(cfs_rq)->clock;
+				cfs_se->statistics.sleep_start =3D rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->statistics.block_start =3D rq_of(cfs_rq)->clock;
+				cfs_se->statistics.block_start =3D rq_of(cfs_rq)->clock;
 		}
 #endif
 	}
=20
-	clear_buddies(cfs_rq, se);
+	clear_buddies(cfs_rq, cfs_se);
=20
-	if (se !=3D cfs_rq->curr)
-		__dequeue_entity(cfs_rq, se);
-	se->on_rq =3D 0;
+	if (cfs_se !=3D cfs_rq->curr)
+		__dequeue_entity(cfs_rq, cfs_se);
+	cfs_se->on_rq =3D 0;
 	update_cfs_load(cfs_rq, 0);
-	account_entity_dequeue(cfs_rq, se);
+	account_entity_dequeue(cfs_rq, cfs_se);
 	update_min_vruntime(cfs_rq);
 	update_cfs_shares(cfs_rq, 0);
=20
@@ -1024,14 +1044,14 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_=
entity *se, int flags)
 	 * movement in our normalized position.
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
-		se->vruntime -=3D cfs_rq->min_vruntime;
+		cfs_se->vruntime -=3D cfs_rq->min_vruntime;
 }
=20
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void
-check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
+check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_cfs_entity *curr)
 {
 	unsigned long ideal_runtime, delta_exec;
=20
@@ -1059,8 +1079,8 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sche=
d_entity *curr)
 		return;
=20
 	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se =3D __pick_next_entity(cfs_rq);
-		s64 delta =3D curr->vruntime - se->vruntime;
+		struct sched_cfs_entity *cfs_se =3D __pick_next_entity(cfs_rq);
+		s64 delta =3D curr->vruntime - cfs_se->vruntime;
=20
 		if (delta > ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
@@ -1068,58 +1088,59 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sc=
hed_entity *curr)
 }
=20
 static void
-set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+set_next_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
 	/* 'current' is not kept within the tree. */
-	if (se->on_rq) {
+	if (cfs_se->on_rq) {
 		/*
 		 * Any task has to be enqueued before it get to execute on
 		 * a CPU. So account for the time it spent waiting on the
 		 * runqueue.
 		 */
-		update_stats_wait_end(cfs_rq, se);
-		__dequeue_entity(cfs_rq, se);
+		update_stats_wait_end(cfs_rq, cfs_se);
+		__dequeue_entity(cfs_rq, cfs_se);
 	}
=20
-	update_stats_curr_start(cfs_rq, se);
-	cfs_rq->curr =3D se;
+	update_stats_curr_start(cfs_rq, cfs_se);
+	cfs_rq->curr =3D cfs_se;
 #ifdef CONFIG_SCHEDSTATS
 	/*
 	 * Track our maximum slice length, if the CPU's load is at
 	 * least twice that of our own weight (i.e. dont track it
 	 * when there are only lesser-weight tasks around):
 	 */
-	if (rq_of(cfs_rq)->load.weight >=3D 2*se->load.weight) {
-		se->statistics.slice_max =3D max(se->statistics.slice_max,
-			se->sum_exec_runtime - se->prev_sum_exec_runtime);
+	if (rq_of(cfs_rq)->load.weight >=3D 2*cfs_se->load.weight) {
+		cfs_se->statistics.slice_max =3D max(cfs_se->statistics.slice_max,
+			cfs_se->sum_exec_runtime - cfs_se->prev_sum_exec_runtime);
 	}
 #endif
-	se->prev_sum_exec_runtime =3D se->sum_exec_runtime;
+	cfs_se->prev_sum_exec_runtime =3D cfs_se->sum_exec_runtime;
 }
=20
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
+static int wakeup_preempt_entity(struct sched_cfs_entity *curr,
+				 struct sched_cfs_entity *cfs_se);
=20
-static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_cfs_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se =3D __pick_next_entity(cfs_rq);
-	struct sched_entity *left =3D se;
+	struct sched_cfs_entity *cfs_se =3D __pick_next_entity(cfs_rq);
+	struct sched_cfs_entity *left =3D cfs_se;
=20
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se =3D cfs_rq->next;
+		cfs_se =3D cfs_rq->next;
=20
 	/*
 	 * Prefer last buddy, try to return the CPU to a preempted task.
 	 */
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
-		se =3D cfs_rq->last;
+		cfs_se =3D cfs_rq->last;
=20
-	clear_buddies(cfs_rq, se);
+	clear_buddies(cfs_rq, cfs_se);
=20
-	return se;
+	return cfs_se;
 }
=20
-static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *pr=
ev)
+static void
+put_prev_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *prev)
 {
 	/*
 	 * If still on the runqueue then deactivate_task()
@@ -1138,7 +1159,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, st=
ruct sched_entity *prev)
 }
=20
 static void
-entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
+entity_tick(struct cfs_rq *cfs_rq, struct sched_cfs_entity *curr, int queu=
ed)
 {
 	/*
 	 * Update run-time statistics of the 'current'.
@@ -1178,14 +1199,15 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_ent=
ity *curr, int queued)
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
-	struct sched_entity *se =3D &p->se;
-	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
+	struct sched_cfs_entity *cfs_se =3D &p->cfs;
+	struct cfs_rq *cfs_rq =3D cfs_rq_of(cfs_se);
=20
 	WARN_ON(task_rq(p) !=3D rq);
=20
 	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
-		u64 slice =3D sched_slice(cfs_rq, se);
-		u64 ran =3D se->sum_exec_runtime - se->prev_sum_exec_runtime;
+		u64 slice =3D sched_slice(cfs_rq, cfs_se);
+		u64 ran =3D cfs_se->sum_exec_runtime -
+				cfs_se->prev_sum_exec_runtime;
 		s64 delta =3D slice - ran;
=20
 		if (delta < 0) {
@@ -1217,7 +1239,7 @@ static void hrtick_update(struct rq *rq)
 	if (curr->sched_class !=3D &fair_sched_class)
 		return;
=20
-	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
+	if (cfs_rq_of(&curr->cfs)->nr_running < sched_nr_latency)
 		hrtick_start_fair(rq, curr);
 }
 #else /* !CONFIG_SCHED_HRTICK */
@@ -1240,18 +1262,18 @@ static void
 enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se =3D &p->se;
+	struct sched_cfs_entity *cfs_se =3D &p->cfs;
=20
-	for_each_sched_entity(se) {
-		if (se->on_rq)
+	for_each_sched_cfs_entity(cfs_se) {
+		if (cfs_se->on_rq)
 			break;
-		cfs_rq =3D cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, flags);
+		cfs_rq =3D cfs_rq_of(cfs_se);
+		enqueue_entity(cfs_rq, cfs_se, flags);
 		flags =3D ENQUEUE_WAKEUP;
 	}
=20
-	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
+	for_each_sched_cfs_entity(cfs_se) {
+		struct cfs_rq *cfs_rq =3D cfs_rq_of(cfs_se);
=20
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
@@ -1268,11 +1290,11 @@ enqueue_task_fair(struct rq *rq, struct task_struct=
 *p, int flags)
 static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int fl=
ags)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se =3D &p->se;
+	struct sched_cfs_entity *cfs_se =3D &p->cfs;
=20
-	for_each_sched_entity(se) {
-		cfs_rq =3D cfs_rq_of(se);
-		dequeue_entity(cfs_rq, se, flags);
+	for_each_sched_cfs_entity(cfs_se) {
+		cfs_rq =3D cfs_rq_of(cfs_se);
+		dequeue_entity(cfs_rq, cfs_se, flags);
=20
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
@@ -1280,8 +1302,8 @@ static void dequeue_task_fair(struct rq *rq, struct t=
ask_struct *p, int flags)
 		flags |=3D DEQUEUE_SLEEP;
 	}
=20
-	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
+	for_each_sched_cfs_entity(cfs_se) {
+		struct cfs_rq *cfs_rq =3D cfs_rq_of(cfs_se);
=20
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq, 0);
@@ -1299,7 +1321,7 @@ static void yield_task_fair(struct rq *rq)
 {
 	struct task_struct *curr =3D rq->curr;
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(curr);
-	struct sched_entity *rightmost, *se =3D &curr->se;
+	struct sched_cfs_entity *rightmost, *cfs_se =3D &curr->cfs;
=20
 	/*
 	 * Are we the only task in the tree?
@@ -1307,7 +1329,7 @@ static void yield_task_fair(struct rq *rq)
 	if (unlikely(cfs_rq->nr_running =3D=3D 1))
 		return;
=20
-	clear_buddies(cfs_rq, se);
+	clear_buddies(cfs_rq, cfs_se);
=20
 	if (likely(!sysctl_sched_compat_yield) && curr->policy !=3D SCHED_BATCH) =
{
 		update_rq_clock(rq);
@@ -1325,7 +1347,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Already in the rightmost position?
 	 */
-	if (unlikely(!rightmost || entity_before(rightmost, se)))
+	if (unlikely(!rightmost || entity_before(rightmost, cfs_se)))
 		return;
=20
 	/*
@@ -1333,17 +1355,17 @@ static void yield_task_fair(struct rq *rq)
 	 * Upon rescheduling, sched_class::put_prev_task() will place
 	 * 'current' within the tree based on its new key value.
 	 */
-	se->vruntime =3D rightmost->vruntime + 1;
+	cfs_se->vruntime =3D rightmost->vruntime + 1;
 }
=20
 #ifdef CONFIG_SMP
=20
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
 {
-	struct sched_entity *se =3D &p->se;
-	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
+	struct sched_cfs_entity *cfs_se =3D &p->cfs;
+	struct cfs_rq *cfs_rq =3D cfs_rq_of(cfs_se);
=20
-	se->vruntime -=3D cfs_rq->min_vruntime;
+	cfs_se->vruntime -=3D cfs_rq->min_vruntime;
 }
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1356,17 +1378,17 @@ static void task_waking_fair(struct rq *rq, struct =
task_struct *p)
  */
 static long effective_load(struct task_group *tg, int cpu, long wl, long w=
g)
 {
-	struct sched_entity *se =3D tg->se[cpu];
+	struct sched_cfs_entity *cfs_se =3D tg->cfs_se[cpu];
=20
 	if (!tg->parent)
 		return wl;
=20
-	for_each_sched_entity(se) {
+	for_each_sched_cfs_entity(cfs_se) {
 		long S, rw, s, a, b;
=20
-		S =3D se->my_q->tg->shares;
-		s =3D se->load.weight;
-		rw =3D se->my_q->load.weight;
+		S =3D cfs_se->my_q->tg->shares;
+		s =3D cfs_se->load.weight;
+		rw =3D cfs_se->my_q->load.weight;
=20
 		a =3D S*(rw + wl);
 		b =3D S*rw + s*wg;
@@ -1422,14 +1444,14 @@ static int wake_affine(struct sched_domain *sd, str=
uct task_struct *p, int sync)
 	rcu_read_lock();
 	if (sync) {
 		tg =3D task_group(current);
-		weight =3D current->se.load.weight;
+		weight =3D current->cfs.load.weight;
=20
 		this_load +=3D effective_load(tg, this_cpu, -weight, -weight);
 		load +=3D effective_load(tg, prev_cpu, 0, -weight);
 	}
=20
 	tg =3D task_group(p);
-	weight =3D p->se.load.weight;
+	weight =3D p->cfs.load.weight;
=20
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
@@ -1465,7 +1487,7 @@ static int wake_affine(struct sched_domain *sd, struc=
t task_struct *p, int sync)
 	if (sync && balanced)
 		return 1;
=20
-	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
+	schedstat_inc(p, cfs.statistics.nr_wakeups_affine_attempts);
 	tl_per_task =3D cpu_avg_load_per_task(this_cpu);
=20
 	if (balanced ||
@@ -1477,7 +1499,7 @@ static int wake_affine(struct sched_domain *sd, struc=
t task_struct *p, int sync)
 		 * there is no bad imbalance.
 		 */
 		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.statistics.nr_wakeups_affine);
+		schedstat_inc(p, cfs.statistics.nr_wakeups_affine);
=20
 		return 1;
 	}
@@ -1738,7 +1760,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct=
 *p, int sd_flag, int wake_
 #endif /* CONFIG_SMP */
=20
 static unsigned long
-wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
+wakeup_gran(struct sched_cfs_entity *curr, struct sched_cfs_entity *cfs_se=
)
 {
 	unsigned long gran =3D sysctl_sched_wakeup_granularity;
=20
@@ -1755,8 +1777,8 @@ wakeup_gran(struct sched_entity *curr, struct sched_e=
ntity *se)
 	 * This is especially important for buddies when the leftmost
 	 * task is higher priority than the buddy.
 	 */
-	if (unlikely(se->load.weight !=3D NICE_0_LOAD))
-		gran =3D calc_delta_fair(gran, se);
+	if (unlikely(cfs_se->load.weight !=3D NICE_0_LOAD))
+		gran =3D calc_delta_fair(gran, cfs_se);
=20
 	return gran;
 }
@@ -1775,34 +1797,34 @@ wakeup_gran(struct sched_entity *curr, struct sched=
_entity *se)
  *  w(c, s3) =3D  1
  *
  */
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
+static int wakeup_preempt_entity(struct sched_cfs_entity *curr,
+				 struct sched_cfs_entity *cfs_se)
 {
-	s64 gran, vdiff =3D curr->vruntime - se->vruntime;
+	s64 gran, vdiff =3D curr->vruntime - cfs_se->vruntime;
=20
 	if (vdiff <=3D 0)
 		return -1;
=20
-	gran =3D wakeup_gran(curr, se);
+	gran =3D wakeup_gran(curr, cfs_se);
 	if (vdiff > gran)
 		return 1;
=20
 	return 0;
 }
=20
-static void set_last_buddy(struct sched_entity *se)
+static void set_last_buddy(struct sched_cfs_entity *cfs_se)
 {
-	if (likely(task_of(se)->policy !=3D SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->last =3D se;
+	if (likely(cfs_task_of(cfs_se)->policy !=3D SCHED_IDLE)) {
+		for_each_sched_cfs_entity(cfs_se)
+			cfs_rq_of(cfs_se)->last =3D cfs_se;
 	}
 }
=20
-static void set_next_buddy(struct sched_entity *se)
+static void set_next_buddy(struct sched_cfs_entity *cfs_se)
 {
-	if (likely(task_of(se)->policy !=3D SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->next =3D se;
+	if (likely(cfs_task_of(cfs_se)->policy !=3D SCHED_IDLE)) {
+		for_each_sched_cfs_entity(cfs_se)
+			cfs_rq_of(cfs_se)->next =3D cfs_se;
 	}
 }
=20
@@ -1812,15 +1834,15 @@ static void set_next_buddy(struct sched_entity *se)
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int=
 wake_flags)
 {
 	struct task_struct *curr =3D rq->curr;
-	struct sched_entity *se =3D &curr->se, *pse =3D &p->se;
+	struct sched_cfs_entity *cfs_se =3D &curr->cfs, *cfs_pse =3D &p->cfs;
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(curr);
 	int scale =3D cfs_rq->nr_running >=3D sched_nr_latency;
=20
-	if (unlikely(se =3D=3D pse))
+	if (unlikely(cfs_se =3D=3D cfs_pse))
 		return;
=20
 	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
-		set_next_buddy(pse);
+		set_next_buddy(cfs_pse);
=20
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1844,9 +1866,9 @@ static void check_preempt_wakeup(struct rq *rq, struc=
t task_struct *p, int wake_
 		return;
=20
 	update_curr(cfs_rq);
-	find_matching_se(&se, &pse);
-	BUG_ON(!pse);
-	if (wakeup_preempt_entity(se, pse) =3D=3D 1)
+	find_matching_se(&cfs_se, &cfs_pse);
+	BUG_ON(!cfs_pse);
+	if (wakeup_preempt_entity(cfs_se, cfs_pse) =3D=3D 1)
 		goto preempt;
=20
 	return;
@@ -1862,29 +1884,29 @@ preempt:
 	 * Also, during early boot the idle thread is in the fair class,
 	 * for obvious reasons its a bad idea to schedule back to it.
 	 */
-	if (unlikely(!se->on_rq || curr =3D=3D rq->idle))
+	if (unlikely(!cfs_se->on_rq || curr =3D=3D rq->idle))
 		return;
=20
-	if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
-		set_last_buddy(se);
+	if (sched_feat(LAST_BUDDY) && scale && cfs_entity_is_task(cfs_se))
+		set_last_buddy(cfs_se);
 }
=20
 static struct task_struct *pick_next_task_fair(struct rq *rq)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq =3D &rq->cfs;
-	struct sched_entity *se;
+	struct sched_cfs_entity *cfs_se;
=20
 	if (!cfs_rq->nr_running)
 		return NULL;
=20
 	do {
-		se =3D pick_next_entity(cfs_rq);
-		set_next_entity(cfs_rq, se);
-		cfs_rq =3D group_cfs_rq(se);
+		cfs_se =3D pick_next_entity(cfs_rq);
+		set_next_entity(cfs_rq, cfs_se);
+		cfs_rq =3D group_cfs_rq(cfs_se);
 	} while (cfs_rq);
=20
-	p =3D task_of(se);
+	p =3D cfs_task_of(cfs_se);
 	hrtick_start_fair(rq, p);
=20
 	return p;
@@ -1895,12 +1917,12 @@ static struct task_struct *pick_next_task_fair(stru=
ct rq *rq)
  */
 static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
 {
-	struct sched_entity *se =3D &prev->se;
+	struct sched_cfs_entity *cfs_se =3D &prev->cfs;
 	struct cfs_rq *cfs_rq;
=20
-	for_each_sched_entity(se) {
-		cfs_rq =3D cfs_rq_of(se);
-		put_prev_entity(cfs_rq, se);
+	for_each_sched_cfs_entity(cfs_se) {
+		cfs_rq =3D cfs_rq_of(cfs_se);
+		put_prev_entity(cfs_rq, cfs_se);
 	}
 }
=20
@@ -1938,13 +1960,13 @@ int can_migrate_task(struct task_struct *p, struct =
rq *rq, int this_cpu,
 	 * 3) are cache-hot on their current CPU.
 	 */
 	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
+		schedstat_inc(p, cfs.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
 	*all_pinned =3D 0;
=20
 	if (task_running(rq, p)) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
+		schedstat_inc(p, cfs.statistics.nr_failed_migrations_running);
 		return 0;
 	}
=20
@@ -1960,14 +1982,14 @@ int can_migrate_task(struct task_struct *p, struct =
rq *rq, int this_cpu,
 #ifdef CONFIG_SCHEDSTATS
 		if (tsk_cache_hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
-			schedstat_inc(p, se.statistics.nr_forced_migrations);
+			schedstat_inc(p, cfs.statistics.nr_forced_migrations);
 		}
 #endif
 		return 1;
 	}
=20
 	if (tsk_cache_hot) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
+		schedstat_inc(p, cfs.statistics.nr_failed_migrations_hot);
 		return 0;
 	}
 	return 1;
@@ -1989,7 +2011,7 @@ move_one_task(struct rq *this_rq, int this_cpu, struc=
t rq *busiest,
 	int pinned =3D 0;
=20
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
-		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
+		list_for_each_entry_safe(p, n, &cfs_rq->tasks, cfs.group_node) {
=20
 			if (!can_migrate_task(p, busiest, this_cpu,
 						sd, idle, &pinned))
@@ -2024,17 +2046,17 @@ balance_tasks(struct rq *this_rq, int this_cpu, str=
uct rq *busiest,
=20
 	pinned =3D 1;
=20
-	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
+	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, cfs.group_node) {
 		if (loops++ > sysctl_sched_nr_migrate)
 			break;
=20
-		if ((p->se.load.weight >> 1) > rem_load_move ||
+		if ((p->cfs.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned))
 			continue;
=20
 		pull_task(busiest, p, this_rq, this_cpu);
 		pulled++;
-		rem_load_move -=3D p->se.load.weight;
+		rem_load_move -=3D p->cfs.load.weight;
=20
 #ifdef CONFIG_PREEMPT
 		/*
@@ -2080,7 +2102,7 @@ static int update_shares_cpu(struct task_group *tg, i=
nt cpu)
 	unsigned long flags;
 	struct rq *rq;
=20
-	if (!tg->se[cpu])
+	if (!tg->cfs_se[cpu])
 		return 0;
=20
 	rq =3D cpu_rq(cpu);
@@ -3996,11 +4018,11 @@ static inline void idle_balance(int cpu, struct rq =
*rq)
 static void task_tick_fair(struct rq *rq, struct task_struct *curr, int qu=
eued)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se =3D &curr->se;
+	struct sched_cfs_entity *cfs_se =3D &curr->cfs;
=20
-	for_each_sched_entity(se) {
-		cfs_rq =3D cfs_rq_of(se);
-		entity_tick(cfs_rq, se, queued);
+	for_each_sched_cfs_entity(cfs_se) {
+		cfs_rq =3D cfs_rq_of(cfs_se);
+		entity_tick(cfs_rq, cfs_se, queued);
 	}
 }
=20
@@ -4012,7 +4034,7 @@ static void task_tick_fair(struct rq *rq, struct task=
_struct *curr, int queued)
 static void task_fork_fair(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(current);
-	struct sched_entity *se =3D &p->se, *curr =3D cfs_rq->curr;
+	struct sched_cfs_entity *cfs_se =3D &p->cfs, *curr =3D cfs_rq->curr;
 	int this_cpu =3D smp_processor_id();
 	struct rq *rq =3D this_rq();
 	unsigned long flags;
@@ -4030,19 +4052,20 @@ static void task_fork_fair(struct task_struct *p)
 	update_curr(cfs_rq);
=20
 	if (curr)
-		se->vruntime =3D curr->vruntime;
-	place_entity(cfs_rq, se, 1);
+		cfs_se->vruntime =3D curr->vruntime;
+	place_entity(cfs_rq, cfs_se, 1);
=20
-	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
+	if (sysctl_sched_child_runs_first &&
+	    curr && entity_before(curr, cfs_se)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
 		 */
-		swap(curr->vruntime, se->vruntime);
+		swap(curr->vruntime, cfs_se->vruntime);
 		resched_task(rq->curr);
 	}
=20
-	se->vruntime -=3D cfs_rq->min_vruntime;
+	cfs_se->vruntime -=3D cfs_rq->min_vruntime;
=20
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
@@ -4090,10 +4113,10 @@ static void switched_to_fair(struct rq *rq, struct =
task_struct *p,
  */
 static void set_curr_task_fair(struct rq *rq)
 {
-	struct sched_entity *se =3D &rq->curr->se;
+	struct sched_cfs_entity *cfs_se =3D &rq->curr->cfs;
=20
-	for_each_sched_entity(se)
-		set_next_entity(cfs_rq_of(se), se);
+	for_each_sched_cfs_entity(cfs_se)
+		set_next_entity(cfs_rq_of(cfs_se), cfs_se);
 }
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -4113,16 +4136,16 @@ static void task_move_group_fair(struct task_struct=
 *p, int on_rq)
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
 	if (!on_rq)
-		p->se.vruntime -=3D cfs_rq_of(&p->se)->min_vruntime;
+		p->cfs.vruntime -=3D cfs_rq_of(&p->cfs)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		p->se.vruntime +=3D cfs_rq_of(&p->se)->min_vruntime;
+		p->cfs.vruntime +=3D cfs_rq_of(&p->cfs)->min_vruntime;
 }
 #endif
=20
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct=
 *task)
 {
-	struct sched_entity *se =3D &task->se;
+	struct sched_cfs_entity *cfs_se =3D &task->cfs;
 	unsigned int rr_interval =3D 0;
=20
 	/*
@@ -4130,7 +4153,7 @@ static unsigned int get_rr_interval_fair(struct rq *r=
q, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval =3D NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval =3D NS_TO_JIFFIES(sched_slice(&rq->cfs, cfs_se));
=20
 	return rr_interval;
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c914ec7..2bba302 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -628,16 +628,16 @@ static void update_curr_rt(struct rq *rq)
 	if (!task_has_rt_policy(curr))
 		return;
=20
-	delta_exec =3D rq->clock_task - curr->se.exec_start;
+	delta_exec =3D rq->clock_task - curr->cfs.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec =3D 0;
=20
-	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_=
max, delta_exec));
+	schedstat_set(curr->cfs.statistics.exec_max, max(curr->cfs.statistics.exe=
c_max, delta_exec));
=20
-	curr->se.sum_exec_runtime +=3D delta_exec;
+	curr->cfs.sum_exec_runtime +=3D delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
=20
-	curr->se.exec_start =3D rq->clock_task;
+	curr->cfs.exec_start =3D rq->clock_task;
 	cpuacct_charge(curr, delta_exec);
=20
 	sched_rt_avg_update(rq, delta_exec);
@@ -1099,7 +1099,7 @@ static struct task_struct *_pick_next_task_rt(struct =
rq *rq)
 	} while (rt_rq);
=20
 	p =3D rt_task_of(rt_se);
-	p->se.exec_start =3D rq->clock_task;
+	p->cfs.exec_start =3D rq->clock_task;
=20
 	return p;
 }
@@ -1126,13 +1126,13 @@ static struct task_struct *pick_next_task_rt(struct=
 rq *rq)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
-	p->se.exec_start =3D 0;
+	p->cfs.exec_start =3D 0;
=20
 	/*
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
+	if (p->cfs.on_rq && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
=20
@@ -1283,7 +1283,7 @@ static struct rq *find_lock_lowest_rq(struct task_str=
uct *task, struct rq *rq)
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
-				     !task->se.on_rq)) {
+				     !task->cfs.on_rq)) {
=20
 				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq =3D NULL;
@@ -1317,7 +1317,7 @@ static struct task_struct *pick_next_pushable_task(st=
ruct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->rt.nr_cpus_allowed <=3D 1);
=20
-	BUG_ON(!p->se.on_rq);
+	BUG_ON(!p->cfs.on_rq);
 	BUG_ON(!rt_task(p));
=20
 	return p;
@@ -1463,7 +1463,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p =3D=3D src_rq->curr);
-			WARN_ON(!p->se.on_rq);
+			WARN_ON(!p->cfs.on_rq);
=20
 			/*
 			 * There's a chance that p is higher in priority
@@ -1534,7 +1534,7 @@ static void set_cpus_allowed_rt(struct task_struct *p=
,
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->se.on_rq && (weight !=3D p->rt.nr_cpus_allowed)) {
+	if (p->cfs.on_rq && (weight !=3D p->rt.nr_cpus_allowed)) {
 		struct rq *rq =3D task_rq(p);
=20
 		if (!task_current(rq, p)) {
@@ -1701,7 +1701,7 @@ static void watchdog(struct rq *rq, struct task_struc=
t *p)
 		p->rt.timeout++;
 		next =3D DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
 		if (p->rt.timeout > next)
-			p->cputime_expires.sched_exp =3D p->se.sum_exec_runtime;
+			p->cputime_expires.sched_exp =3D p->cfs.sum_exec_runtime;
 	}
 }
=20
@@ -1737,7 +1737,7 @@ static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p =3D rq->curr;
=20
-	p->se.exec_start =3D rq->clock_task;
+	p->cfs.exec_start =3D rq->clock_task;
=20
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 2bf6b47..763732d 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -26,7 +26,7 @@ static struct task_struct *pick_next_task_stop(struct rq =
*rq)
 {
 	struct task_struct *stop =3D rq->stop;
=20
-	if (stop && stop->se.on_rq)
+	if (stop && stop->cfs.on_rq)
 		return stop;
=20
 	return NULL;
--=20
1.7.2.3

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-QcWKPA396/s5Ldl/28UW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jRCkACgkQk4XaBE3IOsRspACcDYhBWoeQKssGfDYKsgBphMA8
njcAni5yEEnax4oD0GkznzgYOLHB8uL6
=8g46
-----END PGP SIGNATURE-----

--=-QcWKPA396/s5Ldl/28UW--

