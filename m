Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0LFSSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:18:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:48138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab0LFSSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:18:47 -0500
Date: Mon, 6 Dec 2010 18:18:11 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, ananth@in.ibm.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101203095434.2961.22657.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095434.2961.22657.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Use text_poke_smp_batch for unoptimizing
Message-ID: <tip-f984ba4eb575e4a27ed28a76d4126d2aa9233c32@git.kernel.org>
Git-Commit-ID: f984ba4eb575e4a27ed28a76d4126d2aa9233c32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:18:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f984ba4eb575e4a27ed28a76d4126d2aa9233c32
Gitweb:     http://git.kernel.org/tip/f984ba4eb575e4a27ed28a76d4126d2aa9233c32
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:54:34 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:32 +0100

kprobes: Use text_poke_smp_batch for unoptimizing

Use text_poke_smp_batch() on unoptimization path for reducing
the number of stop_machine() issues. If the number of
unoptimizing probes is more than MAX_OPTIMIZE_PROBES(=256),
kprobes unoptimizes first MAX_OPTIMIZE_PROBES probes and kicks
optimizer for remaining probes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20101203095434.2961.22657.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
