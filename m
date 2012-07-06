Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2GFL2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:28:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab2GFL2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:28:23 -0400
Date: Fri, 6 Jul 2012 04:28:09 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-b39f25a849d7677a7dbf183f2483fd41c201a5ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, gorcunov@openvz.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1340656709-11423-2-git-send-email-suresh.b.siddha@intel.com>
References: <1340656709-11423-2-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/apic:
  Optimize cpu traversal in __assign_irq_vector() using domain membership
Git-Commit-ID: b39f25a849d7677a7dbf183f2483fd41c201a5ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:28:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b39f25a849d7677a7dbf183f2483fd41c201a5ce
Gitweb:     http://git.kernel.org/tip/b39f25a849d7677a7dbf183f2483fd41c201a5ce
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 25 Jun 2012 13:38:27 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 11:00:21 +0200

x86/apic: Optimize cpu traversal in __assign_irq_vector() using domain membership

Currently __assign_irq_vector() goes through each cpu in the
specified mask until it finds a free vector in all the cpu's
that are part of the same interrupt domain. We visit all the
interrupt domain sibling cpus to reserve the free vector. So,
when we fail to find a free vector in an interrupt domain, it is
safe to continue our search with a cpu belonging to a new
interrupt domain. No need to go through each cpu, if the domain
containing that cpu is already visited.

Use the irq_cfg's old_domain to track the visited domains and
optimize the cpu traversal while finding a free vector in the
given cpumask.

NOTE: We can also optimize the search by using for_each_cpu() and
skip the current cpu, if it is not the first cpu in the mask
returned by the vector_allocation_domain(). But re-using the
cfg->old_domain to track the visited domains will be slightly
faster.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/r/1340656709-11423-2-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |    8 +++-----
 arch/x86/kernel/apic/apic_noop.c      |    3 +--
 arch/x86/kernel/apic/io_apic.c        |   15 ++++++++-------
 arch/x86/kernel/apic/x2apic_cluster.c |    3 +--
 arch/x86/kernel/vsmp_64.c             |    3 +--
 5 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eec240e..8bebeb8 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,7 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -614,7 +614,7 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       const struct cpumask *andmask,
 			       unsigned int *apicid);
 
-static inline bool
+static inline void
 flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -627,14 +627,12 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	 */
 	cpumask_clear(retmask);
 	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-	return false;
 }
 
-static inline bool
+static inline void
 default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
-	return true;
 }
 
 static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 65c07fc..08c337b 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,12 +100,11 @@ static unsigned long noop_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static bool noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
 	cpumask_copy(retmask, cpumask_of(cpu));
-	return true;
 }
 
 static u32 noop_apic_read(u32 reg)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a951ef7..8a08f09 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1134,12 +1134,13 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
-	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+	cpumask_clear(cfg->old_domain);
+	cpu = cpumask_first_and(mask, cpu_online_mask);
+	while (cpu < nr_cpu_ids) {
 		int new_cpu;
 		int vector, offset;
-		bool more_domains;
 
-		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
+		apic->vector_allocation_domain(cpu, tmp_mask);
 
 		if (cpumask_subset(tmp_mask, cfg->domain)) {
 			free_cpumask_var(tmp_mask);
@@ -1156,10 +1157,10 @@ next:
 		}
 
 		if (unlikely(current_vector == vector)) {
-			if (more_domains)
-				continue;
-			else
-				break;
+			cpumask_or(cfg->old_domain, cfg->old_domain, tmp_mask);
+			cpumask_andnot(tmp_mask, mask, cfg->old_domain);
+			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
+			continue;
 		}
 
 		if (test_bit(vector, used_vectors))
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 943d03f..b5d889b 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -212,11 +212,10 @@ static int x2apic_cluster_probe(void)
 /*
  * Each x2apic cluster is an allocation domain.
  */
-static bool cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void cluster_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_clear(retmask);
 	cpumask_copy(retmask, per_cpu(cpus_in_cluster, cpu));
-	return true;
 }
 
 static struct apic apic_x2apic_cluster = {
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index fa5adb7..3f0285a 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -208,10 +208,9 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  * In vSMP, all cpus should be capable of handling interrupts, regardless of
  * the APIC used.
  */
-static bool fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_setall(retmask);
-	return false;
 }
 
 static void vsmp_apic_post_init(void)
