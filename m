Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2AENbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:31:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64619 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932262Ab2AENbc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:31:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120105131908.GH31206@redhat.com>
References: <20120104143945.GA4783@quad>
	<1325712298.3084.5.camel@laptop>
	<CABPqkBSR4a7PCyYxhE0kpepc3f0f6Rh6JU55_A3ubWYnN+G3iA@mail.gmail.com>
	<1325717396.3084.12.camel@laptop>
	<CABPqkBQ_MFdi1gc7Tje=u0n+RLd1gzo1mHb9e6i20T8JPNrpwA@mail.gmail.com>
	<CABPqkBR2PmqVUF2XmTouLy5jDiDhFVgzBvcaMw-NqEksVjYg_w@mail.gmail.com>
	<20120105131908.GH31206@redhat.com>
Date: Thu, 5 Jan 2012 13:31:27 +0000
Message-ID: <CABPqkBTBczzc96zMbvYMG7xQJwxa1nc429XDTPxfc3Rah46Q1g@mail.gmail.com>
Subject: Re: perf_events: proposed fix for broken intr throttling (repost)
From: Stephane Eranian <eranian@google.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, asharma@fb.com, vince@deater.net, wcohen@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 1:19 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Thu, Jan 05, 2012 at 01:08:41PM +0000, Stephane Eranian wrote:
>> Peter,
>>
>> I looked into this some more this morning. I don't think your proposed
>> scheme can work.
>> Unless, I misunderstood you, you were suggesting that we could perhaps
>> use a lazy
>> approach in perf_event_task_tick() and walk the event list only when
>> we have, at least,  one
>> event to unthrottle, i.e., similar to what is done with nr_freq. That
>> cannot work. The problem is
>> that you'd let all events get throttled before you'd unthrottle them
>> in the next timer tick.
>> At each overflow, hwc->interrupt would get incremented until it
>> reached MAX_INTERRUPTS.
>> Then, the event would be stopped (throttled), you'd do
>> ctx->nr_throttled = 1. At the next
>> timer tick, perf_event_task_tick() would then unthrottle the event. In
>> that scheme, the
>> event would be throttled for at most a tick. But in fact, the event
>> never generated that
>> many overflows/tick to justify throttling.
>>
>> I think there is no other way than what I suggested in my initial email:
>>   1- revert the nr_freq optimization
>>   2- reset hwc->interrupt on all events at each tick
>>
> I think my original patch did that: https://lkml.org/lkml/2011/11/15/114
>
Yes, looks like it, because it is systematically calling perf_ctx_adjust_freq()
which does reset the hwc->interrupts counter on ALL events.

But the pmu_disabled trick is not very pretty. We have to find some
middle ground
solution here.
