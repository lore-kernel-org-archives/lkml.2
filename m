Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab1DNR7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:59:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:42451 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965017Ab1DNR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 195/209] posix-cpu-timers: workaround to suppress the problems with mt exec
Date: Thu, 14 Apr 2011 13:55:53 -0400
Message-Id: <1302803767-9715-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/exit.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 8eb207f..a652c26 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -95,6 +95,14 @@ static void __exit_signal(struct task_struct *tsk)
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
-- 
1.7.4.4

