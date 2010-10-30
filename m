Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0J3SWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:22:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0J3SWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:22:10 -0400
Date: Sat, 30 Oct 2010 20:21:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101030182150.GA21818@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

One of the fixes works around a compiler bug in the jump label optimization on 
x86-32 - and while this fixes the bug it reduced our confidence in GCC getting jump 
labels right, so we also made the optimization Kconfig optional (and it defaults to 
off).

 Thanks,

	Ingo

------------------>
David Miller (1):
      jump_label: Fix unaligned traps on sparc.

H. Peter Anvin (1):
      x86, ftrace: Use safe noops, drop trap test

Jason Baron (2):
      jump label: Fix module __init section race
      jump label: Fix deadlock b/w jump_label_mutex vs. text_mutex

Santosh Shilimkar (1):
      oprofile: Fix the hang while taking the cpu offline

Steven Rostedt (3):
      jump label: Fix error with preempt disable holding mutex
      jump label: Make arch_jump_label_text_poke_early() optional
      jump label: Add work around to i386 gcc asm goto bug

Tejun Heo (1):
      oprofile: Remove deprecated use of flush_scheduled_work()


 arch/Kconfig                        |   14 ++++++
 arch/sparc/include/asm/jump_label.h |    1 +
 arch/x86/Makefile_32.cpu            |   13 +++++-
 arch/x86/kernel/alternative.c       |   69 +++++++------------------------
 drivers/oprofile/buffer_sync.c      |    2 +-
 drivers/oprofile/cpu_buffer.c       |   10 +++-
 drivers/oprofile/cpu_buffer.h       |    1 +
 drivers/oprofile/timer_int.c        |   13 ++++++
 include/linux/jump_label.h          |    7 +++-
 kernel/jump_label.c                 |   77 ++++++++++++++++++++++++++++++-----
 kernel/kprobes.c                    |   26 +++++++-----
 11 files changed, 152 insertions(+), 81 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 53d7f61..8bf0fa65 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -42,6 +42,20 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config JUMP_LABEL
+       bool "Optimize trace point call sites"
+       depends on HAVE_ARCH_JUMP_LABEL
+       help
+         If it is detected that the compiler has support for "asm goto",
+	 the kernel will compile trace point locations with just a
+	 nop instruction. When trace points are enabled, the nop will
+	 be converted to a jump to the trace function. This technique
+	 lowers overhead and stress on the branch prediction of the
+	 processor.
+
+	 On i386, options added to the compiler flags may increase
+	 the size of the kernel slightly.
+
 config OPTPROBES
 	def_bool y
 	depends on KPROBES && HAVE_OPTPROBES
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 62e66d7..d95cf44 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -14,6 +14,7 @@
 			 "nop\n\t"				\
 			 "nop\n\t"				\
 			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".align 4\n\t"				\
 			 ".word 1b, %l[" #label "], %c0\n\t"	\
 			 ".popsection \n\t"			\
 			 : :  "i" (key) :  : label);\
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 1255d95..f2ee1ab 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -51,7 +51,18 @@ cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 # prologue (push %ebp, mov %esp, %ebp) which breaks the function graph
 # tracer assumptions. For i686, generic, core2 this is set by the
 # compiler anyway
-cflags-$(CONFIG_FUNCTION_GRAPH_TRACER) += $(call cc-option,-maccumulate-outgoing-args)
+ifeq ($(CONFIG_FUNCTION_GRAPH_TRACER), y)
+ADD_ACCUMULATE_OUTGOING_ARGS := y
+endif
+
+# Work around to a bug with asm goto with first implementations of it
+# in gcc causing gcc to mess up the push and pop of the stack in some
+# uses of asm goto.
+ifeq ($(CONFIG_JUMP_LABEL), y)
+ADD_ACCUMULATE_OUTGOING_ARGS := y
+endif
+
+cflags-$(ADD_ACCUMULATE_OUTGOING_ARGS) += $(call cc-option,-maccumulate-outgoing-args)
 
 # Bug fix for binutils: this option is required in order to keep
 # binutils from generating NOPL instructions against our will.
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a36bb90..0b30214 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -644,65 +644,26 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 
-unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
+#ifdef CONFIG_X86_64
+unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
+#else
+unsigned char ideal_nop5[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
+#endif
 
 void __init arch_init_ideal_nop5(void)
 {
-	extern const unsigned char ftrace_test_p6nop[];
-	extern const unsigned char ftrace_test_nop5[];
-	extern const unsigned char ftrace_test_jmp[];
-	int faulted = 0;
-
 	/*
-	 * There is no good nop for all x86 archs.
-	 * We will default to using the P6_NOP5, but first we
-	 * will test to make sure that the nop will actually
-	 * work on this CPU. If it faults, we will then
-	 * go to a lesser efficient 5 byte nop. If that fails
-	 * we then just use a jmp as our nop. This isn't the most
-	 * efficient nop, but we can not use a multi part nop
-	 * since we would then risk being preempted in the middle
-	 * of that nop, and if we enabled tracing then, it might
-	 * cause a system crash.
+	 * There is no good nop for all x86 archs.  This selection
+	 * algorithm should be unified with the one in find_nop_table(),
+	 * but this should be good enough for now.
 	 *
-	 * TODO: check the cpuid to determine the best nop.
+	 * For cases other than the ones below, use the safe (as in
+	 * always functional) defaults above.
 	 */
-	asm volatile (
-		"ftrace_test_jmp:"
-		"jmp ftrace_test_p6nop\n"
-		"nop\n"
-		"nop\n"
-		"nop\n"  /* 2 byte jmp + 3 bytes */
-		"ftrace_test_p6nop:"
-		P6_NOP5
-		"jmp 1f\n"
-		"ftrace_test_nop5:"
-		".byte 0x66,0x66,0x66,0x66,0x90\n"
-		"1:"
-		".section .fixup, \"ax\"\n"
-		"2:	movl $1, %0\n"
-		"	jmp ftrace_test_nop5\n"
-		"3:	movl $2, %0\n"
-		"	jmp 1b\n"
-		".previous\n"
-		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
-		_ASM_EXTABLE(ftrace_test_nop5, 3b)
-		: "=r"(faulted) : "0" (faulted));
-
-	switch (faulted) {
-	case 0:
-		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
-		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
-		break;
-	case 1:
-		pr_info("converting mcount calls to 66 66 66 66 90\n");
-		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
-		break;
-	case 2:
-		pr_info("converting mcount calls to jmp . + 5\n");
-		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
-		break;
-	}
-
+#ifdef CONFIG_X86_64
+	/* Don't use these on 32 bits due to broken virtualizers */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		memcpy(ideal_nop5, p6_nops[5], 5);
+#endif
 }
 #endif
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index b7e755f..a3984f4 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -190,7 +190,7 @@ void sync_stop(void)
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
 	mutex_unlock(&buffer_mutex);
-	flush_scheduled_work();
+	flush_cpu_work();
 
 	/* make sure we don't leak task structs */
 	process_task_mortuary();
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index f179ac2..59f5544 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -111,14 +111,18 @@ void start_cpu_work(void)
 
 void end_cpu_work(void)
 {
-	int i;
-
 	work_enabled = 0;
+}
+
+void flush_cpu_work(void)
+{
+	int i;
 
 	for_each_online_cpu(i) {
 		struct oprofile_cpu_buffer *b = &per_cpu(op_cpu_buffer, i);
 
-		cancel_delayed_work(&b->work);
+		/* these works are per-cpu, no need for flush_sync */
+		flush_delayed_work(&b->work);
 	}
 }
 
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 68ea16a..e1d097e 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -25,6 +25,7 @@ void free_cpu_buffers(void);
 
 void start_cpu_work(void);
 void end_cpu_work(void);
+void flush_cpu_work(void);
 
 /* CPU buffer is composed of such entries (which are
  * also used for context switch notes)
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index dc0ae4d..0107251 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -21,6 +21,7 @@
 #include "oprof.h"
 
 static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
+static int ctr_running;
 
 static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
 {
@@ -33,6 +34,9 @@ static void __oprofile_hrtimer_start(void *unused)
 {
 	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
 
+	if (!ctr_running)
+		return;
+
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = oprofile_hrtimer_notify;
 
@@ -42,7 +46,10 @@ static void __oprofile_hrtimer_start(void *unused)
 
 static int oprofile_hrtimer_start(void)
 {
+	get_online_cpus();
+	ctr_running = 1;
 	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
+	put_online_cpus();
 	return 0;
 }
 
@@ -50,6 +57,9 @@ static void __oprofile_hrtimer_stop(int cpu)
 {
 	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
 
+	if (!ctr_running)
+		return;
+
 	hrtimer_cancel(hrtimer);
 }
 
@@ -57,8 +67,11 @@ static void oprofile_hrtimer_stop(void)
 {
 	int cpu;
 
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		__oprofile_hrtimer_stop(cpu);
+	ctr_running = 0;
+	put_online_cpus();
 }
 
 static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b67cb18..7880f18 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
@@ -18,6 +18,8 @@ struct module;
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
+extern void jump_label_lock(void);
+extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
@@ -59,6 +61,9 @@ static inline int jump_label_text_reserved(void *start, void *end)
 	return 0;
 }
 
+static inline void jump_label_lock(void) {}
+static inline void jump_label_unlock(void) {}
+
 #endif
 
 #define COND_STMT(key, stmt)					\
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 7be868b..3b79bd9 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -39,6 +39,16 @@ struct jump_label_module_entry {
 	struct module *mod;
 };
 
+void jump_label_lock(void)
+{
+	mutex_lock(&jump_label_mutex);
+}
+
+void jump_label_unlock(void)
+{
+	mutex_unlock(&jump_label_mutex);
+}
+
 static int jump_label_cmp(const void *a, const void *b)
 {
 	const struct jump_entry *jea = a;
@@ -152,7 +162,7 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 	struct jump_label_module_entry *e_module;
 	int count;
 
-	mutex_lock(&jump_label_mutex);
+	jump_label_lock();
 	entry = get_jump_label_entry((jump_label_t)key);
 	if (entry) {
 		count = entry->nr_entries;
@@ -168,13 +178,14 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 			count = e_module->nr_entries;
 			iter = e_module->table;
 			while (count--) {
-				if (kernel_text_address(iter->code))
+				if (iter->key &&
+						kernel_text_address(iter->code))
 					arch_jump_label_transform(iter, type);
 				iter++;
 			}
 		}
 	}
-	mutex_unlock(&jump_label_mutex);
+	jump_label_unlock();
 }
 
 static int addr_conflict(struct jump_entry *entry, void *start, void *end)
@@ -231,6 +242,7 @@ out:
  * overlaps with any of the jump label patch addresses. Code
  * that wants to modify kernel text should first verify that
  * it does not overlap with any of the jump label addresses.
+ * Caller must hold jump_label_mutex.
  *
  * returns 1 if there is an overlap, 0 otherwise
  */
@@ -241,7 +253,6 @@ int jump_label_text_reserved(void *start, void *end)
 	struct jump_entry *iter_stop = __start___jump_table;
 	int conflict = 0;
 
-	mutex_lock(&jump_label_mutex);
 	iter = iter_start;
 	while (iter < iter_stop) {
 		if (addr_conflict(iter, start, end)) {
@@ -256,10 +267,16 @@ int jump_label_text_reserved(void *start, void *end)
 	conflict = module_conflict(start, end);
 #endif
 out:
-	mutex_unlock(&jump_label_mutex);
 	return conflict;
 }
 
+/*
+ * Not all archs need this.
+ */
+void __weak arch_jump_label_text_poke_early(jump_label_t addr)
+{
+}
+
 static __init int init_jump_label(void)
 {
 	int ret;
@@ -267,7 +284,7 @@ static __init int init_jump_label(void)
 	struct jump_entry *iter_stop = __stop___jump_table;
 	struct jump_entry *iter;
 
-	mutex_lock(&jump_label_mutex);
+	jump_label_lock();
 	ret = build_jump_label_hashtable(__start___jump_table,
 					 __stop___jump_table);
 	iter = iter_start;
@@ -275,7 +292,7 @@ static __init int init_jump_label(void)
 		arch_jump_label_text_poke_early(iter->code);
 		iter++;
 	}
-	mutex_unlock(&jump_label_mutex);
+	jump_label_unlock();
 	return ret;
 }
 early_initcall(init_jump_label);
@@ -366,6 +383,39 @@ static void remove_jump_label_module(struct module *mod)
 	}
 }
 
+static void remove_jump_label_module_init(struct module *mod)
+{
+	struct hlist_head *head;
+	struct hlist_node *node, *node_next, *module_node, *module_node_next;
+	struct jump_label_entry *e;
+	struct jump_label_module_entry *e_module;
+	struct jump_entry *iter;
+	int i, count;
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
+				if (e_module->mod != mod)
+					continue;
+				count = e_module->nr_entries;
+				iter = e_module->table;
+				while (count--) {
+					if (within_module_init(iter->code, mod))
+						iter->key = 0;
+					iter++;
+				}
+			}
+		}
+	}
+}
+
 static int
 jump_label_module_notify(struct notifier_block *self, unsigned long val,
 			 void *data)
@@ -375,16 +425,21 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
-		mutex_lock(&jump_label_mutex);
+		jump_label_lock();
 		ret = add_jump_label_module(mod);
 		if (ret)
 			remove_jump_label_module(mod);
-		mutex_unlock(&jump_label_mutex);
+		jump_label_unlock();
 		break;
 	case MODULE_STATE_GOING:
-		mutex_lock(&jump_label_mutex);
+		jump_label_lock();
 		remove_jump_label_module(mod);
-		mutex_unlock(&jump_label_mutex);
+		jump_label_unlock();
+		break;
+	case MODULE_STATE_LIVE:
+		jump_label_lock();
+		remove_jump_label_module_init(mod);
+		jump_label_unlock();
 		break;
 	}
 	return ret;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 99865c3..9737a76 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1145,14 +1145,13 @@ int __kprobes register_kprobe(struct kprobe *p)
 	if (ret)
 		return ret;
 
+	jump_label_lock();
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
 	    ftrace_text_reserved(p->addr, p->addr) ||
-	    jump_label_text_reserved(p->addr, p->addr)) {
-		preempt_enable();
-		return -EINVAL;
-	}
+	    jump_label_text_reserved(p->addr, p->addr))
+		goto fail_with_jump_label;
 
 	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
 	p->flags &= KPROBE_FLAG_DISABLED;
@@ -1166,10 +1165,9 @@ int __kprobes register_kprobe(struct kprobe *p)
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
 		 */
-		if (unlikely(!try_module_get(probed_mod))) {
-			preempt_enable();
-			return -EINVAL;
-		}
+		if (unlikely(!try_module_get(probed_mod)))
+			goto fail_with_jump_label;
+
 		/*
 		 * If the module freed .init.text, we couldn't insert
 		 * kprobes in there.
@@ -1177,16 +1175,18 @@ int __kprobes register_kprobe(struct kprobe *p)
 		if (within_module_init((unsigned long)p->addr, probed_mod) &&
 		    probed_mod->state != MODULE_STATE_COMING) {
 			module_put(probed_mod);
-			preempt_enable();
-			return -EINVAL;
+			goto fail_with_jump_label;
 		}
 	}
 	preempt_enable();
+	jump_label_unlock();
 
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);
 
+	jump_label_lock(); /* needed to call jump_label_text_reserved() */
+
 	get_online_cpus();	/* For avoiding text_mutex deadlock. */
 	mutex_lock(&text_mutex);
 
@@ -1214,12 +1214,18 @@ int __kprobes register_kprobe(struct kprobe *p)
 out:
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
+	jump_label_unlock();
 	mutex_unlock(&kprobe_mutex);
 
 	if (probed_mod)
 		module_put(probed_mod);
 
 	return ret;
+
+fail_with_jump_label:
+	preempt_enable();
+	jump_label_unlock();
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
