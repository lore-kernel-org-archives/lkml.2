Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2JHRHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2JHRHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:07:12 -0400
Date: Mon, 8 Oct 2012 19:08:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@hack.frob.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] exec: make de_thread() killable
Message-ID: <20121008170844.GB3259@redhat.com>
References: <CA+OH3v09PR9d=qKL4DNUYu_HYFY1CJxcB6DSUXoNp8BhB7k1-w@mail.gmail.com> <CA+55aFzczRxYCXPsNs9u9G=Ch770+f2f--Dyw47m5a8BRoz9TA@mail.gmail.com> <CA+OH3v1JKugp0PVOsHYrZ9wGS3oCDBMthMUeSgA6MPx_VDExQw@mail.gmail.com> <CA+55aFy2t=pk07WO0ob3tUUYq_X_FhpPdNHZwQR6ZthA=8K5fA@mail.gmail.com> <CA+OH3v3trHzrRdMFvccDx244jpWOxSRrv+kSCoMh=7ir-cqKCw@mail.gmail.com> <CA+55aFwbKMs6DFV9ZvuSLCKx+TESMfR8raDAYU0=b8uuyZRWuQ@mail.gmail.com> <CA+55aFxfJpSQ5VSx3L_xeHfTb1jqte9xAKLsj10J+pW-YS+SSw@mail.gmail.com> <20120920153522.GA15426@redhat.com> <20121008170812.GA3259@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008170812.GA3259@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change de_thread() to use KILLABLE rather than UNINTERRUPTIBLE
while waiting for other threads. The only complication is that
we should clear ->group_exit_task and ->notify_count before we
return, and we should do this under tasklist_lock. -EAGAIN is
used to match the initial signal_group_exit() check/return, it
doesn't really matter.

This fixes the (unlikely) race with coredump. de_thread() checks
signal_group_exit() before it starts to kill the subthreads, but
this can't help if another CLONE_VM (but non CLONE_THREAD) task
starts the coredumping after de_thread() unlocks ->siglock. In
this case the killed sub-thread can block in exit_mm() waiting
for coredump_finish(), execing thread waits for that sub-thead,
and execing thread waits for execing thread. Deadlock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -878,9 +878,11 @@ static int de_thread(struct task_struct 
 		sig->notify_count--;
 
 	while (sig->notify_count) {
-		__set_current_state(TASK_UNINTERRUPTIBLE);
+		__set_current_state(TASK_KILLABLE);
 		spin_unlock_irq(lock);
 		schedule();
+		if (unlikely(__fatal_signal_pending(tsk)))
+			goto killed;
 		spin_lock_irq(lock);
 	}
 	spin_unlock_irq(lock);
@@ -898,9 +900,11 @@ static int de_thread(struct task_struct 
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
-			__set_current_state(TASK_UNINTERRUPTIBLE);
+			__set_current_state(TASK_KILLABLE);
 			write_unlock_irq(&tasklist_lock);
 			schedule();
+			if (unlikely(__fatal_signal_pending(tsk)))
+				goto killed;
 		}
 
 		/*
@@ -994,6 +998,14 @@ no_thread_group:
 
 	BUG_ON(!thread_group_leader(tsk));
 	return 0;
+
+killed:
+	/* protects against exit_notify() and __exit_signal() */
+	read_lock(&tasklist_lock);
+	sig->group_exit_task = NULL;
+	sig->notify_count = 0;
+	read_unlock(&tasklist_lock);
+	return -EAGAIN;
 }
 
 char *get_task_comm(char *buf, struct task_struct *tsk)

