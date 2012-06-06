Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2FFEBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:01:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FFEAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:19 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=PTSyU4LRdJAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=nNACH-TMk88zOU5_QVkA:9 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=qnRZC5yr7xjcl4IW:21 a=wX1XVKUT2GUnF1cj:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040016.024644381@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][PATCH 11/12] kprobes: introduce ftrace based optimization
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0011-kprobes-introduce-ftrace-based-optimization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Introduce function trace based kprobes optimization.

With using ftrace optimization, kprobes on the mcount calling
address, use ftrace's mcount call instead of breakpoint.
Furthermore, this optimization works with preemptive kernel
not like as current jump-based optimization. Of cource,
this feature works only if the probe is on mcount call.

Only if kprobe.break_handler is set, that probe is not
optimized with ftrace (nor put on ftrace). The reason why this
limitation comes is that this break_handler may be used only
from jprobes which changes ip address (for fetching the function
arguments), but function tracer ignores modified ip address.

Changes in v2:
 - Fix ftrace_ops registering right after setting its filter.
 - Unregister ftrace_ops if there is no kprobe using.
 - Remove notrace dependency from __kprobes macro.

Link: http://lkml.kernel.org/r/20120605102832.27845.63461.stgit@localhost.localdomain

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kprobes.h |   27 ++++++++++++
 kernel/kprobes.c        |  105 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 119 insertions(+), 13 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index b6e1f8c..aa0d05e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -38,6 +38,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/ftrace.h>
 
 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -48,14 +49,26 @@
 #define KPROBE_REENTER		0x00000004
 #define KPROBE_HIT_SSDONE	0x00000008
 
+/*
+ * If function tracer is enabled and the arch supports full
+ * passing of pt_regs to function tracing, then kprobes can
+ * optimize on top of function tracing.
+ */
+#if defined(CONFIG_FUNCTION_TRACER) && defined(ARCH_SUPPORTS_FTRACE_SAVE_REGS) \
+	&& defined(ARCH_SUPPORTS_KPROBES_ON_FTRACE)
+# define KPROBES_CAN_USE_FTRACE
+#endif
+
 /* Attach to insert probes on any functions which should be ignored*/
 #define __kprobes	__attribute__((__section__(".kprobes.text")))
+
 #else /* CONFIG_KPROBES */
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
 	int dummy;
 };
 #define __kprobes
+
 #endif /* CONFIG_KPROBES */
 
 struct kprobe;
@@ -128,6 +141,7 @@ struct kprobe {
 				   * NOTE:
 				   * this flag is only for optimized_kprobe.
 				   */
+#define KPROBE_FLAG_FTRACE	8 /* probe is using ftrace */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
@@ -146,6 +160,13 @@ static inline int kprobe_optimized(struct kprobe *p)
 {
 	return p->flags & KPROBE_FLAG_OPTIMIZED;
 }
+
+/* Is this kprobe uses ftrace ? */
+static inline int kprobe_ftrace(struct kprobe *p)
+{
+	return p->flags & KPROBE_FLAG_FTRACE;
+}
+
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
@@ -295,6 +316,12 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 #endif
 
 #endif /* CONFIG_OPTPROBES */
+#ifdef KPROBES_CAN_USE_FTRACE
+extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+				  struct pt_regs *regs);
+extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
+#endif
+
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9e47f44..69c16ef 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -759,6 +759,10 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 	struct kprobe *ap;
 	struct optimized_kprobe *op;
 
+	/* Impossible to optimize ftrace-based kprobe */
+	if (kprobe_ftrace(p))
+		return;
+
 	/* For preparing optimization, jump_label_text_reserved() is called */
 	jump_label_lock();
 	mutex_lock(&text_mutex);
@@ -915,9 +919,64 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 }
 #endif /* CONFIG_OPTPROBES */
 
+#ifdef KPROBES_CAN_USE_FTRACE
+static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
+	.regs_func = kprobe_ftrace_handler,
+	.flags = FTRACE_OPS_FL_SAVE_REGS,
+};
+static int kprobe_ftrace_enabled;
+
+/* Must ensure p->addr is really on ftrace */
+static int __kprobes prepare_kprobe(struct kprobe *p)
+{
+	if (!kprobe_ftrace(p))
+		return arch_prepare_kprobe(p);
+
+	return arch_prepare_kprobe_ftrace(p);
+}
+
+/* Caller must lock kprobe_mutex */
+static void __kprobes arm_kprobe_ftrace(struct kprobe *p)
+{
+	int ret;
+
+	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
+				   (unsigned long)p->addr, 0, 0);
+	WARN(ret < 0, "Failed to arm kprobe-ftrace at %p (%d)\n", p->addr, ret);
+	kprobe_ftrace_enabled++;
+	if (kprobe_ftrace_enabled == 1) {
+		ret = register_ftrace_function(&kprobe_ftrace_ops);
+		WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
+	}
+}
+
+/* Caller must lock kprobe_mutex */
+static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
+{
+	int ret;
+
+	kprobe_ftrace_enabled--;
+	if (kprobe_ftrace_enabled == 0) {
+		ret = unregister_ftrace_function(&kprobe_ftrace_ops);
+		WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
+	}
+	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
+			   (unsigned long)p->addr, 1, 0);
+	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
+}
+#else	/* !KPROBES_CAN_USE_FTRACE */
+#define prepare_kprobe(p)	arch_prepare_kprobe(p)
+#define arm_kprobe_ftrace(p)	do {} while (0)
+#define disarm_kprobe_ftrace(p)	do {} while (0)
+#endif
+
 /* Arm a kprobe with text_mutex */
 static void __kprobes arm_kprobe(struct kprobe *kp)
 {
+	if (unlikely(kprobe_ftrace(kp))) {
+		arm_kprobe_ftrace(kp);
+		return;
+	}
 	/*
 	 * Here, since __arm_kprobe() doesn't use stop_machine(),
 	 * this doesn't cause deadlock on text_mutex. So, we don't
@@ -929,11 +988,15 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
 }
 
 /* Disarm a kprobe with text_mutex */
-static void __kprobes disarm_kprobe(struct kprobe *kp)
+static void __kprobes disarm_kprobe(struct kprobe *kp, bool reopt)
 {
+	if (unlikely(kprobe_ftrace(kp))) {
+		disarm_kprobe_ftrace(kp);
+		return;
+	}
 	/* Ditto */
 	mutex_lock(&text_mutex);
-	__disarm_kprobe(kp, true);
+	__disarm_kprobe(kp, reopt);
 	mutex_unlock(&text_mutex);
 }
 
@@ -1343,6 +1406,26 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 					       struct module **probed_mod)
 {
 	int ret = 0;
+	unsigned long ftrace_addr;
+
+	/*
+	 * If the address is located on a ftrace nop, set the
+	 * breakpoint to the following instruction.
+	 */
+	ftrace_addr = ftrace_location((unsigned long)p->addr);
+	if (ftrace_addr) {
+#ifdef KPROBES_CAN_USE_FTRACE
+		/* Given address is not on the instruction boundary */
+		if ((unsigned long)p->addr != ftrace_addr)
+			return -EILSEQ;
+		/* break_handler (jprobe) can not work with ftrace */
+		if (p->break_handler)
+			return -EINVAL;
+		p->flags |= KPROBE_FLAG_FTRACE;
+#else	/* !KPROBES_CAN_USE_FTRACE */
+		return -EINVAL;
+#endif
+	}
 
 	jump_label_lock();
 	preempt_disable();
@@ -1350,7 +1433,6 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 	/* Ensure it is not in reserved area nor out of text */
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
 		goto out;
@@ -1422,7 +1504,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 	}
 
 	mutex_lock(&text_mutex);	/* Avoiding text modification */
-	ret = arch_prepare_kprobe(p);
+	ret = prepare_kprobe(p);
 	mutex_unlock(&text_mutex);
 	if (ret)
 		goto out;
@@ -1480,7 +1562,7 @@ static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
 
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
-			disarm_kprobe(orig_p);
+			disarm_kprobe(orig_p, true);
 			orig_p->flags |= KPROBE_FLAG_DISABLED;
 		}
 	}
@@ -2078,10 +2160,11 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
 
 	if (!pp)
 		pp = p;
-	seq_printf(pi, "%s%s%s\n",
+	seq_printf(pi, "%s%s%s%s\n",
 		(kprobe_gone(p) ? "[GONE]" : ""),
 		((kprobe_disabled(p) && !kprobe_gone(p)) ?  "[DISABLED]" : ""),
-		(kprobe_optimized(pp) ? "[OPTIMIZED]" : ""));
+		(kprobe_optimized(pp) ? "[OPTIMIZED]" : ""),
+		(kprobe_ftrace(pp) ? "[FTRACE]" : ""));
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -2160,14 +2243,12 @@ static void __kprobes arm_all_kprobes(void)
 		goto already_enabled;
 
 	/* Arming kprobes doesn't optimize kprobe itself */
-	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			if (!kprobe_disabled(p))
-				__arm_kprobe(p);
+				arm_kprobe(p);
 	}
-	mutex_unlock(&text_mutex);
 
 	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
@@ -2195,15 +2276,13 @@ static void __kprobes disarm_all_kprobes(void)
 	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
 
-	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
-				__disarm_kprobe(p, false);
+				disarm_kprobe(p, false);
 		}
 	}
-	mutex_unlock(&text_mutex);
 	mutex_unlock(&kprobe_mutex);
 
 	/* Wait for disarming all kprobes by optimizer */
-- 
1.7.10


