Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1BQDiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:38:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55516 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1BQDh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Z5e5SBhCU+VUAgTMTUuPz1WWbgN9pqDHEuHaIJlHl+CSdFaFzHw96HwvCSSCLZyZLM
         q0yqqEwJTfLXWlV3EE/jivjiLViHBVGg1EEk5OaNLp11oTq0FB+M4IJjiHYwng+mP3Tc
         er0BvhBm/2fjflI8gu/iw8a7Zitgy9yXCNOGI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Thu, 17 Feb 2011 04:37:51 +0100
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <20110204105343.GA12133@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110216215157.GA6054@host1.dyn.jankratochvil.net>
In-Reply-To: <20110216215157.GA6054@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102170437.51382.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Thanks for joining!


On Wednesday 16 February 2011 22:51, Jan Kratochvil wrote:
> On Mon, 14 Feb 2011 18:20:52 +0100, Denys Vlasenko wrote:
> > Jan, please put on your gdb maintainer's hat, we need your opinion here.
> > Is it a problem from gdb's POV?
> 
> Here is a summary of current and my wished behavior:
> 
> Make PTRACE_DETACH (data=SIGSTOP) working - that is to leave the process in
> `T (stopped)' without any single PC step.

This coincides of my and Oleg's desire to make SIGSTOP working with
alls ptrace restart commands.


> This works in some kernels and 
> does not work in other kernels, it is "detach-stopped" test in:
> cvs -d :pserver:anoncvs:anoncvs@sourceware.org:/cvs/systemtap co ptrace-tests 
> 
> The current upstream GDB trick of
>   PTRACE_ATTACH
>   if /proc/PID/status->State: == `T (stopped)'
>     tgkill(SIGSTOP)
>     PTRACE_CONT(0)
>   waitpid->SIGSTOP (or preceded by some other signal but 1x SIGSTOP will come)

I don't fully understand the steps of the trick.

* ptrace(PTRACE_ATTACH)
* [do you waitpid? How exactly (once? loop until SIGSTOP or ECHILD?)]
* if /proc/PID/status->State: == `T (stopped)'   [why? Is it test
                                 "was it already stopped when we attached?"
                                 What are the other possible states?]
    tgkill(SIGSTOP)
    PTRACE_CONT(0)
* waitpid->SIGSTOP  [What does this mean? "Loop on waitpid until SIGSTOP"?]

Moreover, I don't see the actual detaching step.

Can you describe the trick in more details?


> should remain compatible, as is implemented in:
> http://sourceware.org/cgi-bin/cvsweb.cgi/src/gdb/linux-nat.c.diff?r1=1.80&r2=1.81&cvsroot=src

If I understand correctly what you are trying to do -
to inject another SIGSTOP so that DETACH won't miss it,
then a fixed ptrace which doesn't lose SIGSTOPs
will also work with the old gdb which does this trick.
The trick will be unnecessary, but it will still work.


> Make the GDB trick above no longer needed, so that in the case it was invented
> for a simple PTRACE_ATTACH, wait->SIGSTOP, PTRACE_DETACH(0) also works:
>   foreign process: kill(child process, SIGSTOP)
>   parent process:  wait() -> SIGSTOP (the notification is now eaten-out)
>   child process is now in `T (stopped)'
>   debugger: PTRACE_ATTACH(child process)
>   debugger: waitpid -> should get SIGSTOP, even despite it was eaten-out above
> This works in some kernels and does not work in other kernels.

I believe there is a proposal to add PTRACE_ATTACH_NOSTOP+PTRACE_INTERRUPT,
which I guess is basically PTRACE_STOP replacement which does not mess things up
with artificial SIGSTOP. Aha, I found it:

http://sourceware.org/ml/archer/2011-q1/msg00026.html

(I do not understand why PTRACE_ATTACH_NOSTOP doesn't simply
make next waitpid() return SIGTRAP stop, but maybe it makes sense
after deeper analysis... anyway, PTRACE_ATTACH_NOSTOP + PTRACE_INTERRUPT
sequence described there is not a problem to use by userspace)

This will work reliably both in above case and also for the case
where real parent did not eat yet the STOP notification.


> A new proposal is to preserve the process's `T (stopped)' for
> a naive/legacy debugger / ptrace tool doing PTRACE_ATTACH, wait->SIGSTOP,
> PTRACE_DETACH(0), incl. GDB doing the "GDB trick" above.

Right, that's the overarching idea: to preserve the stopped state
across ptrace ops.


> That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> iff the process was `T (stopped)' before PTRACE_ATTACH.
>  - PTRACE_DETACH(0)       should preserve `T (stopped)'.

I assume you are thinking about PTRACE_ATTACH + wait():SIGSTOP
+ PTRACE_DETACH(0) sequence.

It looks logical to use 0 in *this* sequence, but consider
the following sequence:

....
ptrace(PTRACE_CONT, 0)
waitpid(): got SIGFOO
ptrace(PTRACE_CONT/SYSCALL/DETACH, 0)

What we have here? A signal delivery notification.
In this case, in next ptrace restarting operation, we specify
whether to inject signal or not. PTRACE_DETACH is a restarting
op. SIGSTOP is a signal. Why rules for them, or their combination,
should be different? Why 0 should still inject the stop?

Basically, assuming kernel got fixed wrt loss of group-stop state,
I don't see why gdb can't simply use PTRACE_DETACH with whatever
signal it saw in last stop (using 0 if it saw non-signal stop)?
If you did see SIGSTOP delivery, pass SIGSTOP with PTRACE_DETACH,
and it will be preserved.

Regarding PTRACE_ATTACH + wait():SIGSTOP + PTRACE_DETACH(???)
sequence. I think this SIGSTOP should be considered by kernel
not to be a signal delivery ptrace stop - because this SIGSTOP
is "artificial". Therefore, next PTRACE_DETACH should ignore
its siganl parameter. IOW, it shouldn't matter whether you
use PTRACE_DETACH(0) or PTRACE_DETACH(SIGSTOP) - the stop state
should be preserved. IOW: neither SIGSTOP nor SIGCONT should
be injected. If we assume this interpretation, then PTRACE_DETACH(0)
will work correctly.


> but also:
>  - PTRACE_DETACH(SIGSTOP) should force `T (stopped)'.

Of course. It should inject SIGSTOP. That stops process
(or rather, it should. You are right that now it is now
always working).


>  - PTRACE_DETACH(SIGCONT) should force freely running process.

Of course. It should inject SIGCONT.

Do you need / want it to work even from a non-signal ptrace stop?
I.e. should this work too?

... ... waitpid():SIGTRAP + ptrace(PTRACE_DETACH, SIGCONT)


> The behavior of SIGSTOP and SIGCONT received during active ptrace session
> I find as a new feature without having much to keep backward compatibibility.
> +
> You have concluded a plan how to do a real `T (stopped)' on received SIGSTOP
> using PTRACE_GETSIGINFO, OK, go with that.
> +
> Personally I would keep it completely hidden from the debugger and only
> remember the last SIGCONT vs. SIGSTOP for the case the session ends with
> PTRACE_DETACH(0).  Debugger/strace would not be able to display any externally
> received SIGSTOP/SIGCONT.  PTRACE_CONT(SIGSTOP) and PTRACE_CONT(SIGCONT)
> should behave as PTRACE_CONT(0) to clean up compatibility with existing tools.
> For a general transparent tracing there is at least systemtap.

Again, the idea is close to what you are saying, just a bit different.

The idea is to make SIGSTOP/SIGCONT to be no different form other signals,
as far as userspace-visible ptrace API is concerned.

Thwo different ways how you end up with stopped tracee:

(1) When waitpid says that tracee got SIGSTOP, the debugger must decide, does
it want to propagate it or not. If it decides to propagate it, it does
ptrace(PTRACE_restarting_op, SIGSTOP). Which injects SIGSTOP to tracee.
If PTRACE_restarting_op == PTRACE_DETACH, the tracee is detached and stopped.
Therefore you must not use ptrace(PTRACE_DETACH, 0), it is logically wrong
if you want SIGSTOP to take effect.

(Note: there is a small twist with PTRACE_restarting_op != PTRACE_DETACH,
because the tracee is still attached and therefore it immediately reports
to debugger that it indeed has stopped in response to SIGSTOP -
which looks very similar to *SIGSTOP delivery*. For example, currently
strace is confused - it thinks that *another SIGSTOP* came in -
and issues *another* ptrace(PTRACE_SYSCALL, SIGSTOP),
which, being issued _not_ after signal delivery ptrace stop, can't inject
the SIGSTOP. Which is harmless, but confusing. Querying GETSIGINFO
can disambiguate this, and make strace output more informative. I have a patch.
But for PTRACE_DETACH it doesn't matter...)

(2) If you PTRACE_ATTACHed (or better, PTRACE_ATTACH_NOSTOP + PTRACE_INTERRUPTed,
because PTRACE_ATTACH is racy versus simultaneous SIGSTOP)
to the process which is already stopped, you don't need to do
ptrace(PTRACE_DETACH, SIGSTOP) in order to detach and leave it stopped.
Actually, if you do waitpid():SIGTRAP + ptrace(PTRACE_DETACH, <anything>),
<anything> will be ignored, because tracee is not in signal delivery ptrace stop,
so you can do ptrace(PTRACE_DETACH, SIGSTOP), no harm done:
if process was already stopped, it will remain stopped.
If it wasn't stopped, it will continue.


So, the only special trick you seem to want is to make ptrace(PTRACE_DETACH, SIGCONT)
to forcibly unpause stopped task, even if done from non-signal ptrace stop. Right?

I guess this can be special-cased, but can't the same be trivially achieved by
kill(SIGCONT) + ptrace(PTRACE_DETACH, SIGCONT)?
This will avoid the need to special case in the kernel...


-- 
vda
