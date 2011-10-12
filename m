Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1JLQsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1JLQsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:48:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/7] FS-Cache: Use new core assertion macros
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 17:47:48 +0100
Message-ID: <20111012164748.539.41820.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
References: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make FS-Cache use the new core assertion macros in place of its own.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/debug.h     |   82 +++++++++++++++++++++++++++++++
 fs/fscache/internal.h  |  128 +-----------------------------------------------
 fs/fscache/operation.c |    3 -
 3 files changed, 86 insertions(+), 127 deletions(-)
 create mode 100644 fs/fscache/debug.h

diff --git a/fs/fscache/debug.h b/fs/fscache/debug.h
new file mode 100644
index 0000000..fcdbbab
--- /dev/null
+++ b/fs/fscache/debug.h
@@ -0,0 +1,82 @@
+/* Debug tracing
+ *
+ * Copyright (C) 2004-2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/printk.h>
+#define ENABLE_ASSERTIONS
+#include <linux/assert.h>
+
+/*
+ * debug tracing
+ */
+#define dbgprintk(FMT, ...) \
+	printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
+
+#define kenter(FMT, ...) dbgprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
+#define kdebug(FMT, ...) dbgprintk(FMT, ##__VA_ARGS__)
+
+#define kjournal(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
+
+#ifdef __KDEBUG
+#define _enter(FMT, ...) kenter(FMT, ##__VA_ARGS__)
+#define _leave(FMT, ...) kleave(FMT, ##__VA_ARGS__)
+#define _debug(FMT, ...) kdebug(FMT, ##__VA_ARGS__)
+
+#elif defined(CONFIG_FSCACHE_DEBUG)
+#define _enter(FMT, ...)			\
+do {						\
+	if (__do_kdebug(ENTER))			\
+		kenter(FMT, ##__VA_ARGS__);	\
+} while (0)
+
+#define _leave(FMT, ...)			\
+do {						\
+	if (__do_kdebug(LEAVE))			\
+		kleave(FMT, ##__VA_ARGS__);	\
+} while (0)
+
+#define _debug(FMT, ...)			\
+do {						\
+	if (__do_kdebug(DEBUG))			\
+		kdebug(FMT, ##__VA_ARGS__);	\
+} while (0)
+
+#else
+#define _enter(FMT, ...) no_printk("==> %s("FMT")", __func__, ##__VA_ARGS__)
+#define _leave(FMT, ...) no_printk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
+#define _debug(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
+#endif
+
+/*
+ * determine whether a particular optional debugging point should be logged
+ * - we need to go through three steps to persuade cpp to correctly join the
+ *   shorthand in FSCACHE_DEBUG_LEVEL with its prefix
+ */
+#define ____do_kdebug(LEVEL, POINT) \
+	unlikely((fscache_debug & \
+		  (FSCACHE_POINT_##POINT << (FSCACHE_DEBUG_ ## LEVEL * 3))))
+#define ___do_kdebug(LEVEL, POINT) \
+	____do_kdebug(LEVEL, POINT)
+#define __do_kdebug(POINT) \
+	___do_kdebug(FSCACHE_DEBUG_LEVEL, POINT)
+
+#define FSCACHE_DEBUG_CACHE	0
+#define FSCACHE_DEBUG_COOKIE	1
+#define FSCACHE_DEBUG_PAGE	2
+#define FSCACHE_DEBUG_OPERATION	3
+
+#define FSCACHE_POINT_ENTER	1
+#define FSCACHE_POINT_LEAVE	2
+#define FSCACHE_POINT_DEBUG	4
+
+#ifndef FSCACHE_DEBUG_LEVEL
+#define FSCACHE_DEBUG_LEVEL CACHE
+#endif
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index dcb3e1d..4c1a1ba 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -24,6 +24,7 @@
 
 #include <linux/fscache-cache.h>
 #include <linux/sched.h>
+#include "debug.h"
 
 #define FSCACHE_MIN_THREADS	4
 #define FSCACHE_MAX_THREADS	32
@@ -288,7 +289,7 @@ extern const struct file_operations fscache_stats_fops;
 static inline void fscache_raise_event(struct fscache_object *object,
 				       unsigned event)
 {
-	BUG_ON(event >= NR_FSCACHE_OBJECT_EVENTS);
+	ASSERTCMP(event, <, NR_FSCACHE_OBJECT_EVENTS);
 	if (!test_and_set_bit(event, &object->events) &&
 	    test_bit(event, &object->event_mask))
 		fscache_enqueue_object(object);
@@ -299,7 +300,7 @@ static inline void fscache_raise_event(struct fscache_object *object,
  */
 static inline void fscache_cookie_put(struct fscache_cookie *cookie)
 {
-	BUG_ON(atomic_read(&cookie->usage) <= 0);
+	ASSERTCMP(atomic_read(&cookie->usage), >, 0);
 	if (atomic_dec_and_test(&cookie->usage))
 		__fscache_cookie_put(cookie);
 }
@@ -324,126 +325,3 @@ void fscache_put_context(struct fscache_cookie *cookie, void *context)
 	if (cookie->def->put_context)
 		cookie->def->put_context(cookie->netfs_data, context);
 }
-
-/*****************************************************************************/
-/*
- * debug tracing
- */
-#define dbgprintk(FMT, ...) \
-	printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
-
-#define kenter(FMT, ...) dbgprintk("==> %s("FMT")", __func__, ##__VA_ARGS__)
-#define kleave(FMT, ...) dbgprintk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
-#define kdebug(FMT, ...) dbgprintk(FMT, ##__VA_ARGS__)
-
-#define kjournal(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-
-#ifdef __KDEBUG
-#define _enter(FMT, ...) kenter(FMT, ##__VA_ARGS__)
-#define _leave(FMT, ...) kleave(FMT, ##__VA_ARGS__)
-#define _debug(FMT, ...) kdebug(FMT, ##__VA_ARGS__)
-
-#elif defined(CONFIG_FSCACHE_DEBUG)
-#define _enter(FMT, ...)			\
-do {						\
-	if (__do_kdebug(ENTER))			\
-		kenter(FMT, ##__VA_ARGS__);	\
-} while (0)
-
-#define _leave(FMT, ...)			\
-do {						\
-	if (__do_kdebug(LEAVE))			\
-		kleave(FMT, ##__VA_ARGS__);	\
-} while (0)
-
-#define _debug(FMT, ...)			\
-do {						\
-	if (__do_kdebug(DEBUG))			\
-		kdebug(FMT, ##__VA_ARGS__);	\
-} while (0)
-
-#else
-#define _enter(FMT, ...) no_printk("==> %s("FMT")", __func__, ##__VA_ARGS__)
-#define _leave(FMT, ...) no_printk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
-#define _debug(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
-#endif
-
-/*
- * determine whether a particular optional debugging point should be logged
- * - we need to go through three steps to persuade cpp to correctly join the
- *   shorthand in FSCACHE_DEBUG_LEVEL with its prefix
- */
-#define ____do_kdebug(LEVEL, POINT) \
-	unlikely((fscache_debug & \
-		  (FSCACHE_POINT_##POINT << (FSCACHE_DEBUG_ ## LEVEL * 3))))
-#define ___do_kdebug(LEVEL, POINT) \
-	____do_kdebug(LEVEL, POINT)
-#define __do_kdebug(POINT) \
-	___do_kdebug(FSCACHE_DEBUG_LEVEL, POINT)
-
-#define FSCACHE_DEBUG_CACHE	0
-#define FSCACHE_DEBUG_COOKIE	1
-#define FSCACHE_DEBUG_PAGE	2
-#define FSCACHE_DEBUG_OPERATION	3
-
-#define FSCACHE_POINT_ENTER	1
-#define FSCACHE_POINT_LEAVE	2
-#define FSCACHE_POINT_DEBUG	4
-
-#ifndef FSCACHE_DEBUG_LEVEL
-#define FSCACHE_DEBUG_LEVEL CACHE
-#endif
-
-/*
- * assertions
- */
-#if 1 /* defined(__KDEBUGALL) */
-
-#define ASSERT(X)							\
-do {									\
-	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		BUG();							\
-	}								\
-} while (0)
-
-#define ASSERTCMP(X, OP, Y)						\
-do {									\
-	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while (0)
-
-#define ASSERTIF(C, X)							\
-do {									\
-	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		BUG();							\
-	}								\
-} while (0)
-
-#define ASSERTIFCMP(C, X, OP, Y)					\
-do {									\
-	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while (0)
-
-#else
-
-#define ASSERT(X)			do {} while (0)
-#define ASSERTCMP(X, OP, Y)		do {} while (0)
-#define ASSERTIF(C, X)			do {} while (0)
-#define ASSERTIFCMP(C, X, OP, Y)	do {} while (0)
-
-#endif /* assert or not */
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index cafba83..be15b09 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -429,8 +429,7 @@ void fscache_put_operation(struct fscache_operation *op)
 		printk("FS-Cache: Asserting on %s operation\n",
 		       fscache_op_names[op->name]);
 
-	ASSERTIFCMP(op->state != FSCACHE_OP_ST_COMPLETE,
-		    op->state, ==, FSCACHE_OP_ST_CANCELLED);
+	ASSERTRANGE(FSCACHE_OP_ST_COMPLETE, <=, op->state, <=, FSCACHE_OP_ST_CANCELLED);
 	op->state = FSCACHE_OP_ST_DEAD;
 
 	fscache_stat(&fscache_n_op_release);

