Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0DSXBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 19:01:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56139 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab0DSXBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 19:01:38 -0400
Date: Mon, 19 Apr 2010 16:01:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@parisplace.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without
 protection!
Message-ID: <20100419230136.GA16856@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
 <20100311032843.GE6767@linux.vnet.ibm.com>
 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
 <1271098032.4807.137.camel@twins>
 <1271242058.32749.19.camel@laptop>
 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 02:26:52PM -0400, Eric Paris wrote:
> On Wed, 2010-04-14 at 12:47 +0200, Peter Zijlstra wrote:
> > On Mon, 2010-04-12 at 20:47 +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-04-12 at 14:44 -0400, Eric Paris wrote:
> > > > On Wed, Mar 10, 2010 at 11:28 PM, Paul E. McKenney
> > > > <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > I know you indicated this was fixed in mainline and I see that set of
> > > > commits objects, but I'm seeing the below spew from linux-next today.
> > > > 
> > > > tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > > tag: next-20100412
> > > > commit: bbeecf185fe464ccd7ee97ce6d3646ad686995b4
> > > > 
> > > > [    0.035602] ===================================================
> > > > [    0.036003] [ INFO: suspicious rcu_dereference_check() usage. ]
> > > > [    0.037006] ---------------------------------------------------
> > > > [    0.038004] include/linux/cgroup.h:533 invoked
> > > > rcu_dereference_check() without protection!
> > > > [    0.039003]
> > > > [    0.039004] other info that might help us debug this:
> > > > [    0.039004]
> > > > [    0.040003]
> > > > [    0.040004] rcu_scheduler_active = 1, debug_locks = 0
> > > > [    0.041004] no locks held by swapper/0.
> > > > [    0.042003]
> > > > [    0.042004] stack backtrace:
> > > > [    0.043005] Pid: 0, comm: swapper Not tainted 2.6.34-rc3-next-20100412+ #65
> > > > [    0.044003] Call Trace:
> > > > [    0.045015]  [<ffffffff8108584f>] lockdep_rcu_dereference+0xaf/0xc0
> > > > [    0.046010]  [<ffffffff81044812>] set_task_cpu+0x2d2/0x370
> > > 
> > > Oh, right, I still have to sort that out.
> > > 
> > > I need to figure out how all that scheduler and cgroup muck interact to
> > > fix this.
> > 
> > I think the below should cure this..
> > 
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 3acf694..2e06d87 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
> >  /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
> >  static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
> >  {
> > +	/*
> > +	 * Strictly speaking this rcu_read_lock() is not needed since the
> > +	 * task_group is tied to the cgroup, which in turn can never go away
> > +	 * as long as there are tasks attached to it.
> > +	 *
> > +	 * However since task_group() uses task_subsys_state() which is an
> > +	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
> > +	 */
> > +	rcu_read_lock();
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> >  	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
> >  	p->se.parent = task_group(p)->se[cpu];
> > @@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
> >  	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
> >  	p->rt.parent = task_group(p)->rt_se[cpu];
> >  #endif
> > +	rcu_read_unlock();
> >  }
> >  
> >  #else
> 
> So I'm back with another one even with this patch.  Would people prefer
> another thread?
> 
> [    0.037175] ===================================================
> [    0.038003] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.039003] ---------------------------------------------------
> [    0.040004] include/linux/cgroup.h:533 invoked rcu_dereference_check() without protection!
> [    0.041003]
> [    0.041004] other info that might help us debug this:
> [    0.041005]
> [    0.042004]
> [    0.042004] rcu_scheduler_active = 1, debug_locks = 0
> [    0.043004] no locks held by swapper/0.
> [    0.044003]
> [    0.044004] stack backtrace:
> [    0.045005] Pid: 0, comm: swapper Not tainted 2.6.34-rc4-next-20100415+ #94
> [    0.046004] Call Trace:
> [    0.047014]  [<ffffffff8108652f>] lockdep_rcu_dereference+0xaf/0xc0
> [    0.048013]  [<ffffffff810a3453>] freezer_fork+0xb3/0xd0
> [    0.049007]  [<ffffffff8109d61c>] cgroup_fork_callbacks+0x2c/0x40
> [    0.050007]  [<ffffffff81055e4a>] copy_process+0xb6a/0x11e0
> [    0.051006]  [<ffffffff8105657e>] do_fork+0xbe/0x3e0
> [    0.052007]  [<ffffffff81012519>] ? sched_clock+0x9/0x10
> [    0.053008]  [<ffffffff81077d45>] ? sched_clock_local+0x15/0x80
> [    0.054006]  [<ffffffff81077e69>] ? sched_clock_cpu+0xb9/0xf0
> [    0.055006]  [<ffffffff81076cd5>] ? up+0x35/0x50
> [    0.056006]  [<ffffffff81084073>] ? get_lock_stats+0x23/0x70
> [    0.057006]  [<ffffffff810840ce>] ? put_lock_stats+0xe/0x30
> [    0.058010]  [<ffffffff81cade20>] ? kernel_init+0x0/0x2e0
> [    0.059006]  [<ffffffff810136dd>] kernel_thread+0x8d/0xa0
> [    0.060006]  [<ffffffff81cade20>] ? kernel_init+0x0/0x2e0
> [    0.061007]  [<ffffffff8100bc20>] ? kernel_thread_helper+0x0/0x10
> [    0.062006]  [<ffffffff81cad140>] ? early_idt_handler+0x0/0x71
> [    0.063011]  [<ffffffff814e40c1>] rest_init+0x21/0x110
> [    0.064005]  [<ffffffff81cadd3f>] start_kernel+0x3af/0x490
> [    0.065006]  [<ffffffff81cad29c>] x86_64_start_reservations+0x7c/0xd0
> [    0.066005]  [<ffffffff81cad000>] ? early_idt_handlers+0x0/0x140
> [    0.067006]  [<ffffffff81cad3e8>] x86_64_start_kernel+0xf8/0x130

Yep, different code path to the same location.  Does the following
patch help?

							Thanx, Paul

------------------------------------------------------------------------

commit 2836f18139267ea918ed2cf39023fb0eb38c4361
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Apr 19 15:59:50 2010 -0700

    rcu: fix RCU lockdep splat on freezer_fork path
    
    Add an RCU read-side critical section to suppress this false positive.
    
    Located-by: Eric Paris <eparis@parisplace.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..e5c0244 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * No lock is needed, since the task isn't on tasklist yet,
 	 * so it can't be moved to another cgroup, which means the
 	 * freezer won't be removed and will be valid during this
-	 * function call.
+	 * function call.  Nevertheless, apply RCU read-side critical
+	 * section to suppress RCU lockdep false positives.
 	 */
+	rcu_read_lock();
 	freezer = task_freezer(task);
+	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
