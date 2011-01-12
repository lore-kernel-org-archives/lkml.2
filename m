Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1ALVoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:44:10 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:58404 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409Ab1ALVoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:44:09 -0500
Date: Wed, 12 Jan 2011 22:43:50 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110112214350.GC13830@host1.dyn.jankratochvil.net>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293199257-11255-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010 15:00:50 +0100, Tejun Heo wrote:
> 1. When attaching to a STOPPED task or a traced task stops for group
>    stop, the tracee now enters TRACED instead of STOPPED.  This is
>    visible via fs/proc but, more importantly, SIGCONT is ignored if a
>    task is TRACED.
> 
>    The behavior before the change was quite erratic.  The first ptrace
>    operation after the tracee enters STOPPED would silently transit
>    its state to TRACED behind its back bypassing arch_ptrace_stop().
>    This means that SIGCONT is honored until the first following ptrace
>    operation but ignored after that.
> 
>    This may, for example, affect the operation of strace but given how
>    strace always need to issue further ptrace operations on trap to
>    determine what's going on, I doubt it would actually be worse.

FSF GDB for `T (stopped)' processes currently does:
  PTRACE_ATTACH
  check /proc/%d/status for `T (stopped)' (by GDB's pid_is_stopped)
    if found then kill (PID, SIGSTOP) && ptrace (PTRACE_CONT, PID, 0, 0).
  waitpid (pid, &status, 0) - so that this one does not get stuck if the stop
                              event was already eaten out before.

If the `T (stopped)' will now always FAIL then at leat the waitpid then should
never get stuck.


> 2. The transition between STOPPED and TRACED involves a short window
>    of RUNNING inbetween.  On attach, the transition is hidden from the
>    tracer using GROUP_STOP_TRAPPING but it still is visible to other
>    threads in the tracer's group.  IOW, if another thread performs
>    WNOHANG wait(2) on the tracee while attach is in progress, the
>    wait(2) may fail even if the tracee is known to be in stopped state
>    before.
> 
>    The same problem exists the other direction during detach.
>    Currently, the code doesn't try to hide this transition even from
>    the tracer.  IOW, if the tracer attaches to a stopped task,
>    detaches, reattaches and then performs WNOHANG wait(2), the wait(2)
>    may fail.  However, given the previous behavior where the tracee is
>    always woken up by wake_up_process() on detach, this is highly
>    unlikely to cause any problem.

FSF gdbserver --multi does PTRACE_ATTACH followed by waitpid (WNOHANG) and it
fails if it returns ECHILD on the first try.

	ptrace(PTRACE_ATTACH, 22049, 0, 0)      = 0
	wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], WNOHANG, NULL) = 22049

It may be also a gdbserver bug, though.


Thanks,
Jan
