Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1LJKxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 05:53:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43025 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1LJKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:53:18 -0500
Message-Id: <20111210104840.199328732@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 11:43:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: gregkh@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] kref: Implement kref_put in terms of kref_sub
References: <20111210104341.592561407@chello.nl>
Content-Disposition: inline; filename=kref-simplify-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Less lines of code is better.

Cc: adobriyan@gmail.com
Cc: eric.dumazet@gmail.com
Cc: mingo@elte.hu
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kref.h |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/kref.h
===================================================================
--- linux-2.6.orig/include/linux/kref.h
+++ linux-2.6/include/linux/kref.h
@@ -43,57 +43,49 @@ static inline void kref_get(struct kref
 }
 
 /**
- * kref_put - decrement refcount for object.
+ * kref_sub - subtract a number of refcounts for object.
  * @kref: object.
+ * @count: Number of recounts to subtract.
  * @release: pointer to the function that will clean up the object when the
  *	     last reference to the object is released.
  *	     This pointer is required, and it is not acceptable to pass kfree
  *	     in as this function.
  *
- * Decrement the refcount, and if 0, call release().
+ * Subtract @count from the refcount, and if 0, call release().
  * Return 1 if the object was removed, otherwise return 0.  Beware, if this
  * function returns 0, you still can not count on the kref from remaining in
  * memory.  Only use the return value if you want to see if the kref is now
  * gone, not present.
  */
-static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref))
+static inline int kref_sub(struct kref *kref, unsigned int count,
+	     void (*release)(struct kref *kref))
 {
 	WARN_ON(release == NULL);
 	WARN_ON(release == (void (*)(struct kref *))kfree);
 
-	if (atomic_dec_and_test(&kref->refcount)) {
+	if (atomic_sub_and_test((int) count, &kref->refcount)) {
 		release(kref);
 		return 1;
 	}
 	return 0;
 }
 
-
 /**
- * kref_sub - subtract a number of refcounts for object.
+ * kref_put - decrement refcount for object.
  * @kref: object.
- * @count: Number of recounts to subtract.
  * @release: pointer to the function that will clean up the object when the
  *	     last reference to the object is released.
  *	     This pointer is required, and it is not acceptable to pass kfree
  *	     in as this function.
  *
- * Subtract @count from the refcount, and if 0, call release().
+ * Decrement the refcount, and if 0, call release().
  * Return 1 if the object was removed, otherwise return 0.  Beware, if this
  * function returns 0, you still can not count on the kref from remaining in
  * memory.  Only use the return value if you want to see if the kref is now
  * gone, not present.
  */
-static inline int kref_sub(struct kref *kref, unsigned int count,
-	     void (*release)(struct kref *kref))
+static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 {
-	WARN_ON(release == NULL);
-	WARN_ON(release == (void (*)(struct kref *))kfree);
-
-	if (atomic_sub_and_test((int) count, &kref->refcount)) {
-		release(kref);
-		return 1;
-	}
-	return 0;
+	return kref_sub(kref, 1, release);
 }
 #endif /* _KREF_H_ */


