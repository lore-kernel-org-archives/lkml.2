Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306Ab0D3TLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:11:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:3401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab0D3Q71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:59:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,294,1270450800"; 
   d="scan'208";a="793893292"
From: Shane Wang <shane.wang@intel.com>
To: avi@redhat.com, hpa@zytor.com, mingo@elte.hu, joseph.cihula@intel.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] intel_txt: enable VMXON check with SMX in KVM
Date: Thu, 29 Apr 2010 12:09:01 -0400
Message-Id: <1272557341-3777-1-git-send-email-shane.wang@intel.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per document, for feature control MSR
Bit 1 enables VMXON in SMX operation. If the bit is clear, execution of VMXON in SMX operation causes a general-protection exception.
Bit 2 enables VMXON outside SMX operation. If the bit is clear, execution of VMXON outside SMX operation causes a general-protection exception.

This patch is to enable this kind of check with SMX for VMXON in KVM.

Signed-off-by: Shane Wang <shane.wang@intel.com>
---
 arch/x86/include/asm/msr-index.h |    5 ++--
 arch/x86/kernel/tboot.c          |    1
 arch/x86/kvm/vmx.c               |   32 +++++++++++++++++++----------
 include/linux/tboot.h            |    1
 4 files changed, 26 insertions(+), 13 deletions(-)

diff -r a96602743dbd arch/x86/include/asm/msr-index.h
--- a/arch/x86/include/asm/msr-index.h	Thu Apr 29 11:49:08 2010 -0400
+++ b/arch/x86/include/asm/msr-index.h	Thu Apr 29 11:49:40 2010 -0400
@@ -202,8 +202,9 @@
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 
-#define FEATURE_CONTROL_LOCKED		(1<<0)
-#define FEATURE_CONTROL_VMXON_ENABLED	(1<<2)
+#define FEATURE_CONTROL_LOCKED				(1<<0)
+#define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
+#define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
 
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
diff -r a96602743dbd arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Thu Apr 29 11:49:08 2010 -0400
+++ b/arch/x86/kernel/tboot.c	Thu Apr 29 11:49:40 2010 -0400
@@ -46,6 +46,7 @@
 
 /* Global pointer to shared data; NULL means no measured launch. */
 struct tboot *tboot __read_mostly;
+EXPORT_SYMBOL(tboot);
 
 /* timeout for APs (in secs) to enter wait-for-SIPI state during shutdown */
 #define AP_WAIT_TIMEOUT		1
diff -r a96602743dbd arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c	Thu Apr 29 11:49:08 2010 -0400
+++ b/arch/x86/kvm/vmx.c	Thu Apr 29 11:49:40 2010 -0400
@@ -27,6 +27,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ftrace_event.h>
 #include <linux/slab.h>
+#include <linux/tboot.h>
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -1176,9 +1177,16 @@ static __init int vmx_disabled_by_bios(v
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & (FEATURE_CONTROL_LOCKED |
-		       FEATURE_CONTROL_VMXON_ENABLED))
-	    == FEATURE_CONTROL_LOCKED;
+	if (!!(msr & FEATURE_CONTROL_LOCKED)) {
+		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)
+			&& tboot_enabled())
+			return 1;
+		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX)
+			&& !tboot_enabled())
+			return 1;
+	}
+
+	return 0;
 	/* locked but not enabled */
 }
 
@@ -1186,21 +1194,23 @@ static int hardware_enable(void *garbage
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	u64 old;
+	u64 old, test_bits;
 
 	if (read_cr4() & X86_CR4_VMXE)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(vcpus_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & (FEATURE_CONTROL_LOCKED |
-		    FEATURE_CONTROL_VMXON_ENABLED))
-	    != (FEATURE_CONTROL_LOCKED |
-		FEATURE_CONTROL_VMXON_ENABLED))
+
+	test_bits = FEATURE_CONTROL_LOCKED;
+	test_bits |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+	if (tboot_enabled())
+		test_bits |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
+
+	if ((old & test_bits) != test_bits) {
 		/* enable and lock */
-		wrmsrl(MSR_IA32_FEATURE_CONTROL, old |
-		       FEATURE_CONTROL_LOCKED |
-		       FEATURE_CONTROL_VMXON_ENABLED);
+		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | test_bits);
+	}
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
diff -r a96602743dbd include/linux/tboot.h
--- a/include/linux/tboot.h	Thu Apr 29 11:49:08 2010 -0400
+++ b/include/linux/tboot.h	Thu Apr 29 11:49:40 2010 -0400
@@ -150,6 +150,7 @@ extern int tboot_force_iommu(void);
 
 #else
 
+#define tboot_enabled()			0
 #define tboot_probe()			do { } while (0)
 #define tboot_shutdown(shutdown_type)	do { } while (0)
 #define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
