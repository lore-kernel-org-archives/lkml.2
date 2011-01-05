Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1AEXpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:45:52 -0500
Received: from kroah.org ([198.145.64.141]:41139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1AEXpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:31 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:28 2011
Message-Id: <20110105230328.410867452@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:01:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>
Subject: [49/49] posix-cpu-timers: workaround to suppress the problems with mt exec
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e0a70217107e6f9844628120412cb27bb4cea194 upstream.

posix-cpu-timers.c correctly assumes that the dying process does
posix_cpu_timers_exit_group() and removes all !CPUCLOCK_PERTHREAD
timers from signal->cpu_timers list.

But, it also assumes that timer->it.cpu.task is always the group
leader, and thus the dead ->task means the dead thread group.

This is obviously not true after de_thread() changes the leader.
After that almost every posix_cpu_timer_ method has problems.

It is not simple to fix this bug correctly. First of all, I think
that timer->it.cpu should use struct pid instead of task_struct.
Also, the locking should be reworked completely. In particular,
tasklist_lock should not be used at all. This all needs a lot of
nontrivial and hard-to-test changes.

Change __exit_signal() to do posix_cpu_timers_exit_group() when
the old leader dies during exec. This is not the fix, just the
temporary hack to hide the problem for 2.6.37 and stable. IOW,
this is obviously wrong but this is what we currently have anyway:
cpu timers do not work after mt exec.

In theory this change adds another race. The exiting leader can
detach the timers which were attached to the new leader. However,
the window between de_thread() and release_task() is small, we
can pretend that sys_timer_create() was called before de_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -92,6 +92,14 @@ static void __exit_signal(struct task_st
 		posix_cpu_timers_exit_group(tsk);
 	else {
 		/*
+		 * This can only happen if the caller is de_thread().
+		 * FIXME: this is the temporary hack, we should teach
+		 * posix-cpu-timers to handle this case correctly.
+		 */
+		if (unlikely(has_group_leader_pid(tsk)))
+			posix_cpu_timers_exit_group(tsk);
+
+		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */


