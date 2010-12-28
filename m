Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0L1LtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:49:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0L1LtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VT8iYLA5xkDsro/fiw3/Vh0RFeJtctf+HiW4/CDBONroA568+4UMKZ5VzrYffXeVRt
         rPvYSGHmjHgugxgPwHMaT+Y73E9mDL4ha5+iLZD6Cwu76YH+Iop1tFkbvT1jZkbSY51p
         ycB/7viqj6DVEtEzgd6j6HU+EVWh7nUZ40lkw=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/16] x86: Replace cpu_2_logical_apicid[] with early percpu variable
Date: Tue, 28 Dec 2010 12:48:37 +0100
Message-Id: <1293536929-31683-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike x86_64, on x86_32, the mapping from cpu to logical apicid may
vary depending on apic in use.  cpu_2_logical_apicid[] array is used
for this mapping.  Replace it with early percpu variable
x86_cpu_to_logical_apicid to make it better aligned with other
mappings.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/apic.h      |    4 ----
 arch/x86/include/asm/smp.h       |    3 +++
 arch/x86/kernel/apic/apic.c      |   11 +++++++++++
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 arch/x86/kernel/apic/numaq_32.c  |    2 +-
 arch/x86/kernel/apic/summit_32.c |    4 ++--
 arch/x86/kernel/setup_percpu.c   |    7 +++++++
 arch/x86/kernel/smpboot.c        |    7 ++-----
 8 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5e3969c..eb139ec 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -595,8 +595,4 @@ extern int default_check_phys_apicid_present(int phys_apicid);
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_X86_32
-extern u8 cpu_2_logical_apicid[NR_CPUS];
-#endif
-
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4c2f63c..dc7c46a 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -38,6 +38,9 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_32)
+DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
+#endif
 
 /* Static state in head.S used to set up a CPU */
 extern struct {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c0f6426..ba78b1e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -79,6 +79,17 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #ifdef CONFIG_X86_32
+
+#ifdef CONFIG_SMP
+/*
+ * On x86_32, the mapping between cpu and logical apicid may vary
+ * depending on apic in use.  The following early percpu variable is
+ * used for the mapping.  This is where the behaviors of x86_64 and 32
+ * actually diverge.  Let's keep it ugly for now.
+ */
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
+#endif
+
 /*
  * Knob to control our willingness to enable the local APIC.
  *
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 8593582..7cb73e1 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -534,7 +534,7 @@ static int es7000_cpu_to_logical_apicid(int cpu)
 #ifdef CONFIG_SMP
 	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
+	return early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 #else
 	return logical_smp_processor_id();
 #endif
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 960f26a..4ed90c4 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -377,7 +377,7 @@ static inline int numaq_cpu_to_logical_apicid(int cpu)
 {
 	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
+	return early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 9b41926..82cfc3e 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -206,7 +206,7 @@ static void summit_init_apic_ldr(void)
 
 	/* Create logical APIC IDs by counting CPUs already in cluster. */
 	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
-		lid = cpu_2_logical_apicid[i];
+		lid = early_per_cpu(x86_cpu_to_logical_apicid, i);
 		if (lid != BAD_APICID && APIC_CLUSTER(lid) == my_cluster)
 			++count;
 	}
@@ -247,7 +247,7 @@ static inline int summit_cpu_to_logical_apicid(int cpu)
 #ifdef CONFIG_SMP
 	if (cpu >= nr_cpu_ids)
 		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
+	return early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 #else
 	return logical_smp_processor_id();
 #endif
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 002b796..b5147f0 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
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
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0b32f17..eb04f30 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -165,9 +165,6 @@ static void unmap_cpu_to_node(int cpu)
 #endif
 
 #ifdef CONFIG_X86_32
-u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
-					{ [0 ... NR_CPUS-1] = BAD_APICID };
-
 static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
@@ -177,13 +174,13 @@ static void map_cpu_to_logical_apicid(void)
 	if (!node_online(node))
 		node = first_online_node;
 
-	cpu_2_logical_apicid[cpu] = apicid;
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = apicid;
 	map_cpu_to_node(cpu, node);
 }
 
 void numa_remove_cpu(int cpu)
 {
-	cpu_2_logical_apicid[cpu] = BAD_APICID;
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = BAD_APICID;
 	unmap_cpu_to_node(cpu);
 }
 #else
-- 
1.7.1

