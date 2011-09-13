Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1IMMC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:02:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44524 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750815Ab1IMMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:02:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19omwQyBSVoJ5FgB3a4l0VTjwf+6mSSqnKYAwTN3c
	hwsq5mXCJaEkDD
Subject: Re: [PATCH tip/core/rcu 44/55] rcu: wire up RCU_BOOST_PRIO for
 rcutree
From: Mike Galbraith <efault@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
In-Reply-To: <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
	 <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 14:02:14 +0200
Message-ID: <1315915334.6300.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

This patch causes RCU thread priority funnies, with some help from rcun.

On Tue, 2011-09-06 at 11:00 -0700, Paul E. McKenney wrote:
> 	return 0;
> @@ -1466,6 +1474,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
>  {
>  	struct sched_param sp;
>  	struct timer_list yield_timer;
> +	int prio = current->normal_prio;
>  
>  	setup_timer_on_stack(&yield_timer, f, arg);
>  	mod_timer(&yield_timer, jiffies + 2);

There's a thinko there, prio either needs to be inverted before feeding
it to __setscheduler().. or just use ->rt_priority.  I did the latter,
and twiddled rcun to restore it's priority instead of RCU_KTHREAD_PRIO.
RCU threads now stay put.

rcu: wire up RCU_BOOST_PRIO for rcutree

RCU boost threads start life at RCU_BOOST_PRIO, while others remain at
RCU_KTHREAD_PRIO.  Adjust rcu_yield() to preserve priority across the
yield, and if the node thread restores RT policy for a yielding thread,
it sets priority to it's own priority.  This sets the stage for user
controlled runtime changes to priority in the -rt tree.

While here, change thread names to match other kthreads.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/rcutree.c        |    2 --
 kernel/rcutree_plugin.h |   22 ++++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

Index: linux-3.0-tip/kernel/rcutree.c
===================================================================
--- linux-3.0-tip.orig/kernel/rcutree.c
+++ linux-3.0-tip/kernel/rcutree.c
@@ -128,8 +128,6 @@ static void rcu_node_kthread_setaffinity
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
-#define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
-
 /*
  * Track the rcutorture test sequence number and the update version
  * number within a given test.  The rcutorture_testseq is incremented
Index: linux-3.0-tip/kernel/rcutree_plugin.h
===================================================================
--- linux-3.0-tip.orig/kernel/rcutree_plugin.h
+++ linux-3.0-tip/kernel/rcutree_plugin.h
@@ -27,6 +27,14 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 
+#define RCU_KTHREAD_PRIO 1
+
+#ifdef CONFIG_RCU_BOOST
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+#else
+#define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
+#endif
+
 /*
  * Check the RCU kernel configuration parameters and print informative
  * messages about anything out of the ordinary.  If you like #ifdef, you
@@ -1345,13 +1353,13 @@ static int __cpuinit rcu_spawn_one_boost
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
 	t = kthread_create(rcu_boost_kthread, (void *)rnp,
-			   "rcub%d", rnp_index);
+			   "rcub/%d", rnp_index);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sp.sched_priority = RCU_BOOST_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
@@ -1446,6 +1454,7 @@ static void rcu_yield(void (*f)(unsigned
 {
 	struct sched_param sp;
 	struct timer_list yield_timer;
+	int prio = current->rt_priority;
 
 	setup_timer_on_stack(&yield_timer, f, arg);
 	mod_timer(&yield_timer, jiffies + 2);
@@ -1453,7 +1462,8 @@ static void rcu_yield(void (*f)(unsigned
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
 	set_user_nice(current, 19);
 	schedule();
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	set_user_nice(current, 0);
+	sp.sched_priority = prio;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 	del_timer(&yield_timer);
 }
@@ -1562,7 +1572,7 @@ static int __cpuinit rcu_spawn_one_cpu_k
 	if (!rcu_scheduler_fully_active ||
 	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
 		return 0;
-	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc/%d", cpu);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	if (cpu_online(cpu))
@@ -1608,7 +1618,7 @@ static int rcu_node_kthread(void *arg)
 				continue;
 			}
 			per_cpu(rcu_cpu_has_work, cpu) = 1;
-			sp.sched_priority = RCU_KTHREAD_PRIO;
+			sp.sched_priority = current->rt_priority;
 			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 			preempt_enable();
 		}
@@ -1671,7 +1681,7 @@ static int __cpuinit rcu_spawn_one_node_
 		return 0;
 	if (rnp->node_kthread_task == NULL) {
 		t = kthread_create(rcu_node_kthread, (void *)rnp,
-				   "rcun%d", rnp_index);
+				   "rcun/%d", rnp_index);
 		if (IS_ERR(t))
 			return PTR_ERR(t);
 		raw_spin_lock_irqsave(&rnp->lock, flags);


