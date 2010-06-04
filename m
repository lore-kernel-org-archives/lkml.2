Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab0FDEKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:10:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53227 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0FDEKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:10:50 -0400
Date: Thu, 3 Jun 2010 21:10:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100604041047.GB2780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com>
 <20100602145653.GA2385@linux.vnet.ibm.com>
 <4C07743C.7030204@cn.fujitsu.com>
 <20100603183040.GA2385@linux.vnet.ibm.com>
 <4C0868A0.5080508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0868A0.5080508@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 10:44:48AM +0800, Li Zefan wrote:
> > Seems worth reviewing the other uses of task_group():
> > 
> > 1.	set_task_rq() -- only a runqueue and a sched_rt_entity leave
> > 	the RCU read-side critical section.  Runqueues do persist.
> > 	I don't claim to understand the sched_rt_entity life cycle.
> > 
> > 2.	__sched_setscheduler() -- not clear to me that this one is
> > 	protected to begin with.  If it is somehow correctly protected,
> > 	it discards the RCU-protected pointer immediately, so is OK
> > 	otherwise.
> > 
> > 3.	cpu_cgroup_destroy() -- ditto.
> > 
> > 4.	cpu_shares_read_u64() -- ditto.
> > 
> > 5.	print_task() -- protected by rcu_read_lock() and discards the
> > 	RCU-protected pointer immediately, so this one is OK.
> > 
> > Any task_group() experts able to weigh in on #2, #3, and #4?
> > 
> 
> #3 and #4 are safe, because it's not calling task_group(), but
> cgroup_tg():
> 
> 	struct task_group *tg = cgroup_tg(cgrp);
> 
> As long as it's safe to access cgrp, it's safe to access tg.

Good point, thank you!

Any takers on #2?

							Thanx, Paul

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 50ec9ea..224ef98 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1251,7 +1251,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  	}
> >  
> >  	tg = task_group(p);
> > -	rcu_read_unlock();
> >  	weight = p->se.load.weight;
> >  
> >  	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
> > @@ -1268,6 +1267,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  	balanced = !this_load ||
> >  		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
> >  		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
> > +	rcu_read_unlock();
> >  
> 
> This is fine.
> 
> Another way is :
> 
> rcu_read_lock();
> tg = task_group(p);
> css_get(&tg->css);
> rcu_read_unlock();
> 
> /* do something */
> ...
> 
> css_put(&tg->css);
