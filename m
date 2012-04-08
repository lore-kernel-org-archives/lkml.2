Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2DHWj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:39:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2DHWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:38:32 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 1/2] bug.h: add BUILD_BUG_DECL, usable at file scope
Date: Sun,  8 Apr 2012 16:38:17 -0600
Message-Id: <1333924698-3894-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
References: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds BUILD_BUG_DECL, primarily to check sizes of file-scoped
arrays etc:

  const char const *names[] = { "bart", "lisa", "homer", "marge" };
  int a[] = {1,2,3,4}, b[] = {1,2,3,5}, c[] = {1,2}
  long d[] = {1,2};
  BUILD_BUG_DECL(Luke, sizeof(a) != sizeof(d));			// ok, but iffy usage
  BUILD_BUG_DECL(Han, sizeof(a) != sizeof(b));			// good
  BUILD_BUG_DECL(Obi, ARRAY_SIZE(a) != ARRAY_SIZE(b));		// better
  BUILD_BUG_DECL(Yoda, ARRAY_SIZE(a) != ARRAY_SIZE(names));	// good, on different types
  BUILD_BUG_DECL(Darth, sizeof(a) != sizeof(c));		// compile err

example 1 expands as:
    static __attribute__ ((__section__(".init.data"))) struct {
       int BUILD_BUG_DECL_Luke[1 - 2*!!(sizeof(a) != sizeof(b))];
    } BUILD_BUG_DECL_Luke[0]  __attribute__((unused));

The name parameter distinguishes multiple uses in the same scope, but
is otherwise arbitrary.  You can reuse the name of one of the checked
vars, or pick something easy to find on the rare occaision when the
assertion breaks the build.

example 5 yields:
    error: size of array ‘BUILD_BUG_DECL_Darth’ is negative

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/bug.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 72961c3..c76e6f6 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -17,6 +17,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
 #define BUILD_BUG() (0)
+#define BUILD_BUG_DECL(name, condition)
 #else /* __CHECKER__ */
 
 /* Force a compilation error if a constant expression is not a power of 2 */
@@ -70,6 +71,20 @@ extern int __build_bug_on_failed;
 		__build_bug_failed();				\
 	} while (0)
 
+/**
+ * BUILD_BUG_DECL - check declared objects
+ * @name: distinguishes multiple uses at same scope.
+ * @cond: false expr, typically like sizeof(a) != sizeof(b)
+ *
+ * This works at file-scope too, and supports checks like:
+ * BUILD_BUG_DECL(foo, sizeof(a) != sizeof(b));
+ * BUILD_BUG_DECL(id_strings, ARRAY_SIZE(id_strings) != ARRAY_SIZE(id_vals));
+ */
+#define BUILD_BUG_DECL(name, cond)				\
+	static __initdata struct {				\
+		int BUILD_BUG_DECL_ ## name[1 - 2*!!(cond)];	\
+	} BUILD_BUG_DECL_ ##name[0] __attribute__((unused))
+
 #endif	/* __CHECKER__ */
 
 #ifdef CONFIG_GENERIC_BUG
-- 
1.7.7.6

