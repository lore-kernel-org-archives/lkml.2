Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1DZFGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:06:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33716 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1DZFGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:06:16 -0400
Date: Mon, 25 Apr 2011 22:06:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110426050612.GA7651@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
 <20110422150222.GA2300@linux.vnet.ibm.com>
 <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
 <20110423210539.GI2628@linux.vnet.ibm.com>
 <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
 <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
 <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
 <20110424062728.GM2628@linux.vnet.ibm.com>
 <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
 <20110424164331.GN2628@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110424164331.GN2628@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 09:43:31AM -0700, Paul E. McKenney wrote:
> On Sun, Apr 24, 2011 at 11:36:44AM +0200, Sedat Dilek wrote:
> > On Sun, Apr 24, 2011 at 8:27 AM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> 
> [ . . . ]
> 
> > > OK, this looks unrelated, but just in case, could you please try it
> > > again with the following patch?  (Not mainlinable, debug only.)
> > >
> > > Also, it does look like you are still seeing a grace-period hang.
> > > Could you please send the output of the script?  Same one as last time.
> > >
> > >                                                        Thanx, Paul
> > >
> > > ------------------------------------------------------------------------
> > >
> > >  debugobjects.c |    8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> > > index 9d86e45..10a7c7a 100644
> > > --- a/lib/debugobjects.c
> > > +++ b/lib/debugobjects.c
> > > @@ -289,10 +289,12 @@ static void debug_object_is_on_stack(void *addr, int onstack)
> > >                return;
> > >
> > >        limit++;
> > > -       if (is_on_stack)
> > > +       if (is_on_stack) {
> > > +               struct rcu_head *p = (struct rcu_head *)addr;
> > >                printk(KERN_WARNING
> > > -                      "ODEBUG: object is on stack, but not annotated\n");
> > > -       else
> > > +                      "ODEBUG: object is on stack, but not annotated: %p\n",
> > > +                      p->func);
> > > +       } else
> > >                printk(KERN_WARNING
> > >                       "ODEBUG: object is not on stack, but annotated\n");
> > >        WARN_ON(1);
> > >
> > 
> > Somehow your attached patch was not applicable.
> > As the changes were a few lines I applied it by myself.
> > Attached are log, dmesg and patches (orig + mine)
> 
> Hmmm...  Does 0xc10231a1 correspond to a function in your build?  If so,
> could you please let me know which one?
> 
> OK, so according to "ps" the per-CPU kthread is runnable, but it appears
> to never run.  You only have one CPU, so it cannot be waiting due to
> running on the wrong CPU.  The only other loop is in wait_event(), and
> that code looks good -- besides, if wait_event() was broken, we would
> be seeing breakage everywhere.
> 
> Peter, any thoughts on what I might have done wrong to get the scheduler
> into a state where it was ignoring a runnable realtime task?

Hello, Sedat,

Here is a diagnostic patch to apply on top of sedat.2011.04.23a from
the -rcu git tree.  Could you please try it out, let me know what
happens, and run the last collectdebugfs.sh during the test?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6cf6e47..65ae701 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1524,9 +1524,9 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
 		return;
 	if (to_rt) {
 		policy = SCHED_NORMAL;
-		sp.sched_priority = RCU_KTHREAD_PRIO;
+		sp.sched_priority = 0;
 	} else {
-		policy = SCHED_FIFO;
+		policy = SCHED_NORMAL;
 		sp.sched_priority = 0;
 	}
 	sched_setscheduler_nocheck(t, policy, &sp);
@@ -1566,8 +1566,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 	sp.sched_priority = 0;
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
 	schedule();
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
 	del_timer(&yield_timer);
 }
 
@@ -1671,8 +1671,8 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
 	per_cpu(rcu_cpu_kthread_task, cpu) = t;
 	wake_up_process(t);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(t, SCHED_NORMAL, &sp);
 	return 0;
 }
 
@@ -1713,8 +1713,8 @@ static int rcu_node_kthread(void *arg)
 				continue;
 			}
 			per_cpu(rcu_cpu_has_work, cpu) = 1;
-			sp.sched_priority = RCU_KTHREAD_PRIO;
-			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+			sp.sched_priority = 0;
+			sched_setscheduler_nocheck(t, SCHED_NORMAL, &sp);
 			preempt_enable();
 		}
 	}
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a21413d..baee185 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1307,8 +1307,8 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	wake_up_process(t);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(t, SCHED_NORMAL, &sp);
 	return 0;
 }
 
