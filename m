Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1ENSfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:35:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52598 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1ENSfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:35:04 -0400
Date: Sat, 14 May 2011 11:34:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110514183453.GA32756@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DCAFFD8.2080605@kernel.org>
 <4DCB157F.20202@kernel.org>
 <20110512060344.GB3191@elte.hu>
 <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com>
 <20110514142621.GB2258@linux.vnet.ibm.com>
 <20110514153118.GA24311@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514153118.GA24311@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 08:31:18AM -0700, Paul E. McKenney wrote:
> On Sat, May 14, 2011 at 07:26:21AM -0700, Paul E. McKenney wrote:
> > On Fri, May 13, 2011 at 02:08:21PM -0700, Yinghai Lu wrote:
> > > On Thu, May 12, 2011 at 2:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:

[ . . . ]

> > > so only revert  e59fb3120becfb36b22ddb8bd27d065d3cdca499 is not enough.
> > > 
> > > [  315.248277] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> > > [  315.285642] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > > [  427.405283] INFO: rcu_sched_state detected stalls on CPUs/tasks: {
> > > 0} (detected by 50, t=15002 jiffies)
> > > [  427.408267] sending NMI to all CPUs:
> > > [  427.419298] NMI backtrace for cpu 1
> > > [  427.420616] CPU 1
> > > 
> > > Paul, can you make one clean revert for
> > > | a26ac2455ffcf3be5c6ef92bc6df7182700f2114
> > > | rcu: move TREE_RCU from softirq to kthread
> > 
> > I will be continuing to look into a few things over the weekend, but
> > if I cannot find the cause, then changing back to softirq might be the
> > thing to do.  It won't be so much a revert in the "git revert" sense
> > due to later dependencies, but it could be shifted back from kthread
> > to softirq.  This would certainly decrease dependence on the scheduler,
> > at least in the common case where ksoftirqd does not run.
> 
> So, upon reviewing Yinghai's RCU debugfs output after getting a good
> night's sleep, I see that the dyntick nesting level is getting messed up.
> This is shown by the "dt=7237/73" near the end of the debugfs info of
> Yinghai's message from Tue, 10 May 2011 23:42:24 -0700.  This says that
> RCU believes that the CPU is not in dyntick-idle mode (7237 is an odd
> number) and that that there are 73 levels of not being in dyntick-idle
> mode, which means at least 72 interrupt levels.  Unless x86 interrupts
> normally nest 72 levels deep...
> 
> This situation will cause RCU to think that a given CPU is not in
> dyntick-idle mode when it really is.  This results in RCU waiting on
> it to respond, and eventually waking it up.  Which would cause needless
> grace-period delays.
> 
> Before commit e59fb31 (Decrease memory-barrier usage based on semi-formal
> proof), rcu_enter_nohz() would have unconditionally caused RCU to believe
> that the CPU was in dyntick-idle mode.  After this commit, RCU pays attention
> to the (broken) nesting count.  Though the broken nesting level probably
> caused some trouble even before this commit.
> 
> So I am restoring the old semantics where rcu_enter_nohz() unconditionally
> tells RCU that the CPU really is in nohz mode.  I am also adding
> some WARN_ON_ONCE() statements that will hopefully help find where the
> misnesting is occurring.  I will also see if I can find the mis-nesting,
> but I am not as familiar with the interrupt entry/exit code as I should
> be.  So I will create and sanity-test the patch and post it first,
> and do the inspection afterwards.

And here is a lightly-tested patch, which applies on tip/core/rcu.

This problem could account for both the long delays seen with e59fb312
(Decrease memory-barrier usage based on semi-formal proof) and the
shorter delays seen with a26ac245 (move TREE_RCU from softirq to kthread).

							Thanx, Paul

------------------------------------------------------------------------

 rcutree.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 16 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a4a2ef0..0b541bd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -308,23 +308,25 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 
 #ifdef CONFIG_NO_HZ
 
-/**
- * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+/*
+ * __rcu_enter_nohz - inform RCU that current CPU is entering nohz
  *
  * Enter nohz mode, in other words, -leave- the mode in which RCU
  * read-side critical sections can occur.  (Though RCU read-side
  * critical sections can occur in irq handlers in nohz mode, a possibility
  * handled by rcu_irq_enter() and rcu_irq_exit()).
+ *
+ * This variant should only be called from rcu_irq_exit() because it
+ * assumes perfect nesting.  The caller must have irqs disabled.
  */
-void rcu_enter_nohz(void)
+void __rcu_enter_nohz(void)
 {
-	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
-	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
+	WARN_ON_ONCE(rdtp->dynticks_nesting <= 0);
 	if (--rdtp->dynticks_nesting) {
-		local_irq_restore(flags);
+		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 		return;
 	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
@@ -332,7 +334,6 @@ void rcu_enter_nohz(void)
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
-	local_irq_restore(flags);
 
 	/* If the interrupt queued a callback, get out of dyntick mode. */
 	if (__get_cpu_var(rcu_sched_data).nxtlist ||
@@ -341,21 +342,46 @@ void rcu_enter_nohz(void)
 		set_need_resched();
 }
 
+/**
+ * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+ *
+ * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * read-side critical sections can occur.  (Though RCU read-side
+ * critical sections can occur in irq handlers in nohz mode, a possibility
+ * handled by rcu_irq_enter() and rcu_irq_exit()).
+ *
+ * Don't assume perfect nesting.  There can be retries in case
+ * of interrupts arriving during the nohz-entry process.
+ */
+void rcu_enter_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
+	rdtp->dynticks_nesting = 1;
+	__rcu_enter_nohz();
+	local_irq_restore(flags);
+}
+
 /*
- * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+ * __rcu_exit_nohz - inform RCU that current CPU is leaving nohz
  *
  * Exit nohz mode, in other words, -enter- the mode in which RCU
  * read-side critical sections normally occur.
+ *
+ * This should only be called from rcu_irq_enter() and rcu_exit_nohz()
+ * because it assumes perfect nesting.  Caller must disable irqs.
  */
-void rcu_exit_nohz(void)
+static void __rcu_exit_nohz(void)
 {
-	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
-	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	if (rdtp->dynticks_nesting++) {
-		local_irq_restore(flags);
+		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 		return;
 	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
@@ -363,6 +389,27 @@ void rcu_exit_nohz(void)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+}
+
+/**
+ * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+ *
+ * Exit nohz mode, in other words, -enter- the mode in which RCU
+ * read-side critical sections normally occur.
+ *
+ * Don't assume perfect nesting.  There can be retries in case
+ * of interrupts arriving during the nohz-entry process.
+ */
+void rcu_exit_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	WARN_ON_ONCE(rdtp->dynticks_nesting != 0);
+	rdtp->dynticks_nesting = 0;
+	__rcu_exit_nohz();
 	local_irq_restore(flags);
 }
 
@@ -378,8 +425,10 @@ void rcu_nmi_enter(void)
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
-	    (atomic_read(&rdtp->dynticks) & 0x1))
+	    (atomic_read(&rdtp->dynticks) & 0x1)) {
+		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 		return;
+	}
 	rdtp->dynticks_nmi_nesting++;
 	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
 	atomic_inc(&rdtp->dynticks);
@@ -400,8 +449,10 @@ void rcu_nmi_exit(void)
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
-	    --rdtp->dynticks_nmi_nesting != 0)
+	    --rdtp->dynticks_nmi_nesting != 0) {
+		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 		return;
+	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
@@ -417,7 +468,11 @@ void rcu_nmi_exit(void)
  */
 void rcu_irq_enter(void)
 {
-	rcu_exit_nohz();
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__rcu_exit_nohz();
+	local_irq_restore(flags);
 }
 
 /**
@@ -429,7 +484,11 @@ void rcu_irq_enter(void)
  */
 void rcu_irq_exit(void)
 {
-	rcu_enter_nohz();
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__rcu_enter_nohz();
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_SMP
