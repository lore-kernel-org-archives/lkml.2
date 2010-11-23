Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0KWV2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:28:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0KWV2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:28:17 -0500
Date: Tue, 23 Nov 2010 16:27:26 -0500
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Message-Id: <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
In-Reply-To: <cover.1290546539.git.jbaron@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
Subject: [PATCH 1/3] jump label: add enabled/disabled state to jump label key entries
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By storing the state of the jump label with each key, we make
sure that when modules are added, they are updated to the correct
state. For example, if the kmalloc tracepoint is enabled and
a module is added which has kmalloc, we make sure that the tracepoint
is properly enabled on module load.

Also, if jump_label_enable(key), is called but the key has not yet
been added to the hashtable of jump label keys, add 'key' to the table.
In this way, if key value has its state updated, but we have not
yet encountered a JUMP_LABEL() definition for it (if its located in
a module), we ensure that the jump label is set to the correct
state when it finally is encountered.

When modules are unloaded, we traverse the jump label hashtable,
and remove any entries that have a key value that is contained
by that module's text section. In this way key values are properly
unregistered, and can be re-used.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/jump_label.c |  101 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 79 insertions(+), 22 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3b79bd9..88e853a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -26,10 +26,11 @@ static DEFINE_MUTEX(jump_label_mutex);
 struct jump_label_entry {
 	struct hlist_node hlist;
 	struct jump_entry *table;
-	int nr_entries;
 	/* hang modules off here */
 	struct hlist_head modules;
 	unsigned long key;
+	u32 nr_entries : 31,
+	       enabled :  1;
 };
 
 struct jump_label_module_entry {
@@ -108,6 +109,7 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 	e->key = key;
 	e->table = table;
 	e->nr_entries = nr_entries;
+	e->enabled = 0;
 	INIT_HLIST_HEAD(&(e->modules));
 	hlist_add_head(&e->hlist, head);
 	return e;
@@ -164,27 +166,37 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 
 	jump_label_lock();
 	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
+	if (!entry) {
+		if (type == JUMP_LABEL_ENABLE) {
+			entry = add_jump_label_entry(key, 0, NULL);
+			if (IS_ERR(entry))
+				goto out;
+		} else
+			goto out;
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
+	/* enable/disable jump labels in modules */
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
 
@@ -316,6 +328,41 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
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
@@ -349,6 +396,9 @@ static int add_jump_label_module(struct module *mod)
 		if (IS_ERR(module_entry))
 			return PTR_ERR(module_entry);
 	}
+	/* update new entries to the correct state */
+	update_jump_label_module(mod);
+
 	return 0;
 }
 
@@ -360,10 +410,6 @@ static void remove_jump_label_module(struct module *mod)
 	struct jump_label_module_entry *e_module;
 	int i;
 
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
 	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
 		head = &jump_label_table[i];
 		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
@@ -375,10 +421,21 @@ static void remove_jump_label_module(struct module *mod)
 					kfree(e_module);
 				}
 			}
+		}
+	}
+	/* now check if any keys can be removed */
+	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
+		head = &jump_label_table[i];
+		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
+			if (!within_module_core(e->key, mod))
+				continue;
 			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
 				hlist_del(&e->hlist);
 				kfree(e);
+				continue;
 			}
+			WARN(1, KERN_ERR "jump label: "
+				"tyring to remove used key: %lu !\n", e->key);
 		}
 	}
 }
@@ -470,7 +527,7 @@ void jump_label_apply_nops(struct module *mod)
 
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
-	.priority = 0,
+	.priority = 1, /* higher than tracepoints */
 };
 
 static __init int init_jump_label_module(void)
-- 
1.7.1

