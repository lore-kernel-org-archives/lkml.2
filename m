Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab1EUBAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 21:00:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:46992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab1EUA7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:59:17 -0400
X-ExtLoop1: 1
Message-Id: <20110521005526.341718626@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 20 May 2011 17:51:20 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        gorcunov@openvz.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 4/4] x86, apic: make apic drivers static
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=make_apic_drivers_confined.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apic probe now looks at the apic drivers listed in the .apicdrivers section.
Remove apic_probe[] and make each apic driver static.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h           |    7 -------
 arch/x86/kernel/apic/apic_flat_64.c   |   10 ++++++++--
 arch/x86/kernel/apic/bigsmp_32.c      |    2 +-
 arch/x86/kernel/apic/es7000_32.c      |    4 ++--
 arch/x86/kernel/apic/numaq_32.c       |    4 ++--
 arch/x86/kernel/apic/probe_32.c       |   28 ++--------------------------
 arch/x86/kernel/apic/probe_64.c       |   21 ---------------------
 arch/x86/kernel/apic/summit_32.c      |    2 +-
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    4 +++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
 11 files changed, 23 insertions(+), 65 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/apic.h
+++ linux-2.6-tip/arch/x86/include/asm/apic.h
@@ -478,15 +478,10 @@ static inline unsigned default_get_apic_
 #define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_64
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2apic_cluster;
-extern struct apic apic_x2apic_phys;
 extern int default_acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
 
-extern struct apic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 
 extern int default_cpu_present_to_apicid(int mps_cpu);
@@ -536,8 +531,6 @@ extern struct apic apic_noop;
 
 #ifdef CONFIG_X86_32
 
-extern struct apic apic_default;
-
 static inline int noop_x86_32_early_logical_apicid(int cpu)
 {
 	return BAD_APICID;
Index: linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
@@ -24,6 +24,12 @@
 #include <acpi/acpi_bus.h>
 #endif
 
+static struct apic apic_physflat;
+static struct apic apic_flat;
+
+struct apic __read_mostly *apic = &apic_flat;
+EXPORT_SYMBOL_GPL(apic);
+
 static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 1;
@@ -164,7 +170,7 @@ static int flat_phys_pkg_id(int initial_
 	return initial_apic_id >> index_msb;
 }
 
-struct apic apic_flat =  {
+static struct apic apic_flat =  {
 	.name				= "flat",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
@@ -320,7 +326,7 @@ static int physflat_probe(void)
 	return 0;
 }
 
-struct apic apic_physflat =  {
+static struct apic apic_physflat =  {
 
 	.name				= "physical flat",
 	.probe				= physflat_probe,
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
@@ -23,27 +23,6 @@
 #include <asm/ipi.h>
 #include <asm/setup.h>
 
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2xpic_uv_x;
-extern struct apic apic_x2apic_phys;
-extern struct apic apic_x2apic_cluster;
-
-struct apic __read_mostly *apic = &apic_flat;
-EXPORT_SYMBOL_GPL(apic);
-
-static struct apic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_UV
-	&apic_x2apic_uv_x,
-#endif
-#ifdef CONFIG_X86_X2APIC
-	&apic_x2apic_phys,
-	&apic_x2apic_cluster,
-#endif
-	&apic_physflat,
-	NULL,
-};
-
 static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
@@ -208,7 +208,7 @@ static int x2apic_cluster_probe(void)
 		return 0;
 }
 
-struct apic apic_x2apic_cluster = {
+static struct apic apic_x2apic_cluster = {
 
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_phys.c
@@ -11,6 +11,8 @@
 
 int x2apic_phys;
 
+static struct apic apic_x2apic_phys;
+
 static int set_x2apic_phys_mode(char *arg)
 {
 	x2apic_phys = 1;
@@ -112,7 +114,7 @@ static int x2apic_phys_probe(void)
 	return apic == &apic_x2apic_phys;
 }
 
-struct apic apic_x2apic_phys = {
+static struct apic apic_x2apic_phys = {
 
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -58,6 +58,8 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+static struct apic apic_x2apic_uv_x;
+
 static unsigned long __init uv_early_read_mmr(unsigned long addr)
 {
 	unsigned long val, *mmr;
@@ -331,7 +333,7 @@ static int uv_probe(void)
 	return apic == &apic_x2apic_uv_x;
 }
 
-struct apic __refdata apic_x2apic_uv_x = {
+static struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
 	.probe				= uv_probe,
Index: linux-2.6-tip/arch/x86/kernel/apic/es7000_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/es7000_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/es7000_32.c
@@ -620,7 +620,7 @@ static int es7000_mps_oem_check_cluster(
 }
 
 /* We've been warned by a false positive warning.Use __refdata to keep calm. */
-struct apic __refdata apic_es7000_cluster = {
+static struct apic __refdata apic_es7000_cluster = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
@@ -685,7 +685,7 @@ struct apic __refdata apic_es7000_cluste
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
 
-struct apic __refdata apic_es7000 = {
+static struct apic __refdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
Index: linux-2.6-tip/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/numaq_32.c
@@ -472,8 +472,8 @@ static void numaq_setup_portio_remap(voi
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
-/* Use __refdata to keep false positive warning calm.	*/
-struct apic __refdata apic_numaq = {
+/* Use __refdata to keep false positive warning calm.  */
+static struct apic __refdata apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
@@ -87,7 +87,7 @@ static int probe_default(void)
 	return 1;
 }
 
-struct apic apic_default = {
+static struct apic apic_default = {
 
 	.name				= "default",
 	.probe				= probe_default,
@@ -151,33 +151,9 @@ struct apic apic_default = {
 
 apic_driver(apic_default);
 
-extern struct apic apic_numaq;
-extern struct apic apic_summit;
-extern struct apic apic_bigsmp;
-extern struct apic apic_es7000;
-extern struct apic apic_es7000_cluster;
-
 struct apic *apic = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
 
-static struct apic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_NUMAQ
-	&apic_numaq,
-#endif
-#ifdef CONFIG_X86_SUMMIT
-	&apic_summit,
-#endif
-#ifdef CONFIG_X86_BIGSMP
-	&apic_bigsmp,
-#endif
-#ifdef CONFIG_X86_ES7000
-	&apic_es7000,
-	&apic_es7000_cluster,
-#endif
-	&apic_default,	/* must be last */
-	NULL,
-};
-
 static int cmdline_apic __initdata;
 static int __init parse_apic(char *arg)
 {
Index: linux-2.6-tip/arch/x86/kernel/apic/summit_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/summit_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/summit_32.c
@@ -491,7 +491,7 @@ void setup_summit(void)
 }
 #endif
 
-struct apic apic_summit = {
+static struct apic apic_summit = {
 
 	.name				= "summit",
 	.probe				= probe_summit,
Index: linux-2.6-tip/arch/x86/kernel/apic/bigsmp_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/bigsmp_32.c
@@ -193,7 +193,7 @@ static int probe_bigsmp(void)
 	return dmi_bigsmp;
 }
 
-struct apic apic_bigsmp = {
+static struct apic apic_bigsmp = {
 
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,


