Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2FFSHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab2FFSHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:07:45 -0400
Date: Wed, 6 Jun 2012 19:20:18 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
Message-ID: <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:58:01PM -0700, Suresh Siddha wrote:
> Until now, irq_cfg domain is mostly static. Either all cpu's (used by flat
> mode) or one cpu (first cpu in the irq afffinity mask) to which irq is being
> migrated (this is used by the rest of apic modes).
> 
> Upcoming x2apic cluster mode optimization patch allows the irq to be sent
> to any cpu in the x2apic cluster (if supported by the HW). So irq_cfg
> domain changes on the fly (depending on which cpu in the x2apic cluster
> is online).
> 
> Instead of checking for any intersection between the new irq affinity
> mask and the current irq_cfg domain, check if the new irq affinity mask
> is a subset of the current irq_cfg domain. Otherwise proceed with
> updating the irq_cfg domain aswell as assigning vector's on all the cpu's
> specified in the new mask.
> 
> This also cleans up a workaround in updating irq_cfg domain for legacy irq's
> that are handled by the IO-APIC.

Suresh,

I thought you posted these patches for reference and held off with my comments
until you are collecting the data. But since Ingo picked the patches I will
sound my concerns in this thread.

> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index ffdc152..bbf8c43 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1137,8 +1137,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  	old_vector = cfg->vector;
>  	if (old_vector) {
>  		cpumask_and(tmp_mask, mask, cpu_online_mask);
> -		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
> -		if (!cpumask_empty(tmp_mask)) {
> +		if (cpumask_subset(tmp_mask, cfg->domain)) {

Imagine that passed mask is a subset of cfg->domain and also contains at least
one online CPU from a different cluster. Since domains are always one cluster
wide this condition ^^^ will fail and we go further.

>  			free_cpumask_var(tmp_mask);
>  			return 0;
>  		}
> @@ -1152,6 +1151,11 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  
>  		apic->vector_allocation_domain(cpu, tmp_mask);
>  
> +		if (cpumask_subset(tmp_mask, cfg->domain)) {

Because the mask intersects with cfg->domain this condition ^^^ may succeed and
we could return with no change from here.

That raises few concerns to me:

- The first check is not perfect, because it failed to recognize the
intersection right away. Instead, we possibly lost multiple loops through the
mask before we realized we do not need any change at all. Therefore...

- It would be better to recognize the intersection even before entering the
loop. But that is exactly what the removed code has been doing before.

- Depending from the passed mask, we equally likely could have select another
cluster and switch to it, even though the current cfg->domain is contained
within the requested mask. Besides it is just not nice, we are also switching
from a cache-hot cluster. If you suggested that it is enough to pick a first
found cluster (rather than select a best possible) then there is even less
reason to switch from cfg->domain here.

> +			free_cpumask_var(tmp_mask);
> +			return 0;
> +		}
> +
>  		vector = current_vector;
>  		offset = current_offset;
>  next:
> @@ -1357,13 +1361,6 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
>  
>  	if (!IO_APIC_IRQ(irq))
>  		return;
> -	/*
> -	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
> -	 * controllers like 8259. Now that IO-APIC can handle this irq, update
> -	 * the cfg->domain.
> -	 */
> -	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
> -		apic->vector_allocation_domain(0, cfg->domain);


This hunk reverts your 69c89ef commit. Regression?

>  
>  	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
>  		return;
> -- 
> 1.7.6.5
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
