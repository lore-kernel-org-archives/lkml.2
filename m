Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab0FKU35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:29:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:44482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0FKU3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:29:55 -0400
Subject: Re: perf_disable()
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100611171732.GA5234@nowhere>
References: <1276273784.2077.2055.camel@twins>
	 <20100611171732.GA5234@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 11 Jun 2010 22:29:40 +0200
Message-ID: <1276288180.2077.2299.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 19:17 +0200, Frederic Weisbecker wrote:
> On Fri, Jun 11, 2010 at 06:29:44PM +0200, Peter Zijlstra wrote:
> > Hi,
> > 
> > I've been going over perf_disable() usage in kernel/perf_event.c and
> > wondered if we actually need it at all.
> > 
> > Currently the only thing we seem to require it for is around pmu::enable
> > calls (and for that powerpc at least does it itself, on x86 we rely on
> > it to call ->enable_all and reprogram the pmu state).
> > 
> > But I can't really find any NMI races wrt data structures or the like as
> > seems implied by some comments. 
> 
> 
> 
> I suspect the problem is also on per context integrity. When you adjust
> the period, enable or disable a counter, this counter becomes async with
> the rest of the group or the rest of the counters in the same context, for
> a small bunch of time.
> 
> The longer you run your events, the higher is going to be this jitter.
> 
> Take an example, when you adjust a period, you:
> 
> perf_disable()
> perf_event_stop()
> left_period = 0
> perf_event_start()
> perf_enable()
> 
> During all this time, the given event is paused, but the whole rest of
> the events running on the cpu continue to count.
> 
> The problem is the same on context switch.
> 
> And I think this high resolution of synchronisation per context is
> sensitive, especially with perf start kind of workflows.

I'm not sure what you're arguing, but the knife cuts on both sides, the
above also stops counters that shouldn't be stopped..

> > There is a fun little recursion issue with perf_adjust_period(), where
> > if we fully removed perf_disable() we could end up calling pmu::stop()
> > twice and such.
> > 
> > But aside from that it looks to me its mostly about optimizing hardware
> > writes.
> > 
> > If nobody else known about/can find anything, I'm going to mostly remove
> > perf_disable() for now and later think about how to optimize the
> > hardware writes again.
> 
> 
> Not sure that's a good idea IMHO.

Well, we need to do something, the current weak mess needs to go, and
the alternative is basically a loop over all registerd pmus calling
their respective pmu::disable_all, which is utter suckage, so removing
as many of this as possible is a good thing.

We can always come up with some lazy mode later that tries to batch the
hardware writes.
