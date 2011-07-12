Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1GLPQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:16:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46594 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab1GLPQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:16:47 -0400
Date: Tue, 12 Jul 2011 08:07:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com,
        kulkarni.ravi4@gmail.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712150749.GA3198@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712144936.GD2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 07:49:36AM -0700, Paul E. McKenney wrote:
> On Tue, Jul 12, 2011 at 10:12:28AM -0400, Konrad Rzeszutek Wilk wrote:
> > > >   [<c042d0f5>] task_waking_fair+0x14  <--
> > > 
> > > Hmmm...  This is a 32-bit system, isn't it?
> > 
> > Yes. I ran this little loop:
> > 
> > #!/bin/bash
> > 
> > ID=`xl list | grep Fedora | awk '  { print $2}'`
> > 
> > rm -f cpu*.log
> > while (true) do
> > 	xl pause $ID
> > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 0 >> cpu0.log
> > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 1 >> cpu1.log
> > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 2 >> cpu2.log
> > 	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 3 >> cpu3.log
> > 	xl unpause $ID
> > done

Having just noted the "julie" above and the "julie Sullivan
<kernelmail.jms@gmail.com>" in the email address list, I suddenly suspect
that the idea here might be to use Xen to allow Julie's problem to be
more easily debugged.  If so, kudos and a big thank you!!!

And if so, could you please try out the patch below?  My earlier attempt
delayed RCU callbacks until just before the scheduler initialized itself
(which seems to have fixed the bug that Ravi Kulkarni (CCed) found), but
didn't help Julie.  This patch instead delays RCU callbacks until after
the scheduler has actually completely spawned at least one task.

This patch should apply to any recent v3.0-rc release, but of course please
let me know if it causes trouble.

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
