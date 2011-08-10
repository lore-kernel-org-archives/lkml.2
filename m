Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1HJQbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:31:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1HJQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:30:40 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Du5YoVDdZcUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=HFjEG5xCVeIYrXOCwAkA:9 a=w_qylXXCnpOoYKAlJhUA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110810163039.000615163@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 10 Aug 2011 12:22:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 5/5][RFC] kprobes: Use ftrace hooks when probing ftrace nops
References: <20110810162222.017387055@goodmis.org>
Content-Disposition: inline; filename=0005-kprobes-Use-ftrace-hooks-when-probing-ftrace-nops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, if a probe is set at an ftrace nop, the probe will fail.

When -mfentry is used by ftrace (in the near future), the nop will be
at the beginning of the function. This will prevent kprobes from hooking
to the most common place that kprobes are attached.

Now that ftrace supports individual users as well as pt_regs passing,
kprobes can use the ftrace infrastructure when a probe is placed on
a ftrace nop.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kprobes.h |    6 ++
 kernel/kprobes.c        |  163 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 160 insertions(+), 9 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index dd7c12e..5742071 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/ftrace.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -112,6 +113,11 @@ struct kprobe {
 	/* copy of the original instruction */
 	struct arch_specific_insn ainsn;
 
+#ifdef CONFIG_FUNCTION_TRACER
+	/* If it is possible to use ftrace to probe */
+	struct ftrace_ops fops;
+#endif
+
 	/*
 	 * Indicates various status flags.
 	 * Protected by kprobe_mutex after this kprobe is registered.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e6c25eb..2160768 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -102,6 +102,31 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{NULL}    /* Terminator */
 };
 
+#ifdef CONFIG_FUNCTION_TRACER
+/* kprobe stub function for use when probe is not connected to ftrace */
+static void
+kprobe_ftrace_stub(unsigned long ip, unsigned long pip,
+		   struct ftrace_ops *op, struct pt_regs *pt_regs)
+{
+}
+
+static bool ftrace_kprobe(struct kprobe *p)
+{
+	return p->fops.func && p->fops.func != kprobe_ftrace_stub;
+}
+
+static void init_non_ftrace_kprobe(struct kprobe *p)
+{
+	p->fops.func = kprobe_ftrace_stub;
+}
+
+#else
+static bool ftrace_kprobe(struct kprobe *p)
+{
+	return false;
+}
+#endif
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -396,6 +421,9 @@ static __kprobes void free_aggr_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
+	if (ftrace_kprobe(p))
+		return;
+
 	op = container_of(p, struct optimized_kprobe, kp);
 	arch_remove_optimized_kprobe(op);
 	arch_remove_kprobe(p);
@@ -759,6 +787,9 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 	struct kprobe *ap;
 	struct optimized_kprobe *op;
 
+	if (ftrace_kprobe(p))
+		return;
+
 	ap = alloc_aggr_kprobe(p);
 	if (!ap)
 		return;
@@ -849,6 +880,10 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 {
 	struct kprobe *_p;
 
+	/* Only arm non-ftrace probes */
+	if (ftrace_kprobe(p))
+		return;
+
 	/* Check collision with other optimized kprobes */
 	_p = get_optimized_kprobe((unsigned long)p->addr);
 	if (unlikely(_p))
@@ -864,6 +899,10 @@ static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
 {
 	struct kprobe *_p;
 
+	/* Only disarm non-ftrace probes */
+	if (ftrace_kprobe(p))
+		return;
+
 	unoptimize_kprobe(p, false);	/* Try to unoptimize */
 
 	if (!kprobe_queued(p)) {
@@ -878,13 +917,26 @@ static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
 
 #else /* !CONFIG_OPTPROBES */
 
+static void __kprobes __arm_kprobe(struct kprobe *p)
+{
+	/* Only arm non-ftrace probes */
+	if (!ftrace_kprobe(p))
+		arch_arm_kprobe(p);
+}
+
+/* Remove the breakpoint of a probe. Must be called with text_mutex locked */
+static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
+{
+	/* Only disarm non-ftrace probes */
+	if (!ftrace_kprobe(p))
+		arch_disarm_kprobe(p);
+}
+
 #define optimize_kprobe(p)			do {} while (0)
 #define unoptimize_kprobe(p, f)			do {} while (0)
 #define kill_optimized_kprobe(p)		do {} while (0)
 #define prepare_optimized_kprobe(p)		do {} while (0)
 #define try_to_optimize_kprobe(p)		do {} while (0)
-#define __arm_kprobe(p)				arch_arm_kprobe(p)
-#define __disarm_kprobe(p, o)			arch_disarm_kprobe(p)
 #define kprobe_disarmed(p)			kprobe_disabled(p)
 #define wait_for_kprobe_optimizer()		do {} while (0)
 
@@ -897,7 +949,9 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 
 static __kprobes void free_aggr_kprobe(struct kprobe *p)
 {
-	arch_remove_kprobe(p);
+
+	if (!ftrace_kprobe(p))
+		arch_remove_kprobe(p);
 	kfree(p);
 }
 
@@ -910,6 +964,12 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 /* Arm a kprobe with text_mutex */
 static void __kprobes arm_kprobe(struct kprobe *kp)
 {
+	/* ftrace probes can skip arch calls */
+	if (ftrace_kprobe(kp)) {
+		register_ftrace_function(&kp->fops);
+		return;
+	}
+
 	/*
 	 * Here, since __arm_kprobe() doesn't use stop_machine(),
 	 * this doesn't cause deadlock on text_mutex. So, we don't
@@ -924,6 +984,12 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
 static void __kprobes disarm_kprobe(struct kprobe *kp)
 {
 	/* Ditto */
+
+	if (ftrace_kprobe(kp)) {
+		unregister_ftrace_function(&kp->fops);
+		return;
+	}
+
 	mutex_lock(&text_mutex);
 	__disarm_kprobe(kp, true);
 	mutex_unlock(&text_mutex);
@@ -1313,6 +1379,56 @@ static inline int check_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
+#ifdef CONFIG_FUNCTION_TRACER
+static notrace void
+kprobe_ftrace_callback(unsigned long ip, unsigned long parent_ip,
+		       struct ftrace_ops *op, struct pt_regs *pt_regs)
+{
+	struct kprobe *p = container_of(op, struct kprobe, fops);
+
+	/* A nop has been trapped, just run both handlers back to back */
+	if (p->pre_handler)
+		p->pre_handler(p, pt_regs);
+	if (p->post_handler)
+		p->post_handler(p, pt_regs, 0);
+}
+
+static int use_ftrace_hook(struct kprobe *p)
+{
+	char str[KSYM_SYMBOL_LEN];
+
+	/* see if this is an ftrace function */
+	if (!ftrace_text_reserved(p->addr, p->addr)) {
+		/* make sure fops->func is nop */
+		init_non_ftrace_kprobe(p);
+		return 0;
+	}
+
+	/* If arch does not support pt_regs passing, bail */
+	if (!ARCH_SUPPORTS_FTRACE_SAVE_REGS)
+		return -EINVAL;
+
+	/* Use ftrace hook instead */
+
+	memset(&p->fops, 0, sizeof(p->fops));
+
+	/* Find the function this is connected with this addr */
+	kallsyms_lookup((unsigned long)p->addr, NULL, NULL, NULL, str);
+
+	p->fops.flags = FTRACE_OPS_FL_SAVE_REGS;
+	p->fops.func = kprobe_ftrace_callback;
+
+	ftrace_set_filter(&p->fops, str, strlen(str), 1);
+
+	return 0;
+}
+#else
+static int use_ftrace_hook(struct kprobe *p)
+{
+	return 0;
+}
+#endif
+
 int __kprobes register_kprobe(struct kprobe *p)
 {
 	int ret = 0;
@@ -1329,11 +1445,14 @@ int __kprobes register_kprobe(struct kprobe *p)
 	if (ret)
 		return ret;
 
+	ret = use_ftrace_hook(p);
+	if (ret)
+		return ret;
+
 	jump_label_lock();
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr))
 		goto fail_with_jump_label;
 
@@ -1384,15 +1503,17 @@ int __kprobes register_kprobe(struct kprobe *p)
 		goto out;
 	}
 
-	ret = arch_prepare_kprobe(p);
-	if (ret)
-		goto out;
+	if (!ftrace_kprobe(p)) {
+		ret = arch_prepare_kprobe(p);
+		if (ret)
+			goto out;
+	}
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (!kprobes_all_disarmed && !kprobe_disabled(p))
+	if (!ftrace_kprobe(p) && !kprobes_all_disarmed && !kprobe_disabled(p))
 		__arm_kprobe(p);
 
 	/* Try to optimize kprobe */
@@ -1400,6 +1521,12 @@ int __kprobes register_kprobe(struct kprobe *p)
 
 out:
 	mutex_unlock(&text_mutex);
+
+	/* ftrace kprobes must be set outside of text_mutex */
+	if (!ret && ftrace_kprobe(p) &&
+	    !kprobes_all_disarmed && !kprobe_disabled(p))
+		arm_kprobe(p);
+
 	put_online_cpus();
 	jump_label_unlock();
 	mutex_unlock(&kprobe_mutex);
@@ -2134,6 +2261,14 @@ static void __kprobes arm_all_kprobes(void)
 	}
 	mutex_unlock(&text_mutex);
 
+	/* ftrace kprobes are enabled outside of text_mutex */
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			if (ftrace_kprobe(p) && !kprobe_disabled(p))
+				arm_kprobe(p);
+	}
+
 	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
 
@@ -2164,11 +2299,21 @@ static void __kprobes disarm_all_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
-			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
+			if (!ftrace_kprobe(p) &&
+			    !arch_trampoline_kprobe(p) && !kprobe_disabled(p))
 				__disarm_kprobe(p, false);
 		}
 	}
 	mutex_unlock(&text_mutex);
+
+	/* ftrace kprobes are disabled outside of text_mutex */
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist) {
+			if (ftrace_kprobe(p) && !kprobe_disabled(p))
+				disarm_kprobe(p);
+		}
+	}
 	mutex_unlock(&kprobe_mutex);
 
 	/* Wait for disarming all kprobes by optimizer */
-- 
1.7.5.4


