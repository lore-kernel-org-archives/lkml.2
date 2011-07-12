Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1GLUq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:46:29 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52300 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab1GLUq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:46:28 -0400
Date: Tue, 12 Jul 2011 13:46:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712204620.GL2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
 <20110712180151.GA18257@dumpdata.com>
 <20110712185907.GJ2326@linux.vnet.ibm.com>
 <1310497836.14978.34.camel@twins>
 <20110712195731.GB20811@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712195731.GB20811@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 03:57:32PM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 12, 2011 at 09:10:36PM +0200, Peter Zijlstra wrote:
> > On Tue, 2011-07-12 at 11:59 -0700, Paul E. McKenney wrote:
> > > OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
> > > are deferred until after the scheduler is fully initialized.  Sounds like
> > > one for the scheduler guys.  ;-) 
> > 
> > https://lkml.org/lkml/2011/7/12/150
> 
> Such a simple patch. And yes, it fixes the issue. You can add
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> if it hasn't yet
> showed up in Ingo's tree.
> 
> Paul, thanks for help on this and providing ideas to test!

Konrad, thank you for all the testing!

Julie, if you apply Peter's patch, do you also need the patch shown
below?

Ravi, could you please retest with the patch below as well?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7e59ffb..ba06207 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,9 +84,32 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 static struct rcu_state *rcu_state;
 
+/*
+ * The rcu_scheduler_active variable transitions from zero to one just
+ * before the first task is spawned.  So when this variable is zero, RCU
+ * can assume that there is but one task, allowing RCU to (for example)
+ * optimized synchronize_sched() to a simple barrier().  When this variable
+ * is one, RCU must actually do all the hard work required to detect real
+ * grace periods.  This variable is also used to suppress boot-time false
+ * positives from lockdep-RCU error checking.
+ */
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+/*
+ * The rcu_scheduler_fully_active variable transitions from zero to one
+ * during the early_initcall() processing, which is after the scheduler
+ * is capable of creating new tasks.  So RCU processing (for example,
+ * creating tasks for RCU priority boosting) must be delayed until after
+ * rcu_scheduler_fully_active transitions from zero to one.  We also
+ * currently delay invocation of any RCU callbacks until after this point.
+ *
+ * It might later prove better for people registering RCU callbacks during
+ * early boot to take responsibility for these callbacks, but one step at
+ * a time.
+ */
+static int rcu_scheduler_fully_active __read_mostly;
+
 #ifdef CONFIG_RCU_BOOST
 
 /*
@@ -98,7 +121,6 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
-static char rcu_kthreads_spawnable;
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
@@ -1467,6 +1489,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  */
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
+	if (unlikely(!ACCESS_ONCE(rcu_scheduler_fully_active)))
+		return;
 	if (likely(!rsp->boost)) {
 		rcu_do_batch(rsp, rdp);
 		return;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 14dc7dd..75113cb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1532,7 +1532,7 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	struct sched_param sp;
 	struct task_struct *t;
 
-	if (!rcu_kthreads_spawnable ||
+	if (!rcu_scheduler_fully_active ||
 	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
 		return 0;
 	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
@@ -1639,7 +1639,7 @@ static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 	struct sched_param sp;
 	struct task_struct *t;
 
-	if (!rcu_kthreads_spawnable ||
+	if (!rcu_scheduler_fully_active ||
 	    rnp->qsmaskinit == 0)
 		return 0;
 	if (rnp->node_kthread_task == NULL) {
@@ -1665,7 +1665,7 @@ static int __init rcu_spawn_kthreads(void)
 	int cpu;
 	struct rcu_node *rnp;
 
-	rcu_kthreads_spawnable = 1;
+	rcu_scheduler_fully_active = 1;
 	for_each_possible_cpu(cpu) {
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 		if (cpu_online(cpu))
@@ -1687,7 +1687,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_kthreads_spawnable) {
+	if (rcu_scheduler_fully_active) {
 		(void)rcu_spawn_one_cpu_kthread(cpu);
 		if (rnp->node_kthread_task == NULL)
 			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
@@ -1726,6 +1726,13 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
 {
 }
 
+static int __init rcu_scheduler_really_started(void)
+{
+	rcu_scheduler_fully_active = 1;
+	return 0;
+}
+early_initcall(rcu_scheduler_really_started);
+
 static void __cpuinit rcu_prepare_kthreads(int cpu)
 {
 }
