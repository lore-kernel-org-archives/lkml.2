Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2HOUCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:02:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:37347 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2HOTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 145/165] x86, random: Architectural inlines to get random integers with RDRAND
Date: Wed, 15 Aug 2012 15:48:09 -0400
Message-ID: <1345060109-9187-146-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
---
 arch/x86/Kconfig                  |  9 +++++
 arch/x86/include/asm/archrandom.h | 73 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)
 create mode 100644 arch/x86/include/asm/archrandom.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b99909c..0a813f8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1460,6 +1460,15 @@ config ARCH_USES_PG_UNCACHED
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
1.7.12.rc2

