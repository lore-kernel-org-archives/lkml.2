Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab0FPAK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:10:56 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:41384 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0FPAKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id; q=dns; s=drama; b=AEQnGji5xR6RF3KUG
	wfGdNBoufUPAt1YX1+o1qwGPel7OSzJuw2/+ZZEpnIZn+6SD/4fTQDoGYqMrezPc
	Jy2nQhcUyN/VimPZEwmPoGc/icVnLch0GTjhN17Jmm/ItXoE9Mr/l7VfFeIXSwf0
	omgyuS0m1ch1hKmoStZVPPViS0=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, torvalds@linux-foundation.org, yehudasa@gmail.com,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 1/1] module: initialize module dynamic debug later
Date: Tue, 15 Jun 2010 17:26:37 -0700
Message-Id: <b419ab1fe660cb24a32e63f9c2da2301b3ff1278.1276647544.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should initialize the module dynamic debug datastructures
only after determining that the module is not loaded yet. This
fixes a bug that introduced in 2.6.35-rc2, where when a trying
to load a module twice, we also load it's dynamic printing data
twice which causes all sorts of nasty issues. Also handle
the dynamic debug cleanup later on failure.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 include/linux/dynamic_debug.h |    4 ++--
 kernel/module.c               |   25 +++++++++++++++++--------
 lib/dynamic_debug.c           |    2 +-
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index b3cd4de..52c0da4 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -40,7 +40,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
-extern int ddebug_remove_module(char *mod_name);
+extern int ddebug_remove_module(const char *mod_name);
 
 #define __dynamic_dbg_enabled(dd)  ({	     \
 	int __ret = 0;							     \
@@ -73,7 +73,7 @@ extern int ddebug_remove_module(char *mod_name);
 
 #else
 
-static inline int ddebug_remove_module(char *mod)
+static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
 }
diff --git a/kernel/module.c b/kernel/module.c
index 8c6b428..4b98b48 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2062,6 +2062,14 @@ static void dynamic_debug_setup(struct _ddebug *debug, unsigned int num)
 #endif
 }
 
+static void dynamic_debug_remove(struct _ddebug *debug)
+{
+#ifdef CONFIG_DYNAMIC_DEBUG
+	if (debug)
+		ddebug_remove_module(debug->modname);
+#endif
+}
+
 static void *module_alloc_update_bounds(unsigned long size)
 {
 	void *ret = module_alloc(size);
@@ -2124,6 +2132,8 @@ static noinline struct module *load_module(void __user *umod,
 	void *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long symoffs, stroffs, *strmap;
 	void __percpu *percpu;
+	struct _ddebug *debug = NULL;
+	unsigned int num_debug = 0;
 
 	mm_segment_t old_fs;
 
@@ -2476,15 +2486,9 @@ static noinline struct module *load_module(void __user *umod,
 	kfree(strmap);
 	strmap = NULL;
 
-	if (!mod->taints) {
-		struct _ddebug *debug;
-		unsigned int num_debug;
-
+	if (!mod->taints)
 		debug = section_objs(hdr, sechdrs, secstrings, "__verbose",
 				     sizeof(*debug), &num_debug);
-		if (debug)
-			dynamic_debug_setup(debug, num_debug);
-	}
 
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
@@ -2526,10 +2530,13 @@ static noinline struct module *load_module(void __user *umod,
 		goto unlock;
 	}
 
+	if (debug)
+		dynamic_debug_setup(debug, num_debug);
+
 	/* Find duplicate symbols */
 	err = verify_export_symbols(mod);
 	if (err < 0)
-		goto unlock;
+		goto ddebug;
 
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
@@ -2557,6 +2564,8 @@ static noinline struct module *load_module(void __user *umod,
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
+ ddebug:
+	dynamic_debug_remove(debug);
  unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 3df8eb1..02afc25 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -692,7 +692,7 @@ static void ddebug_table_free(struct ddebug_table *dt)
  * Called in response to a module being unloaded.  Removes
  * any ddebug_table's which point at the module.
  */
-int ddebug_remove_module(char *mod_name)
+int ddebug_remove_module(const char *mod_name)
 {
 	struct ddebug_table *dt, *nextdt;
 	int ret = -ENOENT;
-- 
1.5.6.5

