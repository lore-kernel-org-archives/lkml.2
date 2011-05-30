Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1E3DIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:08:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53440 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1E3DIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=V7rwgRQTl1YtXhIlPHYB9otj8DYdsmQPj5VXj40p3kvSKWAIFi8NoJj5OOdKSbf6Kd
         mrV/OIO8w5WA+11Lomx3Oknj7AkJRA9ybj3k/86yM/2q2cnIpx6cXT/2QexP+ofJrOXy
         NfyRjLibBDUMGt0n3jtSFM4TsdIfX8JlFTN3Y=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: Ptrace documentation, draft #3
Date: Mon, 30 May 2011 05:08:29 +0200
User-Agent: KMail/1.8.2
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <20110525143250.GJ10146@htj.dyndns.org>
In-Reply-To: <20110525143250.GJ10146@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201105300508.29402.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011 16:32, Tejun Heo wrote:
> On Fri, May 20, 2011 at 09:23:07PM +0200, Denys Vlasenko wrote:
> > When running tracee enters ptrace-stop, it notifies its tracer using
> > waitpid API. Tracer should use waitpid family of syscalls to wait for
> > tracee to stop. Most of this document assumes that tracer waits with:
> > 	pid = waitpid(pid_or_minus_1, &status, __WALL);
> 
> It might not be the best idea to listen for WCONTINUED from ptracer.
> Unlike stop (or trapped) state, the continued state is per-process and
> consuming it would confuse other parents (including the real parent)
> of the process.  Plus, continued exit state doesn't carry much
> interesting information for ptracer anyway (it can't be used for group
> stop state tracking).

Added this info to the next doc revision.


> > Ptrace-stopped tracees are reported as returns with pid > 0 and
> > WIFSTOPPED(status) == true.
> > 
> > ??? any pitfalls with WNOHANG (I remember that there are bugs in this
> >     area)? effects of WSTOPPED, WEXITED, WCONTINUED bits? Are they ok?
> >     waitid usage? WNOWAIT?
> 
> Yes, there are some race conditions around WNOHANG waits.  If ptracer
> is waiting only for stopped state, it shouldn't be visible, I think,
> but there are race conditions where transitions between different
> states race with WNOHANG wait and wait(2) fails unexpectedly.  Should
> be fixed eventually but it has been broken for a very long time.

Added this info to the next doc revision.


> > 	1.x.x Signal-delivery-stop
> > 
> > When (possibly multi-threaded) process receives any signal except
> > SIGKILL, kernel selects a thread which handles the signal (if signal is
> > generated with tgkill, thread selection is done by user). If selected
> > thread is traced, it enters signal-delivery-stop. By this point, signal
> > is not yet delivered to the process, and can be suppressed by tracer.
> > If tracer doesn't suppress the signal, it passes signal to tracee in
> > the next ptrace request. This is called "signal injection" and will be
> > described later.
> 
> I think it would be better to discern between actual signal delivery
> and injection.  I'll write more later.

I think it's just a matter of agreeing on a terminology.
In this doc, I call this "signal delivery (under ptrace)":

waitpid: WIFSTOPPED == 1, WSTOPSIG == sig

and call this subsequent operation "signal injection":

ptrace(PTRACE_cont, pid, 0, sig);

I am not particularly attached to these exact terms.
Maybe yours will sound better. How would you call these things?

 
> > Note that if signal is blocked, signal-delivery-stop doesn't happen
> > until signal is unblocked, with the usual exception that SIGSTOP
> > can't be blocked.
> >
> > Signal-delivery-stop is observed by tracer as waitpid returning with
> > WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. If
> > WSTOPSIG(status) == SIGTRAP, this may be a different kind of
> > ptrace-stop - see "Syscall-stops" and "execve" sections below for
> > details. If WSTOPSIG(status) == stopping signal, this may be a
> > group-stop - see below.
> 
> It might be better to first outline different ptrace-stops and how to
> discern them?

Yes.

 
> > 	1.x.x Signal injection and suppression.
> > 
> > After signal-delivery-stop is observed by tracer, tracer should restart
> > tracee with
> > 	ptrace(PTRACE_rest, pid, 0, sig)
> > call, where PTRACE_rest is one of the restarting ptrace ops. If sig is
> > 0, then signal is not delivered. Otherwise, signal sig is delivered.
> > This operation is called "signal injection", to distinguish it from
> > signal delivery which causes signal-delivery-stop.
> 
> Hmmm... I'm unsure whether injection is the appropriate word here
> especially because we also have pure signal injections in other ptrace
> requests where the kernel really just injects (sends) the requested
> signal, which will traverse the signal delivery path later.

I don't know any (documented) way to do something like this.
Please elaborate.


> This is part of signal delivery path.  Kernel is consulting what to do
> about the signal with the ptracer.  The signal is not being injected
> by ptracer although it can be squashed or modified.

You don't like the word "inject" because it implies *creation*
of a new signal? Propose different term please.


> > Note that sig value may be different from WSTOPSIG(status) value -
> > tracer can cause a different signal to be injected.
> >
> > Note that suppressed signal still causes syscalls to return
> > prematurely. Restartable syscalls will be restarted (tracer will
> > observe tracee to execute restart_syscall(2) syscall if tracer uses
> > PTRACE_SYSCALL), non-restartable syscalls (for example, nanosleep) may
> > return with -EINTR even though no observable signal is injected to the
> > tracee.
> 
> AFAICS, this can also happen when there's no ptracer.
> signal_pending() can trigger -EINTR return and signal delivery can
> race with other threads and by the time the woken up thread reaches
> signal delivery path, there could be no pending signal left and -EINTR
> will happen without actually the thread deliverying anything.

It can't happen in single-threaded process. Whereas under ptrace,
it can. Therefore this is still an observable effect and we can't
handwave it away.


> > Note that restarting ptrace commands issued in ptrace-stops other than
> > signal-delivery-stop are not guaranteed to inject a signal, even if sig
> > is nonzero. No error is reported, nonzero sig may simply be ignored.
> > Ptrace users should not try to "create new signal" this way: use
> > tgkill(2) instead.
> >
> > This is a cause of confusion among ptrace users. One typical scenario
> > is that tracer observes group-stop, mistakes it for
> > signal-delivery-stop, restarts tracee with ptrace(PTRACE_rest, pid, 0,
> > stopsig) with the intention of injecting stopsig, but stopsig gets
> > ignored and tracee continues to run.
> 
> Yes, so, IMHO it's important to discern these two.  One is delivery,
> the other is injection. 

And I _do_ discern them. See above.


> Dunno why but injections aren't even 
> consistent.  It's available for some traps, not for others.  Also, the
> injected signal is fundamentally different 

Fundamentally different from what?

> in that it'll later go 
> through signal delivery path to be actually delivered.
> 
> I think it would be best to discourage the use of injections and only
> deal with signals when ptrace reports a signal to deliver.

Yes, Oleg also says that for now we need to declare ptrace(PTRACE_cont, pid, 0, sig)
behavior undefined when it's done not after signal-delivery-stop.


> > SIGCONT signal has a side effect of waking up (all threads of)
> > group-stopped process. This side effect happens before
> > signal-delivery-stop.
> 
> More precisely, it happens at the time SIGCONT is sent.

>From userspace POV, this is the same thing.


> > Tracer can't suppress this side-effect (it can
> > only suppress signal injection, which only causes SIGCONT handler to
> > not be executed in the tracee, if such handler is installed). In fact,
> > waking up from group-stop may be followed by signal-delivery-stop for
> > signal(s) *other than* SIGCONT, if they were pending when SIGCONT was
> > delivered. IOW: SIGCONT may be not the first signal observed by the
> > tracee after it was sent.
> 
> Please also note that from 2.6.40, the waking up won't happen if the
> tracee is ptraced.  Before 2.6.40, if ptracer didn't issue any further
> ptrace request after group stop, tracee was woken up by SIGCONT.  It
> was racy and buggy and both strace and gdb issued further ptrace
> requests right away so wasn't being used.

I and Oleg think that we should not document this pre-2.6.40 behavior.
We should just say that currently, not PTRACE_cont'ing group-stopped tracee
is a bad idea, and PTRACE_cont'ing tracee will wake it up (make it run).


> > Stopping signals cause (all threads of) process to enter group-stop.
> > This side effect happens after signal injection, and therefore can be
> > suppressed by tracer.
> 
> Maybe it would be clearer to state that group stop is initiated by the
> delivery of a stop signal and ended by sending of SIGCONT?

I simply documented current buggy state: that group-stop is reported,
but is not retained: PTRACE_cont makes tracee run. (Hmm. what happens
in multi-threaded processes?...)


> I think 
> clearly distinguishing different stages of signal handling would be
> nice.  It's visible to ptracer anyway.  ie. sending -> dequeueing (and
> consulting ptracer via signal delivery ptrace-stop) -> delivery
> (sigaction taken).

Sending: is unobservable (it is done by someone else),
dequeuing: I call it "delivery"
delivery: I call it "injection"


> > PTRACE_GETSIGINFO can be used to retrieve siginfo_t structure which
> > corresponds to delivered signal. PTRACE_SETSIGINFO may be used to
> > modify it. If PTRACE_SETSIGINFO has been used to alter siginfo_t,
> > si_signo field and sig parameter in restarting command must match.
> 
> Yeap and if it doesn't match, kernel generates a standard user signal
> one but probably best to state that the outcome is undefined.

Added this to the next doc revision.


> > 	1.x.x Group-stop
> > 
> > When a (possibly multi-threaded) process receives a stopping signal,
> > all threads stop. If some threads are traced, they enter a group-stop.
> > Note that stopping signal will first cause signal-delivery-stop (on one
> > tracee only), and only after it is injected by tracer (or after it was
> > dispatched to a thread which isn't traced), group-stop will be
> > initiated on ALL tracees within multi-threaded process. As usual, every
> > tracee reports its group-stop to corresponding tracer.
> 
> Again, if we discern different stages of signal handling, I think the
> above can be much clearly explained.  Group stop is initiated when a
> stop signal is delivered.  Also, note that without the distinction
> between "delivery" and "injection", the above paragraph is inaccurate.
> After an actual signal injection, group stop won't be initiated until
> it is actually delivered by some thread in the group.

How would you call the stop which I call "signal-delivery-stop"?
How would you call ptrace(PTRACE_cont, pid, 0, dig) op?

 
> > Group-stop is observed by tracer as waitpid returning with
> > WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. The same result
> > is returned by some other classes of ptrace-stops, therefore the
> > recommended practice is to perform
> > 	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo)
> > call. The call can be avoided if signal number is not SIGSTOP, SIGTSTP,
> > SIGTTIN or SIGTTOU - only these four signals are stopping signals. If
> > tracer sees something else, it can't be group-stop. Otherwise, tracer
> > needs to call PTRACE_GETSIGINFO. If PTRACE_GETSIGINFO fails, then it is
> > definitely a group-stop.
> 
> It might also be worth watching the error code.  -EINVAL failure
> firmly indicates group stop but it may also fail with -ESRCH as you
> pointed out before.

Added this to the next doc revision.

 
> > As of kernel 2.6.38, after tracer sees tracee ptrace-stop and until it
> > restarts or kills it, tracee will not run, and will not send
> > notifications (except SIGKILL death) to tracer, even if tracer enters
> > into another waitpid call.
> 
> This isn't strictly true.  There's a race window there and tracee
> could be woken up behind ptracer's back if SIGCONT is sent before the
> first ptrace request after group stop.  This race window should be
> gone from 2.6.40.

Yes.


> > 	1.x.x Syscall-stops
> > 
> > If tracee was restarted by PTRACE_SYSCALL, tracee enters
> > syscall-enter-stop just prior to entering any syscall. If tracer
> > restarts it with PTRACE_SYSCALL, tracee enters syscall-exit-stop when
> > syscall is finished, or if it is interrupted by a signal. (That is,
> > signal-delivery-stop never happens between syscall-enter-stop and
> > syscall-exit-stop, it happens *after* syscall-exit-stop).
> > 
> > Other possibilities are that tracee may stop in a PTRACE_EVENT stop,
> > exit (if it entered exit or exit_group syscall), be killed by SIGKILL,
> > or die silently (if execve syscall happened in another thread).
> > 
> > Syscall-enter-stop and syscall-exit-stop are observed by tracer as
> > waitpid returning with WIFSTOPPED(status) == true, WSTOPSIG(status) ==
> > SIGTRAP. If PTRACE_O_TRACESYSGOOD option was set by tracer, then
> > WSTOPSIG(status) == (SIGTRAP | 0x80).
> 
> This is because it is handled as a real signal delivery.  Kernel
> actually queues the signal than taking trap there.  Later, signal
> delivery path kicks in and what userland sees is the actual delivery
> of that kernel generated signal and being an actual signal it
> interferes with user generated SIGTRAPs, siginfo can be lost under
> memory pressure and so on.

Has it userspace-observable effects? Such as: will blocking SIGTRAP
block it too?


> > Syscall-enter-stop and syscall-exit-stop are indistinguishable from
> > each other by tracer. Tracer needs to keep track of the sequence of
> > ptrace-stops in order to not misinterpret syscall-enter-stop as
> > syscall-exit-stop or vice versa. The rule is that syscall-enter-stop is
> > always followed by syscall-exit-stop, PTRACE_EVENT stop or tracee's
> > death - no other kinds of ptrace-stop can occur in between.
> > 
> > If after syscall-enter-stop tracer uses restarting command other than
> > PTRACE_SYSCALL, syscall-exit-stop is not generated.
> > 
> > PTRACE_GETSIGINFO on syscall-stops returns si_signo = SIGTRAP, si_code
> > = SIGTRAP or (SIGTRAP | 0x80).
> 
> This needs more discussion but I think it would be better to unify all
> trapping mechanism into ptrace traps with unique PTRACE_EVENT_* codes.
> This way, it wouldn't interact with user signals or affected by memory
> pressure and most notifications can be handled the same way by the
> ptracer.

Probably a good idea, but not a goal of this doc. The doc is meant to describe
current situation.


> > Detaching of tracee is performed by ptrace(PTRACE_DETACH, pid, 0, sig).
> > PTRACE_DETACH is a restarting operation, therefore it requires tracee
> > to be in ptrace-stop. If tracee is in signal-delivery-stop, signal can
> > be injected. Othervice, sig parameter may be silently ignored.
> >
> > If tracee is running when tracer wants to detach it, the usual solution
> > is to send SIGSTOP (using tgkill, to make sure it goes to the correct
> > thread), wait for tracee to stop in signal-delivery-stop for SIGSTOP
> > and then detach it (suppressing SIGSTOP injection). Design bug is that
> > this can race with concurrent SIGSTOPs. Another complication is that
> > tracee may enter other ptrace-stops and needs to be restarted and
> > waited for again, until SIGSTOP is seen. Yet another complication is to
> > be sure that tracee is not already group-stopped, because no signal
> > delivery happens while it is - not even SIGSTOP.
> > 
> > ??? is above accurate?
> 
> Mostly, I think.  The only thing is that a stopped tracee doesn't
> deliver signals regardless of where it's stopped.  It doesn't matter
> whether it's group stop or ptrace stop.

In this document, I presume that group-stop is a form of ptrace-stop
(for ptraced threads). [Remember: I describe what userspace sees,
not kernel's internal machinery].

So, s/tracee is not already group-stopped/tracee is not already ptrace-stopped/


> Currently, this department is so thoroughly broken, I don't think
> there's a way to do it in generic manner.  We can suit the solution
> sequence to one scenario but it will break for others.

IIRC gdb performs some scary magic which mostly works.


Expect updated doc soon.

-- 
vda
