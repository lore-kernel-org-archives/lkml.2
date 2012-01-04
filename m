Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab2ADQfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:35:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab2ADQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:35:08 -0500
Date: Wed, 4 Jan 2012 17:29:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Lukasz Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2] ptrace: ensure JOBCTL_STOP_SIGMASK is not zero after
	detach
Message-ID: <20120104162920.GC28907@redhat.com>
References: <20120104162843.GA28907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104162843.GA28907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the temporary simple fix for 3.2, we need more changes in this
area.

1. do_signal_stop() assumes that the running untraced thread in the
   stopped thread group is not possible. This was our goal but it is
   not yet achieved: a stopped-but-resumed tracee can clone the running
   thread which can initiate another group-stop.

   Remove WARN_ON_ONCE(!current->ptrace).

2. A new thread always starts with ->jobctl = 0. If it is auto-attached
   and this group is stopped, __ptrace_unlink() sets JOBCTL_STOP_PENDING
   but JOBCTL_STOP_SIGMASK part is zero, this triggers WANR_ON(!signr)
   in do_jobctl_trap() if another debugger attaches.

   Change __ptrace_unlink() to set the artificial SIGSTOP for report.

   Alternatively we could change ptrace_init_task() to copy signr from
   current, but this means we can copy it for no reason and hide the
   possible similar problems.

Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>		[3.1]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |   13 ++++++++++++-
 kernel/signal.c |    2 --
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 24d0447..78ab24a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -96,9 +96,20 @@ void __ptrace_unlink(struct task_struct *child)
 	 */
 	if (!(child->flags & PF_EXITING) &&
 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
-	     child->signal->group_stop_count))
+	     child->signal->group_stop_count)) {
 		child->jobctl |= JOBCTL_STOP_PENDING;
 
+		/*
+		 * This is only possible if this thread was cloned by the
+		 * traced task running in the stopped group, set the signal
+		 * for the future reports.
+		 * FIXME: we should change ptrace_init_task() to handle this
+		 * case.
+		 */
+		if (!(child->jobctl & JOBCTL_STOP_SIGMASK))
+			child->jobctl |= SIGSTOP;
+	}
+
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
 	 * @child in the butt.  Note that @resume should be used iff @child
diff --git a/kernel/signal.c b/kernel/signal.c
index b3f78d0..2065515 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1994,8 +1994,6 @@ static bool do_signal_stop(int signr)
 		 */
 		if (!(sig->flags & SIGNAL_STOP_STOPPED))
 			sig->group_exit_code = signr;
-		else
-			WARN_ON_ONCE(!current->ptrace);
 
 		sig->group_stop_count = 0;
 
-- 
1.5.5.1


