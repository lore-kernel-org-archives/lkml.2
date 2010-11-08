Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0KHQ0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:26:42 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:51576 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0KHQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:26:41 -0500
Date: Mon, 8 Nov 2010 11:26:30 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101108162630.GN31077@sundance.ccs.neu.edu>
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
 <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
 <4CD5DCE3.3000109@cs.columbia.edu>
 <20101107194222.GG31077@sundance.ccs.neu.edu>
 <4CD71A6B.3020905@cs.columbia.edu>
 <20101107230516.GJ31077@sundance.ccs.neu.edu>
 <4CD774CA.8030004@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD774CA.8030004@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As before, Oren, let's have that phone discussion so that we can preprocess
a lot of this, instead of acting like the the three blind men and the
elephant.  I will _tell you_ the strengths and weaknesses of DMTCP
on the phone, instead of you having to guess at them here on LKML.  And
of course, I hope you will be similarly frank about Linux C/R on the phone.

Thank you for lowering the heat on this last post.  I'll reply only to
some relevant issues in this post, rather than trying to respond to all
of your posts.  I remind you that I still have my own questions about
Linux C/R, but I'm saving them for the phone discussion, since that will
be more efficient, and result in less heat.

> >     If it helps, then think of a wrapper as just another function,
> >that calls an inner function.  Object-oriented programming uses this
> >principle all the time.  Similarly, the glibc wrapper around a kernel
> >API is just one more of these functions.  Another way to view this is
> >through the idea of layers.  Each layer of the software receives a call
> >from the layer above and may call to the next layer below.  As you're
> >already aware, this is a basic principle of O/S design, and so
> >the O/S is full of wrappers.  We're just inserting one more layer ---
> >this time between the user app and the glibc layer.
> 
> Wrappers are great (I did TA the w4118 class here...). They are
> a powerful tool; however in _our_ context they have downsides:
> (a) wrappers add visible overhead (less so for cpu-bound apps,
> more so with server apps)

In our experience, the primary overhead of C/R is to save the
data to disk.  This far outweighs the question of how many ms
one technique or another may require in a system call or in the kernel.

> (b) wrappers that do virtualization to a "black-box" API (as
> opposed to integrate with the API) are prone to races (see the
> paper that I cited before)

The paper you cited was:
  http://www.stanford.edu/~talg/papers/traps/abstract.html
  Traps and Pitfalls: Practical Problems in System Call
     Interposition Based Security Tools
  That paper is about Sandboxing.  DMTCP is about C/R.  If DMTCP was trying
to do a sandbox, it might have some of the same traps and pitfalls.
Luckily, userland C/R is a _lot_ easier than userland sandboxing.
By the way, although of less importance, I'll point out that the paper
was written in 2003, before DMTCP even started.
    Next, you talk about races.  The authors of that paper have races
because they are trying to do sandboxing.  I already answered Matt's
post earlier about why we don't see races in DMTCP.
I'll answer it again, but in more detail.
    At ordinary run-time, the DMTCP checkpoint thread is just waiting
on a select -- waiting for instructions from the DMTCP coordinator.
Our system call wrappers around user threads to not change the issue
of races.  If two user threads used to have a race, they will continue
to do so in DMTCP.  If two user threads did not have a race, then
DMTCP will not introduce any new races.  How should DMTCP introduce
a new race when DMTCP wrappers _never_ communicate with any other thread.
    At checkpoint or restart time, the DMTCP checkpoint thread also runs.
However, at checkpoint time, the first thing it does is to quiesce
all the user threads by sending a signal and forcing them into a DMTCP
signal handler.  (And before we go down that other road again, I remind
you that glibc also reserves two signals solely for the use of glibc.
A user app can break glibc by using the glibc reserved signals.)
During checkpoint-restart, the DMTCP checkpoint thread is then the
_only_ thread that is executing.  So, again, I don't see how a race
could be introduced.  Finally, the last thing the DMTCP checkpoint
thread does is resume the user threads.  The DMTCP checkpoint thread
then goes back to waiting on select for a message from the DMTCP coordinator.

> (c) wrappers duplicate kernel logic, IMHO unnecessarily (and I
> don't refer to the userspace "glue" from above)

DMTCP wrappers do not duplicate kernel logic.  In our phone conversation,
I will show you each and every one of the DMTCP wrappers.  I've already
posted for the entire list where they can find the DMTCP wrappers.
I honestly don't see any duplication of kernel logic.  If you do see this,
please tell us which DMTCP wrapper is duplicating the kernel logic, so
that we can talk about specifics.  But please, can we review the DMTCP
code offline?  A code review within LKML seems _awfully_ tedious.  :-)

> (d) wrappers are hard to make hermetic (no escapes) to apps.

In general, we don't try to make all the DMTCP wrappers hermetic.
Your mindset may be influenced by the sandboxing paper above.
But again, we're not doing sandboxing.  We're doing C/R.
    If you're using "hermetic" as a placeholder for what we call
"pid virtualization" (a translation table between original and current
pid), then yes:  for every system call that takes a pid as an argument
or returns a pid, we must add a wrapper.  That is not a difficult task.
Let's do a code review of DMTCP together (on the phone) to look for a "leak"
in the DMTCP pid's.  I do think this is a lot easier and less
complex to do than to guard against all resource leaks in a container.  :-)
(Sorry, I know that's a cheap shot on my part.  I'm getting tired
of overly broad statements, without the opportunity for us to do a code
review or preprocess the issues back and forth on the phone.)
 
> IMO, the one excellent reasons to use wrappers is to support
> the userspace glue that allows restarted apps to run out of
> their original context.

> 
> >
> >I still don't fully understand what you mean by "collaboration", but
> >it sounds like your definition reduces to the the use of system call
> >wrappers.  In that case, I agree that if DMTCP were not allowed to use
> 
> I clearly failed to explain well. Lemme try again:
> 
> If you use PTRACE to checkpoint, then you ptrace the target tasks,
> peek at and save their state, and then let them resume execution.
> The target apps need not collaborate - they are forced by the kernel
> to the ptraced state regardless of what they were doing, and resume
> execution without knowing what happened.
> 
> In linux-cr it works similarly: checkpoint does not require that
> the processes be scheduled to run - they don't participate; rather,
> external process(es) do the work.
> 
> In contrast, IIUC, dmtcp uses syscall wrappers and overloading of
> signal(s) in order to make every checkpointed process/thread actively
> execute the checkpoint logic. I refer to this as "collaborating"
> with the checkpoint operation. (I mentioned the downside of this
> requirement above).

Again, a correction.  DMTCP does _not_ overload signals.  It uses
a signal not already used by the app.  If the app tries to "zero out"
all signals, then DMTCP protects itself through wrappers (or what
you would call "lying", although I dislike these emotionally
loaded phrases).  Glibc also uses dedicated signals.
    Concerning "collaboration", when gdb inserts a breakpoint, it modifies
the user code.  So, even though gdb uses PTRACE, by your definition,
the gdb use of breakpoints relies on "collaboration".

> >system call wrappers, then DMTCP would fall apart.  Aside from that
> >almost tautology, I don't understand why system call wrappers are inherently
> >bad.  Glibc puts system call wrappers around almost every kernel system call.
> >Glibc even reserves two signals solely for its own use.
> 
> Again, I failed to deliver the message: syscall wrappers are not bad.
> They have limitations as noted above. Some users won't care, others
> may and do.
> 
> As for glibc - those wrappers have a set of well defined tasks,
> e.g. set errno, hide underlying syscall, caching, threads etc. But
> glibc does not try to virtualize pids, for example, nor "spy" after
> the processes, so to speak.

I'm sorry to be blunt, but I simply have to say that you are wrong here.
We've spent six years developing DMTCP.  We've spent a lot of time getting
to know the design principles of glibc.  (And by the way, it's not just glibc
that does these dirty tricks with system calls --- bash, dash, Matlab,
and a host of other applications also do it.)
    Anyway, glibc definitely does have its own "dirty tricks", including
"spy"-ing.  Caching a pid and refusing to make a later system call
is definitely a form of spying.
    It gets worse with glibc session ids and group ids.  When a session id
or group id changes, glibc must inform all of the user threads that their
cached id has changed.  To do this it uses the SETXID concept and a 
dedicated signal, as I mentioned earlier.  At the time when the clone call
was created, there was a dicussion whether to implement threads directly
in the Linux kernel.  It was decided to go with the clone call, instead.
If I understand your general philosophy, that was a bad decision,
because NPTL threads are no longer transparent, and they now require
collaboration through wrappers in glibc.
(Sorry, another cheap shot.  Can we please shift the discussion to
a phone conversation?  If you're going to make me spend hours replying
on LKML, when I could explain it all to you in one hour on the phone,
then I will get cranky.)
    There are also other "dirty tricks" from glibc that I could bring out
for you -- where one might argue that glibc breaks your definition
of transparency.  (However, the literature has lots of papers on "transparent
checkpointing", and I think they use a different definition
of transparency from yours.)
    With DMTCP and glibc both, the philosophy is that as long as
the application coverage is broad enough, and as long as the tricks
of DMTCP and glibc do not affect any programmer's natural programming
methodology, then it's okay.  This is not about sandboxing, or hermeticity.
I understand that Linux C/R may have those higher goals, and that's laudable,
but please don't tell us that DMTCP is bad because it doesn't do
exactly what Linux C/R does.  (Sorry, getting cranky, again.)

> >>>Basically, if _transparent_ means
> >>>that one is not allowed to use anything at all from userland, then I
> >>>agree with you that no userland checkpointing can ever be transparent.
> >>>But, I think that's a biased definition of _transparent_.  :-)
> >>
> >>"Transparent" c/r means "invisible" to the user/apps, i.e. that
> >>you don't restrict the user or the app in what they do and how
> >>they do it.
> >>
> >>Did you ever try to 'ltrace skype' ?  there exists useful and
> >>popular software that doesn't like being spied after...
> >
> >We have not tried to 'ltrace skype'.  But ltrace is using PTRACE.
> >Note that DMTCP does not use PTRACE.  I imagine the more interesting question
> 
> Oh... that's not what I meant: 'ltrace skype' fails because skype
> tries to protect itself from being reverse-engineered. It doesn't
> like ltrace's interposition on some library calls (don't know the
> details). (Note that PTRACE doesn't upset skype: 'strace skype'
> does work). The point being - userspace wrapping is "escapable".
> 
> >is if we ever tried 'dmtcp_checkpoint skype'.  No, we have not, but
> >it sounds like an interesting experiment.  We'd love to do it, and
> >discuss with you whatever we learn.  In the offline discussion, perhaps
> >we can take a shortcut and have you describe the skype tricks to us,
> >so that we can give you a quick first guess.
> 
> No tricks - I once tried after a colleague mentioned that skype is
> hard to reverse engineer (I thought I could prove him wrong...).
> 
> >      Anyway, there's one other obvious issue with skype for both Linux C/R
> >and DMTCP.  Skype is talking to a remote app that is probably not under
> >checkpoint control.
> 
> Linux-cr can do live migration - e.g. VDI, move the desktop - in
> which case skype's sockets' network stacks are reconstructed,
> transparently to both skype (local apps) and the peer (remote apps).
> Then, at the destination host and skype continues to work.

That's a really cool thing to do, and it's definitely not part of what
DMTCP does.  It might be possible to do userland live migration,
but it's definitely not part of our current scope.  But if we're talking
about live migration, have you also looked at the work of
Andres Lagar Caviilla on SnowFlock?
    http://andres.lagarcavilla.com/publications/LagarCavillaEurosys09.pdf
He does live migration of entire virtual machines, again with very
small delay.  Of course, the issue for any type of live migration is that
if the rate of dirtying pages is very high (e.g. HPC), then there is
still a delay or slow response, due to page faults to a remote host.

> >And even if both ends are under checkpoint control,
> >Skype is probably not a good use case for C/R, but if it were, it might
> >indeed be a difficult problem.  (I'd have to think about it.)
> >     As before, remember that we are talking about two different approaches:
> >- in-kernel C/R and capturing every possible application;
> >- userland C/R and covering the actual use cases that one finds in practice
> 
> I'd assume that if the c/r engine can do the former, then it
> will also do the latter. Maybe even it would be useful for dmtcp
> to be able to use a couple of syscalls (checkpoint,restart) to
> do the base c/r work  :p

Yes, we have no objection to combining ideas from DMTCP and Linux C/R.
This is not a case of either-or.  Let's study the use cases together.
I won't say more, because I'm clearly getting cranky right now.  :-)

> Oren.
