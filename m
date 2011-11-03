Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1KCDTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:19:50 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:9775 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1KCDTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:19:18 -0400
Message-Id: <201111030319.pA33JHFg005868@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 2 Nov 2011 22:19:25 -0400
Subject: [PATCH] arch/tile: avoid ISO namespace pollution with <asm/sigcontext.h>
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 03 Nov 2011 03:19:17.0952 (UTC) FILETIME=[5F1AEC00:01CC99D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<asm/sigcontext.h> is used by glibc's <bits/sigcontext.h> from <signal.h>,
which means that it can't clutter the namespace with random symbols
or #defines.  However, we use <arch/abi.h> to get a suitable type to
hold a machine register.

This change makes <arch/abi.h> safe to use in this kind of context
if __need_int_reg_t is defined prior to including the file; in that
case, it only defines a few symbols that are safe in the ISO namespace
(prefixed with double underscores).  <asm/sigcontext.h> then uses
the __uint_reg_t type instead of the normal uint_reg_t.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/abi.h       |   99 ++++++++++++++++++++++++++----------
 arch/tile/include/asm/sigcontext.h |   18 ++++---
 2 files changed, 82 insertions(+), 35 deletions(-)

diff --git a/arch/tile/include/arch/abi.h b/arch/tile/include/arch/abi.h
index 8affc76..c55a3d4 100644
--- a/arch/tile/include/arch/abi.h
+++ b/arch/tile/include/arch/abi.h
@@ -15,13 +15,78 @@
 /**
  * @file
  *
- * ABI-related register definitions helpful when writing assembly code.
+ * ABI-related register definitions.
  */
 
 #ifndef __ARCH_ABI_H__
-#define __ARCH_ABI_H__
 
-#include <arch/chip.h>
+#if !defined __need_int_reg_t && !defined __DOXYGEN__
+# define __ARCH_ABI_H__
+# include <arch/chip.h>
+#endif
+
+/* Provide the basic machine types. */
+#ifndef __INT_REG_BITS
+
+/** Number of bits in a register. */
+#if defined __tilegx__
+# define __INT_REG_BITS 64
+#elif defined __tilepro__
+# define __INT_REG_BITS 32
+#elif !defined __need_int_reg_t
+# include <arch/chip.h>
+# define __INT_REG_BITS CHIP_WORD_SIZE()
+#else
+# error Unrecognized architecture with __need_int_reg_t
+#endif
+
+#if __INT_REG_BITS == 64
+
+#ifndef __ASSEMBLER__
+/** Unsigned type that can hold a register. */
+typedef unsigned long long __uint_reg_t;
+
+/** Signed type that can hold a register. */
+typedef long long __int_reg_t;
+#endif
+
+/** String prefix to use for printf(). */
+#define __INT_REG_FMT "ll"
+
+#else
+
+#ifndef __ASSEMBLER__
+/** Unsigned type that can hold a register. */
+typedef unsigned long __uint_reg_t;
+
+/** Signed type that can hold a register. */
+typedef long __int_reg_t;
+#endif
+
+/** String prefix to use for printf(). */
+#define __INT_REG_FMT "l"
+
+#endif
+#endif /* __INT_REG_BITS */
+
+
+#ifndef __need_int_reg_t
+
+
+#ifndef __ASSEMBLER__
+/** Unsigned type that can hold a register. */
+typedef __uint_reg_t uint_reg_t;
+
+/** Signed type that can hold a register. */
+typedef __int_reg_t int_reg_t;
+#endif
+
+/** String prefix to use for printf(). */
+#define INT_REG_FMT __INT_REG_FMT
+
+/** Number of bits in a register. */
+#define INT_REG_BITS __INT_REG_BITS
+
 
 /* Registers 0 - 55 are "normal", but some perform special roles. */
 
@@ -59,7 +124,7 @@
  * The ABI requires callers to allocate a caller state save area of
  * this many bytes at the bottom of each stack frame.
  */
-#define C_ABI_SAVE_AREA_SIZE (2 * (CHIP_WORD_SIZE() / 8))
+#define C_ABI_SAVE_AREA_SIZE (2 * (INT_REG_BITS / 8))
 
 /**
  * The operand to an 'info' opcode directing the backtracer to not
@@ -67,30 +132,10 @@
  */
 #define INFO_OP_CANNOT_BACKTRACE 2
 
-#ifndef __ASSEMBLER__
-#if CHIP_WORD_SIZE() > 32
 
-/** Unsigned type that can hold a register. */
-typedef unsigned long long uint_reg_t;
+#endif /* !__need_int_reg_t */
 
-/** Signed type that can hold a register. */
-typedef long long int_reg_t;
-
-/** String prefix to use for printf(). */
-#define INT_REG_FMT "ll"
-
-#elif !defined(__LP64__)   /* avoid confusion with LP64 cross-build tools */
-
-/** Unsigned type that can hold a register. */
-typedef unsigned long uint_reg_t;
-
-/** Signed type that can hold a register. */
-typedef long int_reg_t;
-
-/** String prefix to use for printf(). */
-#define INT_REG_FMT "l"
-
-#endif
-#endif /* __ASSEMBLER__ */
+/* Make sure we later can get all the definitions and declarations.  */
+#undef __need_int_reg_t
 
 #endif /* !__ARCH_ABI_H__ */
diff --git a/arch/tile/include/asm/sigcontext.h b/arch/tile/include/asm/sigcontext.h
index 5e2d033..6348e59 100644
--- a/arch/tile/include/asm/sigcontext.h
+++ b/arch/tile/include/asm/sigcontext.h
@@ -15,6 +15,8 @@
 #ifndef _ASM_TILE_SIGCONTEXT_H
 #define _ASM_TILE_SIGCONTEXT_H
 
+/* Don't pollute the namespace since <signal.h> includes this file. */
+#define __need_int_reg_t
 #include <arch/abi.h>
 
 /*
@@ -22,14 +24,14 @@
  * but is simplified since we know the fault is from userspace.
  */
 struct sigcontext {
-	uint_reg_t gregs[53];	/* General-purpose registers.  */
-	uint_reg_t tp;		/* Aliases gregs[TREG_TP].  */
-	uint_reg_t sp;		/* Aliases gregs[TREG_SP].  */
-	uint_reg_t lr;		/* Aliases gregs[TREG_LR].  */
-	uint_reg_t pc;		/* Program counter.  */
-	uint_reg_t ics;		/* In Interrupt Critical Section?  */
-	uint_reg_t faultnum;	/* Fault number.  */
-	uint_reg_t pad[5];
+	__uint_reg_t gregs[53];	/* General-purpose registers.  */
+	__uint_reg_t tp;	/* Aliases gregs[TREG_TP].  */
+	__uint_reg_t sp;	/* Aliases gregs[TREG_SP].  */
+	__uint_reg_t lr;	/* Aliases gregs[TREG_LR].  */
+	__uint_reg_t pc;	/* Program counter.  */
+	__uint_reg_t ics;	/* In Interrupt Critical Section?  */
+	__uint_reg_t faultnum;	/* Fault number.  */
+	__uint_reg_t pad[5];
 };
 
 #endif /* _ASM_TILE_SIGCONTEXT_H */
-- 
1.6.5.2

