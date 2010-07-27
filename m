Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0G0UzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0G0UzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:55:03 -0400
Date: Tue, 27 Jul 2010 16:54:32 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <1d0369680bbab87acfef5499e479bdc6d991ebea.1280263065.git.jbaron@redhat.com>
In-Reply-To: <cover.1280263065.git.jbaron@redhat.com>
References: <cover.1280263065.git.jbaron@redhat.com>
Subject: [PATCH 06/12] jump label v10: convert jump label to use a key
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the jump label code to use a key to identify each related set of
jump labels instead of a string. This saves space since we no longer need
to store strings and their pointers, just the keys. In addition we can
simplify the JUMP_LABEL macro to 2 arguments from 3. We use the address
of the conditional variable as the key value. If jump labels are not enabled
then we can use the conditional variable as usual.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |   10 +++++---
 include/linux/jump_label.h        |   37 ++++++++++++++---------------------
 kernel/jump_label.c               |   38 ++++++++++++++++--------------------
 3 files changed, 38 insertions(+), 47 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3c7e9ab..8679ec7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -163,8 +163,7 @@
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
 	FTRACE_EVENTS()							\
-	TRACE_SYSCALLS()						\
-	JUMP_TABLE()							\
+	TRACE_SYSCALLS()
 
 /*
  * Data section helpers
@@ -203,7 +202,6 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
-		*(__jump_strings)/* Jump: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
@@ -212,6 +210,8 @@
 									\
 	BUG_TABLE							\
 									\
+	JUMP_TABLE							\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -555,11 +555,13 @@
 #define BUG_TABLE
 #endif
 
-#define JUMP_TABLE()							\
+#define JUMP_TABLE							\
 	. = ALIGN(8);							\
+	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___jump_table) = .;		\
 		*(__jump_table)						\
 		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
+	}
 
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index d3d00b6..c9e17b0 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -18,43 +18,36 @@ struct module;
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
-#define DEFINE_JUMP_LABEL(name)						\
-	const char __jlstrtab_##name[]					\
-	__used __attribute__((section("__jump_strings")))  = #name;	\
-	EXPORT_SYMBOL_GPL(__jlstrtab_##name);
-
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
-extern void jump_label_update(const char *name, enum jump_label_type type);
+extern void jump_label_update(unsigned long key, enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_apply_nops(struct module *mod);
 
-#define enable_jump_label(name) \
-	jump_label_update(name, JUMP_LABEL_ENABLE);
+#define enable_jump_label(key) \
+	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
 
-#define disable_jump_label(name) \
-	jump_label_update(name, JUMP_LABEL_DISABLE);
+#define disable_jump_label(key) \
+	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
 
 #else
 
-#define DEFINE_JUMP_LABEL(name)
-
-#define JUMP_LABEL(tag, label, cond)		\
+#define JUMP_LABEL(key, label)			\
 do {						\
-	if (unlikely(cond))			\
+	if (unlikely(*key))			\
 		goto label;			\
 } while (0)
 
-static inline int enable_jump_label(const char *name)
-{
-	return 0;
-}
+#define enable_jump_label(cond_var)	\
+do {					\
+	*(cond_var) = 1;		\
+} while (0)
 
-static inline int disable_jump_label(const char *name)
-{
-	return 0;
-}
+#define disable_jump_label(cond_var)	\
+do {					\
+	*(cond_var) = 0;		\
+} while (0)
 
 static inline int jump_label_apply_nops(struct module *mod)
 {
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index c1e59bb..10fb17f 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -28,7 +28,7 @@ struct jump_label_entry {
 	int nr_entries;
 	/* hang modules off here */
 	struct hlist_head modules;
-	const char *name;
+	unsigned long key;
 };
 
 struct jump_label_module_entry {
@@ -59,8 +59,7 @@ static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry
 		iter_next = start;
 		iter_next++;
 		for (; iter_next < stop; iter++, iter_next++) {
-			if (strcmp((char *)iter->name,
-						(char *)iter_next->name) > 0) {
+			if (iter->key > iter_next->key) {
 				swap_jump_label_entries(iter, iter_next);
 				swapped = 1;
 			}
@@ -68,29 +67,28 @@ static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry
 	} while (swapped == 1);
 }
 
-static struct jump_label_entry *get_jump_label_entry(const char *name)
+static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
 	struct jump_label_entry *e;
-	u32 hash = jhash(name, strlen(name), 0);
+	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
 
 	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
 	hlist_for_each_entry(e, node, head, hlist) {
-		if (!strcmp((char *)name, (char *)e->name))
+		if (key == e->key)
 			return e;
 	}
 	return NULL;
 }
 
-static struct jump_label_entry *add_jump_label_entry(const char *name, int nr_entries, struct jump_entry *table)
+static struct jump_label_entry *add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 {
 	struct hlist_head *head;
 	struct jump_label_entry *e;
-	size_t name_len;
 	u32 hash;
 
-	e = get_jump_label_entry(name);
+	e = get_jump_label_entry(key);
 	if (e)
 		return ERR_PTR(-EEXIST);
 
@@ -98,10 +96,9 @@ static struct jump_label_entry *add_jump_label_entry(const char *name, int nr_en
 	if (!e)
 		return ERR_PTR(-ENOMEM);
 
-	name_len = strlen(name) + 1;
-	hash = jhash(name, name_len-1, 0);
+	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
 	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	e->name = name;
+	e->key = key;
 	e->table = table;
 	e->nr_entries = nr_entries;
 	INIT_HLIST_HEAD(&(e->modules));
@@ -118,17 +115,16 @@ static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entr
 	sort_jump_label_entries(start, stop);
 	iter = start;
 	while (iter < stop) {
-		entry = get_jump_label_entry((char *)iter->name);
+		entry = get_jump_label_entry(iter->key);
 		if (!entry) {
 			iter_begin = iter;
 			count = 0;
 			while ((iter < stop) &&
-				(strcmp((char *)iter->name,
-					(char *)iter_begin->name) == 0)) {
+				(iter->key == iter_begin->key)) {
 				iter++;
 				count++;
 			}
-			entry = add_jump_label_entry((char *)iter_begin->name,
+			entry = add_jump_label_entry(iter_begin->key,
 							count, iter_begin);
 			if (IS_ERR(entry))
 				return PTR_ERR(entry);
@@ -150,7 +146,7 @@ static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entr
  *
  */
 
-void jump_label_update(const char *name, enum jump_label_type type)
+void jump_label_update(unsigned long key, enum jump_label_type type)
 {
 	struct jump_entry *iter;
 	struct jump_label_entry *entry;
@@ -159,7 +155,7 @@ void jump_label_update(const char *name, enum jump_label_type type)
 	int count;
 
 	mutex_lock(&jump_label_mutex);
-	entry = get_jump_label_entry(name);
+	entry = get_jump_label_entry((jump_label_t)key);
 	if (entry) {
 		count = entry->nr_entries;
 		iter = entry->table;
@@ -317,16 +313,16 @@ static int add_jump_label_module(struct module *mod)
 				mod->jump_entries + mod->num_jump_entries);
 	iter = mod->jump_entries;
 	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		entry = get_jump_label_entry((char *)iter->name);
+		entry = get_jump_label_entry(iter->key);
 		iter_begin = iter;
 		count = 0;
 		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
-			(strcmp((char *)iter->name, (char *)iter_begin->name) == 0)) {
+			(iter->key == iter_begin->key)) {
 				iter++;
 				count++;
 		}
 		if (!entry) {
-			entry = add_jump_label_entry((char *)iter_begin->name, 0, NULL);
+			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
 			if (IS_ERR(entry))
 				return PTR_ERR(entry);
 		}
-- 
1.7.1

