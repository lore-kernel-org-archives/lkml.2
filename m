Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab1E1BEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 21:04:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45996 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667Ab1E1BEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 21:04:51 -0400
Date: Fri, 27 May 2011 18:04:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110528010448.GA21955@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DDC21E1.1070502@kernel.org>
 <4DDC48E3.1060108@kernel.org>
 <20110525045253.GB2262@linux.vnet.ibm.com>
 <4DDD7F96.3090408@kernel.org>
 <20110525223437.GO2341@linux.vnet.ibm.com>
 <4DDD8775.1000501@kernel.org>
 <20110526011310.GP2341@linux.vnet.ibm.com>
 <20110526013029.GA28103@linux.vnet.ibm.com>
 <BANLkTinC2q6Fjf7=2GZoJ=+c+fzpdwAvuQ@mail.gmail.com>
 <20110526162802.GC2386@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110526162802.GC2386@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 09:28:02AM -0700, Paul E. McKenney wrote:
> On Thu, May 26, 2011 at 08:08:26AM -0700, Yinghai Lu wrote:
> > On Wed, May 25, 2011 at 6:30 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Wed, May 25, 2011 at 06:13:10PM -0700, Paul E. McKenney wrote:
> > >> On Wed, May 25, 2011 at 03:49:25PM -0700, Yinghai Lu wrote:
> > >> > On 05/25/2011 03:34 PM, Paul E. McKenney wrote:
> > >> > > On Wed, May 25, 2011 at 03:15:50PM -0700, Yinghai Lu wrote:
> > >> > >>> There is a new branch yinghai.2011.05.24a on:
> > >> > >>>
> > >> > >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > >> > >>>
> > >> > >>> Or will be as soon as kernel.org updates its mirrors.
> > >> > >>>
> > >> > >>> I am not sure I could call this "clean", but it does revert that commit
> > >> > >>> and 11 of the subsequent commits that depend on it.  It does build,
> > >> > >>> and I will test it once my currently running tests complete.
> > >> > >>
> > >> > >> yes, with those revert, there is no delay in 10 times booting.
> > >> > >
> > >> > > Unfortunately, there are rcutorture test failures with the revert...
> > >> >
> > >> > confused.
> > >>
> > >> Given what I had to do to generate the revert, not exactly a surprise,
> > >> I am afraid.  Just means that the resulting RCU sometimes fails to
> > >> wait for all pre-existing readers, and rcutorture catches it.
> > >>
> > >> > what is the next?
> > >>
> > >> 1.    I send you a patch that I hope will fix the softlockup
> > >>       you saw.  I am testing this.
> > >>
> > >> 2.    I am working on more detailed instrumentation, and will
> > >>       send a patch on that.
> > >>
> > >> 3.    If time allows, break down the operations RCU is doing
> > >>       and test them in isolation.
> > >>
> > >> Other thoughts?
> > >
> > > And here is patch #1.  Could you please try applying this on top of
> > > Peter Zijlstra's patch to see if it gets rid of the softlockups you saw?
> > >
> > >                                                        Thanx, Paul
> > >
> > > ------------------------------------------------------------------------
> > >
> > > rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state
> > >
> > > Upon creation, kthreads are in TASK_UNINTERRUPTIBLE state, which can
> > > result in softlockup warnings.  Because some of RCU's kthreads can
> > > legitimately be idle indefinitely, start them in TASK_INTERRUPTIBLE
> > > state in order to avoid those warnings.
> > 
> > Yes, it fixes the lock up warning.
> 
> Very good, I have added your Tested-by.

And, after having repeatedly shot myself in the foot trying to make
an all-singing all-dancing RCU grace-period latency measurement tool,
I fell back to simply measuring the RCU grace-period latency during
the time that memory_dev_init() is running.  This assumes that the
grace periods are started using synchronize_rcu() -- if they are instead
being started using call_rcu(), I can adapt to that as well.

Please accept my apologies for the delay...

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 3da6a43..f877cf2 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -647,6 +648,7 @@ int __init memory_dev_init(void)
 	int err;
 	unsigned long block_sz;
 
+	trace_rcu_gp_latency_start();
 	memory_sysdev_class.kset.uevent_ops = &memory_uevent_ops;
 	ret = sysdev_class_register(&memory_sysdev_class);
 	if (ret)
@@ -680,5 +682,6 @@ int __init memory_dev_init(void)
 out:
 	if (ret)
 		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
+	trace_rcu_gp_latency_stop();
 	return ret;
 }
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fb2933d..a4abf8b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -77,6 +77,8 @@ struct rcu_head {
 /* Exported common interfaces */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
+void trace_rcu_gp_latency_start(void);
+void trace_rcu_gp_latency_stop(void);
 extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 40d9ed2..58629b5 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -887,6 +887,8 @@ rcu_torture_writer(void *arg)
 			cur_ops->deferred_free(old_rp);
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
+		if (rcu_torture_current_version == 40)
+			trace_rcu_gp_latency_stop();
 		oldbatch = cur_ops->completed();
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
@@ -1432,6 +1434,7 @@ rcu_torture_init(void)
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
+	trace_rcu_gp_latency_start();
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8b4b3da..db43a3d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1882,6 +1882,22 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
+static int trace_rcu_gp_latency = 0;
+
+void trace_rcu_gp_latency_start(void)
+{
+	printk(KERN_INFO "Starting RCU latency diagnostics\n");
+	trace_rcu_gp_latency = 1;
+}
+EXPORT_SYMBOL_GPL(trace_rcu_gp_latency_start);
+
+void trace_rcu_gp_latency_stop(void)
+{
+	trace_rcu_gp_latency = 0;
+	printk(KERN_INFO "Ending RCU latency diagnostics\n");
+}
+EXPORT_SYMBOL_GPL(trace_rcu_gp_latency_stop);
+
 /**
  * synchronize_sched - wait until an rcu-sched grace period has elapsed.
  *
@@ -1908,10 +1924,13 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
 void synchronize_sched(void)
 {
 	struct rcu_synchronize rcu;
+	ktime_t start, finish;
+	static int i;
 
 	if (rcu_blocking_is_gp())
 		return;
 
+	start = ktime_get();
 	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
@@ -1919,6 +1938,14 @@ void synchronize_sched(void)
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
 	destroy_rcu_head_on_stack(&rcu.head);
+	finish = ktime_get();
+	if (ACCESS_ONCE(trace_rcu_gp_latency)) {
+		printk(KERN_ALERT
+		       "synchronize_sched() duration %d microseconds\n",
+		       (int)ktime_us_delta(finish, start));
+		if (i++ < 10)
+			dump_stack();
+	}
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
