Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0EHB7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:59:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0EHB7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:59:23 -0400
Date: Sat, 8 May 2010 01:57:41 GMT
From: tip-bot for Ky Srinivasan <ksrinivasan@novell.com>
Cc: eranian@google.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       hjanssen@microsoft.com, fweisbec@gmail.com, gregkh@suse.de,
       tglx@linutronix.de, adobriyan@gmail.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, alan@linux.intel.com,
       gleb@redhat.com, ksrinivasan@novell.com, haiyangz@microsoft.com,
       vrozenfe@redhat.com, avi@redhat.com, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, eranian@google.com, a.p.zijlstra@chello.nl,
       hjanssen@microsoft.com, fweisbec@gmail.com, gregkh@suse.de,
       tglx@linutronix.de, adobriyan@gmail.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, alan@linux.intel.com,
       gleb@redhat.com, ksrinivasan@novell.com, haiyangz@microsoft.com,
       vrozenfe@redhat.com, prasad@linux.vnet.ibm.com, avi@redhat.com
In-Reply-To: <20100506190841.GA1605@kroah.com>
References: <20100506190841.GA1605@kroah.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Detect running on a Microsoft HyperV system
Message-ID: <tip-a2a47c6c3d1a7c01da4464b3b7be93b924f874c1@git.kernel.org>
Git-Commit-ID: a2a47c6c3d1a7c01da4464b3b7be93b924f874c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 01:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2a47c6c3d1a7c01da4464b3b7be93b924f874c1
Gitweb:     http://git.kernel.org/tip/a2a47c6c3d1a7c01da4464b3b7be93b924f874c1
Author:     Ky Srinivasan <ksrinivasan@novell.com>
AuthorDate: Thu, 6 May 2010 12:08:41 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 6 May 2010 18:24:15 -0700

x86: Detect running on a Microsoft HyperV system

This patch integrates HyperV detection within the framework currently
used by VmWare. With this patch, we can avoid having to replicate the
HyperV detection code in each of the Microsoft HyperV drivers.

Reworked and tweaked by Greg K-H to build properly.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
LKML-Reference: <20100506190841.GA1605@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vadim Rozenfeld <vrozenfe@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/hyperv.h    |    6 +++
 arch/x86/include/asm/mshyperv.h  |    7 ++++
 arch/x86/include/asm/processor.h |    3 ++
 arch/x86/kernel/cpu/Makefile     |    2 +-
 arch/x86/kernel/cpu/hypervisor.c |   10 ++++--
 arch/x86/kernel/cpu/mshyperv.c   |   67 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/hyperv.h b/arch/x86/include/asm/hyperv.h
index e153a2b..4604047 100644
--- a/arch/x86/include/asm/hyperv.h
+++ b/arch/x86/include/asm/hyperv.h
@@ -14,6 +14,9 @@
 #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
 #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
 
+#define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
+#define HYPERV_CPUID_MIN			0x40000005
+
 /*
  * Feature identification. EAX indicates which features are available
  * to the partition based upon the current partition privileges.
@@ -129,6 +132,9 @@
 /* MSR used to provide vcpu index */
 #define HV_X64_MSR_VP_INDEX			0x40000002
 
+/* MSR used to read the per-partition time reference counter */
+#define HV_X64_MSR_TIME_REF_COUNT		0x40000020
+
 /* Define the virtual APIC registers */
 #define HV_X64_MSR_EOI				0x40000070
 #define HV_X64_MSR_ICR				0x40000071
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
new file mode 100644
index 0000000..6cd8101
--- /dev/null
+++ b/arch/x86/include/asm/mshyperv.h
@@ -0,0 +1,7 @@
+#ifndef ASM_X86__MSHYPER_H
+#define ASM_X86__MSHYPER_H
+
+int ms_hyperv_platform(void);
+void __cpuinit ms_hyperv_set_feature_bits(struct cpuinfo_x86 *c);
+
+#endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b753ea5..597c041 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -114,6 +114,8 @@ struct cpuinfo_x86 {
 	u16			cpu_index;
 #endif
 	unsigned int		x86_hyper_vendor;
+	/* The layout of this field is hypervisor specific */
+	unsigned int		x86_hyper_features;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
@@ -129,6 +131,7 @@ struct cpuinfo_x86 {
 
 #define X86_HYPER_VENDOR_NONE  0
 #define X86_HYPER_VENDOR_VMWARE 1
+#define X86_HYPER_VENDOR_MSFT	2
 
 /*
  * capabilities of CPUs
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c202b62..3a785da 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,7 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o sched.o
+obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 08be922..de3f4e0 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -23,6 +23,7 @@
 
 #include <asm/processor.h>
 #include <asm/vmware.h>
+#include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 
 static inline void __cpuinit
@@ -30,6 +31,8 @@ detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 {
 	if (vmware_platform())
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+	else if (ms_hyperv_platform())
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_MSFT;
 	else
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 }
@@ -37,10 +40,11 @@ detect_hypervisor_vendor(struct cpuinfo_x86 *c)
 static inline void __cpuinit
 hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
 {
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE) {
+	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
 		vmware_set_feature_bits(c);
-		return;
-	}
+	else if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_MSFT)
+		ms_hyperv_set_feature_bits(c);
+	return;
 }
 
 void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
new file mode 100644
index 0000000..2443b61
--- /dev/null
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -0,0 +1,67 @@
+/*
+ * HyperV  Detection code.
+ *
+ * Copyright (C) 2010, Novell, Inc.
+ * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/types.h>
+#include <asm/processor.h>
+#include <asm/hyperv.h>
+#include <asm/mshyperv.h>
+
+
+int ms_hyperv_platform(void)
+{
+	u32 eax, ebx, ecx, edx;
+	char hyp_signature[13];
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+	if (!(ecx & HYPERV_HYPERVISOR_PRESENT_BIT))
+		return 0;
+
+	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS, &eax, &ebx, &ecx, &edx);
+	*(u32 *)(hyp_signature + 0) = ebx;
+	*(u32 *)(hyp_signature + 4) = ecx;
+	*(u32 *)(hyp_signature + 8) = edx;
+
+	if ((eax < HYPERV_CPUID_MIN) || (memcmp("Microsoft Hv", hyp_signature, 12)))
+		return 0;
+	return 1;
+}
+
+void __cpuinit ms_hyperv_set_feature_bits(struct cpuinfo_x86 *c)
+{
+	u32 eax, ebx, ecx, edx;
+
+	c->x86_hyper_features = 0;
+	/*
+	 * Extract the features, recommendations etc.
+	 * The first 9 bits will be used to track hypervisor features.
+	 * The next 6 bits will be used to track the hypervisor
+	 * recommendations.
+	 */
+	cpuid(HYPERV_CPUID_FEATURES, &eax, &ebx, &ecx, &edx);
+	c->x86_hyper_features |= (eax & 0x1ff);
+
+	cpuid(HYPERV_CPUID_ENLIGHTMENT_INFO, &eax, &ebx, &ecx, &edx);
+	c->x86_hyper_features |= ((eax & 0x3f) << 9);
+	printk(KERN_INFO "Detected HyperV with features: %x\n",
+		c->x86_hyper_features);
+}
