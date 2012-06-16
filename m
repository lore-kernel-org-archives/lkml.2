Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab2FPAZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:25:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:13531 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228Ab2FPAZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="154017783"
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Date: Fri, 15 Jun 2012 17:25:20 -0700
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 16:02 -0700, Suresh Siddha wrote:
> On Wed, 2012-06-06 at 19:20 +0200, Alexander Gordeev wrote:
> > 
> > Suresh,
> > 
> > I thought you posted these patches for reference and held off with my comments
> > until you are collecting the data. But since Ingo picked the patches I will
> > sound my concerns in this thread.
> 
> These are tested patches and I am ok with Ingo picking it up for getting
> further baked in -tip. About the data collection, I have to find the
> right system/bios to run the tests for power-aware/round-robin interrupt
> routing. Anyways logical xapic mode already has this capability and we
> are adding the capability for x2apic cluster mode here. And also,
> irqbalance has to ultimately take advantage of this by specifying
> multiple cpu's when migrating an interrupt.
> 
> Only concern I have with this patchset is what I already mentioned in
> the changelog of the second patch. i.e., it reduces the number of IRQ's
> that the platform can handle, as we reduce the available number of
> vectors by a factor of 16.
> 
> If this indeed becomes a problem, then there are few options. Either
> reserve the vectors based on the irq destination mask (rather than
> reserving on all the cluster members) or reducing the grouping from 16
> to a smaller number etc. I can post another patch shortly for this.
> 

Ok, here is a quick version of the patch doing the first option I
mentioned above. Reserve the vectors based on the irq destination mask
and the corresponding vector domain, rather than reserving the vector on
all the cpu's for the theoretical domain (which is an x2apic cluster).

Will do some more testing and post the patch with detailed changelog on
Monday. For now, appended the patch for quick reference. Thanks.
---

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h           |   10 +++++++---
 arch/x86/kernel/apic/apic_noop.c      |    3 ++-
 arch/x86/kernel/apic/io_apic.c        |   28 ++++++++++++++++++++++++++--
 arch/x86/kernel/apic/x2apic_cluster.c |    7 ++++---
 4 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 8619a87..af9ec10 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -303,10 +303,12 @@ struct apic {
 	int disable_esr;
 
 	int dest_logical;
+	bool sub_domain;
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
+					 const struct cpumask *mask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -615,7 +617,8 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       unsigned int *apicid);
 
 static inline bool
-flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
+flat_vector_allocation_domain(int cpu, struct cpumask *retmask,
+			      const struct cpumask *mask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -631,7 +634,8 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 }
 
 static inline bool
-default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+default_vector_allocation_domain(int cpu, struct cpumask *retmask,
+				 const struct cpumask *mask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
 	return true;
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 65c07fc..ebdd349 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,7 +100,8 @@ static unsigned long noop_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static bool noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool noop_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					  struct cpumask *mask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 99a794d..3d1c37c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1126,7 +1126,18 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_and(tmp_mask, mask, cpu_online_mask);
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
+		/*
+		 * If the APIC driver says it can't reliably route the
+		 * interrupt to some subset of the domain members and the
+		 * incoming affinity mask is already a subset of the domain,
+		 * then we are done. We will keep the vector assigned in all
+		 * the domain members.
+		 *
+		 * Or if the new mask is same as the existing domain, then
+		 * also nothing more to do here.
+		 */
+		if ((!apic->sub_domain && cpumask_subset(tmp_mask, cfg->domain))
+		    || (cpumask_equal(tmp_mask, cfg->domain))) {
 			free_cpumask_var(tmp_mask);
 			return 0;
 		}
@@ -1139,9 +1150,22 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 		int vector, offset;
 		bool more_domains;
 
-		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
+		more_domains =
+			apic->vector_allocation_domain(cpu, tmp_mask, mask);
 
 		if (cpumask_subset(tmp_mask, cfg->domain)) {
+			/*
+			 * If the APIC driver can route the interrupt
+			 * to some subset of the domain, then we can
+			 * cleanup the vector allocation for other members.
+			 */
+			if (apic->sub_domain &&
+			    !cpumask_equal(tmp_mask, cfg->domain)) {
+				cpumask_andnot(cfg->old_domain, cfg->domain,
+					       tmp_mask);
+				cfg->move_in_progress = 1;
+				cpumask_and(cfg->domain, cfg->domain, tmp_mask);
+			}
 			free_cpumask_var(tmp_mask);
 			return 0;
 		}
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 943d03f..46cbbe1 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -212,10 +212,10 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static bool cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool cluster_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					     const struct cpumask *mask)
 {
-	cpumask_clear(retmask);
-	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
+	cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 	return true;
 }
 
@@ -233,6 +233,7 @@ static struct apic apic_x2apic_cluster = {
 	.target_cpus			= online_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
+	.sub_domain			= true,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 


