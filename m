Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab1EILB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:01:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40301 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1EILB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=V4qXdeY25NpnixGVg1TxnI1jOg0Ujdxsh1PKVJnCLtYRY4ORNGSv3UdiJ/SNpBIfn8
         AKwWEFIte2+/hPI/M5dje7imyZ6126ckGODKkN972oF0rNuP3414HRGZ8OXajEbN02uB
         oT9NmWo665hSlR3T08x8rD2jsZgJTR+N/43cw=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20110429185741.GB10217@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
	<20110429164227.GA25491@elte.hu>
	<alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
	<20110429185741.GB10217@elte.hu>
Date: Mon, 9 May 2011 13:01:25 +0200
Message-ID: <BANLkTinWxugxrx=7+wJGgoXvT3KGAz28Pg@mail.gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        eranian@google.com, Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:57 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
>
>> On Fri, 29 Apr 2011, Ingo Molnar wrote:
>>
>> > Firstly, one technical problem i have with the raw events ABI method is that it
>> > was added in commit e994d7d23a0b ("perf: Fix LLC-* events on Intel
>> > Nehalem/Westmere"). The raw ABI bit was done 'under the radar', it was not the
>> > declared title of the commit, it was not declared in the changelog either and
>> > it was not my intention to offer such an ABI prematurely either - and i noticed
>> > those two lines too late - but still in time to not let this slip into v2.6.39.
>>
>> The initial patches from November seem to make it clear what is being done
>> here.  I thought it was pretty obvious to those reviewing those patches what
>> was involved.  How would I have known that OFFCORE_RESPONSE support was
>> coming if I didn't see the patches obviously float by on linux-kernel?
>
> Not really, Peter did a lot of review of those patches and they were changed
> beyond recognition from their original form - i think Peter wrote a fair
> portion of the supporting cleanups, as Andi seemed desinterested in acting
> quickly on review feedback.
>

I did spend quite some time looking at the patch, testing it,
debugging it with Lin
Ming. It was all done in the open. We even discussed with Peter the
config1/config2
approach instead of stashing the extra bits in config due to
SandyBridge. During those
months, nobody, absolutely nobody, including YOU, objected to the fact
that the patch
did not provide a generic abstraction for the offcore_response events.
I find it hard
to believe you overlooked that until the last minute. There was no
'under the radar'
behavior. So please, stick to the facts.

> Secondly, Peter posted a patch that might resolve this issue in v2.6.40 - but
> that patch is not cooked yet and you guys have not helped finish it. I'd like
> to see that process play out first - maybe we discover some detail that will
> force us to modify the config1/config2 ABI approach - which we cannot do if
> this is released into v2.6.39 prematurely.
>

I would think the opposite would happen. The config1 is pretty much all you
need to pass the extra config for this event. The hardware is not going to
change from under us on those processors. Keep in mind that offcore_response
is not an architected event and will never be. I would rather see a situation
where you devise mappings to generic events for v2.6.40 and then later you
realize they are wrong. Now, you've changed the behavior of the kernel, it does
not count the same thing anymore. This has already happened with the existing
generic events and will continue to happen based on my limited understanding
of what they're supposed to count.

> Thirdly, and this is my most fundamental objection, i also object to the timing
> of this offcore raw access ABI, because past experience is that we *really* do
> not want to allow raw PMU details without *first* having generic abstractions
> and generic events first.

I am not opposed to generic events. But I don't think they're the
ultimate solution
to all your performance problems: the crystal ball you're trying to sell.

I also don't think users are sloppy either. That's not showing a lot
of considerations
for end-users. I also don't quite follow the reasoning here: "Users are sloppy,
therefore push all the complexity in the "smart" kernel'. What's wrong
with having
smarter tools to help users? The kernel is not necessarily the
solution to all users'
problems. Tool developers are as talented and innovative as kernel developers.

Performance monitoring is not and never will be a 5mn thing you do at
the end of the
day. Same thing for tools, the fact that you write a performance tool
in half a day
is not necessarily a sign that the tool or the kernel API it sits on,
are very good.
What matters is the quality of the data it returns, the quality of the
interpretation
of the data and how it can be translated into program changes that may
eventually lead
to performance improvements. So when I can do a quick:

 $  perf stat -e l1-load-misses foo

I want to be sure:
 - I understand what I am actually measuring
 - I am measuring the same thing on different processors
 - what I am measuring does not change at each kernel version

Sure, it spares me the time to read the manual, but I'd like to be sure
I understand what's going on. It is easy to be misled by counts (see below).
As we've discussed earlier, what matters is the ability to associate costs to
events. I think it would be quite hard to associate costs to generic events when
many are just too broad.

Generic events could be a first approximation BUT they need to be very carefully
defined. You need to clearly state what they count. That's really a minimum.
And if they are just approximations, then I need to know to what extent. Those
rules would have to be set across the board. If you start saying that on Intel
these restrictions apply and on AMD another set of restrictions applies, then
what's the point of all of this?  "Sloppy" users should not be expected to
sift through the kernel changelog to realize that some generic events have
restrictions or are just vast approximations. Ultimately, the tool has to be
aware of this to warn users. This is the problem with the model, it creates
the illusion of uniformity an stability, when the reality is quite different.

You also need to be more careful in how you map generic events. This
goes back to your
"thinking is hard, ..." argument. You do need to think hard before you
come up with
an event you think would be valuable as a generic event. Such event
becomes valuable
only if it can be mapped on MORE than one processor AND measure the SAME thing.
Failure to do so, means the model is useless.

A quick reading of the Intel event table to find approximate mappings
is not enough.
Given generic events are a center-piece of your design, you need to be
extra cautious
when adding mappings. I would expect you'd write micro-benchmarks to
validate that
the event counts what its generic mapping is defined for.

I am afraid, your recent series of stalls events is not a perfect
illustration of that.
Here is an example:

 /* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;

There is a reason this event is called CORE. When HT is on, it counts
what's going on for the
two threads. You're measuring your CPU and the sibling CPU. If you are
stalled and the other
thread is not, you will vastly undercount. This is regardless of the
setting of that ANY bit.
The count is wrong when running per-thread mode. At the user level,
you think you're measuring
stalls in your thread when the reality is very different.  This
example just illustrates the danger
of generic events.

Going back to offcore-response, generic events becomes valuable if you
can map them
onto more than one processor. I'd like to understand their mappings on
AMD processors.

As you said, most processors have common micro-architectural
components these days.
But that does NOT mean you can measure them the same way. The Intel
and AMD event
tables are full of examples of that (LLC misses is one). I am not
necessarily happy about
that, but I can understand why this happens. Many times, it is not
possible to compensate
in SW for the HW differences in how an event counts despite its
concept being apparently
simple such as with a cache miss.

> But it's more than that, generalization works even on the *hardware* level:
>
> AMD managed to keep a large chunk of their events stable even across very
> radical changes of the underlying hardware. I have two AMD systems produced
> *10* years apart and they even use the same event encodings for the major
> events.
>
> Intel started introducing stable event definitions a couple of years ago as
> well.
>

I don't agree with this statement. It's not happening. The proof is that Intel
came out with the architected events with the Core micro-architecture. Since,
then, we've had Nehalem, Westmere, Sandy Bridge and the list of architected
events has NOT been extended. I bet you, it won't with follow on processors.
It does not make sense. The micro-architecture keeps changing. Take the uncore
component. It  varies between a single-socket and dual-socket WSM and is
totally different on the EX part. You think you can ever get an architected last
level cache miss event that works across the board? The event definition does
matter and it's not a marginal issue.

As for AMD, yes, it has not changed in 10 years, but that does not
mean the problem
is solved and that all events are useful. Furthermore, I am sure
you've seen the AMD
patches for Fam15h processors (Bulldozer), they've added a bunch of
event constraints.

> Basically without proper generalization people get sloppy and go the fast path
> and export very low level, opaque, unstructured PMU interfaces to user-space
> and repeat the Oprofile and perfmon tooling mistakes again and again.
>
>  "Thinking is hard, lets go shopping^W exporting raw ABIs."
>

What is your proposal for the proper abstraction for AMD IBS, then?


> We put structure, proper abstractions and easy tooling *ahead* of the interests
> of a small group of people who'd rather prefer a lowlevel, opaque hardware
> channel so that they do not have to *think* about generalization and also
> perhaps so they do not have to share their selection of events and analysis
> methods with others ...
>

Now what? A conspiracy theory. You really think that's the goal of those
people (which I bet include myself)? The reality is quite different. Those
people want to help. They have been looking at this for years. They know
where the pitfalls are and they are trying to raise awareness. They also
want to make sure Linux provides them with an infrastructure on which they
can build better tools for advanced analysis.

Don't go claiming those people will run away once they have raw event access.
Have I not contributed patches to perf_events to make it better and that
despite what happened two years ago?

Nobody is trying to conceal events or analysis techniques (see the presentation
below). People are trying to get what they need based on past experience dealing
with PMU hardware and applications.

Related to that, the following statement on Vince:

> So i think i can tell it with a fairly high confidence factor that you simply
> do not know what you are talking about.

I think this is a gratuitous and unfounded statement. I have known Vince for
years. He has been studying the PMU events for years, writing micro-benchmarks
to really understand what they actually count and their differences
across processors.
So I think he is fully qualified to comment on events.


As described above, there are lots of pitfalls when using PMU events. I'd like
to have to access the events as described in the processor specs. There is no
harm in doing so. This is a way of validating measurements and also a
way of doing
finer grain analysis. The extra 1% of performance does matter for a
lot of applications
and for those you need a lot more than the generic events.

Analysis techniques have been published (not concealed). The following
presentation
given at CERN a few months back is a good example:

    https://openlab-mu-internal.web.cern.ch/openlab-mu-internal/03_Documents/4_Presentations/Slides/2010-list/HPC_Perf_analysis_Xeon_5500_5600_intro.pdf

We believe we can build tools to create that decomposition tree. Such
decomposition
needs access to many raw events. Some people have already prototyped tools based
on those analysis techniques:

    http://mkortela.web.cern.ch/mkortela/ptuview/

If perf_events does not allow such tools to be built because it is
artificially restricting
access to certain hardware features, then people, incl. myself, may legitimately
question its usefulness.

In summary, I am not a believer in generic events, at least not at the
kernel level.
That does not mean I am against them. However, I am against the ideas that there
should only be generic events and that generic events should come first.
