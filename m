Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0LCJ6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:58:21 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38210 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab0LCJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:58:12 -0500
X-AuditID: b753bd60-a69a5ba000003e7d-07-4cf8bf31d18c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 8/8] kprobes: Use text_poke_smp_batch for unoptimizing
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 03 Dec 2010 18:54:34 +0900
Message-ID: <20101203095434.2961.22657.stgit@ltc236.sdl.hitachi.co.jp>
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

Use text_poke_smp_batch() on unoptimization path for reducing
the number of stop_machine() issues. If the number of unoptimizing
probes is more than MAX_OPTIMIZE_PROBES(=256), kprobes unoptimizes
first MAX_OPTIMIZE_PROBES probes and kicks optimizer for remaining
probes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 arch/x86/kernel/kprobes.c |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/kprobes.h   |    2 ++
 kernel/kprobes.c          |   10 ++++------
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 25a8af7..5940282 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1457,6 +1457,46 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 	text_poke_smp_batch(jump_poke_params, c);
 }
 
+static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
+					      u8 *insn_buf,
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
+/*
+ * Recover original instructions and breakpoints from relative jumps.
+ * Caller must call with locking kprobe_mutex.
+ */
+extern void arch_unoptimize_kprobes(struct list_head *oplist,
+				    struct list_head *done_list)
+{
+	struct optimized_kprobe *op, *tmp;
+	int c = 0;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		/* Setup param */
+		setup_unoptimize_kprobe(&jump_poke_params[c],
+					jump_poke_bufs[c].buf, op);
+		list_move(&op->list, done_list);
+		if (++c >= MAX_OPTIMIZE_PROBES)
+			break;
+	}
+
+	/*
+	 * text_poke_smp doesn't support NMI/MCE code modifying.
+	 * However, since kprobes itself also doesn't support NMI/MCE
+	 * code probing, it's not a problem.
+	 */
+	text_poke_smp_batch(jump_poke_params, c);
+}
+
 /* Replace a relative jump with a breakpoint (int3).  */
 void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
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
index 531e101..7663e5d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -517,9 +517,9 @@ static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 	/* Ditto to do_optimize_kprobes */
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	list_for_each_entry_safe(op, tmp, &unoptimizing_list, list) {
-		/* Unoptimize kprobes */
-		arch_unoptimize_kprobe(op);
+	arch_unoptimize_kprobes(&unoptimizing_list, free_list);
+	/* Loop free_list for disarming */
+	list_for_each_entry_safe(op, tmp, free_list, list) {
 		/* Disarm probes if marked disabled */
 		if (kprobe_disabled(&op->kp))
 			arch_disarm_kprobe(&op->kp);
@@ -530,8 +530,6 @@ static __kprobes void do_unoptimize_kprobes(struct list_head *free_list)
 			 * (reclaiming is done by do_free_cleaned_kprobes.)
 			 */
 			hlist_del_rcu(&op->kp.hlist);
-			/* Move only unused probes on free_list */
-			list_move(&op->list, free_list);
 		} else
 			list_del_init(&op->list);
 	}
@@ -592,7 +590,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 	mutex_unlock(&module_mutex);
 
 	/* Step 5: Kick optimizer again if needed */
-	if (!list_empty(&optimizing_list))
+	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
 		kick_kprobe_optimizer();
 	else
 		/* Wake up all waiters */

