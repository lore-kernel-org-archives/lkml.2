Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0K1U7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:59:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab0K1U7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:59:50 -0500
Date: Sun, 28 Nov 2010 21:53:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/14] ptrace: make do_signal_stop() use ptrace_stop()
	if the task is being ptraced
Message-ID: <20101128205315.GF12896@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-9-git-send-email-tj@kernel.org> <20101128195442.GB12896@redhat.com> <20101128202201.GA11650@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101128202201.GA11650@host0.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Jan Kratochvil wrote:
>
> On Sun, 28 Nov 2010 20:54:42 +0100, Oleg Nesterov wrote:
> > To simplify, suppose that we have a single-thread tracee, and
> > debugger "acks" SIGSTOP, say, it does ptrace(PTRACE_CONT, SIGSTOP).
>
> I do not find this case useful.

OK, thanks.

> It happens with current GDB:
> (gdb) handle SIGSTOP
> Signal        Stop	Print	Pass to program	Description
> SIGSTOP       Yes	Yes	Yes		Stopped (signal)
>                                 ^^^
> But it behaves weird anyway:
>
> ptrace(PTRACE_CONT, 11799, 0x1, SIGSTOP) = 0
> wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}], WNOHANG, NULL) = 11799
> [...]
> ptrace(PTRACE_CONT, 11799, 0x1, SIGSTOP) = 0
> <no new signal received>:
> State:	S (sleeping)
> TracerPid:	11797
>
> So the first time it immediately gets reported and the second time it gets
> lost.  (kernel-2.6.35.6-48.fc14.x86_64)

This is correct. (note that I am not saying this looks very nice ;)

The second ptrace(PTRACE_CONT, SIGSTOP) is equal to ptrace(CONT, 0),
exactly because ->last_siginfo is NULL, we do not have the signal
context. (Well, this explanation is not exactly right technically).

And. IIRC, something in user-space relies on the current behaviour.
At least, I do remember it was said that ->last_siginfo != NULL
check (PTRACE_GETSIGINFO fails or not should help to detect the
jctl stop.

Oleg.

