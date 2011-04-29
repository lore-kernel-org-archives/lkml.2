Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab1D2Qmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:42:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36220 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759988Ab1D2Qmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:42:49 -0400
Date: Fri, 29 Apr 2011 18:42:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110429164227.GA25491@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
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

> Hello Linus
> 
> can you revert the commit b52c55c6a25e4515b5e075a989ff346fc251ed09
> 
> This removed functionality from perf_events that allowed raw event access 
> for OFFCORE_EVENTS type events on Nehalem and Westmere cpus.

I have three major objections/concerns.

Firstly, one technical problem i have with the raw events ABI method is that it 
was added in commit e994d7d23a0b ("perf: Fix LLC-* events on Intel 
Nehalem/Westmere"). The raw ABI bit was done 'under the radar', it was not the 
declared title of the commit, it was not declared in the changelog either and 
it was not my intention to offer such an ABI prematurely either - and i noticed 
those two lines too late - but still in time to not let this slip into v2.6.39.

Secondly, Peter posted a patch that might resolve this issue in v2.6.40 - but 
that patch is not cooked yet and you guys have not helped finish it. I'd like 
to see that process play out first - maybe we discover some detail that will 
force us to modify the config1/config2 ABI approach - which we cannot do if 
this is released into v2.6.39 prematurely.

Thirdly, and this is my most fundamental objection, i also object to the timing 
of this offcore raw access ABI, because past experience is that we *really* do 
not want to allow raw PMU details without *first* having generic abstractions 
and generic events first.

The discussion in the "[PATCH 1/1] perf tools: Add missing user space support 
for config1/config2" thread on lkml has demonstrated it pretty well: people 
only started making serious thoughts about proper structure and abstractions 
and easy tooling once they were forced to think about that ...

The thing is, as far as i can see you and Andi are *still* pushing the failed 
perfmon and Oprofile ABI and tooling models.

My job as a maintainer is to notice such things and to say 'no' to incomplete 
bits.

Basically without proper generalization people get sloppy and go the fast path 
and export very low level, opaque, unstructured PMU interfaces to user-space 
and repeat the Oprofile and perfmon tooling mistakes again and again.

 "Thinking is hard, lets go shopping^W exporting raw ABIs."

So the perf events policy has always been that while we tolerate raw events 
(there's nothing bad with offering them once generic events have crystallized 
out), we only accept them if the *useful* events are first abstracted and 
generalized out.

We put structure, proper abstractions and easy tooling *ahead* of the interests 
of a small group of people who'd rather prefer a lowlevel, opaque hardware 
channel so that they do not have to *think* about generalization and also 
perhaps so they do not have to share their selection of events and analysis 
methods with others ...

For the offcore patches this concept of 'abstraction first' has been ignored 
entirely, and commit e994d7d23a0b ("perf: Fix LLC-* events on Intel 
Nehalem/Westmere") has (without declaring it in the changelog) added a raw ABI 
hack to the offcore PMU features without bothering to factor out the useful 
events first. This slipped through and i only noticed it when Andi's patch got 
to me:

   https://lkml.org/lkml/2011/4/22/14

Generalization of offcore, NUMA memory events is very much possible and 
desirable, and Peter has posted an RFC patch that implements one form of it:

   https://lkml.org/lkml/2011/4/22/281

And with that done raw events can be offered as well.

But it's still work in progress - it might be mergable in v2.6.40. 
Unfortunately neither you nor Andi has actually bothered testing (and 
improving) Peter's patch. If we do the raw ABI now i fear you guys will 
disappear and wont ever bother with proper generalization.

We want generalization like Peter's patch first - that is what users really 
need in the end, and that is the price of us supporting/maintaining this PMU 
functionality in the kernel. Once we feel good about it can we expose the raw 
bits as well.

Not the other way around.

> To be fair, this is not technically a regression as the feature was only 
> (finally!) added in the 2.6.39 merge window.  However this is a useful 
> feature and many tools (including the PAPI performance counter library that I 
> work on) had added support for it in anticipation of the 2.6.39 release.
> 
> Ingo's reasons for removing the feature seem to boil down to
>   1.  "perf" doesn't use the functionality, and any other userspace
>       program that uses the perf_events syscalls don't matter
>   2.  Users are too stupid to use the raw functionality properly;
>       we should only allow a kernel-developer-approved small subset
>       of the features provided by the CPU as described in the intel
>       developers manuals.
>
> #2 seems like a gross misinterpretation of the whole "Linux gives you
> enough rope to shoot yourself in the foot" policy from days passed, but maybe 
> things have moved on.

That is a very unfair and misleading summary that grossly misrepresents my 
position. I've made my position very clear to you, multiple times - and so has 
Peter and others have made clear their similar position on this issue.

I detailed my concerns in the commit you want reverted and i also repeated it 
in the lkml discussion, multiple times, as replies to you. You can also see it 
outlined in detail in my reply above.

In light of all that, how you could possibly misrepresent my position in such 
an unfair, distorted and manipulative way is beyond me ...

Thanks,

	Ingo
