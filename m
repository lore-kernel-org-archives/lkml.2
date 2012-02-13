Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2BMWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:03:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48429 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2BMWDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:03:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgNAkj8tjBk1mXO6WhwUyeZDrRC5ECzHXLzPQ0PCpbr34D4_A@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <CAKgNAkicbgpSLZE6Wn_5ickGojJuGd4x2vMUG0491OB+O1Z_HA@mail.gmail.com>
 <CAK1hOcNEBFOd1MR6L+Fdj0paAGacmrepbyPmpT_J9wBQ7bxx=Q@mail.gmail.com> <CAKgNAkj8tjBk1mXO6WhwUyeZDrRC5ECzHXLzPQ0PCpbr34D4_A@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 13 Feb 2012 23:02:45 +0100
Message-ID: <CAK1hOcMEWnCysL1HRe+Z3Qfxg9+=tcY6YKWor7_bymNkPVSL+A@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: mtk.manpages@gmail.com
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

On Mon, Oct 3, 2011 at 7:27 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> Thanks for the detailed responses. Some comments to your remarks
> below, and a couple of open questions (marked "????"). If you send me
> the answers, then I can get another draft for review.
>
>>>> - SIGSTOP _can_ be injected.
>>>
>>> Was this true at one time? If yes, then we should document past and
>>> current behavior, and note when the change occurred.
>>>
>>> In the Linux 2.4 sources, I see the following in
>>> arch/i386/kernel/signal.c::do_signal():
>>>
>>>                        /* The debugger continued.  Ignore SIGSTOP.  */
>>>                        if (signr == SIGSTOP)
>>>                                continue;
>>>
>>> Did that code prevent SIGSTOP being injected in the 2.4 series?
>>
>> Looks like it is indeed the code.
>
> ????
> Sorry -- I'm not quite clear there. You're confirming that SIGSTOP
> could not be injected in 2.4, right?

Yes. In 2.4, SIGSTOP can't be injected.



>> No need to do PTRACE_GETSIGINFO.
>> Remember, requiring PTRACE_GETSIGINFO on every ptrace stop
>> is a performance hit.
>
> Thanks. So I'll change that sentence (and the others):
>
> A subsequent PTRACE_GETSIGINFO on the stopped tracee will return a
> siginfo_t structure with si_code set to SIGTRAP|PTRACE_EVENT_FORK<<8.
>
> to:
>
> A waitpid() by the tracer will return SIGTRAP|PTRACE_EVENT_FORK<<8 as
> the status of the tracee.

Word "status" above is ambiguous. Is it waitpid status?
Is it si_code field in PTRACE_GETSIGINFO result?
We probably need to be ridiculously verbose here
to avoid confusion:

"A waitpid() by the tracer will return status value which
will have SIGTRAP | (PTRACE_EVENT_FORK << 8) in its
most significant 24 bits. IOW: (status >> 8) will be equal to
SIGTRAP | (PTRACE_EVENT_FORK << 8)."




>> As of kernel 2.6.38,
>> after the tracer sees the tracee ptrace-stop and until it
>> restarts or kills it, the tracee will not run,
>> and will not send notifications (except
>> .B SIGKILL
>> death) to the tracer, even if the tracer enters into another
>> .BR waitpid (2)
>> call.
>> .LP
>> .\"
>> .\" FIXME ??? referrent of "it" in the next line is unclear
>> .\"        What does "it" refer to?
>> Currently, it causes a problem with transparent handling of stopping
>> signals: if the tracer restarts the tracee after group-stop,
>> .B SIGSTOP
>> is effectively ignored: the tracee doesn't remain stopped, it runs.
>> If the tracer doesn't restart the tracee before entering into the next
>> .BR waitpid (2),
>> future
>> .B SIGCONT
>> signals will not be reported to the tracer.
>> This would cause
>> .B SIGCONT
>> to have no effect.
>>
>> "it" refers to ptrace behavior versus group-stops and SIGCONT,
>> as described. Feel free to rephrase.
>
> ????
> Help! I'm still having problems here. The problem may possibly be
> this: when one uses a pronoun like "it" in English, it's normally a
> back reference to some text already given. Is this "it" a back
> reference (In that case, could you please send me a rewritten version
> of the sentence that replaces "it" by some descriptive text), or is it
> a reference to the current paragraph (in other words, should this
> paragraph rather start with the words "Currently, here is a problem
> with...")?

I think replacing "it" with "this kernel behavior" will do:

"Currently, this kernel behavior causes a problem with transparent
handling of stopping signals: if the tracer restarts the tracee
after group-stop, the stopping signal is effectively ignored:
the tracee doesn't remain stopped, it runs. ..."

(^^^^^^ also, replaced SIGSTOP with "the stopping signal" -
all stopping signals are equally affected).


>> No, it is not ok. Please consult sigaction(2) manpage and
>> /usr/include/bits/siginfo.h
>> For example, si_code == SI_TIMER (-2) can be sent by timer
>> expiration, which is not a system call. There are many other signal
>> sources which are not systcalls.
>
> Okay. So how about the following:
>
> was delivered as a result of a userspace action,
> for example, a direct system call
> .RB ( tgkill (2),
> .BR kill (2),
> .BR sigqueue (3),
> etc.),
> expiration of a POSIX timer,
> change of state on a POSIX message queue,
> or completion of an asynchronous I/O request.

Yes, this looks ok.



-- 
vda
