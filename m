Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1H3FYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:24:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:48866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab1H3FYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:24:49 -0400
Date: Tue, 30 Aug 2011 05:24:20 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-433b3520616be694e0aa777089346c8718c91a7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86: Add xadd helper macro
Git-Commit-ID: 433b3520616be694e0aa777089346c8718c91a7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:24:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  433b3520616be694e0aa777089346c8718c91a7b
Gitweb:     http://git.kernel.org/tip/433b3520616be694e0aa777089346c8718c91a7b
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Tue, 21 Jun 2011 12:00:55 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:42:20 -0700

x86: Add xadd helper macro

Add a common xadd implementation.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
