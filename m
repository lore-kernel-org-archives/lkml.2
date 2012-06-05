Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab2FELYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933938Ab2FELYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:24:06 -0400
Date: Tue, 5 Jun 2012 13:23:58 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/8] x86: apic: Factor out default vector_allocation_domain()
 operations
Message-ID: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/include/asm/apic.h           |   21 +++++++++++++++++++++
 arch/x86/include/asm/x2apic.h         |    9 ---------
 arch/x86/kernel/apic/apic_flat_64.c   |   22 +---------------------
 arch/x86/kernel/apic/apic_noop.c      |    3 +--
 arch/x86/kernel/apic/apic_numachip.c  |    8 +-------
 arch/x86/kernel/apic/bigsmp_32.c      |    8 +-------
 arch/x86/kernel/apic/es7000_32.c      |   19 ++-----------------
 arch/x86/kernel/apic/numaq_32.c       |   16 +---------------
 arch/x86/kernel/apic/probe_32.c       |   17 +----------------
 arch/x86/kernel/apic/summit_32.c      |   16 +---------------
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    8 +-------
 13 files changed, 33 insertions(+), 118 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 41190ae..9571160 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -598,6 +598,27 @@ extern unsigned int
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
diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
index ff4cf37..f90f0a5 100644
--- a/arch/x86/include/asm/x2apic.h
+++ b/arch/x86/include/asm/x2apic.h
@@ -19,15 +19,6 @@ static int x2apic_apic_id_registered(void)
 	return 1;
 }
 
-/*
- * For now each logical cpu is in its own vector allocation domain.
- */
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
 static void
 __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
 {
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 9f778f0..1349b01 100644
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
@@ -256,12 +242,6 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
@@ -308,7 +288,7 @@ static struct apic apic_physflat =  {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= physflat_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	/* not needed, but shouldn't hurt: */
 	.init_apic_ldr			= flat_init_apic_ldr,
 
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index fc680d1..4cc0b77 100644
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
index 6d78c8f..9a37915 100644
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
index 142f5c2..d36b01c 100644
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
index e42d1d3b9..ebfca02 100644
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
@@ -704,7 +689,7 @@ static struct apic __refdata apic_es7000 = {
 	.check_apicid_used		= es7000_check_apicid_used,
 	.check_apicid_present		= es7000_check_apicid_present,
 
-	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.vector_allocation_domain	= flat_vector_allocation_domain,
 	.init_apic_ldr			= es7000_init_apic_ldr,
 
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 00d2422..3c9cb77 100644
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
index 0ac67ed..23a2320 100644
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
index fea000b..99bdf1f 100644
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
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 9edc1a0..636d97c 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -225,7 +225,7 @@ static struct apic apic_x2apic_cluster = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= x2apic_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index beab139..a1fb7e2 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -105,7 +105,7 @@ static struct apic apic_x2apic_phys = {
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
-	.vector_allocation_domain	= x2apic_vector_allocation_domain,
+	.vector_allocation_domain	= default_vector_allocation_domain,
 	.init_apic_ldr			= init_x2apic_ldr,
 
 	.ioapic_phys_id_map		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index a77b75c..4c367f3 100644
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
