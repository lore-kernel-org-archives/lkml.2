Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab1EYOc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:32:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42169 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab1EYOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IDCw+br9fjL8R7bBeONb0ZRqYWVphTB6k/akYtTlUEeBHw+SJ//EBbk3NcS33yMnMd
         KtF7TOHTnD/Wy1Qi3pXYM0gI5ADe3HgUPw14YghoRF6mTdEyx0y4j8ji2P8Wa7A+hOhx
         Ou1XaPoMyo6HwmjC5TQ/nPro7Q5dUSxfJZYiQ=
Date: Wed, 25 May 2011 16:32:50 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: Ptrace documentation, draft #3
Message-ID: <20110525143250.GJ10146@htj.dyndns.org>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Fri, May 20, 2011 at 09:23:07PM +0200, Denys Vlasenko wrote:
> When running tracee enters ptrace-stop, it notifies its tracer using
> waitpid API. Tracer should use waitpid family of syscalls to wait for
> tracee to stop. Most of this document assumes that tracer waits with:
> 	pid = waitpid(pid_or_minus_1, &status, __WALL);

It might not be the best idea to listen for WCONTINUED from ptracer.
Unlike stop (or trapped) state, the continued state is per-process and
consuming it would confuse other parents (including the real parent)
of the process.  Plus, continued exit state doesn't carry much
interesting information for ptracer anyway (it can't be used for group
stop state tracking).

> Ptrace-stopped tracees are reported as returns with pid > 0 and
> WIFSTOPPED(status) == true.
> 
> ??? any pitfalls with WNOHANG (I remember that there are bugs in this
>     area)? effects of WSTOPPED, WEXITED, WCONTINUED bits? Are they ok?
>     waitid usage? WNOWAIT?

Yes, there are some race conditions around WNOHANG waits.  If ptracer
is waiting only for stopped state, it shouldn't be visible, I think,
but there are race conditions where transitions between different
states race with WNOHANG wait and wait(2) fails unexpectedly.  Should
be fixed eventually but it has been broken for a very long time.

> 	1.x.x Signal-delivery-stop
> 
> When (possibly multi-threaded) process receives any signal except
> SIGKILL, kernel selects a thread which handles the signal (if signal is
> generated with tgkill, thread selection is done by user). If selected
> thread is traced, it enters signal-delivery-stop. By this point, signal
> is not yet delivered to the process, and can be suppressed by tracer.
> If tracer doesn't suppress the signal, it passes signal to tracee in
> the next ptrace request. This is called "signal injection" and will be
> described later.

I think it would be better to discern between actual signal delivery
and injection.  I'll write more later.

> Note that if signal is blocked, signal-delivery-stop doesn't happen
> until signal is unblocked, with the usual exception that SIGSTOP
> can't be blocked.
>
> Signal-delivery-stop is observed by tracer as waitpid returning with
> WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. If
> WSTOPSIG(status) == SIGTRAP, this may be a different kind of
> ptrace-stop - see "Syscall-stops" and "execve" sections below for
> details. If WSTOPSIG(status) == stopping signal, this may be a
> group-stop - see below.

It might be better to first outline different ptrace-stops and how to
discern them?

> 	1.x.x Signal injection and suppression.
> 
> After signal-delivery-stop is observed by tracer, tracer should restart
> tracee with
> 	ptrace(PTRACE_rest, pid, 0, sig)
> call, where PTRACE_rest is one of the restarting ptrace ops. If sig is
> 0, then signal is not delivered. Otherwise, signal sig is delivered.
> This operation is called "signal injection", to distinguish it from
> signal delivery which causes signal-delivery-stop.

Hmmm... I'm unsure whether injection is the appropriate word here
especially because we also have pure signal injections in other ptrace
requests where the kernel really just injects (sends) the requested
signal, which will traverse the signal delivery path later.

This is part of signal delivery path.  Kernel is consulting what to do
about the signal with the ptracer.  The signal is not being injected
by ptracer although it can be squashed or modified.

> Note that sig value may be different from WSTOPSIG(status) value -
> tracer can cause a different signal to be injected.
>
> Note that suppressed signal still causes syscalls to return
> prematurely. Restartable syscalls will be restarted (tracer will
> observe tracee to execute restart_syscall(2) syscall if tracer uses
> PTRACE_SYSCALL), non-restartable syscalls (for example, nanosleep) may
> return with -EINTR even though no observable signal is injected to the
> tracee.

AFAICS, this can also happen when there's no ptracer.
signal_pending() can trigger -EINTR return and signal delivery can
race with other threads and by the time the woken up thread reaches
signal delivery path, there could be no pending signal left and -EINTR
will happen without actually the thread deliverying anything.

> Note that restarting ptrace commands issued in ptrace-stops other than
> signal-delivery-stop are not guaranteed to inject a signal, even if sig
> is nonzero. No error is reported, nonzero sig may simply be ignored.
> Ptrace users should not try to "create new signal" this way: use
> tgkill(2) instead.
>
> This is a cause of confusion among ptrace users. One typical scenario
> is that tracer observes group-stop, mistakes it for
> signal-delivery-stop, restarts tracee with ptrace(PTRACE_rest, pid, 0,
> stopsig) with the intention of injecting stopsig, but stopsig gets
> ignored and tracee continues to run.

Yes, so, IMHO it's important to discern these two.  One is delivery,
the other is injection.  Dunno why but injections aren't even
consistent.  It's available for some traps, not for others.  Also, the
injected signal is fundamentally different in that it'll later go
through signal delivery path to be actually delivered.

I think it would be best to discourage the use of injections and only
deal with signals when ptrace reports a signal to deliver.

> SIGCONT signal has a side effect of waking up (all threads of)
> group-stopped process. This side effect happens before
> signal-delivery-stop.

More precisely, it happens at the time SIGCONT is sent.

> Tracer can't suppress this side-effect (it can
> only suppress signal injection, which only causes SIGCONT handler to
> not be executed in the tracee, if such handler is installed). In fact,
> waking up from group-stop may be followed by signal-delivery-stop for
> signal(s) *other than* SIGCONT, if they were pending when SIGCONT was
> delivered. IOW: SIGCONT may be not the first signal observed by the
> tracee after it was sent.

Please also note that from 2.6.40, the waking up won't happen if the
tracee is ptraced.  Before 2.6.40, if ptracer didn't issue any further
ptrace request after group stop, tracee was woken up by SIGCONT.  It
was racy and buggy and both strace and gdb issued further ptrace
requests right away so wasn't being used.

> Stopping signals cause (all threads of) process to enter group-stop.
> This side effect happens after signal injection, and therefore can be
> suppressed by tracer.

Maybe it would be clearer to state that group stop is initiated by the
delivery of a stop signal and ended by sending of SIGCONT?  I think
clearly distinguishing different stages of signal handling would be
nice.  It's visible to ptracer anyway.  ie. sending -> dequeueing (and
consulting ptracer via signal delivery ptrace-stop) -> delivery
(sigaction taken).

> PTRACE_GETSIGINFO can be used to retrieve siginfo_t structure which
> corresponds to delivered signal. PTRACE_SETSIGINFO may be used to
> modify it. If PTRACE_SETSIGINFO has been used to alter siginfo_t,
> si_signo field and sig parameter in restarting command must match.

Yeap and if it doesn't match, kernel generates a standard user signal
one but probably best to state that the outcome is undefined.

> 	1.x.x Group-stop
> 
> When a (possibly multi-threaded) process receives a stopping signal,
> all threads stop. If some threads are traced, they enter a group-stop.
> Note that stopping signal will first cause signal-delivery-stop (on one
> tracee only), and only after it is injected by tracer (or after it was
> dispatched to a thread which isn't traced), group-stop will be
> initiated on ALL tracees within multi-threaded process. As usual, every
> tracee reports its group-stop to corresponding tracer.

Again, if we discern different stages of signal handling, I think the
above can be much clearly explained.  Group stop is initiated when a
stop signal is delivered.  Also, note that without the distinction
between "delivery" and "injection", the above paragraph is inaccurate.
After an actual signal injection, group stop won't be initiated until
it is actually delivered by some thread in the group.

> Group-stop is observed by tracer as waitpid returning with
> WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. The same result
> is returned by some other classes of ptrace-stops, therefore the
> recommended practice is to perform
> 	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo)
> call. The call can be avoided if signal number is not SIGSTOP, SIGTSTP,
> SIGTTIN or SIGTTOU - only these four signals are stopping signals. If
> tracer sees something else, it can't be group-stop. Otherwise, tracer
> needs to call PTRACE_GETSIGINFO. If PTRACE_GETSIGINFO fails, then it is
> definitely a group-stop.

It might also be worth watching the error code.  -EINVAL failure
firmly indicates group stop but it may also fail with -ESRCH as you
pointed out before.

> As of kernel 2.6.38, after tracer sees tracee ptrace-stop and until it
> restarts or kills it, tracee will not run, and will not send
> notifications (except SIGKILL death) to tracer, even if tracer enters
> into another waitpid call.

This isn't strictly true.  There's a race window there and tracee
could be woken up behind ptracer's back if SIGCONT is sent before the
first ptrace request after group stop.  This race window should be
gone from 2.6.40.

> Currently, it causes a problem with transparent handling of stopping
> signals: if tracer restarts tracee after group-stop, SIGSTOP is
> effectively ignored: tracee doesn't remain stopped, it runs. If tracer
> doesn't restart tracee before entering into next waitpid, future
> SIGCONT will not be reported to the tracer. Which would make SIGCONT to
> have no effect.
...
> 	1.x.x Syscall-stops
> 
> If tracee was restarted by PTRACE_SYSCALL, tracee enters
> syscall-enter-stop just prior to entering any syscall. If tracer
> restarts it with PTRACE_SYSCALL, tracee enters syscall-exit-stop when
> syscall is finished, or if it is interrupted by a signal. (That is,
> signal-delivery-stop never happens between syscall-enter-stop and
> syscall-exit-stop, it happens *after* syscall-exit-stop).
> 
> Other possibilities are that tracee may stop in a PTRACE_EVENT stop,
> exit (if it entered exit or exit_group syscall), be killed by SIGKILL,
> or die silently (if execve syscall happened in another thread).
> 
> Syscall-enter-stop and syscall-exit-stop are observed by tracer as
> waitpid returning with WIFSTOPPED(status) == true, WSTOPSIG(status) ==
> SIGTRAP. If PTRACE_O_TRACESYSGOOD option was set by tracer, then
> WSTOPSIG(status) == (SIGTRAP | 0x80).

This is because it is handled as a real signal delivery.  Kernel
actually queues the signal than taking trap there.  Later, signal
delivery path kicks in and what userland sees is the actual delivery
of that kernel generated signal and being an actual signal it
interferes with user generated SIGTRAPs, siginfo can be lost under
memory pressure and so on.

> There is no portable way to distinguish them from signal-delivery-stop
> with SIGTRAP. Some architectures allow to distinguish them by examining
> registers. For example, on x86 rax = -ENOSYS in syscall-enter-stop.
> Since SIGTRAP (like any other signal) always happens *after*
> syscall-exit-stop, and at this point rax almost never contains -ENOSYS,
> SIGTRAP looks like "syscall-stop which is not syscall-enter-stop", IOW:
> it looks like a "stray syscall-exit-stop" and can be detected this way.
> But such detection is fragile and is best avoided. Using
> PTRACE_O_TRACESYSGOOD option is a recommended method.
> 
> ??? can be distinguished by PTRACE_GETSIGINFO, si_code <= 0 if sent by
> usual suspects like [t]kill, sigqueue; or = SI_KERNEL (0x80) if sent by
> kernel, whereas syscall-stops have si_code = SIGTRAP or (SIGTRAP |
> 0x80). Right? Should this be documented?

Yes, no user sent signal can have si_code > 0.

> Syscall-enter-stop and syscall-exit-stop are indistinguishable from
> each other by tracer. Tracer needs to keep track of the sequence of
> ptrace-stops in order to not misinterpret syscall-enter-stop as
> syscall-exit-stop or vice versa. The rule is that syscall-enter-stop is
> always followed by syscall-exit-stop, PTRACE_EVENT stop or tracee's
> death - no other kinds of ptrace-stop can occur in between.
> 
> If after syscall-enter-stop tracer uses restarting command other than
> PTRACE_SYSCALL, syscall-exit-stop is not generated.
> 
> PTRACE_GETSIGINFO on syscall-stops returns si_signo = SIGTRAP, si_code
> = SIGTRAP or (SIGTRAP | 0x80).

This needs more discussion but I think it would be better to unify all
trapping mechanism into ptrace traps with unique PTRACE_EVENT_* codes.
This way, it wouldn't interact with user signals or affected by memory
pressure and most notifications can be handled the same way by the
ptracer.

> 	1.x Informational and restarting ptrace commands.
> 
> Most ptrace commands (all except ATTACH, TRACEME, KILL) require tracee
> to be in ptrace-stop, otherwise they fail with ESRCH.
> 
> When tracee is in ptrace-stop, tracer can read and write data to tracee
> using informational commands. They leave tracee in ptrace-stopped state:
> 
> longv = ptrace(PTRACE_PEEKTEXT/PEEKDATA/PEEKUSER, pid, addr, 0);
> 	ptrace(PTRACE_POKETEXT/POKEDATA/POKEUSER, pid, addr, long_val);
> 	ptrace(PTRACE_GETREGS/GETFPREGS, pid, 0, &struct);
> 	ptrace(PTRACE_SETREGS/SETFPREGS, pid, 0, &struct);
> 	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo);
> 	ptrace(PTRACE_SETSIGINFO, pid, 0, &siginfo);
> 	ptrace(PTRACE_GETEVENTMSG, pid, 0, &long_var);
> 	ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_flags);
> 
> Note that some errors are not reported. For example, setting siginfo
> may have no effect in some ptrace-stops, yet the call may succeed
> (return 0 and don't set errno).

Yeah, it should be used pretty much only during signal delivery stop.

> 	1.x Attaching and detaching
> 
> A thread can be attached to tracer using ptrace(PTRACE_ATTACH, pid, 0,
> 0) call. This also sends SIGSTOP to this thread. If tracer wants this
> SIGSTOP to have no effect, it needs to suppress it. Note that if other
> signals are concurrently sent to this thread during attach, tracer may
> see tracee enter signal-delivery-stop with other signal(s) first! The
> usual practice is to reinject these signals until SIGSTOP is seen, then
> suppress SIGSTOP injection. The design bug here is that attach and
> concurrent SIGSTOP are racing and SIGSTOP may be lost.

Heh, yeah, it's broken.

> ??? Describe how to attach to a thread which is already group-stopped.

No idea.  Sorry.

> Since attaching sends SIGSTOP and tracer usually suppresses it, this
> may cause stray EINTR return from the currently executing syscall in
> the tracee, as described in "signal injection and suppression" section.

As I wrote before, I think this can happen regardless of ptrace.

> ptrace(PTRACE_TRACEME, 0, 0, 0) request turns current thread into a
> tracee. It continues to run (doesn't enter ptrace-stop). A common
> practice is follow ptrace(PTRACE_TRACEME) with raise(SIGSTOP) and allow
> parent (which is our tracer now) to observe our signal-delivery-stop.
> 
> If PTRACE_O_TRACE[V]FORK or PTRACE_O_TRACECLONE options are in effect,
> then children created by (vfork or clone(CLONE_VFORK)), (fork or
> clone(SIGCHLD)) and (other kinds of clone) respectively are
> automatically attached to the same tracer which traced their parent.
> SIGSTOP is delivered to them, causing them to enter
> signal-delivery-stop after they exit syscall which created them.
> 
> Detaching of tracee is performed by ptrace(PTRACE_DETACH, pid, 0, sig).
> PTRACE_DETACH is a restarting operation, therefore it requires tracee
> to be in ptrace-stop. If tracee is in signal-delivery-stop, signal can
> be injected. Othervice, sig parameter may be silently ignored.
>
> If tracee is running when tracer wants to detach it, the usual solution
> is to send SIGSTOP (using tgkill, to make sure it goes to the correct
> thread), wait for tracee to stop in signal-delivery-stop for SIGSTOP
> and then detach it (suppressing SIGSTOP injection). Design bug is that
> this can race with concurrent SIGSTOPs. Another complication is that
> tracee may enter other ptrace-stops and needs to be restarted and
> waited for again, until SIGSTOP is seen. Yet another complication is to
> be sure that tracee is not already group-stopped, because no signal
> delivery happens while it is - not even SIGSTOP.
> 
> ??? is above accurate?

Mostly, I think.  The only thing is that a stopped tracee doesn't
deliver signals regardless of where it's stopped.  It doesn't matter
whether it's group stop or ptrace stop.

> ??? Describe how to detach from a group-stopped tracee so that it
>     doesn't run, but continues to wait for SIGCONT.

Currently, this department is so thoroughly broken, I don't think
there's a way to do it in generic manner.  We can suit the solution
sequence to one scenario but it will break for others.

> If tracer dies, all tracees are automatically detached and restarted,
> unless they were in group-stop. Handling of restart from group-stop is
> currently buggy, but "as planned" behavior is to leave tracee stopped
> and waiting for SIGCONT. If tracee is restarted from
> signal-delivery-stop, pending signal is injected.

Yeap, the plan is to decouple group stop and tracee execution.

> 	1.x execve under ptrace.
> 
...
>   ** we get death notification: leader died: **
>  PID0 exit(0)                            = ?
>   ** we get syscall-entry-stop in thread 1: **
>  PID1 execve("/bin/foo", "foo" <unfinished ...>
>   ** we get syscall-entry-stop in thread 2: **
>  PID2 execve("/bin/bar", "bar" <unfinished ...>
>   ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
>   ** we get syscall-exit-stop for PID0: **
>  PID0 <... execve resumed> )             = 0
> 
> ??? Question: WHICH execve succeeded? Can tracer figure it out?

Hmmm... I don't know.  Maybe we can set ptrace message to the original
tid?

> 	1.x Real parent
> 
> Ptrace API (ab)uses standard Unix parent/child signaling over waitpid.
> This used to cause real parent of the process to stop receiving several
> kinds of waitpid notifications when child process is traced by some
> other process.
> 
> Many of these bugs have been fixed, but as of 2.6.38 several still
> exist.

Yeap, it should behave sanely from 2.6.40.

Wheee... that's a long scary document.  Thanks a lot.

-- 
tejun
