Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab2C3Sio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab2C3Sil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:38:41 -0400
Date: Fri, 30 Mar 2012 20:31:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT
Message-ID: <20120330183104.GA12927@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I've looked at syscall_regfunc/unregfunc by accident, and I am
a bit confused...

	void syscall_regfunc(void)
	{
		unsigned long flags;
		struct task_struct *g, *t;

		if (!sys_tracepoint_refcount) {
			read_lock_irqsave(&tasklist_lock, flags);

Why _irqsave? write_lock(tasklist) needs to disable irqs, but read_
doesn't. Any subtle reason I missed?

			do_each_thread(g, t) {
				/* Skip kernel threads. */
				if (t->mm)

We should check PF_KTHREAD, not ->mm.

					set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);

But the main question is, can't we race with clone() and miss the
new child? The new task is not "visible" to do_each_thread() until
copy_process()->list_add_tail_rcu(thread_group/init_task.tasks).

Don't we need something like the patch below?

Oleg.


--- x/kernel/fork.c
+++ x/kernel/fork.c
@@ -1446,7 +1446,12 @@ static struct task_struct *copy_process(
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+#ifdef CONFIG_TRACEPOINTS
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+#endif
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)

