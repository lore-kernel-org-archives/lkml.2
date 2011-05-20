Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab1ETNm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:42:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:36169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934137Ab1ETNmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:42:55 -0400
Date: Fri, 20 May 2011 13:42:37 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Message-ID: <tip-79deb8e511bd6fc8e40add4da75b19df085d9453@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110519234637.591426753@sbsiddha-MOBL3.sc.intel.com>
References: <20110519234637.591426753@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, x2apic: Move the common bits to x2apic.h
Git-Commit-ID: 79deb8e511bd6fc8e40add4da75b19df085d9453
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:42:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79deb8e511bd6fc8e40add4da75b19df085d9453
Gitweb:     http://git.kernel.org/tip/79deb8e511bd6fc8e40add4da75b19df085d9453
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Thu, 19 May 2011 16:45:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:41:11 +0200

x86, x2apic: Move the common bits to x2apic.h

To eliminate code duplication.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: steiner@sgi.com
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110519234637.591426753@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/x2apic.h         |   62 ++++++++++++++++++++++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |   71 ++-------------------------------
 arch/x86/kernel/apic/x2apic_phys.c    |   60 +--------------------------
 3 files changed, 69 insertions(+), 124 deletions(-)

diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
new file mode 100644
index 0000000..6bf5b8e
--- /dev/null
+++ b/arch/x86/include/asm/x2apic.h
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
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 4dfe936..f7875d9 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -8,8 +8,7 @@
 #include <linux/cpu.h>
 
 #include <asm/smp.h>
-#include <asm/apic.h>
-#include <asm/ipi.h>
+#include <asm/x2apic.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
@@ -20,37 +19,6 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
@@ -128,11 +96,6 @@ static void x2apic_send_IPI_all(int vector)
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
@@ -165,32 +128,6 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
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
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 6ef49e3..78c8f33 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -7,8 +7,7 @@
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
-#include <asm/apic.h>
-#include <asm/ipi.h>
+#include <asm/x2apic.h>
 
 int x2apic_phys;
 
@@ -27,34 +26,6 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
@@ -97,11 +68,6 @@ static void x2apic_send_IPI_all(int vector)
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
@@ -134,26 +100,6 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
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
