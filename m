Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2FFXCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:02:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:48242 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab2FFXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:02:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108742426"
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Date: Wed, 06 Jun 2012 16:02:05 -0700
In-Reply-To: <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339023725.28766.55.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 19:20 +0200, Alexander Gordeev wrote:
> On Mon, May 21, 2012 at 04:58:01PM -0700, Suresh Siddha wrote:
> > Until now, irq_cfg domain is mostly static. Either all cpu's (used by flat
> > mode) or one cpu (first cpu in the irq afffinity mask) to which irq is being
> > migrated (this is used by the rest of apic modes).
> > 
> > Upcoming x2apic cluster mode optimization patch allows the irq to be sent
> > to any cpu in the x2apic cluster (if supported by the HW). So irq_cfg
> > domain changes on the fly (depending on which cpu in the x2apic cluster
> > is online).
> > 
> > Instead of checking for any intersection between the new irq affinity
> > mask and the current irq_cfg domain, check if the new irq affinity mask
> > is a subset of the current irq_cfg domain. Otherwise proceed with
> > updating the irq_cfg domain aswell as assigning vector's on all the cpu's
> > specified in the new mask.
> > 
> > This also cleans up a workaround in updating irq_cfg domain for legacy irq's
> > that are handled by the IO-APIC.
> 
> Suresh,
> 
> I thought you posted these patches for reference and held off with my comments
> until you are collecting the data. But since Ingo picked the patches I will
> sound my concerns in this thread.

These are tested patches and I am ok with Ingo picking it up for getting
further baked in -tip. About the data collection, I have to find the
right system/bios to run the tests for power-aware/round-robin interrupt
routing. Anyways logical xapic mode already has this capability and we
are adding the capability for x2apic cluster mode here. And also,
irqbalance has to ultimately take advantage of this by specifying
multiple cpu's when migrating an interrupt.

Only concern I have with this patchset is what I already mentioned in
the changelog of the second patch. i.e., it reduces the number of IRQ's
that the platform can handle, as we reduce the available number of
vectors by a factor of 16.

If this indeed becomes a problem, then there are few options. Either
reserve the vectors based on the irq destination mask (rather than
reserving on all the cluster members) or reducing the grouping from 16
to a smaller number etc. I can post another patch shortly for this.

> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> >  arch/x86/kernel/apic/io_apic.c |   15 ++++++---------
> >  1 files changed, 6 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index ffdc152..bbf8c43 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -1137,8 +1137,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> >  	old_vector = cfg->vector;
> >  	if (old_vector) {
> >  		cpumask_and(tmp_mask, mask, cpu_online_mask);
> > -		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
> > -		if (!cpumask_empty(tmp_mask)) {
> > +		if (cpumask_subset(tmp_mask, cfg->domain)) {
> 
> Imagine that passed mask is a subset of cfg->domain and also contains at least
> one online CPU from a different cluster. Since domains are always one cluster
> wide this condition ^^^ will fail and we go further.
> 
> >  			free_cpumask_var(tmp_mask);
> >  			return 0;
> >  		}
> > @@ -1152,6 +1151,11 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> >  
> >  		apic->vector_allocation_domain(cpu, tmp_mask);
> >  
> > +		if (cpumask_subset(tmp_mask, cfg->domain)) {
> 
> Because the mask intersects with cfg->domain this condition ^^^ may succeed and
> we could return with no change from here.
> 
> That raises few concerns to me:
> - The first check is not perfect, because it failed to recognize the
> intersection right away. Instead, we possibly lost multiple loops through the
> mask before we realized we do not need any change at all. Therefore...
> 
> - It would be better to recognize the intersection even before entering the
> loop. But that is exactly what the removed code has been doing before.
> 
> - Depending from the passed mask, we equally likely could have select another
> cluster and switch to it, even though the current cfg->domain is contained
> within the requested mask. Besides it is just not nice, we are also switching
> from a cache-hot cluster. If you suggested that it is enough to pick a first
> found cluster (rather than select a best possible) then there is even less
> reason to switch from cfg->domain here.

Few things to keep in perspective.

this is generic portion of the vector handling code and has to work
across different apic drivers and their cfg domains. And also most of
the intelligence lies in the irqbalance which specifies the irq
destination mask. Traditionally Kernel code selected the first possible
destination and not the best destination among the specified mask.

Anyways the above hunks are trying to address scenario like this for
example: During boot, all the IO-APIC interrupts (legacy/non-legacy) are
routed to cpu-0 with only cpu-0 in their cfg->domain (as we don't know
which other cpu's fall into the same x2apic cluster, we can't pre-set
them in the cfg->domain). Consider a single socket system. After the SMP
bringup of other siblings, those io-apic irq's affinity is modified to
all cpu's in setup_ioapic_dest(). And with the current code,
assign_irq_vector() will bail immediately with out reserving the
corresponding vector on all the cluster members that are now online. And
the interrupt ends up going to only cpu-0 and it will not get corrected
as long as cpu-0 is in the specified interrupt destination mask.

> > +			free_cpumask_var(tmp_mask);
> > +			return 0;
> > +		}
> > +
> >  		vector = current_vector;
> >  		offset = current_offset;
> >  next:
> > @@ -1357,13 +1361,6 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
> >  
> >  	if (!IO_APIC_IRQ(irq))
> >  		return;
> > -	/*
> > -	 * For legacy irqs, cfg->domain starts with cpu 0 for legacy
> > -	 * controllers like 8259. Now that IO-APIC can handle this irq, update
> > -	 * the cfg->domain.
> > -	 */
> > -	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
> > -		apic->vector_allocation_domain(0, cfg->domain);
> 
> 
> This hunk reverts your 69c89ef commit. Regression?
> 

As I mentioned in the changelog, this patch removes the need for that
hacky workaround. commit 69c89ef didn't really fix the underlying
problem (and hence we re-encountered the similar issue (above mentioned)
in the context of x2apic cluster). Clean fix is to address the issue in
assign_irq_vector() which is what this patch does.

thanks,
suresh

