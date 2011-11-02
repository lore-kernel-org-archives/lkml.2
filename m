Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab1KBTZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:25:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56849 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1KBTZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:25:33 -0400
Date: Wed, 2 Nov 2011 12:23:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com, shaohua.li@intel.com,
        ak@linux.intel.com, mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
Message-ID: <20111102192312.GS2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111024100501.GA24913@linux.vnet.ibm.com>
 <20111024114806.GA3340@linux.vnet.ibm.com>
 <20111026203020.GA10285@elte.hu>
 <20111027075901.GB2313@linux.vnet.ibm.com>
 <20111027080016.GA16885@elte.hu>
 <4EAA14A1.5060204@cn.fujitsu.com>
 <20111029182710.GG6160@linux.vnet.ibm.com>
 <4EAE57AF.1060706@cn.fujitsu.com>
 <20111031093256.GI6160@linux.vnet.ibm.com>
 <4EAF5B68.8090005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAF5B68.8090005@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110219-5806-0000-0000-000000EC3CDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 10:37:28AM +0800, Li Zefan wrote:
> (I shoud have cced Stephane Eranian instead of Turner..)
> 
> Paul E. McKenney wrote:
> > On Mon, Oct 31, 2011 at 04:09:19PM +0800, Li Zefan wrote:
> >> (Let's cc Peter and Paul Turner for this perf cgroup issue.)
> >>
> >>> Thank you for the analysis.  Does the following patch fix this problem?
> >>>
> >>> 							Thanx, Paul
> >>>
> >>> ------------------------------------------------------------------------
> >>>
> >>> fs: Add RCU protection in set_task_comm()
> >>>
> >>> Running "perf stat true" results in the following RCU-lockdep splat:
> >>>
> >>> ===============================
> >>> [ INFO: suspicious RCU usage. ]
> >>> -------------------------------
> >>> include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
> >>>
> >>> other info that might help us debug this:
> >>>
> >>> rcu_scheduler_active = 1, debug_locks = 0
> >>> 1 lock held by true/655:
> >>> #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<810d1bd7>] prepare_bprm_creds+0x27/0x70
> >>>
> >>> stack backtrace:
> >>> Pid: 655, comm: true Not tainted 3.1.0-tip-01868-g1271bd2-dirty #161079
> >>> Call Trace:
> >>> [<81abe239>] ? printk+0x18/0x1a
> >>> [<81064920>] lockdep_rcu_suspicious+0xc0/0xd0
> >>> [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
> >>> [<81063764>] ? __lock_release+0x54/0xb0
> >>> [<8108cca8>] perf_event_comm+0x18/0x60
> >>> [<810d1abd>] ? set_task_comm+0x5d/0x80
> >>> [<81af622d>] ? _raw_spin_unlock+0x1d/0x40
> >>> [<810d1ac4>] set_task_comm+0x64/0x80
> >>> [<810d25fd>] setup_new_exec+0xbd/0x1d0
> >>> [<810d1b61>] ? flush_old_exec+0x81/0xa0
> >>> [<8110753e>] load_elf_binary+0x28e/0xa00
> >>> [<810d2101>] ? search_binary_handler+0xd1/0x1d0
> >>> [<81063764>] ? __lock_release+0x54/0xb0
> >>> [<811072b0>] ? load_elf_library+0x260/0x260
> >>> [<810d2108>] search_binary_handler+0xd8/0x1d0
> >>> [<810d2060>] ? search_binary_handler+0x30/0x1d0
> >>> [<810d242f>] do_execve_common+0x22f/0x2a0
> >>> [<810d24b2>] do_execve+0x12/0x20
> >>> [<81009592>] sys_execve+0x32/0x70
> >>> [<81af7752>] ptregs_execve+0x12/0x20
> >>> [<81af76d4>] ? sysenter_do_call+0x12/0x36
> >>>
> >>> Li Zefan noted that this is due to set_task_comm() dropping the task
> >>> lock before invoking perf_event_comm(), which could in fact result in
> >>> the task being freed up before perf_event_comm() completed tracing in
> >>> the case where one task invokes set_task_comm() on another task -- which
> >>> actually does occur via comm_write(), which can be invoked via /proc.
> >>>
> >>
> >> This is not true. The caller should ensure @tsk is valid during
> >> set_task_comm().
> >>
> >> The warning comes from perf_cgroup_from_task(). We can trigger this warning
> >> in some other cases where perf cgroup is used, for example:
> > 
> > I must defer to your greater knowledge of this situation.  What patch
> > would you propose?
> > 
> 
> With the following patch, we should see no rcu warning from perf, but as I
> don't know the internel of perf, I guess we have to defer to Peter and
> Stephane. ;)
> 
> I have two doubts:
> 
> - in perf_cgroup_sched_out/in(), we retrieve the task's cgroup twice in the function
> and it's callee perf_cgroup_switch(), but the task can move to another cgroup between
> two calls, so they might return two different cgroup pointers. Does it matter?
> 
> - in perf_cgroup_switch():
> 
> 	 cpuctx->cgrp = perf_cgroup_from_task(task);
> 
> but seems the cgroup is not pinned, so cpuctx->cgrp can be invalid in later use.

Looks sane to me, for whatever that might be worth.

								Thanx, Paul

> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d1a1bee..f5e05ce 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -302,7 +302,10 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
>  	if (!is_cgroup_event(event))
>  		return;
> 
> +	rcu_read_lock();
>  	cgrp = perf_cgroup_from_task(current);
> +	rcu_read_unlock();
> +
>  	/*
>  	 * Do not update time when cgroup is not active
>  	 */
> @@ -325,9 +328,11 @@ perf_cgroup_set_timestamp(struct task_struct *task,
>  	if (!task || !ctx->nr_cgroups)
>  		return;
> 
> +	rcu_read_lock();
>  	cgrp = perf_cgroup_from_task(task);
>  	info = this_cpu_ptr(cgrp->info);
>  	info->timestamp = ctx->timestamp;
> +	rcu_read_unlock();
>  }
> 
>  #define PERF_CGROUP_SWOUT	0x1 /* cgroup switch out every event */
> @@ -406,6 +411,8 @@ static inline void perf_cgroup_sched_out(struct task_struct *task,
>  	struct perf_cgroup *cgrp1;
>  	struct perf_cgroup *cgrp2 = NULL;
> 
> +	rcu_read_lock();
> +
>  	/*
>  	 * we come here when we know perf_cgroup_events > 0
>  	 */
> @@ -418,6 +425,8 @@ static inline void perf_cgroup_sched_out(struct task_struct *task,
>  	if (next)
>  		cgrp2 = perf_cgroup_from_task(next);
> 
> +	rcu_read_unlock();
> +
>  	/*
>  	 * only schedule out current cgroup events if we know
>  	 * that we are switching to a different cgroup. Otherwise,
> @@ -433,6 +442,8 @@ static inline void perf_cgroup_sched_in(struct task_struct *prev,
>  	struct perf_cgroup *cgrp1;
>  	struct perf_cgroup *cgrp2 = NULL;
> 
> +	rcu_read_lock();
> +
>  	/*
>  	 * we come here when we know perf_cgroup_events > 0
>  	 */
> @@ -441,6 +452,8 @@ static inline void perf_cgroup_sched_in(struct task_struct *prev,
>  	/* prev can never be NULL */
>  	cgrp2 = perf_cgroup_from_task(prev);
> 
> +	rcu_read_unlock();
> +
>  	/*
>  	 * only need to schedule in cgroup events if we are changing
>  	 * cgroup during ctxsw. Cgroup events were not scheduled
> 

