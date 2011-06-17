Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655Ab1FQT54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:57:56 -0400
Received: from outmail013.snc4.facebook.com ([66.220.144.145]:55908 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933041Ab1FQT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:57:46 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 3/4] atomic: cleanup asm-generic atomic*.h inclusion
Date: Fri, 17 Jun 2011 12:57:09 -0700
Message-Id: <1308340630-16008-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1308340630-16008-1-git-send-email-asharma@fb.com>
References: <1308340630-16008-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After changing all consumers of atomics to include
<linux/atomic.h>, we ran into some compile time errors
due to this dependency chain:

linux/atomic.h
  -> asm/atomic.h
    -> asm-generic/atomic-long.h

where atomic-long.h could use funcs defined later in
linux/atomic.h without a prototype. This patches moves
the code that includes asm-generic/atomic*.h to
linux/atomic.h.

Archs that need <asm-generic/atomic64.h> need to select
CONFIG_GENERIC_ATOMIC64 from now on (some of them used
to include it unconditionally).

Compile tested on i386 and x86_64 with allnoconfig.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
---
 arch/alpha/include/asm/atomic.h    |    1 -
 arch/arm/include/asm/atomic.h      |    5 +----
 arch/avr32/include/asm/atomic.h    |    2 --
 arch/blackfin/include/asm/atomic.h |    3 ---
 arch/cris/include/asm/atomic.h     |    1 -
 arch/frv/include/asm/atomic.h      |    1 -
 arch/h8300/include/asm/atomic.h    |    1 -
 arch/ia64/include/asm/atomic.h     |    1 -
 arch/m32r/include/asm/atomic.h     |    1 -
 arch/m68k/include/asm/atomic.h     |    2 --
 arch/mips/include/asm/atomic.h     |    6 ------
 arch/mn10300/include/asm/atomic.h  |    2 --
 arch/parisc/include/asm/atomic.h   |    5 -----
 arch/powerpc/include/asm/atomic.h  |    4 ----
 arch/s390/include/asm/atomic.h     |    2 --
 arch/sh/include/asm/atomic.h       |    3 ---
 arch/sparc/include/asm/atomic_32.h |    1 -
 arch/sparc/include/asm/atomic_64.h |    1 -
 arch/tile/include/asm/atomic.h     |    5 -----
 arch/x86/include/asm/atomic.h      |    1 -
 arch/xtensa/include/asm/atomic.h   |    1 -
 include/asm-generic/atomic.h       |    2 --
 include/linux/atomic.h             |    4 ++++
 23 files changed, 5 insertions(+), 50 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 3d67049..640f909 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -255,5 +255,4 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ALPHA_ATOMIC_H */
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 3757e91..86976d0 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -459,9 +459,6 @@ static inline int atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
 
-#else /* !CONFIG_GENERIC_ATOMIC64 */
-#include <asm-generic/atomic64.h>
-#endif
-#include <asm-generic/atomic-long.h>
+#endif /* !CONFIG_GENERIC_ATOMIC64 */
 #endif
 #endif
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index dc6c3a4..e0ac263 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -188,6 +188,4 @@ static inline int atomic_sub_if_positive(int i, atomic_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /*  __ASM_AVR32_ATOMIC_H */
diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 2cfce26..c1c5e7e 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -116,10 +116,7 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
 #define atomic_sub_and_test(i,v) (atomic_sub_return((i), (v)) == 0)
 #define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
 
-#include <asm-generic/atomic-long.h>
 
 #endif
 
-#include <asm-generic/atomic64.h>
-
 #endif
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 7e90532..bbf0938 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -157,5 +157,4 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc()     barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index a51dcdf..0d8a7d6 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -257,5 +257,4 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 }
 
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index e6d1663..f5a38c1 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -145,5 +145,4 @@ static __inline__ void atomic_set_mask(unsigned long mask, unsigned long *v)
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc() barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* __ARCH_H8300_ATOMIC __ */
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 22aca21..3fad89e 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -215,5 +215,4 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ASM_IA64_ATOMIC_H */
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index c839426..1e7f29f 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -313,5 +313,4 @@ static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif	/* _ASM_M32R_ATOMIC_H */
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 017a15e..63c245f 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -205,6 +205,4 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-#include <asm-generic/atomic64.h>
 #endif /* __ARCH_M68K_ATOMIC __ */
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 31cb23d..1d93f81 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -765,10 +765,6 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
  */
 #define atomic64_add_negative(i, v) (atomic64_add_return(i, (v)) < 0)
 
-#else /* !CONFIG_64BIT */
-
-#include <asm-generic/atomic64.h>
-
 #endif /* CONFIG_64BIT */
 
 /*
@@ -780,6 +776,4 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	smp_mb__before_llsc()
 #define smp_mb__after_atomic_inc()	smp_llsc_mb()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index a2e6759..b9a8f84 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -343,8 +343,6 @@ static inline void atomic_set_mask(unsigned long mask, unsigned long *addr)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* __KERNEL__ */
 #endif /* CONFIG_SMP */
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 1914f17..b1dc71f 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -335,12 +335,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
-#else /* CONFIG_64BIT */
-
-#include <asm-generic/atomic64.h>
-
 #endif /* !CONFIG_64BIT */
 
-#include <asm-generic/atomic-long.h>
 
 #endif /* _ASM_PARISC_ATOMIC_H_ */
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 952e161..e2a4c26 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -469,11 +469,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
-#else  /* __powerpc64__ */
-#include <asm-generic/atomic64.h>
-
 #endif /* __powerpc64__ */
 
-#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_ATOMIC_H_ */
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 7b0b0a7..8517d2a 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -331,6 +331,4 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* __ARCH_S390_ATOMIC__  */
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index 2177596..63a27db 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -67,7 +67,4 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic-long.h>
-#include <asm-generic/atomic64.h>
-
 #endif /* __ASM_SH_ATOMIC_H */
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index bdce95e..5c3c8b6 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -160,5 +160,4 @@ static inline int __atomic24_sub(int i, atomic24_t *v)
 
 #endif /* !(__KERNEL__) */
 
-#include <asm-generic/atomic-long.h>
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 1fc3d0a..9f421df 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -113,5 +113,4 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index e327271..921dbeb 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -177,9 +177,4 @@ extern unsigned long __cmpxchg_called_with_bad_pointer(void);
 #include <asm/atomic_64.h>
 #endif
 
-/* Provide the appropriate atomic_long_t definitions. */
-#ifndef __ASSEMBLY__
-#include <asm-generic/atomic-long.h>
-#endif
-
 #endif /* _ASM_TILE_ATOMIC_H */
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 5fe9cb3..10572e3 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -318,5 +318,4 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 # include "atomic64_64.h"
 #endif
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_H */
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index e464212..23592ef 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -291,7 +291,6 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 
 #endif /* _XTENSA_ATOMIC_H */
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index bd18bfd..a8fad94 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -154,7 +154,5 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index fc31190..f2e6529 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -70,4 +70,8 @@ static inline void atomic_or(int i, atomic_t *v)
 }
 #endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
 
+#include <asm-generic/atomic-long.h>
+#ifdef CONFIG_GENERIC_ATOMIC64
+#include <asm-generic/atomic64.h>
+#endif
 #endif /* _LINUX_ATOMIC_H */
-- 
1.7.4

