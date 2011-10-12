Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1JLQse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1JLQsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:48:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] Add assertion checking macros
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 17:47:28 +0100
Message-ID: <20111012164728.539.29820.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
References: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a range of ASSERT* macros to linux/assert.h for performing runtime
assertions.  These will use assertion_failure() to cause an annotated oops if
the check fails.

The checks are only enabled under two circumstances:

 (1) CONFIG_DEBUG_ENABLE_ASSERTIONS=y

 (2) ENABLE_ASSERTIONS is defined prior to the #inclusion of <linux/assert.h>

There are five macros provided:

 (a) ASSERT(X)

     Issue an assertion failure error if X is false.  In other words, require
     the expression X to be true.  For example:

	ASSERT(val != 0);

     There is no need to display val here in the case the expression fails
     since it can only be 0.  If this fails, it produces an error like the
     following:

	------------[ cut here ]------------
	ASSERTION FAILED at fs/fscache/main.c:109!
	invalid opcode: 0000 [#1] SMP

 (b) ASSERTCMP(X, OP, Y)

     Issue an assertion failure error if the expression X OP Y is false.  For
     example:

	ASSERTCMP(x, >, 12)


     If an oops is produced, then the values of X and Y will be displayed in
     hex, along with OP:

	------------[ cut here ]------------
	ASSERTION FAILED at fs/fscache/main.c:109!
	Check 2 > c is false
	invalid opcode: 0000 [#1] SMP

 (c) ASSERTRANGE(X, OP, Y, OP2, Z)

     Issue an assertion failure error if the expression X OP Y or if the
     expression Y OP2 Z is false.  Typically OP and OP2 would be < or <=,
     looking something like:

	ASSERTRANGE(11, <, x, <=, 13);

     and giving the following error:

	------------[ cut here ]------------
	ASSERTION FAILED at fs/fscache/main.c:109!
	Check b < 2 <= d is false
	invalid opcode: 0000 [#1] SMP

and for compactness, where an assertion should only apply under certain
circumstances:

 (d) ASSERTIF(C, X)

     If condition C is true, issue an assertion failure error if X is false.
     For example:

	ASSERTIF(test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags),
		 object->n_exclusive != 0);

 (e) ASSERTIFCMP(C, X, OP, Y)

     This is a combination of ASSERTIF and ASSERTCMP.  For example:

	ASSERTIFCMP(test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags),
		    object->n_exclusive, >, 0);

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/assert.h |   94 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |    8 ++++
 2 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/include/linux/assert.h b/include/linux/assert.h
index 739ebf7..a65d1a8 100644
--- a/include/linux/assert.h
+++ b/include/linux/assert.h
@@ -33,4 +33,98 @@ void do_assertion_failed(const char *file, int line, const char *fmt, ...)
 		do_assertion_failed(__FILE__, __LINE__, FMT, ## __VA_ARGS__); \
 	} while (0)
 
+/*
+ * ENABLE_ASSERTIONS can be set by an individual module to override the global
+ * setting and turn assertions on for just that module.
+ */
+#if defined(CONFIG_DEBUG_ENABLE_ASSERTIONS) || defined(ENABLE_ASSERTIONS)
+
+#define cond_assertion_failed(FMT, ...)					\
+	do {								\
+		do_assertion_failed(__FILE__, __LINE__, FMT, ## __VA_ARGS__); \
+	} while (0)
+
+#else
+
+#define cond_assertion_failed(FMT, ...)		\
+	do {					\
+		no_printk(FMT, ## __VA_ARGS__);	\
+	} while (0)
+
+#endif
+
+/**
+ * ASSERT - Oops if the given expression is not true
+ * X: The expression to check
+ */
+#define ASSERT(X)							\
+do {									\
+	if (unlikely(!(X)))						\
+		cond_assertion_failed(NULL);				\
+} while (0)
+
+/**
+ * ASSERTCMP - Oops if the specified check fails
+ * X: The value to check
+ * OP: The operator to use for comparison
+ * Y: The value to compare against
+ *
+ * The two values are displayed in the oops report if the assertion fails.
+ */
+#define ASSERTCMP(X, OP, Y)						\
+do {									\
+	if (unlikely(!((X) OP (Y))))					\
+		cond_assertion_failed("Check %lx " #OP " %lx is false\n", \
+				      (unsigned long)(X),		\
+				      (unsigned long)(Y));		\
+} while (0)
+
+/**
+ * ASSERTIF - If condition is true, oops if the given expression is not true
+ * C: The condition under which to perform the check
+ * X: The expression to check
+ */
+#define ASSERTIF(C, X)							\
+do {									\
+	if (unlikely((C) && !(X)))					\
+		cond_assertion_failed(NULL);				\
+} while (0)
+
+/**
+ * ASSERTIFCMP - If condition is true, oops if the specified check fails
+ * C: The condition under which to perform the check
+ * X: The value to check
+ * OP: The operator to use for comparison
+ * Y: The value to compare against
+ *
+ * The two values are displayed in the oops report if the assertion fails.
+ */
+#define ASSERTIFCMP(C, X, OP, Y)					\
+do {									\
+	if (unlikely((C) && !((X) OP (Y))))				\
+		cond_assertion_failed("Check %lx " #OP " %lx is false\n", \
+				      (unsigned long)(X),		\
+				      (unsigned long)(Y));		\
+} while (0)
+
+/**
+ * ASSERTCMP - Oops if the value is outside of the specified range
+ * X: The lower bound
+ * OP: The operator to use to check against the lower bound (< or <=)
+ * Y: The value to check
+ * OP2: The operator to use to check against the upper bound (< or <=)
+ * Z: The upper bound
+ *
+ * The three values are displayed in the oops report if the assertion fails.
+ */
+#define ASSERTRANGE(X, OP, Y, OP2, Z)					\
+do {									\
+	if (unlikely(!((X) OP (Y)) || !((Y) OP2 (Z))))			\
+		cond_assertion_failed("Check %lx " #OP " %lx " #OP2	\
+				      " %lx is false\n",		\
+				      (unsigned long)(X),		\
+				      (unsigned long)(Y),		\
+				      (unsigned long)(Z));		\
+} while(0)
+
 #endif /* _LINUX_ASSERT_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..604eede9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -149,6 +149,14 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config DEBUG_ENABLE_ASSERTIONS
+	bool "Enable assertion checks"
+	depends on BUG
+	help
+	  Say Y here to globally enable checks made by the ASSERT*() macros.
+	  If such a check fails, BUG() processing will be invoked and an
+	  annotated oops will be emitted.
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL && GENERIC_HARDIRQS

