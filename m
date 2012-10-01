Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2JAXDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35689 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796Ab2JAXDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:53 -0400
Message-Id: <20121001225204.392628594@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 160/180] x86, random: Architectural inlines to get random integers with RDRAND
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 628c6246d47b85f5357298601df2444d7f4dd3fd upstream.

Architectural inlines to get random ints and longs using the RDRAND
instruction.

Intel has introduced a new RDRAND instruction, a Digital Random Number
Generator (DRNG), which is functionally an high bandwidth entropy
source, cryptographic whitener, and integrity monitor all built into
hardware.  This enables RDRAND to be used directly, bypassing the
kernel random number pool.

For technical documentation, see:

http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/

In this patch, this is *only* used for the nonblocking random number
pool.  RDRAND is a nonblocking source, similar to our /dev/urandom,
and is therefore not a direct replacement for /dev/random.  The
architectural hooks presented in the previous patch only feed the
kernel internal users, which only use the nonblocking pool, and so
this is not a problem.

Since this instruction is available in userspace, there is no reason
to have a /dev/hw_rng device driver for the purpose of feeding rngd.
This is especially so since RDRAND is a nonblocking source, and needs
additional whitening and reduction (see the above technical
documentation for details) in order to be of "pure entropy source"
quality.

The CONFIG_EXPERT compile-time option can be used to disable this use
of RDRAND.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Originally-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/Kconfig                  |    9 +++++
 arch/x86/include/asm/archrandom.h |   73 +++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/archrandom.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73ae02a..aa889d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1428,6 +1428,15 @@ config ARCH_USES_PG_UNCACHED
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
index 0000000..b7b5bc0
--- /dev/null
+++ b/arch/x86/include/asm/archrandom.h
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
+#endif /* ASM_X86_ARCHRANDOM_H */
-- 
1.7.2.1.45.g54fbc



