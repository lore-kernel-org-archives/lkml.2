Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2BZSZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 13:25:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2BZSZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 13:25:41 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAK1hOcMEWnCysL1HRe+Z3Qfxg9+=tcY6YKWor7_bymNkPVSL+A@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com>
 <CAK1hOcNEBFOd1MR6L+Fdj0paAGacmrepbyPmpT_J9wBQ7bxx=Q@mail.gmail.com>
 <CAKgNAkj8tjBk1mXO6WhwUyeZDrRC5ECzHXLzPQ0PCpbr34D4_A@mail.gmail.com> <CAK1hOcMEWnCysL1HRe+Z3Qfxg9+=tcY6YKWor7_bymNkPVSL+A@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 27 Feb 2012 07:25:20 +1300
Message-ID: <CAKgNAkiyR7v=q0WTr+sQEsYE57z_j-C3+3n3ABZT+5HjJoc9fw@mail.gmail.com>
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

 Hello Denys,

Thanks for these comments.

On Tue, Feb 14, 2012 at 11:02 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Mon, Oct 3, 2011 at 7:27 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>> Thanks for the detailed responses. Some comments to your remarks
>> below, and a couple of open questions (marked "????"). If you send me
>> the answers, then I can get another draft for review.
>>
>>>>> - SIGSTOP _can_ be injected.
>>>>
>>>> Was this true at one time? If yes, then we should document past and
>>>> current behavior, and note when the change occurred.
>>>>
>>>> In the Linux 2.4 sources, I see the following in
>>>> arch/i386/kernel/signal.c::do_signal():
>>>>
>>>>                        /* The debugger continued.  Ignore SIGSTOP.  */
>>>>                        if (signr == SIGSTOP)
>>>>                                continue;
>>>>
>>>> Did that code prevent SIGSTOP being injected in the 2.4 series?
>>>
>>> Looks like it is indeed the code.
>>
>> ????
>> Sorry -- I'm not quite clear there. You're confirming that SIGSTOP
>> could not be injected in 2.4, right?
>
> Yes. In 2.4, SIGSTOP can't be injected.

Okay -- I added some words to (what I hope is) an appropriate place in
the page. Can you please check this in the next draft.

>>> No need to do PTRACE_GETSIGINFO.
>>> Remember, requiring PTRACE_GETSIGINFO on every ptrace stop
>>> is a performance hit.
>>
>> Thanks. So I'll change that sentence (and the others):
>>
>> A subsequent PTRACE_GETSIGINFO on the stopped tracee will return a
>> siginfo_t structure with si_code set to SIGTRAP|PTRACE_EVENT_FORK<<8.
>>
>> to:
>>
>> A waitpid() by the tracer will return SIGTRAP|PTRACE_EVENT_FORK<<8 as
>> the status of the tracee.
>
> Word "status" above is ambiguous. Is it waitpid status?
> Is it si_code field in PTRACE_GETSIGINFO result?
> We probably need to be ridiculously verbose here
> to avoid confusion:
>
> "A waitpid() by the tracer will return status value which
> will have SIGTRAP | (PTRACE_EVENT_FORK << 8) in its
> most significant 24 bits. IOW: (status >> 8) will be equal to
> SIGTRAP | (PTRACE_EVENT_FORK << 8)."


That's a bit repetitious, so I simplified to sentences of the form:

A waitpid(2) by the tracer will return a status value such that

      status>>8 == (SIGTRAP | (PTRACE_EVENT_FORK<<8))

>>> As of kernel 2.6.38,
>>> after the tracer sees the tracee ptrace-stop and until it
>>> restarts or kills it, the tracee will not run,
>>> and will not send notifications (except
>>> .B SIGKILL
>>> death) to the tracer, even if the tracer enters into another
>>> .BR waitpid (2)
>>> call.
>>> .LP
>>> .\"
>>> .\" FIXME ??? referrent of "it" in the next line is unclear
>>> .\"        What does "it" refer to?
>>> Currently, it causes a problem with transparent handling of stopping
>>> signals: if the tracer restarts the tracee after group-stop,
>>> .B SIGSTOP
>>> is effectively ignored: the tracee doesn't remain stopped, it runs.
>>> If the tracer doesn't restart the tracee before entering into the next
>>> .BR waitpid (2),
>>> future
>>> .B SIGCONT
>>> signals will not be reported to the tracer.
>>> This would cause
>>> .B SIGCONT
>>> to have no effect.
>>>
>>> "it" refers to ptrace behavior versus group-stops and SIGCONT,
>>> as described. Feel free to rephrase.
>>
>> ????
>> Help! I'm still having problems here. The problem may possibly be
>> this: when one uses a pronoun like "it" in English, it's normally a
>> back reference to some text already given. Is this "it" a back
>> reference (In that case, could you please send me a rewritten version
>> of the sentence that replaces "it" by some descriptive text), or is it
>> a reference to the current paragraph (in other words, should this
>> paragraph rather start with the words "Currently, here is a problem
>> with...")?
>
> I think replacing "it" with "this kernel behavior" will do:

That helps, but still it's a bit unclear. I'll leave you a question in
the next draft.

> "Currently, this kernel behavior causes a problem with transparent
> handling of stopping signals: if the tracer restarts the tracee
> after group-stop, the stopping signal is effectively ignored:
> the tracee doesn't remain stopped, it runs. ..."
>
> (^^^^^^ also, replaced SIGSTOP with "the stopping signal" -
> all stopping signals are equally affected).

Okay -- I made that change also.

>>> No, it is not ok. Please consult sigaction(2) manpage and
>>> /usr/include/bits/siginfo.h
>>> For example, si_code == SI_TIMER (-2) can be sent by timer
>>> expiration, which is not a system call. There are many other signal
>>> sources which are not systcalls.
>>
>> Okay. So how about the following:
>>
>> was delivered as a result of a userspace action,
>> for example, a direct system call
>> .RB ( tgkill (2),
>> .BR kill (2),
>> .BR sigqueue (3),
>> etc.),
>> expiration of a POSIX timer,
>> change of state on a POSIX message queue,
>> or completion of an asynchronous I/O request.
>
> Yes, this looks ok.

Good.

I will shortly send you another draft for review.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
