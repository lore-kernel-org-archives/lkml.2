Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0K1Uae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:30:34 -0500
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:39167 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab0K1Uae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:30:34 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2010 15:30:33 EST
Date: Sun, 28 Nov 2010 21:22:02 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/14] ptrace: make do_signal_stop() use ptrace_stop() if
 the task is being ptraced
Message-ID: <20101128202201.GA11650@host0.dyn.jankratochvil.net>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
 <1290768569-16224-9-git-send-email-tj@kernel.org>
 <20101128195442.GB12896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101128195442.GB12896@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010 20:54:42 +0100, Oleg Nesterov wrote:
> To simplify, suppose that we have a single-thread tracee, and
> debugger "acks" SIGSTOP, say, it does ptrace(PTRACE_CONT, SIGSTOP).

I do not find this case useful.  It happens with current GDB:
(gdb) handle SIGSTOP
Signal        Stop	Print	Pass to program	Description
SIGSTOP       Yes	Yes	Yes		Stopped (signal)
                                ^^^
But it behaves weird anyway:

ptrace(PTRACE_CONT, 11799, 0x1, SIGSTOP) = 0
wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], WNOHANG, NULL) = 11799
[...]
ptrace(PTRACE_CONT, 11799, 0x1, SIGSTOP) = 0
<no new signal received>:
State:	S (sleeping)
TracerPid:	11797

So the first time it immediately gets reported and the second time it gets
lost.  (kernel-2.6.35.6-48.fc14.x86_64)


> Before this patch, the tracee stops in TASK_STOPPED, now it calls
> ptrace_stop() and goes to TASK_TRACED state.
> 
> Add Jan. I hope this is OK, but this might break the tracer if
> it looks into fs/proc (probably only test-cases do this).

ptrace(PTRACE_CONT, SIGSTOP) should just work somehow so that current GDB does
not break as it calls it sometimes.  The behavior of it may change I guess.

I find only interesting that (PTRACE_DETACH, SIGSTOP) should really keep it
stopped and also the attaching to `T (stopped)' should work with all the
issues of waited-for/unwaited-for SIGSTOP.  Those cases are not being
discussed here.


Thanks,
Jan
