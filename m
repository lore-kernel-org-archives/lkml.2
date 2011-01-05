Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1AEPnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:43:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1AEPnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:43:50 -0500
Date: Wed, 5 Jan 2011 10:43:08 -0500
From: Jason Baron <jbaron@redhat.com>
To: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu
Cc: tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Message-Id: <94bc7e748f6de41466c742b18cf4e09a34f82d69.1294239591.git.jbaron@redhat.com>
In-Reply-To: <cover.1294239591.git.jbaron@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com>
Subject: [PATCH 1/2] jump label: make enable/disable o(1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, I allowed any variable type to be used as the 'key' for
the jump label. However, by enforcing a type, we can make use of the
contents of the 'key'. This patch thus introduces:

struct jump_label_key {
       void *ptr;
};

The 'ptr' is used a pointer into the jump label table of the
corresponding addresses that need to be updated. Thus, when jump labels
are enabled/disabled we have a constant time algorithm. There is no
longer any hashing.

When jump lables are disabled we simply have:

struct jump_label_key {
        int state;
};

I tested enable/disable times on x86 on a quad core via:

 time echo 1 > /sys/kernel/debug/tracing/events/enable

With this patch, runs average .03s. Prior to the jump label infrastructure
this command averaged around .01s.

We can speed this path up further via batching the enable/disables.

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h  |    6 +-
 include/linux/jump_label.h     |   46 +++++++++-----
 include/linux/jump_label_ref.h |   34 +++--------
 include/linux/perf_event.h     |    8 ++-
 include/linux/tracepoint.h     |    6 +-
 kernel/jump_label.c            |  127 +++++++++++++++++++++++++++++++---------
 kernel/perf_event.c            |   24 +++++---
 kernel/tracepoint.c            |   22 +++-----
 8 files changed, 172 insertions(+), 101 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a90b389..ddf7bae 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -33,7 +33,7 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
-	char enabled;
+	struct jump_label_key enabled;
 } __attribute__((aligned(8)));
 
 
@@ -50,7 +50,7 @@ extern int ddebug_remove_module(const char *mod_name);
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
+		_DPRINTK_FLAGS_DEFAULT, JUMP_LABEL_INIT };		\
 	JUMP_LABEL(&descriptor.enabled, do_printk);			\
 	goto out;							\
 do_printk:								\
@@ -66,7 +66,7 @@ out:	;								\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
+		_DPRINTK_FLAGS_DEFAULT, JUMP_LABEL_INIT };		\
 	JUMP_LABEL(&descriptor.enabled, do_printk);			\
 	goto out;							\
 do_printk:								\
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 7880f18..152f7de 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -2,6 +2,11 @@
 #define _LINUX_JUMP_LABEL_H
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+
+struct jump_label_key {
+	void *ptr;
+};
+
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
@@ -13,6 +18,8 @@ enum jump_label_type {
 
 struct module;
 
+#define JUMP_LABEL_INIT { 0 }
+
 #ifdef HAVE_JUMP_LABEL
 
 extern struct jump_entry __start___jump_table[];
@@ -23,33 +30,38 @@ extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
-extern void jump_label_update(unsigned long key, enum jump_label_type type);
 extern void jump_label_apply_nops(struct module *mod);
 extern int jump_label_text_reserved(void *start, void *end);
-
-#define jump_label_enable(key) \
-	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
-
-#define jump_label_disable(key) \
-	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
+extern int jump_label_enabled(struct jump_label_key *key);
+extern void jump_label_enable(struct jump_label_key *key);
+extern void jump_label_disable(struct jump_label_key *key);
 
 #else
 
+struct jump_label_key {
+	int state;
+};
+
 #define JUMP_LABEL(key, label)			\
 do {						\
-	if (unlikely(*key))			\
+	if (unlikely(((struct jump_label_key *)key)->state))		\
 		goto label;			\
 } while (0)
 
-#define jump_label_enable(cond_var)	\
-do {					\
-       *(cond_var) = 1;			\
-} while (0)
+static inline int jump_label_enabled(struct jump_label_key *key)
+{
+	return key->state;
+}
 
-#define jump_label_disable(cond_var)	\
-do {					\
-       *(cond_var) = 0;			\
-} while (0)
+static inline void jump_label_enable(struct jump_label_key *key)
+{
+	key->state = 1;
+}
+
+static inline void jump_label_disable(struct jump_label_key *key)
+{
+	key->state = 0;
+}
 
 static inline int jump_label_apply_nops(struct module *mod)
 {
@@ -69,7 +81,7 @@ static inline void jump_label_unlock(void) {}
 #define COND_STMT(key, stmt)					\
 do {								\
 	__label__ jl_enabled;					\
-	JUMP_LABEL(key, jl_enabled);				\
+	JUMP_LABEL_ELSE_ATOMIC_READ(key, jl_enabled);		\
 	if (0) {						\
 jl_enabled:							\
 		stmt;						\
diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
index e5d012a..8a76e89 100644
--- a/include/linux/jump_label_ref.h
+++ b/include/linux/jump_label_ref.h
@@ -4,38 +4,20 @@
 #include <linux/jump_label.h>
 #include <asm/atomic.h>
 
-#ifdef HAVE_JUMP_LABEL
-
-static inline void jump_label_inc(atomic_t *key)
-{
-	if (atomic_add_return(1, key) == 1)
-		jump_label_enable(key);
+struct jump_label_key_counter {
+	atomic_t ref;
+	struct jump_label_key key;
 }
 
-static inline void jump_label_dec(atomic_t *key)
-{
-	if (atomic_dec_and_test(key))
-		jump_label_disable(key);
-}
-
-#else /* !HAVE_JUMP_LABEL */
+#ifdef HAVE_JUMP_LABEL
 
-static inline void jump_label_inc(atomic_t *key)
-{
-	atomic_inc(key);
-}
+#define JUMP_LABEL_ELSE_ATOMIC_READ(key, label, counter) JUMP_LABEL(key, label)
 
-static inline void jump_label_dec(atomic_t *key)
-{
-	atomic_dec(key);
-}
+#else /* !HAVE_JUMP_LABEL */
 
-#undef JUMP_LABEL
-#define JUMP_LABEL(key, label)						\
+#define JUMP_LABEL_ELSE_ATOMIC_READ(key, label, counter)		\
 do {									\
-	if (unlikely(__builtin_choose_expr(				\
-	      __builtin_types_compatible_p(typeof(key), atomic_t *),	\
-	      atomic_read((atomic_t *)(key)), *(key))))			\
+	if (unlikely(atomic_read((atomic_t *)counter)))			\
 		goto label;						\
 } while (0)
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dda5b0a..94834ce 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1000,7 +1000,7 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
-extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern struct jump_label_key_counter perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
@@ -1029,7 +1029,9 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
+	JUMP_LABEL_ELSE_ATOMIC_READ(&perf_swevent_enabled[event_id].key,
+				    have_event,
+				    &perf_swevent_enabled[event_id].ref);
 	return;
 
 have_event:
@@ -1040,7 +1042,7 @@ have_event:
 	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern atomic_t perf_task_events;
+extern struct jump_label_key_counter perf_task_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d3e4f87..2ff00e5 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -29,7 +29,7 @@ struct tracepoint_func {
 
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
-	int state;			/* State. */
+	struct jump_label_key key;
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func *funcs;
@@ -149,7 +149,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
+		JUMP_LABEL(&__tracepoint_##name.key, do_trace);		\
 		return;							\
 do_trace:								\
 			__DO_TRACE(&__tracepoint_##name,		\
@@ -179,7 +179,7 @@ do_trace:								\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL }
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3b79bd9..b6d461c 100644
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
+	u32 nr_entries;
+	int refcount;
 };
 
 struct jump_label_module_entry {
@@ -105,11 +106,14 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 
 	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
 	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	e->key = key;
+	e->key = (unsigned long)key;
 	e->table = table;
 	e->nr_entries = nr_entries;
+	e->refcount = 0;
 	INIT_HLIST_HEAD(&(e->modules));
 	hlist_add_head(&e->hlist, head);
+	((struct jump_label_key *)(unsigned long)key)->ptr = e;
+
 	return e;
 }
 
@@ -154,37 +158,91 @@ build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
  *
  */
 
-void jump_label_update(unsigned long key, enum jump_label_type type)
+static void jump_label_update(struct jump_label_entry *entry, enum jump_label_type type)
 {
 	struct jump_entry *iter;
-	struct jump_label_entry *entry;
 	struct hlist_node *module_node;
 	struct jump_label_module_entry *e_module;
 	int count;
 
-	jump_label_lock();
-	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
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
+}
+
+static struct jump_label_entry *get_jump_label_entry_key(struct jump_label_key *key)
+{
+	struct jump_label_entry *entry;
+
+	entry = (struct jump_label_entry *)key->ptr;
+	if (!entry) {
+		entry = add_jump_label_entry((jump_label_t)(unsigned long)key, 0, NULL);
+		if (IS_ERR(entry))
+			return NULL;
+	}
+	return entry;
+}
+
+int jump_label_enabled(struct jump_label_key *key)
+{
+	struct jump_label_entry *entry;
+	int enabled = 0;
+
+	jump_label_lock();
+	entry = get_jump_label_entry_key(key);
+	if (!entry)
+		goto out;
+	enabled = !!entry->refcount;
+out:
+	jump_label_unlock();
+	return enabled;
+}
+
+
+void jump_label_enable(struct jump_label_key *key)
+{
+	struct jump_label_entry *entry;
+
+	jump_label_lock();
+	entry = get_jump_label_entry_key(key);
+	if (!entry)
+		goto out;
+	if (!entry->refcount) {
+		jump_label_update(entry, JUMP_LABEL_ENABLE);
+		entry->refcount = 1;
+	}
+out:
+	jump_label_unlock();
+}
+
+void jump_label_disable(struct jump_label_key *key)
+{
+	struct jump_label_entry *entry;
+
+	jump_label_lock();
+	entry = get_jump_label_entry_key(key);
+	if (!entry)
+		goto out;
+	if (entry->refcount) {
+		jump_label_update(entry, JUMP_LABEL_DISABLE);
+		entry->refcount = 0;
+	}
+out:
 	jump_label_unlock();
 }
 
@@ -305,6 +363,7 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
 			    int count, struct module *mod)
 {
 	struct jump_label_module_entry *e;
+	struct jump_entry *iter;
 
 	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
 	if (!e)
@@ -313,6 +372,13 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
 	e->nr_entries = count;
 	e->table = iter_begin;
 	hlist_add_head(&e->hlist, &entry->modules);
+	if (entry->refcount) {
+		iter = iter_begin;
+		while (count--) {
+			arch_jump_label_transform(iter, JUMP_LABEL_ENABLE);
+			iter++;
+		}
+	}
 	return e;
 }
 
@@ -360,10 +426,6 @@ static void remove_jump_label_module(struct module *mod)
 	struct jump_label_module_entry *e_module;
 	int i;
 
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
 	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
 		head = &jump_label_table[i];
 		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
@@ -375,10 +437,21 @@ static void remove_jump_label_module(struct module *mod)
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
@@ -470,7 +543,7 @@ void jump_label_apply_nops(struct module *mod)
 
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
-	.priority = 0,
+	.priority = 1, /* higher than tracepoints */
 };
 
 static __init int init_jump_label_module(void)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 11847bf..f96d615 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -38,7 +38,7 @@
 
 #include <asm/irq_regs.h>
 
-atomic_t perf_task_events __read_mostly;
+struct jump_label_key_counter perf_task_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -2292,8 +2292,10 @@ static void free_event(struct perf_event *event)
 	irq_work_sync(&event->pending);
 
 	if (!event->parent) {
-		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_task_events);
+		if (event->attach_state & PERF_ATTACH_TASK) {
+			if (atomic_dec_and_test(&perf_task_events.ref))
+				jump_label_disable(&perf_task_events.key);
+		}
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -4821,7 +4823,7 @@ fail:
 	return err;
 }
 
-atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+struct jump_label_key_counter perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_event_destroy(struct perf_event *event)
 {
@@ -4829,7 +4831,8 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 	WARN_ON(event->parent);
 
-	jump_label_dec(&perf_swevent_enabled[event_id]);
+	if (atomic_dec_and_test(&perf_swevent_enabled[event_id].ref))
+		jump_label_disable(&perf_swevent_enabled[event_id].key);
 	swevent_hlist_put(event);
 }
 
@@ -4854,12 +4857,15 @@ static int perf_swevent_init(struct perf_event *event)
 
 	if (!event->parent) {
 		int err;
+		atomic_t *ref;
 
 		err = swevent_hlist_get(event);
 		if (err)
 			return err;
 
-		jump_label_inc(&perf_swevent_enabled[event_id]);
+		ref = &perf_swevent_enabled[event_id].ref;
+		if (atomic_add_return(1, ref) == 1)
+			jump_label_enable(&perf_swevent_enabled[event_id].key);
 		event->destroy = sw_perf_event_destroy;
 	}
 
@@ -5614,8 +5620,10 @@ done:
 	event->pmu = pmu;
 
 	if (!event->parent) {
-		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_task_events);
+		if (event->attach_state & PERF_ATTACH_TASK) {
+			if (atomic_add_return(1, &perf_task_events.ref) == 1)
+				jump_label_enable(&perf_task_events.key);
+		}
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index e95ee7f..d54b434 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -251,9 +251,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !elem->state && active)
+	if (elem->regfunc && !jump_label_enabled(&elem->key) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && elem->state && !active)
+	else if (elem->unregfunc && jump_label_enabled(&elem->key) && !active)
 		elem->unregfunc();
 
 	/*
@@ -264,13 +264,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (!elem->state && active) {
-		jump_label_enable(&elem->state);
-		elem->state = active;
-	} else if (elem->state && !active) {
-		jump_label_disable(&elem->state);
-		elem->state = active;
-	}
+	if (active)
+		jump_label_enable(&elem->key);
+	else if (!active)
+		jump_label_disable(&elem->key);
 }
 
 /*
@@ -281,13 +278,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && elem->state)
+	if (elem->unregfunc && jump_label_enabled(&elem->key))
 		elem->unregfunc();
 
-	if (elem->state) {
-		jump_label_disable(&elem->state);
-		elem->state = 0;
-	}
+	jump_label_disable(&elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
-- 
1.7.1

