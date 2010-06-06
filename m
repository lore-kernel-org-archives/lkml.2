Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab0FFQk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0FFQkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:40:55 -0400
Date: Sun, 6 Jun 2010 18:39:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Evan Teran <eteran@alum.rit.edu>,
       Jan Kratochvil <jan.kratochvil@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ptrace: x86: stepping in a signal handler leaks
	X86_EFLAGS_TF
Message-ID: <20100606163928.GB19800@redhat.com>
References: <20100602192318.GA26735@redhat.com> <20100606163848.GA19800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100606163848.GA19800@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See https://bugzilla.kernel.org/show_bug.cgi?id=16061

When the TIF_SINGLESTEP tracee dequeues a signal, handle_signal()
clears TIF_FORCED_TF and X86_EFLAGS_TF but leaves TIF_SINGLESTEP set.

If the tracer does PTRACE_SINGLESTEP again, enable_single_step() sets
X86_EFLAGS_TF but not TIF_FORCED_TF. This means that the subsequent
PTRACE_CONT doesn't not clear X86_EFLAGS_TF, and the tracee gets the
wrong SIGTRAP.

Test-case (based on the excellent report from Evan):

	#include <unistd.h>
	#include <stdio.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <sys/user.h>
	#include <assert.h>
	#include <stddef.h>

	void handler(int n)
	{
		asm("nop");
	}

	int child(void)
	{
		assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
		signal(SIGALRM, handler);
		kill(getpid(), SIGALRM);
		return 0x23;
	}

	void *getip(int pid)
	{
		return (void*)ptrace(PTRACE_PEEKUSER, pid,
					offsetof(struct user, regs.rip), 0);
	}

	int main(void)
	{
		int pid, status;

		pid = fork();
		if (!pid)
			return child();

		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGALRM);

		assert(ptrace(PTRACE_SINGLESTEP, pid, 0, SIGALRM) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
		assert((getip(pid) - (void*)handler) == 0);

		assert(ptrace(PTRACE_SINGLESTEP, pid, 0, SIGALRM) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
		assert((getip(pid) - (void*)handler) == 1);

		assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
		assert(wait(&status) == pid);
		assert(WIFEXITED(status) && WEXITSTATUS(status) == 0x23);

		return 0;
	}

Change handle_signal() to clear TIF_SINGLESTEP as well. We cleared
X86_EFLAGS_TF and TIF_FORCED_TF, we are not going to return to user-mode
if TIF_SINGLESTEP was set, and we already passed syscall_trace_leave().
We are going to sleep until the next ptrace_resume() which should set
these flags correctly if needed.

Note: this is the most simple fix now, most probably we need more
changes/cleanups on top of this patch.

Reported-by: Evan Teran <eteran@alum.rit.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/arch/x86/kernel/signal.c~BZ16061_TEMPORARY_FIX	2010-06-06 16:22:55.000000000 +0200
+++ 34-rc1/arch/x86/kernel/signal.c	2010-06-06 16:47:55.000000000 +0200
@@ -749,7 +749,7 @@ handle_signal(unsigned long sig, siginfo
 	spin_unlock_irq(&current->sighand->siglock);
 
 	tracehook_signal_handler(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLESTEP));
+				 test_and_clear_thread_flag(TIF_SINGLESTEP));
 
 	return 0;
 }

