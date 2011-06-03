Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1FCPFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:05:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1FCPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=Tt3JJHUCpEvgqXGsHtO0vmlsQORbggPA6vP4i6KQ1inzz9f6QVT7PjeWt5cYjE3Q0r
         sUQP4Xbb9ZwT8eHgR9Z9as8l9Nbks5Rcspk1xhWXrp1F1YBtpIp50z/Au1qZWbrEoLie
         vT0cQs90mJshZh9lXfMGQ523SwHostMW+2PzQ=
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 3 Jun 2011 17:05:25 +0200
Message-ID: <BANLkTim8JC=+dR8rrny77yKnzXjEh2u20Q@mail.gmail.com>
Subject: Ptrace documentation, draft #5
To: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: multipart/mixed; boundary=0016e6d96c368c1e2004a4d01623
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d96c368c1e2004a4d01623
Content-Type: text/plain; charset=ISO-8859-1

Ptrace discussions repeatedly display a higher than average amount
of misunderstanding and confusion. New ptrace users and even people
who already worked with it are repeatedly confused by details
which are not documented anywhere and knowledge about which exists
mostly in the brains of strace/gdb/other_such_tools developers.

This document is meant as a brain dump of this knowledge.
It assumes that the reader has basic understanding what ptrace is.

The biggest changes are "execve under ptrace" section and in "Konwn bugs".

The diff from version 4 is attached too.

I think it's ready to go into Documentation/trace/ptrace.txt

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

Tracer can kill a tracee with ptrace(PTRACE_KILL, pid, 0, 0). This
opeartion is deprecated, use kill/tgkill(SIGKILL) instead.

^^^ Oleg prefers to deprecate it instead of describing (and needing to
support) PTRACE_KILL's quirks.

When tracee executes exit syscall, it reports its death to its tracer.
Other threads are not affected.

When any thread executes exit_group syscall, every tracee in its thread
group reports its death to its tracer.

If PTRACE_O_TRACEEXIT option is on, PTRACE_EVENT_EXIT will happen
before actual death. This applies to exits on exit syscall, group_exit
syscall, signal deaths (except SIGKILL), and when threads are torn down
on execve in multi-threaded process.

Tracer cannot assume that ptrace-stopped tracee exists. There are many
scenarios when tracee may die while stopped (such as SIGKILL).
Therefore, tracer must always be prepared to handle ESRCH error on any
ptrace operation. Unfortunately, the same error is returned if tracee
exists but is not ptrace-stopped (for commands which require stopped
tracee), or if it is not traced by process which issued ptrace call.
Tracer needs to keep track of stopped/running state, and interpret
ESRCH as "tracee died unexpectedly" only if it knows that tracee has
been observed to enter ptrace-stop. Note that there is no guarantee
that waitpid(WNOHANG) will reliably report tracee's death status if
ptrace operation returned ESRCH. waitpid(WNOHANG) may return 0 instead.
IOW: tracee may be "not yet fully dead" but already refusing ptrace ops.

Tracer can not assume that tracee ALWAYS ends its life by reporting
WIFEXITED(status) or WIFSIGNALED(status).

??? or can it? Do we include such a promise into ptrace API?


	1.x Stopped states.

When running tracee enters ptrace-stop, it notifies its tracer using
waitpid API. Tracer should use waitpid family of syscalls to wait for
tracee to stop. Most of this document assumes that tracer waits with:

	pid = waitpid(pid_or_minus_1, &status, __WALL);

Ptrace-stopped tracees are reported as returns with pid > 0 and
WIFSTOPPED(status) == true.

??? Do we require __WALL usage, or will just using 0 be ok? Are the
rules different if user wants to use waitid? Will waitid require
WEXITED?

__WALL value does not include WSTOPPED and WEXITED bits, but implies
their functionality.

Setting of WCONTINUED bit in waitpid flags is not recommended: the
continued state is per-process and consuming it can confuse real parent
of the tracee.

Use of WNOHANG bit in waitpid flags may cause waitpid return 0 ("no
wait results available yet") even if tracer knows there should be a
notification. Example: kill(tracee, SIGKILL); waitpid(tracee, &status,
__WALL | WNOHANG);

??? waitid usage? WNOWAIT?

??? describe how wait notifications queue (or not queue)

The following kinds of ptrace-stops exist: signal-delivery-stops,
group-stop, PTRACE_EVENT stops, syscall-stops [, SINGLESTEP, SYSEMU,
SYSEMU_SINGLESTEP]. They all are reported as waitpid result with
WIFSTOPPED(status) == true. They may be differentiated by checking
(status >> 8) value, and if looking at (status >> 8) value doesn't
resolve ambiguity, by querying PTRACE_GETSIGINFO. (Note:
WSTOPSIG(status) macro returns ((status >> 8) & 0xff) value).


	1.x.x Signal-delivery-stop

When (possibly multi-threaded) process receives any signal except
SIGKILL, kernel selects a thread which handles the signal (if signal is
generated with t[g]kill, thread selection is done by user). If selected
thread is traced, it enters signal-delivery-stop. By this point, signal
is not yet delivered to the process, and can be suppressed by tracer.
If tracer doesn't suppress the signal, it passes signal to tracee in
the next ptrace request. This second step of signal delivery is called
"signal injection" in this document. Note that if signal is blocked,
signal-delivery-stop doesn't happen until signal is unblocked, with the
usual exception that SIGSTOP can't be blocked.

Signal-delivery-stop is observed by tracer as waitpid returning with
WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. If
WSTOPSIG(status) == SIGTRAP, this may be a different kind of
ptrace-stop - see "Syscall-stops" and "execve" sections below for
details. If WSTOPSIG(status) == stopping signal, this may be a
group-stop - see below.


	1.x.x Signal injection and suppression.

After signal-delivery-stop is observed by tracer, tracer should restart
tracee with

	ptrace(PTRACE_rest, pid, 0, sig)

call, where PTRACE_rest is one of the restarting ptrace ops. If sig is
0, then signal is not delivered. Otherwise, signal sig is delivered.
This operation is called "signal injection" in this document, to
distinguish it from signal-delivery-stop.

Note that sig value may be different from WSTOPSIG(status) value -
tracer can cause a different signal to be injected.

Note that suppressed signal still causes syscalls to return
prematurely. Restartable syscalls will be restarted (tracer will
observe tracee to execute restart_syscall(2) syscall if tracer uses
PTRACE_SYSCALL), non-restartable syscalls (for example, nanosleep) may
return with -EINTR even though no observable signal is injected to the
tracee.

Note that restarting ptrace commands issued in ptrace-stops other than
signal-delivery-stop are not guaranteed to inject a signal, even if sig
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

PTRACE_GETSIGINFO can be used to retrieve siginfo_t structure which
corresponds to delivered signal. PTRACE_SETSIGINFO may be used to
modify it. If PTRACE_SETSIGINFO has been used to alter siginfo_t,
si_signo field and sig parameter in restarting command must match,
otherwise the result is undefined.


	1.x.x Group-stop

When a (possibly multi-threaded) process receives a stopping signal,
all threads stop. If some threads are traced, they enter a group-stop.
Note that stopping signal will first cause signal-delivery-stop (on one
tracee only), and only after it is injected by tracer (or after it was
dispatched to a thread which isn't traced), group-stop will be
initiated on ALL tracees within multi-threaded process. As usual, every
tracee reports its group-stop separately to corresponding tracer.

Group-stop is observed by tracer as waitpid returning with
WIFSTOPPED(status) == true, WSTOPSIG(status) == signal. The same result
is returned by some other classes of ptrace-stops, therefore the
recommended practice is to perform

	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo)

call. The call can be avoided if signal number is not SIGSTOP, SIGTSTP,
SIGTTIN or SIGTTOU - only these four signals are stopping signals. If
tracer sees something else, it can't be group-stop. Otherwise, tracer
needs to call PTRACE_GETSIGINFO. If PTRACE_GETSIGINFO fails with
EINVAL, then it is definitely a group-stop. (Other failure codes are
possible, such as ESRCH "no such process" if SIGKILL killed the tracee).

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


	1.x.x PTRACE_EVENT stops

If tracer sets TRACE_O_TRACEfoo options, tracee will enter ptrace-stops
called PTRACE_EVENT stops.

PTRACE_EVENT stops are observed by tracer as waitpid returning with
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

PTRACE_EVENT_EXIT - stop before exit (including death from exit_group),
signal death, or exit caused by execve in multi-threaded process.
PTRACE_GETEVENTMSG returns exit status. Registers can be examined
(unlike when "real" exit happens). The tracee is still alive, it needs
to be PTRACE_CONTed or PTRACE_DETACHed to finish exit.

PTRACE_GETSIGINFO on PTRACE_EVENT stops returns si_signo = SIGTRAP,
si_code = (event << 8) | SIGTRAP.


	1.x.x Syscall-stops

If tracee was restarted by PTRACE_SYSCALL, tracee enters
syscall-enter-stop just prior to entering any syscall. If tracer
restarts it with PTRACE_SYSCALL, tracee enters syscall-exit-stop when
syscall is finished, or if it is interrupted by a signal. (That is,
signal-delivery-stop never happens between syscall-enter-stop and
syscall-exit-stop, it happens *after* syscall-exit-stop).

Other possibilities are that tracee may stop in a PTRACE_EVENT stop,
exit (if it entered exit or exit_group syscall), be killed by SIGKILL,
or die silently (if execve syscall happened in another thread).

Syscall-enter-stop and syscall-exit-stop are observed by tracer as
waitpid returning with WIFSTOPPED(status) == true, WSTOPSIG(status) ==
SIGTRAP. If PTRACE_O_TRACESYSGOOD option was set by tracer, then
WSTOPSIG(status) == (SIGTRAP | 0x80).

Syscall-stops can be distinguished from signal-delivery-stop with
SIGTRAP by querying PTRACE_GETSIGINFO: si_code <= 0 if sent by usual
suspects like [tg]kill/sigqueue/etc; or = SI_KERNEL (0x80) if sent by
kernel, whereas syscall-stops have si_code = SIGTRAP or (SIGTRAP |
0x80). However, syscall-stops happen very often (twice per syscall),
and performing PTRACE_GETSIGINFO for every syscall-stop may be somewhat
expensive.

Some architectures allow to distinguish them by examining registers.
For example, on x86 rax = -ENOSYS in syscall-enter-stop. Since SIGTRAP
(like any other signal) always happens *after* syscall-exit-stop, and
at this point rax almost never contains -ENOSYS, SIGTRAP looks like
"syscall-stop which is not syscall-enter-stop", IOW: it looks like a
"stray syscall-exit-stop" and can be detected this way. But such
detection is fragile and is best avoided.

Using PTRACE_O_TRACESYSGOOD option is a recommended method, since it is
reliable and does not incur performance penalty.

Syscall-enter-stop and syscall-exit-stop are indistinguishable from
each other by tracer. Tracer needs to keep track of the sequence of
ptrace-stops in order to not misinterpret syscall-enter-stop as
syscall-exit-stop or vice versa. The rule is that syscall-enter-stop is
always followed by syscall-exit-stop, PTRACE_EVENT stop or tracee's
death - no other kinds of ptrace-stop can occur in between.

If after syscall-enter-stop tracer uses restarting command other than
PTRACE_SYSCALL, syscall-exit-stop is not generated.

PTRACE_GETSIGINFO on syscall-stops returns si_signo = SIGTRAP, si_code
= SIGTRAP or (SIGTRAP | 0x80).


	1.x.x SINGLESTEP, SYSEMU, SYSEMU_SINGLESTEP

??? document PTRACE_SINGLESTEP, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP


	1.x Informational and restarting ptrace commands.

Most ptrace commands (all except ATTACH, TRACEME, KILL) require tracee
to be in ptrace-stop, otherwise they fail with ESRCH.

When tracee is in ptrace-stop, tracer can read and write data to tracee
using informational commands. They leave tracee in ptrace-stopped state:

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

ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_flags) affects one tracee.
Current flags are replaced. Flags are inherited by new tracees created
and "auto-attached" via active PTRACE_O_TRACE[V]FORK or
PTRACE_O_TRACECLONE options.

Another group of commands makes ptrace-stopped tracee run. They have
the form:

	ptrace(PTRACE_cmd, pid, 0, sig);

where cmd is CONT, DETACH, SYSCALL, SINGLESTEP, SYSEMU, or
SYSEMU_SINGLESTEP. If tracee is in signal-delivery-stop, sig is the
signal to be injected. Otherwise, sig may be ignored.


	1.x Attaching and detaching

A thread can be attached to tracer using ptrace(PTRACE_ATTACH, pid, 0,
0) call. This also sends SIGSTOP to this thread. If tracer wants this
SIGSTOP to have no effect, it needs to suppress it. Note that if other
signals are concurrently sent to this thread during attach, tracer may
see tracee enter signal-delivery-stop with other signal(s) first! The
usual practice is to reinject these signals until SIGSTOP is seen, then
suppress SIGSTOP injection. The design bug here is that attach and
concurrent SIGSTOP are racing and SIGSTOP may be lost.

??? Describe how to attach to a thread which is already group-stopped.

Since attaching sends SIGSTOP and tracer usually suppresses it, this
may cause stray EINTR return from the currently executing syscall in
the tracee, as described in "signal injection and suppression" section.

ptrace(PTRACE_TRACEME, 0, 0, 0) request turns current thread into a
tracee. It continues to run (doesn't enter ptrace-stop). A common
practice is to follow ptrace(PTRACE_TRACEME) with raise(SIGSTOP) and
allow parent (which is our tracer now) to observe our
signal-delivery-stop.

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
be sure that tracee is not already ptrace-stopped, because no signal
delivery happens while it is - not even SIGSTOP.

??? Describe how to detach from a group-stopped tracee so that it
    doesn't run, but continues to wait for SIGCONT.

If tracer dies, all tracees are automatically detached and restarted,
unless they were in group-stop. Handling of restart from group-stop is
currently buggy, but "as planned" behavior is to leave tracee stopped
and waiting for SIGCONT. If tracee is restarted from
signal-delivery-stop, pending signal is injected.


	1.x execve under ptrace.

During execve, kernel destroys all other threads in the process, and
resets execve'ing thread tid to tgid (process id). This looks very
confusing to tracers:

All other threads stop in PTRACE_EXIT stop, if requested by active
ptrace option. Then all other threads except thread group leader report
death as if they exited via exit syscall with exit code 0. Then
PTRACE_EVENT_EXEC stop happens, if requested by active ptrace option
(on which tracee - leader? execve-ing one?).

The execve-ing tracee changes its pid while it is in execve syscall.
(Remember, under ptrace 'pid' returned from waitpid, or fed into ptrace
calls, is tracee's tid). That is, pid is reset to process id, which
coincides with thread group leader tid.

If thread group leader has reported its death by this time, for tracer
this looks like dead thread leader "reappears from nowhere". If thread
group leader was still alive, for tracer this may look as if thread
group leader returns from a different syscall than it entered, or even
"returned from syscall even though it was not in any syscall". If
thread group leader was not traced (or was traced by a different
tracer), during execve it will appear as if it has become a tracee of
the tracer of execve'ing tracee. All these effects are the artifacts of
pid change.

PTRACE_O_TRACEEXEC option is the recommended tool for dealing with this
case. It enables PTRACE_EVENT_EXEC stop which occurs before execve
syscall return.

Pid change happens before PTRACE_EVENT_EXEC stop, not after.

When tracer receives PTRACE_EVENT_EXEC stop notification, it is
guaranteed that except this tracee and thread group leader, no other
threads from the process are alive.

On receiving this notification, tracer should clean up all its internal
data structures about all threads of this process, and retain only one
data structure, one which describes single still running tracee, with
pid = tgid = process id.

Currently, there is no way to retrieve former pid of execve-ing tracee.
If tracer doesn't keep track of its tracees' thread group relations, it
may be unable to know which tracee execve-ed and therefore no longer
exists under old pid due to pid change.

Example: two threads execve at the same time:

  ** we get syscall-entry-stop in thread 1: **
 PID1 execve("/bin/foo", "foo" <unfinished ...>
  ** we issue PTRACE_SYSCALL for thread 1 **
  ** we get syscall-entry-stop in thread 2: **
 PID2 execve("/bin/bar", "bar" <unfinished ...>
  ** we issue PTRACE_SYSCALL for thread 2 **
  ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
  ** we get syscall-exit-stop for PID0: **
 PID0 <... execve resumed> )             = 0

In this situation there is no way to know which execve succeeded.

If PTRACE_O_TRACEEXEC option is NOT in effect for the execve'ing
tracee, kernel delivers an extra SIGTRAP to tracee after execve syscall
returns. This is an ordinary signal (similar to one which can be
generated by "kill -TRAP"), not a special kind of ptrace-stop.
GETSIGINFO on it has si_code = 0 (SI_USER). It can be blocked by signal
mask, and thus can happen (much) later.

Usually, tracer (for example, strace) would not want to show this extra
post-execve SIGTRAP signal to the user, and would suppress its delivery
to the tracee (if SIGTRAP is set to SIG_DFL, it is a killing signal).
However, determining *which* SIGTRAP to suppress is not easy. Setting
PTRACE_O_TRACEEXEC option and thus suppressing this extra SIGTRAP is
the recommended approach.


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


	1.x Known bugs

Following bugs still exist:

Group-stop notifications are sent to tracer, but not to real parent.
Last confirmed on 2.6.38.6.

If thread group leader is traced and exits by calling exit syscall,
PTRACE_EVENT_EXIT stop will happen for it (if requested), but
subsequent WIFEXITED notification will not be delivered until all other
threads exit. As explained above, if one of other threads execve's,
thread group leader death will *never* be reported. If execve-ed thread
is not traced by this tracer, tracer will never know that execve
happened.

??? need to test this scenario

One possible workaround is to detach thread group leader instead of
restarting it in this case. Last confirmed on 2.6.38.6.

SIGKILL signal may still cause PTRACE_EVENT_EXIT stop before actual
signal death. This may be changed in the future - SIGKILL is meant to
always immediately kill tasks even under ptrace. Last confirmed on
2.6.38.6.



	2. Linux kernel implementation

TODO

--0016e6d96c368c1e2004a4d01623
Content-Type: text/x-patch; charset=US-ASCII; name="DOC45.diff"
Content-Disposition: attachment; filename="DOC45.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_goh9fa1l0

LS0tIERPQ2IJMjAxMS0wNS0zMCAxNzoxMTo0OC4wMDA2MTkyMTEgKzAyMDAKKysrIERPQ2MJMjAx
MS0wNi0wMyAxNjo1NDoyMS42Mjc2MzMzNzMgKzAyMDAKQEAgLTcyLDMyICs3MiwyNyBAQAogZ3Jv
dXAgcmVwb3J0cyBpdHMgZGVhdGggdG8gaXRzIHRyYWNlci4KIAogSWYgUFRSQUNFX09fVFJBQ0VF
WElUIG9wdGlvbiBpcyBvbiwgUFRSQUNFX0VWRU5UX0VYSVQgd2lsbCBoYXBwZW4KLWJlZm9yZSBh
Y3R1YWwgZGVhdGguIFRoaXMgYXBwbGllcyB0byBib3RoIG5vcm1hbCBleGl0cyBhbmQgc2lnbmFs
Ci1kZWF0aHMgKGV4Y2VwdCBTSUdLSUxMKS4KLQotS05PV04gQlVHOiBQVFJBQ0VfRVZFTlRfRVhJ
VCBzaG91bGQgaGFwcGVuIGZvciBldmVyeSB0cmFjZWUgaW4gdGhyZWFkCi1ncm91cCBvbiBleGl0
X2dyb3VwIG9yIHNpZ25hbCBkZWF0aCwgYnV0IGN1cnJlbnRseSAofjIuNi4zOCkgdGhpcyBpcwot
YnVnZ3k6IHNvbWUgb2YgdGhlc2Ugc3RvcHMgbWF5IGJlIG1pc3NlZC4KK2JlZm9yZSBhY3R1YWwg
ZGVhdGguIFRoaXMgYXBwbGllcyB0byBleGl0cyBvbiBleGl0IHN5c2NhbGwsIGdyb3VwX2V4aXQK
K3N5c2NhbGwsIHNpZ25hbCBkZWF0aHMgKGV4Y2VwdCBTSUdLSUxMKSwgYW5kIHdoZW4gdGhyZWFk
cyBhcmUgdG9ybiBkb3duCitvbiBleGVjdmUgaW4gbXVsdGktdGhyZWFkZWQgcHJvY2Vzcy4KIAog
VHJhY2VyIGNhbm5vdCBhc3N1bWUgdGhhdCBwdHJhY2Utc3RvcHBlZCB0cmFjZWUgZXhpc3RzLiBU
aGVyZSBhcmUgbWFueQotc2NlbmFyaW9zIHdoZW4gdHJhY2VlIG1heSBkaWUgd2hpbGUgc3RvcHBl
ZCAoc3VjaCBhcyBTSUdLSUxMKS4gVGhlcmUKLWFyZSBjYXNlcyB3aGVyZSB0cmFjZWUgZGlzYXBw
ZWFycyB3aXRob3V0IHJlcG9ydGluZyBkZWF0aCAoc3VjaCBhcwotZXhlY3ZlIGluIG11bHRpLXRo
cmVhZGVkIHByb2Nlc3MpLiBUaGVyZWZvcmUsIHRyYWNlciBtdXN0IGFsd2F5cyBiZQotcHJlcGFy
ZWQgdG8gaGFuZGxlIEVTUkNIIGVycm9yIG9uIGFueSBwdHJhY2Ugb3BlcmF0aW9uLiBVbmZvcnR1
bmF0ZWx5LAotdGhlIHNhbWUgZXJyb3IgaXMgcmV0dXJuZWQgaWYgdHJhY2VlIGV4aXN0cyBidXQg
aXMgbm90IHB0cmFjZS1zdG9wcGVkCi0oZm9yIGNvbW1hbmRzIHdoaWNoIHJlcXVpcmUgc3RvcHBl
ZCB0cmFjZWUpLiBUcmFjZXIgbmVlZHMgdG8ga2VlcCB0cmFjawotb2Ygc3RvcHBlZC9ydW5uaW5n
IHN0YXRlLCBhbmQgaW50ZXJwcmV0IEVTUkNIIGFzICJ0cmFjZWUgZGllZAotdW5leHBlY3RlZGx5
IiBvbmx5IGlmIGl0IGtub3dzIHRoYXQgdHJhY2VlIGhhcyBiZWVuIG9ic2VydmVkIHRvIGVudGVy
Ci1wdHJhY2Utc3RvcC4KLQotVGhlcmUgaXMgbm8gZ3VhcmFudGVlIHRoYXQgd2FpdHBpZChXTk9I
QU5HKSB3aWxsIHJlbGlhYmx5IHJlcG9ydAotdHJhY2VlJ3MgZGVhdGggc3RhdHVzIGlmIHB0cmFj
ZSBvcGVyYXRpb24gcmV0dXJuZWQgRVNSQ0guCi13YWl0cGlkKFdOT0hBTkcpIG1heSByZXR1cm4g
MCBpbnN0ZWFkLiBJT1c6IHRyYWNlZSBtYXkgYmUgIm5vdCB5ZXQKLWZ1bGx5IGRlYWQiIGJ1dCBh
bHJlYWR5IHJlZnVzaW5nIHB0cmFjZSBvcHMuCitzY2VuYXJpb3Mgd2hlbiB0cmFjZWUgbWF5IGRp
ZSB3aGlsZSBzdG9wcGVkIChzdWNoIGFzIFNJR0tJTEwpLgorVGhlcmVmb3JlLCB0cmFjZXIgbXVz
dCBhbHdheXMgYmUgcHJlcGFyZWQgdG8gaGFuZGxlIEVTUkNIIGVycm9yIG9uIGFueQorcHRyYWNl
IG9wZXJhdGlvbi4gVW5mb3J0dW5hdGVseSwgdGhlIHNhbWUgZXJyb3IgaXMgcmV0dXJuZWQgaWYg
dHJhY2VlCitleGlzdHMgYnV0IGlzIG5vdCBwdHJhY2Utc3RvcHBlZCAoZm9yIGNvbW1hbmRzIHdo
aWNoIHJlcXVpcmUgc3RvcHBlZAordHJhY2VlKSwgb3IgaWYgaXQgaXMgbm90IHRyYWNlZCBieSBw
cm9jZXNzIHdoaWNoIGlzc3VlZCBwdHJhY2UgY2FsbC4KK1RyYWNlciBuZWVkcyB0byBrZWVwIHRy
YWNrIG9mIHN0b3BwZWQvcnVubmluZyBzdGF0ZSwgYW5kIGludGVycHJldAorRVNSQ0ggYXMgInRy
YWNlZSBkaWVkIHVuZXhwZWN0ZWRseSIgb25seSBpZiBpdCBrbm93cyB0aGF0IHRyYWNlZSBoYXMK
K2JlZW4gb2JzZXJ2ZWQgdG8gZW50ZXIgcHRyYWNlLXN0b3AuIE5vdGUgdGhhdCB0aGVyZSBpcyBu
byBndWFyYW50ZWUKK3RoYXQgd2FpdHBpZChXTk9IQU5HKSB3aWxsIHJlbGlhYmx5IHJlcG9ydCB0
cmFjZWUncyBkZWF0aCBzdGF0dXMgaWYKK3B0cmFjZSBvcGVyYXRpb24gcmV0dXJuZWQgRVNSQ0gu
IHdhaXRwaWQoV05PSEFORykgbWF5IHJldHVybiAwIGluc3RlYWQuCitJT1c6IHRyYWNlZSBtYXkg
YmUgIm5vdCB5ZXQgZnVsbHkgZGVhZCIgYnV0IGFscmVhZHkgcmVmdXNpbmcgcHRyYWNlIG9wcy4K
IAogVHJhY2VyIGNhbiBub3QgYXNzdW1lIHRoYXQgdHJhY2VlIEFMV0FZUyBlbmRzIGl0cyBsaWZl
IGJ5IHJlcG9ydGluZwotV0lGRVhJVEVEKHN0YXR1cykgb3IgV0lGU0lHTkFMRUQoc3RhdHVzKS4g
T25lIG5vdGFibGUgY2FzZSBpcyBleGVjdmUgaW4KLW11bHRpLXRocmVhZGVkIHByb2Nlc3MsIHdo
aWNoIGlzIGRlc2NyaWJlZCBsYXRlci4KK1dJRkVYSVRFRChzdGF0dXMpIG9yIFdJRlNJR05BTEVE
KHN0YXR1cykuCisKKz8/PyBvciBjYW4gaXQ/IERvIHdlIGluY2x1ZGUgc3VjaCBhIHByb21pc2Ug
aW50byBwdHJhY2UgQVBJPwogCiAKIAkxLnggU3RvcHBlZCBzdGF0ZXMuCkBAIC0xMTIsMTQgKzEw
NywxNSBAQAogV0lGU1RPUFBFRChzdGF0dXMpID09IHRydWUuCiAKID8/PyBEbyB3ZSByZXF1aXJl
IF9fV0FMTCB1c2FnZSwgb3Igd2lsbCBqdXN0IHVzaW5nIDAgYmUgb2s/IEFyZSB0aGUKLXJ1bGVz
IGRpZmZlcmVudCBpZiB1c2VyIHdhbnRzIHRvIHVzZSB3YWl0aWQ/IFdpbGwgd2FpdGlkIHJlcXVp
cmUgV0VYSVRFRD8KK3J1bGVzIGRpZmZlcmVudCBpZiB1c2VyIHdhbnRzIHRvIHVzZSB3YWl0aWQ/
IFdpbGwgd2FpdGlkIHJlcXVpcmUKK1dFWElURUQ/CiAKIF9fV0FMTCB2YWx1ZSBkb2VzIG5vdCBp
bmNsdWRlIFdTVE9QUEVEIGFuZCBXRVhJVEVEIGJpdHMsIGJ1dCBpbXBsaWVzCiB0aGVpciBmdW5j
dGlvbmFsaXR5LgogCiBTZXR0aW5nIG9mIFdDT05USU5VRUQgYml0IGluIHdhaXRwaWQgZmxhZ3Mg
aXMgbm90IHJlY29tbWVuZGVkOiB0aGUKLWNvbnRpbnVlZCBzdGF0ZSBpcyBwZXItcHJvY2VzcyBh
bmQgY29uc3VtaW5nIGl0IHdvdWxkIGNvbmZ1c2UgcmVhbAotcGFyZW50IG9mIHRoZSB0cmFjZWUu
Citjb250aW51ZWQgc3RhdGUgaXMgcGVyLXByb2Nlc3MgYW5kIGNvbnN1bWluZyBpdCBjYW4gY29u
ZnVzZSByZWFsIHBhcmVudAorb2YgdGhlIHRyYWNlZS4KIAogVXNlIG9mIFdOT0hBTkcgYml0IGlu
IHdhaXRwaWQgZmxhZ3MgbWF5IGNhdXNlIHdhaXRwaWQgcmV0dXJuIDAgKCJubwogd2FpdCByZXN1
bHRzIGF2YWlsYWJsZSB5ZXQiKSBldmVuIGlmIHRyYWNlciBrbm93cyB0aGVyZSBzaG91bGQgYmUg
YQpAQCAtMTM0LDIzICsxMzAsMjMgQEAKIGdyb3VwLXN0b3AsIFBUUkFDRV9FVkVOVCBzdG9wcywg
c3lzY2FsbC1zdG9wcyBbLCBTSU5HTEVTVEVQLCBTWVNFTVUsCiBTWVNFTVVfU0lOR0xFU1RFUF0u
IFRoZXkgYWxsIGFyZSByZXBvcnRlZCBhcyB3YWl0cGlkIHJlc3VsdCB3aXRoCiBXSUZTVE9QUEVE
KHN0YXR1cykgPT0gdHJ1ZS4gVGhleSBtYXkgYmUgZGlmZmVyZW50aWF0ZWQgYnkgY2hlY2tpbmcK
LShzdGF0dXMgPj4gOCkgdmFsdWUgKG5vdGUgdGhhdCBXU1RPUFNJRyhzdGF0dXMpIGlzIChzdGF0
dXMgPj4gOCkgJgotMHhmZikgYW5kIGlmIGxvb2tpbmcgYXQgKHN0YXR1cyA+PiA4KSB2YWx1ZSBk
b2Vzbid0IHJlc29sdmUgYW1iaWd1aXR5LAotYnkgcXVlcnlpbmcgUFRSQUNFX0dFVFNJR0lORk8u
Cisoc3RhdHVzID4+IDgpIHZhbHVlLCBhbmQgaWYgbG9va2luZyBhdCAoc3RhdHVzID4+IDgpIHZh
bHVlIGRvZXNuJ3QKK3Jlc29sdmUgYW1iaWd1aXR5LCBieSBxdWVyeWluZyBQVFJBQ0VfR0VUU0lH
SU5GTy4gKE5vdGU6CitXU1RPUFNJRyhzdGF0dXMpIG1hY3JvIHJldHVybnMgKChzdGF0dXMgPj4g
OCkgJiAweGZmKSB2YWx1ZSkuCiAKIAogCTEueC54IFNpZ25hbC1kZWxpdmVyeS1zdG9wCiAKIFdo
ZW4gKHBvc3NpYmx5IG11bHRpLXRocmVhZGVkKSBwcm9jZXNzIHJlY2VpdmVzIGFueSBzaWduYWwg
ZXhjZXB0CiBTSUdLSUxMLCBrZXJuZWwgc2VsZWN0cyBhIHRocmVhZCB3aGljaCBoYW5kbGVzIHRo
ZSBzaWduYWwgKGlmIHNpZ25hbCBpcwotZ2VuZXJhdGVkIHdpdGggdGdraWxsLCB0aHJlYWQgc2Vs
ZWN0aW9uIGlzIGRvbmUgYnkgdXNlcikuIElmIHNlbGVjdGVkCitnZW5lcmF0ZWQgd2l0aCB0W2dd
a2lsbCwgdGhyZWFkIHNlbGVjdGlvbiBpcyBkb25lIGJ5IHVzZXIpLiBJZiBzZWxlY3RlZAogdGhy
ZWFkIGlzIHRyYWNlZCwgaXQgZW50ZXJzIHNpZ25hbC1kZWxpdmVyeS1zdG9wLiBCeSB0aGlzIHBv
aW50LCBzaWduYWwKIGlzIG5vdCB5ZXQgZGVsaXZlcmVkIHRvIHRoZSBwcm9jZXNzLCBhbmQgY2Fu
IGJlIHN1cHByZXNzZWQgYnkgdHJhY2VyLgogSWYgdHJhY2VyIGRvZXNuJ3Qgc3VwcHJlc3MgdGhl
IHNpZ25hbCwgaXQgcGFzc2VzIHNpZ25hbCB0byB0cmFjZWUgaW4KLXRoZSBuZXh0IHB0cmFjZSBy
ZXF1ZXN0LiBUaGlzIGlzIGNhbGxlZCAic2lnbmFsIGluamVjdGlvbiIgYW5kIHdpbGwgYmUKLWRl
c2NyaWJlZCBsYXRlci4gTm90ZSB0aGF0IGlmIHNpZ25hbCBpcyBibG9ja2VkLCBzaWduYWwtZGVs
aXZlcnktc3RvcAotZG9lc24ndCBoYXBwZW4gdW50aWwgc2lnbmFsIGlzIHVuYmxvY2tlZCwgd2l0
aCB0aGUgdXN1YWwgZXhjZXB0aW9uIHRoYXQKLVNJR1NUT1AgY2FuJ3QgYmUgYmxvY2tlZC4KK3Ro
ZSBuZXh0IHB0cmFjZSByZXF1ZXN0LiBUaGlzIHNlY29uZCBzdGVwIG9mIHNpZ25hbCBkZWxpdmVy
eSBpcyBjYWxsZWQKKyJzaWduYWwgaW5qZWN0aW9uIiBpbiB0aGlzIGRvY3VtZW50LiBOb3RlIHRo
YXQgaWYgc2lnbmFsIGlzIGJsb2NrZWQsCitzaWduYWwtZGVsaXZlcnktc3RvcCBkb2Vzbid0IGhh
cHBlbiB1bnRpbCBzaWduYWwgaXMgdW5ibG9ja2VkLCB3aXRoIHRoZQordXN1YWwgZXhjZXB0aW9u
IHRoYXQgU0lHU1RPUCBjYW4ndCBiZSBibG9ja2VkLgogCiBTaWduYWwtZGVsaXZlcnktc3RvcCBp
cyBvYnNlcnZlZCBieSB0cmFjZXIgYXMgd2FpdHBpZCByZXR1cm5pbmcgd2l0aAogV0lGU1RPUFBF
RChzdGF0dXMpID09IHRydWUsIFdTVE9QU0lHKHN0YXR1cykgPT0gc2lnbmFsLiBJZgpAQCAtMTY0
LDExICsxNjAsMTMgQEAKIAogQWZ0ZXIgc2lnbmFsLWRlbGl2ZXJ5LXN0b3AgaXMgb2JzZXJ2ZWQg
YnkgdHJhY2VyLCB0cmFjZXIgc2hvdWxkIHJlc3RhcnQKIHRyYWNlZSB3aXRoCisKIAlwdHJhY2Uo
UFRSQUNFX3Jlc3QsIHBpZCwgMCwgc2lnKQorCiBjYWxsLCB3aGVyZSBQVFJBQ0VfcmVzdCBpcyBv
bmUgb2YgdGhlIHJlc3RhcnRpbmcgcHRyYWNlIG9wcy4gSWYgc2lnIGlzCiAwLCB0aGVuIHNpZ25h
bCBpcyBub3QgZGVsaXZlcmVkLiBPdGhlcndpc2UsIHNpZ25hbCBzaWcgaXMgZGVsaXZlcmVkLgot
VGhpcyBvcGVyYXRpb24gaXMgY2FsbGVkICJzaWduYWwgaW5qZWN0aW9uIiwgdG8gZGlzdGluZ3Vp
c2ggaXQgZnJvbQotc2lnbmFsIGRlbGl2ZXJ5IHdoaWNoIGNhdXNlcyBzaWduYWwtZGVsaXZlcnkt
c3RvcC4KK1RoaXMgb3BlcmF0aW9uIGlzIGNhbGxlZCAic2lnbmFsIGluamVjdGlvbiIgaW4gdGhp
cyBkb2N1bWVudCwgdG8KK2Rpc3Rpbmd1aXNoIGl0IGZyb20gc2lnbmFsLWRlbGl2ZXJ5LXN0b3Au
CiAKIE5vdGUgdGhhdCBzaWcgdmFsdWUgbWF5IGJlIGRpZmZlcmVudCBmcm9tIFdTVE9QU0lHKHN0
YXR1cykgdmFsdWUgLQogdHJhY2VyIGNhbiBjYXVzZSBhIGRpZmZlcmVudCBzaWduYWwgdG8gYmUg
aW5qZWN0ZWQuCkBAIC0yMjEsMTMgKzIxOSwxNSBAQAogdHJhY2VlIG9ubHkpLCBhbmQgb25seSBh
ZnRlciBpdCBpcyBpbmplY3RlZCBieSB0cmFjZXIgKG9yIGFmdGVyIGl0IHdhcwogZGlzcGF0Y2hl
ZCB0byBhIHRocmVhZCB3aGljaCBpc24ndCB0cmFjZWQpLCBncm91cC1zdG9wIHdpbGwgYmUKIGlu
aXRpYXRlZCBvbiBBTEwgdHJhY2VlcyB3aXRoaW4gbXVsdGktdGhyZWFkZWQgcHJvY2Vzcy4gQXMg
dXN1YWwsIGV2ZXJ5Ci10cmFjZWUgcmVwb3J0cyBpdHMgZ3JvdXAtc3RvcCB0byBjb3JyZXNwb25k
aW5nIHRyYWNlci4KK3RyYWNlZSByZXBvcnRzIGl0cyBncm91cC1zdG9wIHNlcGFyYXRlbHkgdG8g
Y29ycmVzcG9uZGluZyB0cmFjZXIuCiAKIEdyb3VwLXN0b3AgaXMgb2JzZXJ2ZWQgYnkgdHJhY2Vy
IGFzIHdhaXRwaWQgcmV0dXJuaW5nIHdpdGgKIFdJRlNUT1BQRUQoc3RhdHVzKSA9PSB0cnVlLCBX
U1RPUFNJRyhzdGF0dXMpID09IHNpZ25hbC4gVGhlIHNhbWUgcmVzdWx0CiBpcyByZXR1cm5lZCBi
eSBzb21lIG90aGVyIGNsYXNzZXMgb2YgcHRyYWNlLXN0b3BzLCB0aGVyZWZvcmUgdGhlCiByZWNv
bW1lbmRlZCBwcmFjdGljZSBpcyB0byBwZXJmb3JtCisKIAlwdHJhY2UoUFRSQUNFX0dFVFNJR0lO
Rk8sIHBpZCwgMCwgJnNpZ2luZm8pCisKIGNhbGwuIFRoZSBjYWxsIGNhbiBiZSBhdm9pZGVkIGlm
IHNpZ25hbCBudW1iZXIgaXMgbm90IFNJR1NUT1AsIFNJR1RTVFAsCiBTSUdUVElOIG9yIFNJR1RU
T1UgLSBvbmx5IHRoZXNlIGZvdXIgc2lnbmFscyBhcmUgc3RvcHBpbmcgc2lnbmFscy4gSWYKIHRy
YWNlciBzZWVzIHNvbWV0aGluZyBlbHNlLCBpdCBjYW4ndCBiZSBncm91cC1zdG9wLiBPdGhlcndp
c2UsIHRyYWNlcgpAQCAtMjc3LDkgKzI3NywxMSBAQAogCiBQVFJBQ0VfRVZFTlRfRVhFQyAtIHN0
b3AgYmVmb3JlIHJldHVybiBmcm9tIGV4ZWMuCiAKLVBUUkFDRV9FVkVOVF9FWElUIC0gc3RvcCBi
ZWZvcmUgZXhpdC4gUFRSQUNFX0dFVEVWRU5UTVNHIHJldHVybnMgZXhpdAotc3RhdHVzLiBSZWdp
c3RlcnMgY2FuIGJlIGV4YW1pbmVkICh1bmxpa2Ugd2hlbiAicmVhbCIgZXhpdCBoYXBwZW5zKS4K
LVRoZSB0cmFjZWUgaXMgc3RpbGwgYWxpdmUsIGl0IG5lZWRzIHRvIGJlIFBUUkFDRV9DT05UZWQg
dG8gZmluaXNoIGV4aXQuCitQVFJBQ0VfRVZFTlRfRVhJVCAtIHN0b3AgYmVmb3JlIGV4aXQgKGlu
Y2x1ZGluZyBkZWF0aCBmcm9tIGV4aXRfZ3JvdXApLAorc2lnbmFsIGRlYXRoLCBvciBleGl0IGNh
dXNlZCBieSBleGVjdmUgaW4gbXVsdGktdGhyZWFkZWQgcHJvY2Vzcy4KK1BUUkFDRV9HRVRFVkVO
VE1TRyByZXR1cm5zIGV4aXQgc3RhdHVzLiBSZWdpc3RlcnMgY2FuIGJlIGV4YW1pbmVkCisodW5s
aWtlIHdoZW4gInJlYWwiIGV4aXQgaGFwcGVucykuIFRoZSB0cmFjZWUgaXMgc3RpbGwgYWxpdmUs
IGl0IG5lZWRzCit0byBiZSBQVFJBQ0VfQ09OVGVkIG9yIFBUUkFDRV9ERVRBQ0hlZCB0byBmaW5p
c2ggZXhpdC4KIAogUFRSQUNFX0dFVFNJR0lORk8gb24gUFRSQUNFX0VWRU5UIHN0b3BzIHJldHVy
bnMgc2lfc2lnbm8gPSBTSUdUUkFQLAogc2lfY29kZSA9IChldmVudCA8PCA4KSB8IFNJR1RSQVAu
CkBAIC0zNjksNyArMzcxLDkgQEAKIAogQW5vdGhlciBncm91cCBvZiBjb21tYW5kcyBtYWtlcyBw
dHJhY2Utc3RvcHBlZCB0cmFjZWUgcnVuLiBUaGV5IGhhdmUKIHRoZSBmb3JtOgorCiAJcHRyYWNl
KFBUUkFDRV9jbWQsIHBpZCwgMCwgc2lnKTsKKwogd2hlcmUgY21kIGlzIENPTlQsIERFVEFDSCwg
U1lTQ0FMTCwgU0lOR0xFU1RFUCwgU1lTRU1VLCBvcgogU1lTRU1VX1NJTkdMRVNURVAuIElmIHRy
YWNlZSBpcyBpbiBzaWduYWwtZGVsaXZlcnktc3RvcCwgc2lnIGlzIHRoZQogc2lnbmFsIHRvIGJl
IGluamVjdGVkLiBPdGhlcndpc2UsIHNpZyBtYXkgYmUgaWdub3JlZC4KQEAgLTM5NCw4ICszOTgs
OSBAQAogCiBwdHJhY2UoUFRSQUNFX1RSQUNFTUUsIDAsIDAsIDApIHJlcXVlc3QgdHVybnMgY3Vy
cmVudCB0aHJlYWQgaW50byBhCiB0cmFjZWUuIEl0IGNvbnRpbnVlcyB0byBydW4gKGRvZXNuJ3Qg
ZW50ZXIgcHRyYWNlLXN0b3ApLiBBIGNvbW1vbgotcHJhY3RpY2UgaXMgZm9sbG93IHB0cmFjZShQ
VFJBQ0VfVFJBQ0VNRSkgd2l0aCByYWlzZShTSUdTVE9QKSBhbmQgYWxsb3cKLXBhcmVudCAod2hp
Y2ggaXMgb3VyIHRyYWNlciBub3cpIHRvIG9ic2VydmUgb3VyIHNpZ25hbC1kZWxpdmVyeS1zdG9w
LgorcHJhY3RpY2UgaXMgdG8gZm9sbG93IHB0cmFjZShQVFJBQ0VfVFJBQ0VNRSkgd2l0aCByYWlz
ZShTSUdTVE9QKSBhbmQKK2FsbG93IHBhcmVudCAod2hpY2ggaXMgb3VyIHRyYWNlciBub3cpIHRv
IG9ic2VydmUgb3VyCitzaWduYWwtZGVsaXZlcnktc3RvcC4KIAogSWYgUFRSQUNFX09fVFJBQ0Vb
Vl1GT1JLIG9yIFBUUkFDRV9PX1RSQUNFQ0xPTkUgb3B0aW9ucyBhcmUgaW4gZWZmZWN0LAogdGhl
biBjaGlsZHJlbiBjcmVhdGVkIGJ5ICh2Zm9yayBvciBjbG9uZShDTE9ORV9WRk9SSykpLCAoZm9y
ayBvcgpAQCAtNDM1LDkgKzQ0MCwxMSBAQAogcmVzZXRzIGV4ZWN2ZSdpbmcgdGhyZWFkIHRpZCB0
byB0Z2lkIChwcm9jZXNzIGlkKS4gVGhpcyBsb29rcyB2ZXJ5CiBjb25mdXNpbmcgdG8gdHJhY2Vy
czoKIAotQWxsIG90aGVyIHRocmVhZHMgImRpc2FwcGVhciIgLSB0aGF0IGlzLCB0aGV5IHRlcm1p
bmF0ZSB0aGVpciBleGVjdXRpb24KLXdpdGhvdXQgcmV0dXJuaW5nIGFueSB3YWl0cGlkIG5vdGlm
aWNhdGlvbnMgdG8gYW55b25lLCBldmVuIGlmIHRoZXkgYXJlCi1jdXJyZW50bHkgdHJhY2VkLgor
QWxsIG90aGVyIHRocmVhZHMgc3RvcCBpbiBQVFJBQ0VfRVhJVCBzdG9wLCBpZiByZXF1ZXN0ZWQg
YnkgYWN0aXZlCitwdHJhY2Ugb3B0aW9uLiBUaGVuIGFsbCBvdGhlciB0aHJlYWRzIGV4Y2VwdCB0
aHJlYWQgZ3JvdXAgbGVhZGVyIHJlcG9ydAorZGVhdGggYXMgaWYgdGhleSBleGl0ZWQgdmlhIGV4
aXQgc3lzY2FsbCB3aXRoIGV4aXQgY29kZSAwLiBUaGVuCitQVFJBQ0VfRVZFTlRfRVhFQyBzdG9w
IGhhcHBlbnMsIGlmIHJlcXVlc3RlZCBieSBhY3RpdmUgcHRyYWNlIG9wdGlvbgorKG9uIHdoaWNo
IHRyYWNlZSAtIGxlYWRlcj8gZXhlY3ZlLWluZyBvbmU/KS4KIAogVGhlIGV4ZWN2ZS1pbmcgdHJh
Y2VlIGNoYW5nZXMgaXRzIHBpZCB3aGlsZSBpdCBpcyBpbiBleGVjdmUgc3lzY2FsbC4KIChSZW1l
bWJlciwgdW5kZXIgcHRyYWNlICdwaWQnIHJldHVybmVkIGZyb20gd2FpdHBpZCwgb3IgZmVkIGlu
dG8gcHRyYWNlCkBAIC00NjEsMzUgKzQ2OCwzMiBAQAogUGlkIGNoYW5nZSBoYXBwZW5zIGJlZm9y
ZSBQVFJBQ0VfRVZFTlRfRVhFQyBzdG9wLCBub3QgYWZ0ZXIuCiAKIFdoZW4gdHJhY2VyIHJlY2Vp
dmVzIFBUUkFDRV9FVkVOVF9FWEVDIHN0b3Agbm90aWZpY2F0aW9uLCBpdCBpcwotZ3VhcmFudGVl
ZCB0aGF0IGV4Y2VwdCB0aGlzIHRyYWNlZSwgbm8gb3RoZXIgdGhyZWFkcyBmcm9tIHRoZSBwcm9j
ZXNzCi1hcmUgYWxpdmUuIE1vcmVvdmVyLCBpdCBpcyBndWFyYW50ZWVkIHRoYXQgdHJhY2VyIHdp
bGwgbm90IHJlY2VpdmUgYW55Ci0iYnVmZmVyZWQiIGRlYXRoIHJlcG9ydHMgZnJvbSBhbnkgb2Yg
dGhlbSwgZXZlbiBpZiBzb21lIHRocmVhZHMgd2VyZQotcmFjaW5nIHdpdGggZXhlY3ZlJ2luZyB0
cmFjZWUsIGZvciBleGFtcGxlIHdlcmUgZW50ZXJpbmcgZXhpdCBzeXNjYWxsLgorZ3VhcmFudGVl
ZCB0aGF0IGV4Y2VwdCB0aGlzIHRyYWNlZSBhbmQgdGhyZWFkIGdyb3VwIGxlYWRlciwgbm8gb3Ro
ZXIKK3RocmVhZHMgZnJvbSB0aGUgcHJvY2VzcyBhcmUgYWxpdmUuCiAKIE9uIHJlY2VpdmluZyB0
aGlzIG5vdGlmaWNhdGlvbiwgdHJhY2VyIHNob3VsZCBjbGVhbiB1cCBhbGwgaXRzIGludGVybmFs
CiBkYXRhIHN0cnVjdHVyZXMgYWJvdXQgYWxsIHRocmVhZHMgb2YgdGhpcyBwcm9jZXNzLCBhbmQg
cmV0YWluIG9ubHkgb25lCiBkYXRhIHN0cnVjdHVyZSwgb25lIHdoaWNoIGRlc2NyaWJlcyBzaW5n
bGUgc3RpbGwgcnVubmluZyB0cmFjZWUsIHdpdGgKIHBpZCA9IHRnaWQgPSBwcm9jZXNzIGlkLgog
Ci0/Pz8gSG93IHRyYWNlciBrbm93cyB3aGljaCBvZiBpdHMgbWFueSB0cmFjZWVzIF9hcmVfIHRo
cmVhZHMgb2YgdGhhdAotcGFydGljdWxhciBwcm9jZXNzPyAoSXQgbWF5IHRyYWNlIG1vcmUgdGhh
biBvbmUgcHJvY2VzczsgaXQgbWF5IGV2ZW4KLWRvbid0IGtlZXAgdHJhY2sgb2YgaXRzIHRyYWNl
ZXMnIHRocmVhZCBncm91cCByZWxhdGlvbnMgYXQgYWxsLi4uKQotCi0/Pz8gd2hhdCBoYXBwZW5z
IGlmIHR3byB0aHJlYWRzIGV4ZWN2ZSBhdCB0aGUgc2FtZSB0aW1lPyBDbGVhcmx5LCBvbmx5Ci1v
bmUgb2YgdGhlbSBzdWNjZWVkcywgYnV0ICp3aGljaCogb25lPyBUaGluayAic3RyYWNlIC1mIiBv
cgotbXVsdGktdGhyZWFkZWQgcHJvY2VzcyBoZXJlOgorQ3VycmVudGx5LCB0aGVyZSBpcyBubyB3
YXkgdG8gcmV0cmlldmUgZm9ybWVyIHBpZCBvZiBleGVjdmUtaW5nIHRyYWNlZS4KK0lmIHRyYWNl
ciBkb2Vzbid0IGtlZXAgdHJhY2sgb2YgaXRzIHRyYWNlZXMnIHRocmVhZCBncm91cCByZWxhdGlv
bnMsIGl0CittYXkgYmUgdW5hYmxlIHRvIGtub3cgd2hpY2ggdHJhY2VlIGV4ZWN2ZS1lZCBhbmQg
dGhlcmVmb3JlIG5vIGxvbmdlcgorZXhpc3RzIHVuZGVyIG9sZCBwaWQgZHVlIHRvIHBpZCBjaGFu
Z2UuCisKK0V4YW1wbGU6IHR3byB0aHJlYWRzIGV4ZWN2ZSBhdCB0aGUgc2FtZSB0aW1lOgogCi0g
ICoqIHdlIGdldCBkZWF0aCBub3RpZmljYXRpb246IGxlYWRlciBkaWVkOiAqKgotIFBJRDAgZXhp
dCgwKSAgICAgICAgICAgICAgICAgICAgICAgICAgICA9ID8KICAgKiogd2UgZ2V0IHN5c2NhbGwt
ZW50cnktc3RvcCBpbiB0aHJlYWQgMTogKioKICBQSUQxIGV4ZWN2ZSgiL2Jpbi9mb28iLCAiZm9v
IiA8dW5maW5pc2hlZCAuLi4+CisgICoqIHdlIGlzc3VlIFBUUkFDRV9TWVNDQUxMIGZvciB0aHJl
YWQgMSAqKgogICAqKiB3ZSBnZXQgc3lzY2FsbC1lbnRyeS1zdG9wIGluIHRocmVhZCAyOiAqKgog
IFBJRDIgZXhlY3ZlKCIvYmluL2JhciIsICJiYXIiIDx1bmZpbmlzaGVkIC4uLj4KKyAgKiogd2Ug
aXNzdWUgUFRSQUNFX1NZU0NBTEwgZm9yIHRocmVhZCAyICoqCiAgICoqIHdlIGdldCBQVFJBQ0Vf
RVZFTlRfRVhFQyBmb3IgUElEMCwgd2UgaXNzdWUgUFRSQUNFX1NZU0NBTEwgKioKICAgKiogd2Ug
Z2V0IHN5c2NhbGwtZXhpdC1zdG9wIGZvciBQSUQwOiAqKgogIFBJRDAgPC4uLiBleGVjdmUgcmVz
dW1lZD4gKSAgICAgICAgICAgICA9IDAKIAotPz8/IFF1ZXN0aW9uOiBXSElDSCBleGVjdmUgc3Vj
Y2VlZGVkPyBDYW4gdHJhY2VyIGZpZ3VyZSBpdCBvdXQ/CitJbiB0aGlzIHNpdHVhdGlvbiB0aGVy
ZSBpcyBubyB3YXkgdG8ga25vdyB3aGljaCBleGVjdmUgc3VjY2VlZGVkLgogCiBJZiBQVFJBQ0Vf
T19UUkFDRUVYRUMgb3B0aW9uIGlzIE5PVCBpbiBlZmZlY3QgZm9yIHRoZSBleGVjdmUnaW5nCiB0
cmFjZWUsIGtlcm5lbCBkZWxpdmVycyBhbiBleHRyYSBTSUdUUkFQIHRvIHRyYWNlZSBhZnRlciBl
eGVjdmUgc3lzY2FsbApAQCAtNTIzLDE2ICs1MjcsMzEgQEAKIHdob2xlIG11bHRpLXRocmVhZGVk
IHByb2Nlc3MgZXhpdHMpLiBJZiB0aGV5IGFyZSB0aGUgc2FtZSBwcm9jZXNzLCB0aGUKIHJlcG9y
dCBpcyBzZW50IG9ubHkgb25jZS4KIAotLSA/Pz8gYWRkIG1vcmUgZG9jcwogCi1Gb2xsb3dpbmcg
YnVncyBzdGlsbCBleGlzdDoKKwkxLnggS25vd24gYnVncwogCi0tIGdyb3VwLXN0b3Agbm90aWZp
Y2F0aW9ucyBhcmUgc2VudCB0byB0cmFjZXIsIGJ1dCBub3QgdG8gcmVhbCBwYXJlbnQuCitGb2xs
b3dpbmcgYnVncyBzdGlsbCBleGlzdDoKIAotLSBJZiB0aHJlYWQgZ3JvdXAgbGVhZGVyIGl0IGlz
IHRyYWNlZCBhbmQgZXhpdHMsIGRvX3dhaXQoV0VYSVRFRCkKLWRvZXNuJ3Qgd29yayAodW50aWwg
YWxsIHRocmVhZHMgZXhpdCkgZm9yIGl0cyB0aGUgdHJhY2VyLgorR3JvdXAtc3RvcCBub3RpZmlj
YXRpb25zIGFyZSBzZW50IHRvIHRyYWNlciwgYnV0IG5vdCB0byByZWFsIHBhcmVudC4KK0xhc3Qg
Y29uZmlybWVkIG9uIDIuNi4zOC42LgogCi0/Pz8gYWRkIG1vcmUga25vd24gYnVncyBoZXJlCitJ
ZiB0aHJlYWQgZ3JvdXAgbGVhZGVyIGlzIHRyYWNlZCBhbmQgZXhpdHMgYnkgY2FsbGluZyBleGl0
IHN5c2NhbGwsCitQVFJBQ0VfRVZFTlRfRVhJVCBzdG9wIHdpbGwgaGFwcGVuIGZvciBpdCAoaWYg
cmVxdWVzdGVkKSwgYnV0CitzdWJzZXF1ZW50IFdJRkVYSVRFRCBub3RpZmljYXRpb24gd2lsbCBu
b3QgYmUgZGVsaXZlcmVkIHVudGlsIGFsbCBvdGhlcgordGhyZWFkcyBleGl0LiBBcyBleHBsYWlu
ZWQgYWJvdmUsIGlmIG9uZSBvZiBvdGhlciB0aHJlYWRzIGV4ZWN2ZSdzLAordGhyZWFkIGdyb3Vw
IGxlYWRlciBkZWF0aCB3aWxsICpuZXZlciogYmUgcmVwb3J0ZWQuIElmIGV4ZWN2ZS1lZCB0aHJl
YWQKK2lzIG5vdCB0cmFjZWQgYnkgdGhpcyB0cmFjZXIsIHRyYWNlciB3aWxsIG5ldmVyIGtub3cg
dGhhdCBleGVjdmUKK2hhcHBlbmVkLgorCis/Pz8gbmVlZCB0byB0ZXN0IHRoaXMgc2NlbmFyaW8K
KworT25lIHBvc3NpYmxlIHdvcmthcm91bmQgaXMgdG8gZGV0YWNoIHRocmVhZCBncm91cCBsZWFk
ZXIgaW5zdGVhZCBvZgorcmVzdGFydGluZyBpdCBpbiB0aGlzIGNhc2UuIExhc3QgY29uZmlybWVk
IG9uIDIuNi4zOC42LgorCitTSUdLSUxMIHNpZ25hbCBtYXkgc3RpbGwgY2F1c2UgUFRSQUNFX0VW
RU5UX0VYSVQgc3RvcCBiZWZvcmUgYWN0dWFsCitzaWduYWwgZGVhdGguIFRoaXMgbWF5IGJlIGNo
YW5nZWQgaW4gdGhlIGZ1dHVyZSAtIFNJR0tJTEwgaXMgbWVhbnQgdG8KK2Fsd2F5cyBpbW1lZGlh
dGVseSBraWxsIHRhc2tzIGV2ZW4gdW5kZXIgcHRyYWNlLiBMYXN0IGNvbmZpcm1lZCBvbgorMi42
LjM4LjYuCiAKIAogCg==
--0016e6d96c368c1e2004a4d01623--
