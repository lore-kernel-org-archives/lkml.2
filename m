Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0KRQk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:40:56 -0500
Received: from mail.selbetti.com.br ([201.67.157.50]:56974 "EHLO
	mail.selbetti.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab0KRQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:40:55 -0500
Subject: Re: Galbraith patch
From: Gilberto Nunes <gilberto.nunes@selbetti.com.br>
Reply-To: gilberto.nunes@selbetti.com.br
To: Mike Galbraith <efault@gmx.de>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1290096365.30211.5.camel@maggy.simson.net>
References: <1290018947.4887.14.camel@note-311a>
	 <AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
	 <AANLkTinRBvZQmeU-eEeDSd1ELvcxDZAdM6F8-UCROybq@mail.gmail.com>
	 <1290021497.4887.24.camel@note-311a>
	 <1290036097.27521.5.camel@maggy.simson.net>
	 <1290095008.9939.0.camel@note-311a>
	 <1290096365.30211.5.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Selbetti =?ISO-8859-1?Q?Gest=E3o?= de Documentos
Date: Thu, 18 Nov 2010 14:40:46 -0200
Message-ID: <1290098446.9939.3.camel@note-311a>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK... excuse me... 

Sorry for disturb!

I'll try

Thanks

Em Qui, 2010-11-18 às 09:06 -0700, Mike Galbraith escreveu:
> On Thu, 2010-11-18 at 13:43 -0200, Gilberto Nunes wrote:
> > Hi...
> > 
> > Someone can help with this????
> 
> Hey, patience please, I'm on vacation :)
> 
> You can try the below if you like.  It's what I'm currently tinkering
> with, and has a patch it depends on appended for ease of application.
> Should apply cleanly to virgin 2.6.36.
> 
> 	-Mike
> 
> A recurring complaint from CFS users is that parallel kbuild has a negative
> impact on desktop interactivity.  This patch implements an idea from Linus,
> to automatically create task groups.  This patch implements only per session
> autogroups, but leaves the way open for enhancement.
> 
> Implementation: each task's signal struct contains an inherited pointer to a
> refcounted autogroup struct containing a task group pointer, the default for
> all tasks pointing to the init_task_group.  When a task calls setsid(), the
> process wide reference to the default group is dropped, a new task group is
> created, and the process is moved into the new task group.  Children thereafter
> inherit this task group, and increase it's refcount.  On exit, a reference to the
> current task group is dropped when the last reference to each signal struct is
> dropped.  The task group is destroyed when the last signal struct referencing
> it is freed.   At runqueue selection time, IFF a task has no cgroup assignment,
> it's current autogroup is used.
> 
> The feature is enabled from boot by default if CONFIG_SCHED_AUTOGROUP is
> selected, but can be disabled via the boot option noautogroup, and can be
> also be turned on/off on the fly via..
>    echo [01] > /proc/sys/kernel/sched_autogroup_enabled.
> ..which will automatically move tasks to/from the root task group.
> 
> Some numbers.
> 
> A 100% hog overhead measurement proggy pinned to the same CPU as a make -j10
> 
> About measurement proggy:
>   pert/sec = perturbations/sec
>   min/max/avg = scheduler service latencies in usecs
>   sum/s = time accrued by the competition per sample period (1 sec here)
>   overhead = %CPU received by the competition per sample period
> 
> pert/s:       31 >40475.37us:        3 min:  0.37 max:48103.60 avg:29573.74 sum/s:916786us overhead:90.24%
> pert/s:       23 >41237.70us:       12 min:  0.36 max:56010.39 avg:40187.01 sum/s:924301us overhead:91.99%
> pert/s:       24 >42150.22us:       12 min:  8.86 max:61265.91 avg:39459.91 sum/s:947038us overhead:92.20%
> pert/s:       26 >42344.91us:       11 min:  3.83 max:52029.60 avg:36164.70 sum/s:940282us overhead:91.12%
> pert/s:       24 >44262.90us:       14 min:  5.05 max:82735.15 avg:40314.33 sum/s:967544us overhead:92.22%
> 
> Same load with this patch applied.
> 
> pert/s:      229 >5484.43us:       41 min:  0.15 max:12069.42 avg:2193.81 sum/s:502382us overhead:50.24%
> pert/s:      222 >5652.28us:       43 min:  0.46 max:12077.31 avg:2248.56 sum/s:499181us overhead:49.92%
> pert/s:      211 >5809.38us:       43 min:  0.16 max:12064.78 avg:2381.70 sum/s:502538us overhead:50.25%
> pert/s:      223 >6147.92us:       43 min:  0.15 max:16107.46 avg:2282.17 sum/s:508925us overhead:50.49%
> pert/s:      218 >6252.64us:       43 min:  0.16 max:12066.13 avg:2324.11 sum/s:506656us overhead:50.27%
> 
> Average service latency is an order of magnitude better with autogroup.
> (Imagine that pert were Xorg or whatnot instead)
> 
> Using Mathieu Desnoyers' wakeup-latency testcase:
> 
> With taskset -c 3 make -j 10 running..
> 
> taskset -c 3 ./wakeup-latency& sleep 30;killall wakeup-latency
> 
> without:
> maximum latency: 42963.2 µs
> average latency: 9077.0 µs
> missed timer events: 0
> 
> with:
> maximum latency: 4160.7 µs
> average latency: 149.4 µs
> missed timer events: 0
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  Documentation/kernel-parameters.txt |    2 
>  include/linux/sched.h               |   19 ++++
>  init/Kconfig                        |   12 ++
>  kernel/fork.c                       |    5 -
>  kernel/sched.c                      |   13 ++
>  kernel/sched_autogroup.c            |  170 ++++++++++++++++++++++++++++++++++++
>  kernel/sched_autogroup.h            |   23 ++++
>  kernel/sched_debug.c                |   29 +++---
>  kernel/sys.c                        |    4 
>  kernel/sysctl.c                     |   11 ++
>  10 files changed, 270 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..a111fac 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -506,6 +506,8 @@ struct thread_group_cputimer {
>  	spinlock_t lock;
>  };
>  
> +struct autogroup;
> +
>  /*
>   * NOTE! "signal_struct" does not have it's own
>   * locking, because a shared signal_struct always
> @@ -573,6 +575,9 @@ struct signal_struct {
>  
>  	struct tty_struct *tty; /* NULL if no tty */
>  
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	struct autogroup *autogroup;
> +#endif
>  	/*
>  	 * Cumulative resource counters for dead threads in the group,
>  	 * and for reaped dead child processes forked by this group.
> @@ -1072,7 +1077,7 @@ struct sched_class {
>  					 struct task_struct *task);
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -	void (*moved_group) (struct task_struct *p, int on_rq);
> +	void (*task_move_group) (struct task_struct *p, int on_rq);
>  #endif
>  };
>  
> @@ -1900,6 +1905,20 @@ int sched_rt_handler(struct ctl_table *table, int write,
>  
>  extern unsigned int sysctl_sched_compat_yield;
>  
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +extern unsigned int sysctl_sched_autogroup_enabled;
> +
> +extern void sched_autogroup_create_attach(struct task_struct *p);
> +extern void sched_autogroup_detach(struct task_struct *p);
> +extern void sched_autogroup_fork(struct signal_struct *sig);
> +extern void sched_autogroup_exit(struct signal_struct *sig);
> +#else
> +static inline void sched_autogroup_create_attach(struct task_struct *p) { }
> +static inline void sched_autogroup_detach(struct task_struct *p) { }
> +static inline void sched_autogroup_fork(struct signal_struct *sig) { }
> +static inline void sched_autogroup_exit(struct signal_struct *sig) { }
> +#endif
> +
>  #ifdef CONFIG_RT_MUTEXES
>  extern int rt_mutex_getprio(struct task_struct *p);
>  extern void rt_mutex_setprio(struct task_struct *p, int prio);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc85ceb..8d1f066 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -78,6 +78,7 @@
>  
>  #include "sched_cpupri.h"
>  #include "workqueue_sched.h"
> +#include "sched_autogroup.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
> @@ -268,6 +269,10 @@ struct task_group {
>  	struct task_group *parent;
>  	struct list_head siblings;
>  	struct list_head children;
> +
> +#if (defined(CONFIG_SCHED_AUTOGROUP) && defined(CONFIG_SCHED_DEBUG))
> +	struct autogroup *autogroup;
> +#endif
>  };
>  
>  #define root_task_group init_task_group
> @@ -612,11 +617,14 @@ static inline int cpu_of(struct rq *rq)
>   */
>  static inline struct task_group *task_group(struct task_struct *p)
>  {
> +	struct task_group *tg;
>  	struct cgroup_subsys_state *css;
>  
>  	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
>  			lockdep_is_held(&task_rq(p)->lock));
> -	return container_of(css, struct task_group, css);
> +	tg = container_of(css, struct task_group, css);
> +
> +	return autogroup_task_group(p, tg);
>  }
>  
>  /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
> @@ -1920,6 +1928,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
>  #include "sched_idletask.c"
>  #include "sched_fair.c"
>  #include "sched_rt.c"
> +#include "sched_autogroup.c"
>  #ifdef CONFIG_SCHED_DEBUG
>  # include "sched_debug.c"
>  #endif
> @@ -7749,7 +7758,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_CGROUP_SCHED
>  	list_add(&init_task_group.list, &task_groups);
>  	INIT_LIST_HEAD(&init_task_group.children);
> -
> +	autogroup_init(&init_task);
>  #endif /* CONFIG_CGROUP_SCHED */
>  
>  #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
> @@ -8297,12 +8306,12 @@ void sched_move_task(struct task_struct *tsk)
>  	if (unlikely(running))
>  		tsk->sched_class->put_prev_task(rq, tsk);
>  
> -	set_task_rq(tsk, task_cpu(tsk));
> -
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -	if (tsk->sched_class->moved_group)
> -		tsk->sched_class->moved_group(tsk, on_rq);
> +	if (tsk->sched_class->task_move_group)
> +		tsk->sched_class->task_move_group(tsk, on_rq);
> +	else
>  #endif
> +		set_task_rq(tsk, task_cpu(tsk));
>  
>  	if (unlikely(running))
>  		tsk->sched_class->set_curr_task(rq);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index c445f8c..61f2802 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -173,8 +173,10 @@ static inline void free_signal_struct(struct signal_struct *sig)
>  
>  static inline void put_signal_struct(struct signal_struct *sig)
>  {
> -	if (atomic_dec_and_test(&sig->sigcnt))
> +	if (atomic_dec_and_test(&sig->sigcnt)) {
> +		sched_autogroup_exit(sig);
>  		free_signal_struct(sig);
> +	}
>  }
>  
>  void __put_task_struct(struct task_struct *tsk)
> @@ -900,6 +902,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	posix_cpu_timers_init_group(sig);
>  
>  	tty_audit_fork(sig);
> +	sched_autogroup_fork(sig);
>  
>  	sig->oom_adj = current->signal->oom_adj;
>  	sig->oom_score_adj = current->signal->oom_score_adj;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 7f5a0cd..2745dcd 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1080,8 +1080,10 @@ SYSCALL_DEFINE0(setsid)
>  	err = session;
>  out:
>  	write_unlock_irq(&tasklist_lock);
> -	if (err > 0)
> +	if (err > 0) {
>  		proc_sid_connector(group_leader);
> +		sched_autogroup_create_attach(group_leader);
> +	}
>  	return err;
>  }
>  
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 2e1b0d1..44a41d5 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -87,6 +87,20 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
>  }
>  #endif
>  
> +#if defined(CONFIG_CGROUP_SCHED) && \
> +	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> +static void task_group_path(struct task_group *tg, char *buf, int buflen)
> +{
> +	/* may be NULL if the underlying cgroup isn't fully-created yet */
> +	if (!tg->css.cgroup) {
> +		buf[0] = '\0';
> +		autogroup_path(tg, buf, buflen);
> +		return;
> +	}
> +	cgroup_path(tg->css.cgroup, buf, buflen);
> +}
> +#endif
> +
>  static void
>  print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>  {
> @@ -115,7 +129,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>  		char path[64];
>  
>  		rcu_read_lock();
> -		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
> +		task_group_path(task_group(p), path, sizeof(path));
>  		rcu_read_unlock();
>  		SEQ_printf(m, " %s", path);
>  	}
> @@ -147,19 +161,6 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
>  	read_unlock_irqrestore(&tasklist_lock, flags);
>  }
>  
> -#if defined(CONFIG_CGROUP_SCHED) && \
> -	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> -static void task_group_path(struct task_group *tg, char *buf, int buflen)
> -{
> -	/* may be NULL if the underlying cgroup isn't fully-created yet */
> -	if (!tg->css.cgroup) {
> -		buf[0] = '\0';
> -		return;
> -	}
> -	cgroup_path(tg->css.cgroup, buf, buflen);
> -}
> -#endif
> -
>  void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  {
>  	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 3a45c22..165eb9b 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -384,6 +384,17 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	{
> +		.procname	= "sched_autogroup_enabled",
> +		.data		= &sysctl_sched_autogroup_enabled,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
> +#endif
>  #ifdef CONFIG_PROVE_LOCKING
>  	{
>  		.procname	= "prove_locking",
> diff --git a/init/Kconfig b/init/Kconfig
> index 2de5b1c..666fc7e 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -652,6 +652,18 @@ config DEBUG_BLK_CGROUP
>  
>  endif # CGROUPS
>  
> +config SCHED_AUTOGROUP
> +	bool "Automatic process group scheduling"
> +	select CGROUPS
> +	select CGROUP_SCHED
> +	select FAIR_GROUP_SCHED
> +	help
> +	  This option optimizes the scheduler for common desktop workloads by
> +	  automatically creating and populating task groups.  This separation
> +	  of workloads isolates aggressive CPU burners (like build jobs) from
> +	  desktop applications.  Task group autogeneration is currently based
> +	  upon task session.
> +
>  config MM_OWNER
>  	bool
>  
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 8dd7248..1e02f1f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1610,6 +1610,8 @@ and is between 256 and 4096 characters. It is defined in the file
>  	noapic		[SMP,APIC] Tells the kernel to not make use of any
>  			IOAPICs that may be present in the system.
>  
> +	noautogroup	Disable scheduler automatic task group creation.
> +
>  	nobats		[PPC] Do not use BATs for mapping kernel lowmem
>  			on "Classic" PPC cores.
>  
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..4c44b90 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3824,13 +3824,26 @@ static void set_curr_task_fair(struct rq *rq)
>  }
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -static void moved_group_fair(struct task_struct *p, int on_rq)
> +static void task_move_group_fair(struct task_struct *p, int on_rq)
>  {
> -	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> -
> -	update_curr(cfs_rq);
> +	/*
> +	 * If the task was not on the rq at the time of this cgroup movement
> +	 * it must have been asleep, sleeping tasks keep their ->vruntime
> +	 * absolute on their old rq until wakeup (needed for the fair sleeper
> +	 * bonus in place_entity()).
> +	 *
> +	 * If it was on the rq, we've just 'preempted' it, which does convert
> +	 * ->vruntime to a relative base.
> +	 *
> +	 * Make sure both cases convert their relative position when migrating
> +	 * to another cgroup's rq. This does somewhat interfere with the
> +	 * fair sleeper stuff for the first placement, but who cares.
> +	 */
> +	if (!on_rq)
> +		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
> +	set_task_rq(p, task_cpu(p));
>  	if (!on_rq)
> -		place_entity(cfs_rq, &p->se, 1);
> +		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
>  }
>  #endif
>  
> @@ -3882,7 +3895,7 @@ static const struct sched_class fair_sched_class = {
>  	.get_rr_interval	= get_rr_interval_fair,
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -	.moved_group		= moved_group_fair,
> +	.task_move_group	= task_move_group_fair,
>  #endif
>  };
>  
> 
> 
> 
> 

-- 
--
Gilberto Nunes
Departamento de TI
Selbetti Gestão de Documentos
Fone: (47) 3441-6004
Celular (47) 8861-6672


<><

