Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab1LPOOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:14:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759520Ab1LPOO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:14:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/7] Add assertion checking macros
To: linux-arch@vger.kernel.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 16 Dec 2011 14:14:17 +0000
Message-ID: <20111216141417.24668.15693.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
References: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a range of ASSERT* macros to linux/assert.h for performing runtime
assertions.  These will use ANNOTATED_BUG() to create an annotated oops if the
check fails.

All but the first macro will display the values and condition(s) involved in
the failed check as these are very useful for working out the cause of the
problem and may not necessarily be easily determinable from the register and
stack dumps.

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
	kernel BUG at fs/fscache/main.c:109!
	ASSERTION FAILED
	invalid opcode: 0000 [#1] SMP

 (b) ASSERTCMP(X, OP, Y)

     Issue an assertion failure error if the expression X OP Y is false.  For
     example:

	ASSERTCMP(x, >, 12)

     If an oops is produced, then the values of X and Y will be displayed in
     hex, along with OP:

	------------[ cut here ]------------
	kernel BUG at fs/fscache/main.c:109!
	ASSERTION FAILED: 2 > c is false
	invalid opcode: 0000 [#1] SMP

 (c) ASSERTRANGE(X, OP, Y, OP2, Z)

     Issue an assertion failure error if the expression X OP Y or if the
     expression Y OP2 Z is false.  Typically OP and OP2 would be < or <=,
     looking something like:

	ASSERTRANGE(11, <, x, <=, 13);

     and giving the following error:

	------------[ cut here ]------------
	kernel BUG at fs/fscache/main.c:109!
	ASSERTION FAILED: b < 2 <= d is false
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

 include/linux/assert.h |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |    8 +++
 2 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/assert.h

diff --git a/include/linux/assert.h b/include/linux/assert.h
new file mode 100644
index 0000000..e1e9264
--- /dev/null
+++ b/include/linux/assert.h
@@ -0,0 +1,111 @@
+/* Assertion checking
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_ASSERT_H
+#define _LINUX_ASSERT_H
+
+#include <linux/bug.h>
+
+/*
+ * ENABLE_ASSERTIONS can be set by an individual module to override the global
+ * setting and turn assertions on for just that module.
+ */
+#if defined(CONFIG_DEBUG_ENABLE_ASSERTIONS) || defined(ENABLE_ASSERTIONS)
+
+#define cond_assertion_failed(FMT, ...)					\
+	do {								\
+		ANNOTATED_BUG("ASSERTION FAILED" FMT, ## __VA_ARGS__); \
+	} while (0)
+
+#else
+
+#define cond_assertion_failed(FMT, ...)		\
+	do {					\
+		no_printk("ASSERTION FAILED" FMT, ## __VA_ARGS__);	\
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
+		cond_assertion_failed("");				\
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
+		cond_assertion_failed(": %lx " #OP " %lx is false\n", \
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
+		cond_assertion_failed("");				\
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
+		cond_assertion_failed(": %lx " #OP " %lx is false\n",	\
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
+		cond_assertion_failed(": %lx " #OP " %lx " #OP2		\
+				      " %lx is false\n",		\
+				      (unsigned long)(X),		\
+				      (unsigned long)(Y),		\
+				      (unsigned long)(Z));		\
+} while(0)
+
+#endif /* _LINUX_ASSERT_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 82928f5..b14acf9 100644
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

