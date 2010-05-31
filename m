Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0EaUVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:21:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab0EaUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:21:38 -0400
Date: Mon, 31 May 2010 13:17:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Brandon Philips <brandon@ifup.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 2/2] module: wait for other modules after dropping the
 module_mutex
In-Reply-To: <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005311316270.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312130.17038.rusty@rustcorp.com.au> <201005312131.43238.rusty@rustcorp.com.au> <201005312132.28631.rusty@rustcorp.com.au> <20100531094834.c1a684d1.akpm@linux-foundation.org> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
 <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org> <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 May 2010 13:09:21 -0700
Subject: [PATCH 2/2] module: wait for other modules after dropping the module_mutex

Instead of doing a "use_module()" when linking to other modules, we do a
simpler link_module() that does not require the dependent modules to be
initialized.  We then wait for all dependent modules _after_ we have
dropped the module_mutex lock, which avoids a deadlock.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This is the patch that should hopefully fix Brandon's deadlock. But I 
haven't really tested that case - so who knows?

 kernel/module.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 89 insertions(+), 16 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 82ae1e4..c95f97e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -611,6 +611,54 @@ int use_module(struct module *a, struct module *b)
 }
 EXPORT_SYMBOL_GPL(use_module);
 
+/* Module a links to b */
+static int link_module(struct module *a, struct module *b)
+{
+	if (b == NULL || already_uses(a, b))
+		return 1;
+	if (!try_module_get(b))
+		return 0;
+	return add_module_usage(a, b);
+}
+
+/*
+ * Are all modules LIVE? Return 0 (ok) if so.
+ * Return -EINVAL if any are going, and EAGAIN
+ * if there are modules still initializing.
+ */
+static int all_modules_ok(struct module *mod)
+{
+	int err = 0;
+	struct module_use *use;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(use, &mod->target_list, target_list) {
+		struct module *target = use->target;
+		switch (target->state) {
+		case MODULE_STATE_LIVE:
+			break;
+		case MODULE_STATE_COMING:
+			if (!err)
+				err = -EAGAIN;
+			break;
+		default:
+			err = -EINVAL;
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return err;
+}
+
+/* Wait for dependent modules to finish */
+static int module_load_wait(struct module *mod)
+{
+	int err;
+
+	if (wait_event_interruptible_timeout(module_wq, (err = all_modules_ok(mod)) != -EAGAIN, 30 * HZ) <= 0)
+		printk("%s: gave up waiting for init of modules.\n", mod->name);
+	return err;
+}
+
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
 {
@@ -898,6 +946,21 @@ int use_module(struct module *a, struct module *b)
 }
 EXPORT_SYMBOL_GPL(use_module);
 
+/* FIXME! This is wrong. We should do the full link_module. Otherwise
+ * we'll fail if a module we depend on just happens to be loading */
+static int link_module(struct module *a, struct module *b)
+{
+	return strong_try_module_get(b) == 0;
+}
+
+/* Wait for dependent modules to finish. See the FIXME on link_module()
+ * above: we've required that the modules were initialized too early,
+ * so there is nothing to wait on now (nor do we maintain any lists) */
+static int module_load_wait(struct module *mod)
+{
+	return 0;
+}
+
 static inline void module_unload_init(struct module *mod)
 {
 }
@@ -1068,11 +1131,11 @@ static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
 
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
-	/* use_module can fail due to OOM,
+	/* link_module can fail due to OOM,
 	   or module initialization or unloading */
 	if (sym) {
 		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
-		    || !use_module(mod, owner))
+		    || !link_module(mod, owner))
 			sym = NULL;
 	}
 	return sym;
@@ -2528,6 +2591,14 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	/* Drop lock so they can recurse */
 	mutex_unlock(&module_mutex);
 
+	/*
+	 * Now that we've released the module lock, wait for dependent
+	 * modules to finish loading
+	 */
+	ret = module_load_wait(mod);
+	if (ret)
+		goto unload;
+
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
@@ -2535,20 +2606,8 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	/* Start the module */
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
-	if (ret < 0) {
-		/* Init routine failed: abort.  Try to protect us from
-                   buggy refcounters. */
-		mod->state = MODULE_STATE_GOING;
-		synchronize_sched();
-		module_put(mod);
-		blocking_notifier_call_chain(&module_notify_list,
-					     MODULE_STATE_GOING, mod);
-		mutex_lock(&module_mutex);
-		free_module(mod);
-		mutex_unlock(&module_mutex);
-		wake_up(&module_wq);
-		return ret;
-	}
+	if (ret < 0)
+		goto unload;
 	if (ret > 0) {
 		printk(KERN_WARNING
 "%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
@@ -2583,6 +2642,20 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mutex_unlock(&module_mutex);
 
 	return 0;
+
+unload:
+	/* Initialization failed: abort.  Try to protect us from
+	   buggy refcounters. */
+	mod->state = MODULE_STATE_GOING;
+	synchronize_sched();
+	module_put(mod);
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_GOING, mod);
+	mutex_lock(&module_mutex);
+	free_module(mod);
+	mutex_unlock(&module_mutex);
+	wake_up(&module_wq);
+	return ret;
 }
 
 static inline int within(unsigned long addr, void *start, unsigned long size)
-- 
1.7.1.227.gb676f

