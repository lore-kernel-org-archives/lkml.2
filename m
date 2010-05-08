Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0EHB6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:58:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:60273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab0EHB6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:58:37 -0400
Date: Sat, 8 May 2010 01:58:17 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       tglx@linutronix.de, akataria@vmware.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       tglx@linutronix.de, akataria@vmware.com
In-Reply-To: <4BE49778.6060800@zytor.com>
References: <4BE49778.6060800@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Clean up the hypervisor layer
Message-ID: <tip-e08cae4181af9483b04ecfac48f01c8e5a5f27bf@git.kernel.org>
Git-Commit-ID: e08cae4181af9483b04ecfac48f01c8e5a5f27bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 01:58:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e08cae4181af9483b04ecfac48f01c8e5a5f27bf
Gitweb:     http://git.kernel.org/tip/e08cae4181af9483b04ecfac48f01c8e5a5f27bf
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 7 May 2010 16:57:28 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 7 May 2010 17:13:04 -0700

x86: Clean up the hypervisor layer

Clean up the hypervisor layer and the hypervisor drivers, using an ops
structure instead of an enumeration with if statements.

The identity of the hypervisor, if needed, can be tested by testing
the pointer value in x86_hyper.

The MS-HyperV private state is moved into a normal global variable
(it's per-system state, not per-CPU state).  Being a normal bss
variable, it will be left at all zero on non-HyperV platforms, and so
can generally be tested for HyperV-specific features without
additional qualification.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Greg KH <greg@kroah.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>
LKML-Reference: <4BE49778.6060800@zytor.com>
---
 arch/x86/include/asm/hyperv.h     |    5 ++-
 arch/x86/include/asm/hypervisor.h |   27 ++++++++++++++++-
 arch/x86/include/asm/mshyperv.h   |   15 +++++++--
 arch/x86/include/asm/processor.h  |    7 ----
 arch/x86/include/asm/vmware.h     |   27 ------------------
 arch/x86/kernel/cpu/hypervisor.c  |   56 ++++++++++++++++++++++--------------
 arch/x86/kernel/cpu/mshyperv.c    |   51 ++++++++++++++++------------------
 arch/x86/kernel/cpu/vmware.c      |   36 +++++++++++++----------
 8 files changed, 117 insertions(+), 107 deletions(-)

diff --git a/arch/x86/include/asm/hyperv.h b/arch/x86/include/asm/hyperv.h
index 4604047..5df477a 100644
--- a/arch/x86/include/asm/hyperv.h
+++ b/arch/x86/include/asm/hyperv.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_KVM_HYPERV_H
-#define _ASM_X86_KVM_HYPERV_H
+#ifndef _ASM_X86_HYPERV_H
+#define _ASM_X86_HYPERV_H
 
 #include <linux/types.h>
 
@@ -16,6 +16,7 @@
 
 #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
 #define HYPERV_CPUID_MIN			0x40000005
+#define HYPERV_CPUID_MAX			0x4000ffff
 
 /*
  * Feature identification. EAX indicates which features are available
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b78c094..70abda7 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -17,10 +17,33 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-#ifndef ASM_X86__HYPERVISOR_H
-#define ASM_X86__HYPERVISOR_H
+#ifndef _ASM_X86_HYPERVISOR_H
+#define _ASM_X86_HYPERVISOR_H
 
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 extern void init_hypervisor_platform(void);
 
+/*
+ * x86 hypervisor information
+ */
+struct hypervisor_x86 {
+	/* Hypervisor name */
+	const char	*name;
+
+	/* Detection routine */
+	bool		(*detect)(void);
+
+	/* Adjust CPU feature bits (run once per CPU) */
+	void		(*set_cpu_features)(struct cpuinfo_x86 *);
+
+	/* Platform setup (run once per boot) */
+	void		(*init_platform)(void);
+};
+
+extern const struct hypervisor_x86 *x86_hyper;
+
+/* Recognized hypervisors */
+extern const struct hypervisor_x86 x86_hyper_vmware;
+extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
+
 #endif
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 6cd8101..79ce568 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -1,7 +1,14 @@
-#ifndef ASM_X86__MSHYPER_H
-#define ASM_X86__MSHYPER_H
+#ifndef _ASM_X86_MSHYPER_H
+#define _ASM_X86_MSHYPER_H
 
-int ms_hyperv_platform(void);
-void __cpuinit ms_hyperv_set_feature_bits(struct cpuinfo_x86 *c);
+#include <linux/types.h>
+#include <asm/hyperv.h>
+
+struct ms_hyperv_info {
+	u32 features;
+	u32 hints;
+};
+
+extern struct ms_hyperv_info ms_hyperv;
 
 #endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 597c041..e4f1dfb 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -113,9 +113,6 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
-	unsigned int		x86_hyper_vendor;
-	/* The layout of this field is hypervisor specific */
-	unsigned int		x86_hyper_features;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
@@ -129,10 +126,6 @@ struct cpuinfo_x86 {
 
 #define X86_VENDOR_UNKNOWN	0xff
 
-#define X86_HYPER_VENDOR_NONE  0
-#define X86_HYPER_VENDOR_VMWARE 1
-#define X86_HYPER_VENDOR_MSFT	2
-
 /*
  * capabilities of CPUs
  */
diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
deleted file mode 100644
index e49ed6d..0000000
--- a/arch/x86/include/asm/vmware.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2008, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-#ifndef ASM_X86__VMWARE_H
-#define ASM_X86__VMWARE_H
-
-extern void vmware_platform_setup(void);
-extern int vmware_platform(void);
-extern void vmware_set_feature_bits(struct cpuinfo_x86 *c);
-
-#endif
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index de3f4e0..8738175 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -22,40 +22,52 @@
  */
 
 #include <asm/processor.h>
-#include <asm/vmware.h>
-#include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 
-static inline void __cpuinit
-detect_hypervisor_vendor(struct cpuinfo_x86 *c)
+/*
+ * Hypervisor detect order.  This is specified explicitly here because
+ * some hypervisors might implement compatibility modes for other
+ * hypervisors and therefore need to be detected in specific sequence.
+ */
+static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
-	if (vmware_platform())
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
-	else if (ms_hyperv_platform())
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_MSFT;
-	else
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
-}
+	&x86_hyper_vmware,
+	&x86_hyper_ms_hyperv,
+};
 
-static inline void __cpuinit
-hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
+const struct hypervisor_x86 *x86_hyper;
+
+static inline void __init
+detect_hypervisor_vendor(void)
 {
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
-		vmware_set_feature_bits(c);
-	else if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_MSFT)
-		ms_hyperv_set_feature_bits(c);
-	return;
+	const struct hypervisor_x86 *h, * const *p;
+
+	for (p = hypervisors; p < hypervisors + ARRAY_SIZE(hypervisors); p++) {
+		h = *p;
+		if (h->detect()) {
+			x86_hyper = h;
+			printk(KERN_INFO "Hypervisor detected: %s\n", h->name);
+			break;
+		}
+	}
 }
 
 void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
 {
-	detect_hypervisor_vendor(c);
-	hypervisor_set_feature_bits(c);
+	if (x86_hyper && x86_hyper->set_cpu_features)
+		x86_hyper->set_cpu_features(c);
 }
 
 void __init init_hypervisor_platform(void)
 {
+
+	detect_hypervisor_vendor();
+
+	if (!x86_hyper)
+		return;
+
 	init_hypervisor(&boot_cpu_data);
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
-		vmware_platform_setup();
+
+	if (x86_hyper->init_platform)
+		x86_hyper->init_platform();
 }
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index a58d8e6..5969c3e 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -12,45 +12,42 @@
 
 #include <linux/types.h>
 #include <asm/processor.h>
+#include <asm/hypervisor.h>
 #include <asm/hyperv.h>
 #include <asm/mshyperv.h>
 
+struct ms_hyperv_info ms_hyperv;
 
-int ms_hyperv_platform(void)
+static bool __init ms_hyperv_platform(void)
 {
-	u32 eax, ebx, ecx, edx;
-	char hyp_signature[13];
+	u32 eax;
+	u32 hyp_signature[3];
 
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-	if (!(ecx & HYPERV_HYPERVISOR_PRESENT_BIT))
-		return 0;
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return false;
 
-	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS, &eax, &ebx, &ecx, &edx);
-	*(u32 *)(hyp_signature + 0) = ebx;
-	*(u32 *)(hyp_signature + 4) = ecx;
-	*(u32 *)(hyp_signature + 8) = edx;
+	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
+	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
-	if ((eax < HYPERV_CPUID_MIN) || (memcmp("Microsoft Hv", hyp_signature, 12)))
-		return 0;
-	return 1;
+	return eax >= HYPERV_CPUID_MIN &&
+		eax <= HYPERV_CPUID_MAX &&
+		!memcmp("Microsoft Hv", hyp_signature, 12);
 }
 
-void __cpuinit ms_hyperv_set_feature_bits(struct cpuinfo_x86 *c)
+static void __init ms_hyperv_init_platform(void)
 {
-	u32 eax, ebx, ecx, edx;
-
-	c->x86_hyper_features = 0;
 	/*
-	 * Extract the features, recommendations etc.
-	 * The first 9 bits will be used to track hypervisor features.
-	 * The next 6 bits will be used to track the hypervisor
-	 * recommendations.
+	 * Extract the features and hints
 	 */
-	cpuid(HYPERV_CPUID_FEATURES, &eax, &ebx, &ecx, &edx);
-	c->x86_hyper_features |= (eax & 0x1ff);
+	ms_hyperv.features = cpuid_eax(HYPERV_CPUID_FEATURES);
+	ms_hyperv.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
 
-	cpuid(HYPERV_CPUID_ENLIGHTMENT_INFO, &eax, &ebx, &ecx, &edx);
-	c->x86_hyper_features |= ((eax & 0x3f) << 9);
-	printk(KERN_INFO "Detected HyperV with features: %x\n",
-		c->x86_hyper_features);
+	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
+	       ms_hyperv.features, ms_hyperv.hints);
 }
+
+const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
+	.name			= "Microsoft HyperV",
+	.detect			= ms_hyperv_platform,
+	.init_platform		= ms_hyperv_init_platform,
+};
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 1cbed97..46a5b5d 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -23,8 +23,8 @@
 
 #include <linux/dmi.h>
 #include <asm/div64.h>
-#include <asm/vmware.h>
 #include <asm/x86_init.h>
+#include <asm/hypervisor.h>
 
 #define CPUID_VMWARE_INFO_LEAF	0x40000000
 #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
@@ -64,7 +64,7 @@ static unsigned long vmware_get_tsc_khz(void)
 	return tsc_hz;
 }
 
-void __init vmware_platform_setup(void)
+static void __init vmware_platform_setup(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 
@@ -82,24 +82,21 @@ void __init vmware_platform_setup(void)
  * serial key should be enough, as this will always have a VMware
  * specific string when running under VMware hypervisor.
  */
-int vmware_platform(void)
+static bool __init vmware_platform(void)
 {
 	if (cpu_has_hypervisor) {
-		unsigned int eax, ebx, ecx, edx;
-		char hyper_vendor_id[13];
-
-		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &ebx, &ecx, &edx);
-		memcpy(hyper_vendor_id + 0, &ebx, 4);
-		memcpy(hyper_vendor_id + 4, &ecx, 4);
-		memcpy(hyper_vendor_id + 8, &edx, 4);
-		hyper_vendor_id[12] = '\0';
-		if (!strcmp(hyper_vendor_id, "VMwareVMware"))
-			return 1;
+		unsigned int eax;
+		unsigned int hyper_vendor_id[3];
+
+		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &hyper_vendor_id[0],
+		      &hyper_vendor_id[1], &hyper_vendor_id[2]);
+		if (!memcmp(hyper_vendor_id, "VMwareVMware", 12))
+			return true;
 	} else if (dmi_available && dmi_name_in_serial("VMware") &&
 		   __vmware_platform())
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 /*
@@ -114,8 +111,15 @@ int vmware_platform(void)
  * so that the kernel could just trust the hypervisor with providing a
  * reliable virtual TSC that is suitable for timekeeping.
  */
-void __cpuinit vmware_set_feature_bits(struct cpuinfo_x86 *c)
+static void __cpuinit vmware_set_cpu_features(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 }
+
+const __refconst struct hypervisor_x86 x86_hyper_vmware = {
+	.name			= "VMware",
+	.detect			= vmware_platform,
+	.set_cpu_features	= vmware_set_cpu_features,
+	.init_platform		= vmware_platform_setup,
+};
