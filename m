Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1BCUuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:50:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1BCUuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:50:17 -0500
Date: Thu, 3 Feb 2011 21:41:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>
Cc: jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110203204154.GB26371@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-11-git-send-email-tj@kernel.org> <20110203204122.GA26371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203204122.GA26371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>

	int main(void)
	{
		int pid, stat;

		pid = fork();
		if (!pid) {
			kill(getpid(), SIGSTOP);
			assert(0);
		}

		if (!fork()) {
			assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);
			/* eat ->exit_code */
			assert(wait(&stat) == pid);
			/* exit instead of DETACH to avoid the extra wakeup */
			assert(stat == 0x137f);
			return 0;
		}
		wait(NULL);

		assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);
		alarm(1);
		assert(wait(&stat) == pid);
		assert(stat == 0x137f);
		assert(ptrace(PTRACE_DETACH, pid, 0,0) == 0);

		kill(pid, SIGKILL);
		return 0;
	}

Without this patch wait() hangs forever after the 2nd PTRACE_DETACH.
This is because task->exit_code was already cleared by the previous
debugger. Change ptrace_attach() to restore ->exit_code in this case.

The new exit_code is not necessarily accurate and we can't use
->group_exit_code because it can be cleared by ->real_parent too,
but I think this doesn't really matter.

Even with this patch SIGCONT can "steal" exit_code and the pending
SIGSTOP, but in this case the tracee will report SIGCONT to the new
debugger, so wait() won't hang anyway.

(Of course, SIGCONT after wait() can break PTRACE_DETACH but this
 is another story, any ptrace request can fail if the tracee is
 TASK_STOPPED).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- 37/kernel/ptrace.c~attach_exit_code	2010-11-02 19:48:08.000000000 +0100
+++ 37/kernel/ptrace.c	2011-02-03 20:39:26.000000000 +0100
@@ -202,9 +202,22 @@ int ptrace_attach(struct task_struct *ta
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
-	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
+	if (task_is_stopped(task)) {
+		/* safe, we checked ->exit_state */
+		spin_lock(&task->sighand->siglock);
+		/*
+		 * This can only happen if the previous tracer cleared
+		 * ->exit_code, make sure do_wait() will not hang.
+		 */
+		if (task_is_stopped(task) && !task->exit_code)
+			task->exit_code = SIGSTOP;
+		spin_unlock(&task->sighand->siglock);
+	}
+
+	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 	retval = 0;
+
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
 unlock_creds:

