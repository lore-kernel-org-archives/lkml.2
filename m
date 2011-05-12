Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab1ELSVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:21:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab1ELSVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:21:21 -0400
Date: Thu, 12 May 2011 20:20:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
	ptrace_check_attach()
Message-ID: <20110512182006.GA25850@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-11-git-send-email-tj@kernel.org> <20110511164947.GA26383@redhat.com> <20110511195333.GE24245@mtj.dyndns.org> <20110512155910.GD18599@redhat.com> <20110512160709.GL1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512160709.GL1030@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Tejun Heo wrote:
>
> On Thu, May 12, 2011 at 05:59:10PM +0200, Oleg Nesterov wrote:
>
> > Also. _Perhaps_ we can rethink the SIGCONT trapping, and perhaps in
> > this case do_wait() won't need any changes. May be.
>
> But, if there's a better way, sure.

Unfortunately, I have no any particular ideas right now, and I doubt
I can invent something clean. But I'd like at least to try to think
a bit.


Now about GROUP_STOP_TRAPPING. To simplify the discussion, lets
forget about this series, please recall the previous
"ptrace: use GROUP_STOP_TRAPPING for PTRACE_DETACH too" change.

http://marc.info/?l=linux-kernel&m=130486589601593

In short, it changes __ptrace_unlink() to set _TRAPPING if needed,
and ptrace_attach() waits for !TRAPPING unconditionally.

Problem: TRAPPING can be set outside of do_signal_stop() paths, and
I think we should avoid this as much as possible.

(I am ignoring the problem this patch addresses temporary, I think
 we can fix it a bit differently).

As we already discussed, this patch is not right, we have the problems
with KILL/CONT. The proposed solution is to clear TRAPPING on kill,
but I think this is not enough.

One particular example. Note that de_thread() waits ->notify_count == 0
in TASK_UNINTERRUPTIBLE. Btw, this is not good, we need TASK_KILLABLE,
but this doesn't matter in this discussion. The only imporant thing is
that it is practically impossible to make this path restartable.

Note also we have PT_TRACE_EXIT, the sub-thread stops even if killed by
the execing thread. (to clarify, this depends on /dev/random and should
be fixed, and in fact it is debatable whether it should stop, please
ignore).

Now suppose we are tracing 2 threads, T1 execs and kills T2, T2 reports
PTRACE_EVENT_EXIT. Now, if the tracer waits for !(T1 & TRAPPING), it will
wait forever.


Say, the thread group was stopped, the tracer PTRACE_CONT's T1, it calls
sys_execve() and reports the trap from syscall_trace_enter().

The tracer does ptrace(T1, DETACH) + ptrace(T1, SEIZE) and hangs forever.


Once again, this is only one example. coredump, vfork, probably something
else. In short: I think that TRAPPING-outside-of-do_signal_stop is the
can of worms.

Oleg.

