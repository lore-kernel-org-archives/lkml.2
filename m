Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216Ab1KJDak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:30:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934722Ab1KJDac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.004034483@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Juan Gutierrez <jgutierrez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [153/262] hwspinlock/core: use a mutex to protect the radix tree
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan Gutierrez <jgutierrez@ti.com>

commit 93b465c2e186d96fb90012ba0f9372eb9952e732 upstream.

Since we're using non-atomic radix tree allocations, we
should be protecting the tree using a mutex and not a
spinlock.

Non-atomic allocations and process context locking is good enough,
as the tree is manipulated only when locks are registered/
unregistered/requested/freed.

The locks themselves are still protected by spinlocks of course,
and mutexes are not involved in the locking/unlocking paths.

Signed-off-by: Juan Gutierrez <jgutierrez@ti.com>
[ohad@wizery.com: rewrite the commit log, #include mutex.h, add minor
commentary]
[ohad@wizery.com: update register/unregister parts in hwspinlock.txt]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/hwspinlock.txt         |   18 +++++---------
 drivers/hwspinlock/hwspinlock_core.c |   45 +++++++++++++++--------------------
 2 files changed, 27 insertions(+), 36 deletions(-)

--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -39,23 +39,20 @@ independent, drivers.
      in case an unused hwspinlock isn't available. Users of this
      API will usually want to communicate the lock's id to the remote core
      before it can be used to achieve synchronization.
-     Can be called from an atomic context (this function will not sleep) but
-     not from within interrupt context.
+     Should be called from a process context (might sleep).
 
   struct hwspinlock *hwspin_lock_request_specific(unsigned int id);
    - assign a specific hwspinlock id and return its address, or NULL
      if that hwspinlock is already in use. Usually board code will
      be calling this function in order to reserve specific hwspinlock
      ids for predefined purposes.
-     Can be called from an atomic context (this function will not sleep) but
-     not from within interrupt context.
+     Should be called from a process context (might sleep).
 
   int hwspin_lock_free(struct hwspinlock *hwlock);
    - free a previously-assigned hwspinlock; returns 0 on success, or an
      appropriate error code on failure (e.g. -EINVAL if the hwspinlock
      is already free).
-     Can be called from an atomic context (this function will not sleep) but
-     not from within interrupt context.
+     Should be called from a process context (might sleep).
 
   int hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned int timeout);
    - lock a previously-assigned hwspinlock with a timeout limit (specified in
@@ -232,15 +229,14 @@ int hwspinlock_example2(void)
 
   int hwspin_lock_register(struct hwspinlock *hwlock);
    - to be called from the underlying platform-specific implementation, in
-     order to register a new hwspinlock instance. Can be called from an atomic
-     context (this function will not sleep) but not from within interrupt
-     context. Returns 0 on success, or appropriate error code on failure.
+     order to register a new hwspinlock instance. Should be called from
+     a process context (this function might sleep).
+     Returns 0 on success, or appropriate error code on failure.
 
   struct hwspinlock *hwspin_lock_unregister(unsigned int id);
    - to be called from the underlying vendor-specific implementation, in order
      to unregister an existing (and unused) hwspinlock instance.
-     Can be called from an atomic context (will not sleep) but not from
-     within interrupt context.
+     Should be called from a process context (this function might sleep).
      Returns the address of hwspinlock on success, or NULL on error (e.g.
      if the hwspinlock is sill in use).
 
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -26,6 +26,7 @@
 #include <linux/radix-tree.h>
 #include <linux/hwspinlock.h>
 #include <linux/pm_runtime.h>
+#include <linux/mutex.h>
 
 #include "hwspinlock_internal.h"
 
@@ -52,10 +53,12 @@
 static RADIX_TREE(hwspinlock_tree, GFP_KERNEL);
 
 /*
- * Synchronization of access to the tree is achieved using this spinlock,
+ * Synchronization of access to the tree is achieved using this mutex,
  * as the radix-tree API requires that users provide all synchronisation.
+ * A mutex is needed because we're using non-atomic radix tree allocations.
  */
-static DEFINE_SPINLOCK(hwspinlock_tree_lock);
+static DEFINE_MUTEX(hwspinlock_tree_lock);
+
 
 /**
  * __hwspin_trylock() - attempt to lock a specific hwspinlock
@@ -261,8 +264,7 @@ EXPORT_SYMBOL_GPL(__hwspin_unlock);
  * This function should be called from the underlying platform-specific
  * implementation, to register a new hwspinlock instance.
  *
- * Can be called from an atomic context (will not sleep) but not from
- * within interrupt context.
+ * Should be called from a process context (might sleep)
  *
  * Returns 0 on success, or an appropriate error code on failure
  */
@@ -279,7 +281,7 @@ int hwspin_lock_register(struct hwspinlo
 
 	spin_lock_init(&hwlock->lock);
 
-	spin_lock(&hwspinlock_tree_lock);
+	mutex_lock(&hwspinlock_tree_lock);
 
 	ret = radix_tree_insert(&hwspinlock_tree, hwlock->id, hwlock);
 	if (ret)
@@ -293,7 +295,7 @@ int hwspin_lock_register(struct hwspinlo
 	WARN_ON(tmp != hwlock);
 
 out:
-	spin_unlock(&hwspinlock_tree_lock);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_register);
@@ -305,8 +307,7 @@ EXPORT_SYMBOL_GPL(hwspin_lock_register);
  * This function should be called from the underlying platform-specific
  * implementation, to unregister an existing (and unused) hwspinlock.
  *
- * Can be called from an atomic context (will not sleep) but not from
- * within interrupt context.
+ * Should be called from a process context (might sleep)
  *
  * Returns the address of hwspinlock @id on success, or NULL on failure
  */
@@ -315,7 +316,7 @@ struct hwspinlock *hwspin_lock_unregiste
 	struct hwspinlock *hwlock = NULL;
 	int ret;
 
-	spin_lock(&hwspinlock_tree_lock);
+	mutex_lock(&hwspinlock_tree_lock);
 
 	/* make sure the hwspinlock is not in use (tag is set) */
 	ret = radix_tree_tag_get(&hwspinlock_tree, id, HWSPINLOCK_UNUSED);
@@ -331,7 +332,7 @@ struct hwspinlock *hwspin_lock_unregiste
 	}
 
 out:
-	spin_unlock(&hwspinlock_tree_lock);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return hwlock;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_unregister);
@@ -400,9 +401,7 @@ EXPORT_SYMBOL_GPL(hwspin_lock_get_id);
  * to the remote core before it can be used for synchronization (to get the
  * id of a given hwlock, use hwspin_lock_get_id()).
  *
- * Can be called from an atomic context (will not sleep) but not from
- * within interrupt context (simply because there is no use case for
- * that yet).
+ * Should be called from a process context (might sleep)
  *
  * Returns the address of the assigned hwspinlock, or NULL on error
  */
@@ -411,7 +410,7 @@ struct hwspinlock *hwspin_lock_request(v
 	struct hwspinlock *hwlock;
 	int ret;
 
-	spin_lock(&hwspinlock_tree_lock);
+	mutex_lock(&hwspinlock_tree_lock);
 
 	/* look for an unused lock */
 	ret = radix_tree_gang_lookup_tag(&hwspinlock_tree, (void **)&hwlock,
@@ -431,7 +430,7 @@ struct hwspinlock *hwspin_lock_request(v
 		hwlock = NULL;
 
 out:
-	spin_unlock(&hwspinlock_tree_lock);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return hwlock;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_request);
@@ -445,9 +444,7 @@ EXPORT_SYMBOL_GPL(hwspin_lock_request);
  * Usually early board code will be calling this function in order to
  * reserve specific hwspinlock ids for predefined purposes.
  *
- * Can be called from an atomic context (will not sleep) but not from
- * within interrupt context (simply because there is no use case for
- * that yet).
+ * Should be called from a process context (might sleep)
  *
  * Returns the address of the assigned hwspinlock, or NULL on error
  */
@@ -456,7 +453,7 @@ struct hwspinlock *hwspin_lock_request_s
 	struct hwspinlock *hwlock;
 	int ret;
 
-	spin_lock(&hwspinlock_tree_lock);
+	mutex_lock(&hwspinlock_tree_lock);
 
 	/* make sure this hwspinlock exists */
 	hwlock = radix_tree_lookup(&hwspinlock_tree, id);
@@ -482,7 +479,7 @@ struct hwspinlock *hwspin_lock_request_s
 		hwlock = NULL;
 
 out:
-	spin_unlock(&hwspinlock_tree_lock);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return hwlock;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_request_specific);
@@ -495,9 +492,7 @@ EXPORT_SYMBOL_GPL(hwspin_lock_request_sp
  * Should only be called with an @hwlock that was retrieved from
  * an earlier call to omap_hwspin_lock_request{_specific}.
  *
- * Can be called from an atomic context (will not sleep) but not from
- * within interrupt context (simply because there is no use case for
- * that yet).
+ * Should be called from a process context (might sleep)
  *
  * Returns 0 on success, or an appropriate error code on failure
  */
@@ -511,7 +506,7 @@ int hwspin_lock_free(struct hwspinlock *
 		return -EINVAL;
 	}
 
-	spin_lock(&hwspinlock_tree_lock);
+	mutex_lock(&hwspinlock_tree_lock);
 
 	/* make sure the hwspinlock is used */
 	ret = radix_tree_tag_get(&hwspinlock_tree, hwlock->id,
@@ -538,7 +533,7 @@ int hwspin_lock_free(struct hwspinlock *
 	module_put(hwlock->owner);
 
 out:
-	spin_unlock(&hwspinlock_tree_lock);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_free);


