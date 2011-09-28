Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1I1H26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:28:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53765 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753239Ab1I1H24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:28:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+yTEctjYyyLBS6gV3UaFW+Xb7r32fXM4GC6ZLjz8
	eyb/UxXpo8ufhC
Subject: Re: x86: interrupt routing question
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1310455620.4844.29.camel@marge.simson.net>
References: <1310455620.4844.29.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 09:28:52 +0200
Message-ID: <1317194932.6506.94.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the next sod who gets curious about irq routing behavior difference,
and tries to ask google.

On Tue, 2011-07-12 at 09:27 +0200, Mike Galbraith wrote:
> Greetings,
> 
> I have an x3550 M3 box which shows different behavior than my Q6600
> desktop box.  The below is the rt kernel, but it doesn't matter which
> kernel I boot, all interrupts are on CPU0 unless I move them.  On Q6600
> box, IRQs magically appear on every cpu in the affinity mask.  Change
> the eth0 mask while flood pinging, numbers start/stop changing on the
> fly.
> 
> On x3550 M3, setting eg IRQ 63's mask to '0xe' will move irq to CPU2,
> but nothing that I have found will make the thing behave the same as
> trusty old Q6600 box, which seems strange.  Is this some kind of BIOS
> thingie, or is every kernel busted on this hardware?  Busted kernel
> seems highly doubtful.

The difference is that Q6600 desktop box uses flat routing, and x3550 M3
uses physical flat.  What the heck does that mean you (didn't) ask?
Dunno, that's a "RTFM for all the gory technical details" thing, but if
you rummage around in x86 source, you'll end up here..

arch/kernel/x86/apic/io_apic.c::setup_ioapic_irq()

        if (assign_irq_vector(irq, cfg, apic->target_cpus()))
                return;

        dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());

        apic_printk(APIC_VERBOSE,KERN_DEBUG
                    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
                    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
                    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
                    irq, trigger, polarity, dest);

..and see that in physical flat mode, assign_irq_vector() scribbles only
one bit to cfg->domain.

arch/kernel/x86/apic/io_apic.c:__assign_irq_vector()

            for_each_cpu_and(cpu, mask, cpu_online_mask) {
                int new_cpu;
                int vector, offset;

                apic->vector_allocation_domain(cpu, tmp_mask);
		...
                cpumask_copy(cfg->domain, tmp_mask);
                err = 0;
                break;
        }

apic.vector_allocation_domain for physical flat is..
 
arch/x86/kernel/apic/apic_flat_64.c::

static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
{
        cpumask_clear(retmask);
        cpumask_set_cpu(cpu, retmask);
}

..whereas for flat it's..

static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
{
	...
        cpumask_clear(retmask);
        cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
}

So, while __assign_irq_vector() is called with a mask of all CPUs for
both boxen, apic->vector_allocation_domain() ensures the mask finally
written to cfg->domain has only one CPU bit set in physical flat mode,
and all CPU bits set in flat mode.

	-Mike

P.S.  if you try that RTFM thing, strap a pillow to your forehead first

