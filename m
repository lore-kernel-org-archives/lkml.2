Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2FFECB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:02:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2FFEAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:18 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=etPE-jhN8coA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=CVHErIZdAAAA:8 a=Y1Ot2RuyV6B7H7rStpgA:9 a=LFc6pFH91g0A:10 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040016.253427242@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][PATCH 12/12] kprobes/x86: ftrace based optimization for x86
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0012-kprobes-x86-ftrace-based-optimization-for-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add function tracer based kprobe optimization support
handlers on x86. This allows kprobes to use function
tracer for probing on mcount call.

Link: http://lkml.kernel.org/r/20120605102838.27845.26317.stgit@localhost.localdomain

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

[ Updated to new port of ftrace save regs functions ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/kprobes.h |    1 +
 arch/x86/kernel/kprobes.c      |   48 ++++++++++++++++++++++++++++++++++++++++
 include/linux/kprobes.h        |    2 +-
 kernel/kprobes.c               |    2 +-
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5478825..d3ddd17 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -27,6 +27,7 @@
 #include <asm/insn.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
+#define  ARCH_SUPPORTS_KPROBES_ON_FTRACE
 
 struct pt_regs;
 struct kprobe;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e2f751e..47ae102 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1052,6 +1052,54 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef KPROBES_CAN_USE_FTRACE
+/* Ftrace callback handler for kprobes */
+void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+				     struct ftrace_ops *ops, struct pt_regs *regs)
+{
+	struct kprobe *p;
+	struct kprobe_ctlblk *kcb;
+	unsigned long flags;
+
+	/* Disable irq for emulating a breakpoint and avoiding preempt */
+	local_irq_save(flags);
+
+	p = get_kprobe((kprobe_opcode_t *)ip);
+	if (unlikely(!p) || kprobe_disabled(p))
+		goto end;
+
+	kcb = get_kprobe_ctlblk();
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(p);
+	} else {
+		regs->ip += sizeof(kprobe_opcode_t);
+
+		__this_cpu_write(current_kprobe, p);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		if (p->pre_handler)
+			p->pre_handler(p, regs);
+
+		if (unlikely(p->post_handler)) {
+			/* Emulate singlestep as if there is a 5byte nop */
+			regs->ip = ip + MCOUNT_INSN_SIZE;
+			kcb->kprobe_status = KPROBE_HIT_SSDONE;
+			p->post_handler(p, regs, 0);
+		}
+		__this_cpu_write(current_kprobe, NULL);
+		regs->ip = ip;	/* Recover for next callback */
+	}
+end:
+	local_irq_restore(flags);
+}
+
+int __kprobes arch_prepare_kprobe_ftrace(struct kprobe *p)
+{
+	p->ainsn.insn = NULL;
+	p->ainsn.boostable = -1;
+	return 0;
+}
+#endif
+
 int __init arch_init_kprobes(void)
 {
 	return arch_init_optprobes();
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index aa0d05e..23755ba 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -318,7 +318,7 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 #endif /* CONFIG_OPTPROBES */
 #ifdef KPROBES_CAN_USE_FTRACE
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
-				  struct pt_regs *regs);
+				  struct ftrace_ops *ops, struct pt_regs *regs);
 extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
 #endif
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 69c16ef..35b4315 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -921,7 +921,7 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 
 #ifdef KPROBES_CAN_USE_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
-	.regs_func = kprobe_ftrace_handler,
+	.func = kprobe_ftrace_handler,
 	.flags = FTRACE_OPS_FL_SAVE_REGS,
 };
 static int kprobe_ftrace_enabled;
-- 
1.7.10


