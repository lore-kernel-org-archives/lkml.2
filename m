Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0C2VeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:34:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52948 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0C2VeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:34:09 -0400
Date: Mon, 29 Mar 2010 14:34:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       abogani@texware.it
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
Message-ID: <20100329213405.GA18143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329211525.GA17703@linux.vnet.ibm.com>
 <1269897564.12097.372.camel@laptop>
 <20100329212932.GO2569@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329212932.GO2569@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 02:29:32PM -0700, Paul E. McKenney wrote:
> On Mon, Mar 29, 2010 at 11:19:23PM +0200, Peter Zijlstra wrote:
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
> It might well be wrong.  The lockdep RCU splat triggered in
> task_subsys_state():
> 
> static inline struct cgroup_subsys_state *task_subsys_state(
> 	struct task_struct *task, int subsys_id)
> {
> 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
> 				     rcu_read_lock_held() ||
> 				     cgroup_lock_is_held());
> }
> 
> My thought was that this access was safe due to the fact that we were
> in the middle of creating a task, so that no other CPU could access it.
> But I am not certain of this, given the fact that this is digging through
> cgroup state.
> 
> The lockdep splat is here: http://pastebin.ubuntu.com/406131/
> 
> Suggestions?

And it appears that my patch is at best insufficient:
http://paste.ubuntu.com/406189/

Left to myself, I would wrap copy_process() with rcu_read_lock(),
but I would rather hear your thoughts before doing too much more
semi-random hacking.  ;-)

						Thanx, Paul
