Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1LTLK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:10:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1LTLKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:10:24 -0500
Date: Tue, 20 Dec 2011 12:08:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [lttng-dev] [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111220110813.GA19105@elte.hu>
References: <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
 <20111208052354.GC9485@elte.hu>
 <20111208232709.GA19820@kroah.com>
 <20111219104915.GA19861@elte.hu>
 <20111219153053.GA21548@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219153053.GA21548@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ing Arnaldo on this as well.)

* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> > Mathieu, any update on this? I don't want the LTTNG goodies 
> > to drop on the floor - we just have to integrate them 
> > properly.
> > 
> > If you 100% disagree with how specific things are done 
> > upstream right now then don't hold back: just replace 
> > existing mechanisms - that gives a starting point to discuss 
> > what the best way is forward.
> 
> I'm bringing a though question then: what should we do if I 
> strongly think that the current ABIs should be replaced ?  To 
> support this, let's note that the current perf ABI:
> 
>  - lacks versioning information to handle change. [...]

That's not actually true on *any* level: we are changing, 
evolving and extending the perf ABIs all the time.

There's two main API/ABI components:

1) the perf syscall which is part of the Linux syscall ABI.

Individual versions of the ABI have (monotonically increasing) 
sizes for "struct perf_event_attr" - you can consider these 
natural ABI versioning.

So the 'versioning' is not done via some inflexible and ugly, 
Windows-alike 'explicit ABI version' field, but done via 
structure sizes and -ENOSYS.

We've iterated and versioned it numerous times in the past 10 
kernel releases, in a backwards compatible manner.

2) the perf.data file

The versioning there is capability bitmask based - modelled 
after ext2/ext3/ext4 capability bitmasks. It's extensible as 
well.

I think your concentration on ABIs is missing a very fundamental 
property of instrumentation:

  the life-time and persistence of instrumentation data is 
  typically very short ('days' is already an exception - typical 
  is minutes, at most hours), and for that reason we havent been 
  getting much pressure from users to maintain a perf.data ABI - 
  but we are doing it nevertheless.

Instrumentation is fundamentally about the 'here and now' and so 
it fundamentally differs from things like backup formats and 
database formats. An ABI does not hurt and we are maintaining 
it, but you are overrating its importance significantly.


>    [...] I think shipping the tracer tools within the Linux 
>    tools/ directory made sense for an initial phase that made 
>    tracer solutions more popular for kernel developers (and it 
>    did a great job a that), but if we want to move on to build 
>    tools that target a wider audience, we should leave the 
>    tools/ sandbox and create separate projects, with clearly 
>    defined ABIs, using ABI versioning to manage changes. At 
>    this point, I think that perf tool shipped within tools/ is 
>    more than anything a pain for non-kernel-developer users, 
>    and favors design of sloppy ABIs.

I think you've thoroughly misunderstood the upstream ABI 
versioning status quo, which makes your argument out of this 
world.

The perf ABIs are well-defined and well-maintained. See an 
ad-hoc ABI and tool compatibility experiment i made here:

   [F.A.Q.] perf ABI backwards and forwards compatibility
   https://lkml.org/lkml/2011/11/8/77

>  - makes it impossible to move to CTF (Common Trace Format) 
>    and benefit from the added features it allows,

"CTF" was mainly written by yourself, right?

If there's any tool worth caring about that wants to deal in CTF 
then it can be converted just fine. I don't think it matters 
nearly as much as you seem to imply, see my reply further below.

>  - makes it needlessly hard, if not impossible, for perf to
>    move to something that would have the benefits brought by 
>    the fast unified ring buffer code I created 2 years ago,

The current upstream code actually has a fast unified 
ring-buffer, mmap()-ed to user-space, so you'd have to be a bit 
more specific about that point.

>  - makes it impossible to benefit from the LTTng fast trace 
>  clocks.

We have various trace clocks upstream as well - so you'd have to 
outline it specifically why it's "impossible".

> Also, it should be noted that I am finding that the way perf 
> evolved into a large monolithic binary blob that needs to be 
> all enabled or all disabled makes it quite hard to extend and 
> re-use. [...]

There's a (very) healthy in-flux of features - it's one of the 
most active kernel and userpace projects we have.

So *others* don't find it hard to work with. If you have 
specific observations i'm sure Arnaldo will appreciate them.

[ I snipped the rest of your reply - you seem to have deep 
  rooted misconceptions about what the current upstream 
  principles and practices are in this area: you are banging on 
  open doors! ]

Anyway, my prior request+offer stands: please split LTTNG up 
into individual feature blocks done to extend or replace 
existing instrumentation features and offer them as changes to 
existing upstream instrumentation code. We want every 
conceivable useful feature, but we *really* don't want 
schizophrenic duplication in this area.

Thanks,

	Ingo
