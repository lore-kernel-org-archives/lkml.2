Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab2FHOvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:51:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab2FHOvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:51:15 -0400
Date: Fri, 8 Jun 2012 07:51:04 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-8637e38aff14d048b649075114023023a2e80fba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120607131542.GE4759@dhcp-26-207.brq.redhat.com>
References: <20120607131542.GE4759@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Avoid useless scanning thru a cpumask in assign_irq_vector()
Git-Commit-ID: 8637e38aff14d048b649075114023023a2e80fba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:51:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8637e38aff14d048b649075114023023a2e80fba
Gitweb:     http://git.kernel.org/tip/8637e38aff14d048b649075114023023a2e80fba
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 7 Jun 2012 15:15:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:44:29 +0200

x86/apic: Avoid useless scanning thru a cpumask in assign_irq_vector()

In case of static vector allocation domains (i.e. flat) if all
vector numbers are exhausted, an attempt to assign a new vector
will lead to useless scans through all CPUs in the cpumask, even
though it is known that each new pass would fail. Make this
corner case less painful by letting report whether the vector
allocation domain depends on passed arguments or not and stop
scanning early.

The same could have been achived by introducing a static flag to
the apic operations. But let's allow vector_allocation_domain()
have more intelligence here and decide dynamically, in case we
would need it in the future.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120607131542.GE4759@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h      |    8 +++++---
 arch/x86/kernel/apic/apic_noop.c |    3 ++-
 arch/x86/kernel/apic/io_apic.c   |   12 +++++++++---
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index feb2dbd..e3fecd5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,7 +306,7 @@ struct apic {
 	unsigned long (*check_apicid_used)(physid_mask_t *map, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	bool (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
 	void (*init_apic_ldr)(void);
 
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -615,7 +615,7 @@ extern unsigned int
 default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       const struct cpumask *andmask);
 
-static inline void
+static inline bool
 flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -628,12 +628,14 @@ flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
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
index 3e43cf5..ac9edf2 100644
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
index 05af3d3..4061a7d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1137,8 +1137,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	for_each_cpu_and(cpu, mask, cpu_online_mask) {
 		int new_cpu;
 		int vector, offset;
+		bool more_domains;
 
-		apic->vector_allocation_domain(cpu, tmp_mask);
+		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
 
 		if (cpumask_subset(tmp_mask, cfg->domain)) {
 			free_cpumask_var(tmp_mask);
@@ -1153,8 +1154,13 @@ next:
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
