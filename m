Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2JAXbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:31:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35178 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab2JAXAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:33 -0400
Message-Id: <20121001225204.434891290@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Tso" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>
Subject: [ 161/180] x86, random: Verify RDRAND functionality and allow it to be disabled
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 49d859d78c5aeb998b6936fcb5f288f78d713489 upstream.

If the CPU declares that RDRAND is available, go through a guranteed
reseed sequence, and make sure that it is actually working (producing
data.)   If it does not, disable the CPU feature flag.

Allow RDRAND to be disabled on the command line (as opposed to at
compile time) for a user who has special requirements with regards to
random numbers.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/include/asm/archrandom.h   |    2 +
 arch/x86/kernel/cpu/Makefile        |    1 +
 arch/x86/kernel/cpu/common.c        |    2 +
 arch/x86/kernel/cpu/rdrand.c        |   73 +++++++++++++++++++++++++++++++++++
 5 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/rdrand.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c840e7d..14c7fb0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1725,6 +1725,11 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	noresidual	[PPC] Don't use residual data on PReP machines.
 
+	nordrand	[X86] Disable the direct use of the RDRAND
+			instruction even if it is supported by the
+			processor.  RDRAND is still available to user
+			space applications.
+
 	noresume	[SWSUSP] Disables resume and restores original swap
 			space.
 
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index b7b5bc0..0d9ec77 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -70,4 +70,6 @@ GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP3);
 
 #endif  /* CONFIG_ARCH_RANDOM */
 
+extern void x86_init_rdrand(struct cpuinfo_x86 *c);
+
 #endif /* ASM_X86_ARCHRANDOM_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ff502cc..1f537a2 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,6 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o
+obj-y			+= rdrand.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4e34d10..ba1a1dd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -15,6 +15,7 @@
 #include <asm/stackprotector.h>
 #include <asm/perf_event.h>
 #include <asm/mmu_context.h>
+#include <asm/archrandom.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
@@ -815,6 +816,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #endif
 
 	init_hypervisor(c);
+	x86_init_rdrand(c);
 
 	/*
 	 * Clear/Set all flags overriden by options, need do it
diff --git a/arch/x86/kernel/cpu/rdrand.c b/arch/x86/kernel/cpu/rdrand.c
new file mode 100644
index 0000000..feca286
--- /dev/null
+++ b/arch/x86/kernel/cpu/rdrand.c
@@ -0,0 +1,73 @@
+/*
+ * This file is part of the Linux kernel.
+ *
+ * Copyright (c) 2011, Intel Corporation
+ * Authors: Fenghua Yu <fenghua.yu@intel.com>,
+ *          H. Peter Anvin <hpa@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <asm/processor.h>
+#include <asm/archrandom.h>
+#include <asm/sections.h>
+
+static int __init x86_rdrand_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_RDRAND);
+	return 1;
+}
+__setup("nordrand", x86_rdrand_setup);
+
+/* We can't use arch_get_random_long() here since alternatives haven't run */
+static inline int rdrand_long(unsigned long *v)
+{
+	int ok;
+	asm volatile("1: " RDRAND_LONG "\n\t"
+		     "jc 2f\n\t"
+		     "decl %0\n\t"
+		     "jnz 1b\n\t"
+		     "2:"
+		     : "=r" (ok), "=a" (*v)
+		     : "0" (RDRAND_RETRY_LOOPS));
+	return ok;
+}
+
+/*
+ * Force a reseed cycle; we are architecturally guaranteed a reseed
+ * after no more than 512 128-bit chunks of random data.  This also
+ * acts as a test of the CPU capability.
+ */
+#define RESEED_LOOP ((512*128)/sizeof(unsigned long))
+
+void __cpuinit x86_init_rdrand(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_ARCH_RANDOM
+	unsigned long tmp;
+	int i, count, ok;
+
+	if (!cpu_has(c, X86_FEATURE_RDRAND))
+		return;		/* Nothing to do */
+
+	for (count = i = 0; i < RESEED_LOOP; i++) {
+		ok = rdrand_long(&tmp);
+		if (ok)
+			count++;
+	}
+
+	if (count != RESEED_LOOP)
+		clear_cpu_cap(c, X86_FEATURE_RDRAND);
+#endif
+}
-- 
1.7.2.1.45.g54fbc



