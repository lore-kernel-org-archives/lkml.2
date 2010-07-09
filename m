Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0GIXjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:39:40 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab0GIXhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:23 -0400
Message-Id: <20100709225816.427638223@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 07/20] kthread_kill_stop()
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=kthread_kill_stop.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow use of "interruptible" functions in kernel threads by creating this
kthread_stop_kill() variant. Instead of just waking up the thread, it also sends
a signal after setting the "must exit" variable to 1.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/kthread.h |    1 +
 kernel/kthread.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

Index: linux.trees.git/include/linux/kthread.h
===================================================================
--- linux.trees.git.orig/include/linux/kthread.h	2010-06-18 18:37:11.000000000 -0400
+++ linux.trees.git/include/linux/kthread.h	2010-06-18 18:37:27.000000000 -0400
@@ -29,6 +29,7 @@ struct task_struct *kthread_create(int (
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
+int kthread_kill_stop(struct task_struct *k, int signo);
 int kthread_should_stop(void);
 
 int kthreadd(void *unused);
Index: linux.trees.git/kernel/kthread.c
===================================================================
--- linux.trees.git.orig/kernel/kthread.c	2010-06-18 18:32:21.000000000 -0400
+++ linux.trees.git/kernel/kthread.c	2010-06-18 18:37:57.000000000 -0400
@@ -211,6 +211,46 @@ int kthread_stop(struct task_struct *k)
 }
 EXPORT_SYMBOL(kthread_stop);
 
+/**
+ * kthread_kill_stop - kill and stop a thread created by kthread_create().
+ * @k: thread created by kthread_create().
+ * @signo: signal number to send.
+ *
+ * Sets kthread_should_stop() for @k to return true, sends a signal, and
+ * waits for it to exit. This can also be called after kthread_create()
+ * instead of calling wake_up_process(): the thread will exit without
+ * calling threadfn().
+ *
+ * If threadfn() may call do_exit() itself, the caller must ensure
+ * task_struct can't go away.
+ *
+ * Returns the result of threadfn(), or %-EINTR if wake_up_process()
+ * was never called.
+ */
+int kthread_kill_stop(struct task_struct *k, int signo)
+{
+	struct kthread *kthread;
+	int ret;
+
+	trace_sched_kthread_stop(k);
+	get_task_struct(k);
+
+	kthread = to_kthread(k);
+	barrier(); /* it might have exited */
+	if (k->vfork_done != NULL) {
+		kthread->should_stop = 1;
+		force_sig(signo, k);
+		wait_for_completion(&kthread->exited);
+	}
+	ret = k->exit_code;
+
+	put_task_struct(k);
+	trace_sched_kthread_stop_ret(ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(kthread_kill_stop);
+
 int kthreadd(void *unused)
 {
 	struct task_struct *tsk = current;

