Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1JYLuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:50:07 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:58631 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab1JYLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:50:06 -0400
Message-ID: <4EA6A265.1080506@scalemp.com>
Date: Tue, 25 Oct 2011 13:49:57 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: [PATCH] APICID: Avoid false sharing on the read mostly x86_cpu_to_apicid
References: <4EA66960.7050907@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274367@VMBX108.ihostexchange.net>
In-Reply-To: <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274367@VMBX108.ihostexchange.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid false sharing on the read mostly x86_cpu_to_apicid by moving it to
__read_mostly section.
The per-cpu area is write and read and this symbol shows up high on ipi
intensive/x86_cpu_to_apicid load.

Signed-off-by: Eial Czerwacki<eial@scalemp.com>
Signed-off-by: Shai Fultheim<shai@scalemp.com>
Author: Ravikiran Thirumalai<kiran@scalex86.org>
---

Index: b/arch/x86/include/asm/smp.h
===================================================================
--- a/arch/x86/include/asm/smp.h	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/include/asm/smp.h	2010-06-02 15:59:21.000000000 -0700
@@ -36,7 +36,8 @@ static inline struct cpumask *cpu_core_m
   	return per_cpu(cpu_core_map, cpu);
   }

-DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
+extern u16 x86_cpu_to_apicid[NR_CPUS];
+
   DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);

   /* Static state in head.S used to set up a CPU */
@@ -142,7 +143,7 @@ void native_send_call_func_ipi(const str
   void native_send_call_func_single_ipi(int cpu);

   void smp_store_cpu_info(int id);
-#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
+#define cpu_physical_id(cpu)	x86_cpu_to_apicid[cpu]

   /* We don't mark CPUs online until __cpu_up(), so we need another measure */
   static inline int num_booting_cpus(void)
Index: b/arch/x86/kernel/acpi/boot.c
===================================================================
--- a/arch/x86/kernel/acpi/boot.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/kernel/acpi/boot.c	2010-06-02 15:59:21.000000000 -0700
@@ -568,7 +568,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);

   int acpi_unmap_lsapic(int cpu)
   {
-	per_cpu(x86_cpu_to_apicid, cpu) = -1;
+	x86_cpu_to_apicid[cpu] = -1;
   	set_cpu_present(cpu, false);
   	num_processors--;

Index: b/arch/x86/kernel/apic/apic.c
===================================================================
--- a/arch/x86/kernel/apic/apic.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/kernel/apic/apic.c	2010-06-02 15:59:21.000000000 -0700
@@ -78,9 +78,8 @@ physid_mask_t phys_cpu_present_map;
   /*
    * Map cpu index to physical APIC ID
    */
-DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
+u16 x86_cpu_to_apicid[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = BAD_APICID };
   DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
   EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);

   #ifdef CONFIG_X86_32
@@ -1248,7 +1247,7 @@
   	 * proper NUMA affinity.
   	 */
   	if (apic->x86_32_numa_cpu_node)
-		set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
+		set_apicid_to_node(x86_cpu_to_apicid[cpu],
   				   apic->x86_32_numa_cpu_node(cpu));
   #endif

@@ -1916,7 +1915,7 @@ void __cpuinit generic_processor_info(in
   		max_physical_apicid = apicid;

   #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
-	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
+	x86_cpu_to_apicid[cpu] = apicid;
   	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
   #endif

Index: b/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- a/arch/x86/kernel/apic/apic_flat_64.c	2010-06-02 15:59:21.000000000 -0700
+++ b/arch/x86/kernel/apic/apic_flat_64.c	2010-06-02 16:49:32.000000000 -0700
@@ -294,7 +294,7 @@ static unsigned int physflat_cpu_mask_to
   	 */
   	cpu = cpumask_first(cpumask);
   	if ((unsigned)cpu<   nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
+		return x86_cpu_to_apicid[cpu];
   	else
   		return BAD_APICID;
   }
@@ -314,7 +314,7 @@ c(const st
   		if (cpumask_test_cpu(cpu, cpu_online_mask))
   			break;
   	}
-	return per_cpu(x86_cpu_to_apicid, cpu);
+	return x86_cpu_to_apicid[cpu];
   }

   static int physflat_probe(void)

Index: b/arch/x86/kernel/apic/ipi.c
===================================================================
--- a/arch/x86/kernel/apic/ipi.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/kernel/apic/ipi.c	2010-06-02 15:59:21.000000000 -0700
@@ -31,8 +31,8 @@ void default_send_IPI_mask_sequence_phys
   	 */
   	local_irq_save(flags);
   	for_each_cpu(query_cpu, mask) {
-		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
-				query_cpu), vector, APIC_DEST_PHYSICAL);
+		__default_send_IPI_dest_field(x86_cpu_to_apicid[query_cpu],
+				vector, APIC_DEST_PHYSICAL);
   	}
   	local_irq_restore(flags);
   }
@@ -50,8 +50,8 @@ void default_send_IPI_mask_allbutself_ph
   	for_each_cpu(query_cpu, mask) {
   		if (query_cpu == this_cpu)
   			continue;
-		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
-				 query_cpu), vector, APIC_DEST_PHYSICAL);
+		__default_send_IPI_dest_field(x86_cpu_to_apicid[query_cpu],
+				 vector, APIC_DEST_PHYSICAL);
   	}
   	local_irq_restore(flags);
   }
@@ -143,7 +143,7 @@ static int convert_apicid_to_cpu(int api
   	int i;

   	for_each_possible_cpu(i) {
-		if (per_cpu(x86_cpu_to_apicid, i) == apic_id)
+		if (x86_cpu_to_apicid[i] == apic_id)
   			return i;
   	}
   	return -1;
Index: b/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- a/arch/x86/kernel/apic/x2apic_phys.c	2010-06-02 15:59:21.000000000 -0700
+++ b/arch/x86/kernel/apic/x2apic_phys.c	2010-06-02 15:59:21.000000000 -0700
@@ -103,7 +103,7 @@ static void x2apic_send_IPI_allbutself(i
   	for_each_cpu(query_cpu) {
   		if (apic_dest == APIC_DEST_ALLBUT&&   query_cpu == this_cpu)
   			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+		__x2apic_send_IPI_dest(x86_cpu_to_apicid[query_cpu],
   				       vector, APIC_DEST_PHYSICAL);
   	}
   	local_irq_restore(flags);
@@ -128,7 +128,7 @@ static unsigned int x2apic_cpu_mask_to_a
   	int cpu = cpumask_first(cpumask);

   	if ((unsigned)cpu<   nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
+		return x86_cpu_to_apicid[cpu];
   	else
   		return BAD_APICID;
   }
@@ -149,7 +149,7 @@ x2apic_cpu_mask_to_apicid_and(const stru
   			break;
   	}

-	return per_cpu(x86_cpu_to_apicid, cpu);
+	return x86_cpu_to_apicid[cpu];
   }

   static void init_x2apic_ldr(void)
Index: b/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- a/arch/x86/kernel/apic/x2apic_uv_x.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c	2010-06-02 15:59:21.000000000 -0700
@@ -135,7 +135,7 @@ static void uv_send_IPI_one(int cpu, int
   	unsigned long apicid;
   	int pnode;

-	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	apicid = x86_cpu_to_apicid[cpu];
   	pnode = uv_apicid_to_pnode(apicid);
   	uv_hub_send_ipi(pnode, apicid, vector);
   }
@@ -193,7 +193,7 @@ static unsigned int uv_cpu_mask_to_apici
   	int cpu = cpumask_first(cpumask);

   	if ((unsigned)cpu<   nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
+		return x86_cpu_to_apicid[cpu] | uv_apicid_hibits;
   	else
   		return BAD_APICID;
   }
@@ -213,6 +213,6 @@ uv_cpu_mask_to_apicid_and(const struct c
   		if (cpumask_test_cpu(cpu, cpu_online_mask))
   			break;
   	}
-	return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
+	return return x86_cpu_to_apicid[cpu] | uv_apicid_hibits;
   }

@@ -608,7 +608,7 @@ void __init uv_system_init(void)
   	uv_rtc_init();

   	for_each_present_cpu(cpu) {
-		int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+		int apicid = x86_cpu_to_apicid[cpu];

   		nid = cpu_to_node(cpu);
   		/*

Index: b/arch/x86/kernel/setup_percpu.c
===================================================================
--- a/arch/x86/kernel/setup_percpu.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/kernel/setup_percpu.c	2010-06-02 15:59:21.000000000 -0700
@@ -225,8 +225,6 @@ void __init setup_per_cpu_areas(void)
   		 * gone.
   		 */
   #ifdef CONFIG_X86_LOCAL_APIC
-		per_cpu(x86_cpu_to_apicid, cpu) =
-			early_per_cpu_map(x86_cpu_to_apicid, cpu);
   		per_cpu(x86_bios_cpu_apicid, cpu) =
   			early_per_cpu_map(x86_bios_cpu_apicid, cpu);
   #endif
@@ -249,7 +247,6 @@ void __init setup_per_cpu_areas(void)

   	/* indicate the early static arrays will soon be gone */
   #ifdef CONFIG_X86_LOCAL_APIC
-	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
   	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
   #endif
   #if defined(CONFIG_X86_64)&&   defined(CONFIG_NUMA)
Index: b/arch/x86/kernel/smpboot.c
===================================================================
--- a/arch/x86/kernel/smpboot.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/kernel/smpboot.c	2010-06-02 15:59:21.000000000 -0700
@@ -818,7 +818,7 @@ do_rest:
   		cpumask_clear_cpu(cpu, cpu_initialized_mask);

   		set_cpu_present(cpu, false);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
+		x86_cpu_to_apicid[cpu] = BAD_APICID;
   	}

   	/* mark "stuck" area as not stuck */
Index: b/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- a/arch/x86/platform/uv/tlb_uv.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/platform/uv/tlb_uv.c	2010-06-02 15:59:21.000000000 -0700
@@ -55,7 +55,7 @@ static int __init blade_to_first_uvhub(

   	for_each_present_cpu(cpu)
   		if (uvhub == uv_cpu_to_blade_id(cpu))
-			return per_cpu(x86_cpu_to_apicid, cpu);
+			return x86_cpu_to_apicid[cpu];
   	return -1;
   }

Index: b/arch/x86/mm/numa.c
===================================================================
--- a/arch/x86/mm/numa.c	2010-06-01 09:56:03.000000000 -0700
+++ b/arch/x86/mm/numa.c	2010-06-02 16:19:04.000000000 -0700
@@ -62,7 +62,7 @@ s16 __apicid_to_node[MAX_LOCAL_APIC] __c

   int __cpuinit numa_cpu_node(int cpu)
   {
-	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+	int apicid = x86_cpu_to_apicid[cpu];

   	if (apicid != BAD_APICID)
   		return __apicid_to_node[apicid];
@@ -694,9 +694,6 @@ static __init int find_near_online_node(
   void __init init_cpu_to_node(void)
   {
   	int cpu;
-	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-
-	BUG_ON(cpu_to_apicid == NULL);

   	for_each_possible_cpu(cpu) {
   		int node = numa_cpu_node(cpu);



