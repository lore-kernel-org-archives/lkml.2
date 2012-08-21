Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2HUPOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:14:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2HUPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:14:46 -0400
Date: Tue, 21 Aug 2012 08:14:24 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-e52538965119319447c0800c534da73142c27be2@git.kernel.org>
Cc: fche@redhat.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, ananth@in.ibm.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fche@redhat.com, ananth@in.ibm.com,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20120605102838.27845.26317.stgit@localhost.localdomain>
References: <20120605102838.27845.26317.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86: ftrace based optimization for x86
Git-Commit-ID: e52538965119319447c0800c534da73142c27be2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:14:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e52538965119319447c0800c534da73142c27be2
Gitweb:     http://git.kernel.org/tip/e52538965119319447c0800c534da73142c27be2
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 5 Jun 2012 19:28:38 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:59 -0400

kprobes/x86: ftrace based optimization for x86

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
