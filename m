Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0KLODg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:03:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0KLODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EJT81zbcBciF73vvNRiP++0J5JYgZYYxN5107sgTAZ9Jc2jKm6V8rw+xalgD+XPDWl
         wmnke0iffm3cgvfVFJ3A==
MIME-Version: 1.0
In-Reply-To: <1289568077.2084.256.camel@laptop>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<1289492117-18066-2-git-send-email-andi@firstfloor.org>
	<4CDC2DDD.50508@linux.vnet.ibm.com>
	<4CDC3845.4030104@linux.intel.com>
	<4CDC4628.8020109@linux.vnet.ibm.com>
	<20101111194936.GJ18718@basil.fritz.box>
	<1289505587.2084.193.camel@laptop>
	<20101111201259.GL18718@basil.fritz.box>
	<1289507858.2084.195.camel@laptop>
	<20101112102748.GA8020@basil.fritz.box>
	<AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com>
	<1289561817.2084.240.camel@laptop>
	<AANLkTinjzZnv8dzfKPzgGtRnk5C-XsAt=gyf_4G0+gf8@mail.gmail.com>
	<1289568077.2084.256.camel@laptop>
Date: Fri, 12 Nov 2010 15:03:31 +0100
Message-ID: <AANLkTimGjjr2ME5QOP0KV_eR1PD-NPrw5ipYa8-_2skR@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
        paulus <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, Nov 12, 2010 at 2:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2010-11-12 at 14:00 +0100, Stephane Eranian wrote:
>> I don't understand what aspect you think is messy. When you are sampling
>> cache misses, you expect to get the tuple (instr addr, data addr, latency,
>> data source).
>
> Its the data source thing I have most trouble with -- see below. The
> latency isn't immediately clear either, I mean the larger the bubble the
> more hits the instruction will get, so there should be a correlation
> between samples and latency.
>

The latency is the miss latency, i.e., time to bring the cache line back
at the time the miss is detected. That's not because you see a latency
of 20 cycles that you can assume the line came from the LLC cache, it
may have been in-flight by the time the load was issued. In other words,
the latency may not be enough to figure out where the line actually came.

As for the correlation to cycles sampling, they don't point to the same
location. With cycles, you point to the stalled instructions, i.e., where
you wait for the data to arrive. With PEBS-LL (and variations on the
other archs), you point to the missing load instructions. Sometimes
those can be far apart, it depends on the code flow, instruction scheduling
by the compiler and so on. Backtracing from the stall instruction to the
missing load is tricky business especially with branches, interrupts and
such. Some people have tried that in the past.

What you are really after here is identifying load misses which do incur serious
stalls in your program. No single HW feature provides that. But by combining
cache miss and cycle profiles, I think you can get a good handle on this.

Although the latency is a good hint for potential stalls, there is no guarantee.
A miss latency could be completely overlapped with executions. PEBS-LL
(or variations on the other arch) won't report the overlap. You have
to correlate
this with a cycle profiling. However, it you get latencies of > 40 cycles
or more it is highly unlikely the compiler was able to hide that, thus those are
good candidates for prefetching of some sort (assuming you get lots of samples
like these).

>> That is what you get with AMD IBS, Nehalem PEBS-LL and
>> also Itanium D-EAR. I am sure IBM Power has something similar as well.
>> To collect this, you can either store the info in registers (AMD, Itanium)
>> or in a buffer (PEBS). But regardless of that you will always have to expose
>> the tuple. We have a solution for two out of 4 fields that reuses the existing
>> infrastructure. We need something else for the other two.
>
> Well, if Intel PEBS, IA64 and PPC64 all have a data source thing we can
> simply add PERF_SAMPLE_SOURCE or somesuch and use that.
>

Itanium definitively does have data source, so does IBS. Don't know about
PPC64.

> Do IA64/PPC64 have latency fields as well? PERF_SAMPLE_LATENCY would
> seem to be the thing to use in that case.
>
That's fine too.

> BTW, what's the status of perf on IA64? And do we really still care
> about that platform, its pretty much dead isn't it?
>

It is not dead, there is one more CPU in the making if I recall.
I did touch base with Tony Luck last week on this. I think adding
support for the basic counting stuff should be possible. You have
4 counters, with event constraints. Getting the constraints right
for some events is a bit tricky and the constraint may depend on
the other events being measured. I have the code to do this at
the user level. If somebody wants to tackle, I am willing to help.
Otherwise, it will have to wait until I get some more spare time
and access to Itanium Hw again.

>> We should expect that in the future PMUs will collect more than code addresses.
>
> Sure, but I hate stuff that counts multiple events on a single base like
> IBS does, and LL is similar to that, its a fetch retire counter and then
> you report where fetch was satisfied from. So in effect you're measuring
> l1/l2/l3/dram hit/miss all at the same time but on a fetch basis.
>

PEBS-LL is different. You are counting on a single event which is
MEM_LOAD_RETIRED. The threshold is a refinement to filter out
useless misses (threshold can be as low as 4 cycles, L1D latency).
When you sample on this you are only looking a explicit data load
misses. You ignore the code side and prefetches.

You need to wait until the instruction retires to be sure about the
miss latency. So associating this with LLC_MISSES instead would
be harder. By construction, you can also only track one load at a time.

> Note that we need proper userspace for such crap as well, and libpfm
> doesn't count, we need a full analysis tool in perf itself.

I understand that.
