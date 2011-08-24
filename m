Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1HXVhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:37:20 -0400
Received: from claw.goop.org ([74.207.240.146]:53470 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab1HXVhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:37:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/12] x86: use xadd helper more widely
Date: Wed, 24 Aug 2011 14:37:05 -0700
Message-Id: <99b5a4e8f403b05bad12e7363e962e0fc3bdb6cc.1314221624.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This covers the trivial cases.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/atomic.h      |    8 ++------
 arch/x86/include/asm/atomic64_64.h |    6 +-----
 arch/x86/include/asm/rwsem.h       |    8 +-------
 arch/x86/include/asm/uv/uv_bau.h   |    6 +-----
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 952a826..dfc1b7b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -172,18 +172,14 @@ static inline int atomic_add_negative(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
-	int __i;
 #ifdef CONFIG_M386
+	int __i;
 	unsigned long flags;
 	if (unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
-	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 
 #ifdef CONFIG_M386
 no_xadd: /* Legacy 386 processor */
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 49fd1ea..d76cdaa 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -170,11 +170,7 @@ static inline int atomic64_add_negative(long i, atomic64_t *v)
  */
 static inline long atomic64_add_return(long i, atomic64_t *v)
 {
-	long __i = i;
-	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 }
 
 static inline long atomic64_sub_return(long i, atomic64_t *v)
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 5a35263..1751107 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -201,13 +201,7 @@ static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
  */
 static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	long tmp = delta;
-
-	asm volatile(LOCK_PREFIX "xadd %0,%1"
-		     : "+r" (tmp), "+m" (sem->count)
-		     : : "memory");
-
-	return tmp + delta;
+	return delta + xadd(&sem->count, delta);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 130f1ee..ebc9344 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -487,11 +487,7 @@ static inline int atomic_read_short(const struct atomic_short *v)
  */
 static inline int atomic_add_short_return(short i, struct atomic_short *v)
 {
-	short __i = i;
-	asm volatile(LOCK_PREFIX "xaddw %0, %1"
-			: "+r" (i), "+m" (v->counter)
-			: : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 }
 
 #endif /* _ASM_X86_UV_UV_BAU_H */
-- 
1.7.6

