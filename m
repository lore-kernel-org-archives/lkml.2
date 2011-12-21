Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1LUTJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:09:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1LUTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:09:16 -0500
Date: Wed, 21 Dec 2011 14:09:05 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        mingo@elte.hu, davem@davemloft.net, ddaney.cavm@gmail.com,
        pjt@google.com, rth@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <742699c7e855a61f881c501ea415a43a5da9cd04.1324493360.git.jbaron@redhat.com>
In-Reply-To: <cover.1324493360.git.jbaron@redhat.com>
References: <cover.1324493360.git.jbaron@redhat.com>
Subject: [PATCH 1/4] jump label: Introduce default true branch + API update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current static_branch() construct, assumes that the branch will be
disabled by default. This means we have a single no-op in the straight line
path, and when the branch is made true we patch the no-op with a jump.

There are cases (sched feat code), where we want the branch to default to
true, so that the straight line code is the true branch, and the false
branch is enabled via a jump.

In order to implement this while having, jump_label_inc(), and jump_label_dec()
retain their current meaning, we have to store the initial branch state. I'm using
the lowest bit of the 'entries' pointer in the jump_label_key struct, since this
points to memory that has to be aligned to the arch pointer size. We could have
stored this in the 'struct jump_entry' data structure, but I wanted to avoid adding
additional space overhead.

Thus, the new API is initialized as:

	struct jump_label_key true_key = JUMP_LABEL_INIT_TRUE;

			or

	struct jump_label_key false_key = JUMP_LABEL_INIT_FALSE;

Leaving out an initialization, defaults to false, as in:

	struct jump_label_key uninitialized_key;


Then, for the branches we have:

	static_branch_def_false(false_key);

		or

	static_branch_def_true(true_key);

And finally, jump_label_inc(&key), jump_label_dec(&key) are unchanged -
'jump_label_inc()' means 'make true', and jump_label_dec()' means make false,
with the expected increment/decrement counting.

Thus, you must use 'true_key' with a 'static_branch_def_true' branch, and a
'false_key' or a 'uninitialized_key' with a 'static_branch_def_false' branch.
Mixing different static branches with the same jump_label_key is not allowed.

I've left the old static_branch(), (which is the same as the new
static_branch_def_false()), at least until we've converted over all
in-tree and pending users.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |   77 ++++++++++++++++++++++++++++++++++++-------
 kernel/jump_label.c        |   66 +++++++++++++++++++++++++------------
 2 files changed, 109 insertions(+), 34 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 5ce8b14..a885b5f 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -9,6 +9,7 @@
 
 struct jump_label_key {
 	atomic_t enabled;
+/* Set lsb bit to 1 if branch is default true, 0 ot */
 	struct jump_entry *entries;
 #ifdef CONFIG_MODULES
 	struct jump_label_mod *next;
@@ -34,17 +35,37 @@ struct module;
 
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
 
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	return arch_static_branch(key);
 }
 
+static __always_inline bool static_branch_def_false(struct jump_label_key *key)
+{
+	return arch_static_branch(key);
+}
+
+static __always_inline bool static_branch_def_true(struct jump_label_key *key)
+{
+	return !static_branch_def_false(key);
+}
+
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
@@ -59,17 +80,27 @@ extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
 extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
-extern bool jump_label_enabled(struct jump_label_key *key);
+extern bool jump_label_true(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 extern void jump_label_rate_limit(struct jump_label_key_deferred *key,
 		unsigned long rl);
 
+#ifdef CONFIG_MODULES
+ #define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
+	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1, .next = NULL  })
+ #define JUMP_LABEL_INIT_FALSE ((struct jump_label_key) \
+	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0, .next = NULL })
+#else
+ #define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
+	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1  })
+ #define JUMP_LABEL_INIT_FALSE ((struct jump_label_key) \
+	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
+#endif
+
 #else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
-
 struct jump_label_key {
 	atomic_t enabled;
 };
@@ -84,7 +115,21 @@ struct jump_label_key_deferred {
 
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)))
+	if (unlikely(atomic_read(&key->enabled)) > 0)
+		return true;
+	return false;
+}
+
+static __always_inline bool static_branch_def_false(struct jump_label_key *key)
+{
+	if (unlikely(atomic_read(&key->enabled)) > 0)
+		return true;
+	return false;
+}
+
+static __always_inline bool static_branch_def_true(struct jump_label_key *key)
+{
+	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
@@ -112,9 +157,9 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline bool jump_label_enabled(struct jump_label_key *key)
+static inline bool jump_label_true(struct jump_label_key *key)
 {
-	return !!atomic_read(&key->enabled);
+	return (atomic_read(&key->enabled) > 0);
 }
 
 static inline int jump_label_apply_nops(struct module *mod)
@@ -126,9 +171,15 @@ static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
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
+#define JUMP_LABEL_INIT JUMP_LABEL_INIT_FALSE
+#define jump_label_enabled jump_label_true
 
 #endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 30c3c77..5a05906 100644
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
+EXPORT_SYMBOL(jump_label_true);
 
 static int jump_label_cmp(const void *a, const void *b)
 {
@@ -66,11 +67,16 @@ void jump_label_inc(struct jump_label_key *key)
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
+EXPORT_SYMBOL(jump_label_inc);
 
 static void __jump_label_dec(struct jump_label_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
@@ -81,9 +87,12 @@ static void __jump_label_dec(struct jump_label_key *key,
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
 
@@ -98,6 +107,7 @@ void jump_label_dec(struct jump_label_key *key)
 {
 	__jump_label_dec(key, 0, NULL);
 }
+EXPORT_SYMBOL(jump_label_dec);
 
 void jump_label_dec_deferred(struct jump_label_key_deferred *key)
 {
@@ -171,21 +181,32 @@ void __init jump_label_init(void)
 	struct jump_entry *iter_stop = __stop___jump_table;
 	struct jump_label_key *key = NULL;
 	struct jump_entry *iter;
+	bool true_branch;
 
 	jump_label_lock();
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
 		struct jump_label_key *iterk;
+		enum jump_label_type type;
 
 		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
-						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		true_branch = jump_label_get_branch_default(iterk);
+		type = JUMP_LABEL_DISABLE;
+		if (!true_branch) {
+			if (jump_label_true(iterk))
+				type = JUMP_LABEL_ENABLE;
+		} else {
+			if (!jump_label_true(iterk))
+				type = JUMP_LABEL_ENABLE;
+		}
+		arch_jump_label_transform_static(iter, type);
 		if (iterk == key)
 			continue;
 
 		key = iterk;
-		key->entries = iter;
+		key->entries = (struct jump_entry *)((unsigned long)iter |
+				(true_branch ? JUMP_LABEL_TRUE_BRANCH : 0));
 #ifdef CONFIG_MODULES
 		key->next = NULL;
 #endif
@@ -249,11 +270,7 @@ void jump_label_apply_nops(struct module *mod)
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
 
@@ -264,6 +281,7 @@ static int jump_label_add_module(struct module *mod)
 	struct jump_entry *iter;
 	struct jump_label_key *key = NULL;
 	struct jump_label_mod *jlm;
+	bool true_branch;
 
 	/* if the module doesn't have jump label entries, just return */
 	if (iter_start == iter_stop)
@@ -272,16 +290,17 @@ static int jump_label_add_module(struct module *mod)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
+
 		if (iter->key == (jump_label_t)(unsigned long)key)
 			continue;
 
 		key = (struct jump_label_key *)(unsigned long)iter->key;
+		true_branch = jump_label_get_branch_default(key);
 
 		if (__module_address(iter->key) == mod) {
-			atomic_set(&key->enabled, 0);
-			key->entries = iter;
+			key->entries = (struct jump_entry *)((unsigned long)iter
+				| (true_branch ? JUMP_LABEL_TRUE_BRANCH : 0));
 			key->next = NULL;
-			continue;
 		}
 
 		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
@@ -293,8 +312,12 @@ static int jump_label_add_module(struct module *mod)
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
+		if (jump_label_true(key) && !true_branch)
+			__jump_label_update(key, iter, iter_stop,
+						JUMP_LABEL_ENABLE);
+		if (!jump_label_true(key) && true_branch)
+			__jump_label_update(key, iter, iter_stop,
+						JUMP_LABEL_ENABLE);
 	}
 
 	return 0;
@@ -416,7 +439,8 @@ int jump_label_text_reserved(void *start, void *end)
 
 static void jump_label_update(struct jump_label_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
+	struct jump_entry *stop = __stop___jump_table;
+	struct jump_entry *entry = jump_label_get_entries(key);
 
 #ifdef CONFIG_MODULES
 	struct module *mod = __module_address((jump_label_t)key);
-- 
1.7.7.3

