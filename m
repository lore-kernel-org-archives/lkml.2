Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab1ERPUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:20:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49466 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1ERPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=NSk3Ltb4oFDXB9z09eL3vQ9xVqAHwJvkVftZ2/D6xRDMqbKGmAKNCtyKW6uuAePV4r
         fNqYJhtuHN5Dr66uA81hVwwbgdM7jGjjU+1Wx0VKnscfrR3pTsXEXD/PmYTlCXJhAb5G
         J+HzpOr1QF1WUgGanEo3oTU4TlY9AMNCEUXeE=
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 18 May 2011 17:19:58 +0200
Message-ID: <BANLkTin6cCfOgJWAW1pO0FMucEwWp3q4uQ@mail.gmail.com>
Subject: Ptrace documentation, draft #2
To: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ptrace discussions repeatedly display a higher than average amount
of misunderstanding and confusion. New ptrace users and even people
who already worked with it are repeatedly confused by details
which are not documented anywhere and knowledge about which exists
mostly in the brains of strace/gdb/other_such_tools developers.

This document is meant as a brain dump of this knowledge.
It assumes that the reader has basic understanding what ptrace is.

Since draft no. 1, I added/changed some info:

* PTRACE_EVENT-stops happen inside syscalls, not after them!
* explanation about execve - still unclear/incomplete and needs expanding
* how strace (mis)handles real SIGTRAP signals
* what GETSIGINFO returns on various stops

======================================================================
======================================================================
======================================================================

		Ptrace

Ptrace API (ab)uses standard Unix parent/child signaling over waitpid.
An unfortunate effect of it is that resulting API is complex and has
subtle quirks. This document aims to describe these quirks.

It is split into two parts. First part focuses exclusively on
userspace-visible API and behavior. Second section describes kernel
internals of ptrace.



		1. Userspace API.

(Note to editors: in this section, do not use kernel concepts and terms
which are not observable through userspace API and user-visible
behavior. Use section 2 for that.)

Debugged processes (tracees) first need to be attached to the debugging
process (tracer). Attachment and subsequent commands are per-thread: in
multi-threaded process, every thread can be individually attached to a
(potentially different) tracer, or left not attached and thus not
debugged. Therefore, "tracee" always means "(one) thread", never "a
(possibly multi-threaded) process". Ptrace commands are always sent to
a specific tracee using ptrace(PTRACE_foo, pid, ...), where pid is a
TID of the corresponding Linux thread.

After attachment, each tracee can be in two states: running or stopped.

There are many kinds of states when tracee is stopped, and in ptrace
discussions they are often conflated. Therefore, it is important to use
precise terms.

In this document, any stopped state in which tracee is ready to accept
ptrace commands from the tracer is called ptrace-stop. Ptrace-stops can
be further subdivided into signal-delivery-stop, group-stop,
syscall-stop and so on. They are described in detail later.


	1.x Death under ptrace.

When a (possibly multi-threaded) process receives a killing signal (a
signal set to SIG_DFL and whose default action is to kill the process),
all threads exit. Tracees report their death to the tracer(s). This is
not a ptrace-stop (because tracer can't query tracee status such as
register contents, cannot restart tracee etc) but the notification
about this event is delivered through waitpid API similarly to
ptrace-stop.

Note that killing signal will first cause signal-delivery-stop (on one
tracee only), and only after it is injected by tracer (or after it was
dispatched to a thread which isn't traced), death from signal will
happen on ALL tracees within multi-threaded process.

SIGKILL operates similarly, with exceptions. No signal-delivery-stop is
generated for SIGKILL and therefore tracer can't suppress it. SIGKILL
kills even within syscalls (syscall-exit-stop is not generated prior to
death by SIGKILL). The net effect is that SIGKILL always kills the
process (all its threads), even if some threads of the process are
ptraced.

Tracer can kill a tracee with ptrace(PTRACE_KILL, pid, 0, 0).

??? Does it kill only the tracee or the whole process? What is exit
    status? Will tracer see the death? Other tracers?

When tracee executes exit syscall, it reports its death to its tracer.
Other threads are not affected. Note that if PTRACE_O_TRACEEXIT option
is on for this tracee, PTRACE_EVENT_EXIT will happen before actual
death.

When any thread executes exit_group syscall, every tracee reports its
death to its tracer.

??? will PTRACE_EVENT_EXIT happen for *every* tracee in the group?

Tracer cannot assume that ptrace-stopped tracee exists. There are many
scenarios when tracee may die while stopped (such as SIGKILL). There
are cases where tracee disappears without reporting death (such as
execve in multithreaded process). Therefore, tracer must always be
prepared to handle ESRCH error on any ptrace operation. Unfortunately,
the same error is returned if tracee exists but is not ptrace-stopped
(for commands which require stopped tracee). Tracer needs to keep track
of stopped/running state, and interpret ESRCH as "tracee died
unexpectedly" only if it knows that tracee has been observed to enter
ptrace-stop.

There is no guarantee that waitpid(WNOHANG) will reliably report
tracee's death status if ptrace operation returned ESRCH.
waitpid(WNOHANG) may return 0 instead. IOW: tracee may be "not yet
fully dead" but already refusing ptrace ops.

Tracer can not assume that tracee ALWAYS ends its life by reporting
WIFEXITED(status) or WIFSIGNALED(status). One notable case is execve in
multi-threaded process, which is described later.


	1.x Stopped states.

When running tracee enters ptrace-stop, it notifies its tracer using
waitpid API. Tracer should use waitpid family of syscalls to wait for
tracee to stop. Most of this document assumes that tracer waits with:
	pid = waitpid(pid_or_minus_1, &status, __WALL);
Ptrace-stopped tracees are reported as returns with pid > 0 and
WIFSTOPPED(status) == true.

??? any pitfalls with WNOHANG (I remember that there are bugs in this
    area)? effects of WSTOPPED, WEXITED, WCONTINUED bits? Are they ok?
    waitid usage? WNOWAIT?


	1.x.x Signal-delivery-stop

When (possibly multi-threaded) process receives any signal except
SIGKILL, kernel selects a thread which handles the signal (if signal is
generated with tgkill, thread selection is done by user). If selected
thread is traced, it enters signal-delivery-stop. By this point, signal
is not yet delivered to the process, and can be suppressed by tracer.
If tracer doesn't suppress the signal, it passes signal to tracee in
the next ptrace request. This is called "signal injection" and will be
described later. Note that if signal is blocked, signal-delivery-stop
doesn't happen until signal is unblocked, with the usual exception that
SIGSTOP can't be blocked.

Signal-delivery-stop is observed by tracer as waitpid returning with
WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. If
WSTOPSIG(status) == SIGTRAP, this may be a different kind of
ptrace-stop - see syscall-stop section below for details. If
WSTOPSIG(status) == stopping signal, this may be a group-stop - see
below.

Kernel delivers an extra SIGTRAP to tracee after execve syscall
returns. This is an ordinary signal (similar to one generated by kill
-TRAP), not a special kind of ptrace-stop. For example, it can be
blocked by signal mask, and thus can happen (much) later.

??? can this SIGTRAP be distinguished from "real" user-generated SIGTRAP
    by looking at its siginfo? si_code = ???

If PTRACE_O_TRACEEXEC option is in effect, a PTRACE_EVENT_EXEC-stop is
generated instead.

Usually, tracer (for example, strace) would not want to show this extra
post-execve SIGTRAP signal to the user, and would suppress its delivery
to the tracee (if SIGTRAP is set to SIG_DFL, it is a killing signal).


	1.x.x Signal injection and suppression.

After signal-delivery-stop is observed by tracer, PTRACE_GETSIGINFO can
be used to retrieve corresponding siginfo_t structure.
PTRACE_SETSIGINFO may be used to modify it.

Tracer should restart tracee with
	ptrace(PTRACE_rest, pid, 0, sig)
call, where PTRACE_rest is one of the restarting ptrace ops. If sig is
0, then signal is not delivered. Otherwise, signal sig is delivered.
This operation is called "signal injection", to distinguish it from
signal delivery which causes signal-delivery-stop.

Note that sig value may be different from WSTOPSIG(status) value -
tracer can cause a different signal to be injected. If
PTRACE_SETSIGINFO has been used to alter injected signal's siginfo_t,
si_signo field and sig parameter in restarting command must match.

Note that suppressed signal still causes syscalls to return
prematurely. Restartable syscalls will be restarted (tracer will
observe tracee to execute restart_syscall(2) syscall if tracer uses
PTRACE_SYSCALL), non-restartable syscalls (for example, nanosleep) may
return with -EINTR even though no observable signal is injected to the
tracee.

Note that restarting ptrace commands issued in ptrace-stops other than
signal-delivery-stop is not guaranteed to inject a signal, even if sig
is nonzero. No error is reported, nonzero sig may simply be ignored.
Ptrace users should not try to "create new signal" this way: use
tgkill(2) instead.

This is a cause of confusion among ptrace users. One typical scenario
is that tracer observes group-stop, mistakes it for
signal-delivery-stop, restarts tracee with ptrace(PTRACE_rest, pid, 0,
stopsig) with the intention of injecting stopsig, but stopsig gets
ignored and tracee continues to run.

SIGCONT signal has a side effect of waking up (all threads of)
group-stopped process. This side effect happens before
signal-delivery-stop. Tracer can't suppress this side-effect (it can
only suppress signal injection, which only causes SIGCONT handler to
not be executed in the tracee, if such handler is installed). In fact,
waking up from group-stop may be followed by signal-delivery-stop for
signal(s) *other than* SIGCONT, if they were pending when SIGCONT was
delivered. IOW: SIGCONT may be not the first signal observed by the
tracee after it was sent.

Stopping signals cause (all threads of) process to enter group-stop.
This side effect happens after signal injection, and therefore can be
suppressed by tracer.


	1.x.x Group-stop

When a (possibly multi-threaded) process receives a stopping signal,
all threads stop. If some threads are traced, they enter a group-stop.
Note that stopping signal will first cause signal-delivery-stop (on one
tracee only), and only after it is injected by tracer (or after it was
dispatched to a thread which isn't traced), group-stop will be
initiated on ALL tracees within multi-threaded process. As usual, every
tracee reports its group-stop to corresponding tracer.

Group-stop is observed by tracer as waitpid returning with
WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. The same result
is returned by some other classes of ptrace-stops, therefore the
recommended practice is to perform
	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo)
call. The call can be avoided if signal number is not SIGSTOP, SIGTSTP,
SIGTTIN or SIGTTOU - only these four signals are stopping signals. If
tracer sees something else, it can't be group-stop. Otherwise, tracer
needs to call PTRACE_GETSIGINFO. If PTRACE_GETSIGINFO fails, then it is
definitely a group-stop.

As of kernel 2.6.38, after tracer sees tracee ptrace-stop and until it
restarts or kills it, tracee will not run, and will not send
notifications (except SIGKILL death) to tracer, even if tracer enters
into another waitpid call.

Currently, it causes a problem with transparent handling of stopping
signals: if tracer restarts tracee after group-stop, SIGSTOP is
effectively ignored: tracee doesn't remain stopped, it runs. If tracer
doesn't restart tracee before entering into next waitpid, future
SIGCONT will not be reported to the tracer. Which would make SIGCONT to
have no effect.

??? ...at least no effect on this tracee - how will other threads
    be affected?


	1.x.x PTRACE_EVENT-stops

If tracer sets TRACE_O_TRACEfoo options, tracee will enter ptrace-stops
called PTRACE_EVENT-stops.

PTRACE_EVENT-stops are observed by tracer as waitpid returning with
WIFSTOPPED(status) == true, WSTOPSIG(status) == SIGTRAP. Additional bit
is set in a higher byte of status word: value ((status >> 8) & 0xffff)
will be (SIGTRAP | PTRACE_EVENT_foo << 8). The following events exist:

PTRACE_EVENT_VFORK - stop before return from vfork/clone+CLONE_VFORK.
When tracee is continued after this, it will wait for child to
exit/exec before continuing its execution (IOW: usual behavior on
vfork).

PTRACE_EVENT_FORK - stop before return from fork/clone+SIGCHLD

PTRACE_EVENT_CLONE - stop before return from clone

PTRACE_EVENT_VFORK_DONE - stop before return from
vfork/clone+CLONE_VFORK, but after vfork child unblocked this tracee by
exiting or exec'ing.

For all four stops described above: stop occurs in parent, not in newly
created thread. PTRACE_GETEVENTMSG can be used to retrieve new thread's
tid.

PTRACE_EVENT_EXEC - stop before return from exec.

PTRACE_EVENT_EXIT - stop before exit. PTRACE_GETEVENTMSG returns exit
status. Registers can be examined (unlike when "real" exit happens).
The tracee is still alive, it needs be PTRACE_CONTed to finish exit.

PTRACE_GETSIGINFO on PTRACE_EVENT-stops returns si_signo = SIGTRAP,
si_code = (event << 8) | SIGTRAP.


	1.x.x Syscall-stops

If tracee was restarted by PTRACE_SYSCALL, tracee enters
syscall-enter-stop just prior to entering any syscall. If tracer
restarts it with PTRACE_SYSCALL, tracee enters syscall-exit-stop when
syscall is finished, or if it is interrupted by a signal. (That is,
signal-delivery-stop never happens between syscall-enter-stop and
syscall-exit-stop, it happens *after* syscall-exit-stop).

Other possibilities are that tracee may stop in a PTRACE_EVENT-stop,
exit (if it entered exit or exit_group syscall), be killed by SIGKILL,
or die silently (if execve syscall happened in another thread).

Syscall-enter-stop and syscall-exit-stop are observed by tracer as
waitpid returning with WIFSTOPPED(status) == true, WSTOPSIG(status) ==
SIGTRAP. If PTRACE_O_TRACESYSGOOD option was set by tracer, then
WSTOPSIG(status) == (SIGTRAP | 0x80).

There is no portable way to distinguish them from signal-delivery-stop
with SIGTRAP. Some architectures allow to distinguish them by examining
registers. For example, on x86 rax = -ENOSYS in syscall-enter-stop.
Since SIGTRAP (like any other signal) always happens *after*
syscall-exit-stop, and at this point rax almost never contains -ENOSYS,
SIGTRAP looks like "syscall-stop which is not syscall-enter-stop", IOW:
it looks like a "stray syscall-exit-stop" and can be detected this way.
But such detection is fragile and is best avoided. Using
PTRACE_O_TRACESYSGOOD option is a recommended method.

??? can be distinguished by PTRACE_GETSIGINFO, si_code <= 0 if sent by
usual suspects like [t]kill, sigqueue, SIGIO; SI_KERNEL if by kernel,
whereas syscall-stops have si_code = SIGTRAP or (SIGTRAP | 0x80). Right?

Syscall-enter-stop and syscall-exit-stop are indistinguishable from
each other by tracer. Tracer needs to keep track of the sequence of
ptrace-stops in order to not misinterpret syscall-enter-stop as
syscall-exit-stop or vice versa. The rule is that syscall-enter-stop is
always followed by syscall-exit-stop, PTRACE_EVENT-stop or tracee's
death - no other kinds of ptrace-stop can occur in between.

If after syscall-enter-stop tracer uses restarting command other than
PTRACE_SYSCALL, syscall-exit-stop is not generated.

PTRACE_GETSIGINFO on syscall-stops returns si_signo = SIGTRAP, si_code
= SIGTRAP or (SIGTRAP | 0x80).


	1.x.x SINGLESTEP, SYSEMU, SYSEMU_SINGLESTEP

??? document PTRACE_SINGLESTEP, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP


	1.x Informational and restarting ptrace commands.

Most ptrace commands (all except ATTACH, TRACEME, KILL, SETOPTIONS)
require tracee to be in ptrace-stop, otherwise they fail with ESRCH.

When tracee is in ptrace-stop, tracer can read and write data to tracee
using informational commands. They leave tracee in ptrace-stopped state.

longv = ptrace(PTRACE_PEEKTEXT/PEEKDATA/PEEKUSER, pid, addr, 0);
	ptrace(PTRACE_POKETEXT/POKEDATA/POKEUSER, pid, addr, long_val);
	ptrace(PTRACE_GETREGS/GETFPREGS, pid, 0, &struct);
	ptrace(PTRACE_SETREGS/SETFPREGS, pid, 0, &struct);
	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo);
	ptrace(PTRACE_SETSIGINFO, pid, 0, &siginfo);
	ptrace(PTRACE_GETEVENTMSG, pid, 0, &long_var);
	ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_flags);

Note that some errors are not reported. For example, setting siginfo
may have no effect in some ptrace-stops, yet the call may succeed
(return 0 and don't set errno).

Another group of commands makes ptrace-stopped tracee run. They have
the form:
	ptrace(PTRACE_cmd, pid, 0, sig);
where cmd is CONT, DETACH, SYSCALL, SINGLESTEP, SYSEMU,
SYSEMU_SINGLESTEP. If tracee is in signal-delivery-stop, sig is the
signal to be injected. Otherwise, sig may be ignored.


	1.x PTRACE_SETOPTIONS

ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_flags) affects one tracee.
It requires tracee to be ptrace-stopped. Current flags are replaced.
There is no mechanism to retrieve current flags. Flags are inherited by
new tracees "auto-attached" via active PTRACE_O_TRACE[V]FORK or
PTRACE_O_TRACECLONE options.


	1.x Attaching and detaching

A thread can be attached to using ptrace(PTRACE_ATTACH, pid, 0, 0)
call. This also sends SIGSTOP to this thread. If tracer wants this
SIGSTOP to have no effect, it needs to suppress it. Note that if other
signals are concurrently sent to this thread during attach, tracer may
see tracee enter signal-delivery-stop with other signal(s) first! The
usual practice is to reinject these signals until SIGSTOP is seen, then
suppress SIGSTOP injection. The design bug here is that attach and
concurrent SIGSTOP race and SIGSTOP may be lost.

??? Describe how to attach to a thread which is already group-stopped.

Since attaching sends SIGSTOP and tracer usually suppresses it, this
may cause stray EINTR return from the currently executing syscall in
the tracee, as described in "signal injection and suppression" section.

ptrace(PTRACE_TRACEME, 0, 0, 0) request turns current thread into a
tracee. It continues to run (doesn't enter ptrace-stop). A common
practice is follow ptrace(PTRACE_TRACEME) with raise(SIGSTOP) and allow
parent (which is our tracer now) to observe our signal-delivery-stop.

If PTRACE_O_TRACE[V]FORK or PTRACE_O_TRACECLONE options are in effect,
then children created by (vfork or clone(CLONE_VFORK)), (fork or
clone(SIGCHLD)) and (other kinds of clone) respectively are
automatically attached to the same tracer which traced their parent.
SIGSTOP is delivered to them, causing them to enter
signal-delivery-stop after they exit syscall which created them.

Detaching of tracee is performed by ptrace(PTRACE_DETACH, pid, 0, sig).
PTRACE_DETACH is a restarting operation, therefore it requires tracee
to be in ptrace-stop. If tracee is in signal-delivery-stop, signal can
be injected. Othervice, sig parameter may be silently ignored.

If tracee is running when tracer wants to detach it, the usual solution
is to send SIGSTOP (using tgkill, to make sure it goes to the correct
thread), wait for tracee to stop in signal-delivery-stop for SIGSTOP
and then detach it (suppressing SIGSTOP injection). Design bug is that
this can race with concurrent SIGSTOPs. Another complication is that
tracee may enter other ptrace-stops and needs to be restarted and
waited for again, until SIGSTOP is seen. Yet another complication is to
be sure that tracee is not already group-stopped, because no signal
delivery happens while it is - not even SIGSTOP.

??? is above accurate?

??? Describe how to detach from a group-stopped tracee so that it
    doesn't run, but continues to wait for SIGCONT.

If tracer dies, all tracees are automatically detached and restarted,
unless they were in group-stop. Handling of restart from group-stop is
currently buggy, but "as planned" behavior is to leave tracee stopped
and waiting for SIGCONT. If tracee is restarted from
signal-delivery-stop, pending signal is injected.


	1.x execve under ptrace.

During execve, kernel destroys all other threads in the process, and
resets current thread's tid to pid. This looks very confusing to
tracers of the threads of execve'ing process:

All other threads "disappear" - that is, they terminate their execution
without returning any waitpid notifications even if they are currently
traced.

The execve-ing tracee returns from syscall with the different pid.
(Remember, under ptrace pid is tid). That is, pid is reset to process
id, which coincides with thread leader tid. If thread leader has
reported its death by this time, for tracer this looks like dead thread
leader "reappeared from nowhere". If thread leader was still alive, for
tracer this may look like thread leader returned from a different
syscall than it entered, or even "returned from syscall even though it
was not in any syscall".

PTRACE_O_TRACEEXEC option is the recommended tool for dedling with this
case. It enables PTRACE_EVENT_EXEC-stop which occurs before execve
returns. On receiving this notification, tracer should ...

??? ...what exactly tracer should do? Forget about all other threads?
How it knows which tracees _are_ threads of that particular process?
(It may trace more than one; It may even don't keep track of its
tracees' pids at all...) Is there a guarantee that at this point, they
will never return waitpid status (there are no buffered waitpid data)?
Does PTRACE_EVENT_EXEC-stop return old pid or "already resetted" pid?


	1.x Real parent

Ptrace API (ab)uses standard Unix parent/child signaling over waitpid.
This used to cause real parent of the process to stop receiving several
kinds of waitpid notifications when child process is traced by some
other process.

Many of these bugs have been fixed, but as of 2.6.38 several still
exist.

As of 2.6.38, the following is believed to work correctly:

- exit/death by signal is reported first to tracer, then, when tracer
consumes waitpid result, to real parent (to real parent only when the
whole multi-threaded process exits). If they are the same process, the
report is sent only once.

- ??? add more docs

Following bugs still exist:

- group-stop notifications are sent to tracer, but not to real parent.

- If thread group leader it is traced and exits, do_wait(WEXITED)
doesn't work (until all threads exit) for its the tracer.

??? add more known bugs here



	2. Linux kernel implementation

TODO
