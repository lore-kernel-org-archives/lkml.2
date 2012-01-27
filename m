Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2A0CpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:45:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:53784 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2A0CpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:45:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 6/7] bug: consolidate BUILD_BUG_ON with other bug code
Date: Thu, 26 Jan 2012 21:44:31 -0500
Message-Id: <1327632272-12928-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for BUILD_BUG in linux/kernel.h predates the
addition of linux/bug.h -- with this chunk off separate,
you can run into situations where a person gets a compile
fail even when they've included linux/bug.h, like this:

    CC      lib/string.o
  lib/string.c: In function 'strlcat':
  lib/string.c:225:2: error: implicit declaration of function 'BUILD_BUG_ON'
  make[2]: *** [lib/string.o] Error 1
  $
  $ grep linux/bug.h lib/string.c
  #include <linux/bug.h>
  $

Since the above violates the principle of least surprise, move
the BUG chunks from kernel.h to bug.h so it is all together.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/bug.h    |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |   61 ------------------------------------------------
 2 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index d276b55..72961c3 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -11,6 +11,67 @@ enum bug_trap_type {
 
 struct pt_regs;
 
+#ifdef __CHECKER__
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON(condition)
+#define BUILD_BUG() (0)
+#else /* __CHECKER__ */
+
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but
+ * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
+ * to inline functions).  So as a fallback we use the optimizer; if it can't
+ * prove the condition is false, it will cause a link error on the undefined
+ * "__build_bug_on_failed".  This error message can be harder to track down
+ * though, hence the two different methods.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+extern int __build_bug_on_failed;
+#define BUILD_BUG_ON(condition)					\
+	do {							\
+		((void)sizeof(char[1 - 2*!!(condition)]));	\
+		if (condition) __build_bug_on_failed = 1;	\
+	} while(0)
+#endif
+
+/**
+ * BUILD_BUG - break compile if used.
+ *
+ * If you have some code that you expect the compiler to eliminate at
+ * build time, you should use BUILD_BUG to detect if it is
+ * unexpectedly used.
+ */
+#define BUILD_BUG()						\
+	do {							\
+		extern void __build_bug_failed(void)		\
+			__linktime_error("BUILD_BUG failed");	\
+		__build_bug_failed();				\
+	} while (0)
+
+#endif	/* __CHECKER__ */
+
 #ifdef CONFIG_GENERIC_BUG
 #include <asm-generic/bug.h>
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..5dba983 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -662,67 +662,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-#ifdef __CHECKER__
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)
-#define BUILD_BUG_ON_ZERO(e) (0)
-#define BUILD_BUG_ON_NULL(e) ((void*)0)
-#define BUILD_BUG_ON(condition)
-#define BUILD_BUG() (0)
-#else /* __CHECKER__ */
-
-/* Force a compilation error if a constant expression is not a power of 2 */
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
-	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
-
-/**
- * BUILD_BUG_ON - break compile if a condition is true.
- * @condition: the condition which the compiler should know is false.
- *
- * If you have some code which relies on certain constants being equal, or
- * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
- * detect if someone changes it.
- *
- * The implementation uses gcc's reluctance to create a negative array, but
- * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
- * to inline functions).  So as a fallback we use the optimizer; if it can't
- * prove the condition is false, it will cause a link error on the undefined
- * "__build_bug_on_failed".  This error message can be harder to track down
- * though, hence the two different methods.
- */
-#ifndef __OPTIMIZE__
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-#else
-extern int __build_bug_on_failed;
-#define BUILD_BUG_ON(condition)					\
-	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
-	} while(0)
-#endif
-
-/**
- * BUILD_BUG - break compile if used.
- *
- * If you have some code that you expect the compiler to eliminate at
- * build time, you should use BUILD_BUG to detect if it is
- * unexpectedly used.
- */
-#define BUILD_BUG()						\
-	do {							\
-		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
-		__build_bug_failed();				\
-	} while (0)
-
-#endif	/* __CHECKER__ */
-
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-- 
1.7.7.2

