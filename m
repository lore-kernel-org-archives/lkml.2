Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab0DPPYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006Ab0DPPYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:24:42 -0400
Date: Fri, 16 Apr 2010 11:24:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com
Message-Id: <f47789fa5cd9c60fef9ac902391b948a80e94115.1271427118.git.jbaron@redhat.com>
In-Reply-To: <cover.1271427118.git.jbaron@redhat.com>
References: <cover.1271427118.git.jbaron@redhat.com>
Subject: [PATCH 02/11] jump label: base patch
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
 arch/Kconfig                      |    3 +
 include/asm-generic/vmlinux.lds.h |   10 ++-
 include/linux/jump_label.h        |   59 ++++++++++++
 kernel/Makefile                   |    2 +-
 kernel/jump_label.c               |  179 +++++++++++++++++++++++++++++++++++++
 5 files changed, 251 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c

diff --git a/arch/Kconfig b/arch/Kconfig
index f06010f..4e7a1ec 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -140,4 +140,7 @@ config HAVE_HW_BREAKPOINT
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
+config HAVE_ARCH_JUMP_LABEL
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 67e6520..83a469d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -167,7 +167,8 @@
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
 	FTRACE_EVENTS()							\
-	TRACE_SYSCALLS()
+	TRACE_SYSCALLS()						\
+	JUMP_TABLE()							\
 
 /*
  * Data section helpers
@@ -206,6 +207,7 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		*(__jump_strings)/* Jump: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
@@ -557,6 +559,12 @@
 #define BUG_TABLE
 #endif
 
+#define JUMP_TABLE()							\
+	. = ALIGN(64);							\
+		VMLINUX_SYMBOL(__start___jump_table) = .;		\
+		*(__jump_table)						\
+		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
+
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
new file mode 100644
index 0000000..914ff7c
--- /dev/null
+++ b/include/linux/jump_label.h
@@ -0,0 +1,59 @@
+#ifndef _LINUX_JUMP_LABEL_H
+#define _LINUX_JUMP_LABEL_H
+
+#if (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5))
+# ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
+#  include <asm/jump_label.h>
+#  define HAVE_JUMP_LABEL 1
+# endif
+#endif
+
+enum jump_label_type {
+	JUMP_LABEL_ENABLE,
+	JUMP_LABEL_DISABLE
+};
+
+#ifdef HAVE_JUMP_LABEL
+
+extern struct jump_entry __start___jump_table[];
+extern struct jump_entry __stop___jump_table[];
+
+#define DEFINE_JUMP_LABEL(name)						\
+	const char __jlstrtab_##name[]					\
+	__used __attribute__((section("__jump_strings")))  = #name;
+
+extern void arch_jump_label_transform(struct jump_entry *entry,
+				 enum jump_label_type type);
+extern const u8 *arch_get_jump_label_nop(void);
+
+extern void jump_label_update(const char *name, enum jump_label_type type);
+
+#define enable_jump_label(name) \
+	jump_label_update(name, JUMP_LABEL_ENABLE);
+
+#define disable_jump_label(name) \
+	jump_label_update(name, JUMP_LABEL_DISABLE);
+
+#else
+
+#define DEFINE_JUMP_LABEL(name)
+
+#define JUMP_LABEL(tag, label, cond)		\
+do {						\
+	if (unlikely(cond))			\
+		goto label;			\
+} while (0)
+
+static inline int enable_jump_label(const char *name)
+{
+	return 0;
+}
+
+static inline int disable_jump_label(const char *name)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index d5c3006..59ff12e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o
+	    async.o range.o jump_label.o
 obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
 obj-y += groups.o
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
new file mode 100644
index 0000000..f518922
--- /dev/null
+++ b/kernel/jump_label.c
@@ -0,0 +1,179 @@
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
+#include <asm/alternative.h>
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
+	const char *name;
+};
+
+static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
+{
+	struct jump_entry tmp;
+
+	tmp = *next;
+	*next = *previous;
+	*previous = tmp;
+}
+
+static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
+{
+	int swapped = 0;
+	struct jump_entry *iter;
+	struct jump_entry *iter_next;
+
+	do {
+		swapped = 0;
+		iter = start;
+		iter_next = start;
+		iter_next++;
+		for (; iter_next < stop; iter++, iter_next++) {
+			if (strcmp((char *)iter->name,
+						(char *)iter_next->name) > 0) {
+				swap_jump_label_entries(iter, iter_next);
+				swapped = 1;
+			}
+		}
+	} while (swapped == 1);
+}
+
+static struct jump_label_entry *get_jump_label_entry(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct jump_label_entry *e;
+	u32 hash = jhash(name, strlen(name), 0);
+
+	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp((char *)name, (char *)e->name))
+			return e;
+	}
+	return NULL;
+}
+
+static struct jump_label_entry *add_jump_label_entry(const char *name, int nr_entries, struct jump_entry *table)
+{
+	struct hlist_head *head;
+	struct jump_label_entry *e;
+	size_t name_len;
+	u32 hash;
+
+	e = get_jump_label_entry(name);
+	if (e)
+		return ERR_PTR(-EEXIST);
+
+	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+
+	name_len = strlen(name) + 1;
+	hash = jhash(name, name_len-1, 0);
+	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
+	e->name = name;
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
+		entry = get_jump_label_entry((char *)iter->name);
+		if (!entry) {
+			iter_begin = iter;
+			count = 0;
+			while ((iter < stop) &&
+				(strcmp((char *)iter->name,
+					(char *)iter_begin->name) == 0)) {
+				iter++;
+				count++;
+			}
+			entry = add_jump_label_entry((char *)iter_begin->name,
+							count, iter_begin);
+			if (IS_ERR(entry))
+				return PTR_ERR(entry);
+			continue;
+		}
+		WARN(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
+	}
+	return 0;
+}
+
+/***
+ * jump_label_update - update jump label text
+ * @name - name of the jump label
+ * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
+ *
+ * Will enable/disable the jump for jump label @name, depending on the
+ * value of @type.
+ *
+ */
+
+void jump_label_update(const char *name, enum jump_label_type type)
+{
+	struct jump_entry *iter;
+	struct jump_label_entry *entry;
+	struct hlist_node *module_node;
+	struct jump_label_module_entry *e_module;
+	int count;
+
+	mutex_lock(&jump_label_mutex);
+	entry = get_jump_label_entry(name);
+	if (entry) {
+		count = entry->nr_entries;
+		iter = entry->table;
+		while (count--) {
+			if (kernel_text_address(iter->code))
+				arch_jump_label_transform(iter, type);
+			iter++;
+		}
+	}
+	mutex_unlock(&jump_label_mutex);
+}
+
+static int init_jump_label(void)
+{
+	int ret;
+
+	mutex_lock(&jump_label_mutex);
+	ret = build_jump_label_hashtable(__start___jump_table,
+					 __stop___jump_table);
+	mutex_unlock(&jump_label_mutex);
+	return ret;
+}
+early_initcall(init_jump_label);
+
+#endif
-- 
1.7.0.1

