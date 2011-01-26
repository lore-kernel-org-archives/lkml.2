Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1AZUGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:06:36 -0500
Received: from www.tglx.de ([62.245.132.106]:44524 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab1AZUGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:34 -0500
Message-Id: <20110126195833.876773757@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:06:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 5/6] rwsem: Unify the duplicate rwsem_is_locked() inlines
References: <20110126195810.247325792@linutronix.de>
Content-Disposition: inline; filename=rwsem-use-shared-is-locked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having the same implementation in each architecture, move
it to linux/rwsem.h and remove the duplicates. It's unlikely that an
arch will ever implement something different, but we can deal with
that when it happens.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |    5 -----
 arch/ia64/include/asm/rwsem.h    |    5 -----
 arch/powerpc/include/asm/rwsem.h |    5 -----
 arch/s390/include/asm/rwsem.h    |    5 -----
 arch/sh/include/asm/rwsem.h      |    5 -----
 arch/sparc/include/asm/rwsem.h   |    5 -----
 arch/x86/include/asm/rwsem.h     |    5 -----
 arch/xtensa/include/asm/rwsem.h  |    5 -----
 include/linux/rwsem.h            |    7 +++++++
 9 files changed, 7 insertions(+), 40 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
+++ linux-2.6/arch/alpha/include/asm/rwsem.h
@@ -224,10 +224,5 @@ static inline long rwsem_atomic_update(l
 #endif
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_RWSEM_H */
Index: linux-2.6/arch/ia64/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/rwsem.h
+++ linux-2.6/arch/ia64/include/asm/rwsem.h
@@ -147,9 +147,4 @@ __downgrade_write (struct rw_semaphore *
 #define rwsem_atomic_add(delta, sem)	atomic64_add(delta, (atomic64_t *)(&(sem)->count))
 #define rwsem_atomic_update(delta, sem)	atomic64_add_return(delta, (atomic64_t *)(&(sem)->count))
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* _ASM_IA64_RWSEM_H */
Index: linux-2.6/arch/powerpc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/rwsem.h
+++ linux-2.6/arch/powerpc/include/asm/rwsem.h
@@ -133,10 +133,5 @@ static inline long rwsem_atomic_update(l
 	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return sem->count != 0;
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_RWSEM_H */
Index: linux-2.6/arch/s390/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/rwsem.h
+++ linux-2.6/arch/s390/include/asm/rwsem.h
@@ -325,10 +325,5 @@ static inline long rwsem_atomic_update(l
 	return new;
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _S390_RWSEM_H */
Index: linux-2.6/arch/sh/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/rwsem.h
+++ linux-2.6/arch/sh/include/asm/rwsem.h
@@ -133,10 +133,5 @@ static inline int rwsem_atomic_update(in
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_SH_RWSEM_H */
Index: linux-2.6/arch/sparc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/rwsem.h
+++ linux-2.6/arch/sparc/include/asm/rwsem.h
@@ -124,11 +124,6 @@ static inline long rwsem_atomic_update(l
 	return atomic64_add_return(delta, (atomic64_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC64_RWSEM_H */
Index: linux-2.6/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/rwsem.h
+++ linux-2.6/arch/x86/include/asm/rwsem.h
@@ -222,10 +222,5 @@ static inline long rwsem_atomic_update(l
 	return tmp + delta;
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_RWSEM_H */
Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -133,9 +133,4 @@ static inline int rwsem_atomic_update(in
 	return atomic_add_return(delta, (atomic_t *)(&sem->count));
 }
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->count != 0);
-}
-
 #endif	/* _XTENSA_RWSEM_H */
Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h
+++ linux-2.6/include/linux/rwsem.h
@@ -34,6 +34,13 @@ struct rw_semaphore {
 
 /* Include the arch specific part */
 #include <asm/rwsem.h>
+
+/* In all implementations count != 0 means locked */
+static inline int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	return sem->count != 0;
+}
+
 #endif
 
 /* Common initializer macros and functions */


