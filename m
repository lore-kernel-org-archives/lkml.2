Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0KGTmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 14:42:31 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:50673 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0KGTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 14:42:30 -0500
Date: Sun, 7 Nov 2010 14:42:22 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Kapil Arya <kapil@ccs.neu.edu>, Tejun Heo <tj@kernel.org>,
        Gene Cooperman <gene@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101107194222.GG31077@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
 <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
 <4CD5DCE3.3000109@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD5DCE3.3000109@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to add a few clafifications, below, about DMTCP concerning
Oren's comments.  I'd also like to point out that we've had about 100
downloads per month from sourceforge (and some interesting use cases
from end users) over the last year (although the sourceforge numbers
do go up and down :-) ).  In general, I think we'll all understand the
situation better after having had the opportunity to talk offline.
Below are some clarifications about DMTCP.
===

> For example, in your example, you'd need to wrap the library calls
> (e.g. of MPI implementation) and replaced them to use TCP/IP or
> infiniband. Wrapping on system calls won't help you.

We do not put any wrappers around MPI library calls.  MPI calls things
like open, close, connect, listen, execve({"ssh", ...}, ...), etc.
At this time, DMTCP adds wrappers _only_ around calls to libc.so
and libpthread.so .  This is sufficient to checkpoint a distributed
computation like MPI.

> The only two reasons to interpose on systems calls, ...
> 
> One - to virtualize in userspace reosurces (e.g. pids) that the
> kernel already knows how to virtualize.
> 
> Two - to track state of resources during execution and lie about
> their state when needed, because userspace can't cleanly save
> and restore their state.

Just a small correction about interposition.  The primary "Reason Two"
for interposing on system calls should be to _spy_ on what the user process
is doing and save that information.  For the most part, we do not
_lie about their state when needed_.  I agree that virtualization of pids
is an exception where we have to lie, but that was already stated as
"Reason One" above.  At restart time, we may also recreate resources that are
no longer in the kernel.  But this is not an example of interposition.
I suppose that it is an example of lying, but every C/R technique will
need to do this.
    Later, perhaps Oren, Kapil and I can browse the DMTCP code together,
and we can look exactly at what each wrapper is doing.  The system call
wrappers are, in fact, the smaller part of the DMTCP code.  It's about
3000 lines of code.  For anybody who is curious about what our wrappers do,
please download the DMTCP source code, and look at
.../dmtcp/src/*wrapper*.cpp .

> So I'll repeat the question I asked there: is re-reimplementing
> chunks of kernel functionality and all namespaces in userspace
> the way to go ?

If you're referring to interposition here, that takes place essentially
in the wrappers, and the wrappers are only 3000 lines of code in DMTCP.
Also, I don't believe that we're "re-implementing chunks of kernel
functionality", but let's continue that discussion offline.

> What is "reasonable" overhead ?
> For which applications ?
> What about a 'kernel make' ?
> What about servers (db, web, etc) ?
> What about VPSs/VDIs ?
> Can we do better, including for HPC ?

Again, all good questions that will be answered more easily offline.

> ... (yes, transparent means that
> it does not require LD_PRELOAD or collaboration of the application!
> nor does it require userspace virtualizations of so many things
> already provided by the kernel today), more generic, more flexible,
> provides more guarantees, cover more types or states of resources,
> and can perform significantly better.

I still haven't understood why you object to the DMTCP use of LD_PRELOAD.
How will the user app ever know that we used LD_PRELOAD, since we remove
LD_PRELOAD from the environment before the user app libraries and main
can begin?  And, if you really object to LD_PRELOAD, then there are
other ways to capture control.  Similarly, I'll have to understand better
what you mean by the _collaboration of the application_.  DMTCP operates
on unmodified application binaries.  Basically, if _transparent_ means
that one is not allowed to use anything at all from userland, then I
agree with you that no userland checkpointing can ever be transparent.
But, I think that's a biased definition of _transparent_.  :-)

> And then, if you want to work with dmtcp's type of scenarios, you
> could use the generic c/r and apply their wrappers on top of it !

Agreed.  As before, I'm looking forward to us analyzing all the
use cases offline.  I think that we're all (myself included) in the
situation of the three blind men and the elephant.  I think part of the
misunderstanding is that we're each thinking about a different use case,
and so we (myself included) end up comparing apples and oranges.

Thanks,
- Gene
