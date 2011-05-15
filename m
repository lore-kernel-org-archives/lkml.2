Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1EOUfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 16:35:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36498 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1EOUfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 16:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ACAUIa63cLsYZD+OZ7NSTw3uO+lDlzuZL1ZCes4lMc2TL4CliDyaROoRRjv3JBRW42
         ykNtP5Z7o+V39i0LuY9SqoBaRr2kHcDToczamnqpbtIB+B5z69MZqwitpIDOqd/4MWbq
         5nQw5AtF938gHuNPNGDMcFWLhgEbV2MropLMo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com, oleg@redhat.com
Subject: Ptrace documentation, draft #1
Date: Sun, 15 May 2011 22:35:32 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105152235.32073.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Monday 09 May 2011 12:09, Tejun Heo wrote:
> Hmmm... I was thinking about writing a proper ptrace API doc with
> example programs under Documentation/.  It's userland visible API so
> it shouldn't change all that much and the amount of necessary
> documentation would be too much for comments.

Since I am not helping you much in kernel ptrace hacking,
I can at least help you with the docs.

Ptrace discussions repeatedly display a higher than average amount
of misunderstanding and confusion. New ptrace users and even people
who already worked with it are repeatedly confused by details
which are not documented anywhere and knowledge about which exists
mostly in the brains of strace/gdb/other_such_tools developers.

This document is meant as a brain dump of this knowledge.
It assumes that the reader has basic understanding what ptrace is.

Tejun, Oleg, Jan, please comment. If some paragraphs are unclear,
post your version of the whole paragraph(s).

I am especially interested in adding info on ptrace quirks which
I forgot or don't know yet - Jan, you must know quite a bit
of those from your gdb work.

Tejun, Oleg - "2. Linux kernel implementation" section is for you
to fill with a brain dump of kernel side of the story.

======================================================================
======================================================================
======================================================================

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
Other threads are not affected.

When any thread executes exit_group syscall, every tracee reports its
death to its tracer.

??? Is it true that *every* thread reports death?
    IIRC it isn't... one does (leader? what if there is no leader?)
    and the rest simply disappear.

Tracer cannot assume that ptrace-stopped tracee exists. There are many
scenarios when tracee may die while stopped (such as SIGKILL).
Therefore, tracer must always be prepared to handle ESRCH error on any
ptrace operation. Unfortunately, the same error is returned if tracee
exists but is not ptrace-stopped (for commands which require stopped
tracee). Tracer needs to keep track of stopped/running state, and
interpret ESRCH as "tracee died unexpectedly" only if it knows that
tracee has been observed to enter ptrace-stop.

??? is there a recommended usage of waitpid(WNOHANG) to check whether
    tracee is dead or alive?


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
-TRAP), not a special kind of ptrace-stop. If PTRACE_O_TRACEEXEC option
is in effect, a PTRACE_EVENT_EXEC-stop is generated instead.

??? can this SIGTRAP be distinguished from "real" user-generated SIGTRAP
    by looking at its siginfo?

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
0, then signal is not delivered and has no effect. Otherwise, signal
sig is delivered. This operation is called "signal injection", to
distinguish it from signal delivery which causes signal-delivery-stop.

Note that sig value may be different from WSTOPSIG(status) value -
tracer can cause a different signal to be injected. If before
restarting PTRACE_SETSIGINFO command was used to alter injected
signal's siginfo_t, si_signo field and sig parameter in restarting
command must match.

??? Are syscalls interrupted by signals which are suppressed by tracer?
    If yes, document it here

Note that restarting ptrace commands issued in ptrace-stops other than
signal-delivery-stop do NOT inject a signal, even if sig is nonzero. No
error is reported either. This is a cause of confusion among ptrace
users. One typical scenario is that tracer observes group-stop,
mistakes it for signal-delivery-stop, restarts tracee with
ptrace(PTRACE_rest, pid, 0, stopsig) with the intention of injecting
stopsig, but stopsig gets ignored and tracee continues to run.

??? TODO: there *are* some other ptrace-stops which can take sig.
    Document them.

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
dispatched to a thread which isn't thraced), group-stop will be
initiated on ALL tracees within multi-threaded process. As usual, every
tracee reports its group-stop to corresponding tracer.

Group-stop is observed by tracer as waitpid returning with the
following result: WIFSTOPPED(status) is true, WSTOPSIG(status) is the
delivered signal. The same result is returned by some other classes of
ptrace-stops, therefore the recommended practice is to perform
	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo)
call. The call can be avoided if signal number is not SIGSTOP, SIGTSTP,
SIGTTIN or SIGTTOU - only these four signals are stopping signals. If
tracer sees something else, it can't be group-stop. Otherwise, tracer
needs to call PTRACE_GETSIGINFO. If PTRACE_GETSIGINFO fails, then it is
a group-stop. If it succeeds, it's a signal-delivery-stop.

As of kernel 2.6.38, after tracer sees tracee ptrace-stop and until it
restarts or kills it, tracee will not run, and will not send
notifications (except SIGKILL death) to tracer, even if tracer enters
into another waitpid call.

Currently, it causes problem with transparent handling of stopping
signals: if tracer restarts tracee after group-stop, SIGSTOP is
effectively ignored: tracee doesn't remain stopped, it runs. If tracer
doesn't restart tracee before entering into next waitpid, future
SIGCONT will not be reported to the tracer. Which would make SIGCONT to
have no effect.

??? ...at least no effect on this tracee - how will other threads
    be affected?

	1.x.x Syscall-stops

If tracee was restarted by PTRACE_SYSCALL, tracee enters
syscall-enter-stop just prior to entering any syscall. If tracer
restarts it with PTRACE_SYSCALL, tracee enters syscall-exit-stop when
syscall is finished, or if it is interrupted by a signal. (That is,
signal-delivery-stop never happens between syscall-enter-stop and
syscall-exit-stop, it happens after syscall-exit-stop). Other
possibilities are that tracee may exit (if it entered exit or
exit_group syscall), be killed by SIGKILL, or die when other threads'
actions terminate all threads of the process (such as execve syscall).

??? how such death-because-of-other-thread is reported?

Syscall-enter-stop and syscall-exit-stop are observed by tracer as
waitpid returning with the following result: WIFSTOPPED(status) is
true, WSTOPSIG(status) == SIGTRAP. If PTRACE_O_TRACESYSGOOD option was
set by tracer, then WSTOPSIG(status) == (SIGTRAP | 0x80). Otherwise, it
is impossible to distinguish them from signal-delivery-stop with
SIGTRAP.

Syscall-enter-stop and syscall-exit-stop are indistinguishable by
tracer. Tracer needs to keep track of the sequence of ptrace-stops in
order to not misinterpret syscall-enter-stop as syscall-exit-stop or
vice versa. The rule is that syscall-enter-stop is always followed by
syscall-exit-stop or tracee's death - no other kinds of ptrace-stop can
occur in between.

??? What will happen if trace uses *NOT* PTRACE_SYSCALL to restart
    tracee after syscall-enter-stop?

??? what PTRACE_GETSIGINFO returns on syscall stops?

	1.x.x SINGLESTEP, SYSEMU, SYSEMU_SINGLESTEP

??? document PTRACE_SINGLESTEP, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP

	1.x.x PTRACE_EVENT-stops

If tracer sets TRACE_O_TRACEfoo options, tracee will enter ptrace-stops
called PTRACE_EVENT-stops.

PTRACE_EVENT-stops are observed by tracer as waitpid returning with the
following result: WIFSTOPPED(status) is true, WSTOPSIG(status) ==
SIGTRAP. Additional bit is set in a higher byte of status word: value
((status >> 8) & 0xffff) will be (SIGTRAP | PTRACE_EVENT_foo << 8).

PTRACE_EVENT_VFORK - stop after return from vfork/clone+CLONE_VFORK ???
continuing it will make it wait for child to exit/exec, right?
PTRACE_EVENT_FORK - stop after return from fork/clone+SIGCHLD
PTRACE_EVENT_CLONE - stop after return from clone
PTRACE_EVENT_VFORK_DONE - stop after vfork child unblocks this tracee
	For all four: stop occurs in parent, not in new thread;
	PTRACE_GETEVENTMSG can be used to retrieve new thread's tid.
PTRACE_EVENT_EXEC - stop after return from exec PTRACE_EVENT_EXIT -
stop before exit
	PTRACE_GETEVENTMSG returns exit status.
	Registers can be examined (unlike when "real" exit happens).
??? needs to be PTRACE_CONTed to finish exit, or not?

??? what PTRACE_GETSIGINFO returns on PTRACE_EVENT-stops?


	1.x Informational and restarting ptrace commands.

Most ptrace commands (all except ATTACH, TRACEME, KILL, SETOPTIONS)
require tracee to be in ptrace-stop, otherwise they fail with ESRCH.

When tracee is in ptrace-stop, tracer can read and write data to tracee
using informational commands. They leave tracee in ptrace-stopped state.

longv = ptrace(PTRACE_PEEKTEXT/PTRACE_PEEKDATA/PTRACE_PEEKUSER, pid,
addr, 0);
	ptrace(PTRACE_POKETEXT/PTRACE_POKEDATA/PTRACE_POKEUSER, pid,
addr, long_val);
	ptrace(PTRACE_GETREGS/PTRACE_GETFPREGS, pid, 0, &struct);
	ptrace(PTRACE_SETREGS/PTRACE_SETFPREGS, pid, 0, &struct);
	ptrace(PTRACE_GETSIGINFO, pid, 0, &siginfo);
	ptrace(PTRACE_SETSIGINFO, pid, 0, &siginfo);
	ptrace(PTRACE_GETEVENTMSG, pid, 0, &long_var);

Note that some errors are not reported. For example, setting siginfo
may have no effect in some ptrace-stops, yet the call will succeed
(return 0 and not set errno).

Another group of ptrace commands makes ptrace-stopped tracee run. They
all have the form:
	ptrace(PTRACE_cmd, pid, 0, sig);
where cmd is CONT, DETACH, SYSCALL, SINGLESTEP, SYSEMU,
SYSEMU_SINGLESTEP. If tracee is in signal-delivery-stop, sig is the
signal to be injected. Otherwise, sig is ignored.


	1.x Attaching and detaching

A thread can be attached to using ptrace(PTRACE_ATTACH, pid, 0, 0)
call. This also sends SIGSTOP to this thread. If tracer wants this
SIGSTOP to have no effect, it needs to suppress it. Note that if other
signals are concurrently sent to this thread during attach, tracer may
see tracee enter signal-delivery-stop with other signal(s) first! The
usual practice is to reinject these signals until SIGSTOP is seen, then
suppress SIGSTOP injection. The design bug here is that attach and
concurrent SIGSTOP race and SIGSTOP may be lost.

??? Is there a bug/misfeature that attaching interrupts some syscalls,
    such as nanosleep? Document it. (I guess even suppressed SIGSTOP
    causes syscall to return prematurely).

ptrace(PTRACE_TRACEME, 0, 0, 0) request turns current thread into a
tracee. It continues to run (doesn't enter ptrace-stop). A common
practice is follow ptrace(PTRACE_TRACEME) with raise(SIGSTOP) and allow
parent (which is our tracer now) to observe our signal-delivery-stop.

If PTRACE_O_TRACE[V]FORK or PTRACE_O_TRACECLONE options are in effect,
then children created by (vfork or clone(CLONE_VFORK)), (fork or
clone(SIGCHLD)) and (other kinds of clone) respectively are
automatically attached to the same tracer which traced their parent.
SIGSTOP is delivered to them, causing them to enter
signal-delivery-stop as they exit syscall which created them.

Detaching of tracee is performed by ptrace(PTRACE_DETACH, pid, 0, sig).
PTRACE_DETACH is a restarting operation, therefore it requires tracee
to be in ptrace-stop. If tracee is in signal-delivery-stop, signal can
be injected. Othervice, sig parameter is ignored.

If tracee is running when tracer wants to detach it, the usual solution
is to send SIGSTOP (using tgkill, to mkae sure it goes to the correct
thread), wait for tracee to stop in signal-delivery-stop for SIGSTOP
and then detach it (suppressing SIGSTOP injection). Design bug is that
this can race with concurrent SIGSTOPs. Another complication is that
tracee may enter other ptrace-stops and needs to be restarted and
waited for again, until SIGSTOP is seen. Yet another complication is to
be sure that tracee is not already group-stopped, because no signal
delivery happens while it is - not even SIGSTOP.

??? is above accurate?

If tracer dies, all tracees are automatically detached.

??? are they restarted if they were in some ptrace-stop?
    Even those which were in group-stop?
    Is signal injected if they were in signal-delivery-stop?


	1.x Real parent

Ptrace API (ab)uses standard Unix parent/child signaling over waitpid.
This used to cause real parent of the process to stop receiving several
kinds of waitpid notifications when child process is traced by some
other process.

Many of these bugs have been fixed, but as of 2.6.38 several still
exist.

As of 2.6.38, the following is believed to work correctly:

- exit/death by signal is reported both to tracer and to real parent.
If they are the same process, the report is sent only once.

- ??? add more docs

Following bugs still exist:

- group-stop notifications are sent to tracer, but not to real parent.

- ??? add more known bugs here



	2. Linux kernel implementation

TODO
