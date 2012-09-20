Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2ITMoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:44:05 -0400
Received: from mail.x86-64.org ([217.9.48.20]:43384 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab2ITMoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:44:03 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2] x86, kprobes: Move skip_singlestep up
Date: Thu, 20 Sep 2012 14:43:54 +0200
Message-Id: <1348145034-16603-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <20120920110515.GA5996@gmail.com>
References: <20120920110515.GA5996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

I get

arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined [-Wunused-function]

on tip/auto-latest.

Put the skip_singlestep function declaration up, in KPROBES_CAN_USE_FTRACE
and drop the superfluous forward declaration.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/kprobes.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b7c2a85d1926..57916c0d3cf6 100644
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
-- 
1.7.11.rc1

