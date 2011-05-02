Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1EBKmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:42:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47534 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1EBKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:42:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] cpuset: fix cpuset_cpus_allowed_fallback() don't update tsk->rt.nr_cpus_allowed
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
In-Reply-To: <20110428161149.GA15658@redhat.com>
References: <20110428232228.3D57.A69D9226@jp.fujitsu.com> <20110428161149.GA15658@redhat.com>
Message-Id: <20110502194416.2D61.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  2 May 2011 19:42:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/28, KOSAKI Motohiro wrote:
> >
> > Oleg, Peter,
> >
> > I apologize if I misunderstand a code.
> 
> Heh, I bet you understand it better than me ;)
> 
> > index f20eb8f..42dcbdc 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -147,6 +147,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
> >  static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
> >  {
> >  	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> > +	p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
> >  	return cpumask_any(cpu_active_mask);
> >  }
> >
> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > index 1ceeb04..6e5bbe8 100644
> > --- a/kernel/cpuset.c
> > +++ b/kernel/cpuset.c
> > @@ -2220,6 +2220,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> >  		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
> >  		cpu = cpumask_any(cpu_active_mask;
> >  	}
> > +	tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);
> 
> I think you are right...
> 
> But, don't we need sched_class->set_cpus_allowed() in this case? Only for
> consistency, iiuc currently it is not needed because the task is not active.
> 
> IOW, perhaps cpuset_cpus_allowed_fallback() should do
> 
> 
> 	if (p->sched_class->set_cpus_allowed)
> 		p->sched_class->set_cpus_allowed(p, cpu_possible_mask);
> 	else {
> 		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> 		p->rt.nr_cpus_allowed = cpumask_weight(cpu_possible_mask);
> 	}
> 
> ?
> 
> If yes, probably the new do_set_cpus_allowed(p, mask) helper makes sense,
> it can be used by set_cpus_allowed_ptr() too.

Absolutely. I have very similar patch. but I though we should keep them
separated. The reasons are two.

1. To keep simple one line patch may help to reduce a backport guy's headache.
2. now we have 6 tsk->cpu_allowed writer.

1) sched_rt.c: set_cpus_allowed_rt()		no problem. it's shceduler.
2) sched.c: set_cpus_allowed_ptr()		ditto.
3) sched.c: init_idle()				no lock, but no competitor. that's init.
4) kthread.c kthread_bind()			no lock, but no competitor. kthread haven't started yet
5) cpuset.c: cpuset_cpus_allowed_fallback() 	p->pi_lock held
6) arch/bfin/../process.c: bfin_clone()		crazy. but I alread sent a patch to blackfin folks.

ok, (2)-(5) can use do_set_cpus_allowed(). but It slightly large refactoring.

But, Hmmm...
I've found my patch have one issue. Sigh. Recently RCU sub system introduced
rcuc FIFO kthread and it start to run before secondary cpu is up. then,
cpuset_cpus_allowed_fallback set its cpus_allowed to cpu_possible_mask and
kernel will crash.

Will fix it too.


