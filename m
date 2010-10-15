Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0JOUM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:12:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab0JOUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:38 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=1vFLXohBnmoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=YgSPEmYM6dfwRAaGJtAA:9 a=2En-6YyyPLDpzE3nuFEA:7 a=BOP-Crj-HMKvg76h-kxWlE11bv0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=qxvBBZD-L70gfkZs:21 a=KNx1S9U874eQmBHf:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201036.923619508@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 5/9] jump label: Add register_jump_label_key/unregister_jump_label_key
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0005-jump-label-Add-register_jump_label_key-unregister_ju.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

There are two cases where jump labels didn't match the state
transitions of tracepoints.

1)

A tracepoint is enabled in the core kernel for say kmalloc and
then a module is loaded which has a kmalloc call. We currently
would miss enabling the jump label for the kmalloc in the module.
This is addressed by associating an 'enabled' field with each
jump label. Now, when a new module is loaded we check if any of
the jump labels in that module need to be enabled. If so, we enable
them.

2)

If a tracepoint is defined in the core kernel code, but the usage
of the tracepoint is confined to a module, the current jump label
code does not create a entry in its table until the module is
loaded. Thus, if the tracepoint is enabled before the module
is loaded, we would miss the enablement of the jump label.

I'm not sure if there any tracepoints which currently fall into
this category (the bkl could fall into this category at some point
if its only used in modules). However, I do think its an important
case to address to make sure that jump label behave in a consistent
way with how consumers of the tracepoints might expect.

This case is implemented by introducing:

void register_jump_label_key(unsigned long key);
void unregister_jump_label_key(unsigned long key);

So basically any jump label that we want to use in the system must
first be registered, then it can be enabled/disabled, and then
finally it can be unregistered. For core kernel jump labels, I would
only expect them to be registered and never unregistered. However,
a jump label may be unregistred when modules are removed.

Although, this introduces some more work for consumers wanting
to use jump labels, the tracepoint and dynamic debug consumer code
seems fairly contained, at least to me.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <12fafc1958abf192532a25aedbe6b50a2587c7a3.1285965957.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/jump_label.h |    4 +
 kernel/jump_label.c        |  158 +++++++++++++++++++++++++++++++++++++-------
 kernel/tracepoint.c        |   34 ++++++++++
 lib/dynamic_debug.c        |   20 ++++++
 4 files changed, 193 insertions(+), 23 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index cf213d1..382cd23 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -26,6 +26,8 @@ extern void arch_jump_label_text_poke_early(jump_label_t addr);
 extern void jump_label_update(unsigned long key, enum jump_label_type type);
 extern void jump_label_apply_nops(struct module *mod);
 extern int jump_label_text_reserved(void *start, void *end);
+void register_jump_label_key(unsigned long key);
+void unregister_jump_label_key(unsigned long key);
 
 #define enable_jump_label(key) \
 	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
@@ -63,6 +65,8 @@ static inline int jump_label_text_reserved(void *start, void *end)
 
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
+static inline void register_jump_label_key(unsigned long key) {}
+static inline void unregister_jump_label_key(unsigned long key) {}
 
 #endif
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 12cce78..b30ef81 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -19,6 +19,7 @@
 #define JUMP_LABEL_HASH_BITS 6
 #define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
 static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
+static int registered;
 
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
@@ -26,17 +27,19 @@ static DEFINE_MUTEX(jump_label_mutex);
 struct jump_label_entry {
 	struct hlist_node hlist;
 	struct jump_entry *table;
-	int nr_entries;
 	/* hang modules off here */
 	struct hlist_head modules;
 	unsigned long key;
+	__u32 nr_entries : 30;
+	__u32 registered : 1;
+	__u32 enabled : 1;
 };
 
 struct jump_label_module_entry {
 	struct hlist_node hlist;
 	struct jump_entry *table;
-	int nr_entries;
 	struct module *mod;
+	int nr_entries;
 };
 
 void jump_label_lock(void)
@@ -108,6 +111,8 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 	e->key = key;
 	e->table = table;
 	e->nr_entries = nr_entries;
+	e->enabled = 0;
+	e->registered = 0;
 	INIT_HLIST_HEAD(&(e->modules));
 	hlist_add_head(&e->hlist, head);
 	return e;
@@ -163,28 +168,43 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 	int count;
 
 	jump_label_lock();
+	if (unlikely(!registered)) {
+		WARN(1, KERN_ERR "jump label: update before activation!\n");
+		goto out;
+	}
 	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
+	if (unlikely(!entry)) {
+		WARN(1, KERN_ERR "jump label: updating unkown key: %lu\n", key);
+		goto out;
+	}
+	if (unlikely(!entry->registered)) {
+		WARN(1, KERN_ERR "jump label: update without register:"
+			" %lu\n", key);
+		goto out;
+	}
+	if (type == JUMP_LABEL_ENABLE)
+		entry->enabled = 1;
+	else
+		entry->enabled = 0;
+	count = entry->nr_entries;
+	iter = entry->table;
+	while (count--) {
+		if (kernel_text_address(iter->code))
+			arch_jump_label_transform(iter, type);
+		iter++;
+	}
+	/* eanble/disable jump labels in modules */
+	hlist_for_each_entry(e_module, module_node, &(entry->modules),
+						hlist) {
+		count = e_module->nr_entries;
+		iter = e_module->table;
 		while (count--) {
-			if (kernel_text_address(iter->code))
+			if (iter->key && kernel_text_address(iter->code))
 				arch_jump_label_transform(iter, type);
 			iter++;
 		}
-		/* eanble/disable jump labels in modules */
-		hlist_for_each_entry(e_module, module_node, &(entry->modules),
-							hlist) {
-			count = e_module->nr_entries;
-			iter = e_module->table;
-			while (count--) {
-				if (iter->key &&
-						kernel_text_address(iter->code))
-					arch_jump_label_transform(iter, type);
-				iter++;
-			}
-		}
 	}
+out:
 	jump_label_unlock();
 }
 
@@ -197,6 +217,63 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 	return 0;
 }
 
+/***
+ * register_jump_label_key - register a jump label key
+ * @key -  key value associated with a a jump label
+ *
+ * Code that wants to use a jump label must first register the key before
+ * before calling jump_label_update on it.
+ */
+
+void register_jump_label_key(unsigned long key)
+{
+	struct jump_label_entry *entry;
+
+	jump_label_lock();
+	entry = get_jump_label_entry((jump_label_t)key);
+	if (!entry)
+		entry = add_jump_label_entry((jump_label_t)key, 0, NULL);
+	if (!entry)
+		goto out;
+	if (entry->registered)
+		WARN(1, KERN_ERR "jump label: re-register key: %lu !\n", key);
+	else
+		entry->registered = 1;
+out:
+	jump_label_unlock();
+}
+EXPORT_SYMBOL_GPL(register_jump_label_key);
+
+/***
+ * unregister_jump_label_key - unregister a jump label key
+ * @key -  key value associated with a a jump label
+ *
+ * Code that no longer needs to make use of jump label (such as a module)
+ * needs to call this to clean up state.
+ */
+
+void unregister_jump_label_key(unsigned long key)
+{
+	struct jump_label_entry *entry;
+
+	jump_label_lock();
+	entry = get_jump_label_entry((jump_label_t)key);
+	if (!entry) {
+		jump_label_unlock();
+		WARN(1, KERN_ERR "jump label: remove unknown key: %lu\n", key);
+		return;
+	}
+	if (entry->nr_entries || (!hlist_empty(&entry->modules)))
+		WARN(1, KERN_ERR "jump label: remove used key: %lu\n", key);
+	else {
+		entry->registered = 0;
+		hlist_del(&entry->hlist);
+		kfree(entry);
+	}
+	jump_label_unlock();
+}
+EXPORT_SYMBOL_GPL(unregister_jump_label_key);
+
 #ifdef CONFIG_MODULES
 
 static int module_conflict(void *start, void *end)
@@ -285,6 +362,7 @@ static __init int init_jump_label(void)
 		arch_jump_label_text_poke_early(iter->code);
 		iter++;
 	}
+	registered = 1;
 	jump_label_unlock();
 	return ret;
 }
@@ -309,6 +387,41 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
 	return e;
 }
 
+static void update_jump_label_module(struct module *mod)
+{
+	struct hlist_head *head;
+	struct hlist_node *node, *node_next, *module_node, *module_node_next;
+	struct jump_label_entry *e;
+	struct jump_label_module_entry *e_module;
+	struct jump_entry *iter;
+	int i, count;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (!mod->num_jump_entries)
+		return;
+
+	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
+		head = &jump_label_table[i];
+		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
+			if (!e->enabled)
+				continue;
+			hlist_for_each_entry_safe(e_module, module_node,
+						  module_node_next,
+						  &(e->modules), hlist) {
+				if (e_module->mod != mod)
+					continue;
+				count = e_module->nr_entries;
+				iter = e_module->table;
+				while (count--) {
+					arch_jump_label_transform(iter,
+							JUMP_LABEL_ENABLE);
+					iter++;
+				}
+			}
+		}
+	}
+}
+
 static int add_jump_label_module(struct module *mod)
 {
 	struct jump_entry *iter, *iter_begin;
@@ -342,6 +455,9 @@ static int add_jump_label_module(struct module *mod)
 		if (IS_ERR(module_entry))
 			return PTR_ERR(module_entry);
 	}
+	/* update new entries to the correct state */
+	update_jump_label_module(mod);
+
 	return 0;
 }
 
@@ -368,10 +484,6 @@ static void remove_jump_label_module(struct module *mod)
 					kfree(e_module);
 				}
 			}
-			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
-				hlist_del(&e->hlist);
-				kfree(e);
-			}
 		}
 	}
 }
@@ -463,7 +575,7 @@ void jump_label_apply_nops(struct module *mod)
 
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
-	.priority = 0,
+	.priority = 1, /* higher than tracepoints */
 };
 
 static __init int init_jump_label_module(void)
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d6073a5..00e4074 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -575,6 +575,33 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
+
+static void jump_label_reg_unreg(struct tracepoint *begin,
+				 struct tracepoint *end, int reg)
+{
+	struct tracepoint *iter;
+	if (!begin)
+		return;
+
+	mutex_lock(&tracepoints_mutex);
+	for (iter = begin; iter < end; iter++) {
+		if (reg)
+			register_jump_label_key((unsigned long)&iter->state);
+		else
+			unregister_jump_label_key((unsigned long)&iter->state);
+	}
+	mutex_unlock(&tracepoints_mutex);
+}
+#define jump_label_register(begin, end) jump_label_reg_unreg(begin, end, 1);
+#define jump_label_unregister(begin, end) jump_label_reg_unreg(begin, end, 0);
+
+static int __init init_jump_label_register(void)
+{
+	jump_label_register(__start___tracepoints, __stop___tracepoints);
+	return 0;
+}
+core_initcall(init_jump_label_register);
+
 #ifdef CONFIG_MODULES
 
 int tracepoint_module_notify(struct notifier_block *self,
@@ -584,9 +611,16 @@ int tracepoint_module_notify(struct notifier_block *self,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
+		jump_label_register(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+		tracepoint_update_probe_range(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+		break;
 	case MODULE_STATE_GOING:
 		tracepoint_update_probe_range(mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
+		jump_label_unregister(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
 		break;
 	}
 	return 0;
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e925c7b..5ddcb3f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -79,6 +79,24 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	return buf;
 }
 
+static void jump_label_reg_unreg(struct ddebug_table *dt, int reg)
+{
+	int i;
+	if (!dt)
+		return;
+
+	for (i = 0 ; i < dt->num_ddebugs ; i++) {
+		struct _ddebug *dp = &dt->ddebugs[i];
+		if (reg)
+			register_jump_label_key((unsigned long)&dp->enabled);
+		else
+			unregister_jump_label_key((unsigned long)&dp->enabled);
+	}
+}
+
+#define jump_label_register(dt) jump_label_reg_unreg(dt, 1);
+#define jump_label_unregister(dt) jump_label_reg_unreg(dt, 0);
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
@@ -636,6 +654,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
 	mutex_lock(&ddebug_lock);
 	list_add_tail(&dt->link, &ddebug_tables);
+	jump_label_register(dt);
 	mutex_unlock(&ddebug_lock);
 
 	if (verbose)
@@ -647,6 +666,7 @@ EXPORT_SYMBOL_GPL(ddebug_add_module);
 
 static void ddebug_table_free(struct ddebug_table *dt)
 {
+	jump_label_unregister(dt);
 	list_del_init(&dt->link);
 	kfree(dt->mod_name);
 	kfree(dt);
-- 
1.7.1


