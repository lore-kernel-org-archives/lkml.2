Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BDWCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:02:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:57278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1BDWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:02:29 -0500
Date: Fri, 4 Feb 2011 22:01:24 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        peterz@infradead.org, davem@davemloft.net, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        peterz@infradead.org, davem@davemloft.net, fweisbec@gmail.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110126222622.GA10794@Krystal>
References: <20110126222622.GA10794@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracepoints: Fix section alignment using pointer array
Message-ID: <tip-654986462939cd7ec18f276c6379a334dac106a7@git.kernel.org>
Git-Commit-ID: 654986462939cd7ec18f276c6379a334dac106a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Feb 2011 22:01:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  654986462939cd7ec18f276c6379a334dac106a7
Gitweb:     http://git.kernel.org/tip/654986462939cd7ec18f276c6379a334dac106a7
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Wed, 26 Jan 2011 17:26:22 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 3 Feb 2011 09:28:46 -0500

tracepoints: Fix section alignment using pointer array

Make the tracepoints more robust, making them solid enough to handle compiler
changes by not relying on anything based on compiler-specific behavior with
respect to structure alignment. Implement an approach proposed by David Miller:
use an array of const pointers to refer to the individual structures, and export
this pointer array through the linker script rather than the structures per se.
It will consume 32 extra bytes per tracepoint (24 for structure padding and 8
for the pointers), but are less likely to break due to compiler changes.

History:

commit 7e066fb8 tracepoints: add DECLARE_TRACE() and DEFINE_TRACE()
added the aligned(32) type and variable attribute to the tracepoint structures
to deal with gcc happily aligning statically defined structures on 32-byte
multiples.

One attempt was to use a 8-byte alignment for tracepoint structures by applying
both the variable and type attribute to tracepoint structures definitions and
declarations. It worked fine with gcc 4.5.1, but broke with gcc 4.4.4 and 4.4.5.

The reason is that the "aligned" attribute only specify the _minimum_ alignment
for a structure, leaving both the compiler and the linker free to align on
larger multiples. Because tracepoint.c expects the structures to be placed as an
array within each section, up-alignment cause NULL-pointer exceptions due to the
extra unexpected padding.

(this patch applies on top of -tip)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: David S. Miller <davem@davemloft.net>
LKML-Reference: <20110126222622.GA10794@Krystal>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    8 +++++---
 include/linux/module.h            |    2 +-
 include/linux/tracepoint.h        |   35 ++++++++++++++++++++---------------
 kernel/module.c                   |   16 ++++++++--------
 kernel/tracepoint.c               |   31 ++++++++++++++++---------------
 5 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f53708b..57b1b68 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -166,10 +166,8 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
-	. = ALIGN(32);							\
-	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
+	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
-	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
 	/* implement dynamic printk debug */				\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
@@ -218,6 +216,10 @@
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
+		. = ALIGN(8);						\
+		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;		\
+		*(__tracepoints_ptrs)	/* Tracepoints: pointer array */\
+		VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = .;		\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
diff --git a/include/linux/module.h b/include/linux/module.h
index 7695a30..9bdf27c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -377,7 +377,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_TRACEPOINTS
-	struct tracepoint *tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
 	unsigned int num_tracepoints;
 #endif
 #ifdef HAVE_JUMP_LABEL
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c681461..97c84a5 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,12 +33,7 @@ struct tracepoint {
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
-} __attribute__((aligned(32)));		/*
-					 * Aligned on 32 bytes because it is
-					 * globally visible and gcc happily
-					 * align these on the structure size.
-					 * Keep in sync with vmlinux.lds.h.
-					 */
+};
 
 /*
  * Connect a probe to a tracepoint.
@@ -61,15 +56,15 @@ extern void tracepoint_probe_update_all(void);
 
 struct tracepoint_iter {
 	struct module *module;
-	struct tracepoint *tracepoint;
+	struct tracepoint * const *tracepoint;
 };
 
 extern void tracepoint_iter_start(struct tracepoint_iter *iter);
 extern void tracepoint_iter_next(struct tracepoint_iter *iter);
 extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
 extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
-	struct tracepoint *begin, struct tracepoint *end);
+extern int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+	struct tracepoint * const *begin, struct tracepoint * const *end);
 
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
@@ -84,11 +79,13 @@ static inline void tracepoint_synchronize_unregister(void)
 #define PARAMS(args...) args
 
 #ifdef CONFIG_TRACEPOINTS
-extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
+extern
+void tracepoint_update_probe_range(struct tracepoint * const *begin,
+	struct tracepoint * const *end);
 #else
-static inline void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
+static inline
+void tracepoint_update_probe_range(struct tracepoint * const *begin,
+	struct tracepoint * const *end)
 { }
 #endif /* CONFIG_TRACEPOINTS */
 
@@ -174,12 +171,20 @@ do_trace:								\
 	{								\
 	}
 
+/*
+ * We have no guarantee that gcc and the linker won't up-align the tracepoint
+ * structures, so we create an array of pointers that will be used for iteration
+ * on the tracepoints.
+ */
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
-	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+	__attribute__((section("__tracepoints"))) =			\
+		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
+	static struct tracepoint * const __tracepoint_ptr_##name __used	\
+	__attribute__((section("__tracepoints_ptrs"))) =		\
+		&__tracepoint_##name;
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
diff --git a/kernel/module.c b/kernel/module.c
index 34e00b7..efa290e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2460,9 +2460,9 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
-	mod->tracepoints = section_objs(info, "__tracepoints",
-					sizeof(*mod->tracepoints),
-					&mod->num_tracepoints);
+	mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
+					     sizeof(*mod->tracepoints_ptrs),
+					     &mod->num_tracepoints);
 #endif
 #ifdef HAVE_JUMP_LABEL
 	mod->jump_entries = section_objs(info, "__jump_table",
@@ -3393,7 +3393,7 @@ void module_layout(struct module *mod,
 		   struct modversion_info *ver,
 		   struct kernel_param *kp,
 		   struct kernel_symbol *ks,
-		   struct tracepoint *tp)
+		   struct tracepoint * const *tp)
 {
 }
 EXPORT_SYMBOL(module_layout);
@@ -3407,8 +3407,8 @@ void module_update_tracepoints(void)
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list)
 		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints,
-				mod->tracepoints + mod->num_tracepoints);
+			tracepoint_update_probe_range(mod->tracepoints_ptrs,
+				mod->tracepoints_ptrs + mod->num_tracepoints);
 	mutex_unlock(&module_mutex);
 }
 
@@ -3432,8 +3432,8 @@ int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 			else if (iter_mod > iter->module)
 				iter->tracepoint = NULL;
 			found = tracepoint_get_iter_range(&iter->tracepoint,
-				iter_mod->tracepoints,
-				iter_mod->tracepoints
+				iter_mod->tracepoints_ptrs,
+				iter_mod->tracepoints_ptrs
 					+ iter_mod->num_tracepoints);
 			if (found) {
 				iter->module = iter_mod;
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index e95ee7f..68187af 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -27,8 +27,8 @@
 #include <linux/sched.h>
 #include <linux/jump_label.h>
 
-extern struct tracepoint __start___tracepoints[];
-extern struct tracepoint __stop___tracepoints[];
+extern struct tracepoint * const __start___tracepoints_ptrs[];
+extern struct tracepoint * const __stop___tracepoints_ptrs[];
 
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
@@ -298,10 +298,10 @@ static void disable_tracepoint(struct tracepoint *elem)
  *
  * Updates the probe callback corresponding to a range of tracepoints.
  */
-void
-tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
+void tracepoint_update_probe_range(struct tracepoint * const *begin,
+				   struct tracepoint * const *end)
 {
-	struct tracepoint *iter;
+	struct tracepoint * const *iter;
 	struct tracepoint_entry *mark_entry;
 
 	if (!begin)
@@ -309,12 +309,12 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 
 	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
-		mark_entry = get_tracepoint(iter->name);
+		mark_entry = get_tracepoint((*iter)->name);
 		if (mark_entry) {
-			set_tracepoint(&mark_entry, iter,
+			set_tracepoint(&mark_entry, *iter,
 					!!mark_entry->refcount);
 		} else {
-			disable_tracepoint(iter);
+			disable_tracepoint(*iter);
 		}
 	}
 	mutex_unlock(&tracepoints_mutex);
@@ -326,8 +326,8 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 static void tracepoint_update_probes(void)
 {
 	/* Core kernel tracepoints */
-	tracepoint_update_probe_range(__start___tracepoints,
-		__stop___tracepoints);
+	tracepoint_update_probe_range(__start___tracepoints_ptrs,
+		__stop___tracepoints_ptrs);
 	/* tracepoints in modules. */
 	module_update_tracepoints();
 }
@@ -514,8 +514,8 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
  * Will return the first tracepoint in the range if the input tracepoint is
  * NULL.
  */
-int tracepoint_get_iter_range(struct tracepoint **tracepoint,
-	struct tracepoint *begin, struct tracepoint *end)
+int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+	struct tracepoint * const *begin, struct tracepoint * const *end)
 {
 	if (!*tracepoint && begin != end) {
 		*tracepoint = begin;
@@ -534,7 +534,8 @@ static void tracepoint_get_iter(struct tracepoint_iter *iter)
 	/* Core kernel tracepoints */
 	if (!iter->module) {
 		found = tracepoint_get_iter_range(&iter->tracepoint,
-				__start___tracepoints, __stop___tracepoints);
+				__start___tracepoints_ptrs,
+				__stop___tracepoints_ptrs);
 		if (found)
 			goto end;
 	}
@@ -585,8 +586,8 @@ int tracepoint_module_notify(struct notifier_block *self,
 	switch (val) {
 	case MODULE_STATE_COMING:
 	case MODULE_STATE_GOING:
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
+		tracepoint_update_probe_range(mod->tracepoints_ptrs,
+			mod->tracepoints_ptrs + mod->num_tracepoints);
 		break;
 	}
 	return 0;
