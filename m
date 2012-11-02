Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2KBOrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:47:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40819 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2KBOrB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 10:47:01 -0400
Message-Id: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:47:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>, <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the
 compiler supports it
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the resulting diagnostics quite a bit more useful.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 include/linux/bug.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- 3.7-rc3/include/linux/bug.h
+++ 3.7-rc3-static-assert/include/linux/bug.h
@@ -27,8 +27,15 @@ struct pt_regs;
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
+#define BUILD_BUG_ON_ZERO(e) \
+	sizeof(struct { _Static_assert(!(e), "!(" #e ")"); })
+#define BUILD_BUG_ON_NULL(e) \
+	((void *)sizeof(struct { _Static_assert(!(e), "!(" #e ")"); }))
+#else
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+#endif
 
 /*
  * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
@@ -54,6 +61,15 @@ struct pt_regs;
  */
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#elif __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 3)
+#define __build_bug_on_failed(n) __build_bug_on_##n##_failed
+#define _BUILD_BUG_ON(n, condition)				\
+	do {							\
+		extern void __compiletime_error(#condition)	\
+		__build_bug_on_failed(n)(void);			\
+		if (condition) __build_bug_on_failed(n)();	\
+	} while(0)
+#define BUILD_BUG_ON(condition...) _BUILD_BUG_ON(__COUNTER__, ##condition)
 #else
 extern int __build_bug_on_failed;
 #define BUILD_BUG_ON(condition)					\



