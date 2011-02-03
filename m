Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1BCVEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:04:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59631 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1BCVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=X/0vchotI37pIoUvacPpDIC9ab7Wa6ANOsaFfN5SSFoK1owxkIfvnumtVOaGa/h98b
         rqYRAbW9hhSS5Mgi8OI6zy/2cXn/VMznh6NiqsZbJClA6fhHCE2Gh7xf8ly+gLwStQbq
         niPUYRQB3oyD8WKOtE0eG0YrVtRDc0vpdbNm0=
Message-ID: <4D4B183F.4080108@gmail.com>
Date: Fri, 04 Feb 2011 00:03:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [RFC 2/2 -tip/master] x86, x2apic: Move the common bits of physical,
 cluster modes to x2apic.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate code duplication.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/x2apic.h         |   64 +++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |   70 +---------------------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   68 +++------------------------------
 3 files changed, 75 insertions(+), 127 deletions(-)

Index: tip-linux-2.6/arch/x86/include/asm/x2apic.h
===================================================================
--- /dev/null
+++ tip-linux-2.6/arch/x86/include/asm/x2apic.h
@@ -0,0 +1,64 @@
+/*
+ * Common bits for X2APIC cluster/physical modes
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
+ * need to use more than cpu 0, because we need more vectors
+ * when MSI-X are used
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
+ * for now each logical cpu is in its own vector allocation domain.
+ */
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+static void __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+{
+	unsigned long cfg = __prepare_ICR(0, vector, dest);
+
+	native_x2apic_icr_write(cfg, apicid);
+}
+
+static unsigned int x2apic_get_apic_id(unsigned long x)
+{
+	return x;
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
@@ -8,7 +8,7 @@
 #include <linux/cpu.h>

 #include <asm/smp.h>
-#include <asm/apic.h>
+#include <asm/x2apic.h>
 #include <asm/ipi.h>

 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
@@ -20,37 +20,6 @@ static int x2apic_acpi_madt_oem_check(ch
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
@@ -123,11 +92,6 @@ static void x2apic_send_IPI_all(int vect
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
@@ -188,32 +152,6 @@ static void x2apic_propagate_cpu_cluster
 	}
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
 	int cpu = smp_processor_id();
@@ -294,11 +232,11 @@ struct apic apic_x2apic_cluster = {
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
@@ -7,7 +7,7 @@
 #include <linux/dmar.h>

 #include <asm/smp.h>
-#include <asm/apic.h>
+#include <asm/x2apic.h>
 #include <asm/ipi.h>

 int x2apic_phys;
@@ -27,34 +27,6 @@ static int x2apic_acpi_madt_oem_check(ch
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
@@ -81,10 +53,10 @@ static void

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
@@ -112,11 +84,6 @@ static void x2apic_send_IPI_all(int vect
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
@@ -149,32 +116,11 @@ x2apic_cpu_mask_to_apicid_and(const stru
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
@@ -203,8 +149,8 @@ struct apic apic_x2apic_phys = {
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,

-	.get_apic_id			= x2apic_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,

 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
