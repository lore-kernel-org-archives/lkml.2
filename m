Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2ITOPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:15:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2ITOPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:15:51 -0400
Date: Thu, 20 Sep 2012 07:15:30 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-50a011f6409e888d5f41343024d24885281f048c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1348145034-16603-1-git-send-email-bp@amd64.org>
References: <1348145034-16603-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86: Move skip_singlestep up
Git-Commit-ID: 50a011f6409e888d5f41343024d24885281f048c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 20 Sep 2012 07:15:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50a011f6409e888d5f41343024d24885281f048c
Gitweb:     http://git.kernel.org/tip/50a011f6409e888d5f41343024d24885281f048c
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 20 Sep 2012 14:43:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Sep 2012 14:48:16 +0200

kprobes/x86: Move skip_singlestep up

I get this warning:

  arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined

on tip/auto-latest.

Put the skip_singlestep function declaration up, in
KPROBES_CAN_USE_FTRACE and drop the superfluous forward
declaration.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348145034-16603-1-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b7c2a85..57916c0 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -541,8 +541,23 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 	return 1;
 }
 
+#ifdef KPROBES_CAN_USE_FTRACE
 static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-				      struct kprobe_ctlblk *kcb);
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
+#endif
+
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
@@ -1061,21 +1076,6 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 }
 
 #ifdef KPROBES_CAN_USE_FTRACE
-static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-				      struct kprobe_ctlblk *kcb)
-{
-	/*
-	 * Emulate singlestep (and also recover regs->ip)
-	 * as if there is a 5byte nop
-	 */
-	regs->ip = (unsigned long)p->addr + MCOUNT_INSN_SIZE;
-	if (unlikely(p->post_handler)) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		p->post_handler(p, regs, 0);
-	}
-	__this_cpu_write(current_kprobe, NULL);
-}
-
 /* Ftrace callback handler for kprobes */
 void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				     struct ftrace_ops *ops, struct pt_regs *regs)
