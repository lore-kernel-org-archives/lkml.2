Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1LJKx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 05:53:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43027 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1LJKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:53:19 -0500
Message-Id: <20111210104840.107647845@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 11:43:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] kref: Inline all functions
References: <20111210104341.592561407@chello.nl>
Content-Disposition: inline; filename=kref-simplify.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are tiny functions, there's no point in having them out-of-line.

Cc: adobriyan@gmail.com
Cc: eric.dumazet@gmail.com
Cc: mingo@elte.hu
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kref.h |   79 ++++++++++++++++++++++++++++++++++++++---
 lib/Makefile         |    2 -
 lib/kref.c           |   97 ---------------------------------------------------
 3 files changed, 75 insertions(+), 103 deletions(-)

Index: linux-2.6/include/linux/kref.h
===================================================================
--- linux-2.6.orig/include/linux/kref.h
+++ linux-2.6/include/linux/kref.h
@@ -21,10 +21,79 @@ struct kref {
 	atomic_t refcount;
 };
 
-void kref_init(struct kref *kref);
-void kref_get(struct kref *kref);
-int kref_put(struct kref *kref, void (*release) (struct kref *kref));
-int kref_sub(struct kref *kref, unsigned int count,
-	     void (*release) (struct kref *kref));
+/**
+ * kref_init - initialize object.
+ * @kref: object in question.
+ */
+static inline void kref_init(struct kref *kref)
+{
+	atomic_set(&kref->refcount, 1);
+	smp_mb();
+}
 
+/**
+ * kref_get - increment refcount for object.
+ * @kref: object.
+ */
+static inline void kref_get(struct kref *kref)
+{
+	WARN_ON(!atomic_read(&kref->refcount));
+	atomic_inc(&kref->refcount);
+	smp_mb__after_atomic_inc();
+}
+
+/**
+ * kref_put - decrement refcount for object.
+ * @kref: object.
+ * @release: pointer to the function that will clean up the object when the
+ *	     last reference to the object is released.
+ *	     This pointer is required, and it is not acceptable to pass kfree
+ *	     in as this function.
+ *
+ * Decrement the refcount, and if 0, call release().
+ * Return 1 if the object was removed, otherwise return 0.  Beware, if this
+ * function returns 0, you still can not count on the kref from remaining in
+ * memory.  Only use the return value if you want to see if the kref is now
+ * gone, not present.
+ */
+static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref))
+{
+	WARN_ON(release == NULL);
+	WARN_ON(release == (void (*)(struct kref *))kfree);
+
+	if (atomic_dec_and_test(&kref->refcount)) {
+		release(kref);
+		return 1;
+	}
+	return 0;
+}
+
+
+/**
+ * kref_sub - subtract a number of refcounts for object.
+ * @kref: object.
+ * @count: Number of recounts to subtract.
+ * @release: pointer to the function that will clean up the object when the
+ *	     last reference to the object is released.
+ *	     This pointer is required, and it is not acceptable to pass kfree
+ *	     in as this function.
+ *
+ * Subtract @count from the refcount, and if 0, call release().
+ * Return 1 if the object was removed, otherwise return 0.  Beware, if this
+ * function returns 0, you still can not count on the kref from remaining in
+ * memory.  Only use the return value if you want to see if the kref is now
+ * gone, not present.
+ */
+static inline int kref_sub(struct kref *kref, unsigned int count,
+	     void (*release)(struct kref *kref))
+{
+	WARN_ON(release == NULL);
+	WARN_ON(release == (void (*)(struct kref *))kfree);
+
+	if (atomic_sub_and_test((int) count, &kref->refcount)) {
+		release(kref);
+		return 1;
+	}
+	return 0;
+}
 #endif /* _KREF_H_ */
Index: linux-2.6/lib/kref.c
===================================================================
--- linux-2.6.orig/lib/kref.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * kref.c - library routines for handling generic reference counted objects
- *
- * Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
- * Copyright (C) 2004 IBM Corp.
- *
- * based on lib/kobject.c which was:
- * Copyright (C) 2002-2003 Patrick Mochel <mochel@osdl.org>
- *
- * This file is released under the GPLv2.
- *
- */
-
-#include <linux/kref.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-
-/**
- * kref_init - initialize object.
- * @kref: object in question.
- */
-void kref_init(struct kref *kref)
-{
-	atomic_set(&kref->refcount, 1);
-	smp_mb();
-}
-
-/**
- * kref_get - increment refcount for object.
- * @kref: object.
- */
-void kref_get(struct kref *kref)
-{
-	WARN_ON(!atomic_read(&kref->refcount));
-	atomic_inc(&kref->refcount);
-	smp_mb__after_atomic_inc();
-}
-
-/**
- * kref_put - decrement refcount for object.
- * @kref: object.
- * @release: pointer to the function that will clean up the object when the
- *	     last reference to the object is released.
- *	     This pointer is required, and it is not acceptable to pass kfree
- *	     in as this function.
- *
- * Decrement the refcount, and if 0, call release().
- * Return 1 if the object was removed, otherwise return 0.  Beware, if this
- * function returns 0, you still can not count on the kref from remaining in
- * memory.  Only use the return value if you want to see if the kref is now
- * gone, not present.
- */
-int kref_put(struct kref *kref, void (*release)(struct kref *kref))
-{
-	WARN_ON(release == NULL);
-	WARN_ON(release == (void (*)(struct kref *))kfree);
-
-	if (atomic_dec_and_test(&kref->refcount)) {
-		release(kref);
-		return 1;
-	}
-	return 0;
-}
-
-
-/**
- * kref_sub - subtract a number of refcounts for object.
- * @kref: object.
- * @count: Number of recounts to subtract.
- * @release: pointer to the function that will clean up the object when the
- *	     last reference to the object is released.
- *	     This pointer is required, and it is not acceptable to pass kfree
- *	     in as this function.
- *
- * Subtract @count from the refcount, and if 0, call release().
- * Return 1 if the object was removed, otherwise return 0.  Beware, if this
- * function returns 0, you still can not count on the kref from remaining in
- * memory.  Only use the return value if you want to see if the kref is now
- * gone, not present.
- */
-int kref_sub(struct kref *kref, unsigned int count,
-	     void (*release)(struct kref *kref))
-{
-	WARN_ON(release == NULL);
-	WARN_ON(release == (void (*)(struct kref *))kfree);
-
-	if (atomic_sub_and_test((int) count, &kref->refcount)) {
-		release(kref);
-		return 1;
-	}
-	return 0;
-}
-
-EXPORT_SYMBOL(kref_init);
-EXPORT_SYMBOL(kref_get);
-EXPORT_SYMBOL(kref_put);
-EXPORT_SYMBOL(kref_sub);
Index: linux-2.6/lib/Makefile
===================================================================
--- linux-2.6.orig/lib/Makefile
+++ linux-2.6/lib/Makefile
@@ -17,7 +17,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
-lib-y	+= kobject.o kref.o klist.o
+lib-y	+= kobject.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \


