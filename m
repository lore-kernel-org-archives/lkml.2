Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab1D3RVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:21:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58883 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1D3RUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=x96scHzFd8Fu48LNXJm+QT0z7a7xoweoESBhxRg4HJqO4ZOE5U+VcPC6RZG9ZSoilm
         nYYHdbHqYpLPEnn855ExRPYAOBb3LXC1ZnTduMi1aouFsZnYTgQODRdLQ79fK7FBMJxf
         gwKUDviJOG1+aDVuVj2I+TQRv3kMWn62a3Fg0=
Message-Id: <20110430172025.877190057@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 30 Apr 2011 21:15:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/2] x86, x2apic: Move the common bits of physical and cluster modes to x2apic.h v4
References: <20110430171459.685415696@openvz.org>
Content-Disposition: inline; filename=x86-x2apic-merge-phys-cluster-v4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate code duplication.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/x2apic.h         |   64 ++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |   71 +---------------------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   71 +++-------------------------------
 3 files changed, 76 insertions(+), 130 deletions(-)

Index: tip-linux-2.6/arch/x86/include/asm/x2apic.h
===================================================================
--- /dev/null
+++ tip-linux-2.6/arch/x86/include/asm/x2apic.h
@@ -0,0 +1,64 @@
+/*
+ * Common bits for X2APIC cluster/physical modes.
+ */
+
+#ifndef _ASM_X86_X2APIC_H
+#define _ASM_X86_X2APIC_H
+
+#include <asm/apic.h>
+#include <asm/ipi.h>
+#include <linux/cpumask.h>
+
+/*
+ * Need to use more than cpu 0, because we need more vectors
+ * when MSI-X are used.
+ */
+static const struct cpumask *x2apic_target_cpus(void)
+{
+	return cpu_online_mask;
+}
+
+static int x2apic_apic_id_registered(void)
+{
+	return 1;
+}
+
+/*
+ * For now each logical cpu is in its own vector allocation domain.
+ */
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+static void
+__x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+{
+	unsigned long cfg = __prepare_ICR(0, vector, dest);
+	native_x2apic_icr_write(cfg, apicid);
+}
+
+static unsigned int x2apic_get_apic_id(unsigned long id)
+{
+	return id;
+}
+
+static unsigned long x2apic_set_apic_id(unsigned int id)
+{
+	return id;
+}
+
+static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
+{
+	return initial_apicid >> index_msb;
+}
+
+static void x2apic_send_IPI_self(int vector)
+{
+	apic_write(APIC_SELF_IPI, vector);
+}
+
+void x2apic_init_cpu_notifier(void);
+
+#endif /* _ASM_X86_X2APIC_H */
Index: tip-linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ tip-linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
@@ -8,8 +8,7 @@
 #include <linux/cpu.h>
 
 #include <asm/smp.h>
-#include <asm/apic.h>
-#include <asm/ipi.h>
+#include <asm/x2apic.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
@@ -20,37 +19,6 @@ static int x2apic_acpi_madt_oem_check(ch
 	return x2apic_enabled();
 }
 
-/*
- * need to use more than cpu 0, because we need more vectors when
- * MSI-X are used.
- */
-static const struct cpumask *x2apic_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
-/*
- * for now each logical cpu is in its own vector allocation domain.
- */
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
-static void
-__x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
-{
-	unsigned long cfg;
-
-	cfg = __prepare_ICR(0, vector, dest);
-
-	/*
-	 * send the IPI.
-	 */
-	native_x2apic_icr_write(cfg, apicid);
-}
-
 static inline u32 x2apic_cluster(int cpu)
 {
 	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
@@ -127,11 +95,6 @@ static void x2apic_send_IPI_all(int vect
 	__x2apic_send_IPI_mask(cpu_online_mask, vector, 0);
 }
 
-static int x2apic_apic_id_registered(void)
-{
-	return 1;
-}
-
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	/*
@@ -165,32 +128,6 @@ x2apic_cpu_mask_to_apicid_and(const stru
 }
 
 
-static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
-{
-	unsigned int id;
-
-	id = x;
-	return id;
-}
-
-static unsigned long set_apic_id(unsigned int id)
-{
-	unsigned long x;
-
-	x = id;
-	return x;
-}
-
-static int x2apic_cluster_phys_pkg_id(int initial_apicid, int index_msb)
-{
-	return initial_apicid >> index_msb;
-}
-
-static void x2apic_send_IPI_self(int vector)
-{
-	apic_write(APIC_SELF_IPI, vector);
-}
-
 static void init_x2apic_ldr(void)
 {
 	unsigned int this_cpu = smp_processor_id();
@@ -288,11 +225,11 @@ struct apic apic_x2apic_cluster = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= x2apic_cluster_phys_pkg_id,
+	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= x2apic_cluster_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
Index: tip-linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- tip-linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ tip-linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
@@ -7,8 +7,7 @@
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
-#include <asm/apic.h>
-#include <asm/ipi.h>
+#include <asm/x2apic.h>
 
 int x2apic_phys;
 
@@ -27,34 +26,6 @@ static int x2apic_acpi_madt_oem_check(ch
 		return 0;
 }
 
-/*
- * need to use more than cpu 0, because we need more vectors when
- * MSI-X are used.
- */
-static const struct cpumask *x2apic_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
-static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
-				   unsigned int dest)
-{
-	unsigned long cfg;
-
-	cfg = __prepare_ICR(0, vector, dest);
-
-	/*
-	 * send the IPI.
-	 */
-	native_x2apic_icr_write(cfg, apicid);
-}
-
 static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	unsigned long query_cpu;
@@ -71,7 +42,7 @@ static void x2apic_send_IPI_mask(const s
 }
 
 static void
- x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	unsigned long this_cpu = smp_processor_id();
 	unsigned long query_cpu;
@@ -81,10 +52,10 @@ static void
 
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_apicid, query_cpu),
-				vector, APIC_DEST_PHYSICAL);
+		if (query_cpu == this_cpu)
+			continue;
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
@@ -112,11 +83,6 @@ static void x2apic_send_IPI_all(int vect
 	x2apic_send_IPI_mask(cpu_online_mask, vector);
 }
 
-static int x2apic_apic_id_registered(void)
-{
-	return 1;
-}
-
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	/*
@@ -149,32 +115,11 @@ x2apic_cpu_mask_to_apicid_and(const stru
 	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
-static unsigned int x2apic_phys_get_apic_id(unsigned long x)
-{
-	return x;
-}
-
-static unsigned long set_apic_id(unsigned int id)
-{
-	return id;
-}
-
-static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
-{
-	return initial_apicid >> index_msb;
-}
-
-static void x2apic_send_IPI_self(int vector)
-{
-	apic_write(APIC_SELF_IPI, vector);
-}
-
 static void init_x2apic_ldr(void)
 {
 }
 
 struct apic apic_x2apic_phys = {
-
 	.name				= "physical x2apic",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
@@ -203,8 +148,8 @@ struct apic apic_x2apic_phys = {
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= x2apic_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,

