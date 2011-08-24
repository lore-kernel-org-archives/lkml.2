Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1HXRyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:54:09 -0400
Received: from claw.goop.org ([74.207.240.146]:52892 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1HXRxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:22 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 17/18] x86: add local and sync variants of xadd
Date: Wed, 24 Aug 2011 10:53:11 -0700
Message-Id: <b6707747021ae55d8c37b71f5f4a67b1bacf5e37.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index c99ce79..992ac80 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -193,26 +193,26 @@ extern void __xadd_wrong_size(void);
 	__cmpxchg_local_flag((ptr), (old), (new), sizeof(*ptr))
 #endif
 
-#define xadd(ptr, inc)							\
+#define __xadd(ptr, inc, lock)						\
 	do {								\
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
-			asm volatile (LOCK_PREFIX "xaddb %b0, %1\n"	\
+			asm volatile (lock "xaddb %b0, %1\n"		\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
-			asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"	\
+			asm volatile (lock "xaddw %w0, %1\n"		\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_L:					\
-			asm volatile (LOCK_PREFIX "xaddl %0, %1\n"	\
+			asm volatile (lock "xaddl %0, %1\n"		\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_Q:					\
-			asm volatile (LOCK_PREFIX "xaddq %q0, %1\n"	\
+			asm volatile (lock "xaddq %q0, %1\n"		\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
@@ -221,4 +221,8 @@ extern void __xadd_wrong_size(void);
 		}							\
 	} while(0)
 
+#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
+#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
+#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+
 #endif	/* ASM_X86_CMPXCHG_H */
-- 
1.7.6

