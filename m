Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1KNO0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:26:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60092 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1KNO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <1321279937.1421.18.camel@twins>
References: <20111107110149.GA5177@quad>
	<20111110180308.GD15738@erda.amd.com>
	<CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
	<1321279937.1421.18.camel@twins>
Date: Mon, 14 Nov 2011 15:26:02 +0100
Message-ID: <CABPqkBSc-o+ysZEVx72acE7+AY8fLR8sqFDedKBwh8H60Z77cQ@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's take Robert's example:
   c0 c1 c2
 e0 x     x
 e1    x  x
 e2 x  x

The nodes in the graph:

- S (starting point)
- T (the ending point)
- e0, e1, e2 (the events)
- c0, c1, c2 (the counters)

There is an edge from the source to all the events.
There is an edge from all the counters to the sync.
There is an edge between an event and a counter, if
it can count the event.

The capacity of any edge is 1.

The max flow algorithm returns the maximum number of
events that can be measured together. If max_flow ==
number of events, we maxed out.

To find the assignment, we simply need to inspect the
outgoing edges from events and use the only edge which
has a flow == 1.

If we list all the edges for the example above, we have:
S -> e0
S -> e1
S -> e2
e0 -> c0
e0 -> c2
e1 -> c1
e1 -> c2
e2 -> c0
e2 -> c1
c0 -> T
c1 -> T
c2 -> T

then we do max_flow(S, T), Here we find 3.

Given the capacity is either 0 or 1, I think we could use
bitmasks to describe the edges.

On Mon, Nov 14, 2011 at 3:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-11-14 at 13:55 +0100, Stephane Eranian wrote:
>> I have been talking with co-workers experts in operational research
>> about our problem. They all pointed to me to the max flow algorithm from
>> Ford-Fulkerson (search for it on Wikipedia). I think it solves the complexity
>> and recursion problems. My understanding is that the complexity is also
>> more under control.
>
> How would you apply this algorithm to the problem at hand? I'm probably
> missing the obvious thing here, but if we want the flow to be the number
> of assigned counter then we end up with nodes being the various
> permutations of assignments or so, which isn't helpful since that'd be
> n! nodes.
>
>
>
