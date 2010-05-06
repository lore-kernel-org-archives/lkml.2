Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0EFQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:26:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab0EFQ0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:26:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=FvBkVlPnc1fT1ffb3X/tirMlo7uIhDqMpxp5F3kvdmN7mAldTykk7HlQdZvLrsLkw
	7hgV9BLsjrPpmU/dTfXaw==
MIME-Version: 1.0
In-Reply-To: <1273158502.5605.368.camel@twins>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins>
	 <AANLkTilOw0L-Uersi1weuQDuyFAGKV2zb7Nqmiav2kej@mail.gmail.com>
	 <1273158502.5605.368.camel@twins>
Date: Thu, 6 May 2010 18:26:10 +0200
Message-ID: <AANLkTimYaDqoDeqfCukprJSA17FQW_Jbx3Yotaub4k8b@mail.gmail.com>
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
	utilization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 5:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-05-06 at 16:41 +0200, Stephane Eranian wrote:
>> On Thu, May 6, 2010 at 4:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2010-05-06 at 16:03 +0200, Stephane Eranian wrote:
>> >> Hi,
>> >>
>> >> Looking at ctx_flexible_sched_in(), the logic is that if  group_sched_in()
>> >> fails for a HW group, then no other HW group in the list is even tried.
>> >> I don't understand this restriction. Groups are independent of each other.
>> >> The failure of one group should not block others from being scheduled,
>> >> otherwise you under-utilize the PMU.
>> >>
>> >> What is the reason for this restriction? Can we lift it somehow?
>> >
>> > Sure, but it will make scheduling much more expensive. The current
>> > scheme will only ever check the first N events because it stops at the
>> > first that fails, and since you can max fix N events on the PMU its
>> > constant time.
>> >
>> You may fail not because the PMU is full but because an event is incompatible
>> with the others, i.e., there may still be room for more evens. By relying on the
>> RR to get coverage for all events, you also increase blind spots for
>> events which
>> have been skipped. Longer blind spots implies less accuracy when you scale.
>>
>> > To fix this issue you'd have to basically always iterate all events and
>> > only stop once the PMU is fully booked, which reduces to an O(n) worst
>> > case algorithm.
>> >
>>
>> Yes, but if you have X events and you don't know if you have at least N
>> that are compatible with each other, then you have to scan the whole list.
>
> I'm not sure why you're arguing, you asked why it did as it did, I gave
> an answer ;-)
>
yes, you did.

> I agree its not optimal, but fixing it isn't trivial, I would very much
> like to avoid a full O(n) loop over all events, esp since creating them
> is a non-privilidged operation.
>
I understand that.

> So what we can look at is trying to do better, and making it a service
> based scheduler instead of a strict RR should at least get a more equal
> distribution.
>
How would you define "service" here?

> Another thing we can do is quit at the second or third fail.
>
Not sure if this would be any better.
