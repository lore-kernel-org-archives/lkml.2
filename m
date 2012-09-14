Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab2INLpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:45:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413Ab2INLpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:45:35 -0400
Date: Fri, 14 Sep 2012 04:45:18 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-c6aaf4d0bb86e2154ea31a33804cec300611255f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <20120905143125.10329.90836.stgit@localhost.localdomain>
References: <20120905143125.10329.90836.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86:
  Fix to support jprobes on ftrace-based kprobe
Git-Commit-ID: c6aaf4d0bb86e2154ea31a33804cec300611255f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 14 Sep 2012 04:45:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6aaf4d0bb86e2154ea31a33804cec300611255f
Gitweb:     http://git.kernel.org/tip/c6aaf4d0bb86e2154ea31a33804cec300611255f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 5 Sep 2012 23:31:25 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 13 Sep 2012 22:52:11 -0400

kprobes/x86: Fix to support jprobes on ftrace-based kprobe

Fix kprobes/x86 to support jprobes on ftrace-based kprobes.
Because of -mfentry support of ftrace, ftrace is now put
on the beginning of function where jprobes are put.

Originally ftrace-based kprobes doesn't support jprobe
because it will change regs->ip and ftrace doesn't support
changing IP and ftrace itself doesn't conflict jprobe.
However, ftrace -mfentry support moves mcount call on the
top of functions where jprobes are put. This means that
jprobe always conflicts with ftrace-based kprobe and fails.

This patch allows ftrace-based kprobes to support jprobes
by allowing to modify regs->ip and kprobes breakpoint
handler also allows to skip singlestepping because there
is a ftrace call (not an original instruction).

Link: http://lkml.kernel.org/r/20120905143125.10329.90836.stgit@localhost.localdomain

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/kprobes.c |   42 +++++++++++++++++++++++++++++-------------
 kernel/kprobes.c          |    3 ---
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index f49f60c..b7c2a85 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -541,6 +541,8 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 	return 1;
 }
 
+static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+				      struct kprobe_ctlblk *kcb);
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
@@ -599,6 +601,12 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	} else if (kprobe_running()) {
 		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
+#ifdef KPROBES_CAN_USE_FTRACE
+			if (kprobe_ftrace(p)) {
+				skip_singlestep(p, regs, kcb);
+				return 1;
+			}
+#endif
 			setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
@@ -1053,6 +1061,21 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 }
 
 #ifdef KPROBES_CAN_USE_FTRACE
+static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+				      struct kprobe_ctlblk *kcb)
+{
+	/*
+	 * Emulate singlestep (and also recover regs->ip)
+	 * as if there is a 5byte nop
+	 */
+	regs->ip = (unsigned long)p->addr + MCOUNT_INSN_SIZE;
+	if (unlikely(p->post_handler)) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		p->post_handler(p, regs, 0);
+	}
+	__this_cpu_write(current_kprobe, NULL);
+}
+
 /* Ftrace callback handler for kprobes */
 void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				     struct ftrace_ops *ops, struct pt_regs *regs)
@@ -1077,19 +1100,12 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-		if (p->pre_handler)
-			p->pre_handler(p, regs);
-
-		if (unlikely(p->post_handler)) {
-			/*
-			 * Emulate singlestep (and also recover regs->ip)
-			 * as if there is a 5byte nop
-			 */
-			regs->ip = ip + MCOUNT_INSN_SIZE;
-			kcb->kprobe_status = KPROBE_HIT_SSDONE;
-			p->post_handler(p, regs, 0);
-		}
-		__this_cpu_write(current_kprobe, NULL);
+		if (!p->pre_handler || !p->pre_handler(p, regs))
+			skip_singlestep(p, regs, kcb);
+		/*
+		 * If pre_handler returns !0, it sets regs->ip and
+		 * resets current kprobe.
+		 */
 	}
 end:
 	local_irq_restore(flags);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 35b4315..098f396 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1418,9 +1418,6 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 		/* Given address is not on the instruction boundary */
 		if ((unsigned long)p->addr != ftrace_addr)
 			return -EILSEQ;
-		/* break_handler (jprobe) can not work with ftrace */
-		if (p->break_handler)
-			return -EINVAL;
 		p->flags |= KPROBE_FLAG_FTRACE;
 #else	/* !KPROBES_CAN_USE_FTRACE */
 		return -EINVAL;
