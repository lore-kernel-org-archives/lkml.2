Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2DFHD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:03:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38531 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2DFHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:03:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6671"; a="179411559"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC/PATCH 3/3] debugobjects: Use static keys for debug_objects_enabled
Date: Fri,  6 Apr 2012 00:03:18 -0700
Message-Id: <1333695798-2917-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.rc3.3.g19a6c
In-Reply-To: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
References: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a __read_mostly variable for returning early
from debug_objects operations use static keys. This should
allow us to dynamically patch out debug_objects code from a
running kernel and reduce the overhead of having debug objects
compiled in and not enabled.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

The inlining is sort of ugly.

 include/linux/debugobjects.h |   94 +++++++++++++++++++++++++++++++++++++-----
 lib/debugobjects.c           |   73 ++++++++++++--------------------
 2 files changed, 110 insertions(+), 57 deletions(-)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 0e5f578..902e430 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/jump_label.h>
 
 enum debug_obj_state {
 	ODEBUG_STATE_NONE,
@@ -60,26 +61,94 @@ struct debug_obj_descr {
 };
 
 #ifdef CONFIG_DEBUG_OBJECTS
-extern void debug_object_init      (void *addr, struct debug_obj_descr *descr);
+extern struct static_key debug_objects_enabled;
+#if CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT == 1
+	#define debug_object_branch static_key_true
+#else
+	#define debug_object_branch static_key_false
+#endif
+
+extern void _debug_object_init(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_init(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_init(addr, descr);
+}
+
 extern void
-debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr);
-extern void debug_object_activate  (void *addr, struct debug_obj_descr *descr);
-extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
-extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
-extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
-extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
+_debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_init_on_stack(addr, descr);
+}
+
+extern void _debug_object_activate(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_activate(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_activate(addr, descr);
+}
+
+extern void _debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_deactivate(addr, descr);
+}
 
+extern void _debug_object_destroy(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_destroy(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_destroy(addr, descr);
+}
+
+extern void _debug_object_free(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_free(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_free(addr, descr);
+}
+
+extern void
+_debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
+static __always_inline void
+debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_assert_init(addr, descr);
+}
 /*
  * Active state:
  * - Set at 0 upon initialization.
  * - Must return to 0 before deactivation.
  */
 extern void
-debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+_debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 			  unsigned int expect, unsigned int next);
+static __always_inline void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+			  unsigned int expect, unsigned int next)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_object_active_state(addr, descr, expect, next);
+}
 
 extern void debug_objects_early_init(void);
-extern void debug_objects_mem_init(void);
+
+extern void _debug_objects_mem_init(void);
+static __always_inline void debug_objects_mem_init(void)
+{
+	if (debug_object_branch(&debug_objects_enabled))
+		_debug_objects_mem_init();
+}
 #else
 static inline void
 debug_object_init      (void *addr, struct debug_obj_descr *descr) { }
@@ -101,7 +170,12 @@ static inline void debug_objects_mem_init(void) { }
 #endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_FREE
-extern void debug_check_no_obj_freed(const void *address, unsigned long size);
+extern void _debug_check_no_obj_freed(const void *address, unsigned long size);
+#define debug_check_no_obj_freed(address, size) \
+	({ \
+		if (debug_object_branch(&debug_objects_enabled)) \
+			_debug_check_no_obj_freed(address, size); \
+	})
 #else
 static inline void
 debug_check_no_obj_freed(const void *address, unsigned long size) { }
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 77cb245..4ca24a5 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/static_key.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
@@ -47,8 +48,12 @@ static struct kmem_cache	*obj_cache;
 static int			debug_objects_maxchain __read_mostly;
 static int			debug_objects_fixups __read_mostly;
 static int			debug_objects_warnings __read_mostly;
-static int			debug_objects_enabled __read_mostly
-				= CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT;
+struct static_key		debug_objects_enabled __read_mostly
+#if CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT == 1
+				= STATIC_KEY_INIT_TRUE;
+#else
+				= STATIC_KEY_INIT_FALSE;
+#endif
 
 static struct debug_obj_descr	*descr_test  __read_mostly;
 
@@ -57,13 +62,15 @@ static DECLARE_WORK(debug_obj_work, free_obj_work);
 
 static int __init enable_object_debug(char *str)
 {
-	debug_objects_enabled = 1;
+	if (!static_key_enabled(&debug_objects_enabled))
+		static_key_slow_inc(&debug_objects_enabled);
 	return 0;
 }
 
 static int __init disable_object_debug(char *str)
 {
-	debug_objects_enabled = 0;
+	if (static_key_enabled(&debug_objects_enabled))
+		static_key_slow_dec(&debug_objects_enabled);
 	return 0;
 }
 
@@ -320,7 +327,7 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
 	if (!obj) {
 		obj = alloc_object(addr, db, descr);
 		if (!obj) {
-			debug_objects_enabled = 0;
+			static_key_slow_dec(&debug_objects_enabled);
 			raw_spin_unlock_irqrestore(&db->lock, flags);
 			debug_objects_oom();
 			return;
@@ -357,11 +364,8 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_init(void *addr, struct debug_obj_descr *descr)
+void _debug_object_init(void *addr, struct debug_obj_descr *descr)
 {
-	if (!debug_objects_enabled)
-		return;
-
 	__debug_object_init(addr, descr, 0);
 }
 
@@ -371,11 +375,8 @@ void debug_object_init(void *addr, struct debug_obj_descr *descr)
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
+void _debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
 {
-	if (!debug_objects_enabled)
-		return;
-
 	__debug_object_init(addr, descr, 1);
 }
 
@@ -384,7 +385,7 @@ void debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_activate(void *addr, struct debug_obj_descr *descr)
+void _debug_object_activate(void *addr, struct debug_obj_descr *descr)
 {
 	enum debug_obj_state state;
 	struct debug_bucket *db;
@@ -394,9 +395,6 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 			       .state = ODEBUG_STATE_NOTAVAILABLE,
 			       .descr = descr };
 
-	if (!debug_objects_enabled)
-		return;
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -442,15 +440,12 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
+void _debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
 {
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (!debug_objects_enabled)
-		return;
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -489,16 +484,13 @@ void debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_destroy(void *addr, struct debug_obj_descr *descr)
+void _debug_object_destroy(void *addr, struct debug_obj_descr *descr)
 {
 	enum debug_obj_state state;
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (!debug_objects_enabled)
-		return;
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -535,16 +527,13 @@ out_unlock:
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_free(void *addr, struct debug_obj_descr *descr)
+void _debug_object_free(void *addr, struct debug_obj_descr *descr)
 {
 	enum debug_obj_state state;
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (!debug_objects_enabled)
-		return;
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -575,15 +564,12 @@ out_unlock:
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
  */
-void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
+void _debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
 {
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (!debug_objects_enabled)
-		return;
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -616,16 +602,13 @@ void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
  * @next:	state to move to if expected state is found
  */
 void
-debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+_debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 			  unsigned int expect, unsigned int next)
 {
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (!debug_objects_enabled)
-		return;
-
 	db = get_bucket((unsigned long) addr);
 
 	raw_spin_lock_irqsave(&db->lock, flags);
@@ -713,10 +696,9 @@ repeat:
 	}
 }
 
-void debug_check_no_obj_freed(const void *address, unsigned long size)
+void _debug_check_no_obj_freed(const void *address, unsigned long size)
 {
-	if (debug_objects_enabled)
-		__debug_check_no_obj_freed(address, size);
+	__debug_check_no_obj_freed(address, size);
 }
 #endif
 
@@ -750,7 +732,7 @@ static int __init debug_objects_init_debugfs(void)
 {
 	struct dentry *dbgdir, *dbgstats;
 
-	if (!debug_objects_enabled)
+	if (!debug_object_branch(&debug_objects_enabled))
 		return 0;
 
 	dbgdir = debugfs_create_dir("debug_objects", NULL);
@@ -912,7 +894,7 @@ check_results(void *addr, enum debug_obj_state state, int fixups, int warnings)
 out:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 	if (res)
-		debug_objects_enabled = 0;
+		static_key_slow_dec(&debug_objects_enabled);
 	return res;
 }
 
@@ -1079,17 +1061,14 @@ free:
  * prevents that the debug code is called on kmem_cache_free() for the
  * debug tracker objects to avoid recursive calls.
  */
-void __init debug_objects_mem_init(void)
+void __init _debug_objects_mem_init(void)
 {
-	if (!debug_objects_enabled)
-		return;
-
 	obj_cache = kmem_cache_create("debug_objects_cache",
 				      sizeof (struct debug_obj), 0,
 				      SLAB_DEBUG_OBJECTS, NULL);
 
 	if (!obj_cache || debug_objects_replace_static_objects()) {
-		debug_objects_enabled = 0;
+		static_key_slow_dec(&debug_objects_enabled);
 		if (obj_cache)
 			kmem_cache_destroy(obj_cache);
 		printk(KERN_WARNING "ODEBUG: out of memory.\n");
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

