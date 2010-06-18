Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0FRHWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:22:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0FRHWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:22:40 -0400
Subject: Re: [RFC][PATCH 0/8] perf pmu interface
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100618043540.GF5345@nowhere>
References: <20100616160027.590430763@chello.nl>
	 <1276712372.1745.619.camel@laptop>  <20100618043540.GF5345@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 09:22:24 +0200
Message-ID: <1276845744.27822.1465.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 06:35 +0200, Frederic Weisbecker wrote:

> > Another idea I was kicking about was to push find_get_context()
> > partially into struct pmu, so that we can have context's per pmu.
> > 
> > For cpu-wide contexts its easy, for per-task contexts we need more
> > pointers in task_struct, so I was thinking of something like:
> > 
> > enum {
> >   perf_swevent_context = 0,
> >   perf_cpu_context,
> > #ifdef HW_BREAKPOINT
> >   perf_bp_context,
> > #endif
> >   perf_nr_task_context
> > };
> > 
> > struct task_struct {
> >   ...
> >   struct perf_event_context *perf_event_ctxs[perf_nr_task_context];
> >   ...
> > };
> > 
> > and have add for loops over the struct pmu list for the cpu-wide
> > contexts and for loops over perf_nr_task_context for the task contexts.
> > 
> > It would add some extra code to the hot-paths, but its the best I can
> > come up with.
> 
> 
> I'm not sure what you mean. Would that be to optimize the start_txn / commit_txn ?
> Then that sounds a good idea. 

Not really, its for pmu_disable/enable, because if you know what pmu is
associated with the context, you can easily disable/enable it while
you're operating on it for doing the lazy machine writes.

It also solves another problem, we currently stop adding new events to a
context on the first failure, this gives very odd effect with software
events which are always schedulable.

If we were to add another hardware pmu the story would get even more
complex, since you could easily get into the situation where one pmu
would still be empty but the other is full and stop adding counters.

> But you'd only need two groups I think:
> 
> enum {
>    perf_swevent_context = 0,
>    perf_cpu_context,
>    perf_nr_task_context
> };
> 
> 
> As only the cpu pmu needs the txn game, at least for now.

Well yeah, but breakpoint really should be a hardware pmu
implementation.

> It seems that would drop the ability to gather hardware and software
> events in a same group though.

Almost, we could allow mixing software events with any hardware event in
a group, but disallow mixing hardware events from different pmus.

The only tricky bit is when the group-leader is a sofrware event, but we
could migrate to the hardware context on adding the first hardware
event.


