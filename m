Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1A1SDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:03:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1A1SDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:03:39 -0500
Date: Fri, 28 Jan 2011 18:55:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates
Message-ID: <20110128175532.GA26727@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110128165455.GA18194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128165455.GA18194@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Ingo Molnar wrote:
>
> The bug is that occasionally Ctrl-C does not get processed, and that the Ctrl-C is
> 'lost'. It can be reproduced here by running ./test-signal several times, and
> Ctrl-C-ing it:
>
>  $ ./test-signal
>  ^C
>  $ ./test-signal
>  ^C^C
>  $ ./test-signal
>  ^C
>
> See that '^C^C' line? That is where i had to do Ctrl-C twice.

Reproduced.

At first glance, /bin/sh should be blamed... Hmm, probably yes,
I even reproduced this under strace, and this is what I see

	wait4(-1, 0x7fff388431c4, 0, NULL) = ? ERESTARTSYS (To be restarted)
	--- SIGINT (Interrupt) @ 0 (0) ---
	rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)
	wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 9706

So, ^C is not lost, but ./test-signal doesn't want to exit.




This is what ./test-signal does when ^C does work:

	wait4(-1, 0x7fff1c283b74, 0, NULL)      = ? ERESTARTSYS (To be restarted)
	--- SIGINT (Interrupt) @ 0 (0) ---
	rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)

OK, it doesn't exit immediately, but then it kills itself:

	wait4(-1, [{WIFSIGNALED(s) && WTERMSIG(s) == SIGINT}], 0, NULL) = 19585
	rt_sigaction(SIGINT, {SIG_DFL, [], SA_RESTORER, 0x7f3c3035b150}, {0x433d30, [], SA_RESTORER, 0x7f3c3035b150}, 8) = 0
	rt_sigaction(SIGINT, {SIG_DFL, [], SA_RESTORER, 0x7f3c3035b150}, {SIG_DFL, [], SA_RESTORER, 0x7f3c3035b150}, 8) = 0
	kill(19584, SIGINT)




Looking into the previous log (when it doesn't exit) again,

	wait4(-1, 0x7fff388431c4, 0, NULL) = ? ERESTARTSYS (To be restarted)
	--- SIGINT (Interrupt) @ 0 (0) ---
	rt_sigreturn(0)                         = -1 EINTR (Interrupted system call)
	wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 9706
	rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
	--- SIGCHLD (Child exited) @ 0 (0) ---
	wait4(-1, 0x7fff38842d24, WNOHANG, NULL) = -1 ECHILD (No child processes)
	rt_sigreturn(0x8)                       = 0
	rt_sigaction(SIGINT, {SIG_DFL, [], SA_RESTORER, 0x7f3cbdbd0150}, {0x433d30, [], SA_RESTORER, 0x7f3cbdbd0150}, 8) = 0
	rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
	rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
	rt_sigprocmask(SIG_BLOCK, [INT CHLD], [], 8) = 0
	clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f3cbe9ab780) = 9707

Perhaps the handler for SIGCHLD clears some internal i_am_going_to_exit flag,
I dunno.

Oleg.

