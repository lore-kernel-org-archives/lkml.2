Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0ESQsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0ESQs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:48:29 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 4/5] kprobes/x86: Use text_poke_smp_batch
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 May 2010 12:53:34 -0400
Message-ID: <20100519165334.31828.1658.stgit@localhost6.localdomain6>
In-Reply-To: <20100519165305.31828.15577.stgit@localhost6.localdomain6>
References: <20100519165305.31828.15577.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 arch/x86/kernel/kprobes.c |   69 ++++++++++++++++++++++++++++++++++++++++-----
 include/linux/kprobes.h   |    2 +
 kernel/kprobes.c          |   11 ++-----
 3 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 345a4b1..50cf5d4 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1385,10 +1385,16 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
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
 
@@ -1396,16 +1402,39 @@ int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
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
+ * Caller must call with locking kprobe_mutex.
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
@@ -1437,11 +1466,35 @@ static int  __kprobes setup_detour_execution(struct kprobe *p,
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
index f1351f2..6bd2e53 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -429,8 +429,6 @@ static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
 /* Kprobe jump optimizer */
 static __kprobes void kprobe_optimizer(struct work_struct *work)
 {
-	struct optimized_kprobe *op, *tmp;
-
 	/* Lock modules while optimizing kprobes */
 	mutex_lock(&module_mutex);
 	mutex_lock(&kprobe_mutex);
@@ -458,14 +456,11 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
