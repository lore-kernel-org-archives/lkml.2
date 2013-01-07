Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3AGUxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:53:14 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56371 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab3AGUxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:53:13 -0500
Date: Mon, 7 Jan 2013 12:53:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 05/14] rcu: Distinguish "rcuo" kthreads by
 RCU flavor
Message-ID: <20130107205304.GV2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1357408144-15830-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAP=VYLrCZ6qHTzA0K=+6rEGU0Lk8aLPH6MgRuw5rxSazwJai6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLrCZ6qHTzA0K=+6rEGU0Lk8aLPH6MgRuw5rxSazwJai6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010720-7182-0000-0000-0000043E08A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 06:34:17PM -0500, Paul Gortmaker wrote:
> On Sat, Jan 5, 2013 at 12:48 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> >
> > Currently, the per-no-CBs-CPU kthreads are named "rcuo" followed by
> > the CPU number, for example, "rcuo".  This is problematic given that
> > there are either two or three RCU flavors, each of which gets a per-CPU
> > kthread with exactly the same name.  This commit therefore introduces
> > a one-letter abbreviation for each RCU flavor, namely 'b' for RCU-bh,
> > 'p' for RCU-preempt, and 's' for RCU-sched.  This abbreviation use used
> > to distinguish the "rcuo" kthreads, for example, for CPU 0 we would have
> > "rcuo0b", "rcuo0p", and "rcuo0s".
> 
> Since these names are exposed to Joe Average when he runs ps/top
> etc. -- I am inclined to favour the more full names as implemented
> in this older patch:
> 
> http://goo.gl/H1Aj8
> 
> ...since "rcuo0p" isn't apt to mean anything to people outside
> of the to/cc list of this mail. (Catch me off guard, and I probably
> might fail to be able to name the three flavours myself...)
> 
> But then again it is just a personal preference.  In any case, if we stick
> with the short names in your patch,  we probably still should make the
> similar two documentation type chunks from my patch in yours.

I took yours and Josh's advice here, so the names are now rcuoX/N,
with the definitions of X and N in both the Kconfig entry and in
Documentation/kernel-parameters.txt.

							Thanx, Paul

> Paul.
> --
> 
> >
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > ---
> >  kernel/rcutree.c        |    7 ++++---
> >  kernel/rcutree.h        |    1 +
> >  kernel/rcutree_plugin.h |    5 +++--
> >  3 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 8b110fa..4ec797e 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -64,7 +64,7 @@
> >  static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
> >  static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
> >
> > -#define RCU_STATE_INITIALIZER(sname, cr) { \
> > +#define RCU_STATE_INITIALIZER(sname, sabbr, cr) { \
> >         .level = { &sname##_state.node[0] }, \
> >         .call = cr, \
> >         .fqs_state = RCU_GP_IDLE, \
> > @@ -76,13 +76,14 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
> >         .barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
> >         .onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
> >         .name = #sname, \
> > +       .abbr = sabbr, \
> >  }
> >
> >  struct rcu_state rcu_sched_state =
> > -       RCU_STATE_INITIALIZER(rcu_sched, call_rcu_sched);
> > +       RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
> >
> > -struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, call_rcu_bh);
> > +struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> >
> >  static struct rcu_state *rcu_state;
> > diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> > index ef26eab..c865117 100644
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -452,6 +452,7 @@ struct rcu_state {
> >         unsigned long gp_max;                   /* Maximum GP duration in */
> >                                                 /*  jiffies. */
> >         char *name;                             /* Name of structure. */
> > +       char abbr;                              /* Abbreviated name. */
> >         struct list_head flavors;               /* List of RCU flavors. */
> >  };
> >
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index eb9b473..ab1bdde 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -111,7 +111,7 @@ static void __init rcu_bootup_announce_oddness(void)
> >  #ifdef CONFIG_TREE_PREEMPT_RCU
> >
> >  struct rcu_state rcu_preempt_state =
> > -       RCU_STATE_INITIALIZER(rcu_preempt, call_rcu);
> > +       RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
> >  static struct rcu_state *rcu_state = &rcu_preempt_state;
> >
> > @@ -2510,7 +2510,8 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
> >                 return;
> >         for_each_cpu(cpu, rcu_nocb_mask) {
> >                 rdp = per_cpu_ptr(rsp->rda, cpu);
> > -               t = kthread_run(rcu_nocb_kthread, rdp, "rcuo%d", cpu);
> > +               t = kthread_run(rcu_nocb_kthread, rdp,
> > +                               "rcuo%d%c", cpu, rsp->abbr);
> >                 BUG_ON(IS_ERR(t));
> >                 ACCESS_ONCE(rdp->nocb_kthread) = t;
> >         }
> > --
> > 1.7.8
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

