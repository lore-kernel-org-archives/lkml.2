Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1KPK2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:28:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56977 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1KPK2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:28:43 -0500
MIME-Version: 1.0
In-Reply-To: <1321306989.1421.42.camel@twins>
References: <20111107110149.GA5177@quad>
	<20111110180308.GD15738@erda.amd.com>
	<CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
	<1321279937.1421.18.camel@twins>
	<CABPqkBSc-o+ysZEVx72acE7+AY8fLR8sqFDedKBwh8H60Z77cQ@mail.gmail.com>
	<1321286406.1421.30.camel@twins>
	<CABPqkBTJU5PWpLq3en3sECiAK2AvgLoR+AVqRoZmfNpp_bM_Ug@mail.gmail.com>
	<1321306989.1421.42.camel@twins>
Date: Wed, 16 Nov 2011 11:28:42 +0100
Message-ID: <CABPqkBQ12CbW4c01gZyfU9D7wzNohgVpi9zKobKArU_LRfFooA@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 10:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-11-14 at 18:39 +0100, Stephane Eranian wrote:
>> On Mon, Nov 14, 2011 at 5:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2011-11-14 at 15:26 +0100, Stephane Eranian wrote:
>> >> There is an edge from the source to all the events.
>> >> There is an edge from all the counters to the sync.
>> >> There is an edge between an event and a counter, if
>> >> it can count the event.
>> >>
>> >> The capacity of any edge is 1.
>> >
>> > Ah indeed.
>> >
>> > So that gives:
>> >
>> >  E = e+e*c+c ~= O(c^2); since e<=c
>> >  V = 2+e+c   ~= O(c)
>> >
>> > Then going by:
>> >
>> > http://en.wikipedia.org/wiki/Maximum_flow_problem
>> >
>> > we have to stay away from Edmonds-Karp.
>> >
>> > Ford-Fulkerson would end up being O(E * c) = O(c^3), since max |f| is c.
>> > Which is pretty much identical to all these O(V^2 E) = O(c^3) as well.
>> >
>> > Dinitz blocking flow with dynamic trees looks more interesting at O(c^2
>> > log(c)). Push relabel with dynamic trees looks to be best at O(c^2),
>> > since V^2/E ends up being c^2/c^2 = 1.
>> >
>> > Creating the graph itself will be O(c^2) as well, due to E.
>> >
>> I think we are in the special case of a bi-partite graph with unit capacities,
>> thus the complexity can be reduced even more.
>>
>> See Special Cases in http://en.wikipedia.org/wiki/Dinic%27s_algorithm
>
> Yeah, I found that, but that still reduces to O(c^2.5) which is over the
> O(c^2) of Push relabel with dynamic trees.
>
> I haven't managed to wrap my head around this stuff well enough to even
> start to have an idea if this constraint (bi-partite and unit
> capacities) will have any considerable effect on the other algorithms.
>
> Also, we don't need an exhaustive max flow solution, any flow that's
> high enough to fit the required capacity will do, this too could
> possibly be used to lower the (average) complexity bound.
>
> I would really really like it to not average to O(n^3), that's just
> silly expensive.
>
> Also, do you have any objections to me merging Roberts stuff (provided
> it passes review etc.) while you poke at alternative solutions? We can
> always replace the stuff again if we find anything that works better.
>
I don't have objections to Robert's patch. It will take a bit of time to come
up with a good implementation of those max_flow algorithms.
