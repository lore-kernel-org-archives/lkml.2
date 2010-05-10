Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0EJRsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0EJRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:48:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 5/5] kprobes: Support delayed unoptimization
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 10 May 2010 13:53:47 -0400
Message-ID: <20100510175347.27396.61963.stgit@localhost6.localdomain6>
In-Reply-To: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unoptimization occurs when a probe is unregistered or disabled, and
is heavy because it recovers instructions by using stop_machine().
This patch delays unoptimization operations and unoptimize several
probes at once by using text_poke_smp_batch().
This can avoid unexpected system slowdown coming from stop_machine().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 arch/x86/include/asm/kprobes.h |    4 
 arch/x86/kernel/kprobes.c      |   41 ++++
 include/linux/kprobes.h        |    2 
 kernel/kprobes.c               |  434 +++++++++++++++++++++++++++-------------
 4 files changed, 340 insertions(+), 141 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5478825..e8a864c 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -79,12 +79,12 @@ struct arch_specific_insn {
 };
 
 struct arch_optimized_insn {
-	/* copy of the original instructions */
-	kprobe_opcode_t copied_insn[RELATIVE_ADDR_SIZE];
 	/* detour code buffer */
 	kprobe_opcode_t *insn;
 	/* the size of instructions copied to detour code buffer */
 	size_t size;
+	/* copy of the original instructions */
+	kprobe_opcode_t copied_insn[RELATIVE_ADDR_SIZE];
 };
 
 /* Return true (!0) if optinsn is prepared for optimization. */
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 63a5c24..bd5ea3a 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1167,6 +1167,10 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	/* This is possible if op is under delayed unoptimizing */
+	if (kprobe_disabled(&op->kp))
+		return;
+
 	preempt_disable();
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(&op->kp);
@@ -1431,6 +1435,19 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 	text_poke_smp_batch(jump_params, c);
 }
 
+static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
+					      char *insn_buf,
+					      struct optimized_kprobe *op)
+{
+	/* Set int3 to first byte for kprobes */
+	insn_buf[0] = BREAKPOINT_INSTRUCTION;
+	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+
+	tprm->addr = op->kp.addr;
+	tprm->opcode = insn_buf;
+	tprm->len = RELATIVEJUMP_SIZE;
+}
+
 /* Replace a relative jump with a breakpoint (int3).  */
 void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
@@ -1442,6 +1459,30 @@ void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
 }
 
+extern void arch_unoptimize_kprobes(struct list_head *oplist,
+				    struct list_head *done_list)
+{
+	struct optimized_kprobe *op, *tmp;
+	int c = 0;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		/* Setup param */
+		setup_unoptimize_kprobe(&jump_params[c], jump_code_buf[c], op);
+		list_del_init(&op->list);
+		list_add(&op->list, done_list);
+		if (++c >= MAX_OPTIMIZE_PROBES)
+			break;
+	}
+
+	/*
+	 * text_poke_smp doesn't support NMI/MCE code modifying.
+	 * However, since kprobes itself also doesn't support NMI/MCE
+	 * code probing, it's not a problem.
+	 */
+	text_poke_smp_batch(jump_params, c);
+}
+
+
 static int  __kprobes setup_detour_execution(struct kprobe *p,
 					     struct pt_regs *regs,
 					     int reenter)
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index fe157ba..b78edb5 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -276,6 +276,8 @@ extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
 extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
 extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
 extern void arch_optimize_kprobes(struct list_head *oplist);
+extern void arch_unoptimize_kprobes(struct list_head *oplist,
+				    struct list_head *done_list);
 extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
 extern kprobe_opcode_t *get_optinsn_slot(void);
 extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c824c23..08298ed 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -352,6 +352,13 @@ static inline int kprobe_aggrprobe(struct kprobe *p)
 	return p->pre_handler == aggr_pre_handler;
 }
 
+/* Return true(!0) if the kprobe is unused */
+static inline int kprobe_unused(struct kprobe *p)
+{
+	return kprobe_aggrprobe(p) && kprobe_disabled(p) &&
+	       list_empty(&p->list);
+}
+
 /*
  * Keep all fields in the kprobe consistent
  */
@@ -382,6 +389,17 @@ void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 }
 
+/* Free optimized instructions and optimized_kprobe */
+static __kprobes void free_aggr_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	arch_remove_optimized_kprobe(op);
+	arch_remove_kprobe(p);
+	kfree(op);
+}
+
 /* Return true(!0) if the kprobe is ready for optimization. */
 static inline int kprobe_optready(struct kprobe *p)
 {
@@ -395,6 +413,20 @@ static inline int kprobe_optready(struct kprobe *p)
 	return 0;
 }
 
+/* Return true(!0) if the kprobe is disarmed. Note: p must be on hash list */
+static inline int kprobe_disarmed(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	/* If kprobe is not aggr/opt probe, just return kprobe is disabled */
+	if (!kprobe_aggrprobe(p))
+		return kprobe_disabled(p);
+
+	op = container_of(p, struct optimized_kprobe, kp);
+
+	return kprobe_disabled(p) && list_empty(&op->list);
+}
+
 /*
  * Return an optimized kprobe whose optimizing code replaces
  * instructions including addr (exclude breakpoint).
@@ -420,29 +452,19 @@ struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
 
 /* Optimization staging list, protected by kprobe_mutex */
 static LIST_HEAD(optimizing_list);
+static LIST_HEAD(unoptimizing_list);
 
 static void kprobe_optimizer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
 #define OPTIMIZE_DELAY 5
+static DECLARE_COMPLETION(optimizer_comp);
 
-/* Kprobe jump optimizer */
-static __kprobes void kprobe_optimizer(struct work_struct *work)
+static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 {
-	/* Lock modules while optimizing kprobes */
-	mutex_lock(&module_mutex);
-	mutex_lock(&kprobe_mutex);
-	if (kprobes_all_disarmed || !kprobes_allow_optimization)
-		goto end;
-
-	/*
-	 * Wait for quiesence period to ensure all running interrupts
-	 * are done. Because optprobe may modify multiple instructions
-	 * there is a chance that Nth instruction is interrupted. In that
-	 * case, running interrupt can return to 2nd-Nth byte of jump
-	 * instruction. This wait is for avoiding it.
-	 */
-	synchronize_sched();
+	struct optimized_kprobe *op, *tmp;
 
+	if (list_empty(&unoptimizing_list))
+		return;
 	/*
 	 * The optimization/unoptimization refers online_cpus via
 	 * stop_machine() and cpu-hotplug modifies online_cpus.
@@ -455,14 +477,93 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	 */
 	get_online_cpus();
 	mutex_lock(&text_mutex);
+	/* Do batch unoptimization */
+	arch_unoptimize_kprobes(&unoptimizing_list, free_list);
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+
+	list_for_each_entry_safe(op, tmp, free_list, list) {
+		/* Disarm probes if disabled */
+		if (kprobe_disabled(&op->kp))
+			arch_disarm_kprobe(&op->kp);
+		/* leave only unused probes on free_list */
+		if (!kprobe_unused(&op->kp))
+			list_del_init(&op->list);
+		else
+			/*
+			 * Remove unused probe from hash list. After waiting
+			 * for synchronization, this probe can be freed safely
+			 * (which will be freed by do_free_unused_kprobes.)
+			 */
+			hlist_del_rcu(&op->kp.hlist);
+	}
+}
+
+static __kprobes void do_free_unused_kprobes(struct list_head *free_list)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, free_list, list) {
+		list_del_init(&op->list);
+		free_aggr_kprobe(&op->kp);
+	}
+}
+
+static __kprobes void do_optimize_kprobes(void)
+{
+	/* Optimization never allowed when disarmed */
+	if (kprobes_all_disarmed || !kprobes_allow_optimization ||
+	    list_empty(&optimizing_list))
+		return;
+
+	get_online_cpus();
+	mutex_lock(&text_mutex);
 	arch_optimize_kprobes(&optimizing_list);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
-	if (!list_empty(&optimizing_list))
-		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
-end:
+}
+
+/* Kprobe jump optimize/unoptimize and collect unused aggrprobes */
+static __kprobes void kprobe_optimizer(struct work_struct *work)
+{
+	LIST_HEAD(free_list);
+
+	/* Lock modules while optimizing kprobes */
+	mutex_lock(&module_mutex);
+	mutex_lock(&kprobe_mutex);
+
+	do_unoptimize_kprobes(&free_list);
+
+	/*
+	 * Wait for quiesence period to ensure all running interrupts
+	 * are done. Because optprobe may modify multiple instructions
+	 * there is a chance that Nth instruction is interrupted. In that
+	 * case, running interrupt can return to 2nd-Nth byte of jump
+	 * instruction. This wait is for avoiding it.
+	 */
+	synchronize_sched();
+
+	do_optimize_kprobes();
+
+	/* Release all releasable probes */
+	do_free_unused_kprobes(&free_list);
+
 	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
+
+	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
+		if (!delayed_work_pending(&optimizing_work))
+			schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+	} else
+		/* Wake up all waiters */
+		complete_all(&optimizer_comp);
+}
+
+/* Wait for completion */
+static __kprobes void wait_for_optimizer(void)
+{
+	if (delayed_work_pending(&optimizing_work))
+		wait_for_completion(&optimizer_comp);
 }
 
 /* Optimize kprobe if p is ready to be optimized */
@@ -475,6 +576,10 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 	    (kprobe_disabled(p) || kprobes_all_disarmed))
 		return;
 
+	/* Check if it is already optimized. */
+	if (kprobe_optimized(p))
+		return;
+
 	/* Both of break_handler and post_handler are not supported. */
 	if (p->break_handler || p->post_handler)
 		return;
@@ -485,45 +590,96 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 	if (arch_check_optimized_kprobe(op) < 0)
 		return;
 
-	/* Check if it is already optimized. */
-	if (op->kp.flags & KPROBE_FLAG_OPTIMIZED)
-		return;
-
 	op->kp.flags |= KPROBE_FLAG_OPTIMIZED;
-	list_add(&op->list, &optimizing_list);
-	if (!delayed_work_pending(&optimizing_work))
-		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+	if (!list_empty(&op->list))
+		/* Unoptimizing probe: dequeue probe */
+		list_del_init(&op->list);
+	else {
+		list_add(&op->list, &optimizing_list);
+		if (!delayed_work_pending(&optimizing_work))
+			schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+	}
 }
 
-/* Unoptimize a kprobe if p is optimized */
-static __kprobes void unoptimize_kprobe(struct kprobe *p)
+static __kprobes void force_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	get_online_cpus();
+	arch_unoptimize_kprobe(op);
+	put_online_cpus();
+	if (kprobe_disabled(&op->kp))
+		arch_disarm_kprobe(&op->kp);
+}
+
+/* Unoptimize a kprobe if p is optimized. */
+static __kprobes void unoptimize_kprobe(struct kprobe *p, int force)
 {
 	struct optimized_kprobe *op;
 
-	if ((p->flags & KPROBE_FLAG_OPTIMIZED) && kprobe_aggrprobe(p)) {
-		op = container_of(p, struct optimized_kprobe, kp);
-		if (!list_empty(&op->list))
-			/* Dequeue from the optimization queue */
+	if (!kprobe_aggrprobe(p) || kprobe_disarmed(p))
+		return;	/* This is not an optprobe nor optimized */
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	if (!kprobe_optimized(p)) {
+		/* Unoptimized or unoptimizing */
+		if (force && !list_empty(&op->list)) {
+			/*
+			 * If unoptimizing probe and forced option, forcibly
+			 * unoptimize it.
+			*/
 			list_del_init(&op->list);
-		else
-			/* Replace jump with break */
-			arch_unoptimize_kprobe(op);
-		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+			force_unoptimize_kprobe(op);
+		}
+		return;
+	}
+
+	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	if (!list_empty(&op->list)) {
+		/* Dequeue from the optimization queue */
+		list_del_init(&op->list);
+		return;
+	}
+
+	if (force)	/* Forcibly update the code: this is a special case */
+		force_unoptimize_kprobe(op);
+	else {
+		list_add(&op->list, &unoptimizing_list);
+		if (!delayed_work_pending(&optimizing_work))
+			schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
 	}
 }
 
+/* Cancel unoptimizing for reusing */
+static void reuse_unused_kprobe(struct kprobe *ap)
+{
+	struct optimized_kprobe *op;
+
+	BUG_ON(!kprobe_unused(ap));
+	/*
+	 * Unused kprobe MUST be on the way of delayed unoptimizing (means
+	 * there is still a relative jump) and disabled.
+	 */
+	op = container_of(ap, struct optimized_kprobe, kp);
+	if (unlikely(list_empty(&op->list)))
+		printk(KERN_WARNING "Warning: found a stray unused "
+			"aggrprobe@%p\n", ap->addr);
+	/* Enable the probe again */
+	ap->flags &= ~KPROBE_FLAG_DISABLED;
+	/* Optimize it again (remove from op->list) */
+	BUG_ON(!kprobe_optready(ap));
+	optimize_kprobe(ap);
+}
+
 /* Remove optimized instructions */
 static void __kprobes kill_optimized_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
 	op = container_of(p, struct optimized_kprobe, kp);
-	if (!list_empty(&op->list)) {
-		/* Dequeue from the optimization queue */
+	if (!list_empty(&op->list))
+		/* Dequeue from the (un)optimization queue */
 		list_del_init(&op->list);
-		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
-	}
-	/* Don't unoptimize, because the target code will be freed. */
+	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	/* Don't unoptimize, because the target code is already freed. */
 	arch_remove_optimized_kprobe(op);
 }
 
@@ -536,16 +692,6 @@ static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
 	arch_prepare_optimized_kprobe(op);
 }
 
-/* Free optimized instructions and optimized_kprobe */
-static __kprobes void free_aggr_kprobe(struct kprobe *p)
-{
-	struct optimized_kprobe *op;
-
-	op = container_of(p, struct optimized_kprobe, kp);
-	arch_remove_optimized_kprobe(op);
-	kfree(op);
-}
-
 /* Allocate new optimized_kprobe and try to prepare optimized instructions */
 static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 {
@@ -623,20 +769,15 @@ static void __kprobes unoptimize_all_kprobes(void)
 
 	kprobes_allow_optimization = false;
 	printk(KERN_INFO "Kprobes globally unoptimized\n");
-	get_online_cpus();	/* For avoiding text_mutex deadlock */
-	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!kprobe_disabled(p))
-				unoptimize_kprobe(p);
+				unoptimize_kprobe(p, 0);
 		}
 	}
-
-	mutex_unlock(&text_mutex);
-	put_online_cpus();
-	/* Allow all currently running kprobes to complete */
-	synchronize_sched();
+	/* Wait for unoptimizing completion */
+	wait_for_optimizer();
 }
 
 int sysctl_kprobes_optimization;
@@ -667,37 +808,64 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 	/* Check collision with other optimized kprobes */
 	old_p = get_optimized_kprobe((unsigned long)p->addr);
 	if (unlikely(old_p))
-		unoptimize_kprobe(old_p); /* Fallback to unoptimized kprobe */
+		unoptimize_kprobe(old_p, 1);/* Fallback to unoptimized kprobe */
 
 	arch_arm_kprobe(p);
 	optimize_kprobe(p);	/* Try to optimize (add kprobe to a list) */
 }
 
+/* Return true(!0) if the probe is queued on (un)optimizing lists */
+static int __kprobes kprobe_queued(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	if (kprobe_aggrprobe(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		if (!list_empty(&op->list))
+			return 1;
+	}
+	return 0;
+}
+
 static void __kprobes __disarm_kprobe(struct kprobe *p)
 {
 	struct kprobe *old_p;
 
-	unoptimize_kprobe(p);	/* Try to unoptimize */
-	arch_disarm_kprobe(p);
+	/* Delayed unoptimizing if needed (add kprobe to a list) */
+	if (kprobe_optimized(p))
+		unoptimize_kprobe(p, 0);
 
-	/* If another kprobe was blocked, optimize it. */
-	old_p = get_optimized_kprobe((unsigned long)p->addr);
-	if (unlikely(old_p))
-		optimize_kprobe(old_p);
+	if (!kprobe_queued(p)) {
+		arch_disarm_kprobe(p);
+		/* If another kprobe was blocked, optimize it. */
+		old_p = get_optimized_kprobe((unsigned long)p->addr);
+		if (unlikely(old_p))
+			optimize_kprobe(old_p);
+	}
 }
 
 #else /* !CONFIG_OPTPROBES */
 
 #define optimize_kprobe(p)			do {} while (0)
-#define unoptimize_kprobe(p)			do {} while (0)
+#define unoptimize_kprobe(p, f)			do {} while (0)
 #define kill_optimized_kprobe(p)		do {} while (0)
 #define prepare_optimized_kprobe(p)		do {} while (0)
 #define try_to_optimize_kprobe(p)		do {} while (0)
 #define __arm_kprobe(p)				arch_arm_kprobe(p)
 #define __disarm_kprobe(p)			arch_disarm_kprobe(p)
+#define kprobe_disarmed(p)			kprobe_disabled(p)
+#define wait_for_optimizer()			do {} while (0)
+
+/* There should be no unused kprobes can be reused without optimization */
+static void reuse_unused_kprobe(struct kprobe *ap)
+{
+	printk(KERN_ERR "Error: There should be no unused kprobe here.\n");
+	BUG_ON(kprobe_unused(ap));
+}
 
 static __kprobes void free_aggr_kprobe(struct kprobe *p)
 {
+	arch_remove_kprobe(ap);
 	kfree(p);
 }
 
@@ -720,16 +888,6 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
 	mutex_unlock(&text_mutex);
 }
 
-/* Disarm a kprobe with text_mutex */
-static void __kprobes disarm_kprobe(struct kprobe *kp)
-{
-	get_online_cpus();	/* For avoiding text_mutex deadlock */
-	mutex_lock(&text_mutex);
-	__disarm_kprobe(kp);
-	mutex_unlock(&text_mutex);
-	put_online_cpus();
-}
-
 /*
  * Aggregate handlers for multiple kprobes support - these handlers
  * take care of invoking the individual kprobe handlers on p->list
@@ -928,7 +1086,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
 
 	if (p->break_handler || p->post_handler)
-		unoptimize_kprobe(ap);	/* Fall back to normal kprobe */
+		unoptimize_kprobe(ap, 1);/* Fall back to normal kprobe */
 
 	if (p->break_handler) {
 		if (ap->break_handler)
@@ -991,7 +1149,9 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 		if (!ap)
 			return -ENOMEM;
 		init_aggr_kprobe(ap, old_p);
-	}
+	} else if (kprobe_unused(ap))
+		/* This probe is going to die. Rescue it */
+		reuse_unused_kprobe(ap);
 
 	if (kprobe_gone(ap)) {
 		/*
@@ -1025,23 +1185,6 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 	return add_new_kprobe(ap, p);
 }
 
-/* Try to disable aggr_kprobe, and return 1 if succeeded.*/
-static int __kprobes try_to_disable_aggr_kprobe(struct kprobe *p)
-{
-	struct kprobe *kp;
-
-	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (!kprobe_disabled(kp))
-			/*
-			 * There is an active probe on the list.
-			 * We can't disable aggr_kprobe.
-			 */
-			return 0;
-	}
-	p->flags |= KPROBE_FLAG_DISABLED;
-	return 1;
-}
-
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
@@ -1208,6 +1351,45 @@ out:
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
+/* Check if all probes on the aggrprobe are disabled */
+static int __kprobes aggr_kprobe_disabled(struct kprobe *ap)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &ap->list, list) {
+		if (!kprobe_disabled(kp))
+			/*
+			 * There is an active probe on the list.
+			 * We can't disable aggr_kprobe.
+			 */
+			return 0;
+	}
+	return 1;
+}
+
+/* Disable one kprobe: Make sure called under kprobe_mutex is locked */
+static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
+{
+	struct kprobe *orig_p;
+
+	/* Check whether specified probe is valid, and get real probe */
+	orig_p = __get_valid_kprobe(p);
+	if (unlikely(orig_p == NULL))
+		return NULL;
+
+	if (!kprobe_disabled(p)) {
+		if (p != orig_p)
+			p->flags |= KPROBE_FLAG_DISABLED;
+
+		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
+			__disarm_kprobe(orig_p);
+			orig_p->flags |= KPROBE_FLAG_DISABLED;
+		}
+	}
+
+	return orig_p;
+}
+
 /*
  * Unregister a kprobe without a scheduler synchronization.
  */
@@ -1215,22 +1397,18 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
 	struct kprobe *old_p, *list_p;
 
-	old_p = __get_valid_kprobe(p);
+	/* Disable kprobe. This will disarm it if needed. */
+	old_p = __disable_kprobe(p);
 	if (old_p == NULL)
 		return -EINVAL;
 
 	if (old_p == p ||
 	    (kprobe_aggrprobe(old_p) &&
-	     list_is_singular(&old_p->list))) {
-		/*
-		 * Only probe on the hash list. Disarm only if kprobes are
-		 * enabled and not gone - otherwise, the breakpoint would
-		 * already have been removed. We save on flushing icache.
-		 */
-		if (!kprobes_all_disarmed && !kprobe_disabled(old_p))
-			disarm_kprobe(old_p);
+	     list_is_singular(&old_p->list) && kprobe_disarmed(old_p)))
+		/* Only disarmed probe on the hash list or on aggr_probe */
 		hlist_del_rcu(&old_p->hlist);
-	} else {
+	else {
+		/* This probe is on an aggr_probe */
 		if (p->break_handler && !kprobe_gone(p))
 			old_p->break_handler = NULL;
 		if (p->post_handler && !kprobe_gone(p)) {
@@ -1242,16 +1420,12 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		}
 noclean:
 		list_del_rcu(&p->list);
-		if (!kprobe_disabled(old_p)) {
-			try_to_disable_aggr_kprobe(old_p);
-			if (!kprobes_all_disarmed) {
-				if (kprobe_disabled(old_p))
-					disarm_kprobe(old_p);
-				else
-					/* Try to optimize this probe again */
-					optimize_kprobe(old_p);
-			}
-		}
+		if (!kprobe_disabled(old_p) && !kprobes_all_disarmed)
+			/*
+			 * Try to optimize this probe again,
+			 * because post hander may be changed.
+			 */
+			optimize_kprobe(old_p);
 	}
 	return 0;
 }
@@ -1260,13 +1434,13 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 {
 	struct kprobe *old_p;
 
+	/* If this probe was removed from hlist, remove kprobes insn buffer */
 	if (list_empty(&p->list))
 		arch_remove_kprobe(p);
 	else if (list_is_singular(&p->list)) {
 		/* "p" is the last child of an aggr_kprobe */
 		old_p = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
-		arch_remove_kprobe(old_p);
 		free_aggr_kprobe(old_p);
 	}
 }
@@ -1308,6 +1482,7 @@ void __kprobes unregister_kprobes(struct kprobe **kps, int num)
 	mutex_unlock(&kprobe_mutex);
 
 	synchronize_sched();
+
 	for (i = 0; i < num; i++)
 		if (kps[i]->addr)
 			__unregister_kprobe_bottom(kps[i]);
@@ -1585,29 +1760,10 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 int __kprobes disable_kprobe(struct kprobe *kp)
 {
 	int ret = 0;
-	struct kprobe *p;
 
 	mutex_lock(&kprobe_mutex);
-
-	/* Check whether specified probe is valid. */
-	p = __get_valid_kprobe(kp);
-	if (unlikely(p == NULL)) {
+	if (__disable_kprobe(kp) == NULL)
 		ret = -EINVAL;
-		goto out;
-	}
-
-	/* If the probe is already disabled (or gone), just return */
-	if (kprobe_disabled(kp))
-		goto out;
-
-	kp->flags |= KPROBE_FLAG_DISABLED;
-	if (p != kp)
-		/* When kp != p, p is always enabled. */
-		try_to_disable_aggr_kprobe(p);
-
-	if (!kprobes_all_disarmed && kprobe_disabled(p))
-		disarm_kprobe(p);
-out:
 	mutex_unlock(&kprobe_mutex);
 	return ret;
 }
@@ -1928,8 +2084,8 @@ static void __kprobes disarm_all_kprobes(void)
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 	mutex_unlock(&kprobe_mutex);
-	/* Allow all currently running kprobes to complete */
-	synchronize_sched();
+
+	wait_for_optimizer();
 	return;
 
 already_disabled:


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
