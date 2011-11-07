Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1KGNwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:52:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65255 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1KGNwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:52:50 -0500
MIME-Version: 1.0
In-Reply-To: <1320667833.18053.24.camel@twins>
References: <20111107110149.GA5177@quad>
	<1320667833.18053.24.camel@twins>
Date: Mon, 7 Nov 2011 13:52:49 +0000
Message-ID: <CABPqkBREaQJk2gK7_Q5zUQhvV=EoxE1__ADw5VsiF-YPQNzeKw@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 12:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-11-07 at 12:01 +0100, Stephane Eranian wrote:
>> +                       /*
>> +                        * scan all possible counters for this event
>> +                        * but use the one with the smallest counter weight,
>> +                        * i.e., give a chance to other less constrained events
>> +                        */
>>                         for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
>>
>> +                               if (test_bit(j, used_mask))
>> +                                       continue;
>> +
>> +                               if (wcnt[j] < min_wcnt) {
>> +                                       min_wcnt = wcnt[j];
>> +                                       wcnt_idx = j;
>> +                               }
>> +                       }
>
> The problem with this is that it will typically hit the worst case for
> Intel fixed-purpose events since the fixed purpose counters have the
> highest counter index and their constraint masks are the heaviest in the
> system ensuring we hit the max loop count on the top loop.
>
Yes, but to avoid this you'd need some form of sorting.
We could also cut down on top loop iterations by caching the weight list
of the events and examining only the weights we do have.

As for the complexity, I think it is mostly bound to the number of
counters rather
than event.

The top loop is about event weights, that's bound by the number of counters.
The middle loop is about the number of events.
The inner loop is about the number of counters.

So I'd expect the complexity to be O(c^2*n)
where c is the number of counters, n the number of events.
But given we limit the number of events to that of counters,
we do have O(c^3).

As for the map_idx, it's there to track the position of each event in the
initial event list. We shuffle events between constrained and unconstrained.
By stashing the map_idx in the hw_perf_event struct we avoid having to
pass around yet another array.

> Then again, with Robert's approach we have to mark all fixed purpose
> thingies as redo and we might hit some weird cases there as well, can't
> seem to get me brain straight on that case though.
>
>
>
