Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0LWMd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab0LWMdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:33:54 -0500
Date: Thu, 23 Dec 2010 13:26:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
	if the task is being ptraced
Message-ID: <20101223122634.GA365@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan, Roland, this change needs your review.

As it was already discussed, this is the user-visible change, and
I am starting to worry we can underestimate it.

Again, I am not saying this can break something, I simply do not
know. However, I think there is something non-consistent in the
new behaviour, please see below.

On 12/06, Tejun Heo wrote:
>
> This patch makes do_signal_stop() test whether the task is ptraced and
> use ptrace_stop() if so.

In short: suppose that the tracee recieves a signal, reports it
to debugger, and the debugger does ptrace(PTRACE_CONT, pid, SIGSTOP).

Before the patch the tracee sleeps in TASK_STOPPED, after the patch
it becomes TASK_TRACED.

> Oleg spotted a minor userland visible change.  In some cases, the
> ptracee's state would now be TASK_TRACED where it used to be
> TASK_STOPPED, which is visible via fs/proc.

I missed this part of the changelog. "visible via fs/proc" is not
the only change. Another change is how the tracee reacts to SIGCONT
after that. With this patch it can't wake the tracee up.

Consider the simplest example. The tracee is single-threaded and
debugger == parent. Something like

	int main(void)
	{
		int child, status;

		child = fork();
		if (!child) {
			ptrace(PTRACE_TRACEME);

			kill(getpid(), SIGSTOP);

			return 0;
		}

		wait(&status)
		// the tracee reports the signal
		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
		// it should stop after that
		ptrace(PTRACE_CONT, child, SIGSTOP);

		wait(&status);
		// now it is stopped
		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);

		kill(child, SIGCONT);

		wait(&status);
		assert(WIFSTOPPED() && WSTOPSIG() == SIGCONT);

This won't work with this patch. the last do_wait() will hang forever.
Probably this is fine, I do not know. Please take a look and ack/nack
explicitly.


However. There is something I missed previously, and this small
detail doesn't look good to me: the behaviour of SIGCONT becomes
a bit unpredictable. Suppose it races with do_signal_stop() and
clears GROUP_STOP_PENDING or SIGNAL_STOP_DEQUEUED before, in this
case in can "wakeup" the tracee.

IOW. Let's remove the 2nd wait() in the code above, the parent
does

		wait(&status)
		// the tracee reports the signal
		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
		// it should stop after that
		ptrace(PTRACE_CONT, child, SIGSTOP);

		kill(child, SIGCONT);

Now we can't know id this SIGCONT works or not. If the tracee
is already parked in ptrace_stop() - it doesn't. If the parent
wins - the tracee doesn't stop.



OTOH. Looking at this patch, I can no longer understand why
ptrace_check_attach() can silently do s/STOPPED/TRACED/. Indeed,
as Tejun pointed out, if ptrace_stop() needs arch_ptrace_stop(),
then ptrace_check_attach() should be arch-friendly as well.

So, the patch looks like the bugfix, but I do not understand this
ia64/sparc magic and thus I do not know how important this fix.
Nobody complained so far, though.

Roland, could you comment this part?

Oleg.

