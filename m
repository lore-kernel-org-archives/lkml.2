Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1EWLrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab1EWLrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:47:36 -0400
Date: Mon, 23 May 2011 13:45:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110523114559.GA5279@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-11-git-send-email-tj@kernel.org> <20110519163246.GF17265@redhat.com> <20110519165833.GA19418@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519165833.GA19418@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Oleg Nesterov wrote:
>
> I only meant
> that I got lost in details and I feel I'll ask more questions later.

... and I am greatly disappointed by the fact all technical problems I
noticed were bogus, I should try more ;)



1. __ptrace_unlink:

	task_clear_jobctl_pending(child, JOBCTL_PENDING_MASK);

	/*
	 * Reinstate JOBCTL_STOP_PENDING if group stop is in effect and
	 * @child isn't dead.
	 */
	if (!(child->flags & PF_EXITING) &&
	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
	     child->signal->group_stop_count))
		child->jobctl |= JOBCTL_STOP_PENDING;

Yes, we set JOBCTL_STOP_PENDING correctly. But what about JOBCTL_STOP_CONSUME?
It was potentially flushed by task_clear_jobctl_pending() above.




2. ptrace_trap_notify() always sets JOBCTL_TRAP_NOTIFY. Even if the caller
is prepare_signal(SIGCONT) and there were no SIGSTOP in the past. This looks
a bit strange to me. I mean, perhaps it would be better to provoke the trap
only if this SIGCONT is going to change the jobctl state.

In any case, we shouldn't set JOBCTL_TRAP_NOTIFY if fatal_signal_pending().
do_signal_stop() is fine, and prepare_signal(SIGCONT) can't race with SIGKILL.
but it can race with the zap_other_threads-like code (exec, coredump).
If we set JOBCTL_TRAP_NOTIFY when fatal_signal_pending() is true, the tracee
can't stop, it will call get_signal_to_deliver()->ptrace_stop() in a loop
forever and the tracer can't clear this bit.

Minor, but perhaps it would be more consistent to check PF_EXITING in
the !task_is_traced() case.




3. The similar (but currently theoretical) problem with PTRACE_TRAP_STOP.
We shouldn't assume anything about arch_ptrace_stop_needed(), the code
should work correctly even if it always returns true. This means that,
say, PTRACE_INTERRUPT should not set JOBCTL_TRAP_STOP if the tracee was
killed, or ptrace_stop() should clear JOBCTL_TRAP_MASK if it aborts.




-------------------------------------------------------------------------------
Now about the API. Can't we avoid the "asynchronous" re-trapping and the
subsequent complications like PTRACE_GETSIGINFO-must-be-called-to-cont?

What if we simply add the new request, say, PTRACE_JOBCTL_CONT which acts
as "do not cont, but please report me the next change in jctl state". IOW,
in short, instead of JOBCTL_BLOCK_NOTIFY we add JOBCTL_PLEASE_NOTIFY which
is set by this request.

Roughly, PTRACE_JOBCTL_CONT works as follows:

	- it is only valid if the tracee reported PTRACE_EVENT_STOP

	- SIGCONT/do_signal_stop/prepare_signal(SIGCONT) set
	  JOBCTL_TRAP_NOTIFY but do not wakeup unless
	  JOBCTL_PLEASE_NOTIFY was set by PTRACE_JOBCTL_CONT

	- of course, PTRACE_JOBCTL_CONT checks if JOBCTL_TRAP_NOTIFY
	  is already set.

As for PTRACE_CONT, it should set JOBCTL_PLEASE_NOTIFY if we resume the
stopped tracee. Or the tracer can do PTRACE_JOBCTL_CONT + PTRACE_CONT.


So. If the tracer wants to wait for SIGCONT after the tracee reports the
jobctl stop, it can simply do PTRACE_JOBCTL_CONT and wait(). This looks
much simpler to me. The only (afaics) complication is: PTRACE_INTERRUPT
should guarantee the trap after PTRACE_JOBCTL_CONT (in this case we can
simply set ->exit_code, no need to re-trap).

si_pt_flags (or whatever we use to report the jobctl state) can be recorded
during the trap, not at the time of ptrace() syscall.

The implementation should be simpler too. Only ptrace_attach() needs the
wait_trapping() logic, no need to complicate do_wait(). The tracee re-traps
only if the tracer asks for this.

And _imho_ this is more understandable from the user-space pov. To me it
is a bit strange a TASK_TRACED tracee can run and then take another trap
without some sort of CONT from debugger, even if we hide the transition.

What do you think?

I must admit, I didnt think over this all thoroughly, just a sudden idea.

Oleg.

