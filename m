Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1KGPTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:19:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:55127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1KGPTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:19:20 -0500
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        eric.dumazet@gmail.com, shaohua.li@intel.com, ak@linux.intel.com,
        mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Stephane Eranian <eranian@google.com>
Date: Mon, 07 Nov 2011 16:15:02 +0100
In-Reply-To: <4EAF5B68.8090005@cn.fujitsu.com>
References: <20111003161335.GA2403@linux.vnet.ibm.com>
	 <20111004074637.GA14061@elte.hu>
	 <20111024100501.GA24913@linux.vnet.ibm.com>
	 <20111024114806.GA3340@linux.vnet.ibm.com> <20111026203020.GA10285@elte.hu>
	 <20111027075901.GB2313@linux.vnet.ibm.com> <20111027080016.GA16885@elte.hu>
	 <4EAA14A1.5060204@cn.fujitsu.com>
	 <20111029182710.GG6160@linux.vnet.ibm.com>
	 <4EAE57AF.1060706@cn.fujitsu.com>
	 <20111031093256.GI6160@linux.vnet.ibm.com>
	 <4EAF5B68.8090005@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320678902.18053.63.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far nobody seems to have stated if this is an actual problem or just
shutting up lockdep-prove-rcu? I very much suspect the latter, in which
case I really utterly hate the patch because it adds instructions to
fast-paths just to kill a debug warning.

On Tue, 2011-11-01 at 10:37 +0800, Li Zefan wrote:
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
>          cpuctx->cgrp = perf_cgroup_from_task(task);
> 
> but seems the cgroup is not pinned, so cpuctx->cgrp can be invalid in later use.
> 
> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d1a1bee..f5e05ce 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -302,7 +302,10 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
>         if (!is_cgroup_event(event))
>                 return;
>  
> +       rcu_read_lock();
>         cgrp = perf_cgroup_from_task(current);
> +       rcu_read_unlock();
> +
>         /*
>          * Do not update time when cgroup is not active
>          */

This looks like shutting things up, because what protects the use of
cgrp after rcu_read_unlock() ?

Similar to the below, this is a stupid patch to shut things up, no
actual problem there, just making a hot path slow.

> @@ -325,9 +328,11 @@ perf_cgroup_set_timestamp(struct task_struct *task,
>         if (!task || !ctx->nr_cgroups)
>                 return;
>  
> +       rcu_read_lock();
>         cgrp = perf_cgroup_from_task(task);
>         info = this_cpu_ptr(cgrp->info);
>         info->timestamp = ctx->timestamp;
> +       rcu_read_unlock();
>  }

This seems to actually protect the cgrp usage, but is that needed?

It looks to be superfluous, since
perf_cgroup_attach_task()->__perf_cgroup_move()->perf_cgroup_switch()
will hold ctx->lock when it switches a task from one cgroup to another
and perf_cgroup_set_timestamp() should only ever be called while holding
the ctx->lock since that is what is used to serialize the timestamps.

>  #define PERF_CGROUP_SWOUT      0x1 /* cgroup switch out every event */
> @@ -406,6 +411,8 @@ static inline void perf_cgroup_sched_out(struct task_struct *task,
>         struct perf_cgroup *cgrp1;
>         struct perf_cgroup *cgrp2 = NULL;
>  
> +       rcu_read_lock();
> +
>         /*
>          * we come here when we know perf_cgroup_events > 0
>          */
> @@ -418,6 +425,8 @@ static inline void perf_cgroup_sched_out(struct task_struct *task,
>         if (next)
>                 cgrp2 = perf_cgroup_from_task(next);
>  
> +       rcu_read_unlock();
> +
>         /*
>          * only schedule out current cgroup events if we know
>          * that we are switching to a different cgroup. Otherwise,

This only hides a warning and leaves a race.

> @@ -433,6 +442,8 @@ static inline void perf_cgroup_sched_in(struct task_struct *prev,
>         struct perf_cgroup *cgrp1;
>         struct perf_cgroup *cgrp2 = NULL;
>  
> +       rcu_read_lock();
> +
>         /*
>          * we come here when we know perf_cgroup_events > 0
>          */
> @@ -441,6 +452,8 @@ static inline void perf_cgroup_sched_in(struct task_struct *prev,
>         /* prev can never be NULL */
>         cgrp2 = perf_cgroup_from_task(prev);
>  
> +       rcu_read_unlock();
> +
>         /*
>          * only need to schedule in cgroup events if we are changing
>          * cgroup during ctxsw. Cgroup events were not scheduled
> 

idem.

So no, this patch utterly sucks, it adds code to hot paths just to quiet
debug warnings in two cases and the remaining two cases annotates a
warning away while leaving an actual problem unfixed.


