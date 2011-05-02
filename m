Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab1EBM7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:59:01 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50692 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab1EBM65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:58:57 -0400
Date: Mon, 2 May 2011 05:58:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
Message-ID: <20110502125848.GB2294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110428232228.3D57.A69D9226@jp.fujitsu.com>
 <20110428161149.GA15658@redhat.com>
 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502194416.2D61.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 07:42:40PM +0900, KOSAKI Motohiro wrote:
> > On 04/28, KOSAKI Motohiro wrote:
> > >
> > > Oleg, Peter,
> > >
> > > I apologize if I misunderstand a code.
> > 
> > Heh, I bet you understand it better than me ;)
> > 
> > > index f20eb8f..42dcbdc 100644
> > > --- a/include/linux/cpuset.h
> > > +++ b/include/linux/cpuset.h
> > > @@ -147,6 +147,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
> > >  static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
> > >  {
> > >  	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> > > +	p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
> > >  	return cpumask_any(cpu_active_mask);
> > >  }
> > >
> > > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > > index 1ceeb04..6e5bbe8 100644
> > > --- a/kernel/cpuset.c
> > > +++ b/kernel/cpuset.c
> > > @@ -2220,6 +2220,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> > >  		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
> > >  		cpu = cpumask_any(cpu_active_mask;
> > >  	}
> > > +	tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);
> > 
> > I think you are right...
> > 
> > But, don't we need sched_class->set_cpus_allowed() in this case? Only for
> > consistency, iiuc currently it is not needed because the task is not active.
> > 
> > IOW, perhaps cpuset_cpus_allowed_fallback() should do
> > 
> > 
> > 	if (p->sched_class->set_cpus_allowed)
> > 		p->sched_class->set_cpus_allowed(p, cpu_possible_mask);
> > 	else {
> > 		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> > 		p->rt.nr_cpus_allowed = cpumask_weight(cpu_possible_mask);
> > 	}
> > 
> > ?
> > 
> > If yes, probably the new do_set_cpus_allowed(p, mask) helper makes sense,
> > it can be used by set_cpus_allowed_ptr() too.
> 
> Absolutely. I have very similar patch. but I though we should keep them
> separated. The reasons are two.
> 
> 1. To keep simple one line patch may help to reduce a backport guy's headache.
> 2. now we have 6 tsk->cpu_allowed writer.
> 
> 1) sched_rt.c: set_cpus_allowed_rt()		no problem. it's shceduler.
> 2) sched.c: set_cpus_allowed_ptr()		ditto.
> 3) sched.c: init_idle()				no lock, but no competitor. that's init.
> 4) kthread.c kthread_bind()			no lock, but no competitor. kthread haven't started yet
> 5) cpuset.c: cpuset_cpus_allowed_fallback() 	p->pi_lock held
> 6) arch/bfin/../process.c: bfin_clone()		crazy. but I alread sent a patch to blackfin folks.
> 
> ok, (2)-(5) can use do_set_cpus_allowed(). but It slightly large refactoring.
> 
> But, Hmmm...
> I've found my patch have one issue. Sigh. Recently RCU sub system introduced
> rcuc FIFO kthread and it start to run before secondary cpu is up. then,
> cpuset_cpus_allowed_fallback set its cpus_allowed to cpu_possible_mask and
> kernel will crash.

If there is something different that I should be doing with the rcuc FIFO
kthread, please do let me know!

							Thanx, Paul

> Will fix it too.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
