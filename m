Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1ADQCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:02:20 -0500
Received: from ms01.sssup.it ([193.205.80.99]:40420 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751162Ab1ADQCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:02:18 -0500
Subject: [RFC][PATCH 2/3] sched: make `struct sched_entity' independent
 from the scheduling class.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iTumfD0B3u3XG3BTOCF6"
Date: Tue, 04 Jan 2011 17:01:53 +0100
Message-ID: <1294156913.6169.151.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iTumfD0B3u3XG3BTOCF6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Now that the fair scheduling entity structure is called
sched_cfs_entity we can use the name sched_entity for a more
general data structure, which accommodates both sched_cfs_entity
and sched_rt_entity, along with all the fields that are common
and useful for both the classes.

In fact, it sounds a bit awkward for fields like on_rq or
exec_start, that are meaningful and actually used from within
sched_rt.c (for RT tasks and groups scheduling), to be placed
in some other scheduling class' scheduling entity.

This commit addresses that. Notice that it places
sched_cfs_entity and sched_rt_entity inside sched_entity as full
structure, it doesn't use an union for them yet.

No fields are added, and the memory occupation of this solution
should be pretty much the same of the previous one, apart from
the case where just one of CONFIG_FAIR_GROUP_SCHED and
CONFIG_RT_GROUP_SCHED is defined, which is a bit more expensive
than before.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 fs/proc/base.c            |    2 +-
 include/linux/init_task.h |    8 +-
 include/linux/sched.h     |   33 ++++--
 kernel/delayacct.c        |    2 +-
 kernel/exit.c             |    2 +-
 kernel/kthread.c          |    2 +-
 kernel/posix-cpu-timers.c |   14 ++--
 kernel/sched.c            |  262 ++++++++++++++++++++++++++---------------=
----
 kernel/sched_debug.c      |  109 ++++++++++---------
 kernel/sched_fair.c       |  184 +++++++++++++++++--------------
 kernel/sched_rt.c         |   80 +++++++-------
 kernel/sched_stoptask.c   |    2 +-
 12 files changed, 385 insertions(+), 315 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9591d6e..08cba2c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -356,7 +356,7 @@ static int proc_pid_stack(struct seq_file *m, struct pi=
d_namespace *ns,
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
 	return sprintf(buffer, "%llu %llu %lu\n",
-			(unsigned long long)task->cfs.sum_exec_runtime,
+			(unsigned long long)task->se.sum_exec_runtime,
 			(unsigned long long)task->sched_info.run_delay,
 			task->sched_info.pcount);
 }
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 8baee0b..cd6238b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -142,11 +142,11 @@ extern struct cred init_cred;
 	.cpus_allowed	=3D CPU_MASK_ALL,					\
 	.mm		=3D NULL,						\
 	.active_mm	=3D &init_mm,					\
-	.cfs		=3D {						\
-		.group_node 	=3D LIST_HEAD_INIT(tsk.cfs.group_node),	\
+	.se.cfs		=3D {						\
+		.group_node 	=3D LIST_HEAD_INIT(tsk.se.cfs.group_node),\
 	},								\
-	.rt		=3D {						\
-		.run_list	=3D LIST_HEAD_INIT(tsk.rt.run_list),	\
+	.se.rt		=3D {						\
+		.run_list	=3D LIST_HEAD_INIT(tsk.se.rt.run_list),	\
 		.time_slice	=3D HZ, 					\
 		.nr_cpus_allowed =3D NR_CPUS,				\
 	},								\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55adf37..df358ba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1141,18 +1141,8 @@ struct sched_cfs_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
 	struct list_head	group_node;
-	unsigned int		on_rq;
=20
-	u64			exec_start;
-	u64			sum_exec_runtime;
 	u64			vruntime;
-	u64			prev_sum_exec_runtime;
-
-	u64			nr_migrations;
-
-#ifdef CONFIG_SCHEDSTATS
-	struct sched_statistics statistics;
-#endif
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct sched_cfs_entity *parent;
@@ -1179,6 +1169,26 @@ struct sched_rt_entity {
 #endif
 };
=20
+struct sched_entity {
+	unsigned int on_rq;
+	u64 exec_start;
+	u64 sum_exec_runtime;
+	u64 prev_sum_exec_runtime;
+	u64 nr_migrations;
+
+	/*union {
+		struct sched_cfs_entity cfs;
+		struct sched_rt_entity rt;
+	};*/
+	struct sched_cfs_entity cfs;
+	struct sched_rt_entity rt;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_statistics statistics;
+#endif
+
+};
+
 struct rcu_node;
=20
 enum perf_event_task_context {
@@ -1206,8 +1216,7 @@ struct task_struct {
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;
 	const struct sched_class *sched_class;
-	struct sched_cfs_entity cfs;
-	struct sched_rt_entity rt;
+	struct sched_entity se;
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index f314f56..ead9b61 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -128,7 +128,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct tas=
k_struct *tsk)
 	 */
 	t1 =3D tsk->sched_info.pcount;
 	t2 =3D tsk->sched_info.run_delay;
-	t3 =3D tsk->cfs.sum_exec_runtime;
+	t3 =3D tsk->se.sum_exec_runtime;
=20
 	d->cpu_count +=3D t1;
=20
diff --git a/kernel/exit.c b/kernel/exit.c
index 01087fc..676149a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -132,7 +132,7 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->inblock +=3D task_io_get_inblock(tsk);
 		sig->oublock +=3D task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig->sum_sched_runtime +=3D tsk->cfs.sum_exec_runtime;
+		sig->sum_sched_runtime +=3D tsk->se.sum_exec_runtime;
 	}
=20
 	sig->nr_threads--;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5355cfd..af3b914 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -184,7 +184,7 @@ void kthread_bind(struct task_struct *p, unsigned int c=
pu)
 	}
=20
 	p->cpus_allowed =3D cpumask_of_cpu(cpu);
-	p->rt.nr_cpus_allowed =3D 1;
+	p->se.rt.nr_cpus_allowed =3D 1;
 	p->flags |=3D PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 801169c..6cf4636 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -248,7 +248,7 @@ void thread_group_cputime(struct task_struct *tsk, stru=
ct task_cputime *times)
 	do {
 		times->utime =3D cputime_add(times->utime, t->utime);
 		times->stime =3D cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime +=3D t->cfs.sum_exec_runtime;
+		times->sum_exec_runtime +=3D t->se.sum_exec_runtime;
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -508,7 +508,7 @@ static void cleanup_timers(struct list_head *head,
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->cfs.sum_exec_runtime);
+		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
=20
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
@@ -518,7 +518,7 @@ void posix_cpu_timers_exit_group(struct task_struct *ts=
k)
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime_add(tsk->utime, sig->utime),
 		       cputime_add(tsk->stime, sig->stime),
-		       tsk->cfs.sum_exec_runtime + sig->sum_sched_runtime);
+		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
=20
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count n=
ow)
@@ -949,7 +949,7 @@ static void check_thread_timers(struct task_struct *tsk=
,
 		struct cpu_timer_list *t =3D list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->cfs.sum_exec_runtime < t->expires.sched) {
+		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
 			tsk->cputime_expires.sched_exp =3D t->expires.sched;
 			break;
 		}
@@ -966,7 +966,7 @@ static void check_thread_timers(struct task_struct *tsk=
,
 			ACCESS_ONCE(sig->rlim[RLIMIT_RTTIME].rlim_max);
=20
 		if (hard !=3D RLIM_INFINITY &&
-		    tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
+		    tsk->se.rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
 			/*
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
@@ -974,7 +974,7 @@ static void check_thread_timers(struct task_struct *tsk=
,
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (tsk->rt.timeout > DIV_ROUND_UP(soft, USEC_PER_SEC/HZ)) {
+		if (tsk->se.rt.timeout > DIV_ROUND_UP(soft, USEC_PER_SEC/HZ)) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
@@ -1276,7 +1276,7 @@ static inline int fastpath_timer_check(struct task_st=
ruct *tsk)
 		struct task_cputime task_sample =3D {
 			.utime =3D tsk->utime,
 			.stime =3D tsk->stime,
-			.sum_exec_runtime =3D tsk->cfs.sum_exec_runtime
+			.sum_exec_runtime =3D tsk->se.sum_exec_runtime
 		};
=20
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
diff --git a/kernel/sched.c b/kernel/sched.c
index 5d68fb0..337ed4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -249,9 +249,12 @@ static LIST_HEAD(task_groups);
 struct task_group {
 	struct cgroup_subsys_state css;
=20
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_FAIR_GROUP_SCHED || defined CONFIG_RT_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
-	struct sched_cfs_entity **cfs_se;
+	struct sched_entity **se;
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
@@ -260,7 +263,6 @@ struct task_group {
 #endif
=20
 #ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity **rt_se;
 	struct rt_rq **rt_rq;
=20
 	struct rt_bandwidth rt_bandwidth;
@@ -618,17 +620,32 @@ static inline struct task_group *task_group(struct ta=
sk_struct *p)
 	return autogroup_task_group(p, tg);
 }
=20
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline
+struct sched_cfs_entity *cfs_se_cpu(struct sched_entity **se, int cpu)
+{
+	return se[cpu] ? &se[cpu]->cfs : NULL;
+}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+#ifdef CONFIG_RT_GROUP_SCHED
+static inline
+struct sched_rt_entity *rt_se_cpu(struct sched_entity **se, int cpu)
+{
+	return se[cpu] ? &se[cpu]->rt : NULL;
+}
+#endif /* CONFIG_RT_GROUP_SCHED */
+
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups=
 */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	p->cfs.cfs_rq =3D task_group(p)->cfs_rq[cpu];
-	p->cfs.parent =3D task_group(p)->cfs_se[cpu];
+	p->se.cfs.cfs_rq =3D task_group(p)->cfs_rq[cpu];
+	p->se.cfs.parent =3D cfs_se_cpu(task_group(p)->se, cpu);
 #endif
=20
 #ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  =3D task_group(p)->rt_rq[cpu];
-	p->rt.parent =3D task_group(p)->rt_se[cpu];
+	p->se.rt.rt_rq  =3D task_group(p)->rt_rq[cpu];
+	p->se.rt.parent =3D rt_se_cpu(task_group(p)->se, cpu);
 #endif
 }
=20
@@ -1555,7 +1572,7 @@ static int tg_load_down(struct task_group *tg, void *=
data)
 		load =3D cpu_rq(cpu)->load.weight;
 	} else {
 		load =3D tg->parent->cfs_rq[cpu]->h_load;
-		load *=3D tg->cfs_se[cpu]->load.weight;
+		load *=3D tg->se[cpu]->cfs.load.weight;
 		load /=3D tg->parent->cfs_rq[cpu]->load.weight + 1;
 	}
=20
@@ -1733,13 +1750,13 @@ static void set_load_weight(struct task_struct *p)
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy =3D=3D SCHED_IDLE) {
-		p->cfs.load.weight =3D WEIGHT_IDLEPRIO;
-		p->cfs.load.inv_weight =3D WMULT_IDLEPRIO;
+		p->se.cfs.load.weight =3D WEIGHT_IDLEPRIO;
+		p->se.cfs.load.inv_weight =3D WMULT_IDLEPRIO;
 		return;
 	}
=20
-	p->cfs.load.weight =3D prio_to_weight[p->static_prio - MAX_RT_PRIO];
-	p->cfs.load.inv_weight =3D prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	p->se.cfs.load.weight =3D prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->se.cfs.load.inv_weight =3D prio_to_wmult[p->static_prio - MAX_RT_PRIO]=
;
 }
=20
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1747,7 +1764,7 @@ static void enqueue_task(struct rq *rq, struct task_s=
truct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
-	p->cfs.on_rq =3D 1;
+	p->se.on_rq =3D 1;
 }
=20
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1755,7 +1772,7 @@ static void dequeue_task(struct rq *rq, struct task_s=
truct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, flags);
-	p->cfs.on_rq =3D 0;
+	p->se.on_rq =3D 0;
 }
=20
 /*
@@ -2058,7 +2075,7 @@ static void check_preempt_curr(struct rq *rq, struct =
task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->cfs.on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update =3D 1;
 }
=20
@@ -2081,8 +2098,8 @@ task_hot(struct task_struct *p, u64 now, struct sched=
_domain *sd)
 	 * Buddy candidates are cache hot:
 	 */
 	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
-			(&p->cfs =3D=3D cfs_rq_of(&p->cfs)->next ||
-			 &p->cfs =3D=3D cfs_rq_of(&p->cfs)->last))
+			(&p->se.cfs =3D=3D cfs_rq_of(&p->se.cfs)->next ||
+			 &p->se.cfs =3D=3D cfs_rq_of(&p->se.cfs)->last))
 		return 1;
=20
 	if (sysctl_sched_migration_cost =3D=3D -1)
@@ -2090,7 +2107,7 @@ task_hot(struct task_struct *p, u64 now, struct sched=
_domain *sd)
 	if (sysctl_sched_migration_cost =3D=3D 0)
 		return 0;
=20
-	delta =3D now - p->cfs.exec_start;
+	delta =3D now - p->se.exec_start;
=20
 	return delta < (s64)sysctl_sched_migration_cost;
 }
@@ -2109,7 +2126,7 @@ void set_task_cpu(struct task_struct *p, unsigned int=
 new_cpu)
 	trace_sched_migrate_task(p, new_cpu);
=20
 	if (task_cpu(p) !=3D new_cpu) {
-		p->cfs.nr_migrations++;
+		p->se.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 	}
=20
@@ -2133,7 +2150,7 @@ static bool migrate_task(struct task_struct *p, struc=
t rq *rq)
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->cfs.on_rq || task_running(rq, p);
+	return p->se.on_rq || task_running(rq, p);
 }
=20
 /*
@@ -2193,7 +2210,7 @@ unsigned long wait_task_inactive(struct task_struct *=
p, long match_state)
 		rq =3D task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running =3D task_running(rq, p);
-		on_rq =3D p->cfs.on_rq;
+		on_rq =3D p->se.on_rq;
 		ncsw =3D 0;
 		if (!match_state || p->state =3D=3D match_state)
 			ncsw =3D p->nvcsw | LONG_MIN; /* sets MSB */
@@ -2358,15 +2375,15 @@ static inline void ttwu_activate(struct task_struct=
 *p, struct rq *rq,
 				 bool is_sync, bool is_migrate, bool is_local,
 				 unsigned long en_flags)
 {
-	schedstat_inc(p, cfs.statistics.nr_wakeups);
+	schedstat_inc(p, se.statistics.nr_wakeups);
 	if (is_sync)
-		schedstat_inc(p, cfs.statistics.nr_wakeups_sync);
+		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 	if (is_migrate)
-		schedstat_inc(p, cfs.statistics.nr_wakeups_migrate);
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
 	if (is_local)
-		schedstat_inc(p, cfs.statistics.nr_wakeups_local);
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
 	else
-		schedstat_inc(p, cfs.statistics.nr_wakeups_remote);
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
=20
 	activate_task(rq, p, en_flags);
 }
@@ -2428,7 +2445,7 @@ static int try_to_wake_up(struct task_struct *p, unsi=
gned int state,
 	if (!(p->state & state))
 		goto out;
=20
-	if (p->cfs.on_rq)
+	if (p->se.on_rq)
 		goto out_running;
=20
 	cpu =3D task_cpu(p);
@@ -2523,7 +2540,7 @@ static void try_to_wake_up_local(struct task_struct *=
p)
 	if (!(p->state & TASK_NORMAL))
 		return;
=20
-	if (!p->cfs.on_rq) {
+	if (!p->se.on_rq) {
 		if (likely(!task_running(rq, p))) {
 			schedstat_inc(rq, ttwu_count);
 			schedstat_inc(rq, ttwu_local);
@@ -2564,18 +2581,18 @@ int wake_up_state(struct task_struct *p, unsigned i=
nt state)
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->cfs.exec_start		=3D 0;
-	p->cfs.sum_exec_runtime		=3D 0;
-	p->cfs.prev_sum_exec_runtime	=3D 0;
-	p->cfs.nr_migrations		=3D 0;
+	p->se.exec_start		=3D 0;
+	p->se.sum_exec_runtime		=3D 0;
+	p->se.prev_sum_exec_runtime	=3D 0;
+	p->se.nr_migrations		=3D 0;
=20
 #ifdef CONFIG_SCHEDSTATS
-	memset(&p->cfs.statistics, 0, sizeof(p->cfs.statistics));
+	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
=20
-	INIT_LIST_HEAD(&p->rt.run_list);
-	p->cfs.on_rq =3D 0;
-	INIT_LIST_HEAD(&p->cfs.group_node);
+	INIT_LIST_HEAD(&p->se.rt.run_list);
+	p->se.on_rq =3D 0;
+	INIT_LIST_HEAD(&p->se.cfs.group_node);
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -3447,7 +3464,7 @@ static u64 do_task_delta_exec(struct task_struct *p, =
struct rq *rq)
=20
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns =3D rq->clock_task - p->cfs.exec_start;
+		ns =3D rq->clock_task - p->se.exec_start;
 		if ((s64)ns < 0)
 			ns =3D 0;
 	}
@@ -3480,7 +3497,7 @@ unsigned long long task_sched_runtime(struct task_str=
uct *p)
 	u64 ns =3D 0;
=20
 	rq =3D task_rq_lock(p, &flags);
-	ns =3D p->cfs.sum_exec_runtime + do_task_delta_exec(p, rq);
+	ns =3D p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
=20
 	return ns;
@@ -3709,7 +3726,7 @@ void task_times(struct task_struct *p, cputime_t *ut,=
 cputime_t *st)
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	rtime =3D nsecs_to_cputime(p->cfs.sum_exec_runtime);
+	rtime =3D nsecs_to_cputime(p->se.sum_exec_runtime);
=20
 	if (total) {
 		u64 temp =3D rtime;
@@ -3897,7 +3914,7 @@ static inline void schedule_debug(struct task_struct =
*prev)
=20
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->cfs.on_rq)
+	if (prev->se.on_rq)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
@@ -4556,7 +4573,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio=
)
 	trace_sched_pi_setprio(p, prio);
 	oldprio =3D p->prio;
 	prev_class =3D p->sched_class;
-	on_rq =3D p->cfs.on_rq;
+	on_rq =3D p->se.on_rq;
 	running =3D task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
@@ -4605,7 +4622,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		p->static_prio =3D NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq =3D p->cfs.on_rq;
+	on_rq =3D p->se.on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
=20
@@ -4739,7 +4756,7 @@ static struct task_struct *find_process_by_pid(pid_t =
pid)
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->cfs.on_rq);
+	BUG_ON(p->se.on_rq);
=20
 	p->policy =3D policy;
 	p->rt_priority =3D prio;
@@ -4888,7 +4905,7 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	on_rq =3D p->cfs.on_rq;
+	on_rq =3D p->se.on_rq;
 	running =3D task_current(rq, p);
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -5539,7 +5556,7 @@ void __cpuinit init_idle(struct task_struct *idle, in=
t cpu)
=20
 	__sched_fork(idle);
 	idle->state =3D TASK_RUNNING;
-	idle->cfs.exec_start =3D sched_clock();
+	idle->se.exec_start =3D sched_clock();
=20
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	/*
@@ -5690,7 +5707,7 @@ again:
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
 		cpumask_copy(&p->cpus_allowed, new_mask);
-		p->rt.nr_cpus_allowed =3D cpumask_weight(new_mask);
+		p->se.rt.nr_cpus_allowed =3D cpumask_weight(new_mask);
 	}
=20
 	/* Can the task run on the task's current CPU? If so, we're done */
@@ -5747,7 +5764,7 @@ static int __migrate_task(struct task_struct *p, int =
src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->cfs.on_rq) {
+	if (p->se.on_rq) {
 		deactivate_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
@@ -7847,7 +7864,6 @@ static void init_tg_cfs_entry(struct task_group *tg, =
struct cfs_rq *cfs_rq,
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg =3D tg;
=20
-	tg->cfs_se[cpu] =3D cfs_se;
 	/* cfs_se could be NULL for init_task_group */
 	if (!cfs_se)
 		return;
@@ -7875,7 +7891,6 @@ static void init_tg_rt_entry(struct task_group *tg, s=
truct rt_rq *rt_rq,
 	rt_rq->tg =3D tg;
 	rt_rq->rt_runtime =3D tg->rt_bandwidth.rt_runtime;
=20
-	tg->rt_se[cpu] =3D rt_se;
 	if (!rt_se)
 		return;
=20
@@ -7895,11 +7910,14 @@ void __init sched_init(void)
 	int i, j;
 	unsigned long alloc_size =3D 0, ptr;
=20
+#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
+	alloc_size +=3D nr_cpu_ids * sizeof(void **);
+#endif
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	alloc_size +=3D 2 * nr_cpu_ids * sizeof(void **);
+	alloc_size +=3D nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
-	alloc_size +=3D 2 * nr_cpu_ids * sizeof(void **);
+	alloc_size +=3D nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size +=3D num_possible_cpus() * cpumask_size();
@@ -7907,21 +7925,17 @@ void __init sched_init(void)
 	if (alloc_size) {
 		ptr =3D (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
=20
-#ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.cfs_se =3D (struct sched_cfs_entity **)ptr;
+#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
+		init_task_group.se =3D (struct sched_entity **)ptr;
 		ptr +=3D nr_cpu_ids * sizeof(void **);
-
+#endif /* CONFIG_FAIR_GROUP_SCHED || CONFIG_RT_GROUP_SCHED */
+#ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.cfs_rq =3D (struct cfs_rq **)ptr;
 		ptr +=3D nr_cpu_ids * sizeof(void **);
-
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
-		init_task_group.rt_se =3D (struct sched_rt_entity **)ptr;
-		ptr +=3D nr_cpu_ids * sizeof(void **);
-
 		init_task_group.rt_rq =3D (struct rt_rq **)ptr;
 		ptr +=3D nr_cpu_ids * sizeof(void **);
-
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
@@ -8116,7 +8130,7 @@ static void normalize_task(struct rq *rq, struct task=
_struct *p)
 {
 	int on_rq;
=20
-	on_rq =3D p->cfs.on_rq;
+	on_rq =3D p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -8140,11 +8154,11 @@ void normalize_rt_tasks(void)
 		if (!p->mm)
 			continue;
=20
-		p->cfs.exec_start		=3D 0;
+		p->se.exec_start		=3D 0;
 #ifdef CONFIG_SCHEDSTATS
-		p->cfs.statistics.wait_start	=3D 0;
-		p->cfs.statistics.sleep_start	=3D 0;
-		p->cfs.statistics.block_start	=3D 0;
+		p->se.statistics.wait_start	=3D 0;
+		p->se.statistics.sleep_start	=3D 0;
+		p->se.statistics.block_start	=3D 0;
 #endif
=20
 		if (!rt_task(p)) {
@@ -8218,6 +8232,52 @@ void set_curr_task(int cpu, struct task_struct *p)
=20
 #endif
=20
+#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
+static void free_sched_entity(struct task_group *tg)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (tg->se)
+			kfree(tg->se[i]);
+	}
+
+	kfree(tg->se);
+}
+
+static int alloc_sched_entity(struct task_group *tg)
+{
+	struct sched_entity *se;
+	int i;
+
+	tg->se =3D kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->se)
+		return 0;
+
+	for_each_possible_cpu(i) {
+		se =3D kzalloc_node(sizeof(struct sched_entity),
+				  GFP_KERNEL, cpu_to_node(i));
+
+		/* FIXME: leaking? */
+		if (!se)
+			return 0;
+
+		tg->se[i] =3D se;
+	}
+
+	return 1;
+}
+#else /* !CONFIG_FAIR_GROUP_SCHED && !CONFIG_RT_GROUP_SCHED */
+static void free_sched_entity(struct task_group *tg)
+{
+}
+
+static int alloc_sched_entity(struct task_group *tg)
+{
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void free_fair_sched_group(struct task_group *tg)
 {
@@ -8226,28 +8286,26 @@ static void free_fair_sched_group(struct task_group=
 *tg)
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
-		if (tg->cfs_se)
-			kfree(tg->cfs_se[i]);
 	}
=20
 	kfree(tg->cfs_rq);
-	kfree(tg->cfs_se);
 }
=20
 static
 int alloc_fair_sched_group(struct task_group *tg, struct task_group *paren=
t)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_cfs_entity *cfs_se;
 	struct rq *rq;
 	int i;
=20
+	/*
+	 * A sched_entity for this group has already been
+	 * created outside from this function.
+	 */
+
 	tg->cfs_rq =3D kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->cfs_rq)
-		goto err;
-	tg->cfs_se =3D kzalloc(sizeof(cfs_se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->cfs_se)
-		goto err;
+		return 0;
=20
 	tg->shares =3D NICE_0_LOAD;
=20
@@ -8257,22 +8315,13 @@ int alloc_fair_sched_group(struct task_group *tg, s=
truct task_group *parent)
 		cfs_rq =3D kzalloc_node(sizeof(struct cfs_rq),
 				      GFP_KERNEL, cpu_to_node(i));
 		if (!cfs_rq)
-			goto err;
-
-		cfs_se =3D kzalloc_node(sizeof(struct sched_cfs_entity),
-				      GFP_KERNEL, cpu_to_node(i));
-		if (!cfs_se)
-			goto err_free_rq;
+			return 0;
=20
-		init_tg_cfs_entry(tg, cfs_rq, cfs_se, i, parent->cfs_se[i]);
+		init_tg_cfs_entry(tg, cfs_rq, &tg->se[i]->cfs, i,
+				  cfs_se_cpu(parent->se, i));
 	}
=20
 	return 1;
-
-err_free_rq:
-	kfree(cfs_rq);
-err:
-	return 0;
 }
=20
 static inline void unregister_fair_sched_group(struct task_group *tg, int =
cpu)
@@ -8317,28 +8366,26 @@ static void free_rt_sched_group(struct task_group *=
tg)
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
 			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
 	}
=20
 	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
 }
=20
 static
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
 	struct rq *rq;
 	int i;
=20
+	/*
+	 * A sched_entity for this group has already been
+	 * created outside from this function.
+	 */
+
 	tg->rt_rq =3D kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_rq)
-		goto err;
-	tg->rt_se =3D kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_se)
-		goto err;
+		return 0;
=20
 	init_rt_bandwidth(&tg->rt_bandwidth,
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
@@ -8349,22 +8396,13 @@ int alloc_rt_sched_group(struct task_group *tg, str=
uct task_group *parent)
 		rt_rq =3D kzalloc_node(sizeof(struct rt_rq),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
-			goto err;
-
-		rt_se =3D kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_se)
-			goto err_free_rq;
+			return 0;
=20
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, &tg->se[i]->rt, i,
+				 rt_se_cpu(parent->se, i));
 	}
=20
 	return 1;
-
-err_free_rq:
-	kfree(rt_rq);
-err:
-	return 0;
 }
 #else /* !CONFIG_RT_GROUP_SCHED */
 static inline void free_rt_sched_group(struct task_group *tg)
@@ -8383,6 +8421,7 @@ static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	free_sched_entity(tg);
 	kfree(tg);
 }
=20
@@ -8396,6 +8435,9 @@ struct task_group *sched_create_group(struct task_gro=
up *parent)
 	if (!tg)
 		return ERR_PTR(-ENOMEM);
=20
+	if (!alloc_sched_entity(tg))
+		goto err;
+
 	if (!alloc_fair_sched_group(tg, parent))
 		goto err;
=20
@@ -8447,7 +8489,7 @@ void sched_destroy_group(struct task_group *tg)
=20
 /* change task's runqueue when it moves between groups.
  *	The caller of this function should have put the task in its new group
- *	by now. This function just updates tsk->cfs.cfs_rq and tsk->cfs.parent =
to
+ *	by now. This function just updates tsk->se.cfs.cfs_rq and tsk->cfs.pare=
nt to
  *	reflect its new group.
  */
 void sched_move_task(struct task_struct *tsk)
@@ -8459,7 +8501,7 @@ void sched_move_task(struct task_struct *tsk)
 	rq =3D task_rq_lock(tsk, &flags);
=20
 	running =3D task_current(rq, tsk);
-	on_rq =3D tsk->cfs.on_rq;
+	on_rq =3D tsk->se.on_rq;
=20
 	if (on_rq)
 		dequeue_task(rq, tsk, 0);
@@ -8493,7 +8535,7 @@ int sched_group_set_shares(struct task_group *tg, uns=
igned long shares)
 	/*
 	 * We can't change the weight of the root cgroup.
 	 */
-	if (!tg->cfs_se[0])
+	if (!tg->se[0])
 		return -EINVAL;
=20
 	if (shares < MIN_SHARES)
@@ -8510,10 +8552,10 @@ int sched_group_set_shares(struct task_group *tg, u=
nsigned long shares)
 		struct rq *rq =3D cpu_rq(i);
 		struct sched_cfs_entity *cfs_se;
=20
-		cfs_se =3D tg->cfs_se[i];
+		cfs_se =3D &tg->se[i]->cfs;
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
-		for_each_sched_entity(cfs_se)
+		for_each_sched_cfs_entity(cfs_se)
 			update_cfs_shares(group_cfs_rq(cfs_se), 0);
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
@@ -8549,7 +8591,7 @@ static inline int tg_has_rt_tasks(struct task_group *=
tg)
 	struct task_struct *g, *p;
=20
 	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg =3D=3D tg)
+		if (rt_task(p) && rt_rq_of_se(&p->se.rt)->tg =3D=3D tg)
 			return 1;
 	} while_each_thread(g, p);
=20
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 16d0b10..296cbba 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -56,7 +56,8 @@ static unsigned long nsec_low(unsigned long long nsec)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task=
_group *tg)
 {
-	struct sched_cfs_entity *cfs_se =3D tg->cfs_se[cpu];
+	struct sched_cfs_entity *cfs_se =3D &tg->se[cpu]->cfs;
+	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
=20
 	if (!cfs_se)
 		return;
@@ -66,20 +67,20 @@ static void print_cfs_group_stats(struct seq_file *m, i=
nt cpu, struct task_group
 #define PN(F) \
 	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
=20
-	PN(cfs_se->exec_start);
+	PN(se->exec_start);
 	PN(cfs_se->vruntime);
-	PN(cfs_se->sum_exec_runtime);
+	PN(se->sum_exec_runtime);
 #ifdef CONFIG_SCHEDSTATS
-	PN(cfs_se->statistics.wait_start);
-	PN(cfs_se->statistics.sleep_start);
-	PN(cfs_se->statistics.block_start);
-	PN(cfs_se->statistics.sleep_max);
-	PN(cfs_se->statistics.block_max);
-	PN(cfs_se->statistics.exec_max);
-	PN(cfs_se->statistics.slice_max);
-	PN(cfs_se->statistics.wait_max);
-	PN(cfs_se->statistics.wait_sum);
-	P(cfs_se->statistics.wait_count);
+	PN(se->statistics.wait_start);
+	PN(se->statistics.sleep_start);
+	PN(se->statistics.block_start);
+	PN(se->statistics.sleep_max);
+	PN(se->statistics.block_max);
+	PN(se->statistics.exec_max);
+	PN(se->statistics.slice_max);
+	PN(se->statistics.wait_max);
+	PN(se->statistics.wait_sum);
+	P(se->statistics.wait_count);
 #endif
 	P(cfs_se->load.weight);
 #undef PN
@@ -97,14 +98,14 @@ print_task(struct seq_file *m, struct rq *rq, struct ta=
sk_struct *p)
=20
 	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
 		p->comm, p->pid,
-		SPLIT_NS(p->cfs.vruntime),
+		SPLIT_NS(p->se.cfs.vruntime),
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
 #ifdef CONFIG_SCHEDSTATS
 	SEQ_printf(m, "%9Ld.%06ld %9Ld.%06ld %9Ld.%06ld",
-		SPLIT_NS(p->cfs.vruntime),
-		SPLIT_NS(p->cfs.sum_exec_runtime),
-		SPLIT_NS(p->cfs.statistics.sum_sleep_runtime));
+		SPLIT_NS(p->se.cfs.vruntime),
+		SPLIT_NS(p->se.sum_exec_runtime),
+		SPLIT_NS(p->se.statistics.sum_sleep_runtime));
 #else
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
@@ -128,7 +129,7 @@ static void print_rq(struct seq_file *m, struct rq *rq,=
 int rq_cpu)
 	read_lock_irqsave(&tasklist_lock, flags);
=20
 	do_each_thread(g, p) {
-		if (!p->cfs.on_rq || task_cpu(p) !=3D rq_cpu)
+		if (!p->se.on_rq || task_cpu(p) !=3D rq_cpu)
 			continue;
=20
 		print_task(m, rq, p);
@@ -383,55 +384,55 @@ void proc_sched_show_task(struct task_struct *p, stru=
ct seq_file *m)
 #define PN(F) \
 	SEQ_printf(m, "%-35s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
=20
-	PN(cfs.exec_start);
-	PN(cfs.vruntime);
-	PN(cfs.sum_exec_runtime);
+	PN(se.exec_start);
+	PN(se.cfs.vruntime);
+	PN(se.sum_exec_runtime);
=20
 	nr_switches =3D p->nvcsw + p->nivcsw;
=20
 #ifdef CONFIG_SCHEDSTATS
-	PN(cfs.statistics.wait_start);
-	PN(cfs.statistics.sleep_start);
-	PN(cfs.statistics.block_start);
-	PN(cfs.statistics.sleep_max);
-	PN(cfs.statistics.block_max);
-	PN(cfs.statistics.exec_max);
-	PN(cfs.statistics.slice_max);
-	PN(cfs.statistics.wait_max);
-	PN(cfs.statistics.wait_sum);
-	P(cfs.statistics.wait_count);
-	PN(cfs.statistics.iowait_sum);
-	P(cfs.statistics.iowait_count);
+	PN(se.statistics.wait_start);
+	PN(se.statistics.sleep_start);
+	PN(se.statistics.block_start);
+	PN(se.statistics.sleep_max);
+	PN(se.statistics.block_max);
+	PN(se.statistics.exec_max);
+	PN(se.statistics.slice_max);
+	PN(se.statistics.wait_max);
+	PN(se.statistics.wait_sum);
+	P(se.statistics.wait_count);
+	PN(se.statistics.iowait_sum);
+	P(se.statistics.iowait_count);
 	P(sched_info.bkl_count);
-	P(cfs.nr_migrations);
-	P(cfs.statistics.nr_migrations_cold);
-	P(cfs.statistics.nr_failed_migrations_affine);
-	P(cfs.statistics.nr_failed_migrations_running);
-	P(cfs.statistics.nr_failed_migrations_hot);
-	P(cfs.statistics.nr_forced_migrations);
-	P(cfs.statistics.nr_wakeups);
-	P(cfs.statistics.nr_wakeups_sync);
-	P(cfs.statistics.nr_wakeups_migrate);
-	P(cfs.statistics.nr_wakeups_local);
-	P(cfs.statistics.nr_wakeups_remote);
-	P(cfs.statistics.nr_wakeups_affine);
-	P(cfs.statistics.nr_wakeups_affine_attempts);
-	P(cfs.statistics.nr_wakeups_passive);
-	P(cfs.statistics.nr_wakeups_idle);
+	P(se.nr_migrations);
+	P(se.statistics.nr_migrations_cold);
+	P(se.statistics.nr_failed_migrations_affine);
+	P(se.statistics.nr_failed_migrations_running);
+	P(se.statistics.nr_failed_migrations_hot);
+	P(se.statistics.nr_forced_migrations);
+	P(se.statistics.nr_wakeups);
+	P(se.statistics.nr_wakeups_sync);
+	P(se.statistics.nr_wakeups_migrate);
+	P(se.statistics.nr_wakeups_local);
+	P(se.statistics.nr_wakeups_remote);
+	P(se.statistics.nr_wakeups_affine);
+	P(se.statistics.nr_wakeups_affine_attempts);
+	P(se.statistics.nr_wakeups_passive);
+	P(se.statistics.nr_wakeups_idle);
=20
 	{
 		u64 avg_atom, avg_per_cpu;
=20
-		avg_atom =3D p->cfs.sum_exec_runtime;
+		avg_atom =3D p->se.sum_exec_runtime;
 		if (nr_switches)
 			do_div(avg_atom, nr_switches);
 		else
 			avg_atom =3D -1LL;
=20
-		avg_per_cpu =3D p->cfs.sum_exec_runtime;
-		if (p->cfs.nr_migrations) {
+		avg_per_cpu =3D p->se.sum_exec_runtime;
+		if (p->se.nr_migrations) {
 			avg_per_cpu =3D div64_u64(avg_per_cpu,
-						p->cfs.nr_migrations);
+						p->se.nr_migrations);
 		} else {
 			avg_per_cpu =3D -1LL;
 		}
@@ -446,7 +447,7 @@ void proc_sched_show_task(struct task_struct *p, struct=
 seq_file *m)
 	SEQ_printf(m, "%-35s:%21Ld\n",
 		   "nr_involuntary_switches", (long long)p->nivcsw);
=20
-	P(cfs.load.weight);
+	P(se.cfs.load.weight);
 	P(policy);
 	P(prio);
 #undef PN
@@ -468,6 +469,6 @@ void proc_sched_show_task(struct task_struct *p, struct=
 seq_file *m)
 void proc_sched_set_task(struct task_struct *p)
 {
 #ifdef CONFIG_SCHEDSTATS
-	memset(&p->cfs.statistics, 0, sizeof(p->cfs.statistics));
+	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1ae7a17..e9b8260 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -102,6 +102,11 @@ static const struct sched_class fair_sched_class;
  * CFS operations on generic schedulable entities:
  */
=20
+static inline struct sched_entity *se_of_cfs_se(struct sched_cfs_entity *c=
fs_se)
+{
+	return container_of(cfs_se, struct sched_entity, cfs);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
=20
 /* cpu runqueue to which this cfs_rq is attached */
@@ -118,7 +123,7 @@ static inline struct task_struct *cfs_task_of(struct sc=
hed_cfs_entity *cfs_se)
 #ifdef CONFIG_SCHED_DEBUG
 	WARN_ON_ONCE(!cfs_entity_is_task(cfs_se));
 #endif
-	return container_of(cfs_se, struct task_struct, cfs);
+	return container_of(cfs_se, struct task_struct, se.cfs);
 }
=20
 /* Walk up scheduling entities hierarchy */
@@ -127,7 +132,7 @@ static inline struct task_struct *cfs_task_of(struct sc=
hed_cfs_entity *cfs_se)
=20
 static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
-	return p->cfs.cfs_rq;
+	return p->se.cfs.cfs_rq;
 }
=20
 /* runqueue on which this entity is (to be) queued */
@@ -249,7 +254,7 @@ find_matching_se(struct sched_cfs_entity **cfs_se,
=20
 static inline struct task_struct *cfs_task_of(struct sched_cfs_entity *cfs=
_se)
 {
-	return container_of(cfs_se, struct task_struct, cfs);
+	return container_of(cfs_se, struct task_struct, se.cfs);
 }
=20
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -516,7 +521,8 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs=
_se)
 {
-	u64 slice =3D __sched_period(cfs_rq->nr_running + !cfs_se->on_rq);
+	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
+	u64 slice =3D __sched_period(cfs_rq->nr_running + !se->on_rq);
=20
 	for_each_sched_cfs_entity(cfs_se) {
 		struct load_weight *load;
@@ -525,7 +531,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sc=
hed_cfs_entity *cfs_se)
 		cfs_rq =3D cfs_rq_of(cfs_se);
 		load =3D &cfs_rq->load;
=20
-		if (unlikely(!cfs_se->on_rq)) {
+		if (unlikely(!se_of_cfs_se(cfs_se)->on_rq)) {
 			lw =3D cfs_rq->load;
=20
 			update_load_add(&lw, cfs_se->load.weight);
@@ -558,12 +564,13 @@ static inline void
 __update_curr(struct cfs_rq *cfs_rq, struct sched_cfs_entity *curr,
 	      unsigned long delta_exec)
 {
+	struct sched_entity *curr_se =3D se_of_cfs_se(curr);
 	unsigned long delta_exec_weighted;
=20
-	schedstat_set(curr->statistics.exec_max,
-		      max((u64)delta_exec, curr->statistics.exec_max));
+	schedstat_set(curr_se->statistics.exec_max,
+		      max((u64)delta_exec, curr_se->statistics.exec_max));
=20
-	curr->sum_exec_runtime +=3D delta_exec;
+	curr_se->sum_exec_runtime +=3D delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted =3D calc_delta_fair(delta_exec, curr);
=20
@@ -578,6 +585,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_cfs_e=
ntity *curr,
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_cfs_entity *curr =3D cfs_rq->curr;
+	struct sched_entity *curr_se =3D se_of_cfs_se(curr);
 	u64 now =3D rq_of(cfs_rq)->clock_task;
 	unsigned long delta_exec;
=20
@@ -589,12 +597,12 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	 * since the last time we changed load (this cannot
 	 * overflow on 32 bits):
 	 */
-	delta_exec =3D (unsigned long)(now - curr->exec_start);
+	delta_exec =3D (unsigned long)(now - curr_se->exec_start);
 	if (!delta_exec)
 		return;
=20
 	__update_curr(cfs_rq, curr, delta_exec);
-	curr->exec_start =3D now;
+	curr_se->exec_start =3D now;
=20
 	if (cfs_entity_is_task(curr)) {
 		struct task_struct *curtask =3D cfs_task_of(curr);
@@ -608,7 +616,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cf=
s_se)
 {
-	schedstat_set(cfs_se->statistics.wait_start, rq_of(cfs_rq)->clock);
+	schedstat_set(se_of_cfs_se(cfs_se)->statistics.wait_start,
+		      rq_of(cfs_rq)->clock);
 }
=20
 /*
@@ -628,21 +637,21 @@ update_stats_enqueue(struct cfs_rq *cfs_rq, struct sc=
hed_cfs_entity *cfs_se)
 static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_=
se)
 {
-	schedstat_set(cfs_se->statistics.wait_max,
-		      max(cfs_se->statistics.wait_max,
-			  rq_of(cfs_rq)->clock-cfs_se->statistics.wait_start));
-	schedstat_set(cfs_se->statistics.wait_count,
-		      cfs_se->statistics.wait_count + 1);
-	schedstat_set(cfs_se->statistics.wait_sum,
-		      cfs_se->statistics.wait_sum + rq_of(cfs_rq)->clock -
-		      cfs_se->statistics.wait_start);
 #ifdef CONFIG_SCHEDSTATS
+	/* #ifdef-ing like this suppresses a gcc warning */
+	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
+
+	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
+		      rq_of(cfs_rq)->clock - se->statistics.wait_start));
+	schedstat_set(se->statistics.wait_count, se->statistics.wait_count+1);
+	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
+		      rq_of(cfs_rq)->clock - se->statistics.wait_start);
 	if (cfs_entity_is_task(cfs_se)) {
-		trace_sched_stat_wait(cfs_task_of(cfs_se),
-			rq_of(cfs_rq)->clock - cfs_se->statistics.wait_start);
+		trace_sched_stat_wait(cfs_task_of(cfs_se), rq_of(cfs_rq)->clock -
+				      se->statistics.wait_start);
 	}
+	schedstat_set(se->statistics.wait_start, 0);
 #endif
-	schedstat_set(cfs_se->statistics.wait_start, 0);
 }
=20
 static inline void
@@ -665,7 +674,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct s=
ched_cfs_entity *cfs_se)
 	/*
 	 * We are starting a new run period:
 	 */
-	cfs_se->exec_start =3D rq_of(cfs_rq)->clock_task;
+	se_of_cfs_se(cfs_se)->exec_start =3D rq_of(cfs_rq)->clock_task;
 }
=20
 /**************************************************
@@ -778,7 +787,9 @@ static void reweight_entity(struct cfs_rq *cfs_rq,
 			    struct sched_cfs_entity *cfs_se,
 			    unsigned long weight)
 {
-	if (cfs_se->on_rq) {
+	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
+
+	if (se->on_rq) {
 		/* commit outstanding execution time */
 		if (cfs_rq->curr =3D=3D cfs_se)
 			update_curr(cfs_rq);
@@ -787,7 +798,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq,
=20
 	update_load_set(&cfs_se->load, weight);
=20
-	if (cfs_se->on_rq)
+	if (se->on_rq)
 		account_entity_enqueue(cfs_rq, cfs_se);
 }
=20
@@ -801,7 +812,7 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, lo=
ng weight_delta)
 		return;
=20
 	tg =3D cfs_rq->tg;
-	cfs_se =3D tg->cfs_se[cpu_of(rq_of(cfs_rq))];
+	cfs_se =3D &tg->se[cpu_of(rq_of(cfs_rq))]->cfs;
 	if (!cfs_se)
 		return;
=20
@@ -849,43 +860,44 @@ enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_c=
fs_entity *cfs_se)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct task_struct *tsk =3D NULL;
+	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
=20
 	if (cfs_entity_is_task(cfs_se))
 		tsk =3D cfs_task_of(cfs_se);
=20
-	if (cfs_se->statistics.sleep_start) {
-		u64 delta =3D rq_of(cfs_rq)->clock - cfs_se->statistics.sleep_start;
+	if (se->statistics.sleep_start) {
+		u64 delta =3D rq_of(cfs_rq)->clock - se->statistics.sleep_start;
=20
 		if ((s64)delta < 0)
 			delta =3D 0;
=20
-		if (unlikely(delta > cfs_se->statistics.sleep_max))
-			cfs_se->statistics.sleep_max =3D delta;
+		if (unlikely(delta > se->statistics.sleep_max))
+			se->statistics.sleep_max =3D delta;
=20
-		cfs_se->statistics.sleep_start =3D 0;
-		cfs_se->statistics.sum_sleep_runtime +=3D delta;
+		se->statistics.sleep_start =3D 0;
+		se->statistics.sum_sleep_runtime +=3D delta;
=20
 		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
 			trace_sched_stat_sleep(tsk, delta);
 		}
 	}
-	if (cfs_se->statistics.block_start) {
-		u64 delta =3D rq_of(cfs_rq)->clock - cfs_se->statistics.block_start;
+	if (se->statistics.block_start) {
+		u64 delta =3D rq_of(cfs_rq)->clock - se->statistics.block_start;
=20
 		if ((s64)delta < 0)
 			delta =3D 0;
=20
-		if (unlikely(delta > cfs_se->statistics.block_max))
-			cfs_se->statistics.block_max =3D delta;
+		if (unlikely(delta > se->statistics.block_max))
+			se->statistics.block_max =3D delta;
=20
-		cfs_se->statistics.block_start =3D 0;
-		cfs_se->statistics.sum_sleep_runtime +=3D delta;
+		se->statistics.block_start =3D 0;
+		se->statistics.sum_sleep_runtime +=3D delta;
=20
 		if (tsk) {
 			if (tsk->in_iowait) {
-				cfs_se->statistics.iowait_sum +=3D delta;
-				cfs_se->statistics.iowait_count++;
+				se->statistics.iowait_sum +=3D delta;
+				se->statistics.iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
 			}
=20
@@ -982,7 +994,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_cfs_=
entity *cfs_se,
 	check_spread(cfs_rq, cfs_se);
 	if (cfs_se !=3D cfs_rq->curr)
 		__enqueue_entity(cfs_rq, cfs_se);
-	cfs_se->on_rq =3D 1;
+	se_of_cfs_se(cfs_se)->on_rq =3D 1;
=20
 	if (cfs_rq->nr_running =3D=3D 1)
 		list_add_leaf_cfs_rq(cfs_rq);
@@ -1019,11 +1031,12 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_=
cfs_entity *cfs_se,
 #ifdef CONFIG_SCHEDSTATS
 		if (cfs_entity_is_task(cfs_se)) {
 			struct task_struct *tsk =3D cfs_task_of(cfs_se);
+			struct sched_entity *se =3D se_of_cfs_se(cfs_se);
=20
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				cfs_se->statistics.sleep_start =3D rq_of(cfs_rq)->clock;
+				se->statistics.sleep_start =3D rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				cfs_se->statistics.block_start =3D rq_of(cfs_rq)->clock;
+				se->statistics.block_start =3D rq_of(cfs_rq)->clock;
 		}
 #endif
 	}
@@ -1032,7 +1045,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_cf=
s_entity *cfs_se,
=20
 	if (cfs_se !=3D cfs_rq->curr)
 		__dequeue_entity(cfs_rq, cfs_se);
-	cfs_se->on_rq =3D 0;
+	se_of_cfs_se(cfs_se)->on_rq =3D 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, cfs_se);
 	update_min_vruntime(cfs_rq);
@@ -1054,9 +1067,10 @@ static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_cfs_entity *curr)
 {
 	unsigned long ideal_runtime, delta_exec;
+	struct sched_entity *curr_se =3D se_of_cfs_se(curr);
=20
 	ideal_runtime =3D sched_slice(cfs_rq, curr);
-	delta_exec =3D curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
+	delta_exec =3D curr_se->sum_exec_runtime - curr_se->prev_sum_exec_runtime=
;
 	if (delta_exec > ideal_runtime) {
 		resched_task(rq_of(cfs_rq)->curr);
 		/*
@@ -1090,8 +1104,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sch=
ed_cfs_entity *curr)
 static void
 set_next_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
+	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
+
 	/* 'current' is not kept within the tree. */
-	if (cfs_se->on_rq) {
+	if (se->on_rq) {
 		/*
 		 * Any task has to be enqueued before it get to execute on
 		 * a CPU. So account for the time it spent waiting on the
@@ -1110,11 +1126,11 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched=
_cfs_entity *cfs_se)
 	 * when there are only lesser-weight tasks around):
 	 */
 	if (rq_of(cfs_rq)->load.weight >=3D 2*cfs_se->load.weight) {
-		cfs_se->statistics.slice_max =3D max(cfs_se->statistics.slice_max,
-			cfs_se->sum_exec_runtime - cfs_se->prev_sum_exec_runtime);
+		se->statistics.slice_max =3D max(se->statistics.slice_max,
+			se->sum_exec_runtime - se->prev_sum_exec_runtime);
 	}
 #endif
-	cfs_se->prev_sum_exec_runtime =3D cfs_se->sum_exec_runtime;
+	se->prev_sum_exec_runtime =3D se->sum_exec_runtime;
 }
=20
 static int wakeup_preempt_entity(struct sched_cfs_entity *curr,
@@ -1142,15 +1158,17 @@ static struct sched_cfs_entity *pick_next_entity(st=
ruct cfs_rq *cfs_rq)
 static void
 put_prev_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *prev)
 {
+	struct sched_entity *prev_se =3D se_of_cfs_se(prev);
+
 	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
 	 */
-	if (prev->on_rq)
+	if (prev_se->on_rq)
 		update_curr(cfs_rq);
=20
 	check_spread(cfs_rq, prev);
-	if (prev->on_rq) {
+	if (prev_se->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
@@ -1199,15 +1217,15 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_cfs=
_entity *curr, int queued)
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
-	struct sched_cfs_entity *cfs_se =3D &p->cfs;
+	struct sched_cfs_entity *cfs_se =3D &p->se.cfs;
 	struct cfs_rq *cfs_rq =3D cfs_rq_of(cfs_se);
=20
 	WARN_ON(task_rq(p) !=3D rq);
=20
 	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
 		u64 slice =3D sched_slice(cfs_rq, cfs_se);
-		u64 ran =3D cfs_se->sum_exec_runtime -
-				cfs_se->prev_sum_exec_runtime;
+		u64 ran =3D p->se.sum_exec_runtime -
+				p->se.prev_sum_exec_runtime;
 		s64 delta =3D slice - ran;
=20
 		if (delta < 0) {
@@ -1239,7 +1257,7 @@ static void hrtick_update(struct rq *rq)
 	if (curr->sched_class !=3D &fair_sched_class)
 		return;
=20
-	if (cfs_rq_of(&curr->cfs)->nr_running < sched_nr_latency)
+	if (cfs_rq_of(&curr->se.cfs)->nr_running < sched_nr_latency)
 		hrtick_start_fair(rq, curr);
 }
 #else /* !CONFIG_SCHED_HRTICK */
@@ -1262,10 +1280,10 @@ static void
 enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_cfs_entity *cfs_se =3D &p->cfs;
+	struct sched_cfs_entity *cfs_se =3D &p->se.cfs;
=20
 	for_each_sched_cfs_entity(cfs_se) {
-		if (cfs_se->on_rq)
+		if (se_of_cfs_se(cfs_se)->on_rq)
 			break;
 		cfs_rq =3D cfs_rq_of(cfs_se);
 		enqueue_entity(cfs_rq, cfs_se, flags);
@@ -1290,7 +1308,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *=
p, int flags)
 static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int fl=
ags)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_cfs_entity *cfs_se =3D &p->cfs;
+	struct sched_cfs_entity *cfs_se =3D &p->se.cfs;
=20
 	for_each_sched_cfs_entity(cfs_se) {
 		cfs_rq =3D cfs_rq_of(cfs_se);
@@ -1321,7 +1339,7 @@ static void yield_task_fair(struct rq *rq)
 {
 	struct task_struct *curr =3D rq->curr;
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(curr);
-	struct sched_cfs_entity *rightmost, *cfs_se =3D &curr->cfs;
+	struct sched_cfs_entity *rightmost, *cfs_se =3D &curr->se.cfs;
=20
 	/*
 	 * Are we the only task in the tree?
@@ -1362,7 +1380,7 @@ static void yield_task_fair(struct rq *rq)
=20
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
 {
-	struct sched_cfs_entity *cfs_se =3D &p->cfs;
+	struct sched_cfs_entity *cfs_se =3D &p->se.cfs;
 	struct cfs_rq *cfs_rq =3D cfs_rq_of(cfs_se);
=20
 	cfs_se->vruntime -=3D cfs_rq->min_vruntime;
@@ -1378,7 +1396,7 @@ static void task_waking_fair(struct rq *rq, struct ta=
sk_struct *p)
  */
 static long effective_load(struct task_group *tg, int cpu, long wl, long w=
g)
 {
-	struct sched_cfs_entity *cfs_se =3D tg->cfs_se[cpu];
+	struct sched_cfs_entity *cfs_se =3D &tg->se[cpu]->cfs;
=20
 	if (!tg->parent)
 		return wl;
@@ -1444,14 +1462,14 @@ static int wake_affine(struct sched_domain *sd, str=
uct task_struct *p, int sync)
 	rcu_read_lock();
 	if (sync) {
 		tg =3D task_group(current);
-		weight =3D current->cfs.load.weight;
+		weight =3D current->se.cfs.load.weight;
=20
 		this_load +=3D effective_load(tg, this_cpu, -weight, -weight);
 		load +=3D effective_load(tg, prev_cpu, 0, -weight);
 	}
=20
 	tg =3D task_group(p);
-	weight =3D p->cfs.load.weight;
+	weight =3D p->se.cfs.load.weight;
=20
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
@@ -1487,7 +1505,7 @@ static int wake_affine(struct sched_domain *sd, struc=
t task_struct *p, int sync)
 	if (sync && balanced)
 		return 1;
=20
-	schedstat_inc(p, cfs.statistics.nr_wakeups_affine_attempts);
+	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
 	tl_per_task =3D cpu_avg_load_per_task(this_cpu);
=20
 	if (balanced ||
@@ -1499,7 +1517,7 @@ static int wake_affine(struct sched_domain *sd, struc=
t task_struct *p, int sync)
 		 * there is no bad imbalance.
 		 */
 		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, cfs.statistics.nr_wakeups_affine);
+		schedstat_inc(p, se.statistics.nr_wakeups_affine);
=20
 		return 1;
 	}
@@ -1834,7 +1852,7 @@ static void set_next_buddy(struct sched_cfs_entity *c=
fs_se)
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int=
 wake_flags)
 {
 	struct task_struct *curr =3D rq->curr;
-	struct sched_cfs_entity *cfs_se =3D &curr->cfs, *cfs_pse =3D &p->cfs;
+	struct sched_cfs_entity *cfs_se =3D &curr->se.cfs, *cfs_pse =3D &p->se.cf=
s;
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(curr);
 	int scale =3D cfs_rq->nr_running >=3D sched_nr_latency;
=20
@@ -1884,7 +1902,7 @@ preempt:
 	 * Also, during early boot the idle thread is in the fair class,
 	 * for obvious reasons its a bad idea to schedule back to it.
 	 */
-	if (unlikely(!cfs_se->on_rq || curr =3D=3D rq->idle))
+	if (unlikely(!se_of_cfs_se(cfs_se)->on_rq || curr =3D=3D rq->idle))
 		return;
=20
 	if (sched_feat(LAST_BUDDY) && scale && cfs_entity_is_task(cfs_se))
@@ -1917,7 +1935,7 @@ static struct task_struct *pick_next_task_fair(struct=
 rq *rq)
  */
 static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
 {
-	struct sched_cfs_entity *cfs_se =3D &prev->cfs;
+	struct sched_cfs_entity *cfs_se =3D &prev->se.cfs;
 	struct cfs_rq *cfs_rq;
=20
 	for_each_sched_cfs_entity(cfs_se) {
@@ -1960,13 +1978,13 @@ int can_migrate_task(struct task_struct *p, struct =
rq *rq, int this_cpu,
 	 * 3) are cache-hot on their current CPU.
 	 */
 	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
-		schedstat_inc(p, cfs.statistics.nr_failed_migrations_affine);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
 	*all_pinned =3D 0;
=20
 	if (task_running(rq, p)) {
-		schedstat_inc(p, cfs.statistics.nr_failed_migrations_running);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
 	}
=20
@@ -1982,14 +2000,14 @@ int can_migrate_task(struct task_struct *p, struct =
rq *rq, int this_cpu,
 #ifdef CONFIG_SCHEDSTATS
 		if (tsk_cache_hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
-			schedstat_inc(p, cfs.statistics.nr_forced_migrations);
+			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
 #endif
 		return 1;
 	}
=20
 	if (tsk_cache_hot) {
-		schedstat_inc(p, cfs.statistics.nr_failed_migrations_hot);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
 		return 0;
 	}
 	return 1;
@@ -2011,7 +2029,7 @@ move_one_task(struct rq *this_rq, int this_cpu, struc=
t rq *busiest,
 	int pinned =3D 0;
=20
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
-		list_for_each_entry_safe(p, n, &cfs_rq->tasks, cfs.group_node) {
+		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.cfs.group_node) {
=20
 			if (!can_migrate_task(p, busiest, this_cpu,
 						sd, idle, &pinned))
@@ -2046,17 +2064,17 @@ balance_tasks(struct rq *this_rq, int this_cpu, str=
uct rq *busiest,
=20
 	pinned =3D 1;
=20
-	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, cfs.group_node) {
+	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.cfs.group_node)=
 {
 		if (loops++ > sysctl_sched_nr_migrate)
 			break;
=20
-		if ((p->cfs.load.weight >> 1) > rem_load_move ||
+		if ((p->se.cfs.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned))
 			continue;
=20
 		pull_task(busiest, p, this_rq, this_cpu);
 		pulled++;
-		rem_load_move -=3D p->cfs.load.weight;
+		rem_load_move -=3D p->se.cfs.load.weight;
=20
 #ifdef CONFIG_PREEMPT
 		/*
@@ -2102,7 +2120,7 @@ static int update_shares_cpu(struct task_group *tg, i=
nt cpu)
 	unsigned long flags;
 	struct rq *rq;
=20
-	if (!tg->cfs_se[cpu])
+	if (!tg->se[cpu])
 		return 0;
=20
 	rq =3D cpu_rq(cpu);
@@ -4018,7 +4036,7 @@ static inline void idle_balance(int cpu, struct rq *r=
q)
 static void task_tick_fair(struct rq *rq, struct task_struct *curr, int qu=
eued)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_cfs_entity *cfs_se =3D &curr->cfs;
+	struct sched_cfs_entity *cfs_se =3D &curr->se.cfs;
=20
 	for_each_sched_cfs_entity(cfs_se) {
 		cfs_rq =3D cfs_rq_of(cfs_se);
@@ -4034,7 +4052,7 @@ static void task_tick_fair(struct rq *rq, struct task=
_struct *curr, int queued)
 static void task_fork_fair(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(current);
-	struct sched_cfs_entity *cfs_se =3D &p->cfs, *curr =3D cfs_rq->curr;
+	struct sched_cfs_entity *cfs_se =3D &p->se.cfs, *curr =3D cfs_rq->curr;
 	int this_cpu =3D smp_processor_id();
 	struct rq *rq =3D this_rq();
 	unsigned long flags;
@@ -4113,7 +4131,7 @@ static void switched_to_fair(struct rq *rq, struct ta=
sk_struct *p,
  */
 static void set_curr_task_fair(struct rq *rq)
 {
-	struct sched_cfs_entity *cfs_se =3D &rq->curr->cfs;
+	struct sched_cfs_entity *cfs_se =3D &rq->curr->se.cfs;
=20
 	for_each_sched_cfs_entity(cfs_se)
 		set_next_entity(cfs_rq_of(cfs_se), cfs_se);
@@ -4136,16 +4154,16 @@ static void task_move_group_fair(struct task_struct=
 *p, int on_rq)
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
 	if (!on_rq)
-		p->cfs.vruntime -=3D cfs_rq_of(&p->cfs)->min_vruntime;
+		p->se.cfs.vruntime -=3D cfs_rq_of(&p->se.cfs)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		p->cfs.vruntime +=3D cfs_rq_of(&p->cfs)->min_vruntime;
+		p->se.cfs.vruntime +=3D cfs_rq_of(&p->se.cfs)->min_vruntime;
 }
 #endif
=20
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct=
 *task)
 {
-	struct sched_cfs_entity *cfs_se =3D &task->cfs;
+	struct sched_cfs_entity *cfs_se =3D &task->se.cfs;
 	unsigned int rr_interval =3D 0;
=20
 	/*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2bba302..702e562 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -12,7 +12,7 @@ static inline struct task_struct *rt_task_of(struct sched=
_rt_entity *rt_se)
 #ifdef CONFIG_SCHED_DEBUG
 	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
 #endif
-	return container_of(rt_se, struct task_struct, rt);
+	return container_of(rt_se, struct task_struct, se.rt);
 }
=20
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
@@ -31,7 +31,7 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_e=
ntity *rt_se)
=20
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se=
)
 {
-	return container_of(rt_se, struct task_struct, rt);
+	return container_of(rt_se, struct task_struct, se.rt);
 }
=20
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
@@ -214,7 +214,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 	struct task_struct *curr =3D rq_of_rt_rq(rt_rq)->curr;
 	struct sched_rt_entity *rt_se;
=20
-	rt_se =3D rt_rq->tg->rt_se[this_cpu];
+	rt_se =3D &rt_rq->tg->se[this_cpu]->rt;
=20
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
@@ -229,7 +229,7 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 	int this_cpu =3D smp_processor_id();
 	struct sched_rt_entity *rt_se;
=20
-	rt_se =3D rt_rq->tg->rt_se[this_cpu];
+	rt_se =3D &rt_rq->tg->se[this_cpu]->rt;
=20
 	if (rt_se && on_rt_rq(rt_se))
 		dequeue_rt_entity(rt_se);
@@ -621,23 +621,23 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt=
_rq)
 static void update_curr_rt(struct rq *rq)
 {
 	struct task_struct *curr =3D rq->curr;
-	struct sched_rt_entity *rt_se =3D &curr->rt;
+	struct sched_rt_entity *rt_se =3D &curr->se.rt;
 	struct rt_rq *rt_rq =3D rt_rq_of_se(rt_se);
 	u64 delta_exec;
=20
 	if (!task_has_rt_policy(curr))
 		return;
=20
-	delta_exec =3D rq->clock_task - curr->cfs.exec_start;
+	delta_exec =3D rq->clock_task - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec =3D 0;
=20
-	schedstat_set(curr->cfs.statistics.exec_max, max(curr->cfs.statistics.exe=
c_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_=
max, delta_exec));
=20
-	curr->cfs.sum_exec_runtime +=3D delta_exec;
+	curr->se.sum_exec_runtime +=3D delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
=20
-	curr->cfs.exec_start =3D rq->clock_task;
+	curr->se.exec_start =3D rq->clock_task;
 	cpuacct_charge(curr, delta_exec);
=20
 	sched_rt_avg_update(rq, delta_exec);
@@ -914,20 +914,20 @@ static void dequeue_rt_entity(struct sched_rt_entity =
*rt_se)
 static void
 enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct sched_rt_entity *rt_se =3D &p->rt;
+	struct sched_rt_entity *rt_se =3D &p->se.rt;
=20
 	if (flags & ENQUEUE_WAKEUP)
 		rt_se->timeout =3D 0;
=20
 	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
=20
-	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
+	if (!task_current(rq, p) && p->se.rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
=20
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flag=
s)
 {
-	struct sched_rt_entity *rt_se =3D &p->rt;
+	struct sched_rt_entity *rt_se =3D &p->se.rt;
=20
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se);
@@ -955,7 +955,7 @@ requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_=
entity *rt_se, int head)
=20
 static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head=
)
 {
-	struct sched_rt_entity *rt_se =3D &p->rt;
+	struct sched_rt_entity *rt_se =3D &p->se.rt;
 	struct rt_rq *rt_rq;
=20
 	for_each_sched_rt_entity(rt_se) {
@@ -995,9 +995,9 @@ select_task_rq_rt(struct rq *rq, struct task_struct *p,=
 int sd_flag, int flags)
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	    (rq->curr->se.rt.nr_cpus_allowed < 2 ||
 	     rq->curr->prio < p->prio) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
+	    (p->se.rt.nr_cpus_allowed > 1)) {
 		int cpu =3D find_lowest_rq(p);
=20
 		return (cpu =3D=3D -1) ? task_cpu(p) : cpu;
@@ -1012,10 +1012,10 @@ select_task_rq_rt(struct rq *rq, struct task_struct=
 *p, int sd_flag, int flags)
=20
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->rt.nr_cpus_allowed =3D=3D 1)
+	if (rq->curr->se.rt.nr_cpus_allowed =3D=3D 1)
 		return;
=20
-	if (p->rt.nr_cpus_allowed !=3D 1
+	if (p->se.rt.nr_cpus_allowed !=3D 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
=20
@@ -1099,7 +1099,7 @@ static struct task_struct *_pick_next_task_rt(struct =
rq *rq)
 	} while (rt_rq);
=20
 	p =3D rt_task_of(rt_se);
-	p->cfs.exec_start =3D rq->clock_task;
+	p->se.exec_start =3D rq->clock_task;
=20
 	return p;
 }
@@ -1126,13 +1126,13 @@ static struct task_struct *pick_next_task_rt(struct=
 rq *rq)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
-	p->cfs.exec_start =3D 0;
+	p->se.exec_start =3D 0;
=20
 	/*
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (p->cfs.on_rq && p->rt.nr_cpus_allowed > 1)
+	if (p->se.on_rq && p->se.rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
=20
@@ -1147,7 +1147,7 @@ static int pick_rt_task(struct rq *rq, struct task_st=
ruct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
 	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->rt.nr_cpus_allowed > 1))
+	    (p->se.rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -1199,7 +1199,7 @@ static int find_lowest_rq(struct task_struct *task)
 	int this_cpu =3D smp_processor_id();
 	int cpu      =3D task_cpu(task);
=20
-	if (task->rt.nr_cpus_allowed =3D=3D 1)
+	if (task->se.rt.nr_cpus_allowed =3D=3D 1)
 		return -1; /* No other targets possible */
=20
 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
@@ -1283,7 +1283,7 @@ static struct rq *find_lock_lowest_rq(struct task_str=
uct *task, struct rq *rq)
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
-				     !task->cfs.on_rq)) {
+				     !task->se.on_rq)) {
=20
 				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq =3D NULL;
@@ -1315,9 +1315,9 @@ static struct task_struct *pick_next_pushable_task(st=
ruct rq *rq)
=20
 	BUG_ON(rq->cpu !=3D task_cpu(p));
 	BUG_ON(task_current(rq, p));
-	BUG_ON(p->rt.nr_cpus_allowed <=3D 1);
+	BUG_ON(p->se.rt.nr_cpus_allowed <=3D 1);
=20
-	BUG_ON(!p->cfs.on_rq);
+	BUG_ON(!p->se.on_rq);
 	BUG_ON(!rt_task(p));
=20
 	return p;
@@ -1463,7 +1463,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p =3D=3D src_rq->curr);
-			WARN_ON(!p->cfs.on_rq);
+			WARN_ON(!p->se.on_rq);
=20
 			/*
 			 * There's a chance that p is higher in priority
@@ -1516,9 +1516,9 @@ static void task_woken_rt(struct rq *rq, struct task_=
struct *p)
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
-	    p->rt.nr_cpus_allowed > 1 &&
+	    p->se.rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	    (rq->curr->se.rt.nr_cpus_allowed < 2 ||
 	     rq->curr->prio < p->prio))
 		push_rt_tasks(rq);
 }
@@ -1534,7 +1534,7 @@ static void set_cpus_allowed_rt(struct task_struct *p=
,
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->cfs.on_rq && (weight !=3D p->rt.nr_cpus_allowed)) {
+	if (p->se.on_rq && (weight !=3D p->se.rt.nr_cpus_allowed)) {
 		struct rq *rq =3D task_rq(p);
=20
 		if (!task_current(rq, p)) {
@@ -1544,7 +1544,7 @@ static void set_cpus_allowed_rt(struct task_struct *p=
,
 			 * the list because we are no longer pushable, or it
 			 * will be requeued.
 			 */
-			if (p->rt.nr_cpus_allowed > 1)
+			if (p->se.rt.nr_cpus_allowed > 1)
 				dequeue_pushable_task(rq, p);
=20
 			/*
@@ -1555,9 +1555,9 @@ static void set_cpus_allowed_rt(struct task_struct *p=
,
=20
 		}
=20
-		if ((p->rt.nr_cpus_allowed <=3D 1) && (weight > 1)) {
+		if ((p->se.rt.nr_cpus_allowed <=3D 1) && (weight > 1)) {
 			rq->rt.rt_nr_migratory++;
-		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <=3D 1)) {
+		} else if ((p->se.rt.nr_cpus_allowed > 1) && (weight <=3D 1)) {
 			BUG_ON(!rq->rt.rt_nr_migratory);
 			rq->rt.rt_nr_migratory--;
 		}
@@ -1566,7 +1566,7 @@ static void set_cpus_allowed_rt(struct task_struct *p=
,
 	}
=20
 	cpumask_copy(&p->cpus_allowed, new_mask);
-	p->rt.nr_cpus_allowed =3D weight;
+	p->se.rt.nr_cpus_allowed =3D weight;
 }
=20
 /* Assumes rq->lock is held */
@@ -1698,10 +1698,10 @@ static void watchdog(struct rq *rq, struct task_str=
uct *p)
 	if (soft !=3D RLIM_INFINITY) {
 		unsigned long next;
=20
-		p->rt.timeout++;
+		p->se.rt.timeout++;
 		next =3D DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
-		if (p->rt.timeout > next)
-			p->cputime_expires.sched_exp =3D p->cfs.sum_exec_runtime;
+		if (p->se.rt.timeout > next)
+			p->cputime_expires.sched_exp =3D p->se.sum_exec_runtime;
 	}
 }
=20
@@ -1718,16 +1718,16 @@ static void task_tick_rt(struct rq *rq, struct task=
_struct *p, int queued)
 	if (p->policy !=3D SCHED_RR)
 		return;
=20
-	if (--p->rt.time_slice)
+	if (--p->se.rt.time_slice)
 		return;
=20
-	p->rt.time_slice =3D DEF_TIMESLICE;
+	p->se.rt.time_slice =3D DEF_TIMESLICE;
=20
 	/*
 	 * Requeue to the end of queue if we are not the only element
 	 * on the queue:
 	 */
-	if (p->rt.run_list.prev !=3D p->rt.run_list.next) {
+	if (p->se.rt.run_list.prev !=3D p->se.rt.run_list.next) {
 		requeue_task_rt(rq, p, 0);
 		set_tsk_need_resched(p);
 	}
@@ -1737,7 +1737,7 @@ static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p =3D rq->curr;
=20
-	p->cfs.exec_start =3D rq->clock_task;
+	p->se.exec_start =3D rq->clock_task;
=20
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 763732d..2bf6b47 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -26,7 +26,7 @@ static struct task_struct *pick_next_task_stop(struct rq =
*rq)
 {
 	struct task_struct *stop =3D rq->stop;
=20
-	if (stop && stop->cfs.on_rq)
+	if (stop && stop->se.on_rq)
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

--=-iTumfD0B3u3XG3BTOCF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jRHEACgkQk4XaBE3IOsRomACdHJchKcjc40qwJtHC+UyeOJLy
txoAnjrLP08BfJZk/uJij2eU4daa0JJQ
=2sXp
-----END PGP SIGNATURE-----

--=-iTumfD0B3u3XG3BTOCF6--

