Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab0GTCIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 22:08:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:43968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab0GTCH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 22:07:59 -0400
Date: Tue, 20 Jul 2010 02:06:59 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Split addon_cpuid_features.c
Message-ID: <tip-2decb194e65ab66eaf787512dc572cdc99893b24@git.kernel.org>
Git-Commit-ID: 2decb194e65ab66eaf787512dc572cdc99893b24
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 02:06:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2decb194e65ab66eaf787512dc572cdc99893b24
Gitweb:     http://git.kernel.org/tip/2decb194e65ab66eaf787512dc572cdc99893b24
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 19 Jul 2010 18:32:04 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Jul 2010 19:02:41 -0700

x86, cpu: Split addon_cpuid_features.c

addon_cpuid_features.c contains exactly two almost completely
unrelated functions, plus has a long and very generic name.  Split it
into two files, scattered.c for the scattered feature flags, and
topology.c for the topology information.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |  150 ----------------------------
 arch/x86/kernel/cpu/scattered.c            |   61 +++++++++++
 arch/x86/kernel/cpu/topology.c             |   99 ++++++++++++++++++
 4 files changed, 161 insertions(+), 151 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3a785da..5e3a351 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -12,7 +12,7 @@ endif
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
 
-obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
+obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
deleted file mode 100644
index 41eebcd..0000000
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ /dev/null
@@ -1,150 +0,0 @@
-/*
- *	Routines to indentify additional cpu features that are scattered in
- *	cpuid space.
- */
-#include <linux/cpu.h>
-
-#include <asm/pat.h>
-#include <asm/processor.h>
-
-#include <asm/apic.h>
-
-struct cpuid_bit {
-	u16 feature;
-	u8 reg;
-	u8 bit;
-	u32 level;
-	u32 sub_leaf;
-};
-
-enum cpuid_regs {
-	CR_EAX = 0,
-	CR_ECX,
-	CR_EDX,
-	CR_EBX
-};
-
-void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
-{
-	u32 max_level;
-	u32 regs[4];
-	const struct cpuid_bit *cb;
-
-	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
-		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
-		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
-		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
-		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
-		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
-		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
-		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
-		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
-		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
-		{ 0, 0, 0, 0, 0 }
-	};
-
-	for (cb = cpuid_bits; cb->feature; cb++) {
-
-		/* Verify that the level is valid */
-		max_level = cpuid_eax(cb->level & 0xffff0000);
-		if (max_level < cb->level ||
-		    max_level > (cb->level | 0xffff))
-			continue;
-
-		cpuid_count(cb->level, cb->sub_leaf, &regs[CR_EAX],
-			    &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);
-
-		if (regs[cb->reg] & (1 << cb->bit))
-			set_cpu_cap(c, cb->feature);
-	}
-}
-
-/* leaf 0xb SMT level */
-#define SMT_LEVEL	0
-
-/* leaf 0xb sub-leaf types */
-#define INVALID_TYPE	0
-#define SMT_TYPE	1
-#define CORE_TYPE	2
-
-#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
-#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
-#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
-
-/*
- * Check for extended topology enumeration cpuid leaf 0xb and if it
- * exists, use it for populating initial_apicid and cpu topology
- * detection.
- */
-void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned int eax, ebx, ecx, edx, sub_index;
-	unsigned int ht_mask_width, core_plus_mask_width;
-	unsigned int core_select_mask, core_level_siblings;
-	static bool printed;
-
-	if (c->cpuid_level < 0xb)
-		return;
-
-	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
-
-	/*
-	 * check if the cpuid leaf 0xb is actually implemented.
-	 */
-	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
-		return;
-
-	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
-
-	/*
-	 * initial apic id, which also represents 32-bit extended x2apic id.
-	 */
-	c->initial_apicid = edx;
-
-	/*
-	 * Populate HT related information from sub-leaf level 0.
-	 */
-	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
-	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
-
-	sub_index = 1;
-	do {
-		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
-
-		/*
-		 * Check for the Core type in the implemented sub leaves.
-		 */
-		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
-			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
-			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
-			break;
-		}
-
-		sub_index++;
-	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
-
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
-
-	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
-						 & core_select_mask;
-	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width);
-	/*
-	 * Reinit the apicid, now that we have extended initial_apicid.
-	 */
-	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
-
-	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
-
-	if (!printed) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
-		printed = 1;
-	}
-	return;
-#endif
-}
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
new file mode 100644
index 0000000..9815364
--- /dev/null
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -0,0 +1,61 @@
+/*
+ *	Routines to indentify additional cpu features that are scattered in
+ *	cpuid space.
+ */
+#include <linux/cpu.h>
+
+#include <asm/pat.h>
+#include <asm/processor.h>
+
+#include <asm/apic.h>
+
+struct cpuid_bit {
+	u16 feature;
+	u8 reg;
+	u8 bit;
+	u32 level;
+	u32 sub_leaf;
+};
+
+enum cpuid_regs {
+	CR_EAX = 0,
+	CR_ECX,
+	CR_EDX,
+	CR_EBX
+};
+
+void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
+{
+	u32 max_level;
+	u32 regs[4];
+	const struct cpuid_bit *cb;
+
+	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
+		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
+		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
+		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
+		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
+		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
+		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
+		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
+		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ 0, 0, 0, 0, 0 }
+	};
+
+	for (cb = cpuid_bits; cb->feature; cb++) {
+
+		/* Verify that the level is valid */
+		max_level = cpuid_eax(cb->level & 0xffff0000);
+		if (max_level < cb->level ||
+		    max_level > (cb->level | 0xffff))
+			continue;
+
+		cpuid_count(cb->level, cb->sub_leaf, &regs[CR_EAX],
+			    &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);
+
+		if (regs[cb->reg] & (1 << cb->bit))
+			set_cpu_cap(c, cb->feature);
+	}
+}
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
new file mode 100644
index 0000000..4397e98
--- /dev/null
+++ b/arch/x86/kernel/cpu/topology.c
@@ -0,0 +1,99 @@
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+
+#include <linux/cpu.h>
+#include <asm/apic.h>
+#include <asm/pat.h>
+#include <asm/processor.h>
+
+/* leaf 0xb SMT level */
+#define SMT_LEVEL	0
+
+/* leaf 0xb sub-leaf types */
+#define INVALID_TYPE	0
+#define SMT_TYPE	1
+#define CORE_TYPE	2
+
+#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
+#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
+#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
+
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned int eax, ebx, ecx, edx, sub_index;
+	unsigned int ht_mask_width, core_plus_mask_width;
+	unsigned int core_select_mask, core_level_siblings;
+	static bool printed;
+
+	if (c->cpuid_level < 0xb)
+		return;
+
+	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
+
+	/*
+	 * check if the cpuid leaf 0xb is actually implemented.
+	 */
+	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
+
+	/*
+	 * initial apic id, which also represents 32-bit extended x2apic id.
+	 */
+	c->initial_apicid = edx;
+
+	/*
+	 * Populate HT related information from sub-leaf level 0.
+	 */
+	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
+	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+
+	sub_index = 1;
+	do {
+		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * Check for the Core type in the implemented sub leaves.
+		 */
+		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
+			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
+			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+			break;
+		}
+
+		sub_index++;
+	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+
+	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+
+	c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
+						 & core_select_mask;
+	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+	/*
+	 * Reinit the apicid, now that we have extended initial_apicid.
+	 */
+	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+
+	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
+
+	if (!printed) {
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+		if (c->x86_max_cores > 1)
+			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+			       c->cpu_core_id);
+		printed = 1;
+	}
+	return;
+#endif
+}
