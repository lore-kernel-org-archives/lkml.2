Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1JSV5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab1JSV5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:57:37 -0400
Date: Wed, 19 Oct 2011 23:52:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/X] uprobes: introduce uprobe_deny_signal()
Message-ID: <20111019215246.GD16395@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019215139.GA16395@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A not-UTASK_RUNNING task obviously can't handle the signals, neither it
should stop/freeze/etc. It must not even exit if it was SIGKILL'ed (see
the next changes).

This patch adds the new hook, uprobe_deny_signal(), called by
get_signal_to_deliver(). It simply clears TIF_SIGPENDING to ensure that
this thread can do nothing connected to signals until it becomes
UTASK_RUNNING.

We also change post_xol() path to do recalc_sigpending() before return
to user-mode, this ensures the signal can't be lost.

NOTE! Without the next changes this patch is buggy.
---
 include/linux/uprobes.h |    5 +++++
 kernel/signal.c         |    3 +++
 kernel/uprobes.c        |   23 +++++++++++++++++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 1591c7c..27928e5 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -134,6 +134,7 @@ extern unsigned long __weak get_uprobe_bkpt_addr(struct pt_regs *regs);
 extern int uprobe_post_notifier(struct pt_regs *regs);
 extern int uprobe_bkpt_notifier(struct pt_regs *regs);
 extern void uprobe_notify_resume(struct pt_regs *regs);
+extern bool uprobe_deny_signal(void);
 #else /* CONFIG_UPROBES is not defined */
 static inline int register_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer)
@@ -154,6 +155,10 @@ static inline void munmap_uprobe(struct vm_area_struct *vma)
 static inline void uprobe_notify_resume(struct pt_regs *regs)
 {
 }
+static inline bool uprobe_deny_signal(void)
+{
+	return false;
+}
 static inline unsigned long get_uprobe_bkpt_addr(struct pt_regs *regs)
 {
 	return 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..788b494 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2141,6 +2141,9 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 	struct signal_struct *signal = current->signal;
 	int signr;
 
+	if (unlikely(uprobe_deny_signal()))
+		return 0;
+
 relock:
 	/*
 	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 5fd72b8..d6f4508 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1320,6 +1320,25 @@ static int pre_ssout(struct uprobe *uprobe, struct pt_regs *regs,
 	return -EFAULT;
 }
 
+bool uprobe_deny_signal(void)
+{
+	struct task_struct *tsk = current;
+	struct uprobe_task *utask = tsk->utask;
+
+	if (likely(!utask || !utask->active_uprobe))
+		return false;
+
+	WARN_ON_ONCE(utask->state != UTASK_SSTEP);
+
+	if (signal_pending(tsk)) {
+		spin_lock_irq(&tsk->sighand->siglock);
+		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
+		spin_unlock_irq(&tsk->sighand->siglock);
+	}
+
+	return true;
+}
+
 /*
  * uprobe_notify_resume gets called in task context just before returning
  * to userspace.
@@ -1378,6 +1397,10 @@ void uprobe_notify_resume(struct pt_regs *regs)
 		utask->state = UTASK_RUNNING;
 		user_disable_single_step(current);
 		xol_free_insn_slot(current);
+
+		spin_lock_irq(&current->sighand->siglock);
+		recalc_sigpending(); /* see uprobe_deny_signal() */
+		spin_unlock_irq(&current->sighand->siglock);
 	}
 	return;
 
-- 
1.5.5.1


