Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1HFAVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:21:07 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7097 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757101Ab1HFAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:21:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEqIPE55LbAB/2dsb2JhbABCp2d4gUABAQU6HCMQCBsjCxQlAyETxjwOhVlfBJs2iEQ
Date: Sat, 6 Aug 2011 10:20:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: trigger_all_cpu_backtrace() has no generic implementation (was Re:
 [regression, 3.1, rcu] rcu_sched_state detected stall on CPU 8 (t=15000
 jiffies))
Message-ID: <20110806002056.GC3162@dastard>
References: <20110803022857.GH12870@dastard>
 <20110803025222.GI12870@dastard>
 <20110803063049.GD13065@linux.vnet.ibm.com>
 <20110805003316.GA3162@dastard>
 <20110805064119.GB13065@linux.vnet.ibm.com>
 <20110805084839.GB3162@dastard>
 <20110805112429.GM13065@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805112429.GM13065@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 04:24:29AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 05, 2011 at 06:48:39PM +1000, Dave Chinner wrote:
> > On Thu, Aug 04, 2011 at 11:41:19PM -0700, Paul E. McKenney wrote:
> > > On Fri, Aug 05, 2011 at 10:33:16AM +1000, Dave Chinner wrote:
> > > > On Tue, Aug 02, 2011 at 11:30:50PM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Aug 03, 2011 at 12:52:22PM +1000, Dave Chinner wrote:
> > > > > > On Wed, Aug 03, 2011 at 12:28:57PM +1000, Dave Chinner wrote:
> > > > > > > Hi Paul,
> > > > > > > 
> > > > > > > I've had this hang a couple of times now, so I figured it isn't an
> > > > > > > isolated event. I am getting kernels occassionally hanging with the
> > > > > > > following output occurring:
> > > > > > > 
> > > > > > > [   62.812011] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> > > > > > > [  242.936009] INFO: rcu_sched_state detected stall on CPU 8 (t=60031 jiffies)
> > > > 
> > > > ....
> > > > 
> > > > > > This might be a false alarm - I've just diagnosed(*) that a kernel
> > > > > > thread was stuck in a hard loop therefore not giving up the CPU.
> > > > > 
> > > > > Ah, that is indeed one of the conditions that RCU CPU stall warnings
> > > > > can catch.
> > > > > 
> > > > > > Perhaps this is error message could be more informative?
> > > > > > The detector is acting like the hung task detector, except it's
> > > > > > working on kernel code stuck in a loop burning CPU, so maybe dumping
> > > > > > a stack trace of the spinning CPU (i.e. similar to sysrq-l output)
> > > > > > might be a useful addition to tracking down such stalls?
> > > > > 
> > > > > Strange.  There is a trigger_all_cpu_backtrace() call that is supposed
> > > > > to dump all CPUs' stacks.  It has been working in the past, but you are
> > > > > the second person in a couple of weeks to report that it isn't doing
> > > > > its job.  (Though the other one was running the -rt tree.)
> > > > 
> > > > Ok, so it is supposed to be dumping the stack. Good.
> > > 
> > > Yep!
....
> > > > I'm running on x86_64 (inside a KVM VM) so it should be present.
> > > 
> > > Indeed it should!  Is NMI delivery busted or something?
> > 
> > Not that I know of.
....
> > > Just out of curiosity, what are you thinking of doing in the code to
> > > figure out that trigger_all_cpu_backtrace() didn't work and that it
> > > was time to fall back on sysrq-l-style processing?
> > 
> > -	trigger_all_cpu_backtrace();
> > +	if (!trigger_all_cpu_backtrace()) {
> > +		pr_err("trigger_all_cpu_backtrace returned false!");
> 
> So a good defensive-programming patch would be something like the
> following, right?
> 
> 	if (!trigger_all_cpu_backtrace()) {
> 		pr_err("Falling back to dump_stack()");
> 		dump_stack();
> 	}
> 
> > And I see:
> > 
> > [   90.808037] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> > [   90.808037] trigger_all_cpu_backtrace returned false
> > 
> > Which indicates that arch_trigger_all_cpu_backtrace is indeed not
> > defined, and that sysrq-l is using the fallback.
> > 
> > My .config is below if you want to look into it further.
> 
> My ability to do so is quite limited, but you do have
> CONFIG_X86_LOCAL_APIC=y.  I took a quick look but don't immediately
> see why you would not be getting the NMI variant.

It would appear to be because include/linux/nmi.h does not do
#include <asm/nmi.h> where arch_trigger_all_cpu_backtrace is
defined.

I think this is the case from looking at the build deps for
rcutree.h: I see include/linux/nmi.h but no asm/nmi.h. It appears
that asm/nmi.h is only included if this config ifdef is true:

#if defined(ARCH_HAS_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
#include <asm/nmi.h>

And my .config has:

$ grep CONFIG_HARDLOCKUP_DETECTOR .config
# CONFIG_HARDLOCKUP_DETECTOR is not set
$

And ARCH_HAS_NMI_WATCHDOG is only defined for these archs:

$ grep ARCH_HAS_NMI_WATCHDOG -r arch
arch/blackfin/include/asm/irq.h:# define ARCH_HAS_NMI_WATCHDOG
arch/mn10300/include/asm/reset-regs.h:#define ARCH_HAS_NMI_WATCHDOG /* See include/linux/nmi.h */
arch/sparc/include/asm/irq_64.h:#define ARCH_HAS_NMI_WATCHDOG
$

So unless you configure the CONFIG_HARDLOCKUP_DETECTOR into a
kernel, trigger_all_cpu_backtrace() will simply fail.

And i can't just convert this to always include asm/nmi.h, because:

$ find arch -name nmi.h
arch/blackfin/include/asm/nmi.h
arch/mips/include/asm/sn/nmi.h
arch/mn10300/include/asm/nmi.h
arch/s390/include/asm/nmi.h
arch/sparc/include/asm/nmi.h
arch/x86/include/asm/nmi.h
$

Only a few platforms actually define asm/nmi.h. The whole platform
specific trigger_all_cpu_backtrace() stuff is just broken - it's not
just platform specific, it's platform and config specific, without
having any indication that it is config specific....

Arch specific code is supposed to have a generic implementation for
platfoms that don't implement it. It's pretty clear from the
sysrq-l code that a generic implementation is possible, so I'm
wondering why trigger_all_cpu_backtrace doesn't own that generic
fallback code.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
