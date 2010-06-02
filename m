Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab0FBTYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493Ab0FBTYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:24:45 -0400
Date: Wed, 2 Jun 2010 21:23:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Evan Teran <eteran@alum.rit.edu>,
       Jan Kratochvil <jan.kratochvil@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Bug 16061 - single stepping in a signal handler can cause the
	single step flag to get "stuck"
Message-ID: <20100602192318.GA26735@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(see https://bugzilla.kernel.org/show_bug.cgi?id=16061)

Roland McGrath wrote:
>
> Oleg, please get an appropriate test case for this into the ptrace-tests suite.

The first thing I did, I created the test-case ;)

	#include <signal.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <sys/user.h>
	#include <assert.h>
	#include <stddef.h>

	void handler(int n)
	{
		asm("nop; nop; nop");
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

It is x86 specific and needs -O2. Probably I can just remove getip()
and related asserts and send it to Jan.

> That change might be the right one, but we should discuss it more in email, and
> look at the situation on other machines.

Yes. And I think it is better to discuss this on lkml.

I do not know what is the right fix. I do not like the fix in
https://bugzilla.kernel.org/attachment.cgi?id=26587 even if it is correct.
I can't explain this, but I think that tracehook.h is not the right place
to call disable_step(). And note that handle_signal() plays with TF anyway.

I am starting to think we should fix this per arch. As for x86, perhaps
we should start with this one-liner

		spin_unlock_irq(&current->sighand->siglock);
	 
		tracehook_signal_handler(sig, info, ka, regs,
	-				 test_thread_flag(TIF_SINGLESTEP));
	+				 test_and_clear_thread_flag(TIF_SINGLESTEP));
	 
		return 0;
	 }

then do other changes.

However, what I am thinking about is the more "clever" change (it
passed ptrace-tests).

Do you think it can be correct? I am asking because I never understood
the TIF_SINGLESTEP/TIF_FORCED_TF interaction. But otoh, shouldn't
TIF_FORCED_TF + X86_EFLAGS_TF always imply TIF_SINGLESTEP? at least
in handle_signal().

IOW, help! To me, the patch below is also cleanup. But only if you think
it can fly ;)

Oleg.

--- 34-rc1/arch/x86/kernel/signal.c~BZ16061_MAYBE_FIX	2010-06-02 21:11:07.000000000 +0200
+++ 34-rc1/arch/x86/kernel/signal.c	2010-06-02 21:11:48.000000000 +0200
@@ -682,6 +682,7 @@ static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	bool stepping;
 	int ret;
 
 	/* Are we from a system call? */
@@ -706,13 +707,10 @@ handle_signal(unsigned long sig, siginfo
 		}
 	}
 
-	/*
-	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
-	 * flag so that register information in the sigcontext is correct.
-	 */
-	if (unlikely(regs->flags & X86_EFLAGS_TF) &&
-	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
-		regs->flags &= ~X86_EFLAGS_TF;
+	stepping = test_thread_flag(TIF_SINGLESTEP);
+	if (stepping)
+		// do this before setup_sigcontext()
+		user_disable_single_step(current);
 
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
@@ -748,8 +746,7 @@ handle_signal(unsigned long sig, siginfo
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	tracehook_signal_handler(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLESTEP));
+	tracehook_signal_handler(sig, info, ka, regs, stepping);
 
 	return 0;
 }

