Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0IXJAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:00:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:33780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab0IXJAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:00:18 -0400
Date: Fri, 24 Sep 2010 09:00:02 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
        mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
        mhiramat@redhat.com
In-Reply-To: <06236663a3a7b1c1f13576bb9eccb6d9c17b7bfe.1284733808.git.jbaron@redhat.com>
References: <06236663a3a7b1c1f13576bb9eccb6d9c17b7bfe.1284733808.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Add jump_label_text_reserved() to reserve jump points
Message-ID: <tip-4c3ef6d79328c0e23ade60cbfc8d496123a6855c@git.kernel.org>
Git-Commit-ID: 4c3ef6d79328c0e23ade60cbfc8d496123a6855c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Sep 2010 09:00:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c3ef6d79328c0e23ade60cbfc8d496123a6855c
Gitweb:     http://git.kernel.org/tip/4c3ef6d79328c0e23ade60cbfc8d496123a6855c
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Fri, 17 Sep 2010 11:09:08 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 22 Sep 2010 16:30:46 -0400

jump label: Add jump_label_text_reserved() to reserve jump points

Add a jump_label_text_reserved(void *start, void *end), so that other
pieces of code that want to modify kernel text, can first verify that
jump label has not reserved the instruction.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <06236663a3a7b1c1f13576bb9eccb6d9c17b7bfe.1284733808.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/kprobes.c  |    3 +-
 include/linux/jump_label.h |    8 ++++-
 kernel/jump_label.c        |   83 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c           |    3 +-
 4 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e05952a..1cbd54c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1218,7 +1218,8 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
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
index 460fd40..7be868b 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -177,6 +177,89 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
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
index 18904e4..ec4210c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1147,7 +1147,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr)) {
+	    ftrace_text_reserved(p->addr, p->addr) ||
+	    jump_label_text_reserved(p->addr, p->addr)) {
 		preempt_enable();
 		return -EINVAL;
 	}
