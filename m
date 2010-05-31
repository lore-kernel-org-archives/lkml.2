Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0EaMBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:01:48 -0400
Received: from ozlabs.org ([203.10.76.45]:41199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0EaMBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:01:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Subject: [PATCH 1/2] module: make locking more fine-grained.
Date: Mon, 31 May 2010 21:31:42 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201005311910.32407.rusty@rustcorp.com.au> <201005312130.17038.rusty@rustcorp.com.au>
In-Reply-To: <201005312130.17038.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005312131.43238.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> reports that we still have some
contention over module loading which is slowing boot.

Linus also disliked a previous "drop lock and regrab" patch to fix the
bne2 "gave up waiting for init of module libcrc32c" message.

This is more ambitious in that we only grab the lock where we need it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Brandon Philips <brandon@ifup.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/module.c |   57 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -90,7 +90,8 @@ static DECLARE_WAIT_QUEUE_HEAD(module_wq
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
-/* Bounds of module allocation, for speeding __module_address */
+/* Bounds of module allocation, for speeding __module_address.
+ * Protected by module_mutex. */
 static unsigned long module_addr_min = -1UL, module_addr_max = 0;
 
 int register_module_notifier(struct notifier_block * nb)
@@ -329,7 +330,7 @@ static bool find_symbol_in_section(const
 }
 
 /* Find a symbol and return it, along with, (optional) crc and
- * (optional) module which owns it */
+ * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
 const struct kernel_symbol *find_symbol(const char *name,
 					struct module **owner,
 					const unsigned long **crc,
@@ -557,7 +558,7 @@ static int already_uses(struct module *a
 	return 0;
 }
 
-/* Module a uses b */
+/* Module a uses b: caller needs module_mutex() */
 int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
@@ -598,6 +599,7 @@ static void module_unload_free(struct mo
 {
 	struct module *i;
 
+	mutex_lock(&module_mutex);
 	list_for_each_entry(i, &modules, list) {
 		struct module_use *use;
 
@@ -613,6 +615,7 @@ static void module_unload_free(struct mo
 			}
 		}
 	}
+	mutex_unlock(&module_mutex);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -665,6 +668,7 @@ static int try_stop_module(struct module
 		synchronize_sched();
 		return 0;
 	}
+	mutex_unlock(&module_mutex);
 }
 
 unsigned int module_refcount(struct module *mod)
@@ -783,9 +787,13 @@ SYSCALL_DEFINE2(delete_module, const cha
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
 	ddebug_remove_module(mod->name);
+
+	/* free_module doesn't want module_mutex held by caller. */
+	mutex_unlock(&module_mutex);
 	free_module(mod);
-
- out:
+	goto out_stop;
+
+out:
 	mutex_unlock(&module_mutex);
 	return ret;
 }
@@ -1001,6 +1009,8 @@ static inline int check_modstruct_versio
 {
 	const unsigned long *crc;
 
+	/* Since this should be found in kernel (which can't be removed),
+	 * no locking is necessary. */
 	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
 			 &crc, true, false))
 		BUG();
@@ -1043,8 +1053,7 @@ static inline int same_magic(const char 
 }
 #endif /* CONFIG_MODVERSIONS */
 
-/* Resolve a symbol for this module.  I.e. if we find one, record usage.
-   Must be holding module_mutex. */
+/* Resolve a symbol for this module.  I.e. if we find one, record usage. */
 static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
 						  unsigned int versindex,
 						  const char *name,
@@ -1054,6 +1063,7 @@ static const struct kernel_symbol *resol
 	const struct kernel_symbol *sym;
 	const unsigned long *crc;
 
+	mutex_lock(&module_mutex);
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	/* use_module can fail due to OOM,
@@ -1063,6 +1073,7 @@ static const struct kernel_symbol *resol
 		    || !use_module(mod, owner))
 			sym = NULL;
 	}
+	mutex_unlock(&module_mutex);
 	return sym;
 }
 
@@ -1436,13 +1447,15 @@ static int __unlink_module(void *_mod)
 	return 0;
 }
 
-/* Free a module, remove from lists, etc (must hold module_mutex). */
+/* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
 	trace_module_free(mod);
 
 	/* Delete from various lists */
+	mutex_lock(&module_mutex);
 	stop_machine(__unlink_module, mod, NULL);
+	mutex_unlock(&module_mutex);
 	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
@@ -1514,7 +1527,14 @@ static int verify_export_symbols(struct 
 
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
-			if (find_symbol(s->name, &owner, NULL, true, false)) {
+			const struct kernel_symbol *sym;
+
+			/* Stopping preemption makes find_symbol safe. */
+			preempt_disable();
+			sym = find_symbol(s->name, &owner, NULL, true, false);
+			preempt_enable();
+
+			if (sym) {
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
@@ -1960,11 +1980,13 @@ static void *module_alloc_update_bounds(
 	void *ret = module_alloc(size);
 
 	if (ret) {
+		mutex_lock(&module_mutex);
 		/* Update module bounds. */
 		if ((unsigned long)ret < module_addr_min)
 			module_addr_min = (unsigned long)ret;
 		if ((unsigned long)ret + size > module_addr_max)
 			module_addr_max = (unsigned long)ret + size;
+		mutex_unlock(&module_mutex);
 	}
 	return ret;
 }
@@ -2426,7 +2448,9 @@ static noinline struct module *load_modu
 	 * function to insert in a way safe to concurrent readers.
 	 * The mutex protects against concurrent writers.
 	 */
+	mutex_lock(&module_mutex);
 	list_add_rcu(&mod->list, &modules);
+	mutex_unlock(&module_mutex);
 
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
@@ -2447,8 +2471,10 @@ static noinline struct module *load_modu
 	return mod;
 
  unlink:
+	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
+	mutex_unlock(&module_mutex);
 	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
@@ -2502,19 +2528,10 @@ SYSCALL_DEFINE3(init_module, void __user
 	if (!capable(CAP_SYS_MODULE) || modules_disabled)
 		return -EPERM;
 
-	/* Only one module load at a time, please */
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
-
 	/* Do all the hard work */
 	mod = load_module(umod, len, uargs);
-	if (IS_ERR(mod)) {
-		mutex_unlock(&module_mutex);
+	if (IS_ERR(mod))
 		return PTR_ERR(mod);
-	}
-
-	/* Drop lock so they can recurse */
-	mutex_unlock(&module_mutex);
 
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
@@ -2531,9 +2548,7 @@ SYSCALL_DEFINE3(init_module, void __user
 		module_put(mod);
 		blocking_notifier_call_chain(&module_notify_list,
 					     MODULE_STATE_GOING, mod);
-		mutex_lock(&module_mutex);
 		free_module(mod);
-		mutex_unlock(&module_mutex);
 		wake_up(&module_wq);
 		return ret;
 	}
