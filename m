Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2INLnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:43:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2INLnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:43:45 -0400
Date: Fri, 14 Sep 2012 04:43:28 -0700
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-4b036d54bf849a75d0103b33d92a53f89ecb9315@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20120905143112.10329.72069.stgit@localhost.localdomain>
References: <20120905143112.10329.72069.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86:
  Fix kprobes to collectly handle IP on ftrace
Git-Commit-ID: 4b036d54bf849a75d0103b33d92a53f89ecb9315
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 14 Sep 2012 04:43:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b036d54bf849a75d0103b33d92a53f89ecb9315
Gitweb:     http://git.kernel.org/tip/4b036d54bf849a75d0103b33d92a53f89ecb9315
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 5 Sep 2012 23:31:12 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 13 Sep 2012 22:52:09 -0400

kprobes/x86: Fix kprobes to collectly handle IP on ftrace

Current kprobe_ftrace_handler expects regs->ip == ip, but it is
incorrect (originally on x86-64). Actually, ftrace handler sets
regs->ip = ip + MCOUNT_INSN_SIZE.
kprobe_ftrace_handler must take care for that.

Link: http://lkml.kernel.org/r/20120905143112.10329.72069.stgit@localhost.localdomain

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
