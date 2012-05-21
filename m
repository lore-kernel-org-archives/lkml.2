Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2EUINl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:13:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab2EUINj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:13:39 -0400
Date: Mon, 21 May 2012 10:13:30 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521081330.GB28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXUM-+KSZ1OcxipRW-3XQED3Csyxs=0ke0hJZR7E_hrhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 01:53:36PM -0700, Yinghai Lu wrote:
> > +static void
> > +x2apic_cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
> > +{
> > +       cpumask_copy(retmask, cpu_possible_mask);
> 
> why not using per_cpu(cpus_in_cluster, cpu) instead?

Because it would lead to suboptimal results when updating IRQ affinity:

int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
			  unsigned int *dest_id)
{
	struct irq_cfg *cfg = data->chip_data;

	if (!cpumask_intersects(mask, cpu_online_mask))
		return -1;

	if (assign_irq_vector(data->irq, data->chip_data, mask))
		return -1;

This call ^^^ will update cfg->domain with the value returned by the call to
apic->vector_allocation_domain(). If per_cpu(cpus_in_cluster, cpu) is returned
as cfg->domain here then all other clusters contained in the 'mask' will not
be taken into consideration by the apic->cpu_mask_to_apicid_and() call below.

	cpumask_copy(data->affinity, mask);

	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);

So we really need to submit all possible CPUs here ^^^ to be able finding the
best/heaviest cluster out of the 'mask'.

	return 0;
}


> also you may add one per cpu var like x86_cpu_to_logical_cluster_apicid.

Both cpu_mask_to_apicid() and cpu_mask_to_apicid_and() take a cpumask to
derive the apicid from. Even though we could cache the value of apicid in
'x86_cpu_to_logical_cluster_apicid' variable, we still would have to unset
CPUs which are not in the requested cpumask. That means scanning through the
cpumask etc -- exactly what the the patch does now.

Or I am missing your point here..

> Yinghai

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
