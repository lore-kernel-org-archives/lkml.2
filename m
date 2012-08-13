Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2HMWPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:15:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60108 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2HMWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:15:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>,
        Shan Kang <kangshan0910@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 10/65] ARM: 7467/1: mutex: use generic xchg-based implementation for ARMv6+
Date: Mon, 13 Aug 2012 15:13:54 -0700
Message-Id: <20120813221415.872342783@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit a76d7bd96d65fa5119adba97e1b58d95f2e78829 upstream.

The open-coded mutex implementation for ARMv6+ cores suffers from a
severe lack of barriers, so in the uncontended case we don't actually
protect any accesses performed during the critical section.

Furthermore, the code is largely a duplication of the ARMv6+ atomic_dec
code but optimised to remove a branch instruction, as the mutex fastpath
was previously inlined. Now that this is executed out-of-line, we can
reuse the atomic access code for the locking (in fact, we use the xchg
code as this produces shorter critical sections).

This patch uses the generic xchg based implementation for mutexes on
ARMv6+, which introduces barriers to the lock/unlock operations and also
has the benefit of removing a fair amount of inline assembly code.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Pitre <nico@linaro.org>
Reported-by: Shan Kang <kangshan0910@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/mutex.h |  119 +------------------------------------------
 1 file changed, 4 insertions(+), 115 deletions(-)

--- a/arch/arm/include/asm/mutex.h
+++ b/arch/arm/include/asm/mutex.h
@@ -7,121 +7,10 @@
  */
 #ifndef _ASM_MUTEX_H
 #define _ASM_MUTEX_H
-
-#if __LINUX_ARM_ARCH__ < 6
-/* On pre-ARMv6 hardware the swp based implementation is the most efficient. */
-# include <asm-generic/mutex-xchg.h>
-#else
-
 /*
- * Attempting to lock a mutex on ARMv6+ can be done with a bastardized
- * atomic decrement (it is not a reliable atomic decrement but it satisfies
- * the defined semantics for our purpose, while being smaller and faster
- * than a real atomic decrement or atomic swap.  The idea is to attempt
- * decrementing the lock value only once.  If once decremented it isn't zero,
- * or if its store-back fails due to a dispute on the exclusive store, we
- * simply bail out immediately through the slow path where the lock will be
- * reattempted until it succeeds.
+ * On pre-ARMv6 hardware this results in a swp-based implementation,
+ * which is the most efficient. For ARMv6+, we emit a pair of exclusive
+ * accesses instead.
  */
-static inline void
-__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
-{
-	int __ex_flag, __res;
-
-	__asm__ (
-
-		"ldrex	%0, [%2]	\n\t"
-		"sub	%0, %0, #1	\n\t"
-		"strex	%1, %0, [%2]	"
-
-		: "=&r" (__res), "=&r" (__ex_flag)
-		: "r" (&(count)->counter)
-		: "cc","memory" );
-
-	__res |= __ex_flag;
-	if (unlikely(__res != 0))
-		fail_fn(count);
-}
-
-static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
-{
-	int __ex_flag, __res;
-
-	__asm__ (
-
-		"ldrex	%0, [%2]	\n\t"
-		"sub	%0, %0, #1	\n\t"
-		"strex	%1, %0, [%2]	"
-
-		: "=&r" (__res), "=&r" (__ex_flag)
-		: "r" (&(count)->counter)
-		: "cc","memory" );
-
-	__res |= __ex_flag;
-	if (unlikely(__res != 0))
-		__res = fail_fn(count);
-	return __res;
-}
-
-/*
- * Same trick is used for the unlock fast path. However the original value,
- * rather than the result, is used to test for success in order to have
- * better generated assembly.
- */
-static inline void
-__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
-{
-	int __ex_flag, __res, __orig;
-
-	__asm__ (
-
-		"ldrex	%0, [%3]	\n\t"
-		"add	%1, %0, #1	\n\t"
-		"strex	%2, %1, [%3]	"
-
-		: "=&r" (__orig), "=&r" (__res), "=&r" (__ex_flag)
-		: "r" (&(count)->counter)
-		: "cc","memory" );
-
-	__orig |= __ex_flag;
-	if (unlikely(__orig != 0))
-		fail_fn(count);
-}
-
-/*
- * If the unlock was done on a contended lock, or if the unlock simply fails
- * then the mutex remains locked.
- */
-#define __mutex_slowpath_needs_to_unlock()	1
-
-/*
- * For __mutex_fastpath_trylock we use another construct which could be
- * described as a "single value cmpxchg".
- *
- * This provides the needed trylock semantics like cmpxchg would, but it is
- * lighter and less generic than a true cmpxchg implementation.
- */
-static inline int
-__mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
-{
-	int __ex_flag, __res, __orig;
-
-	__asm__ (
-
-		"1: ldrex	%0, [%3]	\n\t"
-		"subs		%1, %0, #1	\n\t"
-		"strexeq	%2, %1, [%3]	\n\t"
-		"movlt		%0, #0		\n\t"
-		"cmpeq		%2, #0		\n\t"
-		"bgt		1b		"
-
-		: "=&r" (__orig), "=&r" (__res), "=&r" (__ex_flag)
-		: "r" (&count->counter)
-		: "cc", "memory" );
-
-	return __orig;
-}
-
-#endif
+#include <asm-generic/mutex-xchg.h>
 #endif


