Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0LFSSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:18:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:48129 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0LFSSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:18:41 -0500
Date: Mon, 6 Dec 2010 18:17:51 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
        mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, ananth@in.ibm.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
        mingo@elte.hu
In-Reply-To: <20101203095428.2961.8994.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095428.2961.8994.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Use text_poke_smp_batch for optimizing
Message-ID: <tip-cd7ebe2298ff1c3112232878678ce5fe6be8a15b@git.kernel.org>
Git-Commit-ID: cd7ebe2298ff1c3112232878678ce5fe6be8a15b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:17:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd7ebe2298ff1c3112232878678ce5fe6be8a15b
Gitweb:     http://git.kernel.org/tip/cd7ebe2298ff1c3112232878678ce5fe6be8a15b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:54:28 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:31 +0100

kprobes: Use text_poke_smp_batch for optimizing

Use text_poke_smp_batch() in optimization path for reducing
the number of stop_machine() issues. If the number of optimizing
probes is more than MAX_OPTIMIZE_PROBES(=256), kprobes optimizes
first MAX_OPTIMIZE_PROBES probes and kicks optimizer for
remaining probes.

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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20101203095428.2961.8994.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |   69 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/kprobes.h   |    2 +-
 kernel/kprobes.c          |   17 ++++------
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
