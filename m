Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0CRLTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:19:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37974 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0CRLTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:19:16 -0400
Date: Thu, 18 Mar 2010 12:19:29 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/2] bitops: Optimize hweight() by making use of
 compile-time evaluation
Message-ID: <20100318111929.GB11152@aftab>
References: <20100223155852.GF30382@aftab>
 <4B84118C.90203@zytor.com>
 <20100223175457.GA2401@aftab>
 <4B841BC3.1000908@zytor.com>
 <20100223190614.GB2401@aftab>
 <4B875BBD.4060104@zytor.com>
 <20100226074714.GA15310@aftab>
 <4B88097E.7010608@zytor.com>
 <20100227082807.GA21706@aftab>
 <4B8979DA.9000201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8979DA.9000201@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 1 Feb 2010 15:03:07 +0100
Subject: [PATCH 1/2] bitops: Optimize hweight() by making use of compile-time evaluation

Rename the extisting runtime hweight() implementations to
__arch_hweight(), rename the compile-time versions to __const_hweight()
and then have hweight() pick between them.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1265028224.24455.154.camel@laptop>
---
 arch/alpha/include/asm/bitops.h            |   18 ++++++-----
 arch/ia64/include/asm/bitops.h             |   11 ++++---
 arch/sparc/include/asm/bitops_64.h         |   11 ++++---
 include/asm-generic/bitops/arch_hweight.h  |   11 +++++++
 include/asm-generic/bitops/const_hweight.h |   42 ++++++++++++++++++++++++++++
 include/asm-generic/bitops/hweight.h       |    8 +----
 include/linux/bitops.h                     |   25 ----------------
 lib/hweight.c                              |   19 ++++++------
 8 files changed, 87 insertions(+), 58 deletions(-)
 create mode 100644 include/asm-generic/bitops/arch_hweight.h
 create mode 100644 include/asm-generic/bitops/const_hweight.h

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 15f3ae2..296da1d 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -405,29 +405,31 @@ static inline int fls(int x)
 
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
 /* Whee.  EV67 can calculate it directly.  */
-static inline unsigned long hweight64(unsigned long w)
+static inline unsigned long __arch_hweight64(unsigned long w)
 {
 	return __kernel_ctpop(w);
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_weight32(unsigned int w)
 {
-	return hweight64(w);
+	return __arch_hweight64(w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
-	return hweight64(w & 0xffff);
+	return __arch_hweight64(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
-	return hweight64(w & 0xff);
+	return __arch_hweight64(w & 0xff);
 }
 #else
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 #endif
 
+#include <asm-generic/bitops/const_hweight.h>
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 6ebc229..9da3df6 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -437,17 +437,18 @@ __fls (unsigned long x)
  * hweightN: returns the hamming weight (i.e. the number
  * of bits set) of a N-bit word
  */
-static __inline__ unsigned long
-hweight64 (unsigned long x)
+static __inline__ unsigned long __arch_hweight64(unsigned long x)
 {
 	unsigned long result;
 	result = ia64_popcnt(x);
 	return result;
 }
 
-#define hweight32(x)	(unsigned int) hweight64((x) & 0xfffffffful)
-#define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
-#define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
+#define __arch_hweight32(x) ((unsigned int) __arch_hweight64((x) & 0xfffffffful))
+#define __arch_hweight16(x) ((unsigned int) __arch_hweight64((x) & 0xfffful))
+#define __arch_hweight8(x)  ((unsigned int) __arch_hweight64((x) & 0xfful))
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index e72ac9c..766121a 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -44,7 +44,7 @@ extern void change_bit(unsigned long nr, volatile unsigned long *addr);
 
 #ifdef ULTRA_HAS_POPULATION_COUNT
 
-static inline unsigned int hweight64(unsigned long w)
+static inline unsigned int __arch_hweight64(unsigned long w)
 {
 	unsigned int res;
 
@@ -52,7 +52,7 @@ static inline unsigned int hweight64(unsigned long w)
 	return res;
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
 
@@ -60,7 +60,7 @@ static inline unsigned int hweight32(unsigned int w)
 	return res;
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res;
 
@@ -68,7 +68,7 @@ static inline unsigned int hweight16(unsigned int w)
 	return res;
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res;
 
@@ -78,9 +78,10 @@ static inline unsigned int hweight8(unsigned int w)
 
 #else
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 
 #endif
+#include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
new file mode 100644
index 0000000..3a7be84
--- /dev/null
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+
+#include <asm/types.h>
+
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
+extern unsigned long __arch_hweight64(__u64 w);
+
+#endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
new file mode 100644
index 0000000..fa2a50b
--- /dev/null
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+
+/*
+ * Compile time versions of __arch_hweightN()
+ */
+#define __const_hweight8(w)		\
+      (	(!!((w) & (1ULL << 0))) +	\
+	(!!((w) & (1ULL << 1))) +	\
+	(!!((w) & (1ULL << 2))) +	\
+	(!!((w) & (1ULL << 3))) +	\
+	(!!((w) & (1ULL << 4))) +	\
+	(!!((w) & (1ULL << 5))) +	\
+	(!!((w) & (1ULL << 6))) +	\
+	(!!((w) & (1ULL << 7)))	)
+
+#define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
+#define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
+#define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
+
+/*
+ * Generic interface.
+ */
+#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __arch_hweight8(w))
+#define hweight16(w) (__builtin_constant_p(w) ? __const_hweight16(w) : __arch_hweight16(w))
+#define hweight32(w) (__builtin_constant_p(w) ? __const_hweight32(w) : __arch_hweight32(w))
+#define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
+
+/*
+ * Interface for known constant arguments
+ */
+#define HWEIGHT8(w)  (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight8(w))
+#define HWEIGHT16(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight16(w))
+#define HWEIGHT32(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight32(w))
+#define HWEIGHT64(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight64(w))
+
+/*
+ * Type invariant interface to the compile time constant hweight functions.
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)w)
+
+#endif /* _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_ */
diff --git a/include/asm-generic/bitops/hweight.h b/include/asm-generic/bitops/hweight.h
index fbbc383..a94d651 100644
--- a/include/asm-generic/bitops/hweight.h
+++ b/include/asm-generic/bitops/hweight.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_GENERIC_BITOPS_HWEIGHT_H_
 #define _ASM_GENERIC_BITOPS_HWEIGHT_H_
 
-#include <asm/types.h>
-
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
+#include <asm-generic/bitops/arch_hweight.h>
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index b793898..c55d5bc 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -47,31 +47,6 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-/*
- * Clearly slow versions of the hweightN() functions, their benefit is
- * of course compile time evaluation of constant arguments.
- */
-#define HWEIGHT8(w)					\
-      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
-	(!!((w) & (1ULL << 0))) +			\
-	(!!((w) & (1ULL << 1))) +			\
-	(!!((w) & (1ULL << 2))) +			\
-	(!!((w) & (1ULL << 3))) +			\
-	(!!((w) & (1ULL << 4))) +			\
-	(!!((w) & (1ULL << 5))) +			\
-	(!!((w) & (1ULL << 6))) +			\
-	(!!((w) & (1ULL << 7)))	)
-
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
-
-/*
- * Type invariant version that simply casts things to the
- * largest type.
- */
-#define HWEIGHT(w)   HWEIGHT64((u64)(w))
-
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
diff --git a/lib/hweight.c b/lib/hweight.c
index 63ee4eb..a6927e7 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int hweight32(unsigned int w)
+unsigned int __arch_hweight32(unsigned int w)
 {
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x55555555;
@@ -24,29 +24,30 @@ unsigned int hweight32(unsigned int w)
 	return (res + (res >> 16)) & 0x000000FF;
 #endif
 }
-EXPORT_SYMBOL(hweight32);
+EXPORT_SYMBOL(__arch_hweight32);
 
-unsigned int hweight16(unsigned int w)
+unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(hweight16);
+EXPORT_SYMBOL(__arch_hweight16);
 
-unsigned int hweight8(unsigned int w)
+unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(hweight8);
+EXPORT_SYMBOL(__arch_hweight8);
 
-unsigned long hweight64(__u64 w)
+unsigned long __arch_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+	return __arch_hweight32((unsigned int)(w >> 32)) +
+	       __arch_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -63,4 +64,4 @@ unsigned long hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(hweight64);
+EXPORT_SYMBOL(__arch_hweight64);
-- 
1.7.0.2

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
