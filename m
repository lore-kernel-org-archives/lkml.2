Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1JJQEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab1JJQEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:04:09 -0400
Date: Mon, 10 Oct 2011 12:03:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com
Subject: Re: [RFC][PATCH] x86, reboot:  use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111010160341.GA5795@redhat.com>
References: <1317236148-15134-1-git-send-email-dzickus@redhat.com>
 <20111010065333.GL32173@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010065333.GL32173@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 08:53:33AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -28,6 +28,7 @@
> >  #include <asm/mmu_context.h>
> >  #include <asm/proto.h>
> >  #include <asm/apic.h>
> > +#include <asm/nmi.h>
> >  /*
> >   *	Some notes on x86 processor bugs affecting SMP operation:
> >   *
> > @@ -147,6 +148,57 @@ void native_send_call_func_ipi(const struct cpumask *mask)
> >  	free_cpumask_var(allbutself);
> >  }
> >  
> > +static int stopping_cpu;
> 
> Is access to this variable sufficiently serialized by all callpaths 
> of stop_other_cpus()?

Doesn't seem to be.  I can change this to an atomic_cmpxchg() to do that.

> 
> > +
> > +static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
> > +{
> > +	/* We are registerd on stopping cpu too, avoid spurious NMI */
> > +	if (raw_smp_processor_id() == stopping_cpu)
> > +		return NMI_HANDLED;
> > +
> > +	stop_this_cpu(NULL);
> > +
> > +	return NMI_HANDLED;
> > +}
> > +
> > +static void native_nmi_stop_other_cpus(int wait)
> > +{
> > +	unsigned long flags;
> > +	unsigned long timeout;
> > +
> > +	if (reboot_force)
> > +		return;
> > +
> > +	/*
> > +	 * Use an own vector here because smp_call_function
> > +	 * does lots of things not suitable in a panic situation.
> > +	 */
> > +	if (num_online_cpus() > 1) {
> > +		stopping_cpu = safe_smp_processor_id();
> > +
> > +		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> > +					 NMI_FLAG_FIRST, "smp_stop"))
> > +			return;		/* return what? */
> > +
> > +		/* sync above data before sending NMI */
> > +		wmb();
> > +
> > +		apic->send_IPI_allbutself(NMI_VECTOR);
> > +
> > +		/*
> > +		 * Don't wait longer than a second if the caller
> > +		 * didn't ask us to wait.
> > +		 */
> > +		timeout = USEC_PER_SEC;
> > +		while (num_online_cpus() > 1 && (wait || timeout--))
> > +			udelay(1);
> > +	}
> > +
> > +	local_irq_save(flags);
> > +	disable_local_APIC();
> > +	local_irq_restore(flags);
> > +}
> > +
> >  /*
> >   * this function calls the 'stop' function on all other CPUs in the system.
> >   */
> > @@ -159,7 +211,7 @@ asmlinkage void smp_reboot_interrupt(void)
> >  	irq_exit();
> >  }
> >  
> > -static void native_stop_other_cpus(int wait)
> > +static void native_irq_stop_other_cpus(int wait)
> >  {
> >  	unsigned long flags;
> >  	unsigned long timeout;
> > @@ -229,7 +281,7 @@ struct smp_ops smp_ops = {
> >  	.smp_prepare_cpus	= native_smp_prepare_cpus,
> >  	.smp_cpus_done		= native_smp_cpus_done,
> >  
> > -	.stop_other_cpus	= native_stop_other_cpus,
> > +	.stop_other_cpus	= native_nmi_stop_other_cpus,
> >  	.smp_send_reschedule	= native_smp_send_reschedule,
> >  
> >  	.cpu_up			= native_cpu_up,
> 
> I'd be fine about this if you also aded some sort of 
> CONFIG_KERNEL_DEBUG dependent test facility that did a "send NMI to 
> all CPUs and check that they truly arrive" non-destructive test.
> 
> That would at least give people an automatic way to test it without 
> waiting for the first crash of their kernel.

Ok fair enough.  I also wanted to keep the 'old' fucntion around to let
people add something reboot=irq on the command line to sort through those
issues too.

I'll work on the 'DEBUG' idea you suggested and repost.

Thanks,
Don
