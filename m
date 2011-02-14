Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1BNLp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:45:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab1BNLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:45:26 -0500
Date: Mon, 14 Feb 2011 12:45:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/2 -tip/master] x86, x2apic: minimize IPI register writes
 using cluster groups
Message-ID: <20110214114515.GA9867@elte.hu>
References: <4D4B1835.10606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4B1835.10606@gmail.com>
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

> In the case of x2apic cluster mode we can group IPI register writes based on the 
> cluster group instead of individual per-cpu destiantion messages. This reduces the 
> apic register writes and reduces the amount of IPI messages (in the best case we 
> can reduce it by a factor of 16).
> 
> With this change, microbenchmark measuring the cost of flush_tlb_others(), with 
> the flush tlb IPI being sent from a cpu in the socket-1 to all the logical cpus in 
> socket-2 (on a Westmere-EX system that has 20 logical cpus in a socket) is 3x 
> times better now (compared to the former 'send one-by-one' algorithm).

Pretty nice!

I have a few structural and nitpicking comments:

> +++ tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
> @@ -71,7 +71,9 @@ void __init default_setup_apic_routing(v
>  #endif
> 
>  	if (apic == &apic_flat && num_possible_cpus() > 8)
> -			apic = &apic_physflat;
> +		apic = &apic_physflat;
> +	else if (apic == &apic_x2apic_cluster)
> +		x2apic_init_cpu_notifier();

This should be encapsulated cleaner - this higher layer does not care what the 
x2apic code tries to initialize.

So i think the cleanest method would be to clean up default_setup_apic_routing() and 
get rid of the CONFIG_X86_X2APIC (and UV and vsmp) mess from there.

We want some sort of proper driver init sequence between the various APIC drivers, 
which sequence the default_setup_apic_routing() code just iterates and as a result 
it gets a pointer to a 'struct apic'. This would be like all other driver init 
sequences work - no ugly 'glue' like probe_64.c would be needed.


> +static void __x2apic_send_IPI_mask(const struct cpumask *mask, int vector,
> +				   int exclude_self)

Please if possible don't break function prototypes in the middle of the argument 
list. There are more natural places to break the line:

static void
__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int exclude_self)

But it can be in a single line as well. (up to 90-100 cols is fine.)

> +{
> +	unsigned long cpu;
>  	unsigned long flags;
> +	struct cpumask *cpus_in_cluster_ptr, *ipi_mask_ptr;
> +	u32 dest, this_cpu;

Ok, this is a pet peeve of mine: look how inconsistent this variable definition 
block has become. This would be cleaner:

	struct cpumask *cpus_in_cluster_ptr, *ipi_mask_ptr;
	unsigned long cpu, flags;
	u32 dest, this_cpu;

> +	/*
> +	 * we are to modify mask, so we need an own copy
> +	 * and be sure it's manipulated with irq off
> +	 */

Most comments in this file capitalize the first word in a comment block.

(this holds for a number of similar cases as well in later portions of your patch)

> +	for_each_cpu(cpu, ipi_mask_ptr) {
> +		unsigned long i;
> +		dest = 0;

Please separate variable definitions from the first statement in a more visible manner.

> +		cpus_in_cluster_ptr = per_cpu(cpus_in_cluster, cpu);
> +
> +		/* only cpus in cluster involved */
> +		for_each_cpu_and(i, ipi_mask_ptr, cpus_in_cluster_ptr)
> +			if (!exclude_self || i != this_cpu)
> +				dest |= per_cpu(x86_cpu_to_logical_apicid, i);

Please use curly braces in blocks that are longer than a single line.

> +#define x2apic_propagate_cpu_cluster_status_online(cpu)		\
> +	x2apic_propagate_cpu_cluster_status(cpu, 1)
> +
> +#define x2apic_propagate_cpu_cluster_status_offline(cpu)	\
> +	x2apic_propagate_cpu_cluster_status(cpu, 0)

Is there any particular reason why we use preprocessor technology here, instead of 
the fine C language that .c files are generally written in?

Enumerating 0/1 symbolically would be cleaner that introducing two smaller helper 
functions in any case.

> +static int __cpuinit
> +cluster_setup(struct notifier_block *nfb, unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +	int err = 0;
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +		zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
> +		zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
> +		if (!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu)) {
> +			free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
> +			free_cpumask_var(per_cpu(ipi_mask, cpu));
> +			err = -ENOMEM;
> +		}

zalloc_cpumask_var() has a return code that could be used for a slightly more 
standard deinit/teardown sequence.

> +void x2apic_init_cpu_notifier(void)
> +{
> +	int cpu = smp_processor_id();
> 
> +	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
> +	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
> +	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));

Such a BUG_ON() is not particularly user friendly - and this could trigger during 
CPU hotplug events, i.e. while the system is fully booted up, right?

Thanks,

	Ingo
