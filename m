Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1AMQAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:00:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab1AMQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:00:46 -0500
Date: Thu, 13 Jan 2011 16:51:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
	and TRACED
Message-ID: <20110113155120.GA31691@redhat.com>
References: <1293199257-11255-1-git-send-email-tj@kernel.org> <20110112214350.GC13830@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112214350.GC13830@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Jan Kratochvil wrote:
>
> FSF GDB for `T (stopped)' processes currently does:
>   PTRACE_ATTACH
>   check /proc/%d/status for `T (stopped)' (by GDB's pid_is_stopped)
>     if found then kill (PID, SIGSTOP) && ptrace (PTRACE_CONT, PID, 0, 0).
>   waitpid (pid, &status, 0) - so that this one does not get stuck if the stop
>                               event was already eaten out before.
>
> If the `T (stopped)' will now always FAIL then at leat the waitpid then should
> never get stuck.

I think it won't stuck. With this change the tracee always goes from
TASK_STOPPED to TASK_TRACED with the correct (and nonzero) stop code.

Btw, this should fix the case when ->exit_code was already consumed
by the previous debugger.


> FSF gdbserver --multi does PTRACE_ATTACH followed by waitpid (WNOHANG) and it
> fails if it returns ECHILD on the first try.

Not sure I understand... With or without this change waitpid()
shouldn't return ECHILD. But (again, with or without this change)
it can return 0 due to WNOHANG.

> 	ptrace(PTRACE_ATTACH, 22049, 0, 0)      = 0
> 	wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], WNOHANG, NULL) = 22049
>
> It may be also a gdbserver bug, though.

I do not know if this matters or not, but just in case...

gdb shouldn't assume the tracee will report SIGSTOP after attach.
Yes, PTRACE_ATTACH sends this signal implicitly, but the tracee can
dequeue and report another pending signal before SIGSTOP.

Oleg.

