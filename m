Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1LVBqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:46:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:45116 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1LVBqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:46:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90216183"
Message-Id: <20111222014632.644264512@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 17:45:18 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, flyboy@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/5] x86, x2apic: allow "nox2apic" to disable x2apic mode setup by bios
References: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=allow_nox2apic_to_disable_pre-enabled_x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Currently "nox2apic" boot parameter was not enabling x2apic mode if the cpu,
kernel are all capable of enabling x2apic mode and the OS handover
happened in xapic mode.

However If the bios enabled x2apic prior to OS handover, using "nox2apic"
boot parameter had no effect.

If the boot cpu's apicid is < 255, enable "nox2apic" boot parameter to
disable the x2apic mode setup by the bios. This will enable the kernel to
fallback to xapic mode and bringup only the cpu's which has apic-id < 255.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/apic/apic.c |   39 ++++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 11 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -148,15 +148,24 @@ int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;
+static int nox2apic;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
-		pr_warning("Bios already enabled x2apic, "
-			   "can't enforce nox2apic");
-		return 0;
-	}
+		int apicid = native_apic_msr_read(APIC_ID);
+
+		if (apicid >= 255) {
+			pr_warning("Apicid: %08x, cannot enforce nox2apic\n",
+				   apicid);
+			return;
+		}
+
+		pr_warning("x2apic already enabled. will disable it\n");
+	} else
+		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+
+	nox2apic = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1453,12 +1462,17 @@ static void disable_x2apic(void)
 	if (msr & X2APIC_ENABLE) {
 		u32 x2apic_id = read_apic_id();
 
-		if (x2apic_id > 255)
-			panic("Can not disable x2apic, id: %08x\n", x2apic_id);
+		if (x2apic_id >= 255)
+			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
 
 		pr_info("Disabling x2apic\n");
 		__disable_x2apic(msr);
 
+		if (nox2apic) {
+			clear_cpu_cap(&cpu_data(0), X86_FEATURE_X2APIC);
+			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+		}
+
 		x2apic_disabled = 1;
 		x2apic_mode = 0;
 
@@ -1533,13 +1547,16 @@ void __init enable_IR_x2apic(void)
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
+	if (x2apic_preenabled && nox2apic)
+		disable_x2apic();
+
 	if (dmar_table_init_ret)
 		ret = -1;
 	else
 		ret = enable_IR();
 
 	if (!x2apic_supported())
-		goto nox2apic;
+		goto skip_x2apic;
 
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
@@ -1549,7 +1566,7 @@ void __init enable_IR_x2apic(void)
 		    !hypervisor_x2apic_available()) {
 			if (x2apic_preenabled)
 				disable_x2apic();
-			goto nox2apic;
+			goto skip_x2apic;
 		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
@@ -1560,7 +1577,7 @@ void __init enable_IR_x2apic(void)
 
 	if (ret == IRQ_REMAP_XAPIC_MODE) {
 		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-		goto nox2apic;
+		goto skip_x2apic;
 	}
 
 	x2apic_enabled = 1;
@@ -1571,7 +1588,7 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-nox2apic:
+skip_x2apic:
 	if (ret < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -216,6 +216,7 @@ static inline void x2apic_force_phys(voi
 {
 }
 
+#define	nox2apic	0
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
 #endif


