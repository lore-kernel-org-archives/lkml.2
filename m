Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab0FPEDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:03:54 -0400
Received: from ozlabs.org ([203.10.76.45]:60162 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab0FPEDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:03:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: torvalds@linux-foundation.org
Subject: [PATCH] module: initialize module dynamic debug later
Date: Wed, 16 Jun 2010 13:33:50 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, linux-kernel@vger.kernel.org,
       yehudasa@gmail.com, sage@newdream.net
References: <b419ab1fe660cb24a32e63f9c2da2301b3ff1278.1276647544.git.yehuda@hq.newdream.net>
In-Reply-To: <b419ab1fe660cb24a32e63f9c2da2301b3ff1278.1276647544.git.yehuda@hq.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161333.50868.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yehuda Sadeh <yehuda@hq.newdream.net>

We should initialize the module dynamic debug datastructures
only after determining that the module is not loaded yet. This
fixes a bug that introduced in 2.6.35-rc2, where when a trying
to load a module twice, we also load it's dynamic printing data
twice which causes all sorts of nasty issues. Also handle
the dynamic debug cleanup later on failure.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (removed a #ifdef)
---
 include/linux/dynamic_debug.h |    4 ++--
 kernel/module.c               |   23 +++++++++++++++--------
 lib/dynamic_debug.c           |    2 +-
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -40,7 +40,7 @@ int ddebug_add_module(struct _ddebug *ta
 				const char *modname);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
-extern int ddebug_remove_module(char *mod_name);
+extern int ddebug_remove_module(const char *mod_name);
 
 #define __dynamic_dbg_enabled(dd)  ({	     \
 	int __ret = 0;							     \
@@ -73,7 +73,7 @@ extern int ddebug_remove_module(char *mo
 
 #else
 
-static inline int ddebug_remove_module(char *mod)
+static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
 }
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2062,6 +2062,12 @@ static void dynamic_debug_setup(struct _
 #endif
 }
 
+static void dynamic_debug_remove(struct _ddebug *debug)
+{
+	if (debug)
+		ddebug_remove_module(debug->modname);
+}
+
 static void *module_alloc_update_bounds(unsigned long size)
 {
 	void *ret = module_alloc(size);
@@ -2124,6 +2130,8 @@ static noinline struct module *load_modu
 	void *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long symoffs, stroffs, *strmap;
 	void __percpu *percpu;
+	struct _ddebug *debug = NULL;
+	unsigned int num_debug = 0;
 
 	mm_segment_t old_fs;
 
@@ -2476,15 +2484,9 @@ static noinline struct module *load_modu
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
@@ -2526,10 +2528,13 @@ static noinline struct module *load_modu
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
@@ -2557,6 +2562,8 @@ static noinline struct module *load_modu
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
+ ddebug:
+	dynamic_debug_remove(debug);
  unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -692,7 +692,7 @@ static void ddebug_table_free(struct dde
  * Called in response to a module being unloaded.  Removes
  * any ddebug_table's which point at the module.
  */
-int ddebug_remove_module(char *mod_name)
+int ddebug_remove_module(const char *mod_name)
 {
 	struct ddebug_table *dt, *nextdt;
 	int ret = -ENOENT;
