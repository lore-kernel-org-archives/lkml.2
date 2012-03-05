Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2CEReP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:34:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40715 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab2CEReG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:34:06 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <201202270158.09878.vda.linux@googlemail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <CAKgNAkiyR7v=q0WTr+sQEsYE57z_j-C3+3n3ABZT+5HjJoc9fw@mail.gmail.com>
 <CAKgNAkhZT=cGfAvenQpc7zLSzk6SPrKN_8FDLahK2QkKv3uhrA@mail.gmail.com> <201202270158.09878.vda.linux@googlemail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 6 Mar 2012 06:33:45 +1300
Message-ID: <CAKgNAkhhrpjv9yjCPrkaGCjAocvyXm+9ZubE0Zhg0W_ZtQ_fNw@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Blaisorblade <blaisorblade@yahoo.it>,
        Daniel Jacobowitz <dan@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

On Mon, Feb 27, 2012 at 1:58 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Sunday 26 February 2012 19:42, Michael Kerrisk wrote:
>> Hello Denys,
>>
>> Below is another iteration of the ptrace.2 page with your new
>> material. Could you please take a look at the page in general, and the
>> FIXMEs in particular? (I'd like to get specific input from you on all
>> of the FIXMEs, if possible.)
>>
>> Thanks,
>>
>> Michael
>
> ...
> ...
>
>> As for
>> .BR PTRACE_PEEKUSER ,
>> the offset must typically be word-aligned.
>> In order to maintain the integrity of the kernel,
>> some modifications to the USER area are disallowed.
>> .\" FIXME In the preceding sentence, which modifications are disallowed,
>> .\" and when they are disallowed, how does userspace discover that fact?
> ...
>> As for
>> .BR PTRACE_POKEUSER ,
>> some general purpose register modifications may be disallowed.
>> .\" FIXME In the preceding sentence, which modifications are disallowed,
>> .\" and when they are disallowed, how does userspace discover that fact?
>
> I don't know the answer to this question.

Okay -- I'll just leave the FIXME there for future reference.

>> Use of the
>> .B WNOHANG
>> flag may cause
>> .BR waitpid (2)
>> to return 0 ("no wait results available yet")
>> even if the tracer knows there should be a notification.
>> Example:
>> .nf
>>
>>     kill(tracee, SIGKILL);
>>     waitpid(tracee, &status, __WALL | WNOHANG);
>> .fi
>> .\" FIXME: mtk: the following comment seems to be unresolved?
>> .\"        Do you want to add anything?
>> .\"
>> .\"     waitid usage? WNOWAIT?
>> .\"     describe how wait notifications queue (or not queue)
>
> I did not experiment with waitid and WNOWAIT flag yet.

Okay -- I'll just leave the FIXME there for future reference.

>> .LP
>> The following kinds of ptrace-stops exist: signal-delivery-stops,
>> group-stop, PTRACE_EVENT stops, syscall-stops
>> .\"
>> .\" FIXME: mtk: the following text ("[, PTRACE_SINGLESTEP...") is incomplete.
>> .\"        Do you want to add anything?
>> .\"
>> [, PTRACE_SINGLESTEP, PTRACE_SYSEMU,
>> PTRACE_SYSEMU_SINGLESTEP].
>
> I am not familiar enough with these ptrace commands, can't add anything useful.
> You can just remove the [...] part for now.

Actually, I think I'll leave it in. See below.

>> As of kernel 2.6.38,
>> after the tracer sees the tracee ptrace-stop and until it
>> restarts or kills it, the tracee will not run,
>> and will not send notifications (except
>> .B SIGKILL
>> death) to the tracer, even if the tracer enters into another
>> .BR waitpid (2)
>> call.
>> .LP
>> .\" FIXME It is unclear what "this kernel behavior" refers to.
>> .\" Can show me exactly which piece of text above or below is
>> .\" referred to when you say "this kernel behavior"?
>> Currently, this kernel behavior
>> causes a problem with transparent handling of stopping signals:
>> if the tracer restarts the tracee after group-stop,
>> the stopping signal
>> is effectively ignored\(emthe tracee doesn't remain stopped, it runs.
>> If the tracer doesn't restart the tracee before entering into the next
>> .BR waitpid (2),
>> future
>> .B SIGCONT
>> signals will not be reported to the tracer.
>> This would cause
>> .B SIGCONT
>> to have no effect.
>
> You seem to be asking this question repeatedly. I tried to give you
> the answer several times. I don't know what is unclear here.
>
> Ok, I will try to explain it yet again.
>
> Let's say a tracee receives stopping signal and stops.
> Tracer sees this stop via waitpid() status.
> It determines that it is a group-stop.
>
> After this, tracer has two options: (2) execute ptrace(PTRACE_CONT)
> on the tracee before going back to waitpid'ing, or (2) don't
> do ptrace(PTRACE_CONT), and go back to waitpid'ing.
>
> Both options are bad: in option (1), tracee will start running -
> in effect, making stop signal to not have intended effect.
> In option (2), tracee will be stopped FOREVER - SIGCONT won't be able
> to start it again.

Okay -- as discussed in a chat. I think the main point to bring out
here is that "This kernel behavior" means "The kernel behavior
described in the previous paragraph". I'll reword to make that clear.


>> Currently, this kernel behavior
>> causes a problem with transparent handling of stopping signals:
>> if the tracer restarts the tracee after group-stop,
>> the stopping signal
>> is effectively ignored
>
> I am not a native English speaker. Please rephrase
> this text fragment so that it sounds understandable to you.
> I would agree to any version of it by now.

Done.

>> But such detection is fragile and is best avoided.
>> .LP
>> Using the
>> .B PTRACE_O_TRACESYSGOOD
>> .\"
>> .\" FIXME Below: "is the recommended method" for WHAT?
>> option is the recommended method,
>> since it is reliable and does not incur a performance penalty.
>
> It is the recommended method to distinquish syscall-stops
> from other kinds of ptrace-stops.

Okay -- I added those words.

>> If after syscall-enter-stop,
>> the tracer uses a restarting command other than
>> .BR PTRACE_SYSCALL ,
>> syscall-exit-stop is not generated.
>> .LP
>> .B PTRACE_GETSIGINFO
>> on syscall-stops returns
>> .B SIGTRAP
>> in
>> .IR si_signo ,
>> with
>> .I si_code
>> set to
>> .B SIGTRAP
>> or
>> .IR (SIGTRAP|0x80) .
>> .SS PTRACE_SINGLESTEP, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP stops
>> .\"
>> .\" FIXME The following TODO is unresolved
>> .\"       Do you want to add anything, or (less good) do we just
>> .\"       convert this into a comment in the source indicating
>> .\"       that these points still need to be documented?
>> .\"
>> (TODO: document stops occurring with PTRACE_SINGLESTEP, PTRACE_SYSEMU,
>> PTRACE_SYSEMU_SINGLESTEP)
>
> I am not familiar enough with these ptrace commands, can't add anything useful.
> You can just remove the (...) part for now.

In fact, I think I'll leave a piece of text here in the man page to
note that these stops exists, but are not yet documented.


>> The design bug here is that a ptrace attach and a concurrently delivered
>> .B SIGSTOP
>> may race and the concurrent
>> .B SIGSTOP
>> may be lost.
>> .\"
>> .\" FIXME: mtk: the following comment seems to be unresolved?
>> .\"      Do you want to add any text?
>> .\"
>> .\"      Describe how to attach to a thread which is already group-stopped.
>
> No, I don't have anything useful to add here right now.

Okay -- I'll just leave the FIXME there for future reference.

>> Another complication is that the tracee may enter other ptrace-stops
>> and needs to be restarted and waited for again, until
>> .B SIGSTOP
>> is seen.
>> Yet another complication is to be sure that
>> the tracee is not already ptrace-stopped,
>> because no signal delivery happens while it is\(emnot even
>> .BR SIGSTOP .
>> .\" FIXME: mtk: the following comment seems to be unresolved?
>> .\"       Do you want to add anything?
>> .\"
>> .\"     Describe how to detach from a group-stopped tracee so that it
>> .\"     doesn't run, but continues to wait for SIGCONT.
>
> No, I don't have anything useful to add here right now.

Okay -- I'll just leave the FIXME there for future reference.

>> If the tracer dies, all tracees are automatically detached and restarted,
>> unless they were in group-stop.
>> Handling of restart from group-stop is
>> .\" FIXME: Define currently
>> currently buggy, but the
>> .\" FIXME: Planned for when? And should applications be designed
>> .\" in some way so as to allow for this future change?
>> "as planned" behavior is to leave tracee stopped and waiting for
>> .BR SIGCONT .
>
> It means that current kernels are known to have bugs in this area:
> if tracer exits, group-stopped tracees may start running.

Okay.

>> Then a
>> .B PTRACE_EVENT_EXEC
>> stop happens, if the
>> .BR PTRACE_O_TRACEEXEC
>> option was turned on.
>> .\" FIXME: mtk: the following comment seems to be unresolved?
>> .\"       (on which tracee - leader? execve-ing one?)
>
> At this point, pid change has already occurred.
> Currently, rendered manpage looks like this:
>
> *  All   other   threads   stop   in  PTRACE_EVENT_EXIT  stop,  if  the
>   PTRACE_O_TRACEEXIT option was turned on.   Then  all  other  threads
>   except  the  thread  group leader report death as if they exited via
>   _exit(2) with exit code 0.  Then a PTRACE_EVENT_EXEC  stop  happens,
>   if the PTRACE_O_TRACEEXEC option was turned on.
>
> *  The  execing  tracee  changes  its  thread  ID  while  it  is in the
>   execve(2).  (Remember, under ptrace, the "pid" returned  from  wait-
>   pid(2),  or fed into ptrace calls, is the tracee's thread ID.)  That
>   is, the tracee's thread ID is reset to be the same  as  its  process
>   ID, which is the same as the thread group leader's thread ID.
>
> *  If  the  thread group leader has reported its death by this time...
>
>
> I suggest creating a new bullet point after the second one,
> and moving "Then a PTRACE_EVENT_EXEC stop happens, if the
> PTRACE_O_TRACEEXEC option was turned on" text into it.
>
> This will clearly indicate that by this time, pid has changed.

Done.

> There is a bit of text below:
>
>> The thread ID change happens before
>> .B PTRACE_EVENT_EXEC
>> stop, not after.
>
> which will be made redundant by the above change and can be deleted.

I deleted it.


>> .\" FIXME: Please check: at various places in the following,
>> .\"        I have changed "pid" to "[the tracee's] thead ID"
>> .\"        Is that okay?
>> .IP *
>> The execing tracee changes its thread ID while it is in the
>> .BR execve (2).
>> (Remember, under ptrace, the "pid" returned from
>> .BR waitpid (2),
>> or fed into ptrace calls, is the tracee's thread ID.)
>> That is, the tracee's thread ID is reset to be the same as its process ID,
>> which is the same as the thread group leader's thread ID.
>
> Yes, the text look ok to me.

Okay.

>> The
>> .B PTRACE_O_TRACEEXEC
>> option is the recommended tool for dealing with this situation.
>> It enables
>> .B PTRACE_EVENT_EXEC
>> stop, which occurs before
>> .BR execve (2)
>> returns.
>> .\" FIXME Following on from the previous sentences,
>> .\"       can/should we add a few more words on how
>> .\"       PTRACE_EVENT_EXEC stop helps us deal with this situation?
>> .LP
>
> I propose the following text:
>
> The PTRACE_O_TRACEEXEC option is the recommended tool for dealing with
> this situation. First, it enables PTRACE_EVENT_EXEC stop, which occurs
> before execve(2) returns. In this stop, tracer can use
> ptrace(PTRACE_GETEVENTMSG) call to retrieve the tracee's former thread ID.
> (This feature was introduced in Linux 3.0).
> Second, PTRACE_O_TRACEEXEC option disables legacy SIGTRAP generation
> on execve.

Thanks. I added that text.

>> As of Linux 2.6.38, the following is believed to work correctly:
>> .IP * 3
>> exit/death by signal is reported first to the tracer, then,
>> when the tracer consumes the
>> .BR waitpid (2)
>> result, to the real parent (to the real parent only when the
>> whole multithreaded process exits).
>> .\"
>> .\" FIXME mtk: Please check: In the next line,
>> .\" I changed "they" to "the tracer and the real parent". Okay?
>> If the tracer and the real parent are the same process,
>> the report is sent only once.
>
> Yes, this change is ok.

Thanks.

>> .B EPERM
>> The specified process cannot be traced.
>> This could be because the
>> tracer has insufficient privileges (the required capability is
>> .BR CAP_SYS_PTRACE );
>> unprivileged processes cannot trace processes that they
>> cannot send signals to or those running
>> set-user-ID/set-group-ID programs, for obvious reasons.
>> .\"
>> .\" FIXME I reworked the discussion of init below to note
>> .\" the kernel version (2.6.26) when the behavior changed for
>> .\" tracing init(8). Okay?
>> Alternatively, the process may already be being traced,
>> or (on kernels before 2.6.26) be
>> .BR init (8)
>> (PID 1).
>
> Yes, this change is ok.

Thanks.

>> glibc currently declares
>> .BR ptrace ()
>> as a variadic function with only the
>> .I request
>> argument fixed.
>> This means that unneeded trailing arguments may be omitted,
>> though doing so makes use of undocumented
>> .BR gcc (1)
>> behavior.
>> .\" FIXME Please review. I reinstated the following, noting the
>> .\" kernel version number where it ceased to be true
>> .LP
>> In Linux kernels before 2.6.26,
>> .\" See commit 00cd5c37afd5f431ac186dd131705048c0a11fdb
>> .BR init (8),
>> the process with PID 1, may not be traced.
>
> Yes, this change is ok.

Thanks.

>> .\" FIXME So, can we just remove the following text (rather than
>> .\" just commenting it out)?
>> .\"
>> .\" Covered in more details above: (removed by dv)
>> .\" .LP
>> .\" Tracing causes a few subtle differences in the semantics of
>> .\" traced processes.
>> .\" For example, if a process is attached to with
>> .\" .BR PTRACE_ATTACH ,
>> .\" its original parent can no longer receive notification via
>> .\" .BR waitpid (2)
>> .\" when it stops, and there is no way for the new parent to
>> .\" effectively simulate this notification.
>> .\" .LP
>> .\" When the parent receives an event with
>> .\" .B PTRACE_EVENT_*
>> .\" set,
>> .\" the tracee is not in the normal signal delivery path.
>> .\" This means the parent cannot do
>> .\" .BR ptrace (PTRACE_CONT)
>> .\" with a signal or
>> .\" .BR ptrace (PTRACE_KILL).
>> .\" .BR kill (2)
>> .\" with a
>> .\" .B SIGKILL
>> .\" signal can be used instead to kill the tracee
>> .\" after receiving one of these messages.
>> .\" .LP
>
> Yes, let's remove this comment.

Done.

>> If a thread group leader is traced and exits by calling
>> .BR _exit (2),
>> .\" Note from Denys Vlasenko:
>> .\"     Here "exits" means any kind of death - _exit, exit_group,
>> .\"     signal death. Signal death and exit_group cases are trivial,
>> .\"     though: since signal death and exit_group kill all other threads
>> .\"     too, "until all other threads exit" thing happens rather soon
>> .\"     in these cases. Therefore, only _exit presents observably
>> .\"     puzzling behavior to ptrace users: thread leader _exit's,
>> .\"     but WIFEXITED isn't reported! We are trying to explain here
>> .\"     why it is so.
>> a
>> .B PTRACE_EVENT_EXIT
>> stop will happen for it (if requested), but the subsequent
>> .B WIFEXITED
>> notification will not be delivered until all other threads exit.
>> As explained above, if one of other threads calls
>> .BR execve (2),
>> the death of the thread group leader will
>> .I never
>> be reported.
>> If the execed thread is not traced by this tracer,
>> the tracer will never know that
>> .BR execve (2)
>> happened.
>> One possible workaround is to
>> .B PTRACE_DETACH
>> the thread group leader instead of restarting it in this case.
>> Last confirmed on 2.6.38.6.
>> .\"        ^^^ need to test/verify this scenario
>> .\" FIXME: mtk: the preceding comment seems to be unresolved?
>> .\"        Do you want to add anything?
>
> No, I don't have anything useful to add here right now.

Okay -- I'll just leave the FIXME there for future reference.

So, I think this update is ready to go into the next man-pages
release. Thanks for all of this work Denys. It's a great improvement
to the page.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
