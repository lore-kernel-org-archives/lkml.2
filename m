Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1ARVRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:17:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1ARVRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:17:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/4] BKL: mark lock_kernel as deprecated
Date: Tue, 18 Jan 2011 22:17:01 +0100
Message-Id: <1295385422-3592-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295385422-3592-1-git-send-email-arnd@arndb.de>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IGH9I2Xk9AB/qAh3uis8IgJf9AoXORkvgex6dC7/E9h
 40JB+pHUztSq/VNBW20mPCBAc9kTKrwdVDNNE/3wnoJSTxbYJ6
 mbTWS0GT65hpWemZ9iYXExJSktqwh+DpBFV6teQ8hbnt+LyP1T
 4uyLLPpY45RVbvU480HQWloiBH1KWb7dMZ1VGyaLccTIxoNXxR
 +TLA9yynsKCubMcRTiHKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No new code should use the big kernel lock, so
we should really emit compiler warnings to make
people building out of mainline code aware of
this.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/smp_lock.h |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 3a19882..a06eb78 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -30,24 +30,14 @@ extern void __lockfunc
 _unlock_kernel(const char *func, const char *file, int line)
 __releases(kernel_lock);
 
-#define lock_kernel() do {					\
-	_lock_kernel(__func__, __FILE__, __LINE__);		\
-} while (0)
-
-#define unlock_kernel()	do {					\
-	_unlock_kernel(__func__, __FILE__, __LINE__);		\
-} while (0)
+static inline void __deprecated lock_kernel(void)
+{
+	_lock_kernel(__func__, __FILE__, __LINE__);
+}
 
-/*
- * Various legacy drivers don't really need the BKL in a specific
- * function, but they *do* need to know that the BKL became available.
- * This function just avoids wrapping a bunch of lock/unlock pairs
- * around code which doesn't really need it.
- */
-static inline void cycle_kernel_lock(void)
+static inline void __deprecated unlock_kernel(void)
 {
-	lock_kernel();
-	unlock_kernel();
+	_unlock_kernel(__func__, __FILE__, __LINE__);
 }
 
 #else
@@ -55,7 +45,6 @@ static inline void cycle_kernel_lock(void)
 #ifdef CONFIG_BKL /* provoke build bug if not set */
 #define lock_kernel()
 #define unlock_kernel()
-#define cycle_kernel_lock()			do { } while(0)
 #endif /* CONFIG_BKL */
 
 #define release_kernel_lock(task)		do { } while(0)
-- 
1.7.1

