Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1LVBqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:46:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:45116 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1LVBqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:46:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="89147712"
Message-Id: <20111222014632.600418637@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 17:45:17 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, flyboy@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/5] x86, x2apic: fallback to xapic when bios doesnt setup interrupt-remapping
References: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=allow_xapic_fallback_from_x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

On some of the recent Intel SNB platforms, by default bios is pre-enabling
x2apic mode in the cpu with out setting up interrupt-remapping.
This case was resulting in the kernel to panic as the cpu is already in
x2apic mode but the OS was not able to enable interrupt-remapping (which
is a pre-req for using x2apic capability).

On these platforms all the apic-ids are < 255 and the kernel can fallback to
xapic mode if the bios has not enabled interrupt-remapping (which is
mostly the case if the bios has not exported interrupt-remapping tables to the
OS).

Reported-by: Berck E. Nash <flyboy@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h    |    4 ++
 arch/x86/include/asm/apicdef.h |    1 
 arch/x86/kernel/apic/apic.c    |   73 ++++++++++++++++++++++++++++++-----------
 arch/x86/kernel/apic/io_apic.c |    4 ++
 4 files changed, 64 insertions(+), 18 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read
 }
 
 extern int x2apic_phys;
+extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -198,6 +199,9 @@ static inline void x2apic_force_phys(voi
 	x2apic_phys = 1;
 }
 #else
+static inline void disable_x2apic(void)
+{
+}
 static inline void check_x2apic(void)
 {
 }
Index: tip/arch/x86/include/asm/apicdef.h
===================================================================
--- tip.orig/arch/x86/include/asm/apicdef.h
+++ tip/arch/x86/include/asm/apicdef.h
@@ -144,6 +144,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -146,7 +146,8 @@ __setup("apicpmtimer", setup_apicpmtimer
 int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
-static int x2apic_preenabled;
+int x2apic_preenabled;
+static int x2apic_disabled;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1431,6 +1432,40 @@ void __init bsp_end_local_APIC_setup(voi
 }
 
 #ifdef CONFIG_X86_X2APIC
+/*
+ * Need to disable xapic and x2apic at the same time and then enable xapic mode
+ */
+static inline void __disable_x2apic(u64 msr)
+{
+	wrmsrl(MSR_IA32_APICBASE,
+	       msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
+	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
+}
+
+static void disable_x2apic(void)
+{
+	u64 msr;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (msr & X2APIC_ENABLE) {
+		u32 x2apic_id = read_apic_id();
+
+		if (x2apic_id >= 255)
+			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
+
+		pr_info("Disabling x2apic\n");
+		__disable_x2apic(msr);
+
+		x2apic_disabled = 1;
+		x2apic_mode = 0;
+
+		register_lapic_address(mp_lapic_addr);
+	}
+}
+
 void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
@@ -1441,15 +1476,20 @@ void check_x2apic(void)
 
 void enable_x2apic(void)
 {
-	int msr, msr2;
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (x2apic_disabled) {
+		__disable_x2apic(msr);
+		return;
+	}
 
 	if (!x2apic_mode)
 		return;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
+		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
@@ -1486,7 +1526,7 @@ void __init enable_IR_x2apic(void)
 	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto out;
+		return;
 	}
 
 	local_irq_save(flags);
@@ -1498,13 +1538,19 @@ void __init enable_IR_x2apic(void)
 	else
 		ret = enable_IR();
 
+	if (!x2apic_supported())
+		goto nox2apic;
+
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available())
+		    !hypervisor_x2apic_available()) {
+			if (x2apic_preenabled)
+				disable_x2apic();
 			goto nox2apic;
+		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1512,8 +1558,10 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	if (ret == IRQ_REMAP_XAPIC_MODE)
+	if (ret == IRQ_REMAP_XAPIC_MODE) {
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
 		goto nox2apic;
+	}
 
 	x2apic_enabled = 1;
 
@@ -1528,17 +1576,6 @@ nox2apic:
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-
-out:
-	if (x2apic_enabled || !x2apic_supported())
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (ret == IRQ_REMAP_XAPIC_MODE)
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-	else if (ret < 0)
-		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2948,6 +2948,10 @@ static inline void __init check_timer(vo
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	if (x2apic_preenabled)
+		apic_printk(APIC_QUIET, KERN_INFO
+			    "Perhaps problem with the pre-enabled x2apic mode\n"
+			    "Try booting with x2apic and interrupt-remapping disabled in the bios.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
 out:


