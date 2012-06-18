Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2FRJRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:17:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab2FRJRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:17:49 -0400
Date: Mon, 18 Jun 2012 11:17:41 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
Message-ID: <20120618091740.GK3383@dhcp-26-207.brq.redhat.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
 <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 05:25:20PM -0700, Suresh Siddha wrote:
> On Wed, 2012-06-06 at 16:02 -0700, Suresh Siddha wrote:
> Ok, here is a quick version of the patch doing the first option I
> mentioned above. Reserve the vectors based on the irq destination mask
> and the corresponding vector domain, rather than reserving the vector on
> all the cpu's for the theoretical domain (which is an x2apic cluster).

Suresh,

I would suggest to go further and generalize your idea and introduce something
like compare_domains() instead sub_domain flag. This would help us to keep/let
__assign_irq_vector() be more generic and hide domains treating logic in
drivers.

Also, this would fix a previous subtle condition introduced with previous
commit 332afa6 ("x86/irq: Update irq_cfg domain unless the new affinity is a
subset of the current domain") when a change of affinity mask could trigger
unnecessary move of vector in case new and old masks intersect, but the new
mask is not a subset of the old one.

The patch is just to clarify the idea, neither tested nor even compiled.


diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eec240e..fcca995 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,10 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	bool (*vector_allocation_domain)(int cpu,
+					 const struct cpumask *mask,
+					 struct cpumask *retmask);
+	int (*compare_domains)(const struct cpumask *, const struct cpumask *);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -615,7 +618,9 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       unsigned int *apicid);
 
 static inline bool
-flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
+flat_vector_allocation_domain(int cpu,
+			      const struct cpumask *mask,
+			      struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -630,13 +635,33 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	return false;
 }
 
+static inline int
+flat_compare_domains(const struct cpumask *domain1,
+		     const struct cpumask *domain2)
+{
+	if (cpumask_subset(domain1, domain2))
+		return 0;
+	return 1;
+}
+
 static inline bool
-default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+default_vector_allocation_domain(int cpu,
+				 const struct cpumask *mask,
+				 struct cpumask *retmask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
 	return true;
 }
 
+static inline int
+default_compare_domains(const struct cpumask *domain1,
+			const struct cpumask *domain2)
+{
+	if (cpumask_intersects(domain1, domain2))
+		return 0;
+	return 1;
+}
+
 static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return physid_isset(apicid, *map);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0540f08..88cafc8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1126,7 +1126,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_and(tmp_mask, mask, cpu_online_mask);
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
+		if (!apic->compare_domains(tmp_mask, cfg->domain)) {
 			free_cpumask_var(tmp_mask);
 			return 0;
 		}
@@ -1138,47 +1138,50 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 		int new_cpu;
 		int vector, offset;
 		bool more_domains;
+		int cmp_domains;
 
-		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
+		more = apic->vector_allocation_domain(cpu, mask, tmp_mask);
+		cmp = apic->compare_domains(tmp_mask, cfg->domain);
 
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
-			free_cpumask_var(tmp_mask);
-			return 0;
-		}
-
-		vector = current_vector;
-		offset = current_offset;
+		if (cmp < 0) {
+			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
+			cfg->move_in_progress = 1;
+			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
+		} else if (cmp > 0) {
+			vector = current_vector;
+			offset = current_offset;
 next:
-		vector += 16;
-		if (vector >= first_system_vector) {
-			offset = (offset + 1) % 16;
-			vector = FIRST_EXTERNAL_VECTOR + offset;
-		}
-
-		if (unlikely(current_vector == vector)) {
-			if (more_domains)
-				continue;
-			else
-				break;
-		}
+			vector += 16;
+			if (vector >= first_system_vector) {
+				offset = (offset + 1) % 16;
+				vector = FIRST_EXTERNAL_VECTOR + offset;
+			}
 
-		if (test_bit(vector, used_vectors))
-			goto next;
+			if (unlikely(current_vector == vector)) {
+				if (more)
+					continue;
+				else
+					break;
+			}
 
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+			if (test_bit(vector, used_vectors))
 				goto next;
-		/* Found one! */
-		current_vector = vector;
-		current_offset = offset;
-		if (old_vector) {
-			cfg->move_in_progress = 1;
-			cpumask_copy(cfg->old_domain, cfg->domain);
+
+			for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+				if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+					goto next;
+			/* Found one! */
+			current_vector = vector;
+			current_offset = offset;
+			if (old_vector) {
+				cfg->move_in_progress = 1;
+				cpumask_copy(cfg->old_domain, cfg->domain);
+			}
+			for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+				per_cpu(vector_irq, new_cpu)[vector] = irq;
+			cfg->vector = vector;
+			cpumask_copy(cfg->domain, tmp_mask);
 		}
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			per_cpu(vector_irq, new_cpu)[vector] = irq;
-		cfg->vector = vector;
-		cpumask_copy(cfg->domain, tmp_mask);
 		err = 0;
 		break;
 	}
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 943d03f..090c69e 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -212,13 +212,24 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static bool cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool cluster_vector_allocation_domain(int cpu,
+					     const struct cpumask *mask,
+					     struct cpumask *retmask)
 {
-	cpumask_clear(retmask);
-	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
+	cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 	return true;
 }
 
+static int cluster_compare_domains(const struct cpumask *domain1,
+				   const struct cpumask *domain2)
+{
+	if (cpumask_subset(domain1, domain2))
+		return -1;
+	if (cpumask_equal(domain1, domain2))
+		return 0;
+	return 1;
+}
+
 static struct apic apic_x2apic_cluster = {
 
 	.name				= "cluster x2apic",
@@ -237,6 +248,7 @@ static struct apic apic_x2apic_cluster = {
 	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= cluster_vector_allocation_domain,
+	.compare_domains		= cluster_compare_domains,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index e03a1e1..24511a9 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -106,6 +106,7 @@ static struct apic apic_x2apic_phys = {
 	.check_apicid_present		= NULL,
 
 	.vector_allocation_domain	= default_vector_allocation_domain,
+	.compare_domains		= default_compare_domains,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
