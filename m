Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0IQPJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0IQPJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:40 -0400
Date: Fri, 17 Sep 2010 11:09:00 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 03/10] jump label v11: base patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
assembly gcc mechanism, we can now branch to labels from an 'asm goto'
statment. This allows us to create a 'no-op' fastpath, which can subsequently
be patched with a jump to the slowpath code. This is useful for code which
might be rarely used, but which we'd like to be able to call, if needed.
Tracepoints are the current usecase that these are being implemented for.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 Makefile                           |    5 +
 arch/Kconfig                       |    3 +
 arch/x86/include/asm/alternative.h |    3 +-
 arch/x86/kernel/alternative.c      |    2 +-
 include/asm-generic/vmlinux.lds.h  |   10 +
 include/linux/jump_label.h         |   58 ++++++
 include/linux/module.h             |    5 +-
 kernel/Makefile                    |    2 +-
 kernel/jump_label.c                |  338 ++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                   |    1 +
 kernel/module.c                    |    6 +
 scripts/gcc-goto.sh                |    5 +
 12 files changed, 434 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c
 create mode 100644 scripts/gcc-goto.sh

diff --git a/Makefile b/Makefile
index 92ab33f..a906378 100644
--- a/Makefile
+++ b/Makefile
@@ -591,6 +591,11 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 
+# check for 'asm goto'
+ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
+	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
+endif
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
diff --git a/arch/Kconfig b/arch/Kconfig
index 4877a8c..1462d84 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -158,4 +158,7 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
+config HAVE_ARCH_JUMP_LABEL
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 634bf78..76561d2 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/stringify.h>
+#include <linux/jump_label.h>
 #include <asm/asm.h>
 
 /*
@@ -182,7 +183,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 
-#if defined(CONFIG_DYNAMIC_FTRACE)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 #define IDEAL_NOP_SIZE_5 5
 extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
 extern void arch_init_ideal_nop5(void);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 083bd01..cb0e6d3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -641,7 +641,7 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	return addr;
 }
 
-#if defined(CONFIG_DYNAMIC_FTRACE)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 
 unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8a92a17..ef2af99 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -220,6 +220,8 @@
 									\
 	BUG_TABLE							\
 									\
+	JUMP_TABLE							\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -563,6 +565,14 @@
 #define BUG_TABLE
 #endif
 
+#define JUMP_TABLE							\
+	. = ALIGN(8);							\
+	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___jump_table) = .;		\
+		*(__jump_table)						\
+		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
+	}
+
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
new file mode 100644
index 0000000..de58656
--- /dev/null
+++ b/include/linux/jump_label.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_JUMP_LABEL_H
+#define _LINUX_JUMP_LABEL_H
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
+# include <asm/jump_label.h>
+# define HAVE_JUMP_LABEL
+#endif
+
+enum jump_label_type {
+	JUMP_LABEL_ENABLE,
+	JUMP_LABEL_DISABLE
+};
+
+struct module;
+
+#ifdef HAVE_JUMP_LABEL
+
+extern struct jump_entry __start___jump_table[];
+extern struct jump_entry __stop___jump_table[];
+
+extern void arch_jump_label_transform(struct jump_entry *entry,
+				 enum jump_label_type type);
+extern void jump_label_update(unsigned long key, enum jump_label_type type);
+extern void jump_label_apply_nops(struct module *mod);
+extern void arch_jump_label_text_poke_early(jump_label_t addr);
+
+#define enable_jump_label(key) \
+	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
+
+#define disable_jump_label(key) \
+	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
+
+#else
+
+#define JUMP_LABEL(key, label)			\
+do {						\
+	if (unlikely(*key))			\
+		goto label;			\
+} while (0)
+
+#define enable_jump_label(cond_var)	\
+do {					\
+       *(cond_var) = 1;			\
+} while (0)
+
+#define disable_jump_label(cond_var)	\
+do {					\
+       *(cond_var) = 0;			\
+} while (0)
+
+static inline int jump_label_apply_nops(struct module *mod)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff --git a/include/linux/module.h b/include/linux/module.h
index 8a6b9fd..403ac26 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -350,7 +350,10 @@ struct module
 	struct tracepoint *tracepoints;
 	unsigned int num_tracepoints;
 #endif
-
+#ifdef HAVE_JUMP_LABEL
+	struct jump_entry *jump_entries;
+	unsigned int num_jump_entries;
+#endif
 #ifdef CONFIG_TRACING
 	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
diff --git a/kernel/Makefile b/kernel/Makefile
index 92b7420..8a0feb7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o
+	    async.o range.o jump_label.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
new file mode 100644
index 0000000..07656ec
--- /dev/null
+++ b/kernel/jump_label.c
@@ -0,0 +1,338 @@
+/*
+ * jump label support
+ *
+ * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
+ *
+ */
+#include <linux/jump_label.h>
+#include <linux/memory.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/err.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+#define JUMP_LABEL_HASH_BITS 6
+#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
+static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
+
+/* mutex to protect coming/going of the the jump_label table */
+static DEFINE_MUTEX(jump_label_mutex);
+
+struct jump_label_entry {
+	struct hlist_node hlist;
+	struct jump_entry *table;
+	int nr_entries;
+	/* hang modules off here */
+	struct hlist_head modules;
+	unsigned long key;
+};
+
+struct jump_label_module_entry {
+	struct hlist_node hlist;
+	struct jump_entry *table;
+	int nr_entries;
+	struct module *mod;
+};
+
+static int jump_label_cmp(const void *a, const void *b)
+{
+	const struct jump_entry *jea = a;
+	const struct jump_entry *jeb = b;
+
+	if (jea->key < jeb->key)
+		return -1;
+
+	if (jea->key > jeb->key)
+		return 1;
+
+	return 0;
+}
+
+static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
+{
+	unsigned long size;
+
+	size = (((unsigned long)stop - (unsigned long)start)
+					/ sizeof(struct jump_entry));
+	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
+}
+
+static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct jump_label_entry *e;
+	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
+
+	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (key == e->key)
+			return e;
+	}
+	return NULL;
+}
+
+static struct jump_label_entry *add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
+{
+	struct hlist_head *head;
+	struct jump_label_entry *e;
+	u32 hash;
+
+	e = get_jump_label_entry(key);
+	if (e)
+		return ERR_PTR(-EEXIST);
+
+	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+
+	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
+	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
+	e->key = key;
+	e->table = table;
+	e->nr_entries = nr_entries;
+	INIT_HLIST_HEAD(&(e->modules));
+	hlist_add_head(&e->hlist, head);
+	return e;
+}
+
+static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
+{
+	struct jump_entry *iter, *iter_begin;
+	struct jump_label_entry *entry;
+	int count;
+
+	sort_jump_label_entries(start, stop);
+	iter = start;
+	while (iter < stop) {
+		entry = get_jump_label_entry(iter->key);
+		if (!entry) {
+			iter_begin = iter;
+			count = 0;
+			while ((iter < stop) &&
+				(iter->key == iter_begin->key)) {
+				iter++;
+				count++;
+			}
+			entry = add_jump_label_entry(iter_begin->key,
+							count, iter_begin);
+			if (IS_ERR(entry))
+				return PTR_ERR(entry);
+		 } else {
+			WARN_ONCE(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/***
+ * jump_label_update - update jump label text
+ * @key -  key value associated with a a jump label
+ * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
+ *
+ * Will enable/disable the jump for jump label @key, depending on the
+ * value of @type.
+ *
+ */
+
+void jump_label_update(unsigned long key, enum jump_label_type type)
+{
+	struct jump_entry *iter;
+	struct jump_label_entry *entry;
+	struct hlist_node *module_node;
+	struct jump_label_module_entry *e_module;
+	int count;
+
+	mutex_lock(&jump_label_mutex);
+	entry = get_jump_label_entry((jump_label_t)key);
+	if (entry) {
+		count = entry->nr_entries;
+		iter = entry->table;
+		while (count--) {
+			if (kernel_text_address(iter->code))
+				arch_jump_label_transform(iter, type);
+			iter++;
+		}
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
+	}
+	mutex_unlock(&jump_label_mutex);
+}
+
+static __init int init_jump_label(void)
+{
+	int ret;
+	struct jump_entry *iter_start = __start___jump_table;
+	struct jump_entry *iter_stop = __stop___jump_table;
+	struct jump_entry *iter;
+
+	mutex_lock(&jump_label_mutex);
+	ret = build_jump_label_hashtable(__start___jump_table,
+					 __stop___jump_table);
+	iter = iter_start;
+	while (iter < iter_stop) {
+		arch_jump_label_text_poke_early(iter->code);
+		iter++;
+	}
+	mutex_unlock(&jump_label_mutex);
+	return ret;
+}
+early_initcall(init_jump_label);
+
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
+		entry = get_jump_label_entry(iter->key);
+		iter_begin = iter;
+		count = 0;
+		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
+			(iter->key == iter_begin->key)) {
+				iter++;
+				count++;
+		}
+		if (!entry) {
+			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
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
+/***
+ * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
+ * @mod: module to patch
+ *
+ * Allow for run-time selection of the optimal nops. Before the module
+ * loads patch these with arch_get_jump_label_nop(), which is specified by
+ * the arch specific jump label code.
+ */
+void jump_label_apply_nops(struct module *mod)
+{
+	struct jump_entry *iter;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (!mod->num_jump_entries)
+		return;
+
+	iter = mod->jump_entries;
+	while (iter < mod->jump_entries + mod->num_jump_entries) {
+		arch_jump_label_text_poke_early(iter->code);
+		iter++;
+	}
+}
+
+struct notifier_block jump_label_module_nb = {
+	.notifier_call = jump_label_module_notify,
+	.priority = 0,
+};
+
+static __init int init_jump_label_module(void)
+{
+	return register_module_notifier(&jump_label_module_nb);
+}
+early_initcall(init_jump_label_module);
+
+#endif /* CONFIG_MODULES */
+
+#endif
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..798adfa 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -47,6 +47,7 @@
 #include <linux/memory.h>
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
+#include <linux/jump_label.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
diff --git a/kernel/module.c b/kernel/module.c
index d0b5f8d..eba1341 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/jump_label.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2308,6 +2309,11 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef HAVE_JUMP_LABEL
+	mod->jump_entries = section_objs(info, "__jump_table",
+					sizeof(*mod->jump_entries),
+					&mod->num_jump_entries);
+#endif
 #ifdef CONFIG_EVENT_TRACING
 	mod->trace_events = section_objs(info, "_ftrace_events",
 					 sizeof(*mod->trace_events),
diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
new file mode 100644
index 0000000..8e82424
--- /dev/null
+++ b/scripts/gcc-goto.sh
@@ -0,0 +1,5 @@
+#!/bin/sh
+# Test for gcc 'asm goto' suport
+# Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
+
+echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $1 -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
-- 
1.7.1

