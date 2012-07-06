Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2GFL3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:29:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2GFL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:29:17 -0400
Date: Fri, 6 Jul 2012 04:29:03 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, gorcunov@openvz.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1340656709-11423-3-git-send-email-suresh.b.siddha@intel.com>
References: <1340656709-11423-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/apic/x2apic:
  Limit the vector reservation to the user specified mask
Git-Commit-ID: 1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:29:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02
Gitweb:     http://git.kernel.org/tip/1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 25 Jun 2012 13:38:28 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 11:00:22 +0200

x86/apic/x2apic: Limit the vector reservation to the user specified mask

For the x2apic cluster mode, vector for an interrupt is
currently reserved on all the cpu's that are part of the x2apic
cluster. But the interrupts will be routed only to the cluster
(derived from the first cpu in the mask) members specified in
the mask. So there is no need to reserve the vector in the
unused cluster members.

Modify __assign_irq_vector() to reserve the vectors based on the
user specified irq destination mask. If the new mask is a proper
subset of the currently used mask, cleanup the vector allocation
on the unused cpu members.

Also, allow the apic driver to tune the vector domain based on
the affinity mask (which in most cases is the user-specified
mask).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/r/1340656709-11423-3-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |    9 ++++++---
 arch/x86/kernel/apic/apic_noop.c      |    3 ++-
 arch/x86/kernel/apic/io_apic.c        |   31 +++++++++++++++----------------
 arch/x86/kernel/apic/x2apic_cluster.c |    6 +++---
 arch/x86/kernel/vsmp_64.c             |    3 ++-
 5 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 8bebeb8..88093c1 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,8 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask,
+					 const struct cpumask *mask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -615,7 +616,8 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       unsigned int *apicid);
 
 static inline void
-flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
+flat_vector_allocation_domain(int cpu, struct cpumask *retmask,
+			      const struct cpumask *mask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -630,7 +632,8 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 }
 
 static inline void
-default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+default_vector_allocation_domain(int cpu, struct cpumask *retmask,
+				 const struct cpumask *mask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
 }
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 08c337b..e145f28 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,7 +100,8 @@ static unsigned long noop_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					  const struct cpumask *mask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8a08f09..9684f96 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1113,7 +1113,6 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 */
 	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
 	static int current_offset = VECTOR_OFFSET_START % 16;
-	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
@@ -1123,28 +1122,28 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return -ENOMEM;
 
-	old_vector = cfg->vector;
-	if (old_vector) {
-		cpumask_and(tmp_mask, mask, cpu_online_mask);
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
-			free_cpumask_var(tmp_mask);
-			return 0;
-		}
-	}
-
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
 	cpumask_clear(cfg->old_domain);
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	while (cpu < nr_cpu_ids) {
-		int new_cpu;
-		int vector, offset;
+		int new_cpu, vector, offset;
 
-		apic->vector_allocation_domain(cpu, tmp_mask);
+		apic->vector_allocation_domain(cpu, tmp_mask, mask);
 
 		if (cpumask_subset(tmp_mask, cfg->domain)) {
-			free_cpumask_var(tmp_mask);
-			return 0;
+			err = 0;
+			if (cpumask_equal(tmp_mask, cfg->domain))
+				break;
+			/*
+			 * New cpumask using the vector is a proper subset of
+			 * the current in use mask. So cleanup the vector
+			 * allocation for the members that are not used anymore.
+			 */
+			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
+			cfg->move_in_progress = 1;
+			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
+			break;
 		}
 
 		vector = current_vector;
@@ -1172,7 +1171,7 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		if (old_vector) {
+		if (cfg->vector) {
 			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index b5d889b..bde78d0 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -212,10 +212,10 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					     const struct cpumask *mask)
 {
-	cpumask_clear(retmask);
-	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
+	cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
 }
 
 static struct apic apic_x2apic_cluster = {
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 3f0285a..992f890 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -208,7 +208,8 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  * In vSMP, all cpus should be capable of handling interrupts, regardless of
  * the APIC used.
  */
-static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask,
+					  const struct cpumask *mask)
 {
 	cpumask_setall(retmask);
 }
