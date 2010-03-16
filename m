Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966032Ab0CPH36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:29:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab0CPH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:29:56 -0400
Date: Tue, 16 Mar 2010 08:29:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] x86: handle legacy PIC interrupts on all the cpu's
Message-ID: <20100316072947.GA18448@elte.hu>
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
 <4B9EABE8.1020203@kernel.org>
 <1268693771.3296.49.camel@sbs-t61.sc.intel.com>
 <4B9EB185.3010400@kernel.org>
 <20100316053717.GA10765@elte.hu>
 <1268722471.2948.3.camel@sbs-t61>
 <4B9F26C5.2060905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F26C5.2060905@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 03/15/2010 11:54 PM, Suresh Siddha wrote:
> > On Mon, 2010-03-15 at 22:37 -0700, Ingo Molnar wrote:
> >> * Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >>> On 03/15/2010 03:56 PM, Suresh Siddha wrote:
> >>>> On Mon, 2010-03-15 at 14:51 -0700, Yinghai Lu wrote:
> >>>>>> +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> >>>>>> +		if (!IO_APIC_IRQ(irq))
> >>>>>> +			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> >>>>>
> >>>>> seems those three lines are not needed...
> >>>>
> >>>> Those are needed for !CONFIG_X86_IO_APIC case.
> >>>>
> >>> then we can have
> >>>
> >>> +#ifndef CONFIG_X86_IO_APIC
> >>> +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> >>> +		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> >>> +#endif
> >>>
> >>> then we don't punish most setup with ioapic controller.
> >>
> >> Ok - i've simplified the code with the above and have added your Acked-by - is 
> >> that is fine by you?
> > 
> > Ingo, Probably appended one is a better version. Yinghai can you please
> > Ack if it is ok. Thanks.
> > 
> > ---
> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > Subject: x86: handle legacy PIC interrupts on all the cpu's
> > 
> > Ingo Molnar reported that with the recent changes of not statically blocking
> > IRQ0_VECTOR..IRQ15_VECTOR's on all the cpu's, broke an AMD platform
> > (with Nvidia chipset) boot when "noapic" boot option is used.
> > 
> > On this platform, legacy PIC interrupts are getting delivered to all the
> > cpu's instead of just the boot cpu. Thus not initializing the vector to irq
> > mapping for the legacy irq's resulted in not handling certain interrupts
> > causing boot hang.
> > 
> > Fix this by initializing the vector to irq mapping on all the logical cpu's,
> > if the legacy IRQ is handled by the legacy PIC.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> > 
> >  arch/x86/include/asm/hw_irq.h  |    3 +--
> >  arch/x86/kernel/apic/io_apic.c |    9 +++++++++
> >  arch/x86/kernel/irqinit.c      |   20 ++++++++++++++++++++
> >  3 files changed, 30 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> > index a929c9e..564a7a1 100644
> > --- a/arch/x86/include/asm/hw_irq.h
> > +++ b/arch/x86/include/asm/hw_irq.h
> > @@ -133,15 +133,14 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
> >  
> >  typedef int vector_irq_t[NR_VECTORS];
> >  DECLARE_PER_CPU(vector_irq_t, vector_irq);
> > +extern void __setup_vector_irq(int cpu);
> >  
> >  #ifdef CONFIG_X86_IO_APIC
> >  extern void lock_vector_lock(void);
> >  extern void unlock_vector_lock(void);
> > -extern void __setup_vector_irq(int cpu);
> >  #else
> >  static inline void lock_vector_lock(void) {}
> >  static inline void unlock_vector_lock(void) {}
> > -static inline void __setup_vector_irq(int cpu) {}
> >  #endif
> >  
> >  #endif /* !ASSEMBLY_ */
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index e4e0ddc..fd3cecd 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -1268,6 +1268,15 @@ void __setup_vector_irq(int cpu)
> >  	/* Mark the inuse vectors */
> >  	for_each_irq_desc(irq, desc) {
> >  		cfg = desc->chip_data;
> > +
> > +		/*
> > +		 * If it is a legacy IRQ handled by the legacy PIC, be ready
> > +		 * to handle it on any CPU, as the PIC interrupts are delivered
> > +		 * to multiple cpu's on some platforms.
> > +		 */
> > +		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
> > +			cpumask_set_cpu(cpu, cfg->domain);
> > +
> >  		if (!cpumask_test_cpu(cpu, cfg->domain))
> >  			continue;
> >  		vector = cfg->vector;
> > diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> > index ef257fc..afc3b31 100644
> > --- a/arch/x86/kernel/irqinit.c
> > +++ b/arch/x86/kernel/irqinit.c
> > @@ -141,6 +141,26 @@ void __init init_IRQ(void)
> >  	x86_init.irqs.intr_init();
> >  }
> >  
> > +#ifndef CONFIG_X86_IO_APIC
> > +/*
> > + * Setup the vector to irq mappings.
> > + */
> > +void __setup_vector_irq(int cpu)
> > +{
> > +	int irq;
> > +
> > +	/*
> > +	 * On most of the platforms, legacy PIC delivers the interrupts on the
> > +	 * boot cpu. But there are certain platforms where PIC interrupts are
> > +	 * delivered to multiple cpu's. For the new cpu that is coming online,
> > +	 * setup the static legacy vector to irq mapping.
> > +	 */
> > +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> > +		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> > +
> > +}
> > +#endif
> > +
> >  static void __init smp_intr_init(void)
> >  {
> >  #ifdef CONFIG_SMP
> > 
> 
> yes, less one one function prototype.
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Please submit the cleanup bit separately, we try to keep x86/urgent patches as 
small as possible.

Thanks,

	Ingo
