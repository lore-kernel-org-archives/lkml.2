Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab1KRLic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:38:32 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46923 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab1KRLi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:38:29 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 18 Nov 2011 16:42:19 +0530
Message-Id: <20111118111219.10512.2502.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 28/30] uprobes: introduce UTASK_SSTEP_TRAPPED logic
x-cbid: 11111811-2000-0000-0000-0000021C85B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add UTASK_SSTEP_TRAPPED state/code to handle the case when
xol insn itself triggers the signal.

In this case we should restart the original insn even if the task is
already SIGKILL'ed (say, the coredump should report the correct ip).
This is even more important if the task has a handler for SIGSEGV/etc,
The _same_ instruction should be repeated again after return from the
signal handler, and SSTEP can never finish in this case.

Change uprobe_deny_signal() to set UTASK_SSTEP_TRAPPED and TIF_UPROBE. It
also sets TIF_NOTIFY_RESUME.

When uprobe_notify_resume() sees UTASK_SSTEP_TRAPPED it does abort_xol()
instead of post_xol().

Original-patch-from: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
Changelog (since v6)
-	abort_xol moved to previous patch.

 include/linux/uprobes.h |    1 +
 kernel/uprobes.c        |   13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 8d12c06..6a84332 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -76,6 +76,7 @@ enum uprobe_task_state {
 	UTASK_BP_HIT,
 	UTASK_SSTEP,
 	UTASK_SSTEP_ACK,
+	UTASK_SSTEP_TRAPPED,
 };
 
 /*
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 3e7c4c5..f8c0f7c 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1326,6 +1326,12 @@ bool uprobe_deny_signal(void)
 		spin_lock_irq(&tsk->sighand->siglock);
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 		spin_unlock_irq(&tsk->sighand->siglock);
+
+		if (__fatal_signal_pending(tsk) || xol_was_trapped(tsk)) {
+			utask->state = UTASK_SSTEP_TRAPPED;
+			set_tsk_thread_flag(tsk, TIF_UPROBE);
+			set_tsk_thread_flag(tsk, TIF_NOTIFY_RESUME);
+		}
 	}
 
 	return true;
@@ -1382,6 +1388,8 @@ void uprobe_notify_resume(struct pt_regs *regs)
 		u = utask->active_uprobe;
 		if (utask->state == UTASK_SSTEP_ACK)
 			post_xol(u, regs);
+		else if (utask->state == UTASK_SSTEP_TRAPPED)
+			abort_xol(regs, u);
 		else
 			WARN_ON_ONCE(1);
 
@@ -1405,9 +1413,8 @@ void uprobe_notify_resume(struct pt_regs *regs)
 	if (u) {
 		put_uprobe(u);
 		set_instruction_pointer(regs, probept);
-	} else {
-		/*TODO Return SIGTRAP signal */
-	}
+	} else
+		send_sig(SIGTRAP, current, 0);
 }
 
 /*

