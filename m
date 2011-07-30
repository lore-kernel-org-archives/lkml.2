Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1G3Wee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:34:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38529 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab1G3WeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:34:16 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH v2 2/2] x86, random: Add support for architectural random number generator
Date: Sat, 30 Jul 2011 15:26:23 -0700
Message-Id: <1312064783-9033-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312064783-9033-1-git-send-email-hpa@zytor.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1312064783-9033-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

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

Since this instruction is available in userspace, there is no reason
to have a /dev/hw_rng device driver for the purpose of feeding rngd.
This is especially so since RDRAND is a nonblocking source, and needs
additional whitening and reduction (see the above technical
documentation for details) in order to be of "pure entropy source"
quality.

The nordrand kernel parameter or a CONFIG_EXPERT compile-time option
can be used to disable this use of RDRAND.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Originally-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/kernel-parameters.txt |    5 +++
 arch/x86/Kconfig                    |    9 +++++
 arch/x86/kernel/Makefile            |    2 +
 arch/x86/kernel/rdrand.c            |   65 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/rdrand_asm.S        |   57 ++++++++++++++++++++++++++++++
 5 files changed, 138 insertions(+), 0 deletions(-)
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
index 90b06d4..d45d889 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
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
index 0000000..df0e46b
--- /dev/null
+++ b/arch/x86/kernel/rdrand.c
@@ -0,0 +1,65 @@
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
+void arch_setup_random_funcs(arch_random_func_t *nonblocking_func,
+			     arch_random_func_t *blocking_func)
+{
+	int i, count, ok;
+	unsigned long tmp;
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
+
+	if (likely(count == RESEED_LOOP))
+		*nonblocking_func = x86_rdrand_long;
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

