Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936773Ab2C3XCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:02:21 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934836Ab2C3VFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:13 -0400
Message-Id: <201203302104.q2UL4uKK006260@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 13:30:31 -0400
Subject: [PATCH] arch/tile: support building big-endian kernel
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>, Jonas Bonn <jonas@southpole.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:58.0241 (UTC) FILETIME=[C39FBF10:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The toolchain supports big-endian mode now, so add support for building
the kernel to run big-endian as well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/byteorder.h |   20 ++++++++++++++++++++
 arch/tile/include/asm/elf.h       |    5 +++++
 arch/tile/kernel/module.c         |   12 +++++++++++-
 arch/tile/kernel/single_step.c    |   16 ++++++++++++----
 arch/tile/lib/memchr_64.c         |    8 +++-----
 arch/tile/lib/memcpy_64.c         |   23 +++++++++++++++++++++--
 arch/tile/lib/strchr_64.c         |   15 +++++----------
 arch/tile/lib/string-endian.h     |   33 +++++++++++++++++++++++++++++++++
 arch/tile/lib/strlen_64.c         |   11 ++++-------
 9 files changed, 114 insertions(+), 29 deletions(-)
 create mode 100644 arch/tile/lib/string-endian.h

diff --git a/arch/tile/include/asm/byteorder.h b/arch/tile/include/asm/byteorder.h
index 9558416..fb72ecf 100644
--- a/arch/tile/include/asm/byteorder.h
+++ b/arch/tile/include/asm/byteorder.h
@@ -1 +1,21 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#if defined (__BIG_ENDIAN__)
+#include <linux/byteorder/big_endian.h>
+#elif defined (__LITTLE_ENDIAN__)
 #include <linux/byteorder/little_endian.h>
+#else
+#error "__BIG_ENDIAN__ or __LITTLE_ENDIAN__ must be defined."
+#endif
diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index 623a6bb..d16d006 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -44,7 +44,11 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 #else
 #define ELF_CLASS	ELFCLASS32
 #endif
+#ifdef __BIG_ENDIAN__
+#define ELF_DATA	ELFDATA2MSB
+#else
 #define ELF_DATA	ELFDATA2LSB
+#endif
 
 /*
  * There seems to be a bug in how compat_binfmt_elf.c works: it
@@ -59,6 +63,7 @@ enum { ELF_ARCH = CHIP_ELF_TYPE() };
  */
 #define elf_check_arch(x)  \
 	((x)->e_ident[EI_CLASS] == ELF_CLASS && \
+	 (x)->e_ident[EI_DATA] == ELF_DATA && \
 	 (x)->e_machine == CHIP_ELF_TYPE())
 
 /* The module loader only handles a few relocation types. */
diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index b90ab99..bb2dc1e 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -157,7 +157,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 
 		switch (ELF_R_TYPE(rel[i].r_info)) {
 
-#define MUNGE(func) (*location = ((*location & ~func(-1)) | func(value)))
+#ifdef __LITTLE_ENDIAN
+# define MUNGE(func) \
+	(*location = ((*location & ~func(-1)) | func(value)))
+#else
+/*
+ * Instructions are always little-endian, so when we read them as data,
+ * we have to swap them around before and after modifying them.
+ */
+# define MUNGE(func) \
+	(*location = swab64((swab64(*location) & ~func(-1)) | func(value)))
+#endif
 
 #ifndef __tilegx__
 		case R_TILE_32:
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index b7a8795..b231ef4 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -152,9 +152,6 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 	if (((unsigned long)addr % size) == 0)
 		return bundle;
 
-#ifndef __LITTLE_ENDIAN
-# error We assume little-endian representation with copy_xx_user size 2 here
-#endif
 	/* Handle unaligned load/store */
 	if (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) {
 		unsigned short val_16;
@@ -175,8 +172,19 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 			state->update = 1;
 		}
 	} else {
+		unsigned short val_16;
 		val = (val_reg == TREG_ZERO) ? 0 : regs->regs[val_reg];
-		err = copy_to_user(addr, &val, size);
+		switch (size) {
+		case 2:
+			val_16 = val;
+			err = copy_to_user(addr, &val_16, sizeof(val_16));
+			break;
+		case 4:
+			err = copy_to_user(addr, &val, sizeof(val));
+			break;
+		default:
+			BUG();
+		}
 	}
 
 	if (err) {
diff --git a/arch/tile/lib/memchr_64.c b/arch/tile/lib/memchr_64.c
index 84fdc8d..6f867db 100644
--- a/arch/tile/lib/memchr_64.c
+++ b/arch/tile/lib/memchr_64.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
+#include "string-endian.h"
 
 void *memchr(const void *s, int c, size_t n)
 {
@@ -39,11 +40,8 @@ void *memchr(const void *s, int c, size_t n)
 
 	/* Read the first word, but munge it so that bytes before the array
 	 * will not match goal.
-	 *
-	 * Note that this shift count expression works because we know
-	 * shift counts are taken mod 64.
 	 */
-	before_mask = (1ULL << (s_int << 3)) - 1;
+	before_mask = MASK(s_int);
 	v = (*p | before_mask) ^ (goal & before_mask);
 
 	/* Compute the address of the last byte. */
@@ -65,7 +63,7 @@ void *memchr(const void *s, int c, size_t n)
 	/* We found a match, but it might be in a byte past the end
 	 * of the array.
 	 */
-	ret = ((char *)p) + (__insn_ctz(bits) >> 3);
+	ret = ((char *)p) + (CFZ(bits) >> 3);
 	return (ret <= last_byte_ptr) ? ret : NULL;
 }
 EXPORT_SYMBOL(memchr);
diff --git a/arch/tile/lib/memcpy_64.c b/arch/tile/lib/memcpy_64.c
index 3fab9a6..c79b8e7 100644
--- a/arch/tile/lib/memcpy_64.c
+++ b/arch/tile/lib/memcpy_64.c
@@ -15,7 +15,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-#define __memcpy memcpy
 /* EXPORT_SYMBOL() is in arch/tile/lib/exports.c since this should be asm. */
 
 /* Must be 8 bytes in size. */
@@ -188,6 +187,7 @@ int USERCOPY_FUNC(void *__restrict dstv, const void *__restrict srcv, size_t n)
 
 	/* n != 0 if we get here.  Write out any trailing bytes. */
 	dst1 = (char *)dst8;
+#ifndef __BIG_ENDIAN__
 	if (n & 4) {
 		ST4((uint32_t *)dst1, final);
 		dst1 += 4;
@@ -202,11 +202,30 @@ int USERCOPY_FUNC(void *__restrict dstv, const void *__restrict srcv, size_t n)
 	}
 	if (n)
 		ST1((uint8_t *)dst1, final);
+#else
+	if (n & 4) {
+		ST4((uint32_t *)dst1, final >> 32);
+		dst1 += 4;
+        }
+        else
+        {
+		final >>= 32;
+        }
+	if (n & 2) {
+		ST2((uint16_t *)dst1, final >> 16);
+		dst1 += 2;
+        }
+        else
+        {
+		final >>= 16;
+        }
+	if (n & 1)
+		ST1((uint8_t *)dst1, final >> 8);
+#endif
 
 	return RETVAL;
 }
 
-
 #ifdef USERCOPY_FUNC
 #undef ST1
 #undef ST2
diff --git a/arch/tile/lib/strchr_64.c b/arch/tile/lib/strchr_64.c
index 617a927..f39f9dc 100644
--- a/arch/tile/lib/strchr_64.c
+++ b/arch/tile/lib/strchr_64.c
@@ -15,8 +15,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-
-#undef strchr
+#include "string-endian.h"
 
 char *strchr(const char *s, int c)
 {
@@ -33,13 +32,9 @@ char *strchr(const char *s, int c)
 	 * match neither zero nor goal (we make sure the high bit of each
 	 * byte is 1, and the low 7 bits are all the opposite of the goal
 	 * byte).
-	 *
-	 * Note that this shift count expression works because we know shift
-	 * counts are taken mod 64.
 	 */
-	const uint64_t before_mask = (1ULL << (s_int << 3)) - 1;
-	uint64_t v = (*p | before_mask) ^
-		(goal & __insn_v1shrsi(before_mask, 1));
+	const uint64_t before_mask = MASK(s_int);
+	uint64_t v = (*p | before_mask) ^ (goal & __insn_v1shrui(before_mask, 1));
 
 	uint64_t zero_matches, goal_matches;
 	while (1) {
@@ -55,8 +50,8 @@ char *strchr(const char *s, int c)
 		v = *++p;
 	}
 
-	z = __insn_ctz(zero_matches);
-	g = __insn_ctz(goal_matches);
+	z = CFZ(zero_matches);
+	g = CFZ(goal_matches);
 
 	/* If we found c before '\0' we got a match. Note that if c == '\0'
 	 * then g == z, and we correctly return the address of the '\0'
diff --git a/arch/tile/lib/string-endian.h b/arch/tile/lib/string-endian.h
new file mode 100644
index 0000000..c0eed7c
--- /dev/null
+++ b/arch/tile/lib/string-endian.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Provide a mask based on the pointer alignment that
+ * sets up non-zero bytes before the beginning of the string.
+ * The MASK expression works because shift counts are taken mod 64.
+ * Also, specify how to count "first" and "last" bits
+ * when the bits have been read as a word.
+ */
+
+#include <asm/byteorder.h>
+
+#ifdef __LITTLE_ENDIAN
+#define MASK(x) (__insn_shl(1ULL, (x << 3)) - 1)
+#define NULMASK(x) ((2ULL << x) - 1)
+#define CFZ(x) __insn_ctz(x)
+#define REVCZ(x) __insn_clz(x)
+#else
+#define MASK(x) (__insn_shl(-2LL, ((-x << 3) - 1)))
+#define NULMASK(x) (-2LL << (63 - x))
+#define CFZ(x) __insn_clz(x)
+#define REVCZ(x) __insn_ctz(x)
+#endif
diff --git a/arch/tile/lib/strlen_64.c b/arch/tile/lib/strlen_64.c
index 1c92d46..9583fc3 100644
--- a/arch/tile/lib/strlen_64.c
+++ b/arch/tile/lib/strlen_64.c
@@ -15,8 +15,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-
-#undef strlen
+#include "string-endian.h"
 
 size_t strlen(const char *s)
 {
@@ -24,15 +23,13 @@ size_t strlen(const char *s)
 	const uintptr_t s_int = (uintptr_t) s;
 	const uint64_t *p = (const uint64_t *)(s_int & -8);
 
-	/* Read the first word, but force bytes before the string to be nonzero.
-	 * This expression works because we know shift counts are taken mod 64.
-	 */
-	uint64_t v = *p | ((1ULL << (s_int << 3)) - 1);
+	/* Read and MASK the first word. */
+	uint64_t v = *p | MASK(s_int);
 
 	uint64_t bits;
 	while ((bits = __insn_v1cmpeqi(v, 0)) == 0)
 		v = *++p;
 
-	return ((const char *)p) + (__insn_ctz(bits) >> 3) - s;
+	return ((const char *)p) + (CFZ(bits) >> 3) - s;
 }
 EXPORT_SYMBOL(strlen);
-- 
1.6.5.2

