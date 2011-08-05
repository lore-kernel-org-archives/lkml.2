Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1HEGlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 02:41:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35233 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1HEGla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 02:41:30 -0400
Date: Thu, 4 Aug 2011 23:41:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [regression, 3.1, rcu] rcu_sched_state detected stall on CPU 8
 (t=15000 jiffies)
Message-ID: <20110805064119.GB13065@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110803022857.GH12870@dastard>
 <20110803025222.GI12870@dastard>
 <20110803063049.GD13065@linux.vnet.ibm.com>
 <20110805003316.GA3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805003316.GA3162@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 10:33:16AM +1000, Dave Chinner wrote:
> On Tue, Aug 02, 2011 at 11:30:50PM -0700, Paul E. McKenney wrote:
> > On Wed, Aug 03, 2011 at 12:52:22PM +1000, Dave Chinner wrote:
> > > On Wed, Aug 03, 2011 at 12:28:57PM +1000, Dave Chinner wrote:
> > > > Hi Paul,
> > > > 
> > > > I've had this hang a couple of times now, so I figured it isn't an
> > > > isolated event. I am getting kernels occassionally hanging with the
> > > > following output occurring:
> > > > 
> > > > [   62.812011] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> > > > [  242.936009] INFO: rcu_sched_state detected stall on CPU 8 (t=60031 jiffies)
> 
> ....
> 
> > > This might be a false alarm - I've just diagnosed(*) that a kernel
> > > thread was stuck in a hard loop therefore not giving up the CPU.
> > 
> > Ah, that is indeed one of the conditions that RCU CPU stall warnings
> > can catch.
> > 
> > > Perhaps this is error message could be more informative?
> > > The detector is acting like the hung task detector, except it's
> > > working on kernel code stuck in a loop burning CPU, so maybe dumping
> > > a stack trace of the spinning CPU (i.e. similar to sysrq-l output)
> > > might be a useful addition to tracking down such stalls?
> > 
> > Strange.  There is a trigger_all_cpu_backtrace() call that is supposed
> > to dump all CPUs' stacks.  It has been working in the past, but you are
> > the second person in a couple of weeks to report that it isn't doing
> > its job.  (Though the other one was running the -rt tree.)
> 
> Ok, so it is supposed to be dumping the stack. Good.

Yep!

> > Wait a minute...  Here is the definition:
> > 
> > 	#ifdef arch_trigger_all_cpu_backtrace
> > 	static inline bool trigger_all_cpu_backtrace(void)
> > 	{
> > 		arch_trigger_all_cpu_backtrace();
> > 
> > 		return true;
> > 	}
> > 	#else
> > 	static inline bool trigger_all_cpu_backtrace(void)
> > 	{
> > 		return false;
> > 	}
> > 	#endif
> > 
> > Passing a lower-case symbol to #ifdef is a bit of a red flag.  Where
> > is it defined?
> > 
> > o	arch/sparc/include/asm/irq_64.h:
> > 
> > 	#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> > 
> > o	arch/sparc/kernel/process_64.c:
> > 
> > 	void arch_trigger_all_cpu_backtrace(void)
> > 	{
> > 		...
> > 	}
> > 
> > o	arch/x86/include/asm/nmi.h:
> > 
> > 	#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> > 
> > o	arch/x86/kernel/apic/hw_nmi.c:
> > 
> > 	void arch_trigger_all_cpu_backtrace(void)
> > 	{
> > 		...
> > 	}
> > 
> > So I am guessing that you are running some architecture other than
> > x86 or SPARC.  And the implementation is a bit hostile on other
> > architectures.  So I suggest adding a dump_stack() before the
> > "return false" in trigger_all_cpu_backtrace(), as in the patch
> > shown below.
> 
> I'm running on x86_64 (inside a KVM VM) so it should be present.

Indeed it should!  Is NMI delivery busted or something?

In addition, how about putting a compiler error into
trigger_all_cpu_backtrace() and verifying that your build fails?  Just in
case and all that.

> Hmmm - I note that sysrq-l has a fallback implementation that uses
> smp_call_function() should trigger_all_cpu_backtrace() return false.
> I'd bet that's why sysrq-l is working and the rcu stall detection
> isn't. i.e arch_trigger_all_cpu_backtrace() is either broken or for
> some reason not compiled in. I can't tell why - I get lost in all
> the different ways that arch specific code is inlined by
> preprocessor magic...

Interesting.

> > But this is still strange.  I -know- I have seen stack dumps for
> > all CPUs when running on Power...  But the code has not changed
> > for quite some time.
> > 
> > Nevertheless, could you please try out the patch below?  It should
> > get you at least the stack dump for the current CPU, which in your
> > case was the offending CPU.
> 
> I'll give it a go, though perhaps using the same fallback as sysrq-l
> might be a better idea?

If your architecture really does believe that trigger_all_cpu_backtrace()
is available, my patch will have no effect.  Substituting dump_stack()
for trigger_all_cpu_backtrace() would be helpful.

Just out of curiosity, what are you thinking of doing in the code to
figure out that trigger_all_cpu_backtrace() didn't work and that it
was time to fall back on sysrq-l-style processing?

							Thanx, Paul
