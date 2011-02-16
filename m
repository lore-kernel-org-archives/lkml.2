Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab1BPJXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:23:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758807Ab1BPJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:23:11 -0500
Date: Wed, 16 Feb 2011 10:23:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/2 -tip/master] x86, x2apic: minimize IPI register writes
 using cluster groups
Message-ID: <20110216092303.GE18842@elte.hu>
References: <4D4B1835.10606@gmail.com>
 <20110214114515.GA9867@elte.hu>
 <4D5945C8.4080108@gmail.com>
 <20110215032259.GA8489@elte.hu>
 <AANLkTiknLx8-SisY6it_1YitKp-HOPAt7ch5BG4=xbv-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiknLx8-SisY6it_1YitKp-HOPAt7ch5BG4=xbv-@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 2/15/11, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >
> >> On 02/14/2011 02:45 PM, Ingo Molnar wrote:
> >> >
> >> >* Cyrill Gorcunov<gorcunov@gmail.com>  wrote:
> >> >
> >> >>In the case of x2apic cluster mode we can group IPI register writes
> >> >> based on the
> >> >>cluster group instead of individual per-cpu destiantion messages. This
> >> >> reduces the
> >> >>apic register writes and reduces the amount of IPI messages (in the best
> >> >> case we
> >> >>can reduce it by a factor of 16).
> >> >>
> >> >>With this change, microbenchmark measuring the cost of
> >> >> flush_tlb_others(), with
> >> >>the flush tlb IPI being sent from a cpu in the socket-1 to all the
> >> >> logical cpus in
> >> >>socket-2 (on a Westmere-EX system that has 20 logical cpus in a socket)
> >> >> is 3x
> >> >>times better now (compared to the former 'send one-by-one' algorithm).
> >> >
> >> >Pretty nice!
> >> >
> >> >I have a few structural and nitpicking comments:
> >>
> >> Thanks a lot for review, Ingo! I'll address all the nits during this week.
> >>
> >> ...
> >> >
> >> >>+void x2apic_init_cpu_notifier(void)
> >> >>+{
> >> >>+	int cpu = smp_processor_id();
> >> >>
> >> >>+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
> >> >>+	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
> >> >>+	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
> >> >
> >> >Such a BUG_ON() is not particularly user friendly - and this could
> >> > trigger during
> >> >CPU hotplug events, i.e. while the system is fully booted up, right?
> >> >
> >> >Thanks,
> >> >
> >> >	Ingo
> >>
> >> Yup is not that much friendly but it's called during system bootup,
> >> hotplug events are handled by
> >>
> >> +static int __cpuinit
> >> +cluster_setup(struct notifier_block *nfb, unsigned long action, void
> >> *hcpu)
> >> +{
> >> +	unsigned int cpu = (unsigned long)hcpu;
> >> +	int err = 0;
> >> +
> >> +	switch (action) {
> >> +	case CPU_UP_PREPARE:
> >> +		zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
> >> +		zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
> >> +		if (!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu)) {
> >> +			free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
> >> +			free_cpumask_var(per_cpu(ipi_mask, cpu));
> >> +			err = -ENOMEM;
> >> +		}
> >> +		break;
> >>
> >> so it returns -ENOMEM if failed. And btw just noted that we forgot to make
> >> x2apic_init_cpu_notifier being in __init section.
> >>
> >> Or I miss something?
> >
> > Is there no GFP_NOFAIL or GFP_FAIL_ON_PANIC variant that could be used the
> > 'must not
> > fail' property of the boot-time allocation?
> >
> > Thanks,
> >
> > 	Ingo
> >
> 
> If only i'm not missing something obvious we can set GFP_NOFAIL ending
> in endless loop if allocation failed (slab should be already running
> at this point of boot). Probably another option might be to switch to
> no-apic mode if there is no enough memory to allocate this masks
> (though i guess if allocation failed at this point we likely to fail
> in further allocations in kernel anyway)

Ok, if it's boot time only then it's no big deal.

Thanks,

	Ingo
