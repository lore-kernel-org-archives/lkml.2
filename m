Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1LWSQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:16:45 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41714 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757574Ab1LWSQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:16:44 -0500
Date: Fri, 23 Dec 2011 13:16:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Perf ABI (was: Re: [lttng-dev] [PATCH 09/11] sched: export
	task_prio to GPL modules)
Message-ID: <20111223181641.GA12681@Krystal>
References: <20111201231751.GA4961@kroah.com> <20111205141749.GC28866@elte.hu> <20111206214446.GD1247@kroah.com> <20111208052354.GC9485@elte.hu> <20111208232709.GA19820@kroah.com> <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal> <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal> <20111223172155.GA14117@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223172155.GA14117@thunk.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:49:16 up 394 days, 22:52,  6 users,  load average: 0.19, 0.10,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

* Ted Ts'o (tytso@mit.edu) wrote:
> On Fri, Dec 23, 2011 at 11:46:29AM -0500, Mathieu Desnoyers wrote:
> > - It's doing so without even needing it: Perf is using an ABI versioning
> >   scheme designed for filesystems, when it is not in fact driven by the
> >   same constraints.
> 
> Well, there are *some* constraints.  I've been assured that despite
> the fact that the perf client is in the kernel sources (something
> which I still think is a bad idea, since it's leading to other bad
> choices like kvm-tool wanting to be bundled with kernel sources), that
> it is *not* a license to jerk the format around wildly --- that people
> will have installed userspace binaries that shouldn't randomly break
> they boot a new kernel.
> 
> So I'm *glad* that Perf is using an ABI versioning scheme that accepts
> the same restraints as file systems.  It means we don't randomly break
> userspace tools.
> 
> So Mathieu, if you think it is the current standards of backwards
> compatibility are too rigid, what level of tool breakage do you think
> is acceptable?  It's not just about the backwards compatibility of the
> trace files, it's also about compatibility of userspace utilities.
> 
> For example, systemtap, where you had to recompile from source at
> each kernel revision, and pray it would still build goes too far in
> the other direction, wouldn't you agree?  What is the correct level of
> kernel developer annoyance you think is appropriate to inflict on
> ourselves?

I completely agree that systemtap did not have the right level of
compatibility towards changes. It clearly does not make sense to require
the tools to be updated whenever the kernel version and instrumentation
changes. What makes sense to me, though, is to allow breakage when a
newly introduced tracer feature requires the ABI to break.

What I currently see as a tradeoff sweet-spot between compatibility
burden and ability to innovate is to split the ABI and handle
compatibility as follows:

- ABIs to control the tracer
  - Versioned, ideally always incrementally adding features, but still
    keeping room for major changes if needed. We should expect very,
    very seldom breakages on this front. This requires update of tracer
    control tools when the ABI is broken.

- ABIs to transport tracing data
  - Versioned, can and should change when a feature or transport
    performance enhancement require to break compatibility. This
    requires update of trace data consumer tools when compability is
    broken.

(note that ABI to control the tracer and ABI to transport data could
share the same version numbering if the control tools and transport
tools happen to reside in the same user-level packages)

- The trace data format
  - Both versioned _and_ self-described.
  Self-description of the event/field layout allows the same tools to
  understand traces gathered on different kernel versions, on different
  architectures, with different tracer configurations.
  Versioning on top of the self-described trace format allows changes
  to what the trace self-description can express.

So the breakages would happen only when required by tracer tool
capability enhancements, not randomly when a kernel instrumentation
source happens to change.

Best regards,

Mathieu

P.S.: my next replies will be slightly delayed, due to Christmas
holidays.

> 
> Regards,
> 
> 
> 						- Ted

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
