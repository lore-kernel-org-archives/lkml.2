Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab1EUA7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:59:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:44727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab1EUA7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,245,1304319600"; 
   d="scan'208";a="440086779"
Message-Id: <20110521005526.068775085@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 20 May 2011 17:51:17 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        gorcunov@openvz.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 1/4] x86, apic: introduce .apicdrivers section to find the list of apic drivers
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=introduce_apicdrivers_section.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will pave the way for each apic driver to be self-contained and eliminate
the need for apic_probe[].

Order in which apic drivers are listed in the .apicdrivers section is
important, as this determines the apic probe order.  And this is enforced
by the ordering of apic driver files in the Makefile and the macros
apic_driver()/apic_drivers().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h           |   20 ++++++++++++++++++++
 arch/x86/kernel/apic/Makefile         |   17 +++++++++++------
 arch/x86/kernel/apic/apic_flat_64.c   |    5 +++++
 arch/x86/kernel/apic/bigsmp_32.c      |    2 ++
 arch/x86/kernel/apic/es7000_32.c      |    6 ++++++
 arch/x86/kernel/apic/numaq_32.c       |    2 ++
 arch/x86/kernel/apic/probe_32.c       |    2 ++
 arch/x86/kernel/apic/summit_32.c      |    2 ++
 arch/x86/kernel/apic/x2apic_cluster.c |    2 ++
 arch/x86/kernel/apic/x2apic_phys.c    |    2 ++
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 ++
 arch/x86/kernel/vmlinux.lds.S         |    7 +++++++
 12 files changed, 63 insertions(+), 6 deletions(-)

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
@@ -377,3 +377,8 @@ struct apic apic_physflat =  {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
+
+/*
+ * We need to check for physflat first, so this order is important.
+ */
+apic_drivers(apic_physflat, apic_flat);
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_cluster.c
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
@@ -168,3 +168,5 @@ struct apic apic_x2apic_phys = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_phys);
Index: linux-2.6-tip/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6-tip/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -864,3 +864,5 @@ void __init uv_system_init(void)
 	if (is_kdump_kernel())
 		reboot_type = BOOT_ACPI;
 }
+
+apic_driver(apic_x2apic_uv_x);
Index: linux-2.6-tip/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/vmlinux.lds.S
+++ linux-2.6-tip/arch/x86/kernel/vmlinux.lds.S
@@ -306,6 +306,13 @@ SECTIONS
 	}
 
 	. = ALIGN(8);
+	.apicdrivers : AT(ADDR(.apicdrivers) - LOAD_OFFSET) {
+		__apicdrivers = .;
+		*(.apicdrivers);
+		__apicdrivers_end = .;
+	}
+
+	. = ALIGN(8);
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
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
@@ -537,3 +537,5 @@ struct apic __refdata apic_numaq = {
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 	.x86_32_numa_cpu_node		= numaq_numa_cpu_node,
 };
+
+apic_driver(apic_numaq);
Index: linux-2.6-tip/arch/x86/kernel/apic/summit_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/summit_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/summit_32.c
@@ -552,3 +552,5 @@ struct apic apic_summit = {
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
 };
+
+apic_driver(apic_summit);
Index: linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/probe_32.c
@@ -174,6 +174,8 @@ struct apic apic_default = {
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
 };
 
+apic_driver(apic_default);
+
 extern struct apic apic_numaq;
 extern struct apic apic_summit;
 extern struct apic apic_bigsmp;


