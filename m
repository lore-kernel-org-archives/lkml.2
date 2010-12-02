Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0LBDBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:01:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:16261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0LBDBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:01:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="683028838"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH] xen: HVM X2APIC support
Date: Thu,  2 Dec 2010 11:03:10 +0800
Message-Id: <1291258990-16080-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is similiar to Gleb Natapov's patch for KVM, which enable the
hypervisor to emulate x2apic feature for the guest. By this way, the emulation
of lapic would be simpler with x2apic interface(MSR), and faster.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/xen/hypervisor.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c           |    4 +++-
 arch/x86/xen/enlighten.c              |   19 -------------------
 3 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 396ff4c..e862874 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,4 +37,37 @@
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
+#include <asm/processor.h>
+
+static inline uint32_t xen_cpuid_base(void)
+{
+	uint32_t base, eax, ebx, ecx, edx;
+	char signature[13];
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		cpuid(base, &eax, &ebx, &ecx, &edx);
+		*(uint32_t *)(signature + 0) = ebx;
+		*(uint32_t *)(signature + 4) = ecx;
+		*(uint32_t *)(signature + 8) = edx;
+		signature[12] = 0;
+
+		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
+			return base;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_XEN
+static inline bool xen_para_available(void)
+{
+	return 0;
+}
+#else
+static inline bool xen_para_available(void)
+{
+	return (xen_cpuid_base() != 0);
+}
+#endif
+
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..1b68221 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -52,6 +52,7 @@
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
 #include <asm/tsc.h>
+#include <asm/xen/hypervisor.h>
 
 unsigned int num_processors;
 
@@ -1476,7 +1477,8 @@ void __init enable_IR_x2apic(void)
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
-		if (max_physical_apicid > 255 || !kvm_para_available())
+		if (max_physical_apicid > 255 ||
+		    (!kvm_para_available() && !xen_para_available()))
 			goto nox2apic;
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 235c0f4..819c365 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1245,25 +1245,6 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
-static uint32_t xen_cpuid_base(void)
-{
-	uint32_t base, eax, ebx, ecx, edx;
-	char signature[13];
-
-	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
-		cpuid(base, &eax, &ebx, &ecx, &edx);
-		*(uint32_t *)(signature + 0) = ebx;
-		*(uint32_t *)(signature + 4) = ecx;
-		*(uint32_t *)(signature + 8) = edx;
-		signature[12] = 0;
-
-		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
-			return base;
-	}
-
-	return 0;
-}
-
 static int init_hvm_pv_info(int *major, int *minor)
 {
 	uint32_t eax, ebx, ecx, edx, pages, msr, base;
-- 
1.7.0.1

