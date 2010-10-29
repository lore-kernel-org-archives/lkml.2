Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0J2Gos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:44:48 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:62566 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754653Ab0J2Gon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:44:43 -0400
Subject: [RFC][PATCH 21/22] sched: add bandwidth management for sched_dl
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333128.8661.137.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sEogI8fnLLQK1wun+5im"
Date: Fri, 29 Oct 2010 08:44:30 +0200
Message-ID: <1288334670.8661.163.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sEogI8fnLLQK1wun+5im
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


In order of -deaadline scheduling to be effective and useful, it is
important that some method of having the allocation of the available
CPU bandwidth to tasks and task groups under control.
This is usually called "admission control" and if it is not performed
at all, no guarantee can be given on the actual scheduling of the
-deadline tasks.

Since when RT-throttling has been introduced each task group have a
bandwidth associated to itself, calculated as a certain amount of
runtime over a period. Moreover, to make it possible to manipulate
such bandwidth, readable/writable controls have been added to both
procfs (for system wide settings) and cgroupfs (for per-group
settings).
Therefore, the same interface is being used for controlling the
bandwidth distrubution to -deadline tasks and task groups, i.e.,
new controls but with similar names, equivalent meaning and with
the same usage paradigm are added.

However, more discussion is needed in order to figure out how
we want to manage SCHED_DEADLINE bandwidth at the task group level.
Therefore, this patch adds a less sophisticated, but actually
very sensible, machanism to ensure that a certain utilization
cap is not overcome per each root_domain.

Another main difference between deadline bandwidth management and
RT-throttling is that -deadline tasks have bandwidth on their own
(while -rt ones doesn't!), and thus we don't need an higher level
throttling mechanism to enforce the desired bandwidth.

This patch, therefore:
 - adds system wide deadline bandwidth management by means of:
    * /proc/sys/kernel/sched_dl_runtime_us,
    * /proc/sys/kernel/sched_dl_period_us,
   that determine (i.e., runtime / period) the total bandwidth
   available on each CPU of each root_domain for -deadline tasks;
 - couples the RT and deadline bandwidth management, i.e., enforces
   that the sum of how much bandwidth is being devoted to -rt
   -deadline tasks to stay below 100%.

This means that, for a root_domain comprising M CPUs, -deadline tasks
can be created until the sum of their bandwidths stay below:

    M * (sched_dl_runtime_us / sched_dl_period_us)

It is also possible to disable this bandwidth management logic, and
be thus free of oversubscribing the system up to any arbitrary level.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    8 +
 kernel/sched.c        |  480 +++++++++++++++++++++++++++++++++++++++++++++=
+--
 kernel/sched_dl.c     |   10 +
 kernel/sysctl.c       |   14 ++
 4 files changed, 492 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7cf78e2..03f8a8a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1293,6 +1293,7 @@ struct sched_dl_entity {
 	u64 dl_runtime;		/* maximum runtime for each instance 	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
 	u64 dl_period;		/* separation of two instances (period) */
+	u64 dl_bw;		/* dl_runtime / dl_deadline		*/
=20
 	/*
 	 * Actual scheduling parameters. Initialized with the values above,
@@ -2116,6 +2117,13 @@ int sched_rt_handler(struct ctl_table *table, int wr=
ite,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
=20
+extern unsigned int sysctl_sched_dl_period;
+extern int sysctl_sched_dl_runtime;
+
+int sched_dl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 extern unsigned int sysctl_sched_compat_yield;
=20
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/sched.c b/kernel/sched.c
index 97db370..5cc0e48 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -153,6 +153,22 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
=20
+static unsigned long to_ratio(u64 period, u64 runtime)
+{
+	if (runtime =3D=3D RUNTIME_INF)
+		return 1ULL << 20;
+
+	/*
+	 * Doing this here saves a lot of checks in all
+	 * the calling paths, and returning zero seems
+	 * safe for them anyway.
+	 */
+	if (period =3D=3D 0)
+		return 0;
+
+	return div64_u64(runtime << 20, period);
+}
+
 struct rt_bandwidth {
 	/* nests inside the rq lock: */
 	raw_spinlock_t		rt_runtime_lock;
@@ -242,6 +258,74 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *=
rt_b)
 #endif
=20
 /*
+ * To keep the bandwidth of -deadline tasks and groups under control
+ * we need some place where:
+ *  - store the maximum -deadline bandwidth of the system (the group);
+ *  - cache the fraction of that bandwidth that is currently allocated.
+ *
+ * This is all done in the data structure below. It is similar to the
+ * one used for RT-throttling (rt_bandwidth), with the main difference
+ * that, since here we are only interested in admission control, we
+ * do not decrease any runtime while the group "executes", neither we
+ * need a timer to replenish it.
+ *
+ * With respect to SMP, the bandwidth is given on a per-CPU basis,
+ * meaning that:
+ *  - dl_bw (< 100%) is the bandwidth of the system (group) on each CPU;
+ *  - dl_total_bw array contains, in the i-eth element, the currently
+ *    allocated bandwidth on the i-eth CPU.
+ * Moreover, groups consume bandwidth on each CPU, while tasks only
+ * consume bandwidth on the CPU they're running on.
+ * Finally, dl_total_bw_cpu is used to cache the index of dl_total_bw
+ * that will be shown the next time the proc or cgroup controls will
+ * be red. It on its turn can be changed by writing on its own
+ * control.
+ */
+struct dl_bandwidth {
+	raw_spinlock_t dl_runtime_lock;
+	u64 dl_runtime;
+	u64 dl_period;
+};
+
+static struct dl_bandwidth def_dl_bandwidth;
+
+static
+void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime)
+{
+	raw_spin_lock_init(&dl_b->dl_runtime_lock);
+	dl_b->dl_period =3D period;
+	dl_b->dl_runtime =3D runtime;
+}
+
+static inline int dl_bandwidth_enabled(void)
+{
+	return sysctl_sched_dl_runtime >=3D 0;
+}
+
+/*
+ *
+ */
+struct dl_bw {
+	raw_spinlock_t lock;
+	u64 bw, total_bw;
+};
+
+static inline u64 global_dl_period(void);
+static inline u64 global_dl_runtime(void);
+
+static void init_dl_bw(struct dl_bw *dl_b)
+{
+	raw_spin_lock_init(&dl_b->lock);
+	raw_spin_lock(&def_dl_bandwidth.dl_runtime_lock);
+	if (global_dl_runtime() =3D=3D RUNTIME_INF)
+		dl_b->bw =3D -1;
+	else
+		dl_b->bw =3D to_ratio(global_dl_period(), global_dl_runtime());
+	raw_spin_unlock(&def_dl_bandwidth.dl_runtime_lock);
+	dl_b->total_bw =3D 0;
+}
+
+/*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
  */
@@ -478,6 +562,7 @@ struct root_domain {
 	 */
 	cpumask_var_t dlo_mask;
 	atomic_t dlo_count;
+	struct dl_bw dl_bw;
=20
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
@@ -915,6 +1000,28 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
=20
+/*
+ * Maximum bandwidth available for all -deadline tasks and groups
+ * (if group scheduling is configured) on each CPU.
+ *
+ * default: 5%
+ */
+unsigned int sysctl_sched_dl_period =3D 1000000;
+int sysctl_sched_dl_runtime =3D 50000;
+
+static inline u64 global_dl_period(void)
+{
+	return (u64)sysctl_sched_dl_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_dl_runtime(void)
+{
+	if (sysctl_sched_dl_runtime < 0)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_dl_runtime * NSEC_PER_USEC;
+}
+
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
@@ -2806,6 +2913,70 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	put_cpu();
 }
=20
+static inline
+void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw -=3D tsk_bw;
+}
+
+static inline
+void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw +=3D tsk_bw;
+}
+
+static inline
+bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
+{
+	return dl_b->bw !=3D -1 &&
+	       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
+}
+
+/*
+ * We must be sure that accepting a new task (or allowing changing the
+ * parameters of an existing one) is consistent with the bandwidth
+ * contraints. If yes, this function also accordingly updates the currentl=
y
+ * allocated bandwidth to reflect the new situation.
+ *
+ * This function is called while holding p's rq->lock.
+ */
+static int dl_overflow(struct task_struct *p, int policy,
+		       const struct sched_param_ex *param_ex)
+{
+	struct dl_bw *dl_b =3D &task_rq(p)->rd->dl_bw;
+	u64 period =3D timespec_to_ns(&param_ex->sched_period);
+	u64 runtime =3D timespec_to_ns(&param_ex->sched_runtime);
+	u64 new_bw =3D dl_policy(policy) ? to_ratio(period, runtime) : 0;
+	int cpus =3D cpumask_weight(task_rq(p)->rd->span);
+	int err =3D -1;
+
+	if (new_bw =3D=3D p->dl.dl_bw)
+		return 0;
+
+	/*
+	 * Either if a task, enters, leave, or stays -deadline but changes
+	 * its parameters, we may need to update accordingly the total
+	 * allocated bandwidth of the container.
+	 */
+	raw_spin_lock(&dl_b->lock);
+	if (dl_policy(policy) && !task_has_dl_policy(p) &&
+	    !__dl_overflow(dl_b, cpus, 0, new_bw)) {
+		__dl_add(dl_b, new_bw);
+		err =3D 0;
+	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
+		   !__dl_overflow(dl_b, cpus, p->dl.dl_bw, new_bw)) {
+		__dl_clear(dl_b, p->dl.dl_bw);
+		__dl_add(dl_b, new_bw);
+		err =3D 0;
+	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
+		__dl_clear(dl_b, p->dl.dl_bw);
+		err =3D 0;
+	}
+	raw_spin_unlock(&dl_b->lock);
+
+	return err;
+}
+
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
@@ -4815,6 +4986,7 @@ __setparam_dl(struct task_struct *p, const struct sch=
ed_param_ex *param_ex)
 		dl_se->dl_period =3D timespec_to_ns(&param_ex->sched_period);
 	else
 		dl_se->dl_period =3D dl_se->dl_deadline;
+	dl_se->dl_bw =3D to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->flags =3D param_ex->sched_flags;
 	dl_se->dl_throttled =3D 0;
 	dl_se->dl_new =3D 1;
@@ -5015,8 +5187,8 @@ recheck:
 		return -EINVAL;
 	}
=20
-#ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
+#ifdef CONFIG_RT_GROUP_SCHED
 		/*
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
@@ -5027,9 +5199,25 @@ recheck:
 			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 			return -EPERM;
 		}
-	}
 #endif
=20
+		if (dl_bandwidth_enabled() && dl_policy(policy)) {
+			const struct cpumask *span =3D rq->rd->span;
+
+			/*
+			 * Don't allow tasks with an affinity mask smaller than
+			 * the entire root_domain to become SCHED_DEADLINE. We
+			 * will also fail if there's no bandwidth available.
+			 */
+			if (!cpumask_equal(&p->cpus_allowed, span) ||
+			    rq->rd->dl_bw.bw =3D=3D 0) {
+				__task_rq_unlock(rq);
+				raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+				return -EPERM;
+			}
+		}
+	}
+
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy !=3D -1 && oldpolicy !=3D p->policy)) {
 		policy =3D oldpolicy =3D -1;
@@ -5037,6 +5225,19 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
+
+	/*
+	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
+	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
+	 * is available.
+	 */
+	if ((dl_policy(policy) || dl_task(p)) &&
+	    dl_overflow(p, policy, param_ex)) {
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		return -EBUSY;
+	}
+
 	on_rq =3D p->se.on_rq;
 	running =3D task_current(rq, p);
 	if (on_rq)
@@ -5415,6 +5616,22 @@ long sched_setaffinity(pid_t pid, const struct cpuma=
sk *in_mask)
 	if (retval)
 		goto out_unlock;
=20
+	/*
+	 * Since bandwidth control happens on root_domain basis,
+	 * if admission test is enabled, we only admit -deadline
+	 * tasks allowed to run on all the CPUs in the task's
+	 * root_domain.
+	 */
+	if (task_has_dl_policy(p)) {
+		const struct cpumask *span =3D task_rq(p)->rd->span;
+
+		if (dl_bandwidth_enabled() &&
+		    !cpumask_equal(in_mask, span)) {
+			retval =3D -EBUSY;
+			goto out_unlock;
+		}
+	}
+
 	cpuset_cpus_allowed(p, cpus_allowed);
 	cpumask_and(new_mask, in_mask, cpus_allowed);
 again:
@@ -6076,6 +6293,42 @@ out:
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
=20
 /*
+ * When dealing with a -deadline task, we have to check if moving it to
+ * a new CPU is possible or not. In fact, this is only true iff there
+ * is enough bandwidth available on such CPU, otherwise we want the
+ * whole migration progedure to fail over.
+ */
+static inline
+bool set_task_cpu_dl(struct task_struct *p, unsigned int cpu)
+{
+	struct dl_bw *dl_b =3D &task_rq(p)->rd->dl_bw;
+	struct dl_bw *cpu_b =3D &cpu_rq(cpu)->rd->dl_bw;
+	int ret =3D 1;
+	u64 bw;
+
+	if (dl_b =3D=3D cpu_b)
+		return 1;
+
+	raw_spin_lock(&dl_b->lock);
+	raw_spin_lock(&cpu_b->lock);
+
+	bw =3D cpu_b->bw * cpumask_weight(cpu_rq(cpu)->rd->span);
+	if (dl_bandwidth_enabled() &&
+	    bw < cpu_b->total_bw + p->dl.dl_bw) {
+		ret =3D 0;
+		goto unlock;
+	}
+	dl_b->total_bw -=3D p->dl.dl_bw;
+	cpu_b->total_bw +=3D p->dl.dl_bw;
+
+unlock:
+	raw_spin_unlock(&cpu_b->lock);
+	raw_spin_unlock(&dl_b->lock);
+
+	return ret;
+}
+
+/*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
  * this because either it can't run here any more (set_cpus_allowed()
  * away from this CPU, or CPU going down), or because we're
@@ -6106,6 +6359,13 @@ static int __migrate_task(struct task_struct *p, int=
 src_cpu, int dest_cpu)
 		goto fail;
=20
 	/*
+	 * If p is -deadline, proceed only if there is enough
+	 * bandwidth available on dest_cpu
+	 */
+	if (unlikely(dl_task(p)) && !set_task_cpu_dl(p, dest_cpu))
+		goto fail;
+
+	/*
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
@@ -6856,6 +7116,8 @@ static int init_rootdomain(struct root_domain *rd)
 	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
 		goto free_dlo_mask;
=20
+	init_dl_bw(&rd->dl_bw);
+
 	if (cpupri_init(&rd->cpupri) !=3D 0)
 		goto free_rto_mask;
 	return 0;
@@ -8406,6 +8668,8 @@ void __init sched_init(void)
=20
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
+	init_dl_bandwidth(&def_dl_bandwidth,
+			global_dl_period(), global_dl_runtime());
=20
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&init_task_group.rt_bandwidth,
@@ -9074,14 +9338,6 @@ unsigned long sched_group_shares(struct task_group *=
tg)
  */
 static DEFINE_MUTEX(rt_constraints_mutex);
=20
-static unsigned long to_ratio(u64 period, u64 runtime)
-{
-	if (runtime =3D=3D RUNTIME_INF)
-		return 1ULL << 20;
-
-	return div64_u64(runtime << 20, period);
-}
-
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
 {
@@ -9243,10 +9499,48 @@ long sched_group_rt_period(struct task_group *tg)
 	do_div(rt_period_us, NSEC_PER_USEC);
 	return rt_period_us;
 }
+#endif /* CONFIG_RT_GROUP_SCHED */
+
+/*
+ * Coupling of -rt and -deadline bandwidth.
+ *
+ * Here we check if the new -rt bandwidth value is consistent
+ * with the system settings for the bandwidth available
+ * to -deadline tasks.
+ *
+ * IOW, we want to enforce that
+ *
+ *   rt_bandwidth + dl_bandwidth <=3D 100%
+ *
+ * is always true.
+ */
+static bool __sched_rt_dl_global_constraints(u64 rt_bw)
+{
+	unsigned long flags;
+	u64 dl_bw;
+	bool ret;
+
+	raw_spin_lock_irqsave(&def_dl_bandwidth.dl_runtime_lock, flags);
+	if (global_rt_runtime() =3D=3D RUNTIME_INF ||
+	    global_dl_runtime() =3D=3D RUNTIME_INF) {
+		ret =3D true;
+		goto unlock;
+	}
+
+	dl_bw =3D to_ratio(def_dl_bandwidth.dl_period,
+			 def_dl_bandwidth.dl_runtime);
+
+	ret =3D rt_bw + dl_bw <=3D to_ratio(RUNTIME_INF, RUNTIME_INF);
+unlock:
+	raw_spin_unlock_irqrestore(&def_dl_bandwidth.dl_runtime_lock, flags);
+
+	return ret;
+}
=20
+#ifdef CONFIG_RT_GROUP_SCHED
 static int sched_rt_global_constraints(void)
 {
-	u64 runtime, period;
+	u64 runtime, period, bw;
 	int ret =3D 0;
=20
 	if (sysctl_sched_rt_period <=3D 0)
@@ -9261,6 +9555,10 @@ static int sched_rt_global_constraints(void)
 	if (runtime > period && runtime !=3D RUNTIME_INF)
 		return -EINVAL;
=20
+	bw =3D to_ratio(period, runtime)
+	if (!__sched_rt_dl_global_constraints(bw))
+		return -EINVAL;
+
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
 	ret =3D __rt_schedulable(NULL, 0, 0);
@@ -9283,19 +9581,19 @@ int sched_rt_can_attach(struct task_group *tg, stru=
ct task_struct *tsk)
 static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
-	int i;
+	int i, ret =3D 0;
+	u64 bw;
=20
 	if (sysctl_sched_rt_period <=3D 0)
 		return -EINVAL;
=20
-	/*
-	 * There's always some RT tasks in the root group
-	 * -- migration, kstopmachine etc..
-	 */
-	if (sysctl_sched_rt_runtime =3D=3D 0)
-		return -EBUSY;
-
 	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
+	bw =3D to_ratio(global_rt_period(), global_rt_runtime());
+	if (!__sched_rt_dl_global_constraints(bw)) {
+		ret =3D -EINVAL;
+		goto unlock;
+	}
+
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq =3D &cpu_rq(i)->rt;
=20
@@ -9303,12 +9601,100 @@ static int sched_rt_global_constraints(void)
 		rt_rq->rt_runtime =3D global_rt_runtime();
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
+unlock:
 	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
=20
-	return 0;
+	return ret;
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+/*
+ * Coupling of -dl and -rt bandwidth.
+ *
+ * Here we check, while setting the system wide bandwidth available
+ * for -dl tasks and groups, if the new values are consistent with
+ * the system settings for the bandwidth available to -rt entities.
+ *
+ * IOW, we want to enforce that
+ *
+ *   rt_bandwidth + dl_bandwidth <=3D 100%
+ *
+ * is always true.
+ */
+static bool __sched_dl_rt_global_constraints(u64 dl_bw)
+{
+	u64 rt_bw;
+	bool ret;
+
+	raw_spin_lock(&def_rt_bandwidth.rt_runtime_lock);
+	if (global_dl_runtime() =3D=3D RUNTIME_INF ||
+	    global_rt_runtime() =3D=3D RUNTIME_INF) {
+		ret =3D true;
+		goto unlock;
+	}
+
+	rt_bw =3D to_ratio(ktime_to_ns(def_rt_bandwidth.rt_period),
+			 def_rt_bandwidth.rt_runtime);
+
+	ret =3D rt_bw + dl_bw <=3D to_ratio(RUNTIME_INF, RUNTIME_INF);
+unlock:
+	raw_spin_unlock(&def_rt_bandwidth.rt_runtime_lock);
+
+	return ret;
+}
+
+static bool __sched_dl_global_constraints(u64 runtime, u64 period)
+{
+	/*
+	 * There's always some -deadline tasks in the root group
+	 * -- migration, kstopmachine etc..
+	 */
+	if (runtime =3D=3D 0)
+		return -EBUSY;
+
+	if (!period || (runtime !=3D RUNTIME_INF && runtime > period))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int sched_dl_global_constraints(void)
+{
+	u64 runtime =3D global_dl_runtime();
+	u64 period =3D global_dl_period();
+	u64 new_bw =3D to_ratio(period, runtime);
+	int ret, i;
+
+	ret =3D __sched_dl_global_constraints(runtime, period);
+	if (ret)
+		return ret;
+
+	if (!__sched_dl_rt_global_constraints(new_bw))
+		return -EINVAL;
+
+	/*
+	 * Here we want to check the bandwidth not being set to some
+	 * value smaller than the currently allocated bandwidth in
+	 * any of the root_domains.
+	 *
+	 * FIXME: Cycling on all the CPUs is overdoing, but simpler than
+	 * cycling on root_domains... Discussion on different/better
+	 * solutions is welcome!
+	 */
+	for_each_possible_cpu(i) {
+		struct dl_bw *dl_b =3D &cpu_rq(i)->rd->dl_bw;
+
+		raw_spin_lock(&dl_b->lock);
+		if (new_bw < dl_b->total_bw) {
+			raw_spin_unlock(&dl_b->lock);
+			return -EBUSY;
+		}
+		raw_spin_unlock(&dl_b->lock);
+	}
+
+	return 0;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -9339,6 +9725,60 @@ int sched_rt_handler(struct ctl_table *table, int wr=
ite,
 	return ret;
 }
=20
+int sched_dl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	int old_period, old_runtime;
+	static DEFINE_MUTEX(mutex);
+	unsigned long flags;
+
+	mutex_lock(&mutex);
+	old_period =3D sysctl_sched_dl_period;
+	old_runtime =3D sysctl_sched_dl_runtime;
+
+	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		raw_spin_lock_irqsave(&def_dl_bandwidth.dl_runtime_lock,
+				      flags);
+
+		ret =3D sched_dl_global_constraints();
+		if (ret) {
+			sysctl_sched_dl_period =3D old_period;
+			sysctl_sched_dl_runtime =3D old_runtime;
+		} else {
+			u64 new_bw;
+			int i;
+
+			def_dl_bandwidth.dl_period =3D global_dl_period();
+			def_dl_bandwidth.dl_runtime =3D global_dl_runtime();
+			if (global_dl_runtime() =3D=3D RUNTIME_INF)
+				new_bw =3D -1;
+			else
+				new_bw =3D to_ratio(global_dl_period(),
+						  global_dl_runtime());
+			/*
+			 * FIXME: As above...
+			 */
+			for_each_possible_cpu(i) {
+				struct dl_bw *dl_b =3D &cpu_rq(i)->rd->dl_bw;
+
+				raw_spin_lock(&dl_b->lock);
+				dl_b->bw =3D new_bw;
+				raw_spin_unlock(&dl_b->lock);
+			}
+		}
+
+		raw_spin_unlock_irqrestore(&def_dl_bandwidth.dl_runtime_lock,
+					   flags);
+	}
+	mutex_unlock(&mutex);
+
+	return ret;
+}
+
 #ifdef CONFIG_CGROUP_SCHED
=20
 /* return corresponding task_group object of a cgroup */
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 991a4f2..69324ae 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -1084,7 +1084,17 @@ static void task_fork_dl(struct task_struct *p)
=20
 static void task_dead_dl(struct task_struct *p)
 {
+	struct dl_bw *dl_b =3D &task_rq(p)->rd->dl_bw;
+
+	/*
+	 * Since we are TASK_DEAD we won't slip out of the domain!
+	 */
+	raw_spin_lock_irq(&dl_b->lock);
+	dl_b->total_bw -=3D p->dl.dl_bw;
+	raw_spin_unlock_irq(&dl_b->lock);
+
 	/*
+	 * We are no longer holding any lock here, so it is safe to
 	 * We are not holding any lock here, so it is safe to
 	 * wait for the bandwidth timer to be removed.
 	 */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c33a1ed..eb975be 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -376,6 +376,20 @@ static struct ctl_table kern_table[] =3D {
 		.proc_handler	=3D sched_rt_handler,
 	},
 	{
+		.procname	=3D "sched_dl_period_us",
+		.data		=3D &sysctl_sched_dl_period,
+		.maxlen		=3D sizeof(unsigned int),
+		.mode		=3D 0644,
+		.proc_handler	=3D sched_dl_handler,
+	},
+	{
+		.procname	=3D "sched_dl_runtime_us",
+		.data		=3D &sysctl_sched_dl_runtime,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D sched_dl_handler,
+	},
+	{
 		.procname	=3D "sched_compat_yield",
 		.data		=3D &sysctl_sched_compat_yield,
 		.maxlen		=3D sizeof(unsigned int),
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-sEogI8fnLLQK1wun+5im
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbU4ACgkQk4XaBE3IOsSn3wCdFPl9OUEocb5L19S0rqIUvfV4
A5gAmwWWDz5h5XuNyBX1pZT9LOpnFTB3
=UGok
-----END PGP SIGNATURE-----

--=-sEogI8fnLLQK1wun+5im--

