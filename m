Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0KLJjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:39:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:51276 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0KLJjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:39:15 -0500
Message-ID: <4CDD0B1F.4060701@kernel.org>
Date: Fri, 12 Nov 2010 10:38:39 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: [PATCH UPDATED 4/9] x86: Initialize 32bit logical apicid mapping
 early during boot
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-5-git-send-email-tj@kernel.org>
In-Reply-To: <1289473363-29440-5-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Nov 2010 09:38:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_32, non-standard logical apicid mapping can be used by
different NUMA setups and the mapping is queried while bringing up
each CPU using apic->cpu_to_logical_apicid() to build
cpu_2_logical_apicid[] array.  The logical apicid is then used to
deliver IPIs and determine NUMA configuration.

Unfortunately, initializing at SMP bring up is too late for percpu
setup making static percpu variables setup w/o considering NUMA.  This
also is different from how x86_64 is configured making the code
difficult to follow and maintain.

This patch updates logical apicid mapping handling such that,

* early_percpu variable x86_cpu_to_logical_apicid replaces
  cpu_2_logical_apicid[].

* apic->cpu_to_logical_apicid() is called once during get_smp_config()
  and the output is recorded in x86_cpu_to_logical_apicid.

* apic->cpu_to_logical_apicid() is allowed to return BAD_APICID if it
  can't determine the value that early during boot.  In this case, the
  mapping will be initialized during SMP bring up by reading APIC LDR
  as before.

- Brian Gerst spotted that setup_per_cpu_areas() was not copying the
  early x86_cpu_to_logical_apicid to the permanent percpu area and
  es7000_32 is using per_cpu() instead of early_per_cpu(), which in
  itself is not incorrect as they're never used before setup_per_cpu()
  but still confusing.  Both updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
---
Updated as per Brian's comment.  The rest of the patchset apply okay
on top of this change.  The git tree is updated accordingly.

Thanks.

 arch/x86/include/asm/apic.h      |   18 +++++++++++++-----
 arch/x86/include/asm/smp.h       |    3 +++
 arch/x86/kernel/apic/apic.c      |   36 ++++++++++++++++++++++++++++--------
 arch/x86/kernel/apic/bigsmp_32.c |   26 ++++++++++++++------------
 arch/x86/kernel/apic/es7000_32.c |   27 ++++++++++-----------------
 arch/x86/kernel/apic/ipi.c       |    8 ++++----
 arch/x86/kernel/apic/numaq_32.c  |   15 +++++++--------
 arch/x86/kernel/apic/summit_32.c |   36 ++++++++++++++++--------------------
 arch/x86/kernel/setup_percpu.c   |    7 +++++++
 arch/x86/kernel/smpboot.c        |   10 +++-------
 10 files changed, 105 insertions(+), 81 deletions(-)

Index: work/arch/x86/kernel/smpboot.c
===================================================================
--- work.orig/arch/x86/kernel/smpboot.c
+++ work/arch/x86/kernel/smpboot.c
@@ -165,25 +165,21 @@ static void unmap_cpu_to_node(int cpu)
 #endif

 #ifdef CONFIG_X86_32
-u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
-					{ [0 ... NR_CPUS-1] = BAD_APICID };
-
 static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
-	int apicid = logical_smp_processor_id();
-	int node = apic->apicid_to_node(apicid);
+	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	int node;

+	node = apic->apicid_to_node(logical_apicid);
 	if (!node_online(node))
 		node = first_online_node;

-	cpu_2_logical_apicid[cpu] = apicid;
 	map_cpu_to_node(cpu, node);
 }

 void numa_remove_cpu(int cpu)
 {
-	cpu_2_logical_apicid[cpu] = BAD_APICID;
 	unmap_cpu_to_node(cpu);
 }
 #else
Index: work/arch/x86/include/asm/apic.h
===================================================================
--- work.orig/arch/x86/include/asm/apic.h
+++ work/arch/x86/include/asm/apic.h
@@ -299,6 +299,19 @@ struct apic {
 	unsigned long (*check_apicid_present)(int apicid);

 	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	/*
+	 * x86_32 specific method called very early during boot from
+	 * get_smp_config().  It should return the logical apicid.
+	 * x86_[bios]_cpu_to_apicid is initialized before this
+	 * function is called.
+	 *
+	 * If logical apicid can't be determined that early, the
+	 * function may return BAD_APICID.  Logical apicid will be
+	 * automatically configured after init_apic_ldr() while
+	 * bringing up CPUs.  Note that NUMA affinity won't work
+	 * properly during early boot in this case.
+	 */
+	int (*cpu_to_logical_apicid)(int cpu);
 	void (*init_apic_ldr)(void);

 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
@@ -306,7 +319,6 @@ struct apic {
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid);
-	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
@@ -594,8 +606,4 @@ extern int default_check_phys_apicid_pre

 #endif /* CONFIG_X86_LOCAL_APIC */

-#ifdef CONFIG_X86_32
-extern u8 cpu_2_logical_apicid[NR_CPUS];
-#endif
-
 #endif /* _ASM_X86_APIC_H */
Index: work/arch/x86/kernel/apic/apic.c
===================================================================
--- work.orig/arch/x86/kernel/apic/apic.c
+++ work/arch/x86/kernel/apic/apic.c
@@ -80,6 +80,11 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_a
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);

 #ifdef CONFIG_X86_32
+
+#ifdef CONFIG_SMP
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
+#endif
+
 /*
  * Knob to control our willingness to enable the local APIC.
  *
@@ -1202,6 +1207,7 @@ static void __cpuinit lapic_setup_esr(vo
  */
 void __cpuinit setup_local_APIC(void)
 {
+	int cpu = smp_processor_id();
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
@@ -1241,6 +1247,19 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	apic->init_apic_ldr();

+#ifdef CONFIG_X86_32
+	/*
+	 * APIC LDR is initialized.  If logical_apicid mapping was
+	 * initialized during get_smp_config(), make sure it matches
+	 * the actual value.
+	 */
+	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
+	/* always use the value from LDR */
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		logical_smp_processor_id();
+#endif
+
 	/*
 	 * Set Task Priority to 'accept all'. We never change this
 	 * later on.
@@ -1343,21 +1362,19 @@ void __cpuinit setup_local_APIC(void)
 	 * TODO: set up through-local-APIC from through-I/O-APIC? --macro
 	 */
 	value = apic_read(APIC_LVT0) & APIC_LVT_MASKED;
-	if (!smp_processor_id() && (pic_mode || !value)) {
+	if (!cpu && (pic_mode || !value)) {
 		value = APIC_DM_EXTINT;
-		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n",
-				smp_processor_id());
+		apic_printk(APIC_VERBOSE, "enabled ExtINT on CPU#%d\n", cpu);
 	} else {
 		value = APIC_DM_EXTINT | APIC_LVT_MASKED;
-		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n",
-				smp_processor_id());
+		apic_printk(APIC_VERBOSE, "masked ExtINT on CPU#%d\n", cpu);
 	}
 	apic_write(APIC_LVT0, value);

 	/*
 	 * only the BP should see the LINT1 NMI signal, obviously.
 	 */
-	if (!smp_processor_id())
+	if (!cpu)
 		value = APIC_DM_NMI;
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
@@ -1369,7 +1386,7 @@ void __cpuinit setup_local_APIC(void)

 #ifdef CONFIG_X86_MCE_INTEL
 	/* Recheck CMCI information after local APIC is up on CPU #0 */
-	if (smp_processor_id() == 0)
+	if (cpu == 0)
 		cmci_recheck();
 #endif
 }
@@ -1967,7 +1984,10 @@ void __cpuinit generic_processor_info(in
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
-
+#ifdef CONFIG_X86_32
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		apic->cpu_to_logical_apicid(cpu);
+#endif
 	set_cpu_possible(cpu, true);
 	set_cpu_present(cpu, true);
 }
Index: work/arch/x86/kernel/apic/bigsmp_32.c
===================================================================
--- work.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ work/arch/x86/kernel/apic/bigsmp_32.c
@@ -45,6 +45,12 @@ static unsigned long bigsmp_check_apicid
 	return 1;
 }

+static int bigsmp_cpu_to_logical_apicid(int cpu)
+{
+	/* on bigsmp, logical apicid is the same as physical */
+	return early_per_cpu(x86_cpu_to_apicid, cpu);
+}
+
 static inline unsigned long calculate_ldr(int cpu)
 {
 	unsigned long val, id;
@@ -93,14 +99,6 @@ static int bigsmp_cpu_present_to_apicid(
 	return BAD_APICID;
 }

-/* Mapping from cpu number to logical apicid */
-static inline int bigsmp_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_physical_id(cpu);
-}
-
 static void bigsmp_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
@@ -115,7 +113,11 @@ static int bigsmp_check_phys_apicid_pres
 /* As we are using single CPU as destination, pick only one CPU here */
 static unsigned int bigsmp_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return bigsmp_cpu_to_logical_apicid(cpumask_first(cpumask));
+	int cpu = cpumask_first(cpumask);
+
+	if (cpu < nr_cpu_ids)
+		return cpu_physical_id(cpu);
+	return BAD_APICID;
 }

 static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
@@ -129,9 +131,9 @@ static unsigned int bigsmp_cpu_mask_to_a
 	 */
 	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
+			return cpu_physical_id(cpu);
 	}
-	return bigsmp_cpu_to_logical_apicid(cpu);
+	return BAD_APICID;
 }

 static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
@@ -214,13 +216,13 @@ struct apic apic_bigsmp = {
 	.check_apicid_present		= bigsmp_check_apicid_present,

 	.vector_allocation_domain	= bigsmp_vector_allocation_domain,
+	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,

 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= bigsmp_apicid_to_node,
-	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
Index: work/arch/x86/kernel/apic/summit_32.c
===================================================================
--- work.orig/arch/x86/kernel/apic/summit_32.c
+++ work/arch/x86/kernel/apic/summit_32.c
@@ -194,11 +194,11 @@ static unsigned long summit_check_apicid
 	return 1;
 }

-static void summit_init_apic_ldr(void)
+/* Mapping from cpu number to logical apicid */
+static int summit_cpu_to_logical_apicid(int cpu)
 {
-	unsigned long val, id;
 	int count = 0;
-	u8 my_id = (u8)hard_smp_processor_id();
+	u8 my_id = early_per_cpu(x86_cpu_to_apicid, cpu);
 	u8 my_cluster = APIC_CLUSTER(my_id);
 #ifdef CONFIG_SMP
 	u8 lid;
@@ -206,7 +206,7 @@ static void summit_init_apic_ldr(void)

 	/* Create logical APIC IDs by counting CPUs already in cluster. */
 	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
-		lid = cpu_2_logical_apicid[i];
+		lid = early_per_cpu(x86_cpu_to_logical_apicid, i);
 		if (lid != BAD_APICID && APIC_CLUSTER(lid) == my_cluster)
 			++count;
 	}
@@ -214,7 +214,15 @@ static void summit_init_apic_ldr(void)
 	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
 	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
 	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
-	id = my_cluster | (1UL << count);
+	return my_cluster | (1UL << count);
+}
+
+static void summit_init_apic_ldr(void)
+{
+	int cpu = smp_processor_id();
+	unsigned long id = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	unsigned long val;
+
 	apic_write(APIC_DFR, SUMMIT_APIC_DFR_VALUE);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
@@ -241,18 +249,6 @@ static int summit_apicid_to_node(int log
 #endif
 }

-/* Mapping from cpu number to logical apicid */
-static inline int summit_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
 static int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
@@ -286,7 +282,7 @@ static unsigned int summit_cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu(cpu, cpumask) {
-		int new_apicid = summit_cpu_to_logical_apicid(cpu);
+		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);

 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			printk("%s: Not a valid mask!\n", __func__);
@@ -301,7 +297,7 @@ static unsigned int summit_cpu_mask_to_a
 static unsigned int summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
-	int apicid = summit_cpu_to_logical_apicid(0);
+	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;

 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
@@ -523,13 +519,13 @@ struct apic apic_summit = {
 	.check_apicid_present		= summit_check_apicid_present,

 	.vector_allocation_domain	= summit_vector_allocation_domain,
+	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.init_apic_ldr			= summit_init_apic_ldr,

 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= summit_apicid_to_node,
-	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
Index: work/arch/x86/include/asm/smp.h
===================================================================
--- work.orig/arch/x86/include/asm/smp.h
+++ work/arch/x86/include/asm/smp.h
@@ -38,6 +38,9 @@ static inline struct cpumask *cpu_core_m

 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_32)
+DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
+#endif

 /* Static state in head.S used to set up a CPU */
 extern struct {
Index: work/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- work.orig/arch/x86/kernel/apic/numaq_32.c
+++ work/arch/x86/kernel/apic/numaq_32.c
@@ -346,6 +346,12 @@ static inline int numaq_apic_id_register
 	return 1;
 }

+static int numaq_cpu_to_logical_apicid(int cpu)
+{
+	/* NUMA-Q firmware set this up but how do I read this from boot CPU? */
+	return BAD_APICID;
+}
+
 static inline void numaq_init_apic_ldr(void)
 {
 	/* Already done in NUMA-Q firmware */
@@ -373,13 +379,6 @@ static inline void numaq_ioapic_phys_id_
 	return physids_promote(0xFUL, retmap);
 }

-static inline int numaq_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
-}
-
 /*
  * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
  * cpu to APIC ID relation to properly interact with the intelligent
@@ -503,13 +502,13 @@ struct apic __refdata apic_numaq = {
 	.check_apicid_present		= numaq_check_apicid_present,

 	.vector_allocation_domain	= numaq_vector_allocation_domain,
+	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.init_apic_ldr			= numaq_init_apic_ldr,

 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
 	.apicid_to_node			= numaq_apicid_to_node,
-	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
Index: work/arch/x86/kernel/apic/ipi.c
===================================================================
--- work.orig/arch/x86/kernel/apic/ipi.c
+++ work/arch/x86/kernel/apic/ipi.c
@@ -73,8 +73,8 @@ void default_send_IPI_mask_sequence_logi
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
 		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
+			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, apic->dest_logical);
 	local_irq_restore(flags);
 }

@@ -92,8 +92,8 @@ void default_send_IPI_mask_allbutself_lo
 		if (query_cpu == this_cpu)
 			continue;
 		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
+			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, apic->dest_logical);
 		}
 	local_irq_restore(flags);
 }
Index: work/arch/x86/kernel/apic/es7000_32.c
===================================================================
--- work.orig/arch/x86/kernel/apic/es7000_32.c
+++ work/arch/x86/kernel/apic/es7000_32.c
@@ -460,11 +460,16 @@ static unsigned long es7000_check_apicid
 	return physid_isset(bit, phys_cpu_present_map);
 }

+static int es7000_cpu_to_logical_apicid(int cpu)
+{
+	return early_per_cpu(x86_bios_cpu_apicid, cpu);
+}
+
 static unsigned long calculate_ldr(int cpu)
 {
-	unsigned long id = per_cpu(x86_bios_cpu_apicid, cpu);
+	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);

-	return SET_APIC_LOGICAL_ID(id);
+	return SET_APIC_LOGICAL_ID(logical_apicid);
 }

 /*
@@ -528,18 +533,6 @@ static void es7000_apicid_to_cpu_present
 	++cpu_id;
 }

-/* Mapping from cpu number to logical apicid */
-static int es7000_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
 static void es7000_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
@@ -561,7 +554,7 @@ static unsigned int es7000_cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu(cpu, cpumask) {
-		int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);

 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			WARN(1, "Not a valid mask!");
@@ -578,7 +571,7 @@ static unsigned int
 es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
-	int apicid = es7000_cpu_to_logical_apicid(0);
+	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;

 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
@@ -650,13 +643,13 @@ struct apic __refdata apic_es7000_cluste
 	.check_apicid_present		= es7000_check_apicid_present,

 	.vector_allocation_domain	= es7000_vector_allocation_domain,
+	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.init_apic_ldr			= es7000_init_apic_ldr_cluster,

 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= es7000_apicid_to_node,
-	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
Index: work/arch/x86/kernel/setup_percpu.c
===================================================================
--- work.orig/arch/x86/kernel/setup_percpu.c
+++ work/arch/x86/kernel/setup_percpu.c
@@ -225,6 +225,10 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(x86_bios_cpu_apicid, cpu) =
 			early_per_cpu_map(x86_bios_cpu_apicid, cpu);
 #endif
+#ifdef CONFIG_X86_32
+		per_cpu(x86_cpu_to_logical_apicid, cpu) =
+			early_per_cpu_map(x86_cpu_to_logical_apicid, cpu);
+#endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) +
@@ -256,6 +260,9 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
 	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
 #endif
+#ifdef CONFIG_X86_32
+	early_per_cpu_ptr(x86_cpu_to_logical_apicid) = NULL;
+#endif
 #if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
