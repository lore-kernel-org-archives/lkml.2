Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab2FUVvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:51:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:44863 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab2FUVvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:51:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114823541"
Subject: Re: [PATCH 2/2] x86, x2apic: limit the vector reservation to the
 user specified mask
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Date: Thu, 21 Jun 2012 14:51:35 -0700
In-Reply-To: <20120621090451.GD2223@dhcp-26-207.brq.redhat.com>
References: <1340067097.3696.6.camel@sbsiddha-desk.sc.intel.com>
	 <1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
	 <1340149411-2972-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120621090451.GD2223@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1340315496.3696.87.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 11:04 +0200, Alexander Gordeev wrote:
> >  static int
> >  __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> >  {
> > @@ -1126,10 +1142,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> >  	old_vector = cfg->vector;
> >  	if (old_vector) {
> >  		cpumask_and(tmp_mask, mask, cpu_online_mask);
> > -		if (cpumask_subset(tmp_mask, cfg->domain)) {
> > -			free_cpumask_var(tmp_mask);
> > -			return 0;
> > -		}
> > +		apic->vector_allocation_domain(mask, tmp_mask, cfg->domain);
> > +		if (cpumask_subset(tmp_mask, cfg->domain))
> > +			return cleanup_unused_subset(tmp_mask, cfg);
> 
> ...but if you decide to leave cleanup_unused_subset() then cpumask_subset()
> check is better to move inside the function while free_cpumask_var() move
> out.

Removed the function and the above hunk completely in the next version.

> 
> >  	}
> >  
> >  	/* Only try and allocate irqs on cpus that are present */
> > @@ -1137,15 +1152,12 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> >  	cpumask_clear(cfg->old_domain);
> >  	cpu = cpumask_first_and(mask, cpu_online_mask);
> >  	while (cpu < nr_cpu_ids) {
> > -		int new_cpu;
> > -		int vector, offset;
> > +		int new_cpu, vector, offset;
> >  
> > -		apic->vector_allocation_domain(cpu, tmp_mask);
> > -
> > -		if (cpumask_subset(tmp_mask, cfg->domain)) {
> > -			free_cpumask_var(tmp_mask);
> > -			return 0;
> > -		}
> > +		cpumask_copy(tmp_mask, cpumask_of(cpu));
> > +		apic->vector_allocation_domain(mask, tmp_mask, cfg->domain);
> 
> I might be missing the point.. in the two lines above you copy a cpumask to
> tmp_mask, then scan it in vector_allocation_domain() just to find the cpu
> which you already know. Why not just pass cpu rather then cpumask_of(cpu)?

One of my earlier experiments was using cfg->domain internally in the
vector_allocation_domain() and didn't want to use to many arguments.
Also 'cpu' argument for the first hunk above was not making sense.

Anyhow, this is all cleaned up now in the next version of the patchset.

thanks,
suresh


