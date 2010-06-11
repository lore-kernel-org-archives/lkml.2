Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518Ab0FKVBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:01:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38451 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0FKVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rMv4DxRpGMF5UcA8b4GN12PqOAu8prU6Sio1D3MsV3/913DqPpv+rHwXsRfri7R8m+
         WzJTEa2+E64oZwuSv+fECrWC7PuGlRMX5IigTeTdWyZW+APMy0EXNY9VlV1EHglv+B1v
         AcZGzR9p/u67r4BvHrsNjX1si++V7hYNDo0+o=
Date: Fri, 11 Jun 2010 23:01:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_disable()
Message-ID: <20100611210137.GB5234@nowhere>
References: <1276273784.2077.2055.camel@twins> <20100611171732.GA5234@nowhere> <1276288180.2077.2299.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276288180.2077.2299.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:29:40PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-06-11 at 19:17 +0200, Frederic Weisbecker wrote:
> > I suspect the problem is also on per context integrity. When you adjust
> > the period, enable or disable a counter, this counter becomes async with
> > the rest of the group or the rest of the counters in the same context, for
> > a small bunch of time.
> > 
> > The longer you run your events, the higher is going to be this jitter.
> > 
> > Take an example, when you adjust a period, you:
> > 
> > perf_disable()
> > perf_event_stop()
> > left_period = 0
> > perf_event_start()
> > perf_enable()
> > 
> > During all this time, the given event is paused, but the whole rest of
> > the events running on the cpu continue to count.
> > 
> > The problem is the same on context switch.
> > 
> > And I think this high resolution of synchronisation per context is
> > sensitive, especially with perf start kind of workflows.
> 
> I'm not sure what you're arguing, but the knife cuts on both sides, the
> above also stops counters that shouldn't be stopped..


Hmm, now that I look at it, x86_pmu_*able_all() isn't touching a
single register to *able everything at once, it's doing a loop
on every events.

Forget about what I said then.

 
> > > There is a fun little recursion issue with perf_adjust_period(), where
> > > if we fully removed perf_disable() we could end up calling pmu::stop()
> > > twice and such.
> > > 
> > > But aside from that it looks to me its mostly about optimizing hardware
> > > writes.
> > > 
> > > If nobody else known about/can find anything, I'm going to mostly remove
> > > perf_disable() for now and later think about how to optimize the
> > > hardware writes again.
> > 
> > 
> > Not sure that's a good idea IMHO.
> 
> Well, we need to do something, the current weak mess needs to go, and
> the alternative is basically a loop over all registerd pmus calling
> their respective pmu::disable_all, which is utter suckage, so removing
> as many of this as possible is a good thing.
> 
> We can always come up with some lazy mode later that tries to batch the
> hardware writes.


Right.

