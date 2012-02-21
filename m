Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2BUUDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BUUD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:27 -0500
Date: Tue, 21 Feb 2012 15:03:04 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Message-Id: <53a004b746028ee29ad2008decc118b76548f2e3.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 04/10] jump label: introduce very_likely()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current very_unlikely() construct, assumes that the branch will be
disabled by default. This means we have a single no-op in the straight line
path, and when the branch is made true we patch the no-op with a jump.

There are cases (sched feat code), where we want the branch to default to
true, so that the straight line code is the true branch, and the false
branch is enabled via a jump.

In order to implement this while having, jump_label_inc(), and
jump_label_dec() retain their current meaning, we have to store the
initial branch state. I'm using the lowest bit of the 'entries'
pointer in the jump_label_key struct, since this points to memory
that has to be aligned to the arch pointer size. We could have stored this
in the 'struct jump_entry' data structure, but I wanted to avoid
adding additional space overhead.

Thus, the new API is initialized as:

	struct jump_label_key true_key = JUMP_LABEL_INIT_TRUE;

			or

	struct jump_label_key false_key = JUMP_LABEL_INIT_FALSE;

Leaving out an initialization, defaults to false, as in:

	struct jump_label_key uninitialized_key;


Then, for the branches we have:

	very_unlikely(&false_key);

		or

	very_likely(&true_key);

And finally, jump_label_inc(&key), jump_label_dec(&key) are unchanged -
'jump_label_inc()' means 'make true', and jump_label_dec()' means make false,
with the expected increment/decrement counting.

Thus, you must use 'true_key' with a 'very_likely()' branch, and a
'false_key' or an 'uninitialized_key' with a 'very_unlikely()' branch.
Mixing different branches with the same jump_label_key is not allowed.

I've left the old static_branch(), (which is the same as the new
very_unlikely()), at least until we've converted over all in-tree and
pending users.

Signed-off-by: Jason Baron <jbaron@redhat.com>
[ Simplified code using jump_label_type(); removed CONFIG_MODULE
  special casing, since C99 initialization inits all unmentioned
  members to 0; obfuscated key->entries initialization. ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/742699c7e855a61f881c501ea415a43a5da9cd04.1324493360.git.jbaron@redhat.com
---
 include/linux/jump_label.h |   89 ++++++++++++++++++++++++++++++++++----------
 kernel/jump_label.c        |   72 ++++++++++++++++++++++-------------
 2 files changed, 115 insertions(+), 46 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 563c781..fdf6fff 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -9,10 +9,10 @@
  *
  * Jump labels provide an interface to generate dynamic branches using
  * self-modifying code. Assuming toolchain and architecture support the result
- * of a "if (static_branch(&key))" statement is a unconditional branch (which
+ * of a "if (very_unlikely(&key))" statement is a unconditional branch (which
  * defaults to false - and the true block is placed out of line).
  *
- * However at runtime we can change the 'static' branch target using
+ * However at runtime we can change the branch target using
  * jump_label_{inc,dec}(). These function as a 'reference' count on the key
  * object and for as long as there are references all branches referring to
  * that particular key will point to the (out of line) true block.
@@ -31,7 +31,21 @@
  *
  * Lacking toolchain and or architecture support, it falls back to a simple
  * conditional branch.
- */
+ *
+ * struct jump_label_key my_key = JUMP_LABEL_INIT_TRUE;
+ *
+ *   if (very_likely(&my_key)) {
+ *   }
+ *
+ * will result in the true case being in-line and starts the key with a single
+ * reference. Mixing very_likely() and very_unlikely() on the same key is not
+ * allowed.
+ *
+ * Not initializing the key (static data is initialized to 0s anyway) is the
+ * same as using JUMP_LABEL_INIT_FALSE and very_unlikely() is
+ * equivalent with static_branch().
+ *
+*/
 
 #include <linux/types.h>
 #include <linux/compiler.h>
@@ -41,6 +55,7 @@
 
 struct jump_label_key {
 	atomic_t enabled;
+/* Set lsb bit to 1 if branch is default true, 0 ot */
 	struct jump_entry *entries;
 #ifdef CONFIG_MODULES
 	struct jump_label_mod *next;
@@ -66,17 +81,32 @@ struct module;
 
 #ifdef HAVE_JUMP_LABEL
 
-#ifdef CONFIG_MODULES
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL, NULL}
-#else
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
-#endif
+#define JUMP_LABEL_TRUE_BRANCH 1UL
+
+static
+inline struct jump_entry *jump_label_get_entries(struct jump_label_key *key)
+{
+	return (struct jump_entry *)((unsigned long)key->entries
+						& ~JUMP_LABEL_TRUE_BRANCH);
+}
+
+static inline bool jump_label_get_branch_default(struct jump_label_key *key)
+{
+	if ((unsigned long)key->entries & JUMP_LABEL_TRUE_BRANCH)
+		return true;
+	return false;
+}
 
 static __always_inline bool very_unlikely(struct jump_label_key *key)
 {
 	return arch_static_branch(key);
 }
 
+static __always_inline bool very_likely(struct jump_label_key *key)
+{
+	return !very_unlikely(key);
+}
+
 /* Deprecated. Please use 'very_unlikely() instead. */
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
@@ -97,17 +127,20 @@ extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
 extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
-extern bool jump_label_enabled(struct jump_label_key *key);
+extern bool jump_label_true(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
-extern void jump_label_rate_limit(struct jump_label_key_deferred *key,
-		unsigned long rl);
+extern void
+jump_label_rate_limit(struct jump_label_key_deferred *key, unsigned long rl);
+
+#define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
+	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
+#define JUMP_LABEL_INIT_FALSE ((struct jump_label_key) \
+	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
 
 #else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
-
 struct jump_label_key {
 	atomic_t enabled;
 };
@@ -122,7 +155,14 @@ struct jump_label_key_deferred {
 
 static __always_inline bool very_unlikely(struct jump_label_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)))
+	if (unlikely(atomic_read(&key->enabled)) > 0)
+		return true;
+	return false;
+}
+
+static __always_inline bool very_likely(struct jump_label_key *key)
+{
+	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
@@ -130,7 +170,7 @@ static __always_inline bool very_unlikely(struct jump_label_key *key)
 /* Deprecated. Please use 'very_unlikely() instead. */
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)))
+	if (unlikely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
@@ -158,9 +198,9 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline bool jump_label_enabled(struct jump_label_key *key)
+static inline bool jump_label_true(struct jump_label_key *key)
 {
-	return !!atomic_read(&key->enabled);
+	return (atomic_read(&key->enabled) > 0);
 }
 
 static inline int jump_label_apply_nops(struct module *mod)
@@ -168,13 +208,22 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
-static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
+static inline void
+jump_label_rate_limit(struct jump_label_key_deferred *key,
 		unsigned long rl)
 {
 }
+
+#define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
+		{ .enabled = ATOMIC_INIT(1) })
+#define JUMP_LABEL_INIT_FALSE ((struct jump_label_key) \
+		{ .enabled = ATOMIC_INIT(0) })
+
 #endif	/* HAVE_JUMP_LABEL */
 
-#define jump_label_key_enabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(1), })
-#define jump_label_key_disabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(0), })
+#define jump_label_key_enabled JUMP_LABEL_INIT_TRUE
+#define jump_label_key_disabled JUMP_LABEL_INIT_FALSE
+#define JUMP_LABEL_INIT JUMP_LABEL_INIT_FALSE
+#define jump_label_enabled jump_label_true
 
 #endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 543782e..2b55284 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -29,10 +29,11 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
-bool jump_label_enabled(struct jump_label_key *key)
+bool jump_label_true(struct jump_label_key *key)
 {
-	return !!atomic_read(&key->enabled);
+	return (atomic_read(&key->enabled) > 0);
 }
+EXPORT_SYMBOL_GPL(jump_label_true);
 
 static int jump_label_cmp(const void *a, const void *b)
 {
@@ -66,8 +67,12 @@ void jump_label_inc(struct jump_label_key *key)
 		return;
 
 	jump_label_lock();
-	if (atomic_read(&key->enabled) == 0)
-		jump_label_update(key, JUMP_LABEL_ENABLE);
+	if (atomic_read(&key->enabled) == 0) {
+		if (!jump_label_get_branch_default(key))
+			jump_label_update(key, JUMP_LABEL_ENABLE);
+		else
+			jump_label_update(key, JUMP_LABEL_DISABLE);
+	}
 	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
@@ -85,12 +90,14 @@ static void __jump_label_dec(struct jump_label_key *key,
 	if (rate_limit) {
 		atomic_inc(&key->enabled);
 		schedule_delayed_work(work, rate_limit);
-	} else
-		jump_label_update(key, JUMP_LABEL_DISABLE);
-
+	} else {
+		if (!jump_label_get_branch_default(key))
+			jump_label_update(key, JUMP_LABEL_DISABLE);
+		else
+			jump_label_update(key, JUMP_LABEL_ENABLE);
+	}
 	jump_label_unlock();
 }
-EXPORT_SYMBOL_GPL(jump_label_dec);
 
 static void jump_label_update_timeout(struct work_struct *work)
 {
@@ -103,12 +110,13 @@ void jump_label_dec(struct jump_label_key *key)
 {
 	__jump_label_dec(key, 0, NULL);
 }
+EXPORT_SYMBOL_GPL(jump_label_dec);
 
 void jump_label_dec_deferred(struct jump_label_key_deferred *key)
 {
 	__jump_label_dec(&key->key, key->timeout, &key->work);
 }
-
+EXPORT_SYMBOL_GPL(jump_label_dec_deferred);
 
 void jump_label_rate_limit(struct jump_label_key_deferred *key,
 		unsigned long rl)
@@ -170,6 +178,17 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
+static enum jump_label_type jump_label_type(struct jump_label_key *key)
+{
+	bool true_branch = jump_label_get_branch_default(key);
+	bool state = jump_label_true(key);
+
+	if ((!true_branch && state) || (true_branch && !state))
+		return JUMP_LABEL_ENABLE;
+
+	return JUMP_LABEL_DISABLE;
+}
+
 void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
@@ -184,13 +203,15 @@ void __init jump_label_init(void)
 		struct jump_label_key *iterk;
 
 		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
-						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, jump_label_type(iterk));
 		if (iterk == key)
 			continue;
 
 		key = iterk;
-		key->entries = iter;
+		/*
+		 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
+		 */
+		*((unsigned long *)&key->entries) += (unsigned long)iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
 #endif
@@ -254,11 +275,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		struct jump_label_key *iterk;
-
-		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
-				JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
 	}
 }
 
@@ -277,28 +294,30 @@ static int jump_label_add_module(struct module *mod)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		if (iter->key == (jump_label_t)(unsigned long)key)
-			continue;
+		struct jump_label_key *iterk;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		if (iterk == key)
+			continue;
 
+		key = iterk;
 		if (__module_address(iter->key) == mod) {
-			atomic_set(&key->enabled, 0);
-			key->entries = iter;
+			/*
+			 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
+			 */
+			*((unsigned long *)&key->entries) += (unsigned long)iter;
 			key->next = NULL;
 			continue;
 		}
-
 		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
 		if (!jlm)
 			return -ENOMEM;
-
 		jlm->mod = mod;
 		jlm->entries = iter;
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_enabled(key))
+		if (jump_label_type(key) == JUMP_LABEL_ENABLE)
 			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
 	}
 
@@ -421,7 +440,8 @@ int jump_label_text_reserved(void *start, void *end)
 
 static void jump_label_update(struct jump_label_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
+	struct jump_entry *stop = __stop___jump_table;
+	struct jump_entry *entry = jump_label_get_entries(key);
 
 #ifdef CONFIG_MODULES
 	struct module *mod = __module_address((unsigned long)key);
-- 
1.7.7.5

