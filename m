Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1GaV2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 17:28:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60187 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1GaV2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 17:28:19 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH v3 2/3] x86, random: Architectural inlines to get random integers with RDRAND
Date: Sun, 31 Jul 2011 14:26:55 -0700
Message-Id: <1312147616-29125-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312147616-29125-1-git-send-email-hpa@zytor.com>
References: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com>
 <1312147616-29125-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

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
---
 arch/x86/Kconfig                  |    9 +++++
 arch/x86/include/asm/archrandom.h |   73 +++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/archrandom.h

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
1.7.6

