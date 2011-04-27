Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab1D0PXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:23:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:34637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210Ab1D0PXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:23:36 -0400
Date: Wed, 27 Apr 2011 15:23:08 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-d430d3d7e646eb1eac2bb4aa244a644312e67c76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        davem@davemloft.net, rostedt@goodmis.org, ralf@linux-mips.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de, jbaron@redhat.com,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        davem@davemloft.net, rostedt@goodmis.org, ralf@linux-mips.org,
        ddaney@caviumnetworks.com, jbaron@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20110316212947.GA8792@redhat.com>
References: <20110316212947.GA8792@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Introduce static_branch() interface
Git-Commit-ID: d430d3d7e646eb1eac2bb4aa244a644312e67c76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:23:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d430d3d7e646eb1eac2bb4aa244a644312e67c76
Gitweb:     http://git.kernel.org/tip/d430d3d7e646eb1eac2bb4aa244a644312e67c76
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Wed, 16 Mar 2011 17:29:47 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 4 Apr 2011 12:48:08 -0400

jump label: Introduce static_branch() interface

Introduce:

static __always_inline bool static_branch(struct jump_label_key *key);

instead of the old JUMP_LABEL(key, label) macro.

In this way, jump labels become really easy to use:

Define:

        struct jump_label_key jump_key;

Can be used as:

        if (static_branch(&jump_key))
                do unlikely code

enable/disale via:

        jump_label_inc(&jump_key);
        jump_label_dec(&jump_key);

that's it!

For the jump labels disabled case, the static_branch() becomes an
atomic_read(), and jump_label_inc()/dec() are simply atomic_inc(),
atomic_dec() operations. We show testing results for this change below.

Thanks to H. Peter Anvin for suggesting the 'static_branch()' construct.

Since we now require a 'struct jump_label_key *key', we can store a pointer into
the jump table addresses. In this way, we can enable/disable jump labels, in
basically constant time. This change allows us to completely remove the previous
hashtable scheme. Thanks to Peter Zijlstra for this re-write.

Testing:

I ran a series of 'tbench 20' runs 5 times (with reboots) for 3
configurations, where tracepoints were disabled.

jump label configured in
avg: 815.6

jump label *not* configured in (using atomic reads)
avg: 800.1

jump label *not* configured in (regular reads)
avg: 803.4

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110316212947.GA8792@redhat.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
Suggested-by: H. Peter Anvin <hpa@linux.intel.com>
Tested-by: David Daney <ddaney@caviumnetworks.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/include/asm/jump_label.h  |   22 +-
 arch/sparc/include/asm/jump_label.h |   25 +-
 arch/x86/include/asm/alternative.h  |    3 +-
 arch/x86/include/asm/jump_label.h   |   26 +-
 arch/x86/kernel/alternative.c       |    2 +-
 arch/x86/kernel/module.c            |    1 +
 include/asm-generic/vmlinux.lds.h   |   14 +-
 include/linux/dynamic_debug.h       |    2 -
 include/linux/jump_label.h          |   89 ++++---
 include/linux/jump_label_ref.h      |   44 ---
 include/linux/perf_event.h          |   26 +-
 include/linux/tracepoint.h          |   22 +-
 kernel/jump_label.c                 |  539 ++++++++++++++---------------------
 kernel/perf_event.c                 |    4 +-
 kernel/tracepoint.c                 |   23 +-
 15 files changed, 356 insertions(+), 486 deletions(-)

diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 7622ccf..1881b31 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,16 +20,18 @@
 #define WORD_INSN ".word"
 #endif
 
-#define JUMP_LABEL(key, label)						\
-	do {								\
-		asm goto("1:\tnop\n\t"					\
-			"nop\n\t"					\
-			".pushsection __jump_table,  \"a\"\n\t"		\
-			WORD_INSN " 1b, %l[" #label "], %0\n\t"		\
-			".popsection\n\t"				\
-			: :  "i" (key) :  : label);			\
-	} while (0)
-
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("1:\tnop\n\t"
+		"nop\n\t"
+		".pushsection __jump_table,  \"aw\"\n\t"
+		WORD_INSN " 1b, %l[l_yes], %0\n\t"
+		".popsection\n\t"
+		: :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 427d468..fc73a82 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,17 +7,20 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-#define JUMP_LABEL(key, label)					\
-	do {							\
-		asm goto("1:\n\t"				\
-			 "nop\n\t"				\
-			 "nop\n\t"				\
-			 ".pushsection __jump_table,  \"a\"\n\t"\
-			 ".align 4\n\t"				\
-			 ".word 1b, %l[" #label "], %c0\n\t"	\
-			 ".popsection \n\t"			\
-			 : :  "i" (key) :  : label);\
-	} while (0)
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+		asm goto("1:\n\t"
+			 "nop\n\t"
+			 "nop\n\t"
+			 ".pushsection __jump_table,  \"aw\"\n\t"
+			 ".align 4\n\t"
+			 ".word 1b, %l[l_yes], %c0\n\t"
+			 ".popsection \n\t"
+			 : :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13009d1..8cdd1e2 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -4,7 +4,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/stringify.h>
-#include <linux/jump_label.h>
 #include <asm/asm.h>
 
 /*
@@ -191,7 +190,7 @@ extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_JUMP_LABEL)
 #define IDEAL_NOP_SIZE_5 5
 extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
 extern void arch_init_ideal_nop5(void);
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 574dbc2..f217cee 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -5,20 +5,24 @@
 
 #include <linux/types.h>
 #include <asm/nops.h>
+#include <asm/asm.h>
 
 #define JUMP_LABEL_NOP_SIZE 5
 
-# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
-
-# define JUMP_LABEL(key, label)					\
-	do {							\
-		asm goto("1:"					\
-			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"aw\" \n\t"\
-			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
-			".popsection \n\t"			\
-			: :  "i" (key) :  : label);		\
-	} while (0)
+#define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+
+static __always_inline bool arch_static_branch(struct jump_label_key *key)
+{
+	asm goto("1:"
+		JUMP_LABEL_INITIAL_NOP
+		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		".popsection \n\t"
+		: :  "i" (key) : : l_yes);
+	return false;
+l_yes:
+	return true;
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..651454b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -679,7 +679,7 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_JUMP_LABEL)
 
 #ifdef CONFIG_X86_64
 unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index ab23f1a..52f256f 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -24,6 +24,7 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/gfp.h>
+#include <linux/jump_label.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 32c45e5..7952216 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -170,6 +170,10 @@
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
+	. = ALIGN(8);                                                   \
+	VMLINUX_SYMBOL(__start___jump_table) = .;                       \
+	*(__jump_table)                                                 \
+	VMLINUX_SYMBOL(__stop___jump_table) = .;                        \
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
 	*(__verbose)                                                    \
@@ -228,8 +232,6 @@
 									\
 	BUG_TABLE							\
 									\
-	JUMP_TABLE							\
-									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -589,14 +591,6 @@
 #define BUG_TABLE
 #endif
 
-#define JUMP_TABLE							\
-	. = ALIGN(8);							\
-	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___jump_table) = .;		\
-		*(__jump_table)						\
-		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
-	}
-
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 0c9653f..e747ecd 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -1,8 +1,6 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
-#include <linux/jump_label.h>
-
 /* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
  * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
  * use independent hash functions, to reduce the chance of false positives.
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 7880f18..83e745f 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,20 +1,43 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
+#include <linux/types.h>
+#include <linux/compiler.h>
+
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+
+struct jump_label_key {
+	atomic_t enabled;
+	struct jump_entry *entries;
+#ifdef CONFIG_MODULES
+	struct jump_label_mod *next;
+#endif
+};
+
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
 
 enum jump_label_type {
+	JUMP_LABEL_DISABLE = 0,
 	JUMP_LABEL_ENABLE,
-	JUMP_LABEL_DISABLE
 };
 
 struct module;
 
 #ifdef HAVE_JUMP_LABEL
 
+#ifdef CONFIG_MODULES
+#define JUMP_LABEL_INIT {{ 0 }, NULL, NULL}
+#else
+#define JUMP_LABEL_INIT {{ 0 }, NULL}
+#endif
+
+static __always_inline bool static_branch(struct jump_label_key *key)
+{
+	return arch_static_branch(key);
+}
+
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
@@ -23,37 +46,37 @@ extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
-extern void jump_label_update(unsigned long key, enum jump_label_type type);
-extern void jump_label_apply_nops(struct module *mod);
 extern int jump_label_text_reserved(void *start, void *end);
+extern void jump_label_inc(struct jump_label_key *key);
+extern void jump_label_dec(struct jump_label_key *key);
+extern bool jump_label_enabled(struct jump_label_key *key);
+extern void jump_label_apply_nops(struct module *mod);
 
-#define jump_label_enable(key) \
-	jump_label_update((unsigned long)key, JUMP_LABEL_ENABLE);
+#else
 
-#define jump_label_disable(key) \
-	jump_label_update((unsigned long)key, JUMP_LABEL_DISABLE);
+#include <asm/atomic.h>
 
-#else
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
 
-#define JUMP_LABEL(key, label)			\
-do {						\
-	if (unlikely(*key))			\
-		goto label;			\
-} while (0)
+struct jump_label_key {
+	atomic_t enabled;
+};
 
-#define jump_label_enable(cond_var)	\
-do {					\
-       *(cond_var) = 1;			\
-} while (0)
+static __always_inline bool static_branch(struct jump_label_key *key)
+{
+	if (unlikely(atomic_read(&key->enabled)))
+		return true;
+	return false;
+}
 
-#define jump_label_disable(cond_var)	\
-do {					\
-       *(cond_var) = 0;			\
-} while (0)
+static inline void jump_label_inc(struct jump_label_key *key)
+{
+	atomic_inc(&key->enabled);
+}
 
-static inline int jump_label_apply_nops(struct module *mod)
+static inline void jump_label_dec(struct jump_label_key *key)
 {
-	return 0;
+	atomic_dec(&key->enabled);
 }
 
 static inline int jump_label_text_reserved(void *start, void *end)
@@ -64,16 +87,16 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-#endif
+static inline bool jump_label_enabled(struct jump_label_key *key)
+{
+	return !!atomic_read(&key->enabled);
+}
 
-#define COND_STMT(key, stmt)					\
-do {								\
-	__label__ jl_enabled;					\
-	JUMP_LABEL(key, jl_enabled);				\
-	if (0) {						\
-jl_enabled:							\
-		stmt;						\
-	}							\
-} while (0)
+static inline int jump_label_apply_nops(struct module *mod)
+{
+	return 0;
+}
+
+#endif
 
 #endif
diff --git a/include/linux/jump_label_ref.h b/include/linux/jump_label_ref.h
deleted file mode 100644
index e5d012a..0000000
--- a/include/linux/jump_label_ref.h
+++ /dev/null
@@ -1,44 +0,0 @@
-#ifndef _LINUX_JUMP_LABEL_REF_H
-#define _LINUX_JUMP_LABEL_REF_H
-
-#include <linux/jump_label.h>
-#include <asm/atomic.h>
-
-#ifdef HAVE_JUMP_LABEL
-
-static inline void jump_label_inc(atomic_t *key)
-{
-	if (atomic_add_return(1, key) == 1)
-		jump_label_enable(key);
-}
-
-static inline void jump_label_dec(atomic_t *key)
-{
-	if (atomic_dec_and_test(key))
-		jump_label_disable(key);
-}
-
-#else /* !HAVE_JUMP_LABEL */
-
-static inline void jump_label_inc(atomic_t *key)
-{
-	atomic_inc(key);
-}
-
-static inline void jump_label_dec(atomic_t *key)
-{
-	atomic_dec(key);
-}
-
-#undef JUMP_LABEL
-#define JUMP_LABEL(key, label)						\
-do {									\
-	if (unlikely(__builtin_choose_expr(				\
-	      __builtin_types_compatible_p(typeof(key), atomic_t *),	\
-	      atomic_read((atomic_t *)(key)), *(key))))			\
-		goto label;						\
-} while (0)
-
-#endif /* HAVE_JUMP_LABEL */
-
-#endif /* _LINUX_JUMP_LABEL_REF_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 311b4dc..730b782 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -505,7 +505,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
-#include <linux/jump_label_ref.h>
+#include <linux/jump_label.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -1034,7 +1034,7 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
-extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
@@ -1063,22 +1063,21 @@ perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
-	return;
-
-have_event:
-	if (!regs) {
-		perf_fetch_caller_regs(&hot_regs);
-		regs = &hot_regs;
+	if (static_branch(&perf_swevent_enabled[event_id])) {
+		if (!regs) {
+			perf_fetch_caller_regs(&hot_regs);
+			regs = &hot_regs;
+		}
+		__perf_sw_event(event_id, nr, nmi, regs, addr);
 	}
-	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern atomic_t perf_sched_events;
+extern struct jump_label_key perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_in(task));
+	if (static_branch(&perf_sched_events))
+		__perf_event_task_sched_in(task);
 }
 
 static inline
@@ -1086,7 +1085,8 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
+	if (static_branch(&perf_sched_events))
+		__perf_event_task_sched_out(task, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 97c84a5..d530a44 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -29,7 +29,7 @@ struct tracepoint_func {
 
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
-	int state;			/* State. */
+	struct jump_label_key key;
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
@@ -146,9 +146,7 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
-		return;							\
-do_trace:								\
+		if (static_branch(&__tracepoint_##name.key))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
@@ -176,14 +174,14 @@ do_trace:								\
  * structures, so we create an array of pointers that will be used for iteration
  * on the tracepoints.
  */
-#define DEFINE_TRACE_FN(name, reg, unreg)				\
-	static const char __tpstrtab_##name[]				\
-	__attribute__((section("__tracepoints_strings"))) = #name;	\
-	struct tracepoint __tracepoint_##name				\
-	__attribute__((section("__tracepoints"))) =			\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
-	static struct tracepoint * const __tracepoint_ptr_##name __used	\
-	__attribute__((section("__tracepoints_ptrs"))) =		\
+#define DEFINE_TRACE_FN(name, reg, unreg)				 \
+	static const char __tpstrtab_##name[]				 \
+	__attribute__((section("__tracepoints_strings"))) = #name;	 \
+	struct tracepoint __tracepoint_##name				 \
+	__attribute__((section("__tracepoints"))) =			 \
+		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL };\
+	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
+	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
 
 #define DEFINE_TRACE(name)						\
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3b79bd9..74d1c09 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -2,43 +2,23 @@
  * jump label support
  *
  * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
+ * Copyright (C) 2011 Peter Zijlstra <pzijlstr@redhat.com>
  *
  */
-#include <linux/jump_label.h>
 #include <linux/memory.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/list.h>
-#include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/err.h>
+#include <linux/jump_label.h>
 
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_LABEL_HASH_BITS 6
-#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
-static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
-
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
-struct jump_label_entry {
-	struct hlist_node hlist;
-	struct jump_entry *table;
-	int nr_entries;
-	/* hang modules off here */
-	struct hlist_head modules;
-	unsigned long key;
-};
-
-struct jump_label_module_entry {
-	struct hlist_node hlist;
-	struct jump_entry *table;
-	int nr_entries;
-	struct module *mod;
-};
-
 void jump_label_lock(void)
 {
 	mutex_lock(&jump_label_mutex);
@@ -49,6 +29,11 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
+bool jump_label_enabled(struct jump_label_key *key)
+{
+	return !!atomic_read(&key->enabled);
+}
+
 static int jump_label_cmp(const void *a, const void *b)
 {
 	const struct jump_entry *jea = a;
@@ -64,7 +49,7 @@ static int jump_label_cmp(const void *a, const void *b)
 }
 
 static void
-sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
+jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
 {
 	unsigned long size;
 
@@ -73,118 +58,25 @@ sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
-static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
-{
-	struct hlist_head *head;
-	struct hlist_node *node;
-	struct jump_label_entry *e;
-	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
-
-	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
-		if (key == e->key)
-			return e;
-	}
-	return NULL;
-}
+static void jump_label_update(struct jump_label_key *key, int enable);
 
-static struct jump_label_entry *
-add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
+void jump_label_inc(struct jump_label_key *key)
 {
-	struct hlist_head *head;
-	struct jump_label_entry *e;
-	u32 hash;
-
-	e = get_jump_label_entry(key);
-	if (e)
-		return ERR_PTR(-EEXIST);
-
-	e = kmalloc(sizeof(struct jump_label_entry), GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-
-	hash = jhash((void *)&key, sizeof(jump_label_t), 0);
-	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
-	e->key = key;
-	e->table = table;
-	e->nr_entries = nr_entries;
-	INIT_HLIST_HEAD(&(e->modules));
-	hlist_add_head(&e->hlist, head);
-	return e;
-}
+	if (atomic_inc_not_zero(&key->enabled))
+		return;
 
-static int
-build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
-{
-	struct jump_entry *iter, *iter_begin;
-	struct jump_label_entry *entry;
-	int count;
-
-	sort_jump_label_entries(start, stop);
-	iter = start;
-	while (iter < stop) {
-		entry = get_jump_label_entry(iter->key);
-		if (!entry) {
-			iter_begin = iter;
-			count = 0;
-			while ((iter < stop) &&
-				(iter->key == iter_begin->key)) {
-				iter++;
-				count++;
-			}
-			entry = add_jump_label_entry(iter_begin->key,
-							count, iter_begin);
-			if (IS_ERR(entry))
-				return PTR_ERR(entry);
-		 } else {
-			WARN_ONCE(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
-			return -1;
-		}
-	}
-	return 0;
+	jump_label_lock();
+	if (atomic_add_return(1, &key->enabled) == 1)
+		jump_label_update(key, JUMP_LABEL_ENABLE);
+	jump_label_unlock();
 }
 
-/***
- * jump_label_update - update jump label text
- * @key -  key value associated with a a jump label
- * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
- *
- * Will enable/disable the jump for jump label @key, depending on the
- * value of @type.
- *
- */
-
-void jump_label_update(unsigned long key, enum jump_label_type type)
+void jump_label_dec(struct jump_label_key *key)
 {
-	struct jump_entry *iter;
-	struct jump_label_entry *entry;
-	struct hlist_node *module_node;
-	struct jump_label_module_entry *e_module;
-	int count;
+	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
+		return;
 
-	jump_label_lock();
-	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
-		while (count--) {
-			if (kernel_text_address(iter->code))
-				arch_jump_label_transform(iter, type);
-			iter++;
-		}
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
-	}
+	jump_label_update(key, JUMP_LABEL_DISABLE);
 	jump_label_unlock();
 }
 
@@ -197,77 +89,33 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 	return 0;
 }
 
-#ifdef CONFIG_MODULES
-
-static int module_conflict(void *start, void *end)
+static int __jump_label_text_reserved(struct jump_entry *iter_start,
+		struct jump_entry *iter_stop, void *start, void *end)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
 	struct jump_entry *iter;
-	int i, count;
-	int conflict = 0;
-
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-							module_node_next,
-							&(e->modules), hlist) {
-				count = e_module->nr_entries;
-				iter = e_module->table;
-				while (count--) {
-					if (addr_conflict(iter, start, end)) {
-						conflict = 1;
-						goto out;
-					}
-					iter++;
-				}
-			}
-		}
-	}
-out:
-	return conflict;
-}
-
-#endif
-
-/***
- * jump_label_text_reserved - check if addr range is reserved
- * @start: start text addr
- * @end: end text addr
- *
- * checks if the text addr located between @start and @end
- * overlaps with any of the jump label patch addresses. Code
- * that wants to modify kernel text should first verify that
- * it does not overlap with any of the jump label addresses.
- * Caller must hold jump_label_mutex.
- *
- * returns 1 if there is an overlap, 0 otherwise
- */
-int jump_label_text_reserved(void *start, void *end)
-{
-	struct jump_entry *iter;
-	struct jump_entry *iter_start = __start___jump_table;
-	struct jump_entry *iter_stop = __start___jump_table;
-	int conflict = 0;
 
 	iter = iter_start;
 	while (iter < iter_stop) {
-		if (addr_conflict(iter, start, end)) {
-			conflict = 1;
-			goto out;
-		}
+		if (addr_conflict(iter, start, end))
+			return 1;
 		iter++;
 	}
 
-	/* now check modules */
-#ifdef CONFIG_MODULES
-	conflict = module_conflict(start, end);
-#endif
-out:
-	return conflict;
+	return 0;
+}
+
+static void __jump_label_update(struct jump_label_key *key,
+		struct jump_entry *entry, int enable)
+{
+	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
+		/*
+		 * entry->code set to 0 invalidates module init text sections
+		 * kernel_text_address() verifies we are not in core kernel
+		 * init code, see jump_label_invalidate_module_init().
+		 */
+		if (entry->code && kernel_text_address(entry->code))
+			arch_jump_label_transform(entry, enable);
+	}
 }
 
 /*
@@ -277,142 +125,173 @@ void __weak arch_jump_label_text_poke_early(jump_label_t addr)
 {
 }
 
-static __init int init_jump_label(void)
+static __init int jump_label_init(void)
 {
-	int ret;
 	struct jump_entry *iter_start = __start___jump_table;
 	struct jump_entry *iter_stop = __stop___jump_table;
+	struct jump_label_key *key = NULL;
 	struct jump_entry *iter;
 
 	jump_label_lock();
-	ret = build_jump_label_hashtable(__start___jump_table,
-					 __stop___jump_table);
-	iter = iter_start;
-	while (iter < iter_stop) {
+	jump_label_sort_entries(iter_start, iter_stop);
+
+	for (iter = iter_start; iter < iter_stop; iter++) {
 		arch_jump_label_text_poke_early(iter->code);
-		iter++;
+		if (iter->key == (jump_label_t)(unsigned long)key)
+			continue;
+
+		key = (struct jump_label_key *)(unsigned long)iter->key;
+		atomic_set(&key->enabled, 0);
+		key->entries = iter;
+#ifdef CONFIG_MODULES
+		key->next = NULL;
+#endif
 	}
 	jump_label_unlock();
-	return ret;
+
+	return 0;
 }
-early_initcall(init_jump_label);
+early_initcall(jump_label_init);
 
 #ifdef CONFIG_MODULES
 
-static struct jump_label_module_entry *
-add_jump_label_module_entry(struct jump_label_entry *entry,
-			    struct jump_entry *iter_begin,
-			    int count, struct module *mod)
+struct jump_label_mod {
+	struct jump_label_mod *next;
+	struct jump_entry *entries;
+	struct module *mod;
+};
+
+static int __jump_label_mod_text_reserved(void *start, void *end)
+{
+	struct module *mod;
+
+	mod = __module_text_address((unsigned long)start);
+	if (!mod)
+		return 0;
+
+	WARN_ON_ONCE(__module_text_address((unsigned long)end) != mod);
+
+	return __jump_label_text_reserved(mod->jump_entries,
+				mod->jump_entries + mod->num_jump_entries,
+				start, end);
+}
+
+static void __jump_label_mod_update(struct jump_label_key *key, int enable)
+{
+	struct jump_label_mod *mod = key->next;
+
+	while (mod) {
+		__jump_label_update(key, mod->entries, enable);
+		mod = mod->next;
+	}
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
 {
-	struct jump_label_module_entry *e;
-
-	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-	e->mod = mod;
-	e->nr_entries = count;
-	e->table = iter_begin;
-	hlist_add_head(&e->hlist, &entry->modules);
-	return e;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
+	struct jump_entry *iter;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (iter_start == iter_stop)
+		return;
+
+	for (iter = iter_start; iter < iter_stop; iter++)
+		arch_jump_label_text_poke_early(iter->code);
 }
 
-static int add_jump_label_module(struct module *mod)
+static int jump_label_add_module(struct module *mod)
 {
-	struct jump_entry *iter, *iter_begin;
-	struct jump_label_entry *entry;
-	struct jump_label_module_entry *module_entry;
-	int count;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
+	struct jump_entry *iter;
+	struct jump_label_key *key = NULL;
+	struct jump_label_mod *jlm;
 
 	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
+	if (iter_start == iter_stop)
 		return 0;
 
-	sort_jump_label_entries(mod->jump_entries,
-				mod->jump_entries + mod->num_jump_entries);
-	iter = mod->jump_entries;
-	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		entry = get_jump_label_entry(iter->key);
-		iter_begin = iter;
-		count = 0;
-		while ((iter < mod->jump_entries + mod->num_jump_entries) &&
-			(iter->key == iter_begin->key)) {
-				iter++;
-				count++;
-		}
-		if (!entry) {
-			entry = add_jump_label_entry(iter_begin->key, 0, NULL);
-			if (IS_ERR(entry))
-				return PTR_ERR(entry);
+	jump_label_sort_entries(iter_start, iter_stop);
+
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		if (iter->key == (jump_label_t)(unsigned long)key)
+			continue;
+
+		key = (struct jump_label_key *)(unsigned long)iter->key;
+
+		if (__module_address(iter->key) == mod) {
+			atomic_set(&key->enabled, 0);
+			key->entries = iter;
+			key->next = NULL;
+			continue;
 		}
-		module_entry = add_jump_label_module_entry(entry, iter_begin,
-							   count, mod);
-		if (IS_ERR(module_entry))
-			return PTR_ERR(module_entry);
+
+		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
+		if (!jlm)
+			return -ENOMEM;
+
+		jlm->mod = mod;
+		jlm->entries = iter;
+		jlm->next = key->next;
+		key->next = jlm;
+
+		if (jump_label_enabled(key))
+			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
 	}
+
 	return 0;
 }
 
-static void remove_jump_label_module(struct module *mod)
+static void jump_label_del_module(struct module *mod)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
-	int i;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
+	struct jump_entry *iter;
+	struct jump_label_key *key = NULL;
+	struct jump_label_mod *jlm, **prev;
 
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		if (iter->key == (jump_label_t)(unsigned long)key)
+			continue;
+
+		key = (struct jump_label_key *)(unsigned long)iter->key;
+
+		if (__module_address(iter->key) == mod)
+			continue;
+
+		prev = &key->next;
+		jlm = key->next;
 
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-						  module_node_next,
-						  &(e->modules), hlist) {
-				if (e_module->mod == mod) {
-					hlist_del(&e_module->hlist);
-					kfree(e_module);
-				}
-			}
-			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
-				hlist_del(&e->hlist);
-				kfree(e);
-			}
+		while (jlm && jlm->mod != mod) {
+			prev = &jlm->next;
+			jlm = jlm->next;
+		}
+
+		if (jlm) {
+			*prev = jlm->next;
+			kfree(jlm);
 		}
 	}
 }
 
-static void remove_jump_label_module_init(struct module *mod)
+static void jump_label_invalidate_module_init(struct module *mod)
 {
-	struct hlist_head *head;
-	struct hlist_node *node, *node_next, *module_node, *module_node_next;
-	struct jump_label_entry *e;
-	struct jump_label_module_entry *e_module;
+	struct jump_entry *iter_start = mod->jump_entries;
+	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
 	struct jump_entry *iter;
-	int i, count;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
 
-	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
-		head = &jump_label_table[i];
-		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
-			hlist_for_each_entry_safe(e_module, module_node,
-						  module_node_next,
-						  &(e->modules), hlist) {
-				if (e_module->mod != mod)
-					continue;
-				count = e_module->nr_entries;
-				iter = e_module->table;
-				while (count--) {
-					if (within_module_init(iter->code, mod))
-						iter->key = 0;
-					iter++;
-				}
-			}
-		}
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		if (within_module_init(iter->code, mod))
+			iter->code = 0;
 	}
 }
 
@@ -426,59 +305,77 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
 	switch (val) {
 	case MODULE_STATE_COMING:
 		jump_label_lock();
-		ret = add_jump_label_module(mod);
+		ret = jump_label_add_module(mod);
 		if (ret)
-			remove_jump_label_module(mod);
+			jump_label_del_module(mod);
 		jump_label_unlock();
 		break;
 	case MODULE_STATE_GOING:
 		jump_label_lock();
-		remove_jump_label_module(mod);
+		jump_label_del_module(mod);
 		jump_label_unlock();
 		break;
 	case MODULE_STATE_LIVE:
 		jump_label_lock();
-		remove_jump_label_module_init(mod);
+		jump_label_invalidate_module_init(mod);
 		jump_label_unlock();
 		break;
 	}
-	return ret;
-}
 
-/***
- * apply_jump_label_nops - patch module jump labels with arch_get_jump_label_nop()
- * @mod: module to patch
- *
- * Allow for run-time selection of the optimal nops. Before the module
- * loads patch these with arch_get_jump_label_nop(), which is specified by
- * the arch specific jump label code.
- */
-void jump_label_apply_nops(struct module *mod)
-{
-	struct jump_entry *iter;
-
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
-	iter = mod->jump_entries;
-	while (iter < mod->jump_entries + mod->num_jump_entries) {
-		arch_jump_label_text_poke_early(iter->code);
-		iter++;
-	}
+	return notifier_from_errno(ret);
 }
 
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
-	.priority = 0,
+	.priority = 1, /* higher than tracepoints */
 };
 
-static __init int init_jump_label_module(void)
+static __init int jump_label_init_module(void)
 {
 	return register_module_notifier(&jump_label_module_nb);
 }
-early_initcall(init_jump_label_module);
+early_initcall(jump_label_init_module);
 
 #endif /* CONFIG_MODULES */
 
+/***
+ * jump_label_text_reserved - check if addr range is reserved
+ * @start: start text addr
+ * @end: end text addr
+ *
+ * checks if the text addr located between @start and @end
+ * overlaps with any of the jump label patch addresses. Code
+ * that wants to modify kernel text should first verify that
+ * it does not overlap with any of the jump label addresses.
+ * Caller must hold jump_label_mutex.
+ *
+ * returns 1 if there is an overlap, 0 otherwise
+ */
+int jump_label_text_reserved(void *start, void *end)
+{
+	int ret = __jump_label_text_reserved(__start___jump_table,
+			__stop___jump_table, start, end);
+
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_MODULES
+	ret = __jump_label_mod_text_reserved(start, end);
+#endif
+	return ret;
+}
+
+static void jump_label_update(struct jump_label_key *key, int enable)
+{
+	struct jump_entry *entry = key->entries;
+
+	/* if there are no users, entry can be NULL */
+	if (entry)
+		__jump_label_update(key, entry, enable);
+
+#ifdef CONFIG_MODULES
+	__jump_label_mod_update(key, enable);
+#endif
+}
+
 #endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..d665e92 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -125,7 +125,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-atomic_t perf_sched_events __read_mostly;
+struct jump_label_key perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -5417,7 +5417,7 @@ fail:
 	return err;
 }
 
-atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_event_destroy(struct perf_event *event)
 {
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 68187af..b219f14 100644
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
+	if (active && !jump_label_enabled(&elem->key))
+		jump_label_inc(&elem->key);
+	else if (!active && jump_label_enabled(&elem->key))
+		jump_label_dec(&elem->key);
 }
 
 /*
@@ -281,13 +278,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
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
+	if (jump_label_enabled(&elem->key))
+		jump_label_dec(&elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
