Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1G2Uib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:38:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:46167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1G2UiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,288,1309762800"; 
   d="scan'208";a="33645168"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/2] x86, random: Add support for architectural random number generator
Date: Fri, 29 Jul 2011 13:37:47 -0700
Message-Id: <1311971867-25124-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Intel has introduced a new RDRAND instruction, a Digital Random Number
Generator (DRNG), which is functionally an high bandwidth entropy
source, cryptographic whitener, and integrity monitor all built into
hardware.  This enables RDRAND to be used directly, bypassing the
kernel random number pool.

For technical documentation, see:

http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/

In this patch, this is *only* used for the nonblocking random number
pool.  RDRAND is a nonblocking source, similar to our /dev/urandom,
and is therefore not a direct replacement for /dev/random.  It can,
and presumably should, be used to feed the blocking entropy pool as
well, but that is not implemented in this patch and may be better done
in rngd.

The nordrand kernel parameter or a CONFIG_EXPERT compile-time option
can be used to disable this use of RDRAND.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/kernel-parameters.txt |    5 +
 arch/x86/Kconfig                    |    9 ++
 arch/x86/kernel/Makefile            |    6 +-
 arch/x86/kernel/rdrand.c            |  148 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/rdrand_asm.S        |   57 +++++++++++++
 5 files changed, 223 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/rdrand.c
 create mode 100644 arch/x86/kernel/rdrand_asm.S

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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90b06d4..ce5f7f3b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -86,12 +86,12 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module.o
-obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_DOUBLEFAULT)	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
-obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
+obj-$(CONFIG_HPET_TIMER)	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
 obj-$(CONFIG_AMD_NB)		+= amd_nb.o
@@ -116,6 +116,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 
+obj-$(CONFIG_ARCH_RANDOM)		+= rdrand.o rdrand_asm.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/rdrand.c b/arch/x86/kernel/rdrand.c
new file mode 100644
index 0000000..d89b122
--- /dev/null
+++ b/arch/x86/kernel/rdrand.c
@@ -0,0 +1,148 @@
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
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+
+extern int x86_rdrand_long(unsigned long *x); /* In rdrand_asm.S */
+
+/* Clear a variable and make sure it is actually zeroed in memory */
+#define ZERO_VAR(x) do {			\
+	(x) = 0;				\
+	asm volatile("" : : "m" (x));		\
+} while (0)
+
+static ssize_t x86_random_bytes_krnl(void *buf, size_t size)
+{
+	unsigned long *p1 = (unsigned long *)buf;
+	unsigned long rnd;
+	ssize_t ret = 0;
+	int ok;
+
+	if (!boot_cpu_has(X86_FEATURE_RDRAND))
+		return 0;
+
+	while (size >= sizeof *p1) {
+		ok = x86_rdrand_long(p1);
+		if (unlikely(!ok))
+			goto out;
+		p1++;
+		size -= sizeof *p1;
+		ret  += sizeof *p1;
+	}
+
+	if (size) {
+		ok = x86_rdrand_long(&rnd);
+		if (unlikely(!ok))
+			goto out;
+		memcpy(p1, &rnd, size);
+		ret += size;
+	}
+
+out:
+	ZERO_VAR(rnd);
+	return ret;
+}
+
+static ssize_t x86_random_bytes_user(void __user *buf, size_t size)
+{
+	char __user *p1 = (char __user *)buf;
+	unsigned long rnd;
+	size_t chunk;
+	ssize_t ret = 0;
+	int ok, err;
+
+	if (!boot_cpu_has(X86_FEATURE_RDRAND))
+		return 0;
+
+	while (size >= sizeof rnd) {
+		ok = x86_rdrand_long(&rnd);
+		if (unlikely(!ok))
+			goto out;
+		err = copy_to_user(p1, &rnd, sizeof rnd);
+		chunk  = sizeof rnd - err;
+		p1    += chunk;
+		ret   += chunk;
+		size  -= chunk;
+		if (err)
+			goto out;
+	}
+
+	if (size) {
+		ok = x86_rdrand_long(&rnd);
+		if (unlikely(!ok))
+			goto out;
+		err = copy_to_user(p1, &rnd, size);
+		chunk  = size - err;
+		p1    += chunk;
+		ret   += chunk;
+		size  -= chunk;
+	}
+
+out:
+	ZERO_VAR(rnd);
+	return ret;
+}
+
+/*
+ * Force a reseed cycle; we are architecturally guaranteed a reseed
+ * after no more than 512 128-bit chunks of random data.  This also
+ * acts as a test of the CPU capability.
+ */
+#define RESEED_LOOP ((512*128)/sizeof(unsigned long))
+
+static bool rdrand_disabled;
+
+static __init int disable_rdrand(char *s)
+{
+	rdrand_disabled = true;
+	return 1;
+}
+__setup("nordrand", disable_rdrand);
+
+void arch_setup_random_funcs(struct get_entropy_funcs *nbp,
+			     struct get_entropy_funcs *bp)
+{
+	int i, count, ok;
+	unsigned long tmp;
+
+	(void)bp;		/* Do nothing to the blocking pool */
+
+	if (!boot_cpu_has(X86_FEATURE_RDRAND) || rdrand_disabled) {
+		/* Nothing available... */
+		return;
+	}
+
+	for (count = i = 0; i < RESEED_LOOP; i++) {
+		ok = x86_rdrand_long(&tmp);
+		if (ok)
+			count++;
+	}
+	ZERO_VAR(tmp);
+
+	if (likely(count == RESEED_LOOP)) {
+		nbp->get_entropy_krnl = x86_random_bytes_krnl;
+		nbp->get_entropy_user = x86_random_bytes_user;
+	}
+}
diff --git a/arch/x86/kernel/rdrand_asm.S b/arch/x86/kernel/rdrand_asm.S
new file mode 100644
index 0000000..5393565
--- /dev/null
+++ b/arch/x86/kernel/rdrand_asm.S
@@ -0,0 +1,57 @@
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
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+#define RDRAND_RETRY_LIMIT	10
+
+#ifdef CONFIG_X86_64
+ENTRY(x86_rdrand_long)
+	mov	$RDRAND_RETRY_LIMIT, %eax
+1:
+	.byte 0x48, 0x0f, 0xc7, 0xf2	/* rdrand %rdx */
+	jnc	2f
+	mov	%rdx, (%rdi)
+	ret
+2:
+	dec	%eax
+	rep;nop
+	jnz	1b
+	ret
+ENDPROC(x86_rdrand_long)
+#else
+ENTRY(x86_rdrand_long)
+	mov	%eax, %ecx
+	mov	$RDRAND_RETRY_LIMIT, %eax
+1:
+	.byte 0x0f, 0xc7, 0xf2		/* rdrand %edx */
+	jnc	2f
+	mov	%edx, (%ecx)
+	ret
+2:
+	dec	%eax
+	rep;nop
+	jnz	1b
+	ret
+ENDPROC(x86_rdrand_long)
+#endif
-- 
1.7.6

