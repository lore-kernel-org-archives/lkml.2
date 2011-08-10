Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1HJTSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:18:42 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50954 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754730Ab1HJTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:18:41 -0400
Date: Wed, 10 Aug 2011 15:18:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH][3.0] Tracepoint: dissociate from module mutex (v2)
Message-ID: <20110810191839.GC8525@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:17:29 up 260 days, 20 min,  4 users,  load average: 0.03,
	0.02, 0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the information needed from struct module into a local module list
held within tracepoint.c from within the module coming/going notifier.

This vastly simplifies locking of tracepoint registration /
unregistration, because we don't have to take the module mutex to
register and unregister tracepoints anymore. Steven Rostedt ran into
dependency problems related to modules mutex vs kprobes mutex vs ftrace
mutex vs tracepoint mutex that seems to be hard to fix without removing
this dependency between tracepoint and module mutex. (note: it should be
investigated whether kprobes could benefit of being dissociated from the
modules mutex too.)

This also fixes module handling of tracepoint list iterators, because it
was expecting the list to be sorted by pointer address. Given we have
control on our own list now, it's OK to sort this list which has
tracepoints as its only purpose. The reason why this sorting is required
is to handle the fact that seq files (and any read() operation from
user-space) cannot hold the tracepoint mutex across multiple calls, so
list entries may vanish between calls. With sorting, the tracepoint
iterator becomes usable even if the list don't contain the exact item
pointed to by the iterator anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: tglx@linutronix.de
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 include/linux/module.h     |   12 ---
 include/linux/tracepoint.h |   25 ++----
 kernel/module.c            |   47 ------------
 kernel/tracepoint.c        |  169 +++++++++++++++++++++++++++++++++++++++------
 4 files changed, 158 insertions(+), 95 deletions(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h
+++ linux-2.6-lttng/include/linux/tracepoint.h
@@ -54,8 +54,18 @@ extern int tracepoint_probe_unregister_n
 						void *data);
 extern void tracepoint_probe_update_all(void);
 
+#ifdef CONFIG_MODULES
+struct tp_module {
+	struct list_head list;
+	unsigned int num_tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
+};
+#endif /* CONFIG_MODULES */
+
 struct tracepoint_iter {
-	struct module *module;
+#ifdef CONFIG_MODULES
+	struct tp_module *module;
+#endif /* CONFIG_MODULES */
 	struct tracepoint * const *tracepoint;
 };
 
@@ -63,8 +73,6 @@ extern void tracepoint_iter_start(struct
 extern void tracepoint_iter_next(struct tracepoint_iter *iter);
 extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
 extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
-	struct tracepoint * const *begin, struct tracepoint * const *end);
 
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
@@ -78,17 +86,6 @@ static inline void tracepoint_synchroniz
 
 #define PARAMS(args...) args
 
-#ifdef CONFIG_TRACEPOINTS
-extern
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-	struct tracepoint * const *end);
-#else
-static inline
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-	struct tracepoint * const *end)
-{ }
-#endif /* CONFIG_TRACEPOINTS */
-
 #endif /* _LINUX_TRACEPOINT_H */
 
 /*
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c
+++ linux-2.6-lttng/kernel/module.c
@@ -3421,50 +3421,3 @@ void module_layout(struct module *mod,
 }
 EXPORT_SYMBOL(module_layout);
 #endif
-
-#ifdef CONFIG_TRACEPOINTS
-void module_update_tracepoints(void)
-{
-	struct module *mod;
-
-	mutex_lock(&module_mutex);
-	list_for_each_entry(mod, &modules, list)
-		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints_ptrs,
-				mod->tracepoints_ptrs + mod->num_tracepoints);
-	mutex_unlock(&module_mutex);
-}
-
-/*
- * Returns 0 if current not found.
- * Returns 1 if current found.
- */
-int module_get_iter_tracepoints(struct tracepoint_iter *iter)
-{
-	struct module *iter_mod;
-	int found = 0;
-
-	mutex_lock(&module_mutex);
-	list_for_each_entry(iter_mod, &modules, list) {
-		if (!iter_mod->taints) {
-			/*
-			 * Sorted module list
-			 */
-			if (iter_mod < iter->module)
-				continue;
-			else if (iter_mod > iter->module)
-				iter->tracepoint = NULL;
-			found = tracepoint_get_iter_range(&iter->tracepoint,
-				iter_mod->tracepoints_ptrs,
-				iter_mod->tracepoints_ptrs
-					+ iter_mod->num_tracepoints);
-			if (found) {
-				iter->module = iter_mod;
-				break;
-			}
-		}
-	}
-	mutex_unlock(&module_mutex);
-	return found;
-}
-#endif
Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c
+++ linux-2.6-lttng/kernel/tracepoint.c
@@ -34,11 +34,16 @@ extern struct tracepoint * const __stop_
 static const int tracepoint_debug;
 
 /*
- * tracepoints_mutex nests inside module_mutex. Tracepoints mutex protects the
- * builtin and module tracepoints and the hash table.
+ * Tracepoints mutex protects the builtin and module tracepoints and the hash
+ * table, as well as the local module list.
  */
 static DEFINE_MUTEX(tracepoints_mutex);
 
+#ifdef CONFIG_MODULES
+/* Local list of struct module */
+static LIST_HEAD(tracepoint_module_list);
+#endif /* CONFIG_MODULES */
+
 /*
  * Tracepoint hash table, containing the active tracepoints.
  * Protected by tracepoints_mutex.
@@ -292,9 +297,10 @@ static void disable_tracepoint(struct tr
  * @end: end of the range
  *
  * Updates the probe callback corresponding to a range of tracepoints.
+ * Called with tracepoints_mutex held.
  */
-void tracepoint_update_probe_range(struct tracepoint * const *begin,
-				   struct tracepoint * const *end)
+static void tracepoint_update_probe_range(struct tracepoint * const *begin,
+					  struct tracepoint * const *end)
 {
 	struct tracepoint * const *iter;
 	struct tracepoint_entry *mark_entry;
@@ -302,7 +308,6 @@ void tracepoint_update_probe_range(struc
 	if (!begin)
 		return;
 
-	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
 		mark_entry = get_tracepoint((*iter)->name);
 		if (mark_entry) {
@@ -312,11 +317,27 @@ void tracepoint_update_probe_range(struc
 			disable_tracepoint(*iter);
 		}
 	}
-	mutex_unlock(&tracepoints_mutex);
 }
 
+#ifdef CONFIG_MODULES
+void module_update_tracepoints(void)
+{
+	struct tp_module *tp_mod;
+
+	list_for_each_entry(tp_mod, &tracepoint_module_list, list)
+		tracepoint_update_probe_range(tp_mod->tracepoints_ptrs,
+			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
+}
+#else /* CONFIG_MODULES */
+void module_update_tracepoints(void)
+{
+}
+#endif /* CONFIG_MODULES */
+
+
 /*
  * Update probes, removing the faulty probes.
+ * Called with tracepoints_mutex held.
  */
 static void tracepoint_update_probes(void)
 {
@@ -359,11 +380,12 @@ int tracepoint_probe_register(const char
 
 	mutex_lock(&tracepoints_mutex);
 	old = tracepoint_add_probe(name, probe, data);
-	mutex_unlock(&tracepoints_mutex);
-	if (IS_ERR(old))
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
-
+	}
 	tracepoint_update_probes();		/* may update entry */
+	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
 	return 0;
 }
@@ -402,11 +424,12 @@ int tracepoint_probe_unregister(const ch
 
 	mutex_lock(&tracepoints_mutex);
 	old = tracepoint_remove_probe(name, probe, data);
-	mutex_unlock(&tracepoints_mutex);
-	if (IS_ERR(old))
+	if (IS_ERR(old)) {
+		mutex_unlock(&tracepoints_mutex);
 		return PTR_ERR(old);
-
+	}
 	tracepoint_update_probes();		/* may update entry */
+	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
 	return 0;
 }
@@ -489,9 +512,8 @@ void tracepoint_probe_update_all(void)
 	if (!list_empty(&old_probes))
 		list_replace_init(&old_probes, &release_probes);
 	need_update = 0;
-	mutex_unlock(&tracepoints_mutex);
-
 	tracepoint_update_probes();
+	mutex_unlock(&tracepoints_mutex);
 	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
 		list_del(&pos->u.list);
 		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
@@ -509,7 +531,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_updat
  * Will return the first tracepoint in the range if the input tracepoint is
  * NULL.
  */
-int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+static int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
 	struct tracepoint * const *begin, struct tracepoint * const *end)
 {
 	if (!*tracepoint && begin != end) {
@@ -520,11 +542,12 @@ int tracepoint_get_iter_range(struct tra
 		return 1;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tracepoint_get_iter_range);
 
+#ifdef CONFIG_MODULES
 static void tracepoint_get_iter(struct tracepoint_iter *iter)
 {
 	int found = 0;
+	struct tp_module *iter_mod;
 
 	/* Core kernel tracepoints */
 	if (!iter->module) {
@@ -534,12 +557,43 @@ static void tracepoint_get_iter(struct t
 		if (found)
 			goto end;
 	}
-	/* tracepoints in modules. */
-	found = module_get_iter_tracepoints(iter);
+	/* Tracepoints in modules */
+	mutex_lock(&tracepoints_mutex);
+	list_for_each_entry(iter_mod, &tracepoint_module_list, list) {
+		/*
+		 * Sorted module list
+		 */
+		if (iter_mod < iter->module)
+			continue;
+		else if (iter_mod > iter->module)
+			iter->tracepoint = NULL;
+		found = tracepoint_get_iter_range(&iter->tracepoint,
+			iter_mod->tracepoints_ptrs,
+			iter_mod->tracepoints_ptrs
+				+ iter_mod->num_tracepoints);
+		if (found) {
+			iter->module = iter_mod;
+			break;
+		}
+	}
+	mutex_unlock(&tracepoints_mutex);
 end:
 	if (!found)
 		tracepoint_iter_reset(iter);
 }
+#else /* CONFIG_MODULES */
+static void tracepoint_get_iter(struct tracepoint_iter *iter)
+{
+	int found = 0;
+
+	/* Core kernel tracepoints */
+	found = tracepoint_get_iter_range(&iter->tracepoint,
+			__start___tracepoints_ptrs,
+			__stop___tracepoints_ptrs);
+	if (!found)
+		tracepoint_iter_reset(iter);
+}
+#endif /* CONFIG_MODULES */
 
 void tracepoint_iter_start(struct tracepoint_iter *iter)
 {
@@ -566,26 +620,98 @@ EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
 
 void tracepoint_iter_reset(struct tracepoint_iter *iter)
 {
+#ifdef CONFIG_MODULES
 	iter->module = NULL;
+#endif /* CONFIG_MODULES */
 	iter->tracepoint = NULL;
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
 #ifdef CONFIG_MODULES
+static int tracepoint_module_coming(struct module *mod)
+{
+	struct tp_module *tp_mod, *iter;
+	int ret = 0;
+
+	/*
+	 * We skip modules that tain the kernel, especially those with different
+	 * module header (for forced load), to make sure we don't cause a crash.
+	 */
+	if (mod->taints)
+		return 0;
+	mutex_lock(&tracepoints_mutex);
+	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
+	if (!tp_mod) {
+		ret = -ENOMEM;
+		goto end;
+	}
+	tp_mod->num_tracepoints = mod->num_tracepoints;
+	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
+
+	/*
+	 * tracepoint_module_list is kept sorted by struct module pointer
+	 * address for iteration on tracepoints from a seq_file that can release
+	 * the mutex between calls.
+	 */
+	list_for_each_entry_reverse(iter, &tracepoint_module_list, list) {
+		BUG_ON(iter == tp_mod);	/* Should never be in the list twice */
+		if (iter < tp_mod) {
+			/* We belong to the location right after iter. */
+			list_add(&tp_mod->list, &iter->list);
+			goto module_added;
+		}
+	}
+	/* We belong to the beginning of the list */
+	list_add(&tp_mod->list, &tracepoint_module_list);
+module_added:
+	tracepoint_update_probe_range(mod->tracepoints_ptrs,
+		mod->tracepoints_ptrs + mod->num_tracepoints);
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+
+static int tracepoint_module_going(struct module *mod)
+{
+	struct tp_module *pos;
+
+	mutex_lock(&tracepoints_mutex);
+	tracepoint_update_probe_range(mod->tracepoints_ptrs,
+		mod->tracepoints_ptrs + mod->num_tracepoints);
+	list_for_each_entry(pos, &tracepoint_module_list, list) {
+		if (pos->tracepoints_ptrs == mod->tracepoints_ptrs) {
+			list_del(&pos->list);
+			kfree(pos);
+			break;
+		}
+	}
+	/*
+	 * In the case of modules that were tainted at "coming", we'll simply
+	 * walk through the list without finding it. We cannot use the "tainted"
+	 * flag on "going", in case a module taints the kernel only after being
+	 * loaded.
+	 */
+	mutex_unlock(&tracepoints_mutex);
+	return 0;
+}
 
 int tracepoint_module_notify(struct notifier_block *self,
 			     unsigned long val, void *data)
 {
 	struct module *mod = data;
+	int ret = 0;
 
 	switch (val) {
 	case MODULE_STATE_COMING:
+		ret = tracepoint_module_coming(mod);
+		break;
+	case MODULE_STATE_LIVE:
+		break;
 	case MODULE_STATE_GOING:
-		tracepoint_update_probe_range(mod->tracepoints_ptrs,
-			mod->tracepoints_ptrs + mod->num_tracepoints);
+		ret = tracepoint_module_going(mod);
 		break;
 	}
-	return 0;
+	return ret;
 }
 
 struct notifier_block tracepoint_module_nb = {
@@ -598,7 +724,6 @@ static int init_tracepoints(void)
 	return register_module_notifier(&tracepoint_module_nb);
 }
 __initcall(init_tracepoints);
-
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h
+++ linux-2.6-lttng/include/linux/module.h
@@ -578,9 +578,6 @@ int unregister_module_notifier(struct no
 
 extern void print_modules(void);
 
-extern void module_update_tracepoints(void);
-extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -696,15 +693,6 @@ static inline int unregister_module_noti
 static inline void print_modules(void)
 {
 }
-
-static inline void module_update_tracepoints(void)
-{
-}
-
-static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
-{
-	return 0;
-}
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
