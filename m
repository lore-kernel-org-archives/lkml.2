Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0KZWb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:31:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34999 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KZWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mzr6Re4001zMeRqX+d9PlV9g/KfXaXubxSwQVCV+TR0JK1Uh4g3sBbbOn+fpsusuC6
         eZWB6AlXDhUFpLHyezSeBCIkyVrkc9if9ohEX3mgFR/yyi+aLAWlYwdFP+AVL5/aCDK4
         MtSh11/9Lo8hKEmuDtq5NO/ulfNsfFo6xKr1M=
Date: Sat, 27 Nov 2010 01:31:22 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -tip] x86, apic: x2apic - Move common bits to a header file
Message-ID: <20101126223121.GD5620@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
---

 Suresh, I didn't managed still to implement smart cluster mode,
but I guess even such code folding is a good thing, right?
Please review.

 arch/x86/include/asm/x2apic.h         |   59 ++++++++++++++++++++++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |   70 +---------------------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   59 +---------------------------
 3 files changed, 66 insertions(+), 122 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/x2apic.h
=====================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/include/asm/x2apic.h
@@ -0,0 +1,59 @@
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
+	/* we're ready to send the IPI */
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
+#endif /* _ASM_X86_X2APIC_H */
Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_cluster.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_cluster.c
@@ -8,6 +8,7 @@
 
 #include <asm/smp.h>
 #include <asm/apic.h>
+#include <asm/x2apic.h>
 #include <asm/ipi.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
@@ -18,37 +19,6 @@ static int x2apic_acpi_madt_oem_check(ch
 }
 
 /*
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
-/*
  * for now, we send the IPI's one by one in the cpumask.
  * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
@@ -114,11 +84,6 @@ static void x2apic_send_IPI_all(int vect
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
@@ -151,32 +116,6 @@ x2apic_cpu_mask_to_apicid_and(const stru
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
 	int cpu = smp_processor_id();
@@ -185,7 +124,6 @@ static void init_x2apic_ldr(void)
 }
 
 struct apic apic_x2apic_cluster = {
-
 	.name				= "cluster x2apic",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
@@ -213,11 +151,11 @@ struct apic apic_x2apic_cluster = {
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
Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_phys.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_phys.c
@@ -8,6 +8,7 @@
 
 #include <asm/smp.h>
 #include <asm/apic.h>
+#include <asm/x2apic.h>
 #include <asm/ipi.h>
 
 int x2apic_phys;
@@ -27,34 +28,6 @@ static int x2apic_acpi_madt_oem_check(ch
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
@@ -112,11 +85,6 @@ static void x2apic_send_IPI_all(int vect
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
@@ -149,32 +117,11 @@ x2apic_cpu_mask_to_apicid_and(const stru
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
@@ -205,8 +152,8 @@ struct apic apic_x2apic_phys = {
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= x2apic_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
