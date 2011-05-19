Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab1ESXrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:47:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:25462 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235Ab1ESXrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="1232758"
Message-Id: <20110519234637.671736436@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 May 2011 16:45:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        suresh.b.siddha@intel.com
Subject: [patch 6/6] x86, apic: use .apicdrivers section to find the list of apic drivers
References: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=use_apicdrivers_section.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will enable each apic driver to be self-contained and eliminate the need
for apic_probe[].

Apic probe will now depend on the order in which apic drivers are listed in
the .apicdrivers section. Ordering of apic driver files in the Makefile
and the macros apic_driver()/apic_drivers() help enforce the desired order.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h           |   25 ++++++++++---
 arch/x86/kernel/apic/Makefile         |   17 +++++---
 arch/x86/kernel/apic/apic_flat_64.c   |   11 ++++-
 arch/x86/kernel/apic/bigsmp_32.c      |    2 +
 arch/x86/kernel/apic/es7000_32.c      |    9 +++-
 arch/x86/kernel/apic/numaq_32.c       |    7 ++-
 arch/x86/kernel/apic/probe_32.c       |   65 ++++++++++++----------------------
 arch/x86/kernel/apic/probe_64.c       |   43 ++++++----------------
 arch/x86/kernel/apic/summit_32.c      |    4 +-
 arch/x86/kernel/apic/x2apic_cluster.c |    4 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    6 ++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    6 ++-
 arch/x86/kernel/vmlinux.lds.S         |    6 +++
 13 files changed, 111 insertions(+), 94 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/apic.h
+++ linux-2.6-tip/arch/x86/include/asm/apic.h
@@ -381,6 +381,26 @@ struct apic {
 extern struct apic *apic;
 
 /*
+ * APIC drivers are probed based on how they are listed in the .apicdrivers
+ * section. So the order is important and enforced by the ordering
+ * of different apic driver files in the Makefile.
+ *
+ * For the files having two apic drivers, we use apic_drivers()
+ * to enforce the order with in them.
+ */
+#define apic_driver(sym)					\
+	static struct apic *__apicdrivers_##sym __used		\
+	__aligned(sizeof(struct apic *))			\
+	__section(.apicdrivers) = { &sym }
+
+#define apic_drivers(sym1, sym2)					\
+	static struct apic *__apicdrivers_##sym1##sym2[2] __used	\
+	__aligned(sizeof(struct apic *))				\
+	__section(.apicdrivers) = { &sym1, &sym2 }
+
+extern struct apic *__apicdrivers[], *__apicdrivers_end[];
+
+/*
  * APIC functionality to boot other CPUs - only used on SMP:
  */
 #ifdef CONFIG_SMP
@@ -458,15 +478,10 @@ static inline unsigned default_get_apic_
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
Index: linux-2.6-tip/arch/x86/kernel/apic/Makefile
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/Makefile
+++ linux-2.6-tip/arch/x86/kernel/apic/Makefile
@@ -2,20 +2,25 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o
 obj-y				+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
-obj-y				+= apic_flat_64.o
-obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
-obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
+# APIC probe will depend on the listing order here
 obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
+obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
+obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
+obj-y				+= apic_flat_64.o
 endif
 
-obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
+# APIC probe will depend on the listing order here
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
-obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
 obj-$(CONFIG_X86_SUMMIT)	+= summit_32.o
+obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
+obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
+
+# For 32bit, probe_32 need to be listed last
+obj-$(CONFIG_X86_LOCAL_APIC)	+= probe_$(BITS).o
Index: linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
@@ -24,6 +24,8 @@
 #include <acpi/acpi_bus.h>
 #endif
 
+static struct apic apic_physflat;
+
 static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 1;
@@ -164,7 +166,7 @@ static int flat_phys_pkg_id(int initial_
 	return initial_apic_id >> index_msb;
 }
 
-struct apic apic_flat =  {
+static struct apic apic_flat =  {
 	.name				= "flat",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
@@ -320,7 +322,7 @@ static int physflat_probe(void)
 	return 0;
 }
 
-struct apic apic_physflat =  {
+static struct apic apic_physflat =  {
 
 	.name				= "physical flat",
 	.probe				= physflat_probe,
@@ -377,3 +379,8 @@ struct apic apic_physflat =  {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
+
+/*
+ * We need to check for physflat first, so this order is important.
+ */
+apic_drivers(apic_physflat, apic_flat);
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
@@ -23,27 +23,9 @@
 #include <asm/ipi.h>
 #include <asm/setup.h>
 
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2xpic_uv_x;
-extern struct apic apic_x2apic_phys;
-extern struct apic apic_x2apic_cluster;
-
-struct apic __read_mostly *apic = &apic_flat;
+struct apic __read_mostly *apic;
 EXPORT_SYMBOL_GPL(apic);
 
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
@@ -54,19 +36,19 @@ static int apicid_phys_pkg_id(int initia
  */
 void __init default_setup_apic_routing(void)
 {
-	int i;
+	struct apic **drv;
 
 	enable_IR_x2apic();
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->probe()) {
-			apic = apic_probe[i];
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->probe()) {
+			apic = *drv;
+			printk(KERN_INFO "APIC routing finalized to %s.\n",
+			       apic->name);
 			break;
 		}
 	}
 
-	printk(KERN_INFO "APIC routing finalized to %s.\n", apic->name);
-
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
@@ -82,13 +64,14 @@ void apic_send_IPI_self(int vector)
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
-			apic = apic_probe[i];
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->acpi_madt_oem_check(oem_id, oem_table_id)) {
+			apic = *drv;
 			printk(KERN_INFO "Setting APIC routing to %s.\n",
-				apic->name);
+			       apic->name);
+
 			return 1;
 		}
 	}
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
@@ -264,3 +264,5 @@ struct apic apic_x2apic_cluster = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_cluster);
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
@@ -168,3 +170,5 @@ struct apic apic_x2apic_phys = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_phys);
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
+static struct apic apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
 	.probe				= uv_probe,
@@ -864,3 +866,5 @@ void __init uv_system_init(void)
 	if (is_kdump_kernel())
 		reboot_type = BOOT_ACPI;
 }
+
+apic_driver(apic_x2apic_uv_x);
Index: linux-2.6-tip/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/vmlinux.lds.S
+++ linux-2.6-tip/arch/x86/kernel/vmlinux.lds.S
@@ -305,6 +305,12 @@ SECTIONS
 		__iommu_table_end = .;
 	}
 
+	.apicdrivers : AT(ADDR(.apicdrivers) - LOAD_OFFSET) {
+		__apicdrivers = .;
+		*(.apicdrivers);
+		__apicdrivers_end = .;
+	}
+
 	. = ALIGN(8);
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
Index: linux-2.6-tip/arch/x86/kernel/apic/bigsmp_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/bigsmp_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/bigsmp_32.c
@@ -254,3 +254,5 @@ struct apic apic_bigsmp = {
 
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
+
+apic_driver(apic_bigsmp);
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
@@ -747,3 +747,9 @@ struct apic __refdata apic_es7000 = {
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
+
+/*
+ * Need to check for es7000 followed by es7000_cluster, so this order
+ * in apic_drivers is important.
+ */
+apic_drivers(apic_es7000, apic_es7000_cluster);
Index: linux-2.6-tip/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/numaq_32.c
@@ -73,7 +73,6 @@ int					mp_bus_id_to_node[MAX_MP_BUSSES]
 int					mp_bus_id_to_local[MAX_MP_BUSSES];
 int					quad_local_to_mp_bus_id[NR_CPUS/4][4];
 
-
 static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 {
 	struct eachquadmem *eq = scd->eq + node;
@@ -472,8 +471,8 @@ static void numaq_setup_portio_remap(voi
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
-/* Use __refdata to keep false positive warning calm.	*/
-struct apic __refdata apic_numaq = {
+/* Use __refdata to keep false positive warning calm.  */
+static struct apic __refdata apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
@@ -537,3 +536,5 @@ struct apic __refdata apic_numaq = {
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 	.x86_32_numa_cpu_node		= numaq_numa_cpu_node,
 };
+
+apic_driver(apic_numaq);
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
@@ -174,44 +174,22 @@ struct apic apic_default = {
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
 };
 
-extern struct apic apic_numaq;
-extern struct apic apic_summit;
-extern struct apic apic_bigsmp;
-extern struct apic apic_es7000;
-extern struct apic apic_es7000_cluster;
+apic_driver(apic_default);
 
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
-	int i;
+	struct apic **drv;
 
 	if (!arg)
 		return -EINVAL;
 
-	for (i = 0; apic_probe[i]; i++) {
-		if (!strcmp(apic_probe[i]->name, arg)) {
-			apic = apic_probe[i];
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!strcmp((*drv)->name, arg)) {
+			apic = *drv;
 			cmdline_apic = 1;
 			return 0;
 		}
@@ -222,6 +200,8 @@ static int __init parse_apic(char *arg)
 }
 early_param("apic", parse_apic);
 
+extern struct apic apic_bigsmp;
+
 void __init generic_bigsmp_probe(void)
 {
 #ifdef CONFIG_X86_BIGSMP
@@ -245,15 +225,16 @@ void __init generic_bigsmp_probe(void)
 void __init generic_apic_probe(void)
 {
 	if (!cmdline_apic) {
-		int i;
-		for (i = 0; apic_probe[i]; i++) {
-			if (apic_probe[i]->probe()) {
-				apic = apic_probe[i];
+		struct apic **drv;
+
+		for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+			if ((*drv)->probe()) {
+				apic = *drv;
 				break;
 			}
 		}
 		/* Not visible without early console */
-		if (!apic_probe[i])
+		if (drv == __apicdrivers_end)
 			panic("Didn't find an APIC driver");
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
@@ -264,16 +245,16 @@ void __init generic_apic_probe(void)
 int __init
 generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->mps_oem_check)
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!((*drv)->mps_oem_check))
 			continue;
-		if (!apic_probe[i]->mps_oem_check(mpc, oem, productid))
+		if (!(*drv)->mps_oem_check(mpc, oem, productid))
 			continue;
 
 		if (!cmdline_apic) {
-			apic = apic_probe[i];
+			apic = *drv;
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
@@ -284,16 +265,16 @@ generic_mps_oem_check(struct mpc_table *
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->acpi_madt_oem_check)
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!(*drv)->acpi_madt_oem_check)
 			continue;
-		if (!apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id))
+		if (!(*drv)->acpi_madt_oem_check(oem_id, oem_table_id))
 			continue;
 
 		if (!cmdline_apic) {
-			apic = apic_probe[i];
+			apic = *drv;
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
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
@@ -552,3 +552,5 @@ struct apic apic_summit = {
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
 };
+
+apic_driver(apic_summit);


