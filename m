Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0FIVk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab0FIVkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:40:23 -0400
Date: Wed, 9 Jun 2010 17:39:32 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <2a7e0be296375cf6658647c8a9c6cb208d875ac8.1276116186.git.jbaron@redhat.com>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 10/13] jump label v9: convert jump label to use a key
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
 arch/x86/include/asm/jump_label.h |   21 +++++++++++--------
 include/linux/jump_label.h        |   32 ++++++++----------------------
 include/linux/tracepoint.h        |    5 +--
 kernel/jump_label.c               |   38 ++++++++++++++++--------------------
 kernel/tracepoint.c               |    6 ++--
 scripts/mod/modpost.c             |   14 +-----------
 scripts/mod/modpost.h             |    1 -
 7 files changed, 45 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index d911d36..3bf5581 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -10,33 +10,36 @@
 
 # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
 
-# define JUMP_LABEL(tag, label, cond)				\
+# define JUMP_LABEL(key, label)					\
 	do {							\
-		extern const char __jlstrtab_##tag[];		\
 		asm goto("1:"					\
 			JUMP_LABEL_INITIAL_NOP			\
 			".pushsection __jump_table,  \"a\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
-			: :  "i" (__jlstrtab_##tag) :  : label);\
+			: :  "i" (key) :  : label);		\
 	} while (0)
 
 #endif /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
 
+typedef __u64 jump_label_t;
+
 struct jump_entry {
-	__u64 code;
-	__u64 target;
-	__u64 name;
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
 };
 
 #else
 
+typedef __u32 jump_label_t;
+
 struct jump_entry {
-	__u32 code;
-	__u32 target;
-	__u32 name;
+	jump_label_t code;
+	jump_label_t target;
+	jump_label_t key;
 };
 
 #endif
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3250793..ebe19ae 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -18,45 +18,31 @@ struct module;
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
-#define DEFINE_JUMP_LABEL(name)						\
-	const char __jlstrtab_##name[]					\
-	__used __attribute__((section("__jump_strings")))  = #name;	\
-	EXPORT_SYMBOL_GPL(__jlstrtab_##name);
-
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern const u8 *arch_get_jump_label_nop(void);
 
-extern void jump_label_update(const char *name, enum jump_label_type type);
+extern void jump_label_update(jump_label_t key, enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 
 extern void apply_jump_label_nops(struct module *mod);
 
-#define enable_jump_label(name) \
-	jump_label_update(name, JUMP_LABEL_ENABLE);
+#define enable_jump_label(key) \
+	jump_label_update(key, JUMP_LABEL_ENABLE);
 
-#define disable_jump_label(name) \
-	jump_label_update(name, JUMP_LABEL_DISABLE);
+#define disable_jump_label(key) \
+	jump_label_update(key, JUMP_LABEL_DISABLE);
 
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
-
-static inline int disable_jump_label(const char *name)
-{
-	return 0;
-}
+#define enable_jump_label(key)
+#define disable_jump_label(key)
 
 static inline int apply_jump_label_nops(struct module *mod)
 {
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 883df16..9df40b8 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -145,7 +145,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		JUMP_LABEL(&__tracepoint_##name, do_trace, __tracepoint_##name.state);\
+		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
 		return;							\
 do_trace:								\
 			__DO_TRACE(&__tracepoint_##name,		\
@@ -174,8 +174,7 @@ do_trace:								\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
-	DEFINE_JUMP_LABEL(name);
+		{ __tpstrtab_##name, 0, reg, unreg, NULL };
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index ac39662..859a87c 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -27,7 +27,7 @@ struct jump_label_entry {
 	int nr_entries;
 	/* hang modules off here */
 	struct hlist_head modules;
-	const char *name;
+	unsigned long key;
 };
 
 struct jump_label_module_entry {
@@ -58,8 +58,7 @@ static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry
 		iter_next = start;
 		iter_next++;
 		for (; iter_next < stop; iter++, iter_next++) {
-			if (strcmp((char *)iter->name,
-						(char *)iter_next->name) > 0) {
+			if (iter->key > iter_next->key) {
 				swap_jump_label_entries(iter, iter_next);
 				swapped = 1;
 			}
@@ -67,29 +66,28 @@ static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry
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
 
@@ -97,10 +95,9 @@ static struct jump_label_entry *add_jump_label_entry(const char *name, int nr_en
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
@@ -117,17 +114,16 @@ static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entr
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
@@ -148,7 +144,7 @@ static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entr
  *
  */
 
-void jump_label_update(const char *name, enum jump_label_type type)
+void jump_label_update(jump_label_t key, enum jump_label_type type)
 {
 	struct jump_entry *iter;
 	struct jump_label_entry *entry;
@@ -157,7 +153,7 @@ void jump_label_update(const char *name, enum jump_label_type type)
 	int count;
 
 	mutex_lock(&jump_label_mutex);
-	entry = get_jump_label_entry(name);
+	entry = get_jump_label_entry(key);
 	if (entry) {
 		count = entry->nr_entries;
 		iter = entry->table;
@@ -316,16 +312,16 @@ static int add_jump_label_module(struct module *mod)
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
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index b16d873..efd6896 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -265,9 +265,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
 	if (!elem->state && active)
-		enable_jump_label(elem->name);
+		enable_jump_label((jump_label_t)&elem->state);
 	if (elem->state && !active)
-		disable_jump_label(elem->name);
+		disable_jump_label((jump_label_t)&elem->state);
 	elem->state = active;
 }
 
@@ -283,7 +283,7 @@ static void disable_tracepoint(struct tracepoint *elem)
 		elem->unregfunc();
 
 	if (elem->state)
-		disable_jump_label(elem->name);
+		disable_jump_label((jump_label_t)&elem->state);
 
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1ed8380..a03b045 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -393,19 +393,14 @@ static void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
 {
 	int swapped = 0;
 	struct jump_entry *iter, *iter_next;
-	char *name, *next_name;
 	Elf_Shdr *sechdrs = info->sechdrs;
 	unsigned long jump_table, jump_table_end;
-	unsigned long jump_strings, jump_strings_addr;
 
-	if ((info->jump_sec == 0) && (info->jump_strings_sec == 0))
+	if (info->jump_sec == 0)
 		return;
 
 	jump_table = (unsigned long)hdr + sechdrs[info->jump_sec].sh_offset;
 	jump_table_end = jump_table + sechdrs[info->jump_sec].sh_size;
-	jump_strings = (unsigned long)hdr +
-				sechdrs[info->jump_strings_sec].sh_offset;
-	jump_strings_addr = sechdrs[info->jump_strings_sec].sh_addr;
 
 	do {
 		swapped = 0;
@@ -413,10 +408,7 @@ static void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
 		iter_next++;
 		for (; iter_next < (struct jump_entry *)jump_table_end;
 							iter++, iter_next++) {
-			name = (char *)(jump_strings + (iter->name - jump_strings_addr));
-			next_name = (char *)(jump_strings +
-					(iter_next->name - jump_strings_addr));
-			if (strcmp(name, next_name) > 0) {
+			if (iter->key > iter_next->key) {
 				swap_jump_label_entries(iter, iter_next);
 				swapped = 1;
 			}
@@ -528,8 +520,6 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->export_gpl_future_sec = i;
 		else if (strcmp(secname, "__jump_table") == 0)
 			info->jump_sec = i;
-		else if (strcmp(secname, "__jump_strings") == 0)
-			info->jump_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0875d4b..362b966 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -127,7 +127,6 @@ struct elf_info {
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
 	Elf_Section  jump_sec;
-	Elf_Section  jump_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
-- 
1.7.1

