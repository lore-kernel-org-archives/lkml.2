Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1LSPbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:31:01 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48731 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515Ab1LSPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:30:59 -0500
Date: Mon, 19 Dec 2011 10:30:54 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [lttng-dev] [PATCH 09/11] sched: export task_prio to GPL
	modules
Message-ID: <20111219153053.GA21548@Krystal>
References: <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com> <1322776568.4699.52.camel@twins> <20111201221404.GC3365@kroah.com> <1322780830.4699.62.camel@twins> <20111201231751.GA4961@kroah.com> <20111205141749.GC28866@elte.hu> <20111206214446.GD1247@kroah.com> <20111208052354.GC9485@elte.hu> <20111208232709.GA19820@kroah.com> <20111219104915.GA19861@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20111219104915.GA19861@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:23:33 up 621 days, 13 min,  4 users,  load average: 1.81,
	3.06, 2.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Dec 08, 2011 at 06:23:54AM +0100, Ingo Molnar wrote:
[...]
> > > There's a highly constructive, open attitude towards LTTNG and 
> > > has been for years:
> > > 
> > >  " Mathieu, please split it up and integrate/unify it with the 
> > >    existing instrumentation features of Linux - and if it 
> > >    replaces existing stuff because an LTTNG component is 
> > >    superior then so be it. "
> > 
> > Ok, that's fair enough.
> > 
> > Mathieu, will you please work on this?  Or is there some 
> > reason you don't feel this is possible?
> 
> Mathieu, any update on this? I don't want the LTTNG goodies to 
> drop on the floor - we just have to integrate them properly.
> 
> If you 100% disagree with how specific things are done upstream 
> right now then don't hold back: just replace existing mechanisms 
> - that gives a starting point to discuss what the best way is 
> forward.

I'm bringing a though question then: what should we do if I strongly
think that the current ABIs should be replaced ?  To support this, let's
note that the current perf ABI:

 - lacks versioning information to handle change. I think shipping the tracer
   tools within the Linux tools/ directory made sense for an initial
   phase that made tracer solutions more popular for kernel developers
   (and it did a great job a that), but if we want to move on to build
   tools that target a wider audience, we should leave the tools/ sandbox
   and create separate projects, with clearly defined ABIs, using ABI
   versioning to manage changes. At this point, I think that perf tool
   shipped within tools/ is more than anything a pain for
   non-kernel-developer users, and favors design of sloppy ABIs.

 - makes it impossible to move to CTF (Common Trace Format) and benefit
   from the added features it allows,

 - makes it needlessly hard, if not impossible, for perf to move to
   something that would have the benefits brought by the fast unified
   ring buffer code I created 2 years ago,

 - makes it impossible to benefit from the LTTng fast trace clocks.

Also, it should be noted that I am finding that the way perf evolved
into a large monolithic binary blob that needs to be all enabled or all
disabled makes it quite hard to extend and re-use. As a matter of fact,
there are various cases where Steven and I tried to create performance
tests for the perf ring buffer and just could not do it without hacking
the perf code. I would definitely prefer to go for a modular approach for
the in-kernel code, and an approach based on user-level libraries for
low-level tracer interaction, with applications depending on those
libraries, again all handled with ABI versioning and library versioning.

I have to give recognition to perf: it's a fantastic performance counter
management/sampling tool, but it has clearly never been geared towards
low-overhead tracing, and this shows.

One possible way for moving things forward is to leave the current
perf/ftrace implementation and ABIs in place along with the existing
tools. We could create a new ABI merging perf, ftrace and LTTng best
features into one (e.g. kstrace for Kernel System Trace -- just made it
up, better ideas are welcome), and gradually move the user-space part of
the 3 tools to the new ABI. It is worth noting that the need for a new
ABI is something many people involved in tracing -- by that I mean those
doing most of the actual upstream tracer implementation work -- agreed
upon in the last 2 years when meetings at conferences. This would allow
a deprecation phase to take place, and would allow removal of the
maintenance burden of the duplicated Perf/Ftrace ABIs, all that while
also bringing in an ABI that allows handling of change and innovation,
which is, IMHO, the key limiting factor of the current ABIs.

By doing so, perf could become the set of tools targeting what it does
best: performance counters management and sampling, ftrace could keep on
targeting function tracing, and lttng could be used for all-system
tracing, everyone sharing the same kernel-level implementation and ABIs
(kstrace ABI).

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
