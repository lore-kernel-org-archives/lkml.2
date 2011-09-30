Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab1I3OOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:14:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55779 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1I3OOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 30 Sep 2011 16:14:13 +0200
Message-ID: <CAK1hOcNEBFOd1MR6L+Fdj0paAGacmrepbyPmpT_J9wBQ7bxx=Q@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: mtk.manpages@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Chuck Ebbert <76306.1226@compuserve.com>,
        Blaisorblade <blaisorblade@yahoo.it>,
        Daniel Jacobowitz <dan@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 9:08 PM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> [CC+=linux-man + a few other possibly interested individuals]
>
> Hello Denys, (Oleg, Tejun),
>
> On Thu, Jul 21, 2011 at 1:09 PM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
>> Hi Michael,
>>
>> Please apply attached patch which updates ptrace manpage.
>> (I'm not sending it inline, google web mail might mangle it. Sorry).
>
> Thanks once again for this nice piece of work. Some comments, and a
> revised page below.
>
>> Changes include:
>>
>> s/parent/tracer/g, s/child/tracee/g - ptrace interface now
>> is sufficiently cleaned up to not treat tracing process as parent.
>
> Thanks!
>
>> Deleted several outright false statements:
>> - pid 1 can be traced
>
> It looks to me as though this was once true, and I amended the page
> accordingly. (Man-pages documents not just current behavior, but
> historical behavior too.)
>
>> - tracer is not shown as parent in ps output
>
> Was this true at one time? If yes, then we should document past and
> current behavior, and note when the change occurred.

It stopped being true VERY long ago (think Linux 2.2 or even before).


>> - SIGSTOP _can_ be injected.
>
> Was this true at one time? If yes, then we should document past and
> current behavior, and note when the change occurred.
>
> In the Linux 2.4 sources, I see the following in
> arch/i386/kernel/signal.c::do_signal():
>
>                        /* The debugger continued.  Ignore SIGSTOP.  */
>                        if (signr == SIGSTOP)
>                                continue;
>
> Did that code prevent SIGSTOP being injected in the 2.4 series?

Looks like it is indeed the code.


> Rather than you writing a new patch to this version of the page, I
> think it might be easiest if you just replied to the FIXMEs inline
> below, then I can revise the page in the light of your comments.

Ok --


.\" FIXME Please check. In the following paragraphs, I substituted language
.\" such as:
.\"     Stop tracee at next fork(2) call with SIGTRAP|PTRACE_EVENT_FORK<<8
.\" with:
.\"     Stop tracee at next fork(2) call... A subsequent PTRACE_GETSIGINFO
.\"     on the stopped tracee will return a siginfo_t structure with si_code
.\"     set to SIGTRAP|PTRACE_EVENT_FORK<<8.
.\"
.\" Is this change correct?

No, it is not correct.
SIGTRAP|PTRACE_EVENT_FORK<<8 value is returned in waitpid status word.
See "PTRACE_EVENT stops" section.

No need to do PTRACE_GETSIGINFO.
Rememeber, requiring PTRACE_GETSIGINFO on every ptrace stop
is a performance hit.



.B PTRACE_ATTACH
Attach to the process specified in
.IR pid ,
making it a tracee of the calling process.
.\" FIXME So, was the following EVER true? IF it was,
.\"       we should reinstate the text and add mention of
.\"       the kernel version where the behaviour changed.
.\"
.\" Not true: (removed by dv)
.\" ; the behavior of the tracee is as if it had done a
.\" .BR PTRACE_TRACEME .
.\" The calling process actually becomes the parent of the tracee
.\" process for most purposes (e.g., it will receive
.\" notification of tracee events and appears in
.\" .BR ps (1)
.\" output as the tracee's parent), but a
.\" .BR getppid (2)
.\" by the tracee will still return the PID of the original parent.

I think it isn't true in non-ancient 2.4 and in 2.6/3.x.
Basically, it's not true for any Linux in practical use.



The tracer can't assume that the tracee
.I always
ends its life by reporting
.I WIFEXITED(status)
or
.IR WIFSIGNALED(status) .
.LP
.\"     or can it? Do we include such a promise into ptrace API?
.\"
.\" FIXME: The preceding comment seems to be unresolved?
.\"        Do you want to add anything?
.\"

I know at least one case when tracee disappears without ever reporting
WIFEXITED(status) or WIFSIGNALED(status): if thread other than
thread group leader execs, it disappears - its pid will never be seen
again, any subsequent ptrace stops will be reported under thread group
leader's pid.

Maybe this example (and all other examples we will discover later)
should be explicitly given here.



.\" FIXME: mtk: the following comment seems to be unresolved?
.\"        Do you want to add anything?
.\"
.\"     Do we require __WALL usage, or will just using 0 be ok? Are the
.\"     rules different if user wants to use waitid? Will waitid require
.\"     WEXITED?
.\"

Still not resolved. For now, I can only say that with __WALL, it works.
With 0, I am not 100% sure there aren't ugly corner cases.



.LP
.\" FIXME: Is the following comment "__WALL... implies" true?
The
.B __WALL
flag does not include the
.B WSTOPPED
and
.B WEXITED
flags, but implies their functionality.

Yes, it's true.



They may be differentiated by examining the value
.IR status>>8 ,
and if there is ambiguity in that value, by querying
.BR PTRACE_GETSIGINFO .
.\"
.\" FIXME What is the purpose of the following sentence? Is it to warn
.\"       the reader not to use WSTOPSIG()? If so, we should make that
.\"       point more explicitly.
(Note: the
.I WSTOPSIG(status)
macro returns the value
.IR "(status>>8)\ &\ 0xff)" .)

Yes. The purpose of this text is to say that WSTOPSIG() can't be used
to check for PTRACE_EVENT stops. This won't work:

    if (WSTOPSIG(status) == (SIGTRAP | (PTRACE_EVENT_foo << 8))) ...

There are no macros for this, one needs to open-code it:

    unsigned sig_and_event = status >> 8;
    if (sig_and_event == (SIGTRAP | (PTRACE_EVENT_foo << 8))) ...



If the tracer doesn't suppress the signal,
.\"
.\" FIXME: I added the word "restart" to the following line. Okay?
it passes the signal to the tracee in the next ptrace restart request.

Yes, it's ok.



.\"
.\" FIXME: the referrent of "This" in the next line is not clear.
.\"        What does "This" refer to?
This is a cause of confusion among ptrace users.
One typical scenario is that the tracer observes group-stop,
mistakes it for signal-delivery-stop, restarts the tracee with
    ptrace(PTRACE_rest, pid, 0, stopsig)
with the intention of injecting
.IR stopsig ,
but
.I stopsig
gets ignored and the tracee continues to run.

"This" refers to the ptrace behavior of ignoring 'sig' argument
on restarting ptrace commands if ptrace-stop is not a
signal-delivery-stop. The confusion even reached ptrace manpage.
The reason manpage used to claim that SIGSTOP
can't be injected is because people were trying to inject it
in the wrong ptrace-stop, which of course doesn't work.



As of kernel 2.6.38,
after the tracer sees the tracee ptrace-stop and until it
restarts or kills it, the tracee will not run,
and will not send notifications (except
.B SIGKILL
death) to the tracer, even if the tracer enters into another
.BR waitpid (2)
call.
.LP
.\"
.\" FIXME ??? referrent of "it" in the next line is unclear
.\"        What does "it" refer to?
Currently, it causes a problem with transparent handling of stopping
signals: if the tracer restarts the tracee after group-stop,
.B SIGSTOP
is effectively ignored: the tracee doesn't remain stopped, it runs.
If the tracer doesn't restart the tracee before entering into the next
.BR waitpid (2),
future
.B SIGCONT
signals will not be reported to the tracer.
This would cause
.B SIGCONT
to have no effect.

"it" refers to ptrace behavior versus group-stops and SIGCONT,
as described. Feel free to rephrase.



Syscall-stops can be distinguished from signal-delivery-stop with
.B SIGTRAP
by querying
.BR PTRACE_GETSIGINFO
for the following cases:
.TP
.IR si_code " <= 0"
.B SIGTRAP
.\" FIXME: Please confirm this is okay: I changed
.\"        "the usual suspects" to "by a system call". Okay?
.\"        Shouldn't we also add kill(2) here?
was sent by a system call
.RB ( tgkill (2),
.BR sigqueue (3),
etc.)

No, it is not ok. Please consult sigaction(2) manpage and
/usr/include/bits/siginfo.h
For example, si_code == SI_TIMER (-2) can be sent by timer
expiration, which is not a system call. There are many other signal
sources which are not systcalls.



However, syscall-stops happen very often (twice per system call),
and performing
.B PTRACE_GETSIGINFO
for every syscall-stop may be somewhat expensive.
.LP
.\"
.\" FIXME referrent of "them" in next line ???
.\"       What does "them" refer to?
Some architectures allow the cases to be distinguished
by examining registers.
For example, on x86,
.I rax
==
.RB - ENOSYS
in syscall-enter-stop.

I don't see word "them" anywhere in that line...



.\"
.\" FIXME I significantly rewrote the following sentence to try to make it
.\" clearer. Is the meaning still preserved?
The design bug here is that a ptrace attach and a concurrently delivered
.B SIGSTOP
may race and the concurrent
.B SIGSTOP
may be lost.

Yes, it looks ok.



.SS execve(2) under ptrace
.\" clone(2) THREAD_CLONE says:
.\"     If  any  of the threads in a thread group performs an execve(2),
.\"     then all threads other than the thread group leader are terminated,
.\"     and the new program is executed in the thread group leader...
.\"
.\" FIXME mtk-addition:  please check: I added the following piece to
.\"       clarify that multithreaded here means clone()+CLONE_THREAD
.\"
When one thread in a multithreaded process
(i.e., a thread group consisting of threads created using the
.BR clone (2)
.B CLONE_THREAD
flag) calls
.\" FIXME end-mtk-addition
.\"

I think this addition is not necessary. If someone reached this point
reading the documentation and he still doesn't understand what is meant
by 'multithreaded' in this context, no amount of clarification will help
that person...



.\"
.\" FIXME mtk-addition:  please check: I added the following piece:
(Or, to put things another way, when a multithreaded process does an
.BR execve (2),
the kernel makes it look as though the
.BR execve (2)
occurred in the thread group leader, regardless of which thread did the
.BR execve (2).)
.\" FIXME end-mtk-addition
.\"

This is not exactly true. If tracer is tracking syscall entry/exit
(e.g. strace),
the entry into execve will be seen happening in the execing thread,
but corresponding syscall exit will happen in thread leader.
This doesn't look exactly like "execve occurred in the thread group leader"!



All other threads stop in
.\" FIXME: mtk: What is "PTRACE_EXIT stop"?
.\"        Should that be "PTRACE_EVENT_EXIT stop"?
.B PTRACE_EXIT
stop,

Correct, it meant to be PTRACE_EVENT_EXIT



.\" FIXME: mtk: In the next line, "by active ptrace option" is unclear.
.\"        What does it mean?
if requested by active ptrace option.

It means "if PTRACE_O_TRACEEXIT option was turned on".



.\"
.\" FIXME Does "exits" in the following mean
.\" just "_exit(2)" or or both "_exit(2) and exit_group(2)"?
If a thread group leader is traced and exits by calling
.BR _exit (2),
a
.B PTRACE_EVENT_EXIT
stop will happen for it (if requested), but the subsequent
.B WIFEXITED
notification will not be delivered until all other threads exit.

Here "exits" means any kind of death - _exit, exit_group,
signal death. Signal death and exit_group cases are trivial,
though: since signal death and exit_group kill all other threads
too, "until all other threads exit" thing happens rather soon
in these cases. Therefore, only _exit presents observably
puzzling behavior to ptrace users: thread leader _exit's,
but WIFEXITED isn't reported! We are trying to explain here
why it is so.



(Note: the
.I WSTOPSIG(status)
macro returns the value
.IR "(status>>8)\ &\ 0xff)" .)

Unpaired parentheses in the fragment above.
I suggest:

.IR "((status>>8)\ &\ 0xff)" .)

-- 
vda
