Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab2FELYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab2FELYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:24:35 -0400
Date: Tue, 5 Jun 2012 13:24:29 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/8] x86: apic: Avoid useless scanning thru a cpumask in
 assign_irq_vector()
Message-ID: <20120605112422.GA11473@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of static vector allocation domains (i.e. flat) if all vector
numbers are exhausted, an attempt to assign a new vector will lead to
useless scans through all CPUs in the cpumask, even though it is known
that each new pass would fail. Make this corner case less painful by
letting report whether the vector allocation domain depends on passed
arguments or not and stop scanning early.

The same could have been achived by introducing a static flag to the
apic operations. But let's allow vector_allocation_domain() have more
intelligence here and decide dynamically, in case we would need it in
the future.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/apic.h      |    8 +++++---
 arch/x86/kernel/apic/apic_noop.c |    3 ++-
 arch/x86/kernel/apic/io_apic.c   |   12 +++++++++---
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9571160..011e9d4 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -301,7 +301,7 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -598,7 +598,7 @@ extern unsigned int
 default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       const struct cpumask *andmask);
 
-static inline void
+static inline bool
 flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -611,12 +611,14 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	 */
 	cpumask_clear(retmask);
 	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
+	return false;
 }
 
-static inline void
+static inline bool
 default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	cpumask_copy(retmask, cpumask_of(cpu));
+	return true;
 }
 
 static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 4cc0b77..e8c6e9c 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,11 +100,12 @@ static unsigned long noop_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
-static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+static bool noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
 	cpumask_copy(retmask, cpumask_of(cpu));
+	return true;
 }
 
 static u32 noop_apic_read(u32 reg)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f043d6a..f80321e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1189,8 +1189,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	for_each_cpu_and(cpu, mask, cpu_online_mask) {
 		int new_cpu;
 		int vector, offset;
+		bool more_domains;
 
-		apic->vector_allocation_domain(cpu, tmp_mask);
+		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
 
 		vector = current_vector;
 		offset = current_offset;
@@ -1200,8 +1201,13 @@ next:
 			offset = (offset + 1) % 16;
 			vector = FIRST_EXTERNAL_VECTOR + offset;
 		}
-		if (unlikely(current_vector == vector))
-			continue;
+
+		if (unlikely(current_vector == vector)) {
+			if (more_domains)
+				continue;
+			else
+				break;
+		}
 
 		if (test_bit(vector, used_vectors))
 			goto next;
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
