Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2IEOck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:32:40 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37627 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2IEOcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:32:36 -0400
X-AuditID: b753bd60-91b5cba000007c38-97-50476282792a
X-AuditID: b753bd60-91b5cba000007c38-97-50476282792a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 2/4] [BUGFIX] kprobes/x86: Fix kprobes to collectly
 handle IP on ftrace
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 05 Sep 2012 23:31:12 +0900
Message-ID: <20120905143112.10329.72069.stgit@localhost.localdomain>
In-Reply-To: <20120905143045.10329.64502.stgit@localhost.localdomain>
References: <20120905143045.10329.64502.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kprobe_ftrace_handler expects regs->ip == ip, but it is
incorrect (originally on x86-64). Actually, ftrace handler sets
regs->ip = ip + MCOUNT_INSN_SIZE.
kprobe_ftrace_handler must take care for that.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 arch/x86/kernel/kprobes.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 47ae102..f49f60c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1072,7 +1072,8 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(p);
 	} else {
-		regs->ip += sizeof(kprobe_opcode_t);
+		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
+		regs->ip = ip + sizeof(kprobe_opcode_t);
 
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
@@ -1080,13 +1081,15 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 			p->pre_handler(p, regs);
 
 		if (unlikely(p->post_handler)) {
-			/* Emulate singlestep as if there is a 5byte nop */
+			/*
+			 * Emulate singlestep (and also recover regs->ip)
+			 * as if there is a 5byte nop
+			 */
 			regs->ip = ip + MCOUNT_INSN_SIZE;
 			kcb->kprobe_status = KPROBE_HIT_SSDONE;
 			p->post_handler(p, regs, 0);
 		}
 		__this_cpu_write(current_kprobe, NULL);
-		regs->ip = ip;	/* Recover for next callback */
 	}
 end:
 	local_irq_restore(flags);

