Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab0EBELV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:11:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56866 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0EBELT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:11:19 -0400
Date: Sat, 1 May 2010 21:11:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100502041111.GC2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100419230136.GA16856@linux.vnet.ibm.com>
 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
 <20100420030452.GB2905@linux.vnet.ibm.com>
 <4BCD646B.1080206@cn.fujitsu.com>
 <1271766716.2972.16.camel@dhcp231-113.rdu.redhat.com>
 <j2ya44ae5cd1004200545q6be4ec82o18ae99d93e8c29c7@mail.gmail.com>
 <20100420135227.GC2628@linux.vnet.ibm.com>
 <t2pa44ae5cd1005011026lab3a2440tb9fa351f172abf75@mail.gmail.com>
 <20100501215502.GA2474@linux.vnet.ibm.com>
 <r2ma44ae5cd1005011900x1699943dm9b354f5f1a3fe3cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <r2ma44ae5cd1005011900x1699943dm9b354f5f1a3fe3cf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 10:00:43PM -0400, Miles Lane wrote:
> On Sat, May 1, 2010 at 5:55 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, May 01, 2010 at 01:26:15PM -0400, Miles Lane wrote:
> >> On Tue, Apr 20, 2010 at 9:52 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Tue, Apr 20, 2010 at 08:45:28AM -0400, Miles Lane wrote:
> >> >> Is there a patch set for 2.6.34-rc5 I can test?
> >> >
> >> > I will be sending a patchset out later today after testing, but
> >> > please see below for a sneak preview collapsed into a single patch.
> >> >
> >> >                                                        Thanx, Paul
> >> >
> >> >> On Tue, Apr 20, 2010 at 8:31 AM, Eric Paris <eparis@redhat.com> wrote:
> >> >>
> >> >> > On Tue, 2010-04-20 at 16:23 +0800, Lai Jiangshan wrote:
> >> >> >
> >> >> > > [PATCH] RCU: don't turn off lockdep when find suspicious
> >> >> > rcu_dereference_check() usage
> >> >> > >
> >> >> > > When suspicious rcu_dereference_check() usage is detected, lockdep is
> >> >> > still
> >> >> > > available actually, so we should not call debug_locks_off() in
> >> >> > > lockdep_rcu_dereference().
> >> >> > >
> >> >> > > For get rid of too much "suspicious rcu_dereference_check() usage"
> >> >> > > output when the "if(!debug_locks_off())" statement is removed. This patch
> >> >> > uses
> >> >> > > static variable '__warned's for very usage of "rcu_dereference*()".
> >> >> > >
> >> >> > > One variable per usage, so, Now, we can get multiple complaint
> >> >> > > when we detect multiple different suspicious rcu_dereference_check()
> >> >> > usage.
> >> >> > >
> >> >> > > Requested-by: Eric Paris <eparis@redhat.com>
> >> >> > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >> >> >
> >> >> > Although mine was a linux-next kernel and it doesn't appear that I have
> >> >> > rcu_dereference_protected() at all, so I dropped that bit of the patch,
> >> >> > it worked great!  I got 4 more complaints to harass people with.  Feel
> >> >> > free to add my tested by if you care to.
> >> >> >
> >> >> > Tested-by: Eric Paris <eparis@redhat.com>
> >> >
> >> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> >> > index 07db2fe..ec9ab49 100644
> >> > --- a/include/linux/rcupdate.h
> >> > +++ b/include/linux/rcupdate.h
> >> > @@ -190,6 +190,15 @@ static inline int rcu_read_lock_sched_held(void)
> >> >
> >> >  #ifdef CONFIG_PROVE_RCU
> >> >
> >> > +#define __do_rcu_dereference_check(c)                                  \
> >> > +       do {                                                            \
> >> > +               static bool __warned;                                   \
> >> > +               if (debug_lockdep_rcu_enabled() && !__warned && !(c)) { \
> >> > +                       __warned = true;                                \
> >> > +                       lockdep_rcu_dereference(__FILE__, __LINE__);    \
> >> > +               }                                                       \
> >> > +       } while (0)
> >> > +
> >> >  /**
> >> >  * rcu_dereference_check - rcu_dereference with debug checking
> >> >  * @p: The pointer to read, prior to dereferencing
> >> > @@ -219,8 +228,7 @@ static inline int rcu_read_lock_sched_held(void)
> >> >  */
> >> >  #define rcu_dereference_check(p, c) \
> >> >        ({ \
> >> > -               if (debug_lockdep_rcu_enabled() && !(c)) \
> >> > -                       lockdep_rcu_dereference(__FILE__, __LINE__); \
> >> > +               __do_rcu_dereference_check(c); \
> >> >                rcu_dereference_raw(p); \
> >> >        })
> >> >
> >> > @@ -237,8 +245,7 @@ static inline int rcu_read_lock_sched_held(void)
> >> >  */
> >> >  #define rcu_dereference_protected(p, c) \
> >> >        ({ \
> >> > -               if (debug_lockdep_rcu_enabled() && !(c)) \
> >> > -                       lockdep_rcu_dereference(__FILE__, __LINE__); \
> >> > +               __do_rcu_dereference_check(c); \
> >> >                (p); \
> >> >        })
> >> >
> >> > diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> >> > index da5e139..e5c0244 100644
> >> > --- a/kernel/cgroup_freezer.c
> >> > +++ b/kernel/cgroup_freezer.c
> >> > @@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
> >> >         * No lock is needed, since the task isn't on tasklist yet,
> >> >         * so it can't be moved to another cgroup, which means the
> >> >         * freezer won't be removed and will be valid during this
> >> > -        * function call.
> >> > +        * function call.  Nevertheless, apply RCU read-side critical
> >> > +        * section to suppress RCU lockdep false positives.
> >> >         */
> >> > +       rcu_read_lock();
> >> >        freezer = task_freezer(task);
> >> > +       rcu_read_unlock();
> >> >
> >> >        /*
> >> >         * The root cgroup is non-freezable, so we can skip the
> >> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> >> > index 2594e1c..03dd1fa 100644
> >> > --- a/kernel/lockdep.c
> >> > +++ b/kernel/lockdep.c
> >> > @@ -3801,8 +3801,6 @@ void lockdep_rcu_dereference(const char *file, const int line)
> >> >  {
> >> >        struct task_struct *curr = current;
> >> >
> >> > -       if (!debug_locks_off())
> >> > -               return;
> >> >        printk("\n===================================================\n");
> >> >        printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
> >> >        printk(  "---------------------------------------------------\n");
> >> > diff --git a/kernel/sched.c b/kernel/sched.c
> >> > index 6af210a..14c44ec 100644
> >> > --- a/kernel/sched.c
> >> > +++ b/kernel/sched.c
> >> > @@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
> >> >  /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
> >> >  static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
> >> >  {
> >> > +       /*
> >> > +        * Strictly speaking this rcu_read_lock() is not needed since the
> >> > +        * task_group is tied to the cgroup, which in turn can never go away
> >> > +        * as long as there are tasks attached to it.
> >> > +        *
> >> > +        * However since task_group() uses task_subsys_state() which is an
> >> > +        * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
> >> > +        */
> >> > +       rcu_read_lock();
> >> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> >> >        p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
> >> >        p->se.parent = task_group(p)->se[cpu];
> >> > @@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
> >> >        p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
> >> >        p->rt.parent = task_group(p)->rt_se[cpu];
> >> >  #endif
> >> > +       rcu_read_unlock();
> >> >  }
> >> >
> >> >  #else
> >> >
> >>
> >> Hi Paul.
> >>
> >> Has this patch made it into the Linus tree?
> >> Thanks!
> >
> > Hello, Miles,
> >
> > Not yet -- working with Ingo to get a variant of it into -tip on
> > its way to Linus's tree.  The latest patch stack may be found at
> > http://lkml.org/lkml/2010/4/30/500.
> 
> What is the rationale for defaulting to showing only one RCU splat?
> That setting seems likely to reduce the rate at which things get
> cleaned up.

Hello, Miles,

The discussion is at http://lkml.org/lkml/2010/4/21/304.  It might
reduce it or even increase it.  The increase might come from people
who might disable CONFIG_PROVE_RCU completely if they kept getting
too many splats.  This way people can choose how much they want to
contribute to cleaning up.

And regardless of how this is eventually settled, let me say again
that I very much appreciate your testing efforts!!!

							Thanx, Paul
