Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1E1GiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 02:38:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54111 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1E1GiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 02:38:17 -0400
Date: Fri, 27 May 2011 23:38:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110528063814.GA2668@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110525045253.GB2262@linux.vnet.ibm.com>
 <4DDD7F96.3090408@kernel.org>
 <20110525223437.GO2341@linux.vnet.ibm.com>
 <4DDD8775.1000501@kernel.org>
 <20110526011310.GP2341@linux.vnet.ibm.com>
 <20110526013029.GA28103@linux.vnet.ibm.com>
 <BANLkTinC2q6Fjf7=2GZoJ=+c+fzpdwAvuQ@mail.gmail.com>
 <20110526162802.GC2386@linux.vnet.ibm.com>
 <20110528010448.GA21955@linux.vnet.ibm.com>
 <4DE07413.5050408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE07413.5050408@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 09:03:31PM -0700, Yinghai Lu wrote:
> On 05/27/2011 06:04 PM, Paul E. McKenney wrote:
> > 
> > And, after having repeatedly shot myself in the foot trying to make
> > an all-singing all-dancing RCU grace-period latency measurement tool,
> > I fell back to simply measuring the RCU grace-period latency during
> > the time that memory_dev_init() is running.  This assumes that the
> > grace periods are started using synchronize_rcu() -- if they are instead
> > being started using call_rcu(), I can adapt to that as well.
> > 
> [   31.635137] cpu_dev_init done
> [   31.635320] Starting RCU latency diagnostics
> [   71.605662] Ending RCU latency diagnostics
> [   71.605924] memory_dev_init done

Thank you!  Strange...

Could you please try the following, which replaces the previous
patch?

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
index 8b4b3da..49c254b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -889,6 +889,22 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
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
 /*
  * Report a full set of quiescent states to the specified rcu_state
  * data structure.  This involves cleaning up after the prior grace
@@ -909,6 +925,9 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	 */
 	smp_mb(); /* See above block comment. */
 	gp_duration = jiffies - rsp->gp_start;
+	if (ACCESS_ONCE(trace_rcu_gp_latency))
+		printk(KERN_ALERT
+		       "Grace period duration %lu jiffies\n", gp_duration);
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
@@ -1803,7 +1822,10 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
+	static int i;
 
+	if (ACCESS_ONCE(trace_rcu_gp_latency) && i++ < 10)
+		dump_stack();
 	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
@@ -1908,10 +1930,13 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
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
@@ -1919,6 +1944,14 @@ void synchronize_sched(void)
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
 
