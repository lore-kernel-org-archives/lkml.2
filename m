Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab0HQXXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:23:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42951 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0HQXXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:14 -0400
Message-Id: <20100817232151.837935309@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: [RFC PATCH 07/20] kthread: Add kthread_kill_stop()
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=kthread_kill_stop.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:52 +0000
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
--- linux.trees.git.orig/include/linux/kthread.h	2010-08-17 16:28:25.000000000 -0400
+++ linux.trees.git/include/linux/kthread.h	2010-08-17 16:32:36.000000000 -0400
@@ -29,6 +29,7 @@ struct task_struct *kthread_create(int (
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
+int kthread_kill_stop(struct task_struct *k, int signo);
 int kthread_should_stop(void);
 void *kthread_data(struct task_struct *k);
 
Index: linux.trees.git/kernel/kthread.c
===================================================================
--- linux.trees.git.orig/kernel/kthread.c	2010-08-17 16:28:26.000000000 -0400
+++ linux.trees.git/kernel/kthread.c	2010-08-17 16:32:36.000000000 -0400
@@ -228,6 +228,46 @@ int kthread_stop(struct task_struct *k)
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

