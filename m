Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873Ab1D2S6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1D2S57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:57:59 -0400
Date: Fri, 29 Apr 2011 20:57:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110429185741.GB10217@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <20110429164227.GA25491@elte.hu>
 <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Fri, 29 Apr 2011, Ingo Molnar wrote:
> 
> > Firstly, one technical problem i have with the raw events ABI method is that it 
> > was added in commit e994d7d23a0b ("perf: Fix LLC-* events on Intel 
> > Nehalem/Westmere"). The raw ABI bit was done 'under the radar', it was not the 
> > declared title of the commit, it was not declared in the changelog either and 
> > it was not my intention to offer such an ABI prematurely either - and i noticed 
> > those two lines too late - but still in time to not let this slip into v2.6.39.
> 
> The initial patches from November seem to make it clear what is being done 
> here.  I thought it was pretty obvious to those reviewing those patches what 
> was involved.  How would I have known that OFFCORE_RESPONSE support was 
> coming if I didn't see the patches obviously float by on linux-kernel?

Not really, Peter did a lot of review of those patches and they were changed 
beyond recognition from their original form - i think Peter wrote a fair 
portion of the supporting cleanups, as Andi seemed desinterested in acting 
quickly on review feedback.

> > Thirdly, and this is my most fundamental objection, i also object to the 
> > timing of this offcore raw access ABI, because past experience is that we 
> > *really* do not want to allow raw PMU details without *first* having 
> > generic abstractions and generic events first.
> 
> why?  Can you explain this better?

Didn't i do that in the rest of my reply? You even quote some of it below.

> > The thing is, as far as i can see you and Andi are *still* pushing the 
> > failed perfmon and Oprofile ABI and tooling models.
> 
> what ABI? 

Well, the raw events ABI reminds me of the perfmon2/perfmon3 ABI: get the raw 
PMU to user-space as quickly as possible and leave all the details to 
user-space. I do not agree with that model of exposing performance measurement 
hardware features.

> [...] by the way, I hate oprofile and never use it.

I dont 'hate' oprofile per se (hey, i still keep pulling and pushing oprofile 
bits from Robert), i just find it very unintuitive and cumbersome to use, and i 
think it was misdesigned in several ways.

> perfmon2 and perfctr are very similar to perf_events in that they provide 
> lightly massaged access to the MSRs so you can program whatever raw event 
> that you like.

perf events (the kernel side) has a very, very different design from perfmon2 
and perfctr - but judging by your past replies such design aspects you do not 
seem to recognize, let alone appreciate.

> It's true that the *userspace* tools (pfmon, iperfex, PAPI) handle things 
> differently than perf, but that's a *userspace* API, not a kernel ABI.  You 
> seem to keep confusing this.

No, i do not think i am confused, i just disagree with you.

> > We put structure, proper abstractions and easy tooling *ahead* of the 
> > interests of a small group of people who'd rather prefer a lowlevel, opaque 
> > hardware channel so that they do not have to *think* about generalization 
> > and also perhaps so they do not have to share their selection of events and 
> > analysis methods with others ...
> 
> And generalization across platforms (and even across minor chip revisions) 
> *doesn't work*.

Why not? We cannot generalize everything, but generalizing the major CPU 
concepts works quite well for perf. The thing is, the laws of physics are the 
same for all CPUs so they all seem to employ very similar concepts and measure 
those concepts in similar ways, with similar events.

But it's more than that, generalization works even on the *hardware* level:

AMD managed to keep a large chunk of their events stable even across very 
radical changes of the underlying hardware. I have two AMD systems produced 
*10* years apart and they even use the same event encodings for the major 
events.

Intel started introducing stable event definitions a couple of years ago as 
well.

So i think i can tell it with a fairly high confidence factor that you simply 
do not know what you are talking about.

> [...]  It lasted maybe a year in PAPI before it was realized to be 
> unworkable.  Talk to some people from AMD or Intel if you want.  It's not 
> possible to sanely generalize perf counters.  They are too tied to hardware 
> quirks.

I have the exact opposite experience: chip designers we talked to were clearly 
supportive of the generalizations perf events offers and clearly both AMD and 
Intel chips are moving *towards* more stable, more generic and more flexible 
performance event measurement methods.

We are getting more counters and with less constraints. Even the hardware is 
slowly but surely abstracting things out.

It is in the interest of PMU designers as well that their stuff moves one level 
higher within OSs and does not stay at the weird hardware-specific level. 
Hardware is getting more complex, measuring it becomes more complex, so making 
things more generic certainly helps.

Thanks,

	Ingo
