Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1HXRxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:53:34 -0400
Received: from claw.goop.org ([74.207.240.146]:52874 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1HXRxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 18/18] x86: use xadd helper more widely
Date: Wed, 24 Aug 2011 10:53:12 -0700
Message-Id: <33726adcab00ad21e4811c9e2ea53e7cd74bf40b.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This covers the trivial cases.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/atomic.h      |    4 +---
 arch/x86/include/asm/atomic64_64.h |    4 +---
 arch/x86/include/asm/rwsem.h       |    4 +---
 arch/x86/include/asm/uv/uv_bau.h   |    4 +---
 4 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 952a826..f201fab 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -180,9 +180,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 #endif
 	/* Modern 486+ processor */
 	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
+	xadd(&v->counter, i);
 	return i + __i;
 
 #ifdef CONFIG_M386
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 49fd1ea..ab3b586 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -171,9 +171,7 @@ static inline int atomic64_add_negative(long i, atomic64_t *v)
 static inline long atomic64_add_return(long i, atomic64_t *v)
 {
 	long __i = i;
-	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
+	xadd(&v->counter, i);
 	return i + __i;
 }
 
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 5a35263..958841a 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -203,9 +203,7 @@ static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
 	long tmp = delta;
 
-	asm volatile(LOCK_PREFIX "xadd %0,%1"
-		     : "+r" (tmp), "+m" (sem->count)
-		     : : "memory");
+	xadd(&sem->count, tmp);
 
 	return tmp + delta;
 }
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 130f1ee..3d36436 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -488,9 +488,7 @@ static inline int atomic_read_short(const struct atomic_short *v)
 static inline int atomic_add_short_return(short i, struct atomic_short *v)
 {
 	short __i = i;
-	asm volatile(LOCK_PREFIX "xaddw %0, %1"
-			: "+r" (i), "+m" (v->counter)
-			: : "memory");
+	xadd(&v->counter, i);
 	return i + __i;
 }
 
-- 
1.7.6

