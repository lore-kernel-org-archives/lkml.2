Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab1KJAJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:09:00 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43529
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933414Ab1KJAI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:08:56 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Milton Miller <miltonm@bga.com>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>,
        Vakul Garg <vakul@freescale.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: [RFC PATCH 09/17] powerpc/e500: Split idle handlers for e500v1/v2 and e500mc
Date: Wed,  9 Nov 2011 19:07:07 -0500
Message-Id: <1320883635-17194-10-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are totally different (more so in fact than 6xx vs. e500v1/v2), so
there isn't really a good reason to keep them in the same file.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/machdep.h      |    1 +
 arch/powerpc/kernel/Makefile            |    3 +-
 arch/powerpc/kernel/idle_e500.S         |   12 -------
 arch/powerpc/kernel/idle_e500mc.S       |   56 +++++++++++++++++++++++++++++++
 arch/powerpc/kernel/setup_32.c          |    2 +-
 arch/powerpc/platforms/85xx/p2041_rdb.c |    2 +-
 arch/powerpc/platforms/85xx/p3041_ds.c  |    2 +-
 arch/powerpc/platforms/85xx/p3060_qds.c |    2 +-
 arch/powerpc/platforms/85xx/p4080_ds.c  |    2 +-
 arch/powerpc/platforms/85xx/p5020_ds.c  |    2 +-
 10 files changed, 65 insertions(+), 19 deletions(-)
 create mode 100644 arch/powerpc/kernel/idle_e500mc.S

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index b540d6f..995a2ec 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -253,6 +253,7 @@ struct machdep_calls {
 };
 
 extern void e500_idle(void);
+extern void e500mc_idle(void);
 extern void power4_idle(void);
 extern void power7_idle(void);
 extern void ppc6xx_idle(void);
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ce4f7f1..8627dda 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -61,7 +61,8 @@ obj-$(CONFIG_IBMEBUS)           += ibmebus.o
 obj-$(CONFIG_GENERIC_TBSYNC)	+= smp-tbsync.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 ifeq ($(CONFIG_PPC32),y)
-obj-$(CONFIG_E500)		+= idle_e500.o
+obj-$(CONFIG_FSL_E500_V1_V2)	+= idle_e500.o
+obj-$(CONFIG_FSL_E500MC)	+= idle_e500mc.o
 endif
 obj-$(CONFIG_6xx)		+= idle_6xx.o l2cr_6xx.o cpu_setup_6xx.o
 obj-$(CONFIG_TAU)		+= tau_6xx.o
diff --git a/arch/powerpc/kernel/idle_e500.S b/arch/powerpc/kernel/idle_e500.S
index 4f0ab85..47a1a98 100644
--- a/arch/powerpc/kernel/idle_e500.S
+++ b/arch/powerpc/kernel/idle_e500.S
@@ -26,17 +26,6 @@ _GLOBAL(e500_idle)
 	ori	r4,r4,_TLF_NAPPING	/* so when we take an exception */
 	stw	r4,TI_LOCAL_FLAGS(r3)	/* it will return to our caller */
 
-#ifdef CONFIG_PPC_E500MC
-	wrteei	1
-1:	wait
-
-	/*
-	 * Guard against spurious wakeups (e.g. from a hypervisor) --
-	 * any real interrupt will cause us to return to LR due to
-	 * _TLF_NAPPING.
-	 */
-	b	1b
-#else
 	/* Check if we can nap or doze, put HID0 mask in r3 */
 	lis	r3,0
 BEGIN_FTR_SECTION
@@ -83,7 +72,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_L2CSR|CPU_FTR_CAN_NAP)
 	mtmsr	r7
 	isync
 2:	b	2b
-#endif /* !E500MC */
 
 /*
  * Return from NAP/DOZE mode, restore some CPU specific registers,
diff --git a/arch/powerpc/kernel/idle_e500mc.S b/arch/powerpc/kernel/idle_e500mc.S
new file mode 100644
index 0000000..4806942
--- /dev/null
+++ b/arch/powerpc/kernel/idle_e500mc.S
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2008 Freescale Semiconductor, Inc. All rights reserved.
+ * Dave Liu <daveliu@freescale.com>
+ * copy from idle_6xx.S and modify for e500 based processor,
+ * implement the power_save function in idle.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/threads.h>
+#include <asm/reg.h>
+#include <asm/page.h>
+#include <asm/cputable.h>
+#include <asm/thread_info.h>
+#include <asm/ppc_asm.h>
+#include <asm/asm-offsets.h>
+
+	.text
+
+_GLOBAL(e500mc_idle)
+	rlwinm	r3,r1,0,0,31-THREAD_SHIFT	/* current thread_info */
+	lwz	r4,TI_LOCAL_FLAGS(r3)	/* set napping bit */
+	ori	r4,r4,_TLF_NAPPING	/* so when we take an exception */
+	stw	r4,TI_LOCAL_FLAGS(r3)	/* it will return to our caller */
+	wrteei	1
+1:	wait
+
+	/*
+	 * Guard against spurious wakeups (e.g. from a hypervisor) --
+	 * any real interrupt will cause us to return to LR due to
+	 * _TLF_NAPPING.
+	 */
+	b	1b
+
+/*
+ * Return from NAP/DOZE mode, restore some CPU specific registers,
+ * r2 containing physical address of current.
+ * r11 points to the exception frame (physical address).
+ * We have to preserve r10.
+ */
+_GLOBAL(power_save_ppc32_restore)
+	lwz	r9,_LINK(r11)		/* interrupted in e500mc_idle */
+	stw	r9,_NIP(r11)		/* make it do a blr */
+
+#ifdef CONFIG_SMP
+	rlwinm	r12,r1,0,0,31-THREAD_SHIFT
+	lwz	r11,TI_CPU(r12)		/* get cpu number * 4 */
+	slwi	r11,r11,2
+#else
+	li	r11,0
+#endif
+
+	b	transfer_to_handler_cont
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index c1ce863..b14aabd 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -139,7 +139,7 @@ notrace void __init machine_init(u64 dt_ptr)
 		ppc_md.power_save = ppc6xx_idle;
 #endif
 
-#ifdef CONFIG_E500
+#ifdef CONFIG_FSL_E500_V1_V2
 	if (cpu_has_feature(CPU_FTR_CAN_DOZE) ||
 	    cpu_has_feature(CPU_FTR_CAN_NAP))
 		ppc_md.power_save = e500_idle;
diff --git a/arch/powerpc/platforms/85xx/p2041_rdb.c b/arch/powerpc/platforms/85xx/p2041_rdb.c
index eda6ed5..43ca79d 100644
--- a/arch/powerpc/platforms/85xx/p2041_rdb.c
+++ b/arch/powerpc/platforms/85xx/p2041_rdb.c
@@ -78,7 +78,7 @@ define_machine(p2041_rdb) {
 	.restart		= fsl_rstcr_restart,
 	.calibrate_decr		= generic_calibrate_decr,
 	.progress		= udbg_progress,
-	.power_save		= e500_idle,
+	.power_save		= e500mc_idle,
 };
 
 machine_device_initcall(p2041_rdb, corenet_ds_publish_devices);
diff --git a/arch/powerpc/platforms/85xx/p3041_ds.c b/arch/powerpc/platforms/85xx/p3041_ds.c
index 96d99a3..4abf6ef 100644
--- a/arch/powerpc/platforms/85xx/p3041_ds.c
+++ b/arch/powerpc/platforms/85xx/p3041_ds.c
@@ -80,7 +80,7 @@ define_machine(p3041_ds) {
 	.restart		= fsl_rstcr_restart,
 	.calibrate_decr		= generic_calibrate_decr,
 	.progress		= udbg_progress,
-	.power_save		= e500_idle,
+	.power_save		= e500mc_idle,
 };
 
 machine_device_initcall(p3041_ds, corenet_ds_publish_devices);
diff --git a/arch/powerpc/platforms/85xx/p3060_qds.c b/arch/powerpc/platforms/85xx/p3060_qds.c
index 01dcf44..6f66776 100644
--- a/arch/powerpc/platforms/85xx/p3060_qds.c
+++ b/arch/powerpc/platforms/85xx/p3060_qds.c
@@ -67,7 +67,7 @@ define_machine(p3060_qds) {
 	.restart		= fsl_rstcr_restart,
 	.calibrate_decr		= generic_calibrate_decr,
 	.progress		= udbg_progress,
-	.power_save		= e500_idle,
+	.power_save		= e500mc_idle,
 };
 
 machine_device_initcall(p3060_qds, declare_of_platform_devices);
diff --git a/arch/powerpc/platforms/85xx/p4080_ds.c b/arch/powerpc/platforms/85xx/p4080_ds.c
index d1b21d7..3589961 100644
--- a/arch/powerpc/platforms/85xx/p4080_ds.c
+++ b/arch/powerpc/platforms/85xx/p4080_ds.c
@@ -79,7 +79,7 @@ define_machine(p4080_ds) {
 	.restart		= fsl_rstcr_restart,
 	.calibrate_decr		= generic_calibrate_decr,
 	.progress		= udbg_progress,
-	.power_save		= e500_idle,
+	.power_save		= e500mc_idle,
 };
 
 machine_device_initcall(p4080_ds, corenet_ds_publish_devices);
diff --git a/arch/powerpc/platforms/85xx/p5020_ds.c b/arch/powerpc/platforms/85xx/p5020_ds.c
index e8cba50..2e38748 100644
--- a/arch/powerpc/platforms/85xx/p5020_ds.c
+++ b/arch/powerpc/platforms/85xx/p5020_ds.c
@@ -88,7 +88,7 @@ define_machine(p5020_ds) {
 #ifdef CONFIG_PPC64
 	.power_save		= book3e_idle,
 #else
-	.power_save		= e500_idle,
+	.power_save		= e500mc_idle,
 #endif
 };
 
-- 
1.7.2.5

