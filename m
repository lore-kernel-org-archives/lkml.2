Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0EJJlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:41:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40744 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0EJJlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:41:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pH2xUl69m2EfZEi7qEPJ3QW5LOtP65riBquEJiEblnRfShtrrXaGNJAEg8E5vDzxv
	pL669Yq8O2hW4MagwFzSw==
MIME-Version: 1.0
In-Reply-To: <1273230948.1642.351.camel@laptop>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins> <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop> <1273220736.1642.318.camel@laptop>
	 <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
	 <1273226796.1642.333.camel@laptop>
	 <AANLkTimguldif-yCpPIPC65RL5bvp-HARuuhOHarxIf1@mail.gmail.com>
	 <1273230948.1642.351.camel@laptop>
Date: Mon, 10 May 2010 11:41:09 +0200
Message-ID: <AANLkTimu41pPmimFK10oQl0_Qh07vc3pJbxwNp-jDtTM@mail.gmail.com>
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
	utilization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 1:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-07 at 12:49 +0200, Stephane Eranian wrote:
>> You'd have to insert all event into the tree, read leftmost.
>> I believe you need more than just basic integer arithmetic
>> to compare s_i to avg. Or you need to tweak the values
>> to get more precisions. But you may already be doing that
>> elsewhere in the kernel.
>
> I've got a modification to CFS which implements EEVDF which needs
> similar eligibility checks. So yeah, I've got code to do this.
>
> The trick to computable avg is to keep a monotonic min_s around and use
> ds_i = s_i - min_s. These ds_i will be 'small', in the order of the max
> lag.
>
> We can thus keep a sum of ds_i up-to-date when inserting/removing events
> from the tree without fear of overflowing our integer.
>
> When we update min_s, we must also update our relative sum
> proportionally and in the opposite direction.
>
> Comparing for eligibility can be done by:
>
> s_i < 1/n \Sum s_i, or s_i - min_s < 1/n \Sum s_i - min_s, which we can
> write as: n*ds_i < \Sum ds_i
>
> Again, this can be done without fear of overflows because ds_i is small.
>
Ok, that's what I thought. You had that for the scheduler.

Looks like a good solution, at least better than what is there right now.

>> Yes. Not clear how you could avoid this without having a global
>> view of the dependencies between events (which are really event
>> groups, BTW). Here you'd need to know that if you have
>> evt   A  B  C
>> s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, fail on B
>> s(1)  1   0  0 -> avg = 1/3=0.33, sort = B, C, A, schedule B, fail on C
>>
>> You'd have two options:
>>    s(2)  1   1  0 -> avg = 2/3=0.66, sort = C, A, B, schedule A, C
>> or
>>    s(2)  1   1  0 -> avg = 2/3=0.66, sort = C, B, A  schedule C
>>
>> The first is more attractive because it shortens the blind spots on C.
>> Both are equally fair, though. Looks like you'd need to add a 2nd
>> parameter to the sort when s_i are equal. That would have to be
>> related to the number of constraints. You could  sort in reverse order
>> to the number of constraints, assuming you can express the constraint
>> as a number. For simple constraints, such as counter restrictions, you
>> could simply compare the number of possible counters between events.
>> But there are PMU where there is no counter constraints but events are
>> incompatible. What values do you compare  in this case?
>
> Not sure, but yeah, using constraint data to tie break is indeed an
> interesting option.
>
> I wonder how much tie breaking we'll really need in practice though, if
> we use event->total_time_running as our s_i we've got ns resolution
> timestamps, and with sub jiffies preemption like is common I doubt we'll
> actually see a lot equal service numbers.
>
I suspect you are right. I would not worry about this now. This can be
fixed later if it turns out to be problematic in corner cases.
