Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1D1QNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1D1QNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:13:06 -0400
Date: Thu, 28 Apr 2011 18:11:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH] cpuset: fix cpuset_cpus_allowed_fallback() don't
	update tsk->rt.nr_cpus_allowed
Message-ID: <20110428161149.GA15658@redhat.com>
References: <20110428232228.3D57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428232228.3D57.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, KOSAKI Motohiro wrote:
>
> Oleg, Peter,
>
> I apologize if I misunderstand a code.

Heh, I bet you understand it better than me ;)

> index f20eb8f..42dcbdc 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -147,6 +147,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
>  static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
>  {
>  	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> +	p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
>  	return cpumask_any(cpu_active_mask);
>  }
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 1ceeb04..6e5bbe8 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2220,6 +2220,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>  		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
>  		cpu = cpumask_any(cpu_active_mask;
>  	}
> +	tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);

I think you are right...

But, don't we need sched_class->set_cpus_allowed() in this case? Only for
consistency, iiuc currently it is not needed because the task is not active.

IOW, perhaps cpuset_cpus_allowed_fallback() should do


	if (p->sched_class->set_cpus_allowed)
		p->sched_class->set_cpus_allowed(p, cpu_possible_mask);
	else {
		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
		p->rt.nr_cpus_allowed = cpumask_weight(cpu_possible_mask);
	}

?

If yes, probably the new do_set_cpus_allowed(p, mask) helper makes sense,
it can be used by set_cpus_allowed_ptr() too.

Oleg.

