Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2EUXqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:46:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:46534 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab2EUXqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155404721"
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Date: Mon, 21 May 2012 16:44:39 -0700
In-Reply-To: <20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
	 <CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
	 <20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 10:13 +0200, Alexander Gordeev wrote:
> On Sat, May 19, 2012 at 01:53:36PM -0700, Yinghai Lu wrote:
> > > +static void
> > > +x2apic_cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
> > > +{
> > > +       cpumask_copy(retmask, cpu_possible_mask);
> > 
> > why not using per_cpu(cpus_in_cluster, cpu) instead?
> 
> Because it would lead to suboptimal results when updating IRQ affinity:
> 
> int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
> 			  unsigned int *dest_id)
> {
> 	struct irq_cfg *cfg = data->chip_data;
> 
> 	if (!cpumask_intersects(mask, cpu_online_mask))
> 		return -1;
> 
> 	if (assign_irq_vector(data->irq, data->chip_data, mask))
> 		return -1;
> 
> This call ^^^ will update cfg->domain with the value returned by the call to
> apic->vector_allocation_domain(). If per_cpu(cpus_in_cluster, cpu) is returned
> as cfg->domain here then all other clusters contained in the 'mask' will not
> be taken into consideration by the apic->cpu_mask_to_apicid_and() call below.
> 
> 	cpumask_copy(data->affinity, mask);
> 
> 	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
> 
> So we really need to submit all possible CPUs here ^^^ to be able finding the
> best/heaviest cluster out of the 'mask'.
> 

I don't think we need to do anything fancy, like selecting the heaviest
cluster out of the mask. Something like (cluster membership of first cpu
in the mask) AND (mask) should be enough.

Also you need some changes in the assign_irq_vector(). Will post my
previously developed patches as a reference to this thread, while I
collect some data for this.

thanks,
suresh

