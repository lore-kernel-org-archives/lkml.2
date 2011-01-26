Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1AZW0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:26:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43338 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754375Ab1AZW00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:26:26 -0500
Date: Wed, 26 Jan 2011 17:26:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC PATCH] Tracepoints: fix section alignment using pointer array
Message-ID: <20110126222622.GA10794@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:15:48 up 64 days,  3:18,  4 users,  load average: 0.07, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the tracepoints more robust, making them solid enough to handle compiler
changes by not relying on anything based on compiler-specific behavior with
respect to structure alignment. Implement an approach proposed by David Miller:
use an array of const pointers to refer to the individual structures, and export
this pointer array through the linker script rather than the structures per se.
It will consume 32 extra bytes per tracepoint (24 for structure padding and 8
for the pointers), but are less likely to break due to compiler changes.

History:

commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
variable attribute to the tracepoint structures to deal with gcc happily
aligning statically defined structures on 32-byte multiples.

commit 15e3540ce2159705f18fad6147ffedf04445ad64 tried to use a 8-byte alignment
for tracepoint structures by applying both the variable and type attribute to
tracepoint structures definitions and declarations. It worked fine with gcc
4.5.1, but broke with gcc 4.4.4 and 4.4.5.

The reason is that the "aligned" attribute only specify the _minimum_ alignment
for a structure, leaving both the compiler and the linker free to align on
larger multiples. Because tracepoint.c expects the structures to be placed as an
array within each section, up-alignment cause NULL-pointer exceptions due to the
extra unexpected padding.

(this patch applies on top of -tip)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Miller <davem@davemloft.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/vmlinux.lds.h |    8 +++++---
 include/linux/module.h            |    2 +-
 include/linux/tracepoint.h        |   31 ++++++++++++++++++++-----------
 kernel/module.c                   |   16 ++++++++--------
 kernel/tracepoint.c               |   31 ++++++++++++++++---------------
 5 files changed, 50 insertions(+), 38 deletions(-)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h
+++ linux-2.6-lttng/include/linux/tracepoint.h
@@ -33,7 +33,7 @@ struct tracepoint {
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func *funcs;
-} __u64_aligned;
+};
 
 /*
  * Connect a probe to a tracepoint.
@@ -56,15 +56,15 @@ extern void tracepoint_probe_update_all(
 
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
@@ -79,11 +79,13 @@ static inline void tracepoint_synchroniz
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
 
@@ -138,7 +140,7 @@ static inline void tracepoint_update_pro
  * structure. Force alignment to the same alignment as the section start.
  */
 #define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
-	extern struct tracepoint __u64_aligned __tracepoint_##name;	\
+	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
 		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
@@ -165,13 +167,20 @@ do_trace:								\
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
-	__u64_aligned							\
 	__attribute__((section("__tracepoints"))) =			\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
+	static struct tracepoint * const __tracepoint_ptr_##name __used	\
+	__attribute__((section("__tracepoints_ptrs"))) =		\
+		&__tracepoint_##name;
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
@@ -168,10 +168,8 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
-	U64_ALIGN();							\
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
Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c
+++ linux-2.6-lttng/kernel/tracepoint.c
@@ -27,8 +27,8 @@
 #include <linux/sched.h>
 #include <linux/jump_label.h>
 
-extern struct tracepoint __start___tracepoints[];
-extern struct tracepoint __stop___tracepoints[];
+extern struct tracepoint * const __start___tracepoints_ptrs[];
+extern struct tracepoint * const __stop___tracepoints_ptrs[];
 
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
@@ -298,10 +298,10 @@ static void disable_tracepoint(struct tr
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
@@ -309,12 +309,12 @@ tracepoint_update_probe_range(struct tra
 
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
@@ -326,8 +326,8 @@ tracepoint_update_probe_range(struct tra
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
@@ -514,8 +514,8 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_updat
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
@@ -534,7 +534,8 @@ static void tracepoint_get_iter(struct t
 	/* Core kernel tracepoints */
 	if (!iter->module) {
 		found = tracepoint_get_iter_range(&iter->tracepoint,
-				__start___tracepoints, __stop___tracepoints);
+				__start___tracepoints_ptrs,
+				__stop___tracepoints_ptrs);
 		if (found)
 			goto end;
 	}
@@ -585,8 +586,8 @@ int tracepoint_module_notify(struct noti
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
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h
+++ linux-2.6-lttng/include/linux/module.h
@@ -347,7 +347,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_TRACEPOINTS
-	struct tracepoint *tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
 	unsigned int num_tracepoints;
 #endif
 #ifdef HAVE_JUMP_LABEL
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c
+++ linux-2.6-lttng/kernel/module.c
@@ -2306,9 +2306,9 @@ static void find_module_sections(struct
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
@@ -3226,7 +3226,7 @@ void module_layout(struct module *mod,
 		   struct modversion_info *ver,
 		   struct kernel_param *kp,
 		   struct kernel_symbol *ks,
-		   struct tracepoint *tp)
+		   struct tracepoint * const *tp)
 {
 }
 EXPORT_SYMBOL(module_layout);
@@ -3240,8 +3240,8 @@ void module_update_tracepoints(void)
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list)
 		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints,
-				mod->tracepoints + mod->num_tracepoints);
+			tracepoint_update_probe_range(mod->tracepoints_ptrs,
+				mod->tracepoints_ptrs + mod->num_tracepoints);
 	mutex_unlock(&module_mutex);
 }
 
@@ -3265,8 +3265,8 @@ int module_get_iter_tracepoints(struct t
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
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
