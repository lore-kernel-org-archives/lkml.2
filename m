Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1EVKnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:43:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:52636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1EVKnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:43:16 -0400
Date: Sun, 22 May 2011 10:43:00 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-107e0e0cd85beeee05af7ea374fda14d037ee500@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110521005526.068775085@sbsiddha-MOBL3.sc.intel.com>
References: <20110521005526.068775085@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Introduce .apicdrivers section to find the list of apic drivers
Git-Commit-ID: 107e0e0cd85beeee05af7ea374fda14d037ee500
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 22 May 2011 10:43:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  107e0e0cd85beeee05af7ea374fda14d037ee500
Gitweb:     http://git.kernel.org/tip/107e0e0cd85beeee05af7ea374fda14d037ee500
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 20 May 2011 17:51:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 May 2011 11:48:03 +0200

x86, apic: Introduce .apicdrivers section to find the list of apic drivers

This will pave the way for each apic driver to be self-contained
and eliminate the need for apic_probe[].

Order in which apic drivers are listed in the .apicdrivers
section is important, as this determines the apic probe order.
And this is enforced by the ordering of apic driver files in the
Makefile and the macros apic_driver()/apic_drivers().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: steiner@sgi.com
Cc: gorcunov@openvz.org
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110521005526.068775085@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a0c46f0..80b243c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
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
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 3966b56..767fd04 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
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
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 025921f..6ce0f7f 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -377,3 +377,8 @@ struct apic apic_physflat =  {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
+
+/*
+ * We need to check for physflat first, so this order is important.
+ */
+apic_drivers(apic_physflat, apic_flat);
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index d84ac5a5..cfb13c3 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -254,3 +254,5 @@ struct apic apic_bigsmp = {
 
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
+
+apic_driver(apic_bigsmp);
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 70533de..80de0d7 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -747,3 +747,9 @@ struct apic __refdata apic_es7000 = {
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
+
+/*
+ * Need to check for es7000 followed by es7000_cluster, so this order
+ * in apic_drivers is important.
+ */
+apic_drivers(apic_es7000, apic_es7000_cluster);
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 30f1331..4caab0d 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -537,3 +537,5 @@ struct apic __refdata apic_numaq = {
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 	.x86_32_numa_cpu_node		= numaq_numa_cpu_node,
 };
+
+apic_driver(apic_numaq);
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 6541e47..a319b33 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -174,6 +174,8 @@ struct apic apic_default = {
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
 };
 
+apic_driver(apic_default);
+
 extern struct apic apic_numaq;
 extern struct apic apic_summit;
 extern struct apic apic_bigsmp;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 35bcd7d..447ec0f 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -552,3 +552,5 @@ struct apic apic_summit = {
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
 };
+
+apic_driver(apic_summit);
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index f7875d9..7595c57 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -264,3 +264,5 @@ struct apic apic_x2apic_cluster = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_cluster);
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 78c8f33..f7ba21c 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -168,3 +168,5 @@ struct apic apic_x2apic_phys = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_phys);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 6bb80b1..b6c6298 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -864,3 +864,5 @@ void __init uv_system_init(void)
 	if (is_kdump_kernel())
 		reboot_type = BOOT_ACPI;
 }
+
+apic_driver(apic_x2apic_uv_x);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 624a201..49927a8 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
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
