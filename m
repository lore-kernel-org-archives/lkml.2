Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0KQP1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:27:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab0KQP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:27:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/7] BKL: mark lock_kernel as deprecated
Date: Wed, 17 Nov 2010 16:26:58 +0100
Message-Id: <1290007619-5787-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290007619-5787-1-git-send-email-arnd@arndb.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:4IT7nmVAXfRsjwHLPYEox4v8D5zdpJ6OI8sGkfTi9lc
 tXmJOF3+gi1YY5bODS+kB/GjiJkb92yxXruZnC3cSiD86d/wW0
 gMSL1T9fqgO7BHwxVm66yZGNe3kGD+f+nBEKWiA5cyNscks9K1
 AhMZi0iSum38Qli/GSu8X1u8dVYvxBt7UU+i044Uo4KROsEDVc
 egj1kX5n00iPvQctUeX1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No new code should use the big kernel lock, so
we should really emit compiler warnings to make
people building out of mainline code aware of
this.

Remove the unused cycle_kernel_lock() functions as well,
so we don't cause unnecessary build warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/smp_lock.h |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 291f721..9590a0c 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -26,10 +26,12 @@ static inline int reacquire_kernel_lock(struct task_struct *task)
 
 extern void __lockfunc
 _lock_kernel(const char *func, const char *file, int line)
+__deprecated
 __acquires(kernel_lock);
 
 extern void __lockfunc
 _unlock_kernel(const char *func, const char *file, int line)
+__deprecated
 __releases(kernel_lock);
 
 #define lock_kernel() do {					\
@@ -40,24 +42,11 @@ __releases(kernel_lock);
 	_unlock_kernel(__func__, __FILE__, __LINE__);		\
 } while (0)
 
-/*
- * Various legacy drivers don't really need the BKL in a specific
- * function, but they *do* need to know that the BKL became available.
- * This function just avoids wrapping a bunch of lock/unlock pairs
- * around code which doesn't really need it.
- */
-static inline void cycle_kernel_lock(void)
-{
-	lock_kernel();
-	unlock_kernel();
-}
-
 #else
 
 #ifdef CONFIG_BKL /* provoke build bug if not set */
 #define lock_kernel()
 #define unlock_kernel()
-#define cycle_kernel_lock()			do { } while(0)
 #define kernel_locked()				1
 #endif /* CONFIG_BKL */
 
-- 
1.7.1

