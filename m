Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1BQQ54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1BQQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:57:53 -0500
Date: Thu, 17 Feb 2011 17:49:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110217164906.GA5167@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110216215157.GA6054@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216215157.GA6054@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Jan Kratochvil wrote:
>
> On Mon, 14 Feb 2011 18:20:52 +0100, Denys Vlasenko wrote:
> > Jan, please put on your gdb maintainer's hat, we need your opinion here.
> > Is it a problem from gdb's POV?
>
> Here is a summary of current and my wished behavior:
>
> Make PTRACE_DETACH (data=SIGSTOP) working

(OK, but afaics this is a bit off-topic ;).

> - that is to leave the process in
> `T (stopped)' without any single PC step.

This is not exactly clear to me... I mean "without any single PC step".
Why?

> This works in some kernels and
> does not work in other kernels,

Afaics, this only works in utrace-based kernels.

In upstream kernel, we have the extra wake_up_state() in ptrace_detach().
And,

> it is "detach-stopped" test in:

But there is another problem which can't be really tested by detach-stopped
(because it detaches when the tracee was already stopped). The
SIGNAL_STOP_DEQUEUED logic is not correct.

> The current upstream GDB trick of
>   PTRACE_ATTACH
>   if /proc/PID/status->State: == `T (stopped)'
>     tgkill(SIGSTOP)
>     PTRACE_CONT(0)
>   waitpid->SIGSTOP (or preceded by some other signal but 1x SIGSTOP will come)
> should remain compatible,

Oh. OK. It should be at first glance, despite the fact PTRACE_CONT()
doesn't actually resume. But then we need this patch ;)

> Make the GDB trick above no longer needed,

It is still needed. Again, this patch should make this trick unnecessary.

(To clarify, Tejun's patches fix this problem too, but we are trying to
 discuss another behaviour).

> so that in the case it was invented
> for a simple PTRACE_ATTACH, wait->SIGSTOP, PTRACE_DETACH(0) also works:
>   foreign process: kill(child process, SIGSTOP)
>   parent process:  wait() -> SIGSTOP (the notification is now eaten-out)
>   child process is now in `T (stopped)'
>   debugger: PTRACE_ATTACH(child process)
>   debugger: waitpid -> should get SIGSTOP, even despite it was eaten-out above
> This works in some kernels and does not work in other kernels.

Yes, but in fact this is another problem, it was fixed by 90bc8d8b
"do_wait: fix waiting for the group stop with the dead leader".



> A new proposal is to preserve the process's `T (stopped)' for
> a naive/legacy debugger / ptrace tool doing PTRACE_ATTACH, wait->SIGSTOP,
> PTRACE_DETACH(0), incl. GDB doing the "GDB trick" above.
> That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> iff the process was `T (stopped)' before PTRACE_ATTACH.
>  - PTRACE_DETACH(0)       should preserve `T (stopped)'.

Hmm. OK, but I assume you meant "unless the tracee was resumed in between".

> but also:
>  - PTRACE_DETACH(SIGSTOP) should force `T (stopped)'.
>  - PTRACE_DETACH(SIGCONT) should force freely running process.

OK... Yes, perhaps PTRACE_{DETACH,CONT}(SIGCONT) should override
SIGNAL_STOP_STOPPED too. This makes sense, and this connects to
the problem with SIGNAL_STOP_DEQUEUED I mentioned above.

But. Let me remind. PTRACE_DETACH(SIGXXX) does not always work as
gdb thinks, SIGXXX can be ignored. For example, PTRACE_KILL-after-
step-into-handler gdb bug. But this is another story.

> The behavior of SIGSTOP and SIGCONT received during active ptrace session
> I find as a new feature without having much to keep backward compatibibility.
> +
> You have concluded a plan how to do a real `T (stopped)' on received SIGSTOP
> using PTRACE_GETSIGINFO, OK, go with that.

Well, not exactly. Please forget about PTRACE_GETSIGINFO.

Suppose that the tracee is 'T (stopped)'. Because the debugger did
PTRACE_CONT(SIGSTOP), or because debugger attached to the stopped task.

Currently, PTRACE_CONT(WHATEVER) after that always resumes the tracee,
despite the fact it is still stopped in some sense. This leads to
numerous oddities/bugs.

What we propose is to change this so that the tracee does not run
until it actually recieves SIGCONT. Yes, _perhaps_ PTRACE_CONT(SIGCONT)
should be treated specially, but I think this is relatively minor issue.

> Personally I would keep it completely hidden from the debugger and only
> remember the last SIGCONT vs. SIGSTOP for the case the session ends with
> PTRACE_DETACH(0).  Debugger/strace would not be able to display any externally
> received SIGSTOP/SIGCONT.  PTRACE_CONT(SIGSTOP) and PTRACE_CONT(SIGCONT)
> should behave as PTRACE_CONT(0) to clean up compatibility with existing tools.

Can't understand... could you explain?

Oleg.

