Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0IVN1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 09:27:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36682 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0IVN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 09:26:58 -0400
From: Andi Kleen <andi@firstfloor.org>
To: jbaron@redhat.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] Rewrite jump_label.c to use binary search v2
Date: Wed, 22 Sep 2010 15:26:41 +0200
Message-Id: <1285162001-9556-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285162001-9556-1-git-send-email-andi@firstfloor.org>
References: <1285162001-9556-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

After the discussion on linux-kernel I decided to rewrite the
hash table based jump_label.c to use binary search as proposed.

This shrunk the code dramatically by >50%:

hash:
 2763      80     544    3387     d3b kernel/jump_label.o
binsearch:
 1072      40       0    1112     458 kernel/jump_label.o

This is only code size, at runtime there will be additional savings
because the new code does not allocate any additional memory.

Also the code is a lot simpler now:

jump_label.c |  391 +++++++++++------------------------------------------------
 1 files changed, 74 insertions(+), 317 deletions(-)

(+ a few lines for a new generic utility function in module.c)

I believe it's also much cleaner than before.

I did some performance tests comparing the hash implementation
with the binary search. This was with a moderate config x86-64
kernel with 68 modules loaded and about 480 trace points active
in several modules and 1340 dynamic debug statements.

I measured arming all/unarming trace points and enabling all
dynamic debug points. The differences in cycles were always
within 30%, in fact in the dynamic debug case the binsearch
implementation was even faster.

In all cases the runtimes were less than a single ms, so
there was no user visible difference at all.

So this is a vastly simpler implementation with in practice
equivalent performance and less memory overhead (no data structures
outside the sections)

The patch is on top of Jason's patchkit.

v2: Fix off by on bug in binary search pointed out by Mathieu.
Fix another overlap bug inherited from the old code in checking for
conflicts.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/jump_label.c |  391 ++++++++++-----------------------------------------
 1 files changed, 74 insertions(+), 317 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index f82878b..3f5273f 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -2,133 +2,78 @@
  * jump label support
  *
  * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
- *
+ * Rewritten in 2010 by Andi Kleen
  */
 #include <linux/jump_label.h>
 #include <linux/memory.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
-#include <linux/list.h>
-#include <linux/jhash.h>
-#include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/err.h>
 
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_LABEL_HASH_BITS 6
-#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
-static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
+#define ENTRIES(start, stop) (((stop) - (start)) / sizeof(*(start)))
 
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
-struct jump_label_entry {
-	struct hlist_node hlist;
-	struct jump_entry *table;
-	int nr_entries;
-	/* hang modules off here */
-	struct hlist_head modules;
-	unsigned long key;
-};
-
-struct jump_label_module_entry {
-	struct hlist_node hlist;
-	struct jump_entry *table;
-	int nr_entries;
-	struct module *mod;
-};
-
 static int jump_label_cmp(const void *a, const void *b)
 {
 	const struct jump_entry *jea = a;
 	const struct jump_entry *jeb = b;
 
-	if (jea->key < jeb->key)
-		return -1;
-
-	if (jea->key > jeb->key)
-		return 1;
-
-	return 0;
+	return jea->key - jeb->key;
 }
 
 static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
 {
-	unsigned long size;
-
-	size = (((unsigned long)stop - (unsigned long)start)
-					/ sizeof(struct jump_entry));
-	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
+	sort(start, ENTRIES(start, stop), sizeof(struct jump_entry), jump_label_cmp, 
+	     NULL);
 }
 
-static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
+static struct jump_entry *
+search_jump_table(struct jump_entry *first, struct jump_entry *last, 
+		  unsigned long key)
 {
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct jump_label_entry *e;
-	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
-
-	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
-		if (key == e->key)
-			return e;
+	while (first <= last) { 
+		struct jump_entry *mid = (last - first)/2 + first;
+		
+		if (mid->key < key)
+			first = mid + 1;
+		else if (mid->key > key)
+			last = mid - 1;
+		else
+			return mid;
 	}
 	return NULL;
 }
 
-static struct jump_label_entry *add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
+void patch_jump_table(unsigned long key, enum jump_label_type type,
+	 	      struct jump_entry *start, struct jump_entry *stop)
 {
-	struct hlist_head *head;
-	struct jump_label_entry *e;
-	u32 hash;
-
-	e = get_jump_label_entry(key);
-	if (e)
-		return ERR_PTR(-EEXIST);
-
-	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-
-	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
-	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	e->key = key;
-	e->table = table;
-	e->nr_entries = nr_entries;
-	INIT_HLIST_HEAD(&(e->modules));
-	hlist_add_head(&e->hlist, head);
-	return e;
+	struct jump_entry *entry = search_jump_table(start, stop - 1, key);
+	if (!entry)
+		return;
+	while (entry > start && entry[-1].key == key)
+		entry--;
+	for (; entry < stop && entry->key == key; entry++)
+		if (kernel_text_address(entry->code))
+			arch_jump_label_transform(entry, type);
 }
 
-static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
+struct args {
+	unsigned long key;
+	enum jump_label_type type;
+};
+
+static void module_patch_jump_table(struct module *mod, void *args)
 {
-	struct jump_entry *iter, *iter_begin;
-	struct jump_label_entry *entry;
-	int count;
+	struct args *a = args;
 
-	sort_jump_label_entries(start, stop);
-	iter = start;
-	while (iter < stop) {
-		entry = get_jump_label_entry(iter->key);
-		if (!entry) {
-			iter_begin = iter;
-			count = 0;
-			while ((iter < stop) &&
-				(iter->key == iter_begin->key)) {
-				iter++;
-				count++;
-			}
-			entry = add_jump_label_entry(iter_begin->key,
-							count, iter_begin);
-			if (IS_ERR(entry))
-				return PTR_ERR(entry);
-		 } else {
-			WARN_ONCE(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
-			return -1;
-		}
-	}
-	return 0;
+	if (mod->num_jump_entries)
+		patch_jump_table(a->key, a->type, mod->jump_entries,
+				 mod->jump_entries + mod->num_jump_entries);
 }
 
 /***
@@ -143,82 +88,42 @@ static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entr
 
 void jump_label_update(unsigned long key, enum jump_label_type type)
 {
-	struct jump_entry *iter;
-	struct jump_label_entry *entry;
-	struct hlist_node *module_node;
-	struct jump_label_module_entry *e_module;
-	int count;
+	struct args args = { .key = key, .type = type };
 
 	mutex_lock(&jump_label_mutex);
-	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
-		while (count--) {
-			if (kernel_text_address(iter->code))
-				arch_jump_label_transform(iter, type);
-			iter++;
-		}
-		/* eanble/disable jump labels in modules */
-		hlist_for_each_entry(e_module, module_node, &(entry->modules),
-							hlist) {
-			count = e_module->nr_entries;
-			iter = e_module->table;
-			while (count--) {
-				if (kernel_text_address(iter->code))
-					arch_jump_label_transform(iter, type);
-				iter++;
-			}
-		}
-	}
+	patch_jump_table(key, type, __start___jump_table, __stop___jump_table);
+	for_each_module(module_patch_jump_table, &args);
 	mutex_unlock(&jump_label_mutex);
 }
 
-static int addr_conflict(struct jump_entry *entry, void *start, void *end)
+static int check_conflict(struct jump_entry *jstart, struct jump_entry *jstop,
+			   void *start, void *stop)
 {
-	if (entry->code <= (unsigned long)end &&
-		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
-		return 1;
+	struct jump_entry *entry;
 
+	for (entry = jstart; entry < jstop; entry++)
+		if (entry->code <= (unsigned long)stop &&
+		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
+			return 1;
 	return 0;
 }
 
-#ifdef CONFIG_MODULES
+struct conflict_args {
+	void *start, *end;
+	int conflict;
+};
 
-static int module_conflict(void *start, void *end)
+static void module_check_conflict(struct module *mod, void *args)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
-	struct jump_entry *iter;
-	int i, count;
-	int conflict = 0;
+	struct conflict_args *a = args;
 
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-							module_node_next,
-							&(e->modules), hlist) {
-				count = e_module->nr_entries;
-				iter = e_module->table;
-				while (count--) {
-					if (addr_conflict(iter, start, end)) {
-						conflict = 1;
-						goto out;
-					}
-					iter++;
-				}
-			}
-		}
-	}
-out:
-	return conflict;
+	if (within_module_core((unsigned long)a->start, mod) || 
+	    within_module_init((unsigned long)a->start, mod))
+		a->conflict = check_conflict(mod->jump_entries, 
+				     mod->jump_entries + mod->num_jump_entries, 
+				     a->start, a->end);
 }
 
-#endif
-
 /***
  * jump_label_text_reserved - check if addr range is reserved
  * @start: start text addr
@@ -233,189 +138,41 @@ out:
  */
 int jump_label_text_reserved(void *start, void *end)
 {
-	struct jump_entry *iter;
-	struct jump_entry *iter_start = __start___jump_table;
-	struct jump_entry *iter_stop = __start___jump_table;
-	int conflict = 0;
+	struct conflict_args args = { .start = start, .end = end };
 
 	mutex_lock(&jump_label_mutex);
-	iter = iter_start;
-	while (iter < iter_stop) {
-		if (addr_conflict(iter, start, end)) {
-			conflict = 1;
-			goto out;
-		}
-		iter++;
-	}
-
+	args.conflict = check_conflict(__start___jump_table, 
+				       __stop___jump_table, start, end);
 	/* now check modules */
 #ifdef CONFIG_MODULES
-	conflict = module_conflict(start, end);
+	if (!args.conflict)
+		for_each_module(module_check_conflict, &args);
 #endif
-out:
 	mutex_unlock(&jump_label_mutex);
-	return conflict;
+	return args.conflict;
 }
 
-static __init int init_jump_label(void)
+static void setup_jump_label(struct jump_entry *start, struct jump_entry *stop)
 {
-	int ret;
-	struct jump_entry *iter_start = __start___jump_table;
-	struct jump_entry *iter_stop = __stop___jump_table;
-	struct jump_entry *iter;
+	struct jump_entry *entry;
 
 	mutex_lock(&jump_label_mutex);
-	ret = build_jump_label_hashtable(__start___jump_table,
-					 __stop___jump_table);
-	iter = iter_start;
-	while (iter < iter_stop) {
-		arch_jump_label_text_poke_early(iter->code);
-		iter++;
-	}
+	sort_jump_label_entries(start, stop);
+	for (entry = start; entry < stop; entry++)
+		arch_jump_label_text_poke_early(entry->code);
 	mutex_unlock(&jump_label_mutex);
-	return ret;
-}
-early_initcall(init_jump_label);
-
-#ifdef CONFIG_MODULES
-
-static struct jump_label_module_entry *add_jump_label_module_entry(struct jump_label_entry *entry, struct jump_entry *iter_begin, int count, struct module *mod)
-{
-	struct jump_label_module_entry *e;
-
-	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-	e->mod = mod;
-	e->nr_entries = count;
-	e->table = iter_begin;
-	hlist_add_head(&e->hlist, &entry->modules);
-	return e;
 }
 
-static int add_jump_label_module(struct module *mod)
+static int init_jump_label(void)
 {
-	struct jump_entry *iter, *iter_begin;
-	struct jump_label_entry *entry;
-	struct jump_label_module_entry *module_entry;
-	int count;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return 0;
-
-	sort_jump_label_entries(mod->jump_entries,
-				mod->jump_entries + mod->num_jump_entries);
-	iter = mod->jump_entries;
-	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		entry = get_jump_label_entry(iter->key);
-		iter_begin = iter;
-		count = 0;
-		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
-			(iter->key == iter_begin->key)) {
-				iter++;
-				count++;
-		}
-		if (!entry) {
-			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
-			if (IS_ERR(entry))
-				return PTR_ERR(entry);
-		}
-		module_entry = add_jump_label_module_entry(entry, iter_begin,
-							   count, mod);
-		if (IS_ERR(module_entry))
-			return PTR_ERR(module_entry);
-	}
+	setup_jump_label(__start___jump_table, __stop___jump_table);
 	return 0;
 }
+early_initcall(init_jump_label);
 
-static void remove_jump_label_module(struct module *mod)
-{
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
-	int i;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-						  module_node_next,
-						  &(e->modules), hlist) {
-				if (e_module->mod == mod) {
-					hlist_del(&e_module->hlist);
-					kfree(e_module);
-				}
-			}
-			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
-				hlist_del(&e->hlist);
-				kfree(e);
-			}
-		}
-	}
-}
-
-static int jump_label_module_notify(struct notifier_block *self, unsigned long val, void *data)
-{
-	struct module *mod = data;
-	int ret = 0;
-
-	switch (val) {
-	case MODULE_STATE_COMING:
-		mutex_lock(&jump_label_mutex);
-		ret = add_jump_label_module(mod);
-		if (ret)
-			remove_jump_label_module(mod);
-		mutex_unlock(&jump_label_mutex);
-		break;
-	case MODULE_STATE_GOING:
-		mutex_lock(&jump_label_mutex);
-		remove_jump_label_module(mod);
-		mutex_unlock(&jump_label_mutex);
-		break;
-	}
-	return ret;
-}
-
-/***
- * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
- * @mod: module to patch
- *
- * Allow for run-time selection of the optimal nops. Before the module
- * loads patch these with arch_get_jump_label_nop(), which is specified by
- * the arch specific jump label code.
- */
 void jump_label_apply_nops(struct module *mod)
 {
-	struct jump_entry *iter;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
-	iter = mod->jump_entries;
-	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		arch_jump_label_text_poke_early(iter->code);
-		iter++;
-	}
-}
-
-struct notifier_block jump_label_module_nb = {
-	.notifier_call = jump_label_module_notify,
-	.priority = 0,
-};
-
-static __init int init_jump_label_module(void)
-{
-	return register_module_notifier(&jump_label_module_nb);
+	setup_jump_label(mod->jump_entries, 
+			 mod->jump_entries + mod->num_jump_entries);
 }
-early_initcall(init_jump_label_module);
-
-#endif /* CONFIG_MODULES */
-
 #endif
-- 
1.7.1

