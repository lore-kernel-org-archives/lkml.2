Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1BBArE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:47:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:21780 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1BBApW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418478"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: oleg@redhat.com, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [133/139] posix-cpu-timers: workaround to suppress the problems with mt exec
Message-Id: <20110202004532.E76F83E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/kernel/exit.c
===================================================================
--- linux-2.6.35.y.orig/kernel/exit.c
+++ linux-2.6.35.y/kernel/exit.c
@@ -95,6 +95,14 @@ static void __exit_signal(struct task_st
 		sig->tty = NULL;
 	} else {
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
