Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2EUOsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab2EUOsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:48:36 -0400
Date: Mon, 21 May 2012 16:48:13 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521124025.GC17065@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 02:40:26PM +0200, Ingo Molnar wrote:
> But that is not 'perfectly balanced' in many cases.
> 
> When the hardware round-robins the interrupts then each 
> interrupt will go to a 'cache cold' CPU in essence. This is 
> pretty much the worst thing possible thing to do in most cases: 
> while it's "perfectly balanced" in the sense of distributing 
> cycles evenly between CPUs, each interrupt handler execution 
> will generate an avalance of cachemisses, for cachelines there 
> were modified in the previous invocation of the irq.

Absolutely.

There are at least two more offenders :) exercising lowest priority + logical
addressing similarly. So in this regard the patch is nothing new:


static inline unsigned int
default_cpu_mask_to_apicid(const struct cpumask *cpumask)
{
	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
}

static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
{
	unsigned int round = 0;
	int cpu, apicid = 0;

	/*
	 * The cpus in the mask must all be on the apic cluster.
	 */
	for_each_cpu(cpu, cpumask) {
		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);

		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
			printk("%s: Not a valid mask!\n", __func__);
			return BAD_APICID;
		}
		apicid |= new_apicid;
		round++;
	}
	return apicid;
}

> One notable exception is when the CPUs are SMT/Hyperthreading 
> siblings, in that case they are sharing even the L1 cache, so 
> there's very little cost to round-robining the IRQs within the 
> CPU mask.
> 
> But AFAICS irqbalanced will spread irqs on wider masks than SMT 
> sibling boundaries, exposing us to the above performance 
> problem.

I would speculate it is irqbalanced who should be (in case of x86) cluster-
agnostic and ask for a mask while the apic layer is just execute or at least
report what was set. But that is a different topic.

Considering a bigger picture, it appears strange to me that apic is the layer
to take decision whether to make CPU a target or not. It is especially true
when one means a particluar cpumask, wants it to be set, but still is not able
to do that due to the current limitation.

> So I think we need to tread carefully here.

Kernel parameter? IRQ line flag? Totally opposed? :)

> Thanks,

> 
> 	Ingo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
