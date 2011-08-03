Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1HCGa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:30:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57025 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1HCGax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:30:53 -0400
Date: Tue, 2 Aug 2011 23:30:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [regression, 3.1, rcu] rcu_sched_state detected stall on CPU 8
 (t=15000 jiffies)
Message-ID: <20110803063049.GD13065@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110803022857.GH12870@dastard>
 <20110803025222.GI12870@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803025222.GI12870@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:52:22PM +1000, Dave Chinner wrote:
> On Wed, Aug 03, 2011 at 12:28:57PM +1000, Dave Chinner wrote:
> > Hi Paul,
> > 
> > I've had this hang a couple of times now, so I figured it isn't an
> > isolated event. I am getting kernels occassionally hanging with the
> > following output occurring:
> > 
> > [   62.812011] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> > [  242.936009] INFO: rcu_sched_state detected stall on CPU 8 (t=60031 jiffies)
> > 
> > And that just goes on until I reboot the machine. e.g. from a test
> > run on a 2p VM that I didn't check on over the weekend:
> > 
> > [220167.108005] INFO: rcu_sched_state detected stall on CPU 0 (t=54681420 jiffies)
> > [220347.228004] INFO: rcu_sched_state detected stall on CPU 0 (t=54726450 jiffies)
> > [220527.348003] INFO: rcu_sched_state detected stall on CPU 0 (t=54771480 jiffies)
> > [220707.468006] INFO: rcu_sched_state detected stall on CPU 0 (t=54816510 jiffies)
> > [220887.588003] INFO: rcu_sched_state detected stall on CPU 0 (t=54861540 jiffies)
> > [221067.708003] INFO: rcu_sched_state detected stall on CPU 0 (t=54906570 jiffies)
> > [221247.828004] INFO: rcu_sched_state detected stall on CPU 0 (t=54951600 jiffies)
> > [221427.948003] INFO: rcu_sched_state detected stall on CPU 0 (t=54996630 jiffies)
> > [221608.068003] INFO: rcu_sched_state detected stall on CPU 0 (t=55041660 jiffies)
> > [221788.188019] INFO: rcu_sched_state detected stall on CPU 0 (t=55086690 jiffies)
> > [221968.308014] INFO: rcu_sched_state detected stall on CPU 0 (t=55131720 jiffies)
> > [222148.428010] INFO: rcu_sched_state detected stall on CPU 0 (t=55176750 jiffies)
> > 
> > I've seen it on 2p and now a 16p test VM. This one occurred
> > during boot of the 16p VM:
> > 
> > [    2.600499] kjournald starting.  Commit interval 5 seconds
> > [    2.600878] EXT3-fs (sda1): mounted filesystem with ordered data mode
> > [    2.600995] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> > [    2.612351] Freeing unused kernel memory: 2824k freed
> > INIT: version 2.88 booting
> > Using makefile-style concurrent boot in runlevel S.
> > [   62.812011] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> > [  242.936009] INFO: rcu_sched_state detected stall on CPU 8 (t=60031 jiffies)
> > 
> > While the console still echos characters, the boot process is
> > not making progress.
> > 
> > I've had this happen under heavy CPU and IO load, sometimes hours
> > after boot e.g. one was mid-way through a 4th run of xfstests which
> > takes about 80mins to do a complete run. There doesn't appear to be
> > any pattern to when it occurs and I cannot reproduce it on command,
> > so tracking it down might be difficult.
> 
> This might be a false alarm - I've just diagnosed(*) that a kernel
> thread was stuck in a hard loop therefore not giving up the CPU.

Ah, that is indeed one of the conditions that RCU CPU stall warnings
can catch.

> Perhaps this is error message could be more informative?
> The detector is acting like the hung task detector, except it's
> working on kernel code stuck in a loop burning CPU, so maybe dumping
> a stack trace of the spinning CPU (i.e. similar to sysrq-l output)
> might be a useful addition to tracking down such stalls?

Strange.  There is a trigger_all_cpu_backtrace() call that is supposed
to dump all CPUs' stacks.  It has been working in the past, but you are
the second person in a couple of weeks to report that it isn't doing
its job.  (Though the other one was running the -rt tree.)

Wait a minute...  Here is the definition:

	#ifdef arch_trigger_all_cpu_backtrace
	static inline bool trigger_all_cpu_backtrace(void)
	{
		arch_trigger_all_cpu_backtrace();

		return true;
	}
	#else
	static inline bool trigger_all_cpu_backtrace(void)
	{
		return false;
	}
	#endif

Passing a lower-case symbol to #ifdef is a bit of a red flag.  Where
is it defined?

o	arch/sparc/include/asm/irq_64.h:

	#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace

o	arch/sparc/kernel/process_64.c:

	void arch_trigger_all_cpu_backtrace(void)
	{
		...
	}

o	arch/x86/include/asm/nmi.h:

	#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace

o	arch/x86/kernel/apic/hw_nmi.c:

	void arch_trigger_all_cpu_backtrace(void)
	{
		...
	}

So I am guessing that you are running some architecture other than
x86 or SPARC.  And the implementation is a bit hostile on other
architectures.  So I suggest adding a dump_stack() before the
"return false" in trigger_all_cpu_backtrace(), as in the patch
shown below.

But this is still strange.  I -know- I have seen stack dumps for
all CPUs when running on Power...  But the code has not changed
for quite some time.

Nevertheless, could you please try out the patch below?  It should
get you at least the stack dump for the current CPU, which in your
case was the offending CPU.

						Thanx, Paul

> Cheers,
> 
> Dave.
> 
> (*) luckily the kernel was still responding to the kvm sendkey
> command so I could get at sysrq dumps to the console...
> -- 
> Dave Chinner
> david@fromorbit.com

------------------------------------------------------------------------

 rcutree.c |    4 ++--
 rcutree.h |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4a83990..ef49749 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -600,7 +600,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	}
 	printk("} (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
-	trigger_all_cpu_backtrace();
+	rcu_trigger_all_cpu_backtrace();
 
 	/* If so configured, complain about tasks blocking the grace period. */
 
@@ -621,7 +621,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 */
 	printk(KERN_ERR "INFO: %s detected stall on CPU %d (t=%lu jiffies)\n",
 	       rsp->name, smp_processor_id(), jiffies - rsp->gp_start);
-	trigger_all_cpu_backtrace();
+	rcu_trigger_all_cpu_backtrace();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 51638b6..f7de88c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -425,6 +425,12 @@ DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DECLARE_PER_CPU(char, rcu_cpu_has_work);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
+#ifdef arch_trigger_all_cpu_backtrace
+#define rcu_trigger_all_cpu_backtrace trigger_all_cpu_backtrace
+#else /* #ifdef arch_trigger_all_cpu_backtrace */
+#define rcu_trigger_all_cpu_backtrace dump_stack
+#endif /* #else #ifdef arch_trigger_all_cpu_backtrace */
+
 #ifndef RCU_TREE_NONCORE
 
 /* Forward declarations for rcutree_plugin.h */
