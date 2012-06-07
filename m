Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2FGNPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab2FGNO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:14:58 -0400
Date: Thu, 7 Jun 2012 15:14:49 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/8] x86/apic: Factor out default vector_allocation_domain()
 operation
Message-ID: <20120607131449.GC4759@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
 <20120606082231.GD5991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606082231.GD5991@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/apic.h          |   21 +++++++++++++++++++++
 arch/x86/kernel/apic/apic_flat_64.c  |   22 +---------------------
 arch/x86/kernel/apic/apic_noop.c     |    3 +--
 arch/x86/kernel/apic/apic_numachip.c |    8 +-------
 arch/x86/kernel/apic/bigsmp_32.c     |    8 +-------
 arch/x86/kernel/apic/es7000_32.c     |   19 ++-----------------
 arch/x86/kernel/apic/numaq_32.c      |   16 +---------------
 arch/x86/kernel/apic/probe_32.c      |   17 +----------------
 arch/x86/kernel/apic/summit_32.c     |   16 +---------------
 arch/x86/kernel/apic/x2apic_phys.c   |   11 +----------
 arch/x86/kernel/apic/x2apic_uv_x.c   |    8 +-------
 11 files changed, 32 insertions(+), 117 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bef5717..feb2dbd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -615,6 +615,27 @@ extern unsigned int
 default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			       const struct cpumask *andmask);
 
+static inline void
+flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	/* Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
+}
+
+static inline void
+default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_copy(retmask, cpumask_of(cpu));
+}
+
 static inline unsigned long default_check_apicid_used(physid_mask_t *map, int apicid)
 {
 	return physid_isset(apicid, *map);
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 55b97ce..bddc925 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -36,20 +36,6 @@ static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 1;
 }
 
-static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	/* Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	cpumask_clear(retmask);
-	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-}
-
 /*
  * Set up the logical destination ID.
  *
@@ -257,12 +243,6 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return 0;
 }
 
-static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 {
 	default_send_IPI_mask_sequence_phys(cpumask, vector);
@@ -309,7 +289,7 @@ static struct apic apic_physflat =  {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= physflat_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	/* not needed, but shouldn't hurt: */
 	.init_apic_ldr			= flat_init_apic_ldr,
 
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 7c3dd4f..3e43cf5 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -104,8 +104,7 @@ static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
+	cpumask_copy(retmask, cpumask_of(cpu));
 }
 
 static u32 noop_apic_read(u32 reg)
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index dba4bf2..c028132 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -72,12 +72,6 @@ static int numachip_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
-static void numachip_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 	union numachip_csr_g3_ext_irq_gen int_gen;
@@ -222,7 +216,7 @@ static struct apic apic_numachip __refconst = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= numachip_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= flat_init_apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 907aa3d..df342fe 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -142,12 +142,6 @@ static const struct dmi_system_id bigsmp_dmi_table[] = {
 	{ } /* NULL entry stops DMI scanning */
 };
 
-static void bigsmp_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static int probe_bigsmp(void)
 {
 	if (def_to_bigsmp)
@@ -176,7 +170,7 @@ static struct apic apic_bigsmp = {
 	.check_apicid_used		= bigsmp_check_apicid_used,
 	.check_apicid_present		= bigsmp_check_apicid_present,
 
-	.vector_allocation_domain	= bigsmp_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index db4ab1b..3c42865 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -394,21 +394,6 @@ static void es7000_enable_apic_mode(void)
 		WARN(1, "Command failed, status = %x\n", mip_status);
 }
 
-static void es7000_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	/* Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	cpumask_clear(retmask);
-	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-}
-
-
 static void es7000_wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
@@ -638,7 +623,7 @@ static struct apic __refdata apic_es7000_cluster = {
 	.check_apicid_used		= es7000_check_apicid_used,
 	.check_apicid_present		= es7000_check_apicid_present,
 
-	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= es7000_init_apic_ldr_cluster,
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
@@ -705,7 +690,7 @@ static struct apic __refdata apic_es7000 = {
 	.check_apicid_used		= es7000_check_apicid_used,
 	.check_apicid_present		= es7000_check_apicid_present,
 
-	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= es7000_init_apic_ldr,
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index f00a68c..eb2d466 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -441,20 +441,6 @@ static int probe_numaq(void)
 	return found_numaq;
 }
 
-static void numaq_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	/* Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	cpumask_clear(retmask);
-	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-}
-
 static void numaq_setup_portio_remap(void)
 {
 	int num_quads = num_online_nodes();
@@ -491,7 +477,7 @@ static struct apic __refdata apic_numaq = {
 	.check_apicid_used		= numaq_check_apicid_used,
 	.check_apicid_present		= numaq_check_apicid_present,
 
-	.vector_allocation_domain	= numaq_vector_allocation_domain,
+	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= numaq_init_apic_ldr,
 
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 71b6ac4..2c6f003 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -66,21 +66,6 @@ static void setup_apic_flat_routing(void)
 #endif
 }
 
-static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	/*
-	 * Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	cpumask_clear(retmask);
-	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-}
-
 /* should be called last. */
 static int probe_default(void)
 {
@@ -105,7 +90,7 @@ static struct apic apic_default = {
 	.check_apicid_used		= default_check_apicid_used,
 	.check_apicid_present		= default_check_apicid_present,
 
-	.vector_allocation_domain	= default_vector_allocation_domain,
+	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 659897c..35d254c 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -320,20 +320,6 @@ static int probe_summit(void)
 	return 0;
 }
 
-static void summit_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	/* Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	cpumask_clear(retmask);
-	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
-}
-
 #ifdef CONFIG_X86_SUMMIT_NUMA
 static struct rio_table_hdr *rio_table_hdr;
 static struct scal_detail   *scal_devs[MAX_NUMNODES];
@@ -509,7 +495,7 @@ static struct apic apic_summit = {
 	.check_apicid_used		= summit_check_apicid_used,
 	.check_apicid_present		= summit_check_apicid_present,
 
-	.vector_allocation_domain	= summit_vector_allocation_domain,
+	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= summit_init_apic_ldr,
 
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f730269..f109388 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -88,15 +88,6 @@ static int x2apic_phys_probe(void)
 	return apic == &apic_x2apic_phys;
 }
 
-/*
- * Each logical cpu is in its own vector allocation domain.
- */
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static struct apic apic_x2apic_phys = {
 
 	.name				= "physical x2apic",
@@ -114,7 +105,7 @@ static struct apic apic_x2apic_phys = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= x2apic_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 16efb92..df89a7d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -185,12 +185,6 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 #ifdef CONFIG_SMP
@@ -363,7 +357,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= uv_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= uv_init_apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
