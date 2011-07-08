Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1GHRQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:16:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1GHRQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:16:53 -0400
Date: Fri, 8 Jul 2011 19:14:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, indan@nul.nu, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] ptrace: dont send SIGSTOP on auto-attach if
	PT_SEIZED
Message-ID: <20110708171417.GD26943@redhat.com>
References: <20110708171320.GA26943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708171320.GA26943@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fake SIGSTOP during attach has numerous problems. PTRACE_SEIZE
is already fine, but we have basically the same problems is SIGSTOP
is sent on auto-attach, the tracer can't know if this signal signal
should be cancelled or not.

Change ptrace_event() to set JOBCTL_TRAP_STOP if the new child is
PT_SEIZED, this triggers the PTRACE_EVENT_STOP report.

Thereafter a PT_SEIZED task can never report the bogus SIGSTOP.

Test-case:

	#define PTRACE_SEIZE		0x4206
	#define PTRACE_SEIZE_DEVEL	0x80000000
	#define PTRACE_EVENT_STOP	7
	#define WEVENT(s)		((s & 0xFF0000) >> 16)

	int main(void)
	{
		int child, grand_child, status;
		long message;

		child = fork();
		if (!child) {
			kill(getpid(), SIGSTOP);
			fork();
			assert(0);
			return 0x23;
		}

		assert(ptrace(PTRACE_SEIZE, child, 0,PTRACE_SEIZE_DEVEL) == 0);
		assert(wait(&status) == child);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);

		assert(ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_TRACEFORK) == 0);

		assert(ptrace(PTRACE_CONT, child, 0,0) == 0);
		assert(waitpid(child, &status, 0) == child);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
		assert(WEVENT(status) == PTRACE_EVENT_FORK);

		assert(ptrace(PTRACE_GETEVENTMSG, child, 0, &message) == 0);
		grand_child = message;

		assert(waitpid(grand_child, &status, 0) == grand_child);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
		assert(WEVENT(status) == PTRACE_EVENT_STOP);

		kill(child, SIGKILL);
		kill(grand_child, SIGKILL);
		return 0;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- ptrace/include/linux/ptrace.h~5_clone_no_stop_if_seized	2011-07-08 18:32:05.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-07-08 18:32:53.000000000 +0200
@@ -228,7 +228,11 @@ static inline void ptrace_init_task(stru
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 
-		sigaddset(&child->pending.signal, SIGSTOP);
+		if (child->ptrace & PT_SEIZED)
+			task_set_jobctl_pending(child, JOBCTL_TRAP_STOP);
+		else
+			sigaddset(&child->pending.signal, SIGSTOP);
+
 		set_tsk_thread_flag(child, TIF_SIGPENDING);
 	}
 }

