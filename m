Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0CVQIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab0CVQIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:08:15 -0400
Date: Mon, 22 Mar 2010 12:07:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
Message-Id: <bb5d2337c2e9b5d949fdca9b7d1811be4a17ba8b.1269272444.git.jbaron@redhat.com>
In-Reply-To: <cover.1269272444.git.jbaron@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com>
Subject: [PATCH 5/5] jump label: add module support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for 'jump label' for modules.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/ptrace.c   |    1 +
 include/linux/jump_label.h |    3 +-
 include/linux/module.h     |    5 +-
 kernel/jump_label.c        |  136 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/module.c            |    7 ++
 5 files changed, 150 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 2d96aab..21854d2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3d42e8c..fa81c0a 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -21,7 +21,8 @@ extern struct jump_entry __stop___jump_table[];
 
 #define DEFINE_JUMP_LABEL(name)						\
 	const char __jlstrtab_##name[]					\
-	__used __attribute__((section("__jump_strings")))  = #name;
+	__used __attribute__((section("__jump_strings")))  = #name;	\
+	EXPORT_SYMBOL_GPL(__jlstrtab_##name);
 
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
diff --git a/include/linux/module.h b/include/linux/module.h
index dd618eb..6d7225e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -339,7 +339,10 @@ struct module
 	struct tracepoint *tracepoints;
 	unsigned int num_tracepoints;
 #endif
-
+#ifdef __HAVE_ARCH_JUMP_LABEL
+	struct jump_entry *jump_entries;
+	unsigned int num_jump_entries;
+#endif
 #ifdef CONFIG_TRACING
 	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 671fcbb..d7a085d 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -30,6 +30,13 @@ struct jump_label_entry {
 	char name[0];
 };
 
+struct jump_label_module_entry {
+	struct hlist_node hlist;
+	struct jump_entry *table;
+	int nr_entries;
+	struct module *mod;
+};
+
 static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
 {
 	struct jump_entry tmp;
@@ -145,6 +152,17 @@ int jump_label_update(const char *name, enum jump_label_type type)
 				arch_jump_label_transform(iter, type);
 			iter++;
 		}
+		/* eanble/disable jump labels in modules */
+		hlist_for_each_entry(e_module, module_node, &(entry->modules),
+							hlist) {
+			count = e_module->nr_entries;
+			iter = e_module->table;
+			while (count--) {
+				if (kernel_text_address(iter->code))
+					arch_jump_label_transform(iter, type);
+				iter++;
+			}
+		}
 	}
 	mutex_unlock(&jump_label_mutex);
 	return 0;
@@ -162,4 +180,122 @@ static int init_jump_label(void)
 }
 early_initcall(init_jump_label);
 
+#ifdef CONFIG_MODULES
+
+static struct jump_label_module_entry *add_jump_label_module_entry(struct jump_label_entry *entry, struct jump_entry *iter_begin, int count, struct module *mod)
+{
+	struct jump_label_module_entry *e;
+
+	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+	e->mod = mod;
+	e->nr_entries = count;
+	e->table = iter_begin;
+	hlist_add_head(&e->hlist, &entry->modules);
+	return e;
+}
+
+static int add_jump_label_module(struct module *mod)
+{
+	struct jump_entry *iter, *iter_begin;
+	struct jump_label_entry *entry;
+	struct jump_label_module_entry *module_entry;
+	int count;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (!mod->num_jump_entries)
+		return 0;
+
+	sort_jump_label_entries(mod->jump_entries,
+				mod->jump_entries + mod->num_jump_entries);
+	iter = mod->jump_entries;
+	while (iter < mod->jump_entries + mod->num_jump_entries) {
+		entry = get_jump_label_entry(iter->name);
+		iter_begin = iter;
+		count = 0;
+		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
+			(strcmp(iter->name, iter_begin->name) == 0)) {
+				iter++;
+				count++;
+		}
+		if (!entry) {
+			entry = add_jump_label_entry(iter_begin->name, 0, NULL);
+			if (IS_ERR(entry))
+				return PTR_ERR(entry);
+		}
+		module_entry = add_jump_label_module_entry(entry, iter_begin,
+							   count, mod);
+		if (IS_ERR(module_entry))
+			return PTR_ERR(module_entry);
+	}
+	return 0;
+}
+
+static void remove_jump_label_module(struct module *mod)
+{
+	struct hlist_head *head;
+	struct hlist_node *node, *node_next, *module_node, *module_node_next;
+	struct jump_label_entry *e;
+	struct jump_label_module_entry *e_module;
+	int i;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (!mod->num_jump_entries)
+		return;
+
+	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
+		head = &jump_label_table[i];
+		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
+			hlist_for_each_entry_safe(e_module, module_node,
+						  module_node_next,
+						  &(e->modules), hlist) {
+				if (e_module->mod == mod) {
+					hlist_del(&e_module->hlist);
+					kfree(e_module);
+				}
+			}
+			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
+				hlist_del(&e->hlist);
+				kfree(e);
+			}
+		}
+	}
+}
+
+static int jump_label_module_notify(struct notifier_block *self, unsigned long val, void *data)
+{
+	struct module *mod = data;
+	int ret = 0;
+
+	switch (val) {
+	case MODULE_STATE_COMING:
+		mutex_lock(&jump_label_mutex);
+		ret = add_jump_label_module(mod);
+		if (ret)
+			remove_jump_label_module(mod);
+		mutex_unlock(&jump_label_mutex);
+		break;
+	case MODULE_STATE_GOING:
+		mutex_lock(&jump_label_mutex);
+		remove_jump_label_module(mod);
+		mutex_unlock(&jump_label_mutex);
+		break;
+	}
+	return ret;
+}
+
+struct notifier_block jump_label_module_nb = {
+	.notifier_call = jump_label_module_notify,
+	.priority = 0,
+};
+
+static int init_jump_label_module(void)
+{
+	return register_module_notifier(&jump_label_module_nb);
+}
+early_initcall(init_jump_label_module);
+
+#endif /* CONFIG_MODULES */
+
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index c968d36..a8c34a2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/jump_label.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2249,6 +2250,12 @@ static noinline struct module *load_module(void __user *umod,
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef __HAVE_ARCH_JUMP_LABEL
+	mod->jump_entries = section_objs(hdr, sechdrs, secstrings,
+					"__jump_table",
+					sizeof(*mod->jump_entries),
+					&mod->num_jump_entries);
+#endif
 #ifdef CONFIG_EVENT_TRACING
 	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
 					 "_ftrace_events",
-- 
1.6.5.1

