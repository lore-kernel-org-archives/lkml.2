Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab1D3CRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 22:17:55 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:56869 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1D3CRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 22:17:54 -0400
Date: Fri, 29 Apr 2011 22:17:04 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <20110429185741.GB10217@elte.hu>
Message-ID: <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu> <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu> <20110429185741.GB10217@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Ingo Molnar wrote:

> > why?  Can you explain this better?
> 
> Didn't i do that in the rest of my reply? You even quote some of it below.

No.

You have not explained why having "generalized" counter definitions have 
anything to do with raw event access.

If your argument was you thought that the values being written to 
the config1 and config2 fields of the perf_attr structure might need to be 
better defined, well that's a better argument and I'd buy that.  That's a 
valid technical argument for blocking raw event access (though you 
probably shouldn't have the fields there at all if you are unsure, they 
become ABI pretty quickly).

But your argument isn't that.  Your argument is that you're blocking raw 
event access as some sort of punishment because us HPC people aren't 
providing patches for "generalized" events that we never plan to use.
That's not a technical argument, that's some sort of weird power play.

> Well, the raw events ABI reminds me of the perfmon2/perfmon3 ABI: get the raw 
> PMU to user-space as quickly as possible and leave all the details to 
> user-space. I do not agree with that model of exposing performance measurement 
> hardware features.

well you probably should have thought of that before you enabled raw 
events at all then.  It's a bit too late now.

> > perfmon2 and perfctr are very similar to perf_events in that they provide 
> > lightly massaged access to the MSRs so you can program whatever raw event 
> > that you like.
> 
> perf events (the kernel side) has a very, very different design from perfmon2 
> and perfctr - but judging by your past replies such design aspects you do not 
> seem to recognize, let alone appreciate.

I didn't mean the internal designs were similar.  There's only so many 
sane ways to provide access to perf counters at the kernel level, and all 
of them look a lot alike from a high level.

> > It's true that the *userspace* tools (pfmon, iperfex, PAPI) handle things 
> > differently than perf, but that's a *userspace* API, not a kernel ABI.  You 
> > seem to keep confusing this.
> 
> No, i do not think i am confused, i just disagree with you.

Why does it matter?  Why should you as a kernel devel have any say in what 
my userspace tool looks like, as long as it is using a published ABI in a 
documented manner?

> Why not? We cannot generalize everything, but generalizing the major CPU 
> concepts works quite well for perf. The thing is, the laws of physics are the 
> same for all CPUs so they all seem to employ very similar concepts and measure 
> those concepts in similar ways, with similar events.

Fine.  Can we have a document saying what the events measure?

Also can you provide some way to query from userspace what event is being
used so that if someone reports a problem with an event we can figure
out which one it is in the relevant manual?

For cache events:
  + Do they count prefetches?  (SW, HW?)
  + Do they count coherency misses or just standard CCC ones?
  + Do they count speculative accesses or only retired accesses?
  + Do they count HW pagetable walks?  

For branch events:
  + Are they determnistic?
  + Are they speculative?

For retired instructions:
  + Deterministic?
  + Does it inclue HW interrupt counts?
  + are there any erratta?
  + Are any counted twice?

> AMD managed to keep a large chunk of their events stable even across very 
> radical changes of the underlying hardware. I have two AMD systems produced 
> *10* years apart and they even use the same event encodings for the major 
> events.

Well guess what, AMD family 15h changes all of that.

And you're not going to like LWP.  They got tired of waiting for a 
workable kernel perf counter interface and moved it completely to 
usersapce, and there's nothing you can do about it unless you start 
blocking the xsave patches from getting in.


> Intel started introducing stable event definitions a couple of years ago as 
> well.

yes. ANd just how compatible are they?  You might want to discuss that 
with some people from intel.

> So i think i can tell it with a fairly high confidence factor that you simply 
> do not know what you are talking about.

Really.

> I have the exact opposite experience: chip designers we talked to were clearly 
> supportive of the generalizations perf events offers and clearly both AMD and 
> Intel chips are moving *towards* more stable, more generic and more flexible 
> performance event measurement methods.

You must be talking to different people that I have.  Have you looked at 
Power6/Power7 or ARM counters?

> We are getting more counters and with less constraints. Even the hardware is 
> slowly but surely abstracting things out.

Again... Sandy Bridge?  Interlagos?  You might want to check that out.


In any case I wish you'd get on the ball with uncore, offcore, etc. 

One of the promises made when perf_events was merged was that the kernel 
was the place to do all this stuff because it would allow such quick 
turnaround on new features.

As it is by the time Nehalem Offcore/Uncore support gets into a kernel 
that is picked up by a distro the chips are going to be 3+ years old and 
headed to the recycle bin.

Vince
