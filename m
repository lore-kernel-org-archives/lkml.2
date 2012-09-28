Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2I1M3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:29:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44874 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2I1M3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:29:01 -0400
Date: Fri, 28 Sep 2012 13:28:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>, Rob Landley <rob@landley.net>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 RESEND 2/2] ARM: local timers: add timer support
 using IO mapped register
Message-ID: <20120928122858.GD9472@e106331-lin.cambridge.arm.com>
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
 <1347694914-1457-2-git-send-email-rvaswani@codeaurora.org>
 <5062013F.8050507@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <5062013F.8050507@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Sep 2012 12:28:59.0113 (UTC) FILETIME=[D5BA3590:01CD9D74]
X-MC-Unique: 112092813285904401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 08:08:47PM +0100, Rohit Vaswani wrote:
> Any comments ?

I have a few questions about the irq side of things.

> > diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> > index 52478c8..8e01328 100644
> > --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> > +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> > @@ -7,10 +7,13 @@ The timer is attached to a GIC to deliver its per-processor interrupts.
> >
> >   ** Timer node properties:
> >
> > -- compatible : Should at least contain "arm,armv7-timer".
> > +- compatible : Should at least contain "arm,armv7-timer" or
> > +  "arm,armv7-timer-mem" if using the memory mapped arch timer interface.
> >
> > -- interrupts : Interrupt list for secure, non-secure, virtual and
> > -  hypervisor timers, in that order.
> > +- interrupts : If using the cp15 interface, the interrupt list for secure,
> > +  non-secure, virtual and hypervisor timers, in that order.
> > +  If using the memory mapped interface, list the interrupts for each core,
> > +  starting with core 0.

I take it that core 0 means physical cpu 0 (i.e. MPIDR.Aff{2,1,0} == 0)?

What privilege level are the interrupts for the memory-mapped interface?

Could each core have multiple interrupts at different privilege levels?

I also notice we don't seem to handle the case of systems without security
extensions, which only have physical and virtual interrupts. If we're adding
support for different interrupt setups, how do we handle them?

> > diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
> > index 8672a75..f79092d 100644
> > --- a/arch/arm/kernel/arch_timer.c
> > +++ b/arch/arm/kernel/arch_timer.c
> > @@ -466,11 +589,166 @@ out:
> >       return err;
> >   }
> >
> > +static int __init arch_timer_mem_register(void)
> > +{
> > +     int err, irq, i;
> > +
> > +     err = arch_timer_available();
> > +     if (err)
> > +             goto out;
> > +
> > +     arch_timer_evt = alloc_percpu(struct clock_event_device *);
> > +     if (!arch_timer_evt) {
> > +             err = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     clocksource_register_hz(&clocksource_counter, arch_timer_rate);
> > +
> > +     if (arch_timer_irq_percpu) {
> > +             for (i = 0; i < arch_timer_num_irqs; i++) {
> > +                     irq = arch_timer_mem_irqs[i];
> > +                     err = request_percpu_irq(irq, arch_timer_handler_mem,
> > +                                             "arch_timer", arch_timer_evt);
> > +             }
> > +     } else {
> > +             for (i = 0; i < arch_timer_num_irqs; i++) {
> > +                     irq = arch_timer_mem_irqs[i];
> > +                     err = request_irq(irq, arch_timer_handler_mem, 0,
> > +                                             "arch_timer",
> > +                                             per_cpu_ptr(arch_timer_evt, i));

The interrupts are listed in order of physical id in the device tree, and
you're registering them in terms of logical cpu id. The two are not necessarily
the same. You'll need some way of mapping from physical ids to logical ids
somehow (e.g.
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080872.html).
Additionally, in multi-cluster systems the set of physical ids isn't
necessarily contiguous, so you need a way of iterating over physical ids. We
have a similar issue with PMU interrupts in the perf backend; the two can
probably be solved with the same mechanism.

It seems odd to me that you're not setting the affinity of the interrupt. Does
this not matter?

> > +                     /* Disable irq now and it will be enabled later
> > +                      * in arch_timer_mem_setup which is called from
> > +                      * smp code. If we don't disable it here, then we
> > +                      * face unbalanced irq problem in arch_timer_mem_setup.
> > +                      * Percpu irqs don't have irq depth management,
> > +                      * hence they dont face this problem.
> > +                      */
> > +                     disable_irq(irq);
> > +             }
> > +     }
> > +
> > +     if (err) {
> > +             pr_err("arch_timer_mem: can't register interrupt %d (%d)\n",
> > +                    irq, err);
> > +             goto out_free;
> > +     }

This only works if the last request_irq returns an error. What if a request in
the middle of the set of irqs fails?

> > +static int __init arch_timer_mem_of_register(void)
> > +{
> > +     struct device_node *np;
> > +     u32 freq;
> > +     int i, ret, irq;
> > +     arch_timer_num_irqs = num_possible_cpus();
> > +
> > +     np = of_find_matching_node(NULL, arch_timer_mem_of_match);
> > +     if (!np) {
> > +             pr_err("arch_timer: can't find armv7-timer-mem DT node\n");
> > +             return -ENODEV;
> > +     }
> > +
> > +     arch_timer_use_virtual = false;
> > +
> > +     /* Try to determine the frequency from the device tree or CNTFRQ */
> > +     if (!of_property_read_u32(np, "clock-frequency", &freq))
> > +             arch_timer_rate = freq;
> > +
> > +     for (i = 0; i < arch_timer_num_irqs; i++) {
> > +             arch_timer_mem_irqs[i] = irq = irq_of_parse_and_map(np, i);
> > +             if (!irq)
> > +                     break;
> > +     }
> > +
> > +     if (!irq_is_per_cpu(arch_timer_ppi[0]))
> > +             arch_timer_irq_percpu = false;

Where is irq_is_per_cpu defined? I can't find it in mainline, linux-next, or
any of rmk's branches.

Also, what if an incorrect number of SPIs is registered? It'd be nice to have
some sort of warning to explain why timers on some cores won't work.

Thanks,
Mark.

