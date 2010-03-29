Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0C2WYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:24:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40401 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab0C2WYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:24:36 -0400
Date: Mon, 29 Mar 2010 15:24:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       abogani@texware.it
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100329222432.GQ2569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329211525.GA17703@linux.vnet.ibm.com>
 <1269897564.12097.372.camel@laptop>
 <1269897964.12097.375.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269897964.12097.375.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:26:04PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 23:19 +0200, Peter Zijlstra wrote:
> > On Mon, 2010-03-29 at 14:15 -0700, Paul E. McKenney wrote:
> > > Add an rcu_read_lock() / rcu_read_unlock() pair to protect a fork-time
> > > cgroup access.  This seems likely to be a false positive.
> > > 
> > > Located by: Alessio Igor Bogani <abogani@texware.it>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > > 
> > >  sched.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > index 9ab3cd7..d4bb5e0 100644
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -2621,7 +2621,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
> > >  	if (p->sched_class->task_fork)
> > >  		p->sched_class->task_fork(p);
> > >  
> > > +	rcu_read_lock();
> > >  	set_task_cpu(p, cpu);
> > > +	rcu_read_unlock();
> > >  
> > >  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
> > >  	if (likely(sched_info_on()))
> > 
> > What got accessed? This patch just looks wrong.
> 
> So the only cgroup thing I can find is set_task_rq()'s task_group()
> usage, which does indeed look like it wants RCU, but then, why would
> only the sched_fork() usage of set_task_cpu() need this.
> 
> If it's needed (possible) then set_task_rq() needs it unconditionally.

Easy patch, if appropriate!

> That said, the whole task_group stuff is tied to the cgroup muck, so it
> shouldn't be possible for the task_group to disappear on us, but then, I
> always sorta glaze over when I get near the cgroup core.

Hey, if it was easy, I might have gotten it right on the first try!  ;-)

							Thanx, Paul
