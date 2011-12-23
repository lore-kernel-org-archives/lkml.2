Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1LWQqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:46:36 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46541 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754386Ab1LWQqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:46:33 -0500
Date: Fri, 23 Dec 2011 11:46:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Perf ABI (was: Re: [lttng-dev] [PATCH 09/11] sched: export
	task_prio to GPL modules)
Message-ID: <20111223164629.GA30474@Krystal>
References: <20111201221404.GC3365@kroah.com> <1322780830.4699.62.camel@twins> <20111201231751.GA4961@kroah.com> <20111205141749.GC28866@elte.hu> <20111206214446.GD1247@kroah.com> <20111208052354.GC9485@elte.hu> <20111208232709.GA19820@kroah.com> <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal> <20111220110813.GA19105@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220110813.GA19105@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:33:12 up 394 days, 20:36,  6 users,  load average: 0.00, 0.06,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'll break down my reply in various sub-topics, and address them
separately in the following weeks. Let's start with the ABIs.

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> (Cc:-ing Arnaldo on this as well.)
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > > Mathieu, any update on this? I don't want the LTTNG goodies 
> > > to drop on the floor - we just have to integrate them 
> > > properly.
> > > 
> > > If you 100% disagree with how specific things are done 
> > > upstream right now then don't hold back: just replace 
> > > existing mechanisms - that gives a starting point to discuss 
> > > what the best way is forward.
> > 
> > I'm bringing a though question then: what should we do if I 
> > strongly think that the current ABIs should be replaced ?  To 
> > support this, let's note that the current perf ABI:
> > 
> >  - lacks versioning information to handle change. [...]
> 
> That's not actually true on *any* level: we are changing, 
> evolving and extending the perf ABIs all the time.

You may be able to evolve and extend the Perf ABI, but the way this ABI
is designed does not allow you to change it in ways that would introduce
ABI incompatibility between versions (the equivalent of a major version
number change).

You're therefore gradually painting yourself in a corner without any
ability to go back and revisit previous decisions, and this is bad
because revisiting those past decisions will be needed to bring in some
LTTng features, because those decisions were taken without having those
features in mind. Supporting a new feature is not always as easy as
"extending a structure" as you seem to imply.

> There's two main API/ABI components:
> 
> 1) the perf syscall which is part of the Linux syscall ABI.
> 
> Individual versions of the ABI have (monotonically increasing) 
> sizes for "struct perf_event_attr" - you can consider these 
> natural ABI versioning.
> 
> So the 'versioning' is not done via some inflexible and ugly, 
> Windows-alike 'explicit ABI version' field, but done via 
> structure sizes and -ENOSYS.

Judging versions as inflexibile and ugly is merely a matter of taste.
However, the inability to do any kind of major change due to the way the
Perf ABI is made has a clear direct impact on the ability to innovate
within this project.

> We've iterated and versioned it numerous times in the past 10 
> kernel releases, in a backwards compatible manner.
> 
> 2) the perf.data file
> 
> The versioning there is capability bitmask based - modelled 
> after ext2/ext3/ext4 capability bitmasks. It's extensible as 
> well.

AFAIU, filesystems have very strict compatibility requirements because
they sit on hard drives for years on live systems that cannot always
easily permit migration between incompatible layouts. Traces don't have
the same constraints (see below),

> 
> I think your concentration on ABIs is missing a very fundamental 
> property of instrumentation:
> 
>   the life-time and persistence of instrumentation data is 
>   typically very short ('days' is already an exception - typical 
>   is minutes, at most hours), and for that reason we havent been 
>   getting much pressure from users to maintain a perf.data ABI - 
>   but we are doing it nevertheless.
> 
> Instrumentation is fundamentally about the 'here and now' and so 
> it fundamentally differs from things like backup formats and 
> database formats. An ABI does not hurt and we are maintaining 
> it, but you are overrating its importance significantly.

I think you are really focusing on a developer use-case, which might be
why you are missing the big picture. How many Linux developers are out
there ? How many Linux system administrators are out there ?  Many, many
more. With all due respect, I'm afraid your definition of "typically" is
limited by your developer-centric vision. So far, I came up with the
following breakdown of use-cases in terms of trace data life-span:

- Long-persistence traces (old traces): for this use-case, a conversion
  phase is usually OK. These long-persistance traces are useful in
  production system monitoring scenarios, and for finding delta in
  execution between different runs of a test suite (for instance). This
  use-case allows format breakage if the old format can be identified by
  a trace converter.
- Short-lived traces (debugging use-case): pretty much anything
  would do, as long as the user-level tool can detect if it understands
  the layout.
- Live traces: we want to minimize the overhead, both on the trace
  producer and on the machine performing the data analysis (which can be
  either the traced machine or a separate host), while still providing a
  live stream of data. This is useful for applications like lttngtop
  (showing a live report of the system) and for production system
  monitoring. In this case, we want the tools to be able to find out if
  they can read the trace format (or report an error, asking for
  upgrade if they can't). Trace conversion is not appropriate in this
  scenario due to the added timing complexity and overhead.

As you will notice, none of these use-cases require a filesystem-alike
bitmask-based compatibility ABI at the trace format level.

Using explicit versioning allows drastic changes to be done when they
are required, in the process allowing a trace converter to be used to
deal with "old" legacy traces, and allowing a live trace
aggregator/analyzer to detect if it can support the live trace stream.


> >    [...] I think shipping the tracer tools within the Linux 
> >    tools/ directory made sense for an initial phase that made 
> >    tracer solutions more popular for kernel developers (and it 
> >    did a great job a that), but if we want to move on to build 
> >    tools that target a wider audience, we should leave the 
> >    tools/ sandbox and create separate projects, with clearly 
> >    defined ABIs, using ABI versioning to manage changes. At 
> >    this point, I think that perf tool shipped within tools/ is 
> >    more than anything a pain for non-kernel-developer users, 
> >    and favors design of sloppy ABIs.
> 
> I think you've thoroughly misunderstood the upstream ABI 
> versioning status quo, which makes your argument out of this 
> world.
> 
> The perf ABIs are well-defined and well-maintained. See an 
> ad-hoc ABI and tool compatibility experiment i made here:
> 
>    [F.A.Q.] perf ABI backwards and forwards compatibility
>    https://lkml.org/lkml/2011/11/8/77

I hope my answer above explains why I think the what perf handles ABI
changes is a terrible choice. In summary:

- Perf is painting itself in a corner, not allowing any ABI breakage,
  only "extensions", which limits integration of features that require
  core changes,
- It's doing so without even needing it: Perf is using an ABI versioning
  scheme designed for filesystems, when it is not in fact driven by the
  same constraints.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
