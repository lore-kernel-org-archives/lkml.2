Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0KGXF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:05:29 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:39188 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0KGXF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:05:26 -0500
Date: Sun, 7 Nov 2010 18:05:16 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101107230516.GJ31077@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
 <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
 <4CD5DCE3.3000109@cs.columbia.edu>
 <20101107194222.GG31077@sundance.ccs.neu.edu>
 <4CD71A6B.3020905@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD71A6B.3020905@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 04:30:19PM -0500, Oren Laadan wrote:
> 
> 
> On 11/07/2010 02:42 PM, Gene Cooperman wrote:
> >I'd like to add a few clafifications, below, about DMTCP concerning
> >Oren's comments.  I'd also like to point out that we've had about 100
> >downloads per month from sourceforge (and some interesting use cases
> >from end users) over the last year (although the sourceforge numbers
> >do go up and down :-) ).  In general, I think we'll all understand the
> >situation better after having had the opportunity to talk offline.
> >Below are some clarifications about DMTCP.
> >===
> >
> >>For example, in your example, you'd need to wrap the library calls
> >>(e.g. of MPI implementation) and replaced them to use TCP/IP or
> >>infiniband. Wrapping on system calls won't help you.
> >
> >We do not put any wrappers around MPI library calls.  MPI calls things
> >like open, close, connect, listen, execve({"ssh", ...}, ...), etc.
> >At this time, DMTCP adds wrappers _only_ around calls to libc.so
> >and libpthread.so .  This is sufficient to checkpoint a distributed
> >computation like MPI.
> 
> Of course. And you don't need syscall virtualization for this.
> Zap did it already many years ago :)  Only problem with the above
> is that, conveniently enough, you _left out_ the context:
> 
> >> For example,
> >> if a distributed computation runs over infiniband, can we migrate
> to a TCP/IP
> >> cluster. For this, one needs the flexibility of wrappers around
> system calls.
> 
> Do you also support checkpoint a distributed app that uses an
> infiniband MPI stack and restart it with a TCP based MPI stack ?
> Can you do it with only syscall wrapping and without knowledge
> on the MPI implementation and some MPI-specific logic in the
> wrappers ?   I'm curious how you do that without wrapping around
> MPI calls, or without an c/r-aware implementation of MPI.
> ...

Yes, that's exactly what we plan to do.  And we have begun some of the
initial work.  And yes, we plan to do it without any MPI-specific logic.
When we talk to each other offline, I'd be happy to give you more
details of how we do it now for TCP "without wrapping around MPI calls,
or without an c/r-aware implementation of MPI", and how we are working
on extending that to Infiniband.

> [snip]
> 
> >>So I'll repeat the question I asked there: is re-reimplementing
> >>chunks of kernel functionality and all namespaces in userspace
> >>the way to go ?
> >
> >If you're referring to interposition here, that takes place essentially
> >in the wrappers, and the wrappers are only 3000 lines of code in DMTCP.
> >Also, I don't believe that we're "re-implementing chunks of kernel
> >functionality", but let's continue that discussion offline.
> 
> The interposition itself is relatively simple (though not atomic).
> The problem is the logic to "spy" on and "lie" to the applications.
> Examples: saving ptrace state, saving FD_CLOEXEC flag, correctly
> maintaining a userspace pid-ns, etc.

And let's wait for the offline discussion for that --- and we'll describe
in detail at that time how we do each one of the things that you mention.
It will be easier to discuss each of the things that you mention by
looking at the DMTCP code "side-by-side" over the phone.  We hope to
show you that the logic is really not so complex.
 
> >
> >>... (yes, transparent means that
> >>it does not require LD_PRELOAD or collaboration of the application!
> >>nor does it require userspace virtualizations of so many things
> >>already provided by the kernel today), more generic, more flexible,
> >>provides more guarantees, cover more types or states of resources,
> >>and can perform significantly better.
> >
> >I still haven't understood why you object to the DMTCP use of LD_PRELOAD.
> >How will the user app ever know that we used LD_PRELOAD, since we remove
> >LD_PRELOAD from the environment before the user app libraries and main
> >can begin?  And, if you really object to LD_PRELOAD, then there are
> >other ways to capture control.  Similarly, I'll have to understand better
> 
> I don't object to it per se - it's actually pretty useful oftentimes.
> But in our context, it has limitations. For example, it does not
> cover static applications, nor apps that call syscalls directly
> using int 0x80.

For static apps, we would use other interposition techniques.  And yes,
we haven't implemented support of static apps so far, because our
user base hasn't asked for it.  We do handle apps that use the
syscall system call to make system calls.  We don't handle apps
that directly use "int 0x80".  Again, there are ways to do this, but
our user base hasn't asked for it.
    In general, please keep in mind the principles that you rightly had
to remind me of in a previous post.  :-)  Our two pieces of work are coming
from two different directions with two different visions.  Linux C/R wants
to be so transparent that no user app can ever detect it.  DMTCP wants to be
transparent enough that any reasonable use case is covered.
    In particular, DMTCP considers distributed computations to be equally
valid use cases for the core DMTCP C/R.  I also agree that Linux C/R can be
extended to cover distributed apps -- either through userland extensions,
or maybe with techniques like in your excellent CLUSTER-2005 paper.
     Hence, DMTCP has grown its coverage of apps over the years.  When we
talk offline, let's talk about future use cases, and whether there are
or are not showstoppers for a userland approach.

> Also, it conflicts with LD_PRELOAD possibly needed
> for other software (like valgrind) - for which again you would need
> yet another per-app wrapper, at the very least.

DMTCP does not conflict with the fact that valgrind uses LD_PRELOAD.
We add dmtcphijack.so to the beginning of LD_PRELOAD before the user app
starts.  We then remove it before the app really starts.  The LD_PRELOAD
requests of valgrind continue to be honored.  It all works.

> >what you mean by the _collaboration of the application_.  DMTCP operates
> >on unmodified application binaries.
> 
> I mean that the applications needs to be scheduled and to run to
> participate in its own checkpoint. You use syscall interposition
> and signals games to do exactly that - gain control over the app
> and run your library's code. This has at least three negatives:
> first, some apps don't want to or can't run - e.g. ptraced, or
> swapped (think incremental checkpoint: why swap everything in ?!);
> Second, the coordination can take significant time, especially if
> many tasks/threads and resources are involved; Third, it modifies
> the state of the app - if something goes wrong while you use c/r
> to migrate an app, you impact the app.
> 
> (While 'ptrace' relieves you from the need for "collaboration"
> of processes, but doesn't address the other problems and adds
> its own issues).

Again, I'll add some clarification, although this will best be done
offline.  DMTCP does indeed do interposition of the 'syscall' system
call in glibc.  As for signals, we don't really play
any signal games.  The sole use of signals in DMTCP is for the
checkpoint thread of a process to quiesce the user threads of that
same thread.  We use one reserved signal, and we use it solely
internally within a single process.  If the user app will allow
us to use a single signal (e.g. SIGRTMIN+2), then we don't need
any games or interposition at all.  We were worried about apps
that wish to set _every_ signal to SIG_IGN, etc.

Next, let's consider what you say about wrappers around wrappers,
and your valgrind example.  Also, I'd like to make clear that we've
tested primarily on gdb.  If it's important, we could do a quick test on
valgrind and report back.  Our user base hasn't requested support for
valgrind so far.  Assuming that valgrind does use wrappers, we have a
valgrind wrapper around a DMTCP wrapper around a glibc call, which itself
is really a wrapper around a kernel API call.
    If it helps, then think of a wrapper as just another function,
that calls an inner function.  Object-oriented programming uses this
principle all the time.  Similarly, the glibc wrapper around a kernel
API is just one more of these functions.  Another way to view this is
through the idea of layers.  Each layer of the software receives a call
from the layer above and may call to the next layer below.  As you're
already aware, this is a basic principle of O/S design, and so
the O/S is full of wrappers.  We're just inserting one more layer ---
this time between the user app and the glibc layer.

I still don't fully understand what you mean by "collaboration", but
it sounds like your definition reduces to the the use of system call
wrappers.  In that case, I agree that if DMTCP were not allowed to use
system call wrappers, then DMTCP would fall apart.  Aside from that
almost tautology, I don't understand why system call wrappers are inherently
bad.  Glibc puts system call wrappers around almost every kernel system call.
Glibc even reserves two signals solely for its own use.

By the way, for those who wish to inspect the DMTCP wrappers, I'd like
to add to my pointers to DMTCP wrappers.  the relevant DMTCP code, is in:
dmtcp/src/execwrappers.cpp
dmtcp/src/miscwrappers.cpp
dmtcp/src/pidwrappers.cpp
dmtcp/src/signalwrappers.cpp
dmtcp/src/socketwrappers.cpp
dmtcp/src/syscallsreal.c
dmtcp/src/syscallwrappers.h
dmtcp/src/uniquepid.cpp
dmtcp/src/virtualpidtable.cpp

The total line count is probably 4,500 lines of code, which includes
about 500 lines of copyright statement (LGPL), #include and other boring
boiler-plating.  I apologize for the shorter listing in my earlier post.
I didn't intend to mislead.  There's lots of other DMTCP code concerned with
what to do at the time of checkpoint and restart, but that would be
a different story.

> >Basically, if _transparent_ means
> >that one is not allowed to use anything at all from userland, then I
> >agree with you that no userland checkpointing can ever be transparent.
> >But, I think that's a biased definition of _transparent_.  :-)
> 
> "Transparent" c/r means "invisible" to the user/apps, i.e. that
> you don't restrict the user or the app in what they do and how
> they do it.
> 
> Did you ever try to 'ltrace skype' ?  there exists useful and
> popular software that doesn't like being spied after...

We have not tried to 'ltrace skype'.  But ltrace is using PTRACE.
Note that DMTCP does not use PTRACE.  I imagine the more interesting question
is if we ever tried 'dmtcp_checkpoint skype'.  No, we have not, but
it sounds like an interesting experiment.  We'd love to do it, and
discuss with you whatever we learn.  In the offline discussion, perhaps
we can take a shortcut and have you describe the skype tricks to us,
so that we can give you a quick first guess.
     Anyway, there's one other obvious issue with skype for both Linux C/R
and DMTCP.  Skype is talking to a remote app that is probably not under
checkpoint control.  And even if both ends are under checkpoint control,
Skype is probably not a good use case for C/R, but if it were, it might
indeed be a difficult problem.  (I'd have to think about it.)
    As before, remember that we are talking about two different approaches:
- in-kernel C/R and capturing every possible application;
- userland C/R and covering the actual use cases that one finds in practice

You seem to be arguing that there is an important use case that a DMTCP
userland approach can never cover.  You may be right about such a use
case, but that detailed back-and-forth will be easier to do offline;
and then we can summarize for the list.

We'll even _help you_ look for those difficult use cases.  If they're there,
we want to know about them, too.  :-)

Thanks and best wishes,
- Gene
