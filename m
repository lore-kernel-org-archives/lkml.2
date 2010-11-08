Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0KHDwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 22:52:54 -0500
Received: from tarap.cc.columbia.edu ([128.59.29.7]:60840 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab0KHDwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 22:52:53 -0500
Message-ID: <4CD774CA.8030004@cs.columbia.edu>
Date: Sun, 07 Nov 2010 22:55:54 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Kapil Arya <kapil@ccs.neu.edu>, Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com> <4CD5DCE3.3000109@cs.columbia.edu> <20101107194222.GG31077@sundance.ccs.neu.edu> <4CD71A6B.3020905@cs.columbia.edu> <20101107230516.GJ31077@sundance.ccs.neu.edu>
In-Reply-To: <20101107230516.GJ31077@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/2010 06:05 PM, Gene Cooperman wrote:

[snip]

>>>> ... (yes, transparent means that
>>>> it does not require LD_PRELOAD or collaboration of the application!
>>>> nor does it require userspace virtualizations of so many things
>>>> already provided by the kernel today), more generic, more flexible,
>>>> provides more guarantees, cover more types or states of resources,
>>>> and can perform significantly better.
>>>
>>> I still haven't understood why you object to the DMTCP use of LD_PRELOAD.
>>> How will the user app ever know that we used LD_PRELOAD, since we remove
>>> LD_PRELOAD from the environment before the user app libraries and main
>>> can begin?  And, if you really object to LD_PRELOAD, then there are
>>> other ways to capture control.  Similarly, I'll have to understand better
>>
>> I don't object to it per se - it's actually pretty useful oftentimes.
>> But in our context, it has limitations. For example, it does not
>> cover static applications, nor apps that call syscalls directly
>> using int 0x80.
>
> For static apps, we would use other interposition techniques.  And yes,
> we haven't implemented support of static apps so far, because our
> user base hasn't asked for it.  We do handle apps that use the
> syscall system call to make system calls.  We don't handle apps
> that directly use "int 0x80".  Again, there are ways to do this, but
> our user base hasn't asked for it.
>      In general, please keep in mind the principles that you rightly had
> to remind me of in a previous post.  :-)  Our two pieces of work are coming
> from two different directions with two different visions.  Linux C/R wants
> to be so transparent that no user app can ever detect it.  DMTCP wants to be
> transparent enough that any reasonable use case is covered.

Agreed - as long as we are considering the c/r-engine functionality
(and not the "glue" logic to keep apps outside their context after
the restart).

That said, I'm afraid we'll more definitions to what is "reasonable"
than to what is "transparent"...

>      In particular, DMTCP considers distributed computations to be equally
> valid use cases for the core DMTCP C/R.  I also agree that Linux C/R can be
> extended to cover distributed apps -- either through userland extensions,
> or maybe with techniques like in your excellent CLUSTER-2005 paper.

Distributed c/r is one of the proposed use-cases for linux-cr.

The technique in that paper, BTW, was a userspace glue: during
restart, that glue re-establishes connectivity by using new TCP 
connections, and c/r uses those new sockets in lieu of restoring
the old ones.

For that and other use-cases we designed linux-cr to be flexible
so that it is possible and easy to integrate any userspace glue.

>> Also, it conflicts with LD_PRELOAD possibly needed
>> for other software (like valgrind) - for which again you would need
>> yet another per-app wrapper, at the very least.
>
> DMTCP does not conflict with the fact that valgrind uses LD_PRELOAD.
> We add dmtcphijack.so to the beginning of LD_PRELOAD before the user app
> starts.  We then remove it before the app really starts.  The LD_PRELOAD
> requests of valgrind continue to be honored.  It all works.

I stand corrected.

>>> what you mean by the _collaboration of the application_.  DMTCP operates
>>> on unmodified application binaries.
>>
>> I mean that the applications needs to be scheduled and to run to
>> participate in its own checkpoint. You use syscall interposition
>> and signals games to do exactly that - gain control over the app
>> and run your library's code. This has at least three negatives:
>> first, some apps don't want to or can't run - e.g. ptraced, or
>> swapped (think incremental checkpoint: why swap everything in ?!);
>> Second, the coordination can take significant time, especially if
>> many tasks/threads and resources are involved; Third, it modifies
>> the state of the app - if something goes wrong while you use c/r
>> to migrate an app, you impact the app.

[snip]

>      If it helps, then think of a wrapper as just another function,
> that calls an inner function.  Object-oriented programming uses this
> principle all the time.  Similarly, the glibc wrapper around a kernel
> API is just one more of these functions.  Another way to view this is
> through the idea of layers.  Each layer of the software receives a call
> from the layer above and may call to the next layer below.  As you're
> already aware, this is a basic principle of O/S design, and so
> the O/S is full of wrappers.  We're just inserting one more layer ---
> this time between the user app and the glibc layer.

Wrappers are great (I did TA the w4118 class here...). They are
a powerful tool; however in _our_ context they have downsides:
(a) wrappers add visible overhead (less so for cpu-bound apps,
more so with server apps)
(b) wrappers that do virtualization to a "black-box" API (as
opposed to integrate with the API) are prone to races (see the
paper that I cited before)
(c) wrappers duplicate kernel logic, IMHO unnecessarily (and I
don't refer to the userspace "glue" from above)
(d) wrappers are hard to make hermetic (no escapes) to apps.

IMO, the one excellent reasons to use wrappers is to support
the userspace glue that allows restarted apps to run out of
their original context.

>
> I still don't fully understand what you mean by "collaboration", but
> it sounds like your definition reduces to the the use of system call
> wrappers.  In that case, I agree that if DMTCP were not allowed to use

I clearly failed to explain well. Lemme try again:

If you use PTRACE to checkpoint, then you ptrace the target tasks,
peek at and save their state, and then let them resume execution.
The target apps need not collaborate - they are forced by the kernel
to the ptraced state regardless of what they were doing, and resume
execution without knowing what happened.

In linux-cr it works similarly: checkpoint does not require that
the processes be scheduled to run - they don't participate; rather,
external process(es) do the work.

In contrast, IIUC, dmtcp uses syscall wrappers and overloading of
signal(s) in order to make every checkpointed process/thread actively
execute the checkpoint logic. I refer to this as "collaborating"
with the checkpoint operation. (I mentioned the downside of this
requirement above).

> system call wrappers, then DMTCP would fall apart.  Aside from that
> almost tautology, I don't understand why system call wrappers are inherently
> bad.  Glibc puts system call wrappers around almost every kernel system call.
> Glibc even reserves two signals solely for its own use.

Again, I failed to deliver the message: syscall wrappers are not bad.
They have limitations as noted above. Some users won't care, others
may and do.

As for glibc - those wrappers have a set of well defined tasks,
e.g. set errno, hide underlying syscall, caching, threads etc. But
glibc does not try to virtualize pids, for example, nor "spy" after
the processes, so to speak.

>>> Basically, if _transparent_ means
>>> that one is not allowed to use anything at all from userland, then I
>>> agree with you that no userland checkpointing can ever be transparent.
>>> But, I think that's a biased definition of _transparent_.  :-)
>>
>> "Transparent" c/r means "invisible" to the user/apps, i.e. that
>> you don't restrict the user or the app in what they do and how
>> they do it.
>>
>> Did you ever try to 'ltrace skype' ?  there exists useful and
>> popular software that doesn't like being spied after...
>
> We have not tried to 'ltrace skype'.  But ltrace is using PTRACE.
> Note that DMTCP does not use PTRACE.  I imagine the more interesting question

Oh... that's not what I meant: 'ltrace skype' fails because skype
tries to protect itself from being reverse-engineered. It doesn't
like ltrace's interposition on some library calls (don't know the
details). (Note that PTRACE doesn't upset skype: 'strace skype'
does work). The point being - userspace wrapping is "escapable".

> is if we ever tried 'dmtcp_checkpoint skype'.  No, we have not, but
> it sounds like an interesting experiment.  We'd love to do it, and
> discuss with you whatever we learn.  In the offline discussion, perhaps
> we can take a shortcut and have you describe the skype tricks to us,
> so that we can give you a quick first guess.

No tricks - I once tried after a colleague mentioned that skype is
hard to reverse engineer (I thought I could prove him wrong...).

>       Anyway, there's one other obvious issue with skype for both Linux C/R
> and DMTCP.  Skype is talking to a remote app that is probably not under
> checkpoint control.

Linux-cr can do live migration - e.g. VDI, move the desktop - in
which case skype's sockets' network stacks are reconstructed,
transparently to both skype (local apps) and the peer (remote apps).
Then, at the destination host and skype continues to work.

> And even if both ends are under checkpoint control,
> Skype is probably not a good use case for C/R, but if it were, it might
> indeed be a difficult problem.  (I'd have to think about it.)
>      As before, remember that we are talking about two different approaches:
> - in-kernel C/R and capturing every possible application;
> - userland C/R and covering the actual use cases that one finds in practice

I'd assume that if the c/r engine can do the former, then it
will also do the latter. Maybe even it would be useful for dmtcp
to be able to use a couple of syscalls (checkpoint,restart) to
do the base c/r work  :p

Oren.
