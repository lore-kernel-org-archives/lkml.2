Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab0LFSRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:17:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:48050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab0LFSRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:17:20 -0500
Date: Mon, 6 Dec 2010 18:16:50 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101203095409.2961.82733.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095409.2961.82733.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Support delayed unoptimizing
Message-ID: <tip-6274de4984a630b45c6934b3ee62e5692c745328@git.kernel.org>
Git-Commit-ID: 6274de4984a630b45c6934b3ee62e5692c745328
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6274de4984a630b45c6934b3ee62e5692c745328
Gitweb:     http://git.kernel.org/tip/6274de4984a630b45c6934b3ee62e5692c745328
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:54:09 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:30 +0100

kprobes: Support delayed unoptimizing

Unoptimization occurs when a probe is unregistered or disabled,
and is heavy because it recovers instructions by using
stop_machine(). This patch delays unoptimization operations and
unoptimize several probes at once by using
text_poke_smp_batch(). This can avoid unexpected system slowdown
coming from stop_machine().

Changes in v5:
- Split this patch into several cleanup patches and this patch.
- Fix some text_mutex lock miss.
- Use bool instead of int for behavior flags.
- Add additional comment for (un)optimizing path.

Changes in v2:
- Use dynamic allocated buffers and params.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101203095409.2961.82733.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    4 +
 kernel/kprobes.c          |  310 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 237 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1cbd54c..da51dc8 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1184,6 +1184,10 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	/* This is possible if op is under delayed unoptimizing */
+	if (kprobe_disabled(&op->kp))
+		return;
+
 	preempt_disable();
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(&op->kp);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1f4f9b9..ba4d4c0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -354,6 +354,13 @@ static inline int kprobe_aggrprobe(struct kprobe *p)
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
@@ -384,6 +391,17 @@ void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
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
@@ -397,6 +415,33 @@ static inline int kprobe_optready(struct kprobe *p)
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
 /*
  * Return an optimized kprobe whose optimizing code replaces
  * instructions including addr (exclude breakpoint).
@@ -422,9 +467,11 @@ static struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
 
 /* Optimization staging list, protected by kprobe_mutex */
 static LIST_HEAD(optimizing_list);
+static LIST_HEAD(unoptimizing_list);
 
 static void kprobe_optimizer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
+static DECLARE_COMPLETION(optimizer_comp);
 #define OPTIMIZE_DELAY 5
 
 /*
@@ -435,6 +482,11 @@ static __kprobes void do_optimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
+	/* Optimization never be done when disarmed */
+	if (kprobes_all_disarmed || !kprobes_allow_optimization ||
+	    list_empty(&optimizing_list))
+		return;
+
 	/*
 	 * The optimization/unoptimization refers online_cpus via
 	 * stop_machine() and cpu-hotplug modifies online_cpus.
@@ -457,17 +509,79 @@ static __kprobes void do_optimize_kprobes(void)
 	put_online_cpus();
 }
 
+/*
+ * Unoptimize (replace a jump with a breakpoint and remove the breakpoint
+ * if need) kprobes listed on unoptimizing_list.
+ */
+static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	/* Unoptimization must be done anytime */
+	if (list_empty(&unoptimizing_list))
+		return;
+
+	/* Ditto to do_optimize_kprobes */
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	list_for_each_entry_safe(op, tmp, &unoptimizing_list, list) {
+		/* Unoptimize kprobes */
+		arch_unoptimize_kprobe(op);
+		/* Disarm probes if marked disabled */
+		if (kprobe_disabled(&op->kp))
+			arch_disarm_kprobe(&op->kp);
+		if (kprobe_unused(&op->kp)) {
+			/*
+			 * Remove unused probes from hash list. After waiting
+			 * for synchronization, these probes are reclaimed.
+			 * (reclaiming is done by do_free_cleaned_kprobes.)
+			 */
+			hlist_del_rcu(&op->kp.hlist);
+			/* Move only unused probes on free_list */
+			list_move(&op->list, free_list);
+		} else
+			list_del_init(&op->list);
+	}
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+}
+
+/* Reclaim all kprobes on the free_list */
+static __kprobes void do_free_cleaned_kprobes(struct list_head *free_list)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, free_list, list) {
+		BUG_ON(!kprobe_unused(&op->kp));
+		list_del_init(&op->list);
+		free_aggr_kprobe(&op->kp);
+	}
+}
+
+/* Start optimizer after OPTIMIZE_DELAY passed */
+static __kprobes void kick_kprobe_optimizer(void)
+{
+	if (!delayed_work_pending(&optimizing_work))
+		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+}
+
 /* Kprobe jump optimizer */
 static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
+	LIST_HEAD(free_list);
+
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
 	mutex_lock(&kprobe_mutex);
-	if (kprobes_all_disarmed || !kprobes_allow_optimization)
-		goto end;
 
 	/*
-	 * Wait for quiesence period to ensure all running interrupts
+	 * Step 1: Unoptimize kprobes and collect cleaned (unused and disarmed)
+	 * kprobes before waiting for quiesence period.
+	 */
+	do_unoptimize_kprobes(&free_list);
+
+	/*
+	 * Step 2: Wait for quiesence period to ensure all running interrupts
 	 * are done. Because optprobe may modify multiple instructions
 	 * there is a chance that Nth instruction is interrupted. In that
 	 * case, running interrupt can return to 2nd-Nth byte of jump
@@ -475,10 +589,24 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	 */
 	synchronize_sched();
 
+	/* Step 3: Optimize kprobes after quiesence period */
 	do_optimize_kprobes();
-end:
+
+	/* Step 4: Free cleaned kprobes after quiesence period */
+	do_free_cleaned_kprobes(&free_list);
+
 	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
+
+	/* Wake up all waiters */
+	complete_all(&optimizer_comp);
+}
+
+/* Wait for completing optimization and unoptimization */
+static __kprobes void wait_for_kprobe_optimizer(void)
+{
+	if (delayed_work_pending(&optimizing_work))
+		wait_for_completion(&optimizer_comp);
 }
 
 /* Optimize kprobe if p is ready to be optimized */
@@ -504,27 +632,63 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 	/* Check if it is already optimized. */
 	if (op->kp.flags & KPROBE_FLAG_OPTIMIZED)
 		return;
-
 	op->kp.flags |= KPROBE_FLAG_OPTIMIZED;
-	list_add(&op->list, &optimizing_list);
-	if (!delayed_work_pending(&optimizing_work))
-		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+
+	if (!list_empty(&op->list))
+		/* This is under unoptimizing. Just dequeue the probe */
+		list_del_init(&op->list);
+	else {
+		list_add(&op->list, &optimizing_list);
+		kick_kprobe_optimizer();
+	}
+}
+
+/* Short cut to direct unoptimizing */
+static __kprobes void force_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	get_online_cpus();
+	arch_unoptimize_kprobe(op);
+	put_online_cpus();
+	if (kprobe_disabled(&op->kp))
+		arch_disarm_kprobe(&op->kp);
 }
 
 /* Unoptimize a kprobe if p is optimized */
-static __kprobes void unoptimize_kprobe(struct kprobe *p)
+static __kprobes void unoptimize_kprobe(struct kprobe *p, bool force)
 {
 	struct optimized_kprobe *op;
 
-	if ((p->flags & KPROBE_FLAG_OPTIMIZED) && kprobe_aggrprobe(p)) {
-		op = container_of(p, struct optimized_kprobe, kp);
-		if (!list_empty(&op->list))
-			/* Dequeue from the optimization queue */
+	if (!kprobe_aggrprobe(p) || kprobe_disarmed(p))
+		return; /* This is not an optprobe nor optimized */
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	if (!kprobe_optimized(p)) {
+		/* Unoptimized or unoptimizing case */
+		if (force && !list_empty(&op->list)) {
+			/*
+			 * Only if this is unoptimizing kprobe and forced,
+			 * forcibly unoptimize it. (No need to unoptimize
+			 * unoptimized kprobe again :)
+			 */
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
+	/* Optimized kprobe case */
+	if (force)
+		/* Forcibly update the code: this is a special case */
+		force_unoptimize_kprobe(op);
+	else {
+		list_add(&op->list, &unoptimizing_list);
+		kick_kprobe_optimizer();
 	}
 }
 
@@ -534,12 +698,12 @@ static void __kprobes kill_optimized_kprobe(struct kprobe *p)
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
+
+	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	/* Don't touch the code, because it is already freed. */
 	arch_remove_optimized_kprobe(op);
 }
 
@@ -552,16 +716,6 @@ static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
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
@@ -596,7 +750,8 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 	op = container_of(ap, struct optimized_kprobe, kp);
 	if (!arch_prepared_optinsn(&op->optinsn)) {
 		/* If failed to setup optimizing, fallback to kprobe */
-		free_aggr_kprobe(ap);
+		arch_remove_optimized_kprobe(op);
+		kfree(op);
 		return;
 	}
 
@@ -640,21 +795,16 @@ static void __kprobes unoptimize_all_kprobes(void)
 		return;
 
 	kprobes_allow_optimization = false;
-	printk(KERN_INFO "Kprobes globally unoptimized\n");
-	get_online_cpus();	/* For avoiding text_mutex deadlock */
-	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!kprobe_disabled(p))
-				unoptimize_kprobe(p);
+				unoptimize_kprobe(p, false);
 		}
 	}
-
-	mutex_unlock(&text_mutex);
-	put_online_cpus();
-	/* Allow all currently running kprobes to complete */
-	synchronize_sched();
+	/* Wait for unoptimizing completion */
+	wait_for_kprobe_optimizer();
+	printk(KERN_INFO "Kprobes globally unoptimized\n");
 }
 
 int sysctl_kprobes_optimization;
@@ -678,6 +828,7 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 }
 #endif /* CONFIG_SYSCTL */
 
+/* Put a breakpoint for a probe. Must be called with text_mutex locked */
 static void __kprobes __arm_kprobe(struct kprobe *p)
 {
 	struct kprobe *_p;
@@ -685,37 +836,45 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 	/* Check collision with other optimized kprobes */
 	_p = get_optimized_kprobe((unsigned long)p->addr);
 	if (unlikely(_p))
-		unoptimize_kprobe(_p); /* Fallback to unoptimized kprobe */
+		/* Fallback to unoptimized kprobe */
+		unoptimize_kprobe(_p, true);
 
 	arch_arm_kprobe(p);
 	optimize_kprobe(p);	/* Try to optimize (add kprobe to a list) */
 }
 
-static void __kprobes __disarm_kprobe(struct kprobe *p)
+/* Remove the breakpoint of a probe. Must be called with text_mutex locked */
+static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
 {
 	struct kprobe *_p;
 
-	unoptimize_kprobe(p);	/* Try to unoptimize */
-	arch_disarm_kprobe(p);
+	unoptimize_kprobe(p, false);	/* Try to unoptimize */
 
-	/* If another kprobe was blocked, optimize it. */
-	_p = get_optimized_kprobe((unsigned long)p->addr);
-	if (unlikely(_p))
-		optimize_kprobe(_p);
+	if (!kprobe_queued(p)) {
+		arch_disarm_kprobe(p);
+		/* If another kprobe was blocked, optimize it. */
+		_p = get_optimized_kprobe((unsigned long)p->addr);
+		if (unlikely(_p) && reopt)
+			optimize_kprobe(_p);
+	}
+	/* TODO: reoptimize others after unoptimized this probe */
 }
 
 #else /* !CONFIG_OPTPROBES */
 
 #define optimize_kprobe(p)			do {} while (0)
-#define unoptimize_kprobe(p)			do {} while (0)
+#define unoptimize_kprobe(p, f)			do {} while (0)
 #define kill_optimized_kprobe(p)		do {} while (0)
 #define prepare_optimized_kprobe(p)		do {} while (0)
 #define try_to_optimize_kprobe(p)		do {} while (0)
 #define __arm_kprobe(p)				arch_arm_kprobe(p)
-#define __disarm_kprobe(p)			arch_disarm_kprobe(p)
+#define __disarm_kprobe(p, o)			arch_disarm_kprobe(p)
+#define kprobe_disarmed(p)			kprobe_disabled(p)
+#define wait_for_kprobe_optimizer()		do {} while (0)
 
 static __kprobes void free_aggr_kprobe(struct kprobe *p)
 {
+	arch_remove_kprobe(p);
 	kfree(p);
 }
 
@@ -741,11 +900,10 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
 /* Disarm a kprobe with text_mutex */
 static void __kprobes disarm_kprobe(struct kprobe *kp)
 {
-	get_online_cpus();	/* For avoiding text_mutex deadlock */
+	/* Ditto */
 	mutex_lock(&text_mutex);
-	__disarm_kprobe(kp);
+	__disarm_kprobe(kp, true);
 	mutex_unlock(&text_mutex);
-	put_online_cpus();
 }
 
 /*
@@ -951,7 +1109,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
 
 	if (p->break_handler || p->post_handler)
-		unoptimize_kprobe(ap);	/* Fall back to normal kprobe */
+		unoptimize_kprobe(ap, true);	/* Fall back to normal kprobe */
 
 	if (p->break_handler) {
 		if (ap->break_handler)
@@ -1014,7 +1172,9 @@ static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 		if (!ap)
 			return -ENOMEM;
 		init_aggr_kprobe(ap, orig_p);
-	}
+	} else if (kprobe_unused(ap))
+		/* Busy to die */
+		return -EBUSY;
 
 	if (kprobe_gone(ap)) {
 		/*
@@ -1283,8 +1443,11 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 	/* Following process expects this probe is an aggrprobe */
 	WARN_ON(!kprobe_aggrprobe(ap));
 
-	if (list_is_singular(&ap->list))
-		/* This probe is the last child of aggrprobe */
+	if (list_is_singular(&ap->list) && kprobe_disarmed(ap))
+		/*
+		 * !disarmed could be happen if the probe is under delayed
+		 * unoptimizing.
+		 */
 		goto disarmed;
 	else {
 		/* If disabling probe has special handlers, update aggrprobe */
@@ -1313,6 +1476,7 @@ noclean:
 	return 0;
 
 disarmed:
+	BUG_ON(!kprobe_disarmed(ap));
 	hlist_del_rcu(&ap->hlist);
 	return 0;
 }
@@ -1322,14 +1486,15 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 	struct kprobe *ap;
 
 	if (list_empty(&p->list))
+		/* This is an independent kprobe */
 		arch_remove_kprobe(p);
 	else if (list_is_singular(&p->list)) {
-		/* "p" is the last child of an aggr_kprobe */
+		/* This is the last child of an aggrprobe */
 		ap = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
-		arch_remove_kprobe(ap);
 		free_aggr_kprobe(ap);
 	}
+	/* Otherwise, do nothing. */
 }
 
 int __kprobes register_kprobes(struct kprobe **kps, int num)
@@ -1951,36 +2116,27 @@ static void __kprobes disarm_all_kprobes(void)
 	mutex_lock(&kprobe_mutex);
 
 	/* If kprobes are already disarmed, just return */
-	if (kprobes_all_disarmed)
-		goto already_disabled;
+	if (kprobes_all_disarmed) {
+		mutex_unlock(&kprobe_mutex);
+		return;
+	}
 
 	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
 
-	/*
-	 * Here we call get_online_cpus() for avoiding text_mutex deadlock,
-	 * because disarming may also unoptimize kprobes.
-	 */
-	get_online_cpus();
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
-				__disarm_kprobe(p);
+				__disarm_kprobe(p, false);
 		}
 	}
-
 	mutex_unlock(&text_mutex);
-	put_online_cpus();
 	mutex_unlock(&kprobe_mutex);
-	/* Allow all currently running kprobes to complete */
-	synchronize_sched();
-	return;
 
-already_disabled:
-	mutex_unlock(&kprobe_mutex);
-	return;
+	/* Wait for disarming all kprobes by optimizer */
+	wait_for_kprobe_optimizer();
 }
 
 /*
