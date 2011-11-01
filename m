Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab1KBAcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 20:32:33 -0400
Received: from claw.goop.org ([74.207.240.146]:40967 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1KBAc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 20:32:28 -0400
Message-ID: <4EB0748E.1070601@goop.org>
Date: Tue, 01 Nov 2011 15:37:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] make Jump Labels work early
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the series which makes jump labels work early.  Does someone want to pick this up, or
should I just send it to Linus directly?

[ I see Linus has already picked up the stop-machine patch from -mm. ]

Thanks,
	J

The following changes since commit a102a9ece5489e1718cd7543aa079082450ac3a2:

  Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/jump-label-noearly

Jeremy Fitzhardinge (9):
      jump_label: use proper atomic_t initializer
      stop_machine: make stop_machine safe and efficient to call early
      jump_label: if a key has already been initialized, don't nop it out
      x86/jump_label: drop arch_jump_label_text_poke_early()
      sparc/jump_label: drop arch_jump_label_text_poke_early()
      jump_label: add arch_jump_label_transform_static() to optimise non-live code updates
      s390/jump-label: add arch_jump_label_transform_static()
      x86/jump_label: add arch_jump_label_transform_static()
      jump-label: initialize jump-label subsystem much earlier

 arch/s390/kernel/jump_label.c  |   51 ++++++++++++++++++++++++---------------
 arch/sparc/kernel/jump_label.c |    8 ------
 arch/x86/kernel/jump_label.c   |   20 +++++++++++----
 include/linux/jump_label.h     |   23 +++++++++++-------
 init/main.c                    |    3 ++
 kernel/jump_label.c            |   37 ++++++++++++++++------------
 kernel/stop_machine.c          |   22 +++++++++++++++++
 7 files changed, 105 insertions(+), 59 deletions(-)

diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 44cc06b..b987ab2 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -18,26 +18,15 @@ struct insn {
 } __packed;
 
 struct insn_args {
-	unsigned long *target;
-	struct insn *insn;
-	ssize_t size;
+	struct jump_entry *entry;
+	enum jump_label_type type;
 };
 
-static int __arch_jump_label_transform(void *data)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type)
 {
-	struct insn_args *args = data;
-	int rc;
-
-	rc = probe_kernel_write(args->target, args->insn, args->size);
-	WARN_ON_ONCE(rc < 0);
-	return 0;
-}
-
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
-{
-	struct insn_args args;
 	struct insn insn;
+	int rc;
 
 	if (type == JUMP_LABEL_ENABLE) {
 		/* brcl 15,offset */
@@ -49,11 +38,33 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		insn.offset = 0;
 	}
 
-	args.target = (void *) entry->code;
-	args.insn = &insn;
-	args.size = JUMP_LABEL_NOP_SIZE;
+	rc = probe_kernel_write((void *)entry->code, &insn, JUMP_LABEL_NOP_SIZE);
+	WARN_ON_ONCE(rc < 0);
+}
 
-	stop_machine(__arch_jump_label_transform, &args, NULL);
+static int __sm_arch_jump_label_transform(void *data)
+{
+	struct insn_args *args = data;
+
+	__jump_label_transform(args->entry, args->type);
+	return 0;
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	struct insn_args args;
+
+	args.entry = entry;
+	args.type = type;
+
+	stop_machine(__sm_arch_jump_label_transform, &args, NULL);
+}
+
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type)
+{
+	__jump_label_transform(entry, type);
 }
 
 #endif
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index ea2dafc..971fd43 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -36,12 +36,4 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
-{
-	u32 *insn_p = (u32 *) (unsigned long) addr;
-
-	*insn_p = 0x01000000;
-	flushi(insn_p);
-}
-
 #endif
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..ea9d5f2f 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,8 +24,9 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type,
+				   void *(*poker)(void *, const void *, size_t))
 {
 	union jump_code_union code;
 
@@ -35,17 +36,24 @@ void arch_jump_label_transform(struct jump_entry *entry,
 				(entry->code + JUMP_LABEL_NOP_SIZE);
 	} else
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+
+	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	__jump_label_transform(entry, type, text_poke_smp);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type)
 {
-	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
-			JUMP_LABEL_NOP_SIZE);
+	__jump_label_transform(entry, type, text_poke_early);
 }
 
 #endif
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 66f23dc..388b0d4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -16,7 +16,7 @@ struct jump_label_key {
 
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
-#endif
+#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
 
 enum jump_label_type {
 	JUMP_LABEL_DISABLE = 0,
@@ -28,9 +28,9 @@ struct module;
 #ifdef HAVE_JUMP_LABEL
 
 #ifdef CONFIG_MODULES
-#define JUMP_LABEL_INIT {{ 0 }, NULL, NULL}
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL, NULL}
 #else
-#define JUMP_LABEL_INIT {{ 0 }, NULL}
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
 #endif
 
 static __always_inline bool static_branch(struct jump_label_key *key)
@@ -41,18 +41,20 @@ static __always_inline bool static_branch(struct jump_label_key *key)
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
+extern void jump_label_init(void);
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
-				 enum jump_label_type type);
-extern void arch_jump_label_text_poke_early(jump_label_t addr);
+				      enum jump_label_type type);
+extern void arch_jump_label_transform_static(struct jump_entry *entry,
+					     enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#else
+#else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
@@ -62,6 +64,10 @@ struct jump_label_key {
 	atomic_t enabled;
 };
 
+static __always_inline void jump_label_init(void)
+{
+}
+
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
@@ -96,7 +102,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 {
 	return 0;
 }
+#endif	/* HAVE_JUMP_LABEL */
 
-#endif
-
-#endif
+#endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/init/main.c b/init/main.c
index 2a9b88a..29d8d84 100644
--- a/init/main.c
+++ b/init/main.c
@@ -515,6 +515,9 @@ asmlinkage void __init start_kernel(void)
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
+
+	jump_label_init();
+
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..bbdfe2a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -104,6 +104,18 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
 	return 0;
 }
 
+/* 
+ * Update code which is definitely not currently executing.
+ * Architectures which need heavyweight synchronization to modify
+ * running code can override this to make the non-live update case
+ * cheaper.
+ */
+void __weak arch_jump_label_transform_static(struct jump_entry *entry,
+					    enum jump_label_type type)
+{
+	arch_jump_label_transform(entry, type);	
+}
+
 static void __jump_label_update(struct jump_label_key *key,
 				struct jump_entry *entry,
 				struct jump_entry *stop, int enable)
@@ -121,14 +133,7 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
-/*
- * Not all archs need this.
- */
-void __weak arch_jump_label_text_poke_early(jump_label_t addr)
-{
-}
-
-static __init int jump_label_init(void)
+void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
 	struct jump_entry *iter_stop = __stop___jump_table;
@@ -139,22 +144,22 @@ static __init int jump_label_init(void)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		arch_jump_label_text_poke_early(iter->code);
-		if (iter->key == (jump_label_t)(unsigned long)key)
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
+						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		if (iterk == key)
 			continue;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
-		atomic_set(&key->enabled, 0);
+		key = iterk;
 		key->entries = iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
 #endif
 	}
 	jump_label_unlock();
-
-	return 0;
 }
-early_initcall(jump_label_init);
 
 #ifdef CONFIG_MODULES
 
@@ -212,7 +217,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_text_poke_early(iter->code);
+		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
 }
 
 static int jump_label_add_module(struct module *mod)
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ba5070c..d3f960a 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -41,6 +41,7 @@ struct cpu_stopper {
 };
 
 static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+static bool stop_machine_initialized = false;
 
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
@@ -386,6 +387,8 @@ static int __init cpu_stop_init(void)
 	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
 	register_cpu_notifier(&cpu_stop_cpu_notifier);
 
+	stop_machine_initialized = true;
+
 	return 0;
 }
 early_initcall(cpu_stop_init);
@@ -485,6 +488,25 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (!stop_machine_initialized) {
+		/*
+		 * Handle the case where stop_machine() is called
+		 * early in boot before stop_machine() has been
+		 * initialized.
+		 */
+ 		unsigned long flags;
+		int ret;
+
+		WARN_ON_ONCE(smdata.num_threads != 1);
+
+		local_irq_save(flags);
+		hard_irq_disable();
+		ret = (*fn)(data);
+		local_irq_restore(flags);
+
+		return ret;
+	}
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);


