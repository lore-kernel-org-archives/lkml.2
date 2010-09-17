Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0IQPJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab0IQPJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:40 -0400
Date: Fri, 17 Sep 2010 11:09:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <06236663a3a7b1c1f13576bb9eccb6d9c17b7bfe.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 05/10] jump label v11: jump_label_text_reserved() to reserve our jump points
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a jump_label_text_reserved(void *start, void *end), so that other
pieces of code that want to modify kernel text, can first verify that
jump label has not reserved the instruction.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/kernel/kprobes.c  |    3 +-
 include/linux/jump_label.h |    8 ++++-
 kernel/jump_label.c        |   83 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c           |    3 +-
 4 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 770ebfb..788fade 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1221,7 +1221,8 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 	}
 	/* Check whether the address range is reserved */
 	if (ftrace_text_reserved(src, src + len - 1) ||
-	    alternatives_text_reserved(src, src + len - 1))
+	    alternatives_text_reserved(src, src + len - 1) ||
+	    jump_label_text_reserved(src, src + len - 1))
 		return -EBUSY;
 
 	return len;
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index de58656..b72cd9f 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -20,9 +20,10 @@ extern struct jump_entry __stop___jump_table[];
 
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
+extern void arch_jump_label_text_poke_early(jump_label_t addr);
 extern void jump_label_update(unsigned long key, enum jump_label_type type);
 extern void jump_label_apply_nops(struct module *mod);
-extern void arch_jump_label_text_poke_early(jump_label_t addr);
+extern int jump_label_text_reserved(void *start, void *end);
 
 #define enable_jump_label(key) \
 	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
@@ -53,6 +54,11 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
+static inline int jump_label_text_reserved(void *start, void *end)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 07656ec..f82878b 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -174,6 +174,89 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 	mutex_unlock(&jump_label_mutex);
 }
 
+static int addr_conflict(struct jump_entry *entry, void *start, void *end)
+{
+	if (entry->code <= (unsigned long)end &&
+		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
+		return 1;
+
+	return 0;
+}
+
+#ifdef CONFIG_MODULES
+
+static int module_conflict(void *start, void *end)
+{
+	struct hlist_head *head;
+	struct hlist_node *node, *node_next, *module_node, *module_node_next;
+	struct jump_label_entry *e;
+	struct jump_label_module_entry *e_module;
+	struct jump_entry *iter;
+	int i, count;
+	int conflict = 0;
+
+	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
+		head = &jump_label_table[i];
+		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
+			hlist_for_each_entry_safe(e_module, module_node,
+							module_node_next,
+							&(e->modules), hlist) {
+				count = e_module->nr_entries;
+				iter = e_module->table;
+				while (count--) {
+					if (addr_conflict(iter, start, end)) {
+						conflict = 1;
+						goto out;
+					}
+					iter++;
+				}
+			}
+		}
+	}
+out:
+	return conflict;
+}
+
+#endif
+
+/***
+ * jump_label_text_reserved - check if addr range is reserved
+ * @start: start text addr
+ * @end: end text addr
+ *
+ * checks if the text addr located between @start and @end
+ * overlaps with any of the jump label patch addresses. Code
+ * that wants to modify kernel text should first verify that
+ * it does not overlap with any of the jump label addresses.
+ *
+ * returns 1 if there is an overlap, 0 otherwise
+ */
+int jump_label_text_reserved(void *start, void *end)
+{
+	struct jump_entry *iter;
+	struct jump_entry *iter_start = __start___jump_table;
+	struct jump_entry *iter_stop = __start___jump_table;
+	int conflict = 0;
+
+	mutex_lock(&jump_label_mutex);
+	iter = iter_start;
+	while (iter < iter_stop) {
+		if (addr_conflict(iter, start, end)) {
+			conflict = 1;
+			goto out;
+		}
+		iter++;
+	}
+
+	/* now check modules */
+#ifdef CONFIG_MODULES
+	conflict = module_conflict(start, end);
+#endif
+out:
+	mutex_unlock(&jump_label_mutex);
+	return conflict;
+}
+
 static __init int init_jump_label(void)
 {
 	int ret;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 798adfa..a53bff3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1142,7 +1142,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr)) {
+	    ftrace_text_reserved(p->addr, p->addr) ||
+	    jump_label_text_reserved(p->addr, p->addr)) {
 		preempt_enable();
 		return -EINVAL;
 	}
-- 
1.7.1

