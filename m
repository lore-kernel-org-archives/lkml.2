Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0KSKNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:13:18 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38149 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0KSKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:13:15 -0500
X-AuditID: b753bd60-a7533ba000000226-12-4ce64db790b1
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v4 2/3] kprobes/x86: Use text_poke_smp_batch
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
Date: Fri, 19 Nov 2010 19:09:39 +0900
Message-ID: <20101119100939.16882.99385.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp>
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
 kernel/kprobes.c          |   11 ++-----
 3 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1cbd54c..2840d34 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1401,10 +1401,16 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
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
 
@@ -1412,16 +1418,39 @@ int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
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
@@ -1453,11 +1482,35 @@ static int  __kprobes setup_detour_execution(struct kprobe *p,
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
index 9737a76..4db766f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -430,8 +430,6 @@ static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
 /* Kprobe jump optimizer */
 static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
-	struct optimized_kprobe *op, *tmp;
-
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
 	mutex_lock(&kprobe_mutex);
@@ -459,14 +457,11 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
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
+	if (!list_empty(&optimizing_list))
+		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
 end:
 	mutex_unlock(&kprobe_mutex);
 	mutex_unlock(&module_mutex);

