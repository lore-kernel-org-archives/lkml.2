Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1E3OKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:10:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37398 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1E3OKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=YTfzwDoaUkacite7AnP10lfGSF2OjJ/zNXxNsZa6FKi0yWlxOoQHvhVOAuk0wIza82
         eEIRU//V1ErBfI5+S+V75FOjFXUWYRWhWOTFyn314UqLt+nh4rR2q/kEwRtBjqGRtJdh
         hHG3a3yg+l8t1RnLV/pxwCfU+W2YrQHe8zw5w=
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 30 May 2011 16:09:42 +0200
Message-ID: <BANLkTinXMaOQ5Cqb_JV5uJZ746HJj1ULbQ@mail.gmail.com>
Subject: Ptrace documentation, draft #4
To: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: multipart/mixed; boundary=001485f9a7c8ea803204a47ed78a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485f9a7c8ea803204a47ed78a
Content-Type: text/plain; charset=ISO-8859-1

Ptrace discussions repeatedly display a higher than average amount
of misunderstanding and confusion. New ptrace users and even people
who already worked with it are repeatedly confused by details
which are not documented anywhere and knowledge about which exists
mostly in the brains of strace/gdb/other_such_tools developers.

This document is meant as a brain dump of this knowledge.
It assumes that the reader has basic understanding what ptrace is.

The diff from version 3 is attached too.

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
before actual death. This applies to both normal exits and signal
deaths (except SIGKILL).

KNOWN BUG: PTRACE_EVENT_EXIT should happen for every tracee in thread
group on exit_group or signal death, but currently (~2.6.38) this is
buggy: some of these stops may be missed.

Tracer cannot assume that ptrace-stopped tracee exists. There are many
scenarios when tracee may die while stopped (such as SIGKILL). There
are cases where tracee disappears without reporting death (such as
execve in multi-threaded process). Therefore, tracer must always be
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

??? Do we require __WALL usage, or will just using 0 be ok? Are the
rules different if user wants to use waitid? Will waitid require WEXITED?

__WALL value does not include WSTOPPED and WEXITED bits, but implies
their functionality.

Setting of WCONTINUED bit in waitpid flags is not recommended: the
continued state is per-process and consuming it would confuse real
parent of the tracee.

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
(status >> 8) value (note that WSTOPSIG(status) is (status >> 8) &
0xff) and if looking at (status >> 8) value doesn't resolve ambiguity,
by querying PTRACE_GETSIGINFO.


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
ptrace-stop - see "Syscall-stops" and "execve" sections below for
details. If WSTOPSIG(status) == stopping signal, this may be a
group-stop - see below.


	1.x.x Signal injection and suppression.

After signal-delivery-stop is observed by tracer, tracer should restart
tracee with
	ptrace(PTRACE_rest, pid, 0, sig)
call, where PTRACE_rest is one of the restarting ptrace ops. If sig is
0, then signal is not delivered. Otherwise, signal sig is delivered.
This operation is called "signal injection", to distinguish it from
signal delivery which causes signal-delivery-stop.

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
tracee reports its group-stop to corresponding tracer.

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

PTRACE_EVENT_EXIT - stop before exit. PTRACE_GETEVENTMSG returns exit
status. Registers can be examined (unlike when "real" exit happens).
The tracee is still alive, it needs to be PTRACE_CONTed to finish exit.

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

All other threads "disappear" - that is, they terminate their execution
without returning any waitpid notifications to anyone, even if they are
currently traced.

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
guaranteed that except this tracee, no other threads from the process
are alive. Moreover, it is guaranteed that tracer will not receive any
"buffered" death reports from any of them, even if some threads were
racing with execve'ing tracee, for example were entering exit syscall.

On receiving this notification, tracer should clean up all its internal
data structures about all threads of this process, and retain only one
data structure, one which describes single still running tracee, with
pid = tgid = process id.

??? How tracer knows which of its many tracees _are_ threads of that
particular process? (It may trace more than one process; it may even
don't keep track of its tracees' thread group relations at all...)

??? what happens if two threads execve at the same time? Clearly, only
one of them succeeds, but *which* one? Think "strace -f" or
multi-threaded process here:

  ** we get death notification: leader died: **
 PID0 exit(0)                            = ?
  ** we get syscall-entry-stop in thread 1: **
 PID1 execve("/bin/foo", "foo" <unfinished ...>
  ** we get syscall-entry-stop in thread 2: **
 PID2 execve("/bin/bar", "bar" <unfinished ...>
  ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
  ** we get syscall-exit-stop for PID0: **
 PID0 <... execve resumed> )             = 0

??? Question: WHICH execve succeeded? Can tracer figure it out?

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

- ??? add more docs

Following bugs still exist:

- group-stop notifications are sent to tracer, but not to real parent.

- If thread group leader it is traced and exits, do_wait(WEXITED)
doesn't work (until all threads exit) for its the tracer.

??? add more known bugs here



	2. Linux kernel implementation

TODO

--001485f9a7c8ea803204a47ed78a
Content-Type: text/x-patch; charset=US-ASCII; name="DOC34.diff"
Content-Disposition: attachment; filename="DOC34.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gobhp03a0

LS0tIERPQ2EJMjAxMS0wNS0yMCAyMTo1MjoyNC4xNTI5NjQwNjggKzAyMDAKKysrIERPQ2IudHh0
CTIwMTEtMDUtMzAgMTY6MDM6MzQuODc4NzkwMjI1ICswMjAwCkBAIC0xMDUsMTYgKzEwNSwzOSBA
QAogV2hlbiBydW5uaW5nIHRyYWNlZSBlbnRlcnMgcHRyYWNlLXN0b3AsIGl0IG5vdGlmaWVzIGl0
cyB0cmFjZXIgdXNpbmcKIHdhaXRwaWQgQVBJLiBUcmFjZXIgc2hvdWxkIHVzZSB3YWl0cGlkIGZh
bWlseSBvZiBzeXNjYWxscyB0byB3YWl0IGZvcgogdHJhY2VlIHRvIHN0b3AuIE1vc3Qgb2YgdGhp
cyBkb2N1bWVudCBhc3N1bWVzIHRoYXQgdHJhY2VyIHdhaXRzIHdpdGg6CisKIAlwaWQgPSB3YWl0
cGlkKHBpZF9vcl9taW51c18xLCAmc3RhdHVzLCBfX1dBTEwpOworCiBQdHJhY2Utc3RvcHBlZCB0
cmFjZWVzIGFyZSByZXBvcnRlZCBhcyByZXR1cm5zIHdpdGggcGlkID4gMCBhbmQKIFdJRlNUT1BQ
RUQoc3RhdHVzKSA9PSB0cnVlLgogCi0/Pz8gYW55IHBpdGZhbGxzIHdpdGggV05PSEFORyAoSSBy
ZW1lbWJlciB0aGF0IHRoZXJlIGFyZSBidWdzIGluIHRoaXMKLSAgICBhcmVhKT8gZWZmZWN0cyBv
ZiBXU1RPUFBFRCwgV0VYSVRFRCwgV0NPTlRJTlVFRCBiaXRzPyBBcmUgdGhleSBvaz8KLSAgICB3
YWl0aWQgdXNhZ2U/IFdOT1dBSVQ/Cis/Pz8gRG8gd2UgcmVxdWlyZSBfX1dBTEwgdXNhZ2UsIG9y
IHdpbGwganVzdCB1c2luZyAwIGJlIG9rPyBBcmUgdGhlCitydWxlcyBkaWZmZXJlbnQgaWYgdXNl
ciB3YW50cyB0byB1c2Ugd2FpdGlkPworCitfX1dBTEwgdmFsdWUgZG9lcyBub3QgaW5jbHVkZSBX
U1RPUFBFRCBhbmQgV0VYSVRFRCBiaXRzLCBidXQgaW1wbGllcwordGhlaXIgZnVuY3Rpb25hbGl0
eS4KKworU2V0dGluZyBvZiBXQ09OVElOVUVEIGJpdCBpbiB3YWl0cGlkIGZsYWdzIGlzIG5vdCBy
ZWNvbW1lbmRlZDogdGhlCitjb250aW51ZWQgc3RhdGUgaXMgcGVyLXByb2Nlc3MgYW5kIGNvbnN1
bWluZyBpdCB3b3VsZCBjb25mdXNlIHJlYWwKK3BhcmVudCBvZiB0aGUgdHJhY2VlLgorCitVc2Ug
b2YgV05PSEFORyBiaXQgaW4gd2FpdHBpZCBmbGFncyBtYXkgY2F1c2Ugd2FpdHBpZCByZXR1cm4g
MCAoIm5vCit3YWl0IHJlc3VsdHMgYXZhaWxhYmxlIHlldCIpIGV2ZW4gaWYgdHJhY2VyIGtub3dz
IHRoZXJlIHNob3VsZCBiZSBhCitub3RpZmljYXRpb24uIEV4YW1wbGU6IGtpbGwodHJhY2VlLCBT
SUdLSUxMKTsgd2FpdHBpZCh0cmFjZWUsICZzdGF0dXMsCitfX1dBTEwgfCBXTk9IQU5HKTsKKwor
Pz8/IHdhaXRpZCB1c2FnZT8gV05PV0FJVD8KIAogPz8/IGRlc2NyaWJlIGhvdyB3YWl0IG5vdGlm
aWNhdGlvbnMgcXVldWUgKG9yIG5vdCBxdWV1ZSkKIAorVGhlIGZvbGxvd2luZyBraW5kcyBvZiBw
dHJhY2Utc3RvcHMgZXhpc3Q6IHNpZ25hbC1kZWxpdmVyeS1zdG9wcywKK2dyb3VwLXN0b3AsIFBU
UkFDRV9FVkVOVCBzdG9wcywgc3lzY2FsbC1zdG9wcyBbLCBTSU5HTEVTVEVQLCBTWVNFTVUsCitT
WVNFTVVfU0lOR0xFU1RFUF0uIFRoZXkgYWxsIGFyZSByZXBvcnRlZCBhcyB3YWl0cGlkIHJlc3Vs
dCB3aXRoCitXSUZTVE9QUEVEKHN0YXR1cykgPT0gdHJ1ZS4gVGhleSBtYXkgYmUgZGlmZmVyZW50
aWF0ZWQgYnkgY2hlY2tpbmcKKyhzdGF0dXMgPj4gOCkgdmFsdWUgKG5vdGUgdGhhdCBXU1RPUFNJ
RyhzdGF0dXMpIGlzIChzdGF0dXMgPj4gOCkgJgorMHhmZikgYW5kIGlmIGxvb2tpbmcgYXQgKHN0
YXR1cyA+PiA4KSB2YWx1ZSBkb2Vzbid0IHJlc29sdmUgYW1iaWd1aXR5LAorYnkgcXVlcnlpbmcg
UFRSQUNFX0dFVFNJR0lORk8uCisKIAogCTEueC54IFNpZ25hbC1kZWxpdmVyeS1zdG9wCiAKQEAg
LTE4Niw3ICsyMDksOCBAQAogUFRSQUNFX0dFVFNJR0lORk8gY2FuIGJlIHVzZWQgdG8gcmV0cmll
dmUgc2lnaW5mb190IHN0cnVjdHVyZSB3aGljaAogY29ycmVzcG9uZHMgdG8gZGVsaXZlcmVkIHNp
Z25hbC4gUFRSQUNFX1NFVFNJR0lORk8gbWF5IGJlIHVzZWQgdG8KIG1vZGlmeSBpdC4gSWYgUFRS
QUNFX1NFVFNJR0lORk8gaGFzIGJlZW4gdXNlZCB0byBhbHRlciBzaWdpbmZvX3QsCi1zaV9zaWdu
byBmaWVsZCBhbmQgc2lnIHBhcmFtZXRlciBpbiByZXN0YXJ0aW5nIGNvbW1hbmQgbXVzdCBtYXRj
aC4KK3NpX3NpZ25vIGZpZWxkIGFuZCBzaWcgcGFyYW1ldGVyIGluIHJlc3RhcnRpbmcgY29tbWFu
ZCBtdXN0IG1hdGNoLAorb3RoZXJ3aXNlIHRoZSByZXN1bHQgaXMgdW5kZWZpbmVkLgogCiAKIAkx
LngueCBHcm91cC1zdG9wCkBAIC0yMDcsOCArMjMxLDkgQEAKIGNhbGwuIFRoZSBjYWxsIGNhbiBi
ZSBhdm9pZGVkIGlmIHNpZ25hbCBudW1iZXIgaXMgbm90IFNJR1NUT1AsIFNJR1RTVFAsCiBTSUdU
VElOIG9yIFNJR1RUT1UgLSBvbmx5IHRoZXNlIGZvdXIgc2lnbmFscyBhcmUgc3RvcHBpbmcgc2ln
bmFscy4gSWYKIHRyYWNlciBzZWVzIHNvbWV0aGluZyBlbHNlLCBpdCBjYW4ndCBiZSBncm91cC1z
dG9wLiBPdGhlcndpc2UsIHRyYWNlcgotbmVlZHMgdG8gY2FsbCBQVFJBQ0VfR0VUU0lHSU5GTy4g
SWYgUFRSQUNFX0dFVFNJR0lORk8gZmFpbHMsIHRoZW4gaXQgaXMKLWRlZmluaXRlbHkgYSBncm91
cC1zdG9wLgorbmVlZHMgdG8gY2FsbCBQVFJBQ0VfR0VUU0lHSU5GTy4gSWYgUFRSQUNFX0dFVFNJ
R0lORk8gZmFpbHMgd2l0aAorRUlOVkFMLCB0aGVuIGl0IGlzIGRlZmluaXRlbHkgYSBncm91cC1z
dG9wLiAoT3RoZXIgZmFpbHVyZSBjb2RlcyBhcmUKK3Bvc3NpYmxlLCBzdWNoIGFzIEVTUkNIICJu
byBzdWNoIHByb2Nlc3MiIGlmIFNJR0tJTEwga2lsbGVkIHRoZSB0cmFjZWUpLgogCiBBcyBvZiBr
ZXJuZWwgMi42LjM4LCBhZnRlciB0cmFjZXIgc2VlcyB0cmFjZWUgcHRyYWNlLXN0b3AgYW5kIHVu
dGlsIGl0CiByZXN0YXJ0cyBvciBraWxscyBpdCwgdHJhY2VlIHdpbGwgbm90IHJ1biwgYW5kIHdp
bGwgbm90IHNlbmQKQEAgLTI3OCwyMCArMzAzLDI0IEBACiBTSUdUUkFQLiBJZiBQVFJBQ0VfT19U
UkFDRVNZU0dPT0Qgb3B0aW9uIHdhcyBzZXQgYnkgdHJhY2VyLCB0aGVuCiBXU1RPUFNJRyhzdGF0
dXMpID09IChTSUdUUkFQIHwgMHg4MCkuCiAKLVRoZXJlIGlzIG5vIHBvcnRhYmxlIHdheSB0byBk
aXN0aW5ndWlzaCB0aGVtIGZyb20gc2lnbmFsLWRlbGl2ZXJ5LXN0b3AKLXdpdGggU0lHVFJBUC4g
U29tZSBhcmNoaXRlY3R1cmVzIGFsbG93IHRvIGRpc3Rpbmd1aXNoIHRoZW0gYnkgZXhhbWluaW5n
Ci1yZWdpc3RlcnMuIEZvciBleGFtcGxlLCBvbiB4ODYgcmF4ID0gLUVOT1NZUyBpbiBzeXNjYWxs
LWVudGVyLXN0b3AuCi1TaW5jZSBTSUdUUkFQIChsaWtlIGFueSBvdGhlciBzaWduYWwpIGFsd2F5
cyBoYXBwZW5zICphZnRlcioKLXN5c2NhbGwtZXhpdC1zdG9wLCBhbmQgYXQgdGhpcyBwb2ludCBy
YXggYWxtb3N0IG5ldmVyIGNvbnRhaW5zIC1FTk9TWVMsCi1TSUdUUkFQIGxvb2tzIGxpa2UgInN5
c2NhbGwtc3RvcCB3aGljaCBpcyBub3Qgc3lzY2FsbC1lbnRlci1zdG9wIiwgSU9XOgotaXQgbG9v
a3MgbGlrZSBhICJzdHJheSBzeXNjYWxsLWV4aXQtc3RvcCIgYW5kIGNhbiBiZSBkZXRlY3RlZCB0
aGlzIHdheS4KLUJ1dCBzdWNoIGRldGVjdGlvbiBpcyBmcmFnaWxlIGFuZCBpcyBiZXN0IGF2b2lk
ZWQuIFVzaW5nCi1QVFJBQ0VfT19UUkFDRVNZU0dPT0Qgb3B0aW9uIGlzIGEgcmVjb21tZW5kZWQg
bWV0aG9kLgotCi0/Pz8gY2FuIGJlIGRpc3Rpbmd1aXNoZWQgYnkgUFRSQUNFX0dFVFNJR0lORk8s
IHNpX2NvZGUgPD0gMCBpZiBzZW50IGJ5Ci11c3VhbCBzdXNwZWN0cyBsaWtlIFt0XWtpbGwsIHNp
Z3F1ZXVlOyBvciA9IFNJX0tFUk5FTCAoMHg4MCkgaWYgc2VudCBieQorU3lzY2FsbC1zdG9wcyBj
YW4gYmUgZGlzdGluZ3Vpc2hlZCBmcm9tIHNpZ25hbC1kZWxpdmVyeS1zdG9wIHdpdGgKK1NJR1RS
QVAgYnkgcXVlcnlpbmcgUFRSQUNFX0dFVFNJR0lORk86IHNpX2NvZGUgPD0gMCBpZiBzZW50IGJ5
IHVzdWFsCitzdXNwZWN0cyBsaWtlIFt0Z11raWxsL3NpZ3F1ZXVlL2V0Yzsgb3IgPSBTSV9LRVJO
RUwgKDB4ODApIGlmIHNlbnQgYnkKIGtlcm5lbCwgd2hlcmVhcyBzeXNjYWxsLXN0b3BzIGhhdmUg
c2lfY29kZSA9IFNJR1RSQVAgb3IgKFNJR1RSQVAgfAotMHg4MCkuIFJpZ2h0PyBTaG91bGQgdGhp
cyBiZSBkb2N1bWVudGVkPworMHg4MCkuIEhvd2V2ZXIsIHN5c2NhbGwtc3RvcHMgaGFwcGVuIHZl
cnkgb2Z0ZW4gKHR3aWNlIHBlciBzeXNjYWxsKSwKK2FuZCBwZXJmb3JtaW5nIFBUUkFDRV9HRVRT
SUdJTkZPIGZvciBldmVyeSBzeXNjYWxsLXN0b3AgbWF5IGJlIHNvbWV3aGF0CitleHBlbnNpdmUu
CisKK1NvbWUgYXJjaGl0ZWN0dXJlcyBhbGxvdyB0byBkaXN0aW5ndWlzaCB0aGVtIGJ5IGV4YW1p
bmluZyByZWdpc3RlcnMuCitGb3IgZXhhbXBsZSwgb24geDg2IHJheCA9IC1FTk9TWVMgaW4gc3lz
Y2FsbC1lbnRlci1zdG9wLiBTaW5jZSBTSUdUUkFQCisobGlrZSBhbnkgb3RoZXIgc2lnbmFsKSBh
bHdheXMgaGFwcGVucyAqYWZ0ZXIqIHN5c2NhbGwtZXhpdC1zdG9wLCBhbmQKK2F0IHRoaXMgcG9p
bnQgcmF4IGFsbW9zdCBuZXZlciBjb250YWlucyAtRU5PU1lTLCBTSUdUUkFQIGxvb2tzIGxpa2UK
KyJzeXNjYWxsLXN0b3Agd2hpY2ggaXMgbm90IHN5c2NhbGwtZW50ZXItc3RvcCIsIElPVzogaXQg
bG9va3MgbGlrZSBhCisic3RyYXkgc3lzY2FsbC1leGl0LXN0b3AiIGFuZCBjYW4gYmUgZGV0ZWN0
ZWQgdGhpcyB3YXkuIEJ1dCBzdWNoCitkZXRlY3Rpb24gaXMgZnJhZ2lsZSBhbmQgaXMgYmVzdCBh
dm9pZGVkLgorCitVc2luZyBQVFJBQ0VfT19UUkFDRVNZU0dPT0Qgb3B0aW9uIGlzIGEgcmVjb21t
ZW5kZWQgbWV0aG9kLCBzaW5jZSBpdCBpcworcmVsaWFibGUgYW5kIGRvZXMgbm90IGluY3VyIHBl
cmZvcm1hbmNlIHBlbmFsdHkuCiAKIFN5c2NhbGwtZW50ZXItc3RvcCBhbmQgc3lzY2FsbC1leGl0
LXN0b3AgYXJlIGluZGlzdGluZ3Vpc2hhYmxlIGZyb20KIGVhY2ggb3RoZXIgYnkgdHJhY2VyLiBU
cmFjZXIgbmVlZHMgdG8ga2VlcCB0cmFjayBvZiB0aGUgc2VxdWVuY2Ugb2YKQEAgLTM4NywxMSAr
NDE2LDkgQEAKIHRoaXMgY2FuIHJhY2Ugd2l0aCBjb25jdXJyZW50IFNJR1NUT1BzLiBBbm90aGVy
IGNvbXBsaWNhdGlvbiBpcyB0aGF0CiB0cmFjZWUgbWF5IGVudGVyIG90aGVyIHB0cmFjZS1zdG9w
cyBhbmQgbmVlZHMgdG8gYmUgcmVzdGFydGVkIGFuZAogd2FpdGVkIGZvciBhZ2FpbiwgdW50aWwg
U0lHU1RPUCBpcyBzZWVuLiBZZXQgYW5vdGhlciBjb21wbGljYXRpb24gaXMgdG8KLWJlIHN1cmUg
dGhhdCB0cmFjZWUgaXMgbm90IGFscmVhZHkgZ3JvdXAtc3RvcHBlZCwgYmVjYXVzZSBubyBzaWdu
YWwKK2JlIHN1cmUgdGhhdCB0cmFjZWUgaXMgbm90IGFscmVhZHkgcHRyYWNlLXN0b3BwZWQsIGJl
Y2F1c2Ugbm8gc2lnbmFsCiBkZWxpdmVyeSBoYXBwZW5zIHdoaWxlIGl0IGlzIC0gbm90IGV2ZW4g
U0lHU1RPUC4KIAotPz8/IGlzIGFib3ZlIGFjY3VyYXRlPwotCiA/Pz8gRGVzY3JpYmUgaG93IHRv
IGRldGFjaCBmcm9tIGEgZ3JvdXAtc3RvcHBlZCB0cmFjZWUgc28gdGhhdCBpdAogICAgIGRvZXNu
J3QgcnVuLCBidXQgY29udGludWVzIHRvIHdhaXQgZm9yIFNJR0NPTlQuCiAK
--001485f9a7c8ea803204a47ed78a--
