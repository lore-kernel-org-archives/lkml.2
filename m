Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab2HHI64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:58:56 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50625
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932330Ab2HHI6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:58:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI154dM1432I4015Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M8FI9S-02-977-02
X-M-MSG: 
Date: Wed, 8 Aug 2012 10:58:37 +0200
From: Robert Richter <robert.richter@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, <mingo@kernel.org>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        <a.p.zijlstra@chello.nl>, <tglx@linutronix.de>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: do_IRQ: 1.55 No irq handler for vector (irq -1)
Message-ID: <20120808085837.GL3732@erda.amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
 <20120807153149.GI3732@erda.amd.com>
 <20120807154134.GA7456@aftab.osrc.amd.com>
 <1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com>
 <87pq72a951.fsf@xmission.com>
 <20120807205717.GC11226@aftab.osrc.amd.com>
 <1344379147.27383.29.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1344379147.27383.29.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.08.12 15:39:07, Suresh Siddha wrote:
> Boris, Robert, can you check if the below patch makes both of your
> systems happy again (essentially not allowing the vector to change for
> legacy irq's, which also allows the RTE to be set correctly in the smp
> case etc)? Based on your results and some more thinking, I will send a
> detailed patch with changelog tomorrow.
> 
>  arch/x86/kernel/apic/io_apic.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

Suresh,

with your patch applied the sata device works fine and the system
boots, no issues seen.

Thanks,

-Robert

> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index a6c64aa..4b98610 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1356,6 +1356,15 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
>  	if (!IO_APIC_IRQ(irq))
>  		return;
>  
> +	/*
> +	 * For legacy irqs, cfg->domain starts with cpu 0. Now that IO-APIC
> +	 * can handle this irq and the apic driver is finialized at this point,
> +	 * update the cfg->domain.
> +	 */
> +	if (irq < legacy_pic->nr_legacy_irqs &&
> +	    cpumask_equal(cfg->domain, cpumask_of(0)))
> +		apic->vector_allocation_domain(0, cfg->domain, cpu_online_mask);
> +
>  	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
>  		return;
>  
> 
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

