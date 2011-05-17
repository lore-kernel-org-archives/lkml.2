Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1EQCkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:40:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48471 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1EQCkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q/ztkd4bKMnyQcBzdvHzdmwBrFHjVlDNaEodlRkpnEZdt++9kI3SgBfb6E8/it3tLn
         GyEJTQT1yXb7nV8MnsyivkZRHOZ8D5+RAMYe/wG2EQSBHxtYjoVOrQlM/BH8r55Jh62o
         d8kEXO6pe5SFSTGric+KrzB1mw1TvXf+eVOuw=
Date: Tue, 17 May 2011 04:40:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110517024000.GA5026@nowhere>
References: <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
 <20110516212449.GJ2573@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516212449.GJ2573@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:24:49PM -0700, Paul E. McKenney wrote:
> On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > In the meantime, would you be willing to try out the patch at 
> > > > https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
> > > > several configurations.
> > > 
> > > Wasn't this the one i tested - or is it a new iteration?
> > > 
> > > I'll try it in any case.
> > 
> > oh, this was a new iteration, mea culpa!
> > 
> > And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)
> 
> ;-)
> 
> Unfortunately, the only reason I can see that it works is (1) there
> is some obscure bug in my code or (2) someone somewhere is failing to
> call irq_exit() on some interrupt-exit path.  Much as I might be tempted
> to paper this one over, I believe that we do need to find whatever the
> underlying bug is.
> 
> Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
> a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
> But I couldn't see any evidence of this in my admittedly cursory scan
> of the x86 interrupt-handling code.
> 
> So until I learn differently, I am assuming that each and every
> irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
> is called after the final irq_exit() of a given burst of interrupts.
> 
> If my assumptions are mistaken, please do let me know!

So it would be nice to have a trace of the calls to rcu_irq_*() / rcu_*_nohz()
before the unpairing happened.

I have tried to reproduce it but couldn't trigger anything.

So it would be nice if Yinghai can test the patch below, since he was able
to trigger the warning.

This is essentially Paul's patch but with stacktrace of the calls recorded.
Then the whole trace is dumped on the console when one of the WARN_ON_ONCE
sanity check is positive. Beware as the trace will be dumped everytime
WARN_ON_ONCE() is positive. So the first dump is enough, you can ignore the
rest.

This requires CONFIG_TRACING. May be a good thing to boot with
"ftrace=nop" parameter, so that ftrace will set up a long enough buffer
to have an interesting trace.

PS: the first check in rcu_nmi_enter() doesn't seem to make sense.

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..a4e6d1b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -316,24 +316,23 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  * critical sections can occur in irq handlers in nohz mode, a possibility
  * handled by rcu_irq_enter() and rcu_irq_exit()).
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
+		if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+			ftrace_dump(DUMP_ORIG);
 		return;
 	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
-	local_irq_restore(flags);
-
+	if (WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1))
+		ftrace_dump(DUMP_ORIG);
 	/* If the interrupt queued a callback, get out of dyntick mode. */
 	if (in_irq() &&
 	    (__get_cpu_var(rcu_sched_data).nxtlist ||
@@ -342,28 +341,57 @@ void rcu_enter_nohz(void)
 		set_need_resched();
 }
 
+void rcu_enter_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	trace_dump_stack();
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	if (WARN_ON_ONCE(rdtp->dynticks_nesting != 1))
+		ftrace_dump(DUMP_ORIG);
+	rdtp->dynticks_nesting = 1;
+	__rcu_enter_nohz();
+	local_irq_restore(flags);
+}
+
 /*
  * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
  *
  * Exit nohz mode, in other words, -enter- the mode in which RCU
  * read-side critical sections normally occur.
  */
-void rcu_exit_nohz(void)
+void __rcu_exit_nohz(void)
 {
-	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
-	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	if (rdtp->dynticks_nesting++) {
-		local_irq_restore(flags);
+		if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+			ftrace_dump(DUMP_ORIG);
 		return;
 	}
 	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+		ftrace_dump(DUMP_ORIG);
+}
+
+void rcu_exit_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	trace_dump_stack();
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	if (WARN_ON_ONCE(rdtp->dynticks_nesting != 0))
+		ftrace_dump(DUMP_ORIG);
+	rdtp->dynticks_nesting = 0;
+	__rcu_exit_nohz();
 	local_irq_restore(flags);
 }
 
@@ -378,15 +406,21 @@ void rcu_nmi_enter(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
+	trace_dump_stack();
+
 	if (rdtp->dynticks_nmi_nesting == 0 &&
-	    (atomic_read(&rdtp->dynticks) & 0x1))
+	    (atomic_read(&rdtp->dynticks) & 0x1)) {
+		if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+			ftrace_dump(DUMP_ORIG);
 		return;
+	}
 	rdtp->dynticks_nmi_nesting++;
 	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+		ftrace_dump(DUMP_ORIG);
 }
 
 /**
@@ -400,14 +434,20 @@ void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
+	trace_dump_stack();
+
 	if (rdtp->dynticks_nmi_nesting == 0 ||
-	    --rdtp->dynticks_nmi_nesting != 0)
+	    --rdtp->dynticks_nmi_nesting != 0) {
+		if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+			ftrace_dump(DUMP_ORIG);
 		return;
+	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force delay to next write. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	if (WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1))
+		ftrace_dump(DUMP_ORIG);
 }
 
 /**
@@ -418,7 +458,12 @@ void rcu_nmi_exit(void)
  */
 void rcu_irq_enter(void)
 {
-	rcu_exit_nohz();
+	unsigned long flags;
+
+	local_irq_save(flags);
+	trace_dump_stack();
+	__rcu_exit_nohz();
+	local_irq_restore(flags);
 }
 
 /**
@@ -430,7 +475,12 @@ void rcu_irq_enter(void)
  */
 void rcu_irq_exit(void)
 {
-	rcu_enter_nohz();
+	unsigned long flags;
+
+	local_irq_save(flags);
+	trace_dump_stack();
+	__rcu_enter_nohz();
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_SMP

