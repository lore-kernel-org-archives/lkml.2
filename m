Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab1JZPu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:50:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933544Ab1JZPuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:50:24 -0400
Date: Wed, 26 Oct 2011 17:48:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/rdrand changes for v3.2
Message-ID: <20111026154846.GA2476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-rdrand-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-rdrand-for-linus


out-of-topic modifications in x86-rdrand-for-linus:
---------------------------------------------------
drivers/char/random.c              # 63d7717: random: Add support for architect
include/linux/random.h             # 63d7717: random: Add support for architect

 Thanks,

	Ingo

------------------>
H. Peter Anvin (3):
      random: Add support for architectural random hooks
      x86, random: Architectural inlines to get random integers with RDRAND
      x86, random: Verify RDRAND functionality and allow it to be disabled


 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/Kconfig                    |    9 ++++
 arch/x86/include/asm/archrandom.h   |   75 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/Makefile        |    1 +
 arch/x86/kernel/cpu/common.c        |    2 +
 arch/x86/kernel/cpu/rdrand.c        |   73 ++++++++++++++++++++++++++++++++++
 drivers/char/random.c               |   25 ++++++++++-
 include/linux/random.h              |   13 ++++++
 8 files changed, 200 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/archrandom.h
 create mode 100644 arch/x86/kernel/cpu/rdrand.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index aa47be7..397ee05 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1764,6 +1764,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	noresidual	[PPC] Don't use residual data on PReP machines.
 
+	nordrand	[X86] Disable the direct use of the RDRAND
+			instruction even if it is supported by the
+			processor.  RDRAND is still available to user
+			space applications.
+
 	noresume	[SWSUSP] Disables resume and restores original swap
 			space.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 37357a5..a0e9bda 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1451,6 +1451,15 @@ config ARCH_USES_PG_UNCACHED
 	def_bool y
 	depends on X86_PAT
 
+config ARCH_RANDOM
+	def_bool y
+	prompt "x86 architectural random number generator" if EXPERT
+	---help---
+	  Enable the x86 architectural RDRAND instruction
+	  (Intel Bull Mountain technology) to generate random numbers.
+	  If supported, this is a high bandwidth, cryptographically
+	  secure hardware random number generator.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
new file mode 100644
index 0000000..0d9ec77
--- /dev/null
+++ b/arch/x86/include/asm/archrandom.h
@@ -0,0 +1,75 @@
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
+#ifndef ASM_X86_ARCHRANDOM_H
+#define ASM_X86_ARCHRANDOM_H
+
+#include <asm/processor.h>
+#include <asm/cpufeature.h>
+#include <asm/alternative.h>
+#include <asm/nops.h>
+
+#define RDRAND_RETRY_LOOPS	10
+
+#define RDRAND_INT	".byte 0x0f,0xc7,0xf0"
+#ifdef CONFIG_X86_64
+# define RDRAND_LONG	".byte 0x48,0x0f,0xc7,0xf0"
+#else
+# define RDRAND_LONG	RDRAND_INT
+#endif
+
+#ifdef CONFIG_ARCH_RANDOM
+
+#define GET_RANDOM(name, type, rdrand, nop)			\
+static inline int name(type *v)					\
+{								\
+	int ok;							\
+	alternative_io("movl $0, %0\n\t"			\
+		       nop,					\
+		       "\n1: " rdrand "\n\t"			\
+		       "jc 2f\n\t"				\
+		       "decl %0\n\t"                            \
+		       "jnz 1b\n\t"                             \
+		       "2:",                                    \
+		       X86_FEATURE_RDRAND,                      \
+		       ASM_OUTPUT2("=r" (ok), "=a" (*v)),       \
+		       "0" (RDRAND_RETRY_LOOPS));		\
+	return ok;						\
+}
+
+#ifdef CONFIG_X86_64
+
+GET_RANDOM(arch_get_random_long, unsigned long, RDRAND_LONG, ASM_NOP5);
+GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP4);
+
+#else
+
+GET_RANDOM(arch_get_random_long, unsigned long, RDRAND_LONG, ASM_NOP3);
+GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP3);
+
+#endif /* CONFIG_X86_64 */
+
+#endif  /* CONFIG_ARCH_RANDOM */
+
+extern void x86_init_rdrand(struct cpuinfo_x86 *c);
+
+#endif /* ASM_X86_ARCHRANDOM_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..0e3a82a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -15,6 +15,7 @@ CFLAGS_common.o		:= $(nostackp)
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
+obj-y			+= rdrand.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..8dbd929 100644
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
@@ -857,6 +858,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
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
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4ddeba..bb58712 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -932,7 +932,21 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
  */
 void get_random_bytes(void *buf, int nbytes)
 {
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+	char *p = buf;
+
+	while (nbytes) {
+		unsigned long v;
+		int chunk = min(nbytes, (int)sizeof(unsigned long));
+		
+		if (!arch_get_random_long(&v))
+			break;
+		
+		memcpy(buf, &v, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+
+	extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
 }
 EXPORT_SYMBOL(get_random_bytes);
 
@@ -1635,8 +1649,13 @@ DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
 unsigned int get_random_int(void)
 {
 	struct keydata *keyptr;
-	__u32 *hash = get_cpu_var(get_random_int_hash);
-	int ret;
+	__u32 *hash;
+	unsigned int ret;
+
+	if (arch_get_random_int(&ret))
+		return ret;
+
+	hash = get_cpu_var(get_random_int_hash);
 
 	keyptr = get_keyptr();
 	hash[0] += current->pid + jiffies + get_cycles();
diff --git a/include/linux/random.h b/include/linux/random.h
index fb7ab9d..079cbba 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -102,6 +102,19 @@ static inline void prandom32_seed(struct rnd_state *state, u64 seed)
 	state->s3 = __seed(i, 15);
 }
 
+#ifdef CONFIG_ARCH_RANDOM
+# include <asm/archrandom.h>
+#else
+static inline int arch_get_random_long(unsigned long *v)
+{
+	return 0;
+}
+static inline int arch_get_random_int(unsigned int *v)
+{
+	return 0;
+}
+#endif
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
