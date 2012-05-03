Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2ECCqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 22:46:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2ECCqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 22:46:10 -0400
Date: Wed, 2 May 2012 22:45:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "Peter Zijlstra (peterz@infradead.org)" <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ
 with NMI fallback
Message-ID: <20120503024559.GP32472@redhat.com>
References: <1333052651-8200-1-git-send-email-dzickus@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2E4D3186D3@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2E4D3186D3@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:42:51PM -0400, Seiji Aguchi wrote:
> Hi,
> 
> I tested this patch by applying to -tip tree on 4cpu machine.
> 
> In a case where one cpu panics while external interrupt is disable in other cpus, 
> WARN_ON in native_smp_send_reschedule() hits.
> The problem is the same as follows which happened in reboot case.
> 
> https://lkml.org/lkml/2012/4/5/308
> 
> I personally think that reasonable solution is just skipping WARN_ON in reboot and panic case
> By adding "PANIC" state in system_state.
> 
> This issue has not solved since it was initially reported in February.
> A band-aid patch is better than doing nothing.
> 
> What do you think?

I don't think Peter would let that patch in.  I just haven't had time to
explore the alternatives.  But that issue isn't really related to what the
attached patch is about.

Cheers,
Don

> 
> Seiji
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Don Zickus
> > Sent: Thursday, March 29, 2012 4:24 PM
> > To: x86@kernel.org
> > Cc: LKML; Peter Zijlstra; Don Zickus
> > Subject: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ with NMI fallback
> > 
> > For v3.3, I added code to use the NMI to stop other cpus in the panic case.  The idea was to make sure all cpus on the system were
> > definitely halted to help serialize the panic path to execute the rest of the code on a single cpu.
> > 
> > The main problem it was trying to solve was how to stop a cpu that was spinning with its irqs disabled.  A IPI irq would be stuck and
> > couldn't get in there, but an NMI could.
> > 
> > Things were great until we had another conversation about some pstore changes.  Because some of the backend pstore still uses
> > spinlocks to protect the device access, things could get ugly if a panic happened and we were stuck spinning on a lock.
> > 
> > Now with the NMI shutting down cpus, we could assume no other cpus were running and just bust the spin lock and proceed.
> > 
> > The counter argument was, well if you do that the backend could be in a screwed up state and you might not be able to save anything
> > as a result.
> > If we could have just given the cpu a little more time to finish things, we could have grabbed the spin lock cleanly and everything
> > would have been fine.
> > 
> > Well, how do give a cpu a 'little more time' in the panic case?  For the most part you can't without spinning on the lock and even in that
> > case, how long do you spin for?
> > 
> > So instead of making it ugly in the pstore code, I had the idea that most spin locks are held with irqs disabled, naturally blocking other
> > irqs until they are done.  We just need an irq to sit there and grab the cpu once the lock is released and irqs are re-enabled again.
> > 
> > I decided to modify stop_other_cpus to go back to the REBOOT_IRQ code and use that IPI irq as the blocking irq.  This code has been
> > working for a long time and will give up after one second.  To fix the original problem of what happens after one second if a cpu hasn't
> > accepted the IPI, I just added the NMI hammer to clobber the cpu.
> > 
> > The end result of this more complicated-looking-diff-than-it-really-is, is a patch that mostly reverts
> > 
> > 3603a25 x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
> > 
> > and instead just sticks another if-case after the REBOOT_IRQ and checks to see if online_cpus are still > 1, and if so, clobber the rest of
> > the cpus with an NMI.
> > 
> > For the most part, the NMI piece will never get hit, thus behaving just like
> > pre-v3.3 code.  However, in those rare conditions, we have a fallback plan.
> > 
> > I still wrap the NMI check with the knob 'nonmi_ipi' in case someone still has issues with NMIs in the panic path.
> > 
> > I also reset the original names of the functions.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> > 
> > There was some discussion on this earlier about how it was causing a scheduler WARN with the original NMI implementation of this
> > patch.  However, that is due to the way the cpu is being shutdown without communicating that information to the scheduler.
> > As a result during shutdown of the cpus the scheduler may reschedule a process onto a cpu that suddenly went away and spit out a
> > WARN().
> > 
> > That is a separate problem then what I am trying to solve here.  I hacked up patch to solve that problem but it doesn't seem to work
> > reliably yet so I haven't posted it yet.
> > 
> >  arch/x86/kernel/smp.c |  100 ++++++++++++++++++++++--------------------------
> >  1 files changed, 46 insertions(+), 54 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c index 66c74f4..48d2b7d 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -109,6 +109,9 @@
> >   *	about nothing of note with C stepping upwards.
> >   */
> > 
> > +static atomic_t stopping_cpu = ATOMIC_INIT(-1); static bool
> > +smp_no_nmi_ipi = false;
> > +
> >  /*
> >   * this function sends a 'reschedule' IPI to another CPU.
> >   * it goes straight through and wastes no time serializing @@ -149,8 +152,6 @@ void native_send_call_func_ipi(const struct cpumask
> > *mask)
> >  	free_cpumask_var(allbutself);
> >  }
> > 
> > -static atomic_t stopping_cpu = ATOMIC_INIT(-1);
> > -
> >  static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)  {
> >  	/* We are registered on stopping cpu too, avoid spurious NMI */ @@ -162,7 +163,19 @@ static int
> > smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
> >  	return NMI_HANDLED;
> >  }
> > 
> > -static void native_nmi_stop_other_cpus(int wait)
> > +/*
> > + * this function calls the 'stop' function on all other CPUs in the system.
> > + */
> > +
> > +asmlinkage void smp_reboot_interrupt(void) {
> > +	ack_APIC_irq();
> > +	irq_enter();
> > +	stop_this_cpu(NULL);
> > +	irq_exit();
> > +}
> > +
> > +static void native_stop_other_cpus(int wait)
> >  {
> >  	unsigned long flags;
> >  	unsigned long timeout;
> > @@ -174,20 +187,25 @@ static void native_nmi_stop_other_cpus(int wait)
> >  	 * Use an own vector here because smp_call_function
> >  	 * does lots of things not suitable in a panic situation.
> >  	 */
> > +
> > +	/*
> > +	 * We start by using the REBOOT_VECTOR irq.
> > +	 * The irq is treated as a sync point to allow critical
> > +	 * regions of code on other cpus to release their spin locks
> > +	 * and re-enable irqs.  Jumping straight to an NMI might
> > +	 * accidentally cause deadlocks with further shutdown/panic
> > +	 * code.  By syncing, we give the cpus up to one second to
> > +	 * finish their work before we force them off with the NMI.
> > +	 */
> >  	if (num_online_cpus() > 1) {
> >  		/* did someone beat us here? */
> >  		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
> >  			return;
> > 
> > -		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> > -					 NMI_FLAG_FIRST, "smp_stop"))
> > -			/* Note: we ignore failures here */
> > -			return;
> > -
> > -		/* sync above data before sending NMI */
> > +		/* sync above data before sending IRQ */
> >  		wmb();
> > 
> > -		apic->send_IPI_allbutself(NMI_VECTOR);
> > +		apic->send_IPI_allbutself(REBOOT_VECTOR);
> > 
> >  		/*
> >  		 * Don't wait longer than a second if the caller @@ -197,63 +215,37 @@ static void native_nmi_stop_other_cpus(int
> > wait)
> >  		while (num_online_cpus() > 1 && (wait || timeout--))
> >  			udelay(1);
> >  	}
> > +
> > +	/* if the REBOOT_VECTOR didn't work, try with the NMI */
> > +	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
> > +		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> > +					 NMI_FLAG_FIRST, "smp_stop"))
> > +			/* Note: we ignore failures here */
> > +			/* Hope the REBOOT_IRQ is good enough */
> > +			goto finish;
> > 
> > -	local_irq_save(flags);
> > -	disable_local_APIC();
> > -	local_irq_restore(flags);
> > -}
> > -
> > -/*
> > - * this function calls the 'stop' function on all other CPUs in the system.
> > - */
> > -
> > -asmlinkage void smp_reboot_interrupt(void) -{
> > -	ack_APIC_irq();
> > -	irq_enter();
> > -	stop_this_cpu(NULL);
> > -	irq_exit();
> > -}
> > -
> > -static void native_irq_stop_other_cpus(int wait) -{
> > -	unsigned long flags;
> > -	unsigned long timeout;
> > +		/* sync above data before sending IRQ */
> > +		wmb();
> > 
> > -	if (reboot_force)
> > -		return;
> > +		pr_emerg("Shutting down cpus with NMI\n");
> > 
> > -	/*
> > -	 * Use an own vector here because smp_call_function
> > -	 * does lots of things not suitable in a panic situation.
> > -	 * On most systems we could also use an NMI here,
> > -	 * but there are a few systems around where NMI
> > -	 * is problematic so stay with an non NMI for now
> > -	 * (this implies we cannot stop CPUs spinning with irq off
> > -	 * currently)
> > -	 */
> > -	if (num_online_cpus() > 1) {
> > -		apic->send_IPI_allbutself(REBOOT_VECTOR);
> > +		apic->send_IPI_allbutself(NMI_VECTOR);
> > 
> >  		/*
> > -		 * Don't wait longer than a second if the caller
> > +		 * Don't wait longer than a 10 ms if the caller
> >  		 * didn't ask us to wait.
> >  		 */
> > -		timeout = USEC_PER_SEC;
> > +		timeout = USEC_PER_MSEC * 10;
> >  		while (num_online_cpus() > 1 && (wait || timeout--))
> >  			udelay(1);
> >  	}
> > 
> > +finish:
> >  	local_irq_save(flags);
> >  	disable_local_APIC();
> >  	local_irq_restore(flags);
> >  }
> > 
> > -static void native_smp_disable_nmi_ipi(void) -{
> > -	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
> > -}
> > -
> >  /*
> >   * Reschedule call back.
> >   */
> > @@ -287,8 +279,8 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
> > 
> >  static int __init nonmi_ipi_setup(char *str)  {
> > -        native_smp_disable_nmi_ipi();
> > -        return 1;
> > +	smp_no_nmi_ipi = true;
> > +	return 1;
> >  }
> > 
> >  __setup("nonmi_ipi", nonmi_ipi_setup);
> > @@ -298,7 +290,7 @@ struct smp_ops smp_ops = {
> >  	.smp_prepare_cpus	= native_smp_prepare_cpus,
> >  	.smp_cpus_done		= native_smp_cpus_done,
> > 
> > -	.stop_other_cpus	= native_nmi_stop_other_cpus,
> > +	.stop_other_cpus	= native_stop_other_cpus,
> >  	.smp_send_reschedule	= native_smp_send_reschedule,
> > 
> >  	.cpu_up			= native_cpu_up,
> > --
> > 1.7.7.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More
> > majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
