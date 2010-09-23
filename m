Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0IWD6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:58:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0IWD4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:09 -0400
X-Authority-Analysis: v=1.1 cv=xllhIT3+0iZermAJQK9ulaVoiSOvD1gApk/LON5m1IU= c=1 sm=0 a=pDz72WaWmTcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=oFBuF9Ulp2jZCSZ_AsQA:9 a=kRxr2brkulnxV2XLpu0A:7 a=d3Nz4h8Ys5Ze0xkfv71GDTsbH_oA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=bpkO5YsEzB_Nt0GA:21 a=oDzMeQt4K0LmMQMg:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923035608.684280775@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 05/11] jump label: Add jump_label_text_reserved() to reserve jump points
References: <20100923034910.867858597@goodmis.org>
Content-Disposition: inline; filename=0005-jump-label-Add-jump_label_text_reserved-to-reserve-j.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

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
-- 
1.7.1


