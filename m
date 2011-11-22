Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab1KVBbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:31:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52235 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1KVBbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:31:12 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] kernel.h: Add BUILD_BUG_ON_USED() macro.
Date: Mon, 21 Nov 2011 17:31:05 -0800
Message-Id: <1321925466-11280-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We can place this in definitions that we expect the compiler to remove
by dead code elimination.  If this assertion fails, we get a nice
error message at build time.

The GCC function attribute error("message") was added in version 4.3,
so we define a new macro __linktime_error(message) to expand to this
for GCC-4.3 and later.  This will give us an error diagnostic from the
compiler on the line that fails.  For other compilers
__linktime_error(message) expands to nothing, and we have to be
content with a link time error, but at least we will still get a build
error.

BUILD_BUG_ON_USED() expands to the undefined function
__build_bug_on_used_failed() and will fail at link time if the
compiler ever emits code for it.  On GCC-4.3 and later,
attribute((error())) is used so that the failure will be noted at compile
time instead.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/compiler-gcc4.h |    1 +
 include/linux/compiler.h      |    4 +++-
 include/linux/kernel.h        |   16 ++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index dfadc96..2f40791 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -29,6 +29,7 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
+#define __linktime_error(message) __attribute__((__error__(message)))
 
 #if __GNUC_MINOR__ >= 5
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 320d6c9..4a24354 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -293,7 +293,9 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-
+#ifndef __linktime_error
+# define __linktime_error(message)
+#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b93c66e..ebe54515 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -666,6 +666,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
+#define BUILD_BUG_ON_USED() (0)
 #else /* __CHECKER__ */
 
 /* Force a compilation error if a constant expression is not a power of 2 */
@@ -704,6 +705,21 @@ extern int __build_bug_on_failed;
 		if (condition) __build_bug_on_failed = 1;	\
 	} while(0)
 #endif
+
+/**
+ * BUILD_BUG_ON_USED - break compile if used.
+ *
+ * If you have some code that you expect the compiler to eliminate at
+ * build time, you should use BUILD_BUG_ON_USED to detect if it is
+ * unexpectedly used.
+ */
+#define BUILD_BUG_ON_USED()						\
+	do {								\
+		extern void __build_bug_on_used_failed(void)		\
+			__linktime_error("BUILD_BUG_ON_USED failed");	\
+		__build_bug_on_used_failed();				\
+	} while (0)
+
 #endif	/* __CHECKER__ */
 
 /* Trap pasters of __FUNCTION__ at compile-time */
-- 
1.7.2.3

