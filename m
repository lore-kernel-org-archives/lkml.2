Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2FTAS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 20:18:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:46253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2FTASY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 20:18:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182426974"
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Date: Tue, 19 Jun 2012 17:18:42 -0700
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
	 <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
	 <20120618091740.GK3383@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1340151523.3696.27.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 17:51 -0700, Suresh Siddha wrote:
> > -		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
> > +		more = apic->vector_allocation_domain(cpu, mask, tmp_mask);
> > +		cmp = apic->compare_domains(tmp_mask, cfg->domain);
> 
> I think we should be able to consolidate both of them into one
> apic_driver specific routine. Also I think we should be able to use the
> tmp_mask in each round and minimize the number of unnecessary
> for_each_cpu iterations. And that should clean up the more_domains bool
> logic we did earlier.

Just posted couple of patches which did the above. Please review and
ack.

On Mon, 2012-06-18 at 11:17 +0200, Alexander Gordeev wrote:
> Also, this would fix a previous subtle condition introduced with previous
> commit 332afa6 ("x86/irq: Update irq_cfg domain unless the new affinity is a
> subset of the current domain") when a change of affinity mask could trigger
> unnecessary move of vector in case new and old masks intersect, but the new
> mask is not a subset of the old one.

So, I gave some thought to this. And I don't like/didn't address it for
the reasons I mentioned earlier. I don't want to add intelligence to the
apic drivers. That belongs to a higher level entity like 'irqbalance'.
Also when irqbalance asks for a specific mask, I don't want its behavior
to depend on the previous configuration. And I want the behavior to be
some what consistent across different apic drivers whose underlying HW
behavior is similar. For example logical-flat with no HW round-robin
will route the interrupt to the first cpu specified in the user-mask.

Also this is a not common case worth caring about.

BTW, there is still one open that I would like to address. How to handle
the vector pressure during boot etc (as the default vector assignment
specifies all online cpus) when there are lot interrupt sources but
fewer x2apic clusters (like one or two socket server case).

We should be able to do something like the appended. Any better
suggestions? I don't want to add boot parameters to limit the x2apic
cluster membership etc (to fewer than 16 logical cpu's) if possible.
---

 arch/x86/kernel/apic/x2apic_cluster.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 4d49512..0e3d659 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -217,7 +217,20 @@ static void cluster_vector_allocation_domain(const struct cpumask *mask,
 					     const struct cpumask *prevmask)
 {
 	int cpu = cpumask_first(retmask);
-	cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
+
+	/*
+	 * By default during boot, device bringup etc interrupt
+	 * will be routed to a specific cpu.
+	 *
+	 * On irq migration requests coming from irqbalance etc,
+	 * interrupts will be routed to the x2apic cluster (cluster-id
+	 * derived from the first cpu in the mask) members specified
+	 * in the mask.
+	 */
+	if (mask == cpu_online_mask)
+		cpumask_copy(retmask, cpumask_of(cpu));
+	else
+		cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 }
 
 static struct apic apic_x2apic_cluster = {


thanks,
suresh

