Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1EUA7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:59:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:59145 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1EUA7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="5534118"
Message-Id: <20110521005526.252703851@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 20 May 2011 17:51:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        gorcunov@openvz.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 3/4] x86, apic: cleanup bigsmp apic selection code
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=cleanup_generic_bigsmp_probe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make generic_bigsmp_probe() return struct apic *. This will avoid
exporting apic_bigsmp, which will be consistent with others.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h      |    2 -
 arch/x86/kernel/apic/bigsmp_32.c |    8 ++++++
 arch/x86/kernel/apic/probe_32.c  |   52 +++++++++++++++++----------------------
 3 files changed, 32 insertions(+), 30 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/apic.h
+++ linux-2.6-tip/arch/x86/include/asm/apic.h
@@ -500,7 +500,7 @@ static inline void default_wait_for_init
 	return;
 }
 
-extern void generic_bigsmp_probe(void);
+extern struct apic *generic_bigsmp_probe(void);
 
 
 #ifdef CONFIG_X86_LOCAL_APIC
Index: linux-2.6-tip/arch/x86/kernel/apic/bigsmp_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/bigsmp_32.c
@@ -255,4 +255,12 @@ struct apic apic_bigsmp = {
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
 
+struct apic * __init generic_bigsmp_probe(void)
+{
+	if (probe_bigsmp())
+		return &apic_bigsmp;
+
+	return NULL;
+}
+
 apic_driver(apic_bigsmp);
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
@@ -52,31 +52,6 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-void __init default_setup_apic_routing(void)
-{
-	int version = apic_version[boot_cpu_physical_apicid];
-
-	if (num_possible_cpus() > 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-
-#ifdef CONFIG_X86_BIGSMP
-	generic_bigsmp_probe();
-#endif
-
-	if (apic->setup_apic_routing)
-		apic->setup_apic_routing();
-}
-
 static int default_x86_32_early_logical_apicid(int cpu)
 {
 	return 1 << cpu;
@@ -224,24 +199,43 @@ static int __init parse_apic(char *arg)
 }
 early_param("apic", parse_apic);
 
-void __init generic_bigsmp_probe(void)
+void __init default_setup_apic_routing(void)
 {
+	int version = apic_version[boot_cpu_physical_apicid];
+
+	if (num_possible_cpus() > 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+
 #ifdef CONFIG_X86_BIGSMP
 	/*
-	 * This routine is used to switch to bigsmp mode when
+	 * This is used to switch to bigsmp mode when
 	 * - There is no apic= option specified by the user
 	 * - generic_apic_probe() has chosen apic_default as the sub_arch
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
 	if (!cmdline_apic && apic == &apic_default) {
-		if (apic_bigsmp.probe()) {
-			apic = &apic_bigsmp;
+		struct apic *bigsmp = generic_bigsmp_probe();
+		if (bigsmp) {
+			apic = bigsmp;
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
 			       apic->name);
 		}
 	}
 #endif
+
+	if (apic->setup_apic_routing)
+		apic->setup_apic_routing();
 }
 
 void __init generic_apic_probe(void)


