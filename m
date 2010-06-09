Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab0FIVkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492Ab0FIVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:40:00 -0400
Date: Wed, 9 Jun 2010 17:39:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <f2ff95c1afea5823cc96e9793f8aea80b782ea87.1276116186.git.jbaron@redhat.com>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 09/13] jump label v9: jump_label_text_reserved() to reserve our jump points
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
 include/linux/jump_label.h |    6 +++
 kernel/jump_label.c        |   83 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c           |    3 +-
 4 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 345a4b1..87ca919 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1201,7 +1201,8 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 	}
 	/* Check whether the address range is reserved */
 	if (ftrace_text_reserved(src, src + len - 1) ||
-	    alternatives_text_reserved(src, src + len - 1))
+	    alternatives_text_reserved(src, src + len - 1) ||
+	    jump_label_text_reserved(src, src + len - 1))
 		return -EBUSY;
 
 	return len;
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index dc81a45..3250793 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -28,6 +28,7 @@ extern void arch_jump_label_transform(struct jump_entry *entry,
 extern const u8 *arch_get_jump_label_nop(void);
 
 extern void jump_label_update(const char *name, enum jump_label_type type);
+extern int jump_label_text_reserved(void *start, void *end);
 
 extern void apply_jump_label_nops(struct module *mod);
 
@@ -62,6 +63,11 @@ static inline int apply_jump_label_nops(struct module *mod)
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
index 3ebe2bf..ac39662 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -181,6 +181,89 @@ void jump_label_update(const char *name, enum jump_label_type type)
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
 static int init_jump_label(void)
 {
 	int ret;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..2f9bea6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1141,7 +1141,8 @@ int __kprobes register_kprobe(struct kprobe *p)
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

