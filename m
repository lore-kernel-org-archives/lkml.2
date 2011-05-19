Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab1ESXrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:47:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:41779 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235Ab1ESXrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="439399659"
Message-Id: <20110519234637.591426753@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 May 2011 16:45:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com
Subject: [patch 5/6] x86, x2apic: move the common bits to x2apic.h
References: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=move_the_common_bits_of_physical_and_cluster_modes_to_x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

To eliminate code duplication.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/x2apic.h         |   62 +++++++++++++++++++++++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |   71 +---------------------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   60 +---------------------------
 3 files changed, 69 insertions(+), 124 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/x2apic.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/arch/x86/include/asm/x2apic.h
@@ -0,0 +1,62 @@
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
+#endif /* _ASM_X86_X2APIC_H */
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
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
- __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
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
@@ -128,11 +96,6 @@ static void x2apic_send_IPI_all(int vect
 	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
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
 	return per_cpu(x86_cpu_to_logical_apicid, cpu);
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
@@ -298,11 +235,11 @@ struct apic apic_x2apic_cluster = {
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
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
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
 static void
 __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
@@ -97,11 +68,6 @@ static void x2apic_send_IPI_all(int vect
 	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
-static int x2apic_apic_id_registered(void)
-{
-	return 1;
-}
-
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	/*
@@ -134,26 +100,6 @@ x2apic_cpu_mask_to_apicid_and(const stru
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
@@ -196,8 +142,8 @@ struct apic apic_x2apic_phys = {
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= x2apic_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,


