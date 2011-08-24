Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1HXVh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:37:27 -0400
Received: from claw.goop.org ([74.207.240.146]:53489 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab1HXVhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:37:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/12] x86: add xadd helper macro
Date: Wed, 24 Aug 2011 14:37:02 -0700
Message-Id: <c0231b7573068b3f668ebc0c26e3927537f9e3f8.1314221624.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add a common xadd implementation.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg.h |   43 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index efe3ec7..0d0d9cd 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -6,6 +6,7 @@
 /* Non-existant functions to indicate usage errors at link time. */
 extern void __xchg_wrong_size(void);
 extern void __cmpxchg_wrong_size(void);
+extern void __xadd_wrong_size(void);
 
 /*
  * Constants for operation sizes. On 32-bit, the 64-bit size it set to
@@ -157,4 +158,46 @@ extern void __cmpxchg_wrong_size(void);
 	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
 #endif
 
+#define __xadd(ptr, inc, lock)						\
+	({								\
+	        __typeof__ (*(ptr)) __ret = (inc);			\
+		switch (sizeof(*(ptr))) {				\
+		case __X86_CASE_B:					\
+			asm volatile (lock "xaddb %b0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_W:					\
+			asm volatile (lock "xaddw %w0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_L:					\
+			asm volatile (lock "xaddl %0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_Q:					\
+			asm volatile (lock "xaddq %q0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		default:						\
+			__xadd_wrong_size();				\
+		}							\
+		__ret;							\
+	})
+
+/*
+ * xadd() adds "inc" to "*ptr" and atomically returns the previous
+ * value of "*ptr".
+ *
+ * xadd() is locked when multiple CPUs are online
+ * xadd_sync() is always locked
+ * xadd_local() is never locked
+ */
+#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
+#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
+#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+
 #endif	/* ASM_X86_CMPXCHG_H */
-- 
1.7.6

