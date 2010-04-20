Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0DTJTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:19:11 -0400
Received: from ozlabs.org ([203.10.76.45]:37917 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0DTJTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:19:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] module: drop the lock while waiting for module to complete initialization.
Date: Tue, 20 Apr 2010 18:49:04 +0930
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.hengli.com.au>, stable@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004201849.04960.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes "gave up waiting for init of module libcrc32c." which
happened at boot time due to multiple parallel module loads.

The problem was a deadlock: we wait for a module to finish
initializing, but we keep the module_lock mutex so it can't complete.
In particular, this could reasonably happen if a module does a
request_module() in its initialization routine.

So we change use_module() to return an errno rather than a bool, and if
it's -EBUSY we drop the lock and wait in the caller, then reaquire the
lock.

Reported-by: Brandon Philips <brandon@ifup.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Brandon Philips <brandon@ifup.org>
---
 kernel/module.c |   57 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -510,33 +510,26 @@ int use_module(struct module *a, struct 
 	struct module_use *use;
 	int no_warn, err;
 
-	if (b == NULL || already_uses(a, b)) return 1;
+	if (b == NULL || already_uses(a, b))
+		return 0;
 
 	/* If we're interrupted or time out, we fail. */
-	if (wait_event_interruptible_timeout(
-		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
-		    30 * HZ) <= 0) {
-		printk("%s: gave up waiting for init of module %s.\n",
-		       a->name, b->name);
-		return 0;
-	}
-
-	/* If strong_try_module_get() returned a different error, we fail. */
+	err = strong_try_module_get(b);
 	if (err)
-		return 0;
+		return err;
 
 	DEBUGP("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
 		printk("%s: out of memory loading\n", a->name);
 		module_put(b);
-		return 0;
+		return -ENOMEM;
 	}
 
 	use->module_which_uses = a;
 	list_add(&use->list, &b->modules_which_use_me);
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(use_module);
 
@@ -823,7 +816,7 @@ static inline void module_unload_free(st
 
 int use_module(struct module *a, struct module *b)
 {
-	return strong_try_module_get(b) == 0;
+	return strong_try_module_get(b);
 }
 EXPORT_SYMBOL_GPL(use_module);
 
@@ -994,17 +987,39 @@ static const struct kernel_symbol *resol
 	struct module *owner;
 	const struct kernel_symbol *sym;
 	const unsigned long *crc;
+	DEFINE_WAIT(wait);
+	int err;
+	long timeleft = 30 * HZ;
 
+again:
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
-	/* use_module can fail due to OOM,
-	   or module initialization or unloading */
-	if (sym) {
-		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
-		    || !use_module(mod, owner))
-			sym = NULL;
+	if (!sym)
+		return NULL;
+
+	if (!check_version(sechdrs, versindex, name, mod, crc, owner))
+		return NULL;
+
+	prepare_to_wait(&module_wq, &wait, TASK_INTERRUPTIBLE);
+	err = use_module(mod, owner);
+	if (likely(!err) || err != -EBUSY || signal_pending(current)) {
+		finish_wait(&module_wq, &wait);
+		return err ? NULL : sym;
 	}
-	return sym;
+
+	/* Module is still loading.  Drop lock and wait. */
+	mutex_unlock(&module_mutex);
+	timeleft = schedule_timeout(timeleft);
+	mutex_lock(&module_mutex);
+	finish_wait(&module_wq, &wait);
+
+	/* Module might be gone entirely, or replaced.  Re-lookup. */
+	if (timeleft)
+		goto again;
+
+	printk(KERN_WARNING "%s: gave up waiting for init of module %s.\n",
+	       mod->name, owner->name);
+	return NULL;
 }
 
 /*
