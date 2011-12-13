Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1LMJhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:37:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:60370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1LMJhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:37:15 -0500
Message-ID: <1323768980.9082.6.camel@twins>
Subject: Re: [PATCH 1/3] kref: Inline all functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Date: Tue, 13 Dec 2011 10:36:20 +0100
In-Reply-To: <20111212221159.GA27940@kroah.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.107647845@chello.nl> <20111212221159.GA27940@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 14:11 -0800, Greg KH wrote:
> Nice, but this breaks the build:

Sorry about that, this one includes the missing include and just booted
on my test-box.

---
Subject: kref: Inline all functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat Dec 10 11:29:57 CET 2011

These are tiny functions, there's no point in having them out-of-line.

Cc: adobriyan@gmail.com
Cc: eric.dumazet@gmail.com
Cc: mingo@elte.hu
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-8eccvi2ur2fzgi00xdjlbf5z@git.kernel.org
---
 include/linux/kref.h |   80 +++++++++++++++++++++++++++++++++++++++---
 lib/Makefile         |    2 -
 lib/kref.c           |   97 ---------------------------------------------------
 3 files changed, 76 insertions(+), 103 deletions(-)
Index: linux-2.6/include/linux/kref.h
===================================================================
--- linux-2.6.orig/include/linux/kref.h
+++ linux-2.6/include/linux/kref.h
@@ -16,15 +16,85 @@
 #define _KREF_H_
 
 #include <linux/types.h>
+#include <linux/slab.h>
 
 struct kref {
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

