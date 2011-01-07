Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1AGSqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:46:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57319 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab1AGSqt (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 7 Jan 2011 13:46:49 -0500
Date: Fri, 7 Jan 2011 13:45:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sheng@linux.intel.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/generic for 2.6.38
Message-ID: <20110107184552.GA25936@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull the following git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/generic

which has changes since git commit cf7d7e5a1980d1116ee152d25dac382b112b9c17
Linus Torvalds (1):
    Linux 2.6.37-rc5 

This patchset speeds up the delivery of interrupts when Linux is
run as a fully virtualized guest (HVM). The code only gets enabled only
if the Xen hypervisor passes to the guest the cpuflag x2apic. KVM and
generic code support this, so changes in the generic layer were
necessary and have been Ack-ed Ingo.

Sheng Yang (2):
      apic: Move hypervisor detection of x2apic to hypervisor.h
      xen: HVM X2APIC support


diff stat:

 arch/x86/include/asm/hypervisor.h     |   12 +++++++++++
 arch/x86/include/asm/xen/hypervisor.h |   35 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c           |    5 ++-
 arch/x86/xen/enlighten.c              |   31 +++++++++++-----------------
 4 files changed, 62 insertions(+), 21 deletions(-)

Full patchset:
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index ff2546c..7a15153 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -20,6 +20,9 @@
 #ifndef _ASM_X86_HYPERVISOR_H
 #define _ASM_X86_HYPERVISOR_H
 
+#include <asm/kvm_para.h>
+#include <asm/xen/hypervisor.h>
+
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 extern void init_hypervisor_platform(void);
 
@@ -47,4 +50,13 @@ extern const struct hypervisor_x86 x86_hyper_vmware;
 extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 
+static inline bool hypervisor_x2apic_available(void)
+{
+	if (kvm_para_available())
+		return true;
+	if (xen_x2apic_para_available())
+		return true;
+	return false;
+}
+
 #endif
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 396ff4c..66d0fff 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,4 +37,39 @@
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
+extern bool xen_hvm_need_lapic(void);
+
+static inline bool xen_x2apic_para_available(void)
+{
+	return xen_hvm_need_lapic();
+}
+#else
+static inline bool xen_x2apic_para_available(void)
+{
+	return (xen_cpuid_base() != 0);
+}
+#endif
+
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..8408f2d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -50,8 +50,8 @@
 #include <asm/mtrr.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
-#include <asm/kvm_para.h>
 #include <asm/tsc.h>
+#include <asm/hypervisor.h>
 
 unsigned int num_processors;
 
@@ -1476,7 +1476,8 @@ void __init enable_IR_x2apic(void)
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
-		if (max_physical_apicid > 255 || !kvm_para_available())
+		if (max_physical_apicid > 255 ||
+		    !hypervisor_x2apic_available())
 			goto nox2apic;
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 44dcad4..5b8986f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1256,25 +1256,6 @@ asmlinkage void __init xen_start_kernel(void)
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
@@ -1384,6 +1365,18 @@ static bool __init xen_hvm_platform(void)
 	return true;
 }
 
+bool xen_hvm_need_lapic(void)
+{
+	if (xen_pv_domain())
+		return false;
+	if (!xen_hvm_domain())
+		return false;
+	if (xen_feature(XENFEAT_hvm_pirqs) && xen_have_vector_callback)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
+
 const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
 	.name			= "Xen HVM",
 	.detect			= xen_hvm_platform,
