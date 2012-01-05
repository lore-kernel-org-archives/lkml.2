Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2AEWg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:36:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971Ab2AEWgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:36:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jan  5 14:29:59 2012
Message-Id: <20120105222959.427640562@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Thu, 05 Jan 2012 14:30:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [79/80] ptrace: ensure JOBCTL_STOP_SIGMASK is not zero after detach
In-Reply-To: <20120105223610.GA9914@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2374
Lines: 71

From: Oleg Nesterov <oleg@redhat.com>

commit 8a88951b5878dc475dcd841cefc767e36397d14e upstream.

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
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/ptrace.c |   13 ++++++++++++-
 kernel/signal.c |    2 --
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -96,9 +96,20 @@ void __ptrace_unlink(struct task_struct
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
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1986,8 +1986,6 @@ static bool do_signal_stop(int signr)
 		 */
 		if (!(sig->flags & SIGNAL_STOP_STOPPED))
 			sig->group_exit_code = signr;
-		else
-			WARN_ON_ONCE(!current->ptrace);
 
 		sig->group_stop_count = 0;
 


