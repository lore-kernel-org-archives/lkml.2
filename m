Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab0LCJ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:58:13 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38186 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab0LCJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:58:06 -0500
X-AuditID: b753bd60-a3afaba000000f8d-0e-4cf8bf2add9b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 7/8] kprobes: Use text_poke_smp_batch for optimizing
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 03 Dec 2010 18:54:28 +0900
Message-ID: <20101203095428.2961.8994.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use text_poke_smp_batch() in optimization path for reducing
the number of stop_machine() issues. If the number of optimizing
probes is more than MAX_OPTIMIZE_PROBES(=256), kprobes optimizes
first MAX_OPTIMIZE_PROBES probes and kicks optimizer for remaining
probes.

Changes in v5:
- Use kick_kprobe_optimizer() instead of directly calling
  schedule_delayed_work().
- Rescheduling optimizer outside of kprobe mutex lock.

Changes in v2:
- Allocate code buffer and parameters in arch_init_kprobes()
  instead of using static arraies.
- Merge previous max optimization limit patch into this patch.
  So, this patch introduces upper limit of optimization at
  once.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 arch/x86/kernel/kprobes.c |   69 ++++++++++++++++++++++++++++++++++++++++-----
 include/linux/kprobes.h   |    2 +
 kernel/kprobes.c          |   17 +++++------
 3 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index da51dc8..25a8af7 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1405,10 +1405,16 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	return 0;
 }
 
-/* Replace a breakpoint (int3) with a relative jump.  */
-int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
+#define MAX_OPTIMIZE_PROBES 256
+static struct text_poke_param *jump_poke_params;
+static struct jump_poke_buffer {
+	u8 buf[RELATIVEJUMP_SIZE];
+} *jump_poke_bufs;
+
+static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
+					    u8 *insn_buf,
+					    struct optimized_kprobe *op)
 {
-	unsigned char jmp_code[RELATIVEJUMP_SIZE];
 	s32 rel = (s32)((long)op->optinsn.insn -
 			((long)op->kp.addr + RELATIVEJUMP_SIZE));
 
@@ -1416,16 +1422,39 @@ int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
 	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
 	       RELATIVE_ADDR_SIZE);
 
-	jmp_code[0] = RELATIVEJUMP_OPCODE;
-	*(s32 *)(&jmp_code[1]) = rel;
+	insn_buf[0] = RELATIVEJUMP_OPCODE;
+	*(s32 *)(&insn_buf[1]) = rel;
+
+	tprm->addr = op->kp.addr;
+	tprm->opcode = insn_buf;
+	tprm->len = RELATIVEJUMP_SIZE;
+}
+
+/*
+ * Replace breakpoints (int3) with relative jumps.
+ * Caller must call with locking kprobe_mutex and text_mutex.
+ */
+void __kprobes arch_optimize_kprobes(struct list_head *oplist)
+{
+	struct optimized_kprobe *op, *tmp;
+	int c = 0;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		WARN_ON(kprobe_disabled(&op->kp));
+		/* Setup param */
+		setup_optimize_kprobe(&jump_poke_params[c],
+				      jump_poke_bufs[c].buf, op);
+		list_del_init(&op->list);
+		if (++c >= MAX_OPTIMIZE_PROBES)
+			break;
+	}
 
 	/*
 	 * text_poke_smp doesn't support NMI/MCE code modifying.
 	 * However, since kprobes itself also doesn't support NMI/MCE
 	 * code probing, it's not a problem.
 	 */
-	text_poke_smp(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE);
-	return 0;
+	text_poke_smp_batch(jump_poke_params, c);
 }
 
 /* Replace a relative jump with a breakpoint (int3).  */
@@ -1457,11 +1486,35 @@ static int  __kprobes setup_detour_execution(struct kprobe *p,
 	}
 	return 0;
 }
+
+static int __kprobes init_poke_params(void)
+{
+	/* Allocate code buffer and parameter array */
+	jump_poke_bufs = kmalloc(sizeof(struct jump_poke_buffer) *
+				 MAX_OPTIMIZE_PROBES, GFP_KERNEL);
+	if (!jump_poke_bufs)
+		return -ENOMEM;
+
+	jump_poke_params = kmalloc(sizeof(struct text_poke_param) *
+				   MAX_OPTIMIZE_PROBES, GFP_KERNEL);
+	if (!jump_poke_params) {
+		kfree(jump_poke_bufs);
+		jump_poke_bufs = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+#else	/* !CONFIG_OPTPROBES */
+static int __kprobes init_poke_params(void)
+{
+	return 0;
+}
 #endif
 
 int __init arch_init_kprobes(void)
 {
-	return 0;
+	return init_poke_params();
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index e7d1b2e..fe157ba 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -275,7 +275,7 @@ extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
 extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
 extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
 extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
-extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
+extern void arch_optimize_kprobes(struct list_head *oplist);
 extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
 extern kprobe_opcode_t *get_optinsn_slot(void);
 extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 134754d..531e101 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -480,8 +480,6 @@ static DECLARE_COMPLETION(optimizer_comp);
  */
 static __kprobes void do_optimize_kprobes(void)
 {
-	struct optimized_kprobe *op, *tmp;
-
 	/* Optimization never be done when disarmed */
 	if (kprobes_all_disarmed || !kprobes_allow_optimization ||
 	    list_empty(&optimizing_list))
@@ -499,12 +497,7 @@ static __kprobes void do_optimize_kprobes(void)
 	 */
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	list_for_each_entry_safe(op, tmp, &optimizing_list, list) {
-		WARN_ON(kprobe_disabled(&op->kp));
-		if (arch_optimize_kprobe(op) < 0)
-			op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
-		list_del_init(&op->list);
-	}
+	arch_optimize_kprobes(&optimizing_list);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
@@ -598,8 +591,12 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);
 
-	/* Wake up all waiters */
-	complete_all(&optimizer_comp);
+	/* Step 5: Kick optimizer again if needed */
+	if (!list_empty(&optimizing_list))
+		kick_kprobe_optimizer();
+	else
+		/* Wake up all waiters */
+		complete_all(&optimizer_comp);
 }
 
 /* Wait for completing optimization and unoptimization */

