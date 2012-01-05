Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2AENIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:08:44 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38370 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab2AENIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:08:43 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBQ_MFdi1gc7Tje=u0n+RLd1gzo1mHb9e6i20T8JPNrpwA@mail.gmail.com>
References: <20120104143945.GA4783@quad>
	<1325712298.3084.5.camel@laptop>
	<CABPqkBSR4a7PCyYxhE0kpepc3f0f6Rh6JU55_A3ubWYnN+G3iA@mail.gmail.com>
	<1325717396.3084.12.camel@laptop>
	<CABPqkBQ_MFdi1gc7Tje=u0n+RLd1gzo1mHb9e6i20T8JPNrpwA@mail.gmail.com>
Date: Thu, 5 Jan 2012 13:08:41 +0000
Message-ID: <CABPqkBR2PmqVUF2XmTouLy5jDiDhFVgzBvcaMw-NqEksVjYg_w@mail.gmail.com>
Subject: Re: perf_events: proposed fix for broken intr throttling (repost)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, gleb@redhat.com,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I looked into this some more this morning. I don't think your proposed
scheme can work.
Unless, I misunderstood you, you were suggesting that we could perhaps
use a lazy
approach in perf_event_task_tick() and walk the event list only when
we have, at least,  one
event to unthrottle, i.e., similar to what is done with nr_freq. That
cannot work. The problem is
that you'd let all events get throttled before you'd unthrottle them
in the next timer tick.
At each overflow, hwc->interrupt would get incremented until it
reached MAX_INTERRUPTS.
Then, the event would be stopped (throttled), you'd do
ctx->nr_throttled = 1. At the next
timer tick, perf_event_task_tick() would then unthrottle the event. In
that scheme, the
event would be throttled for at most a tick. But in fact, the event
never generated that
many overflows/tick to justify throttling.

I think there is no other way than what I suggested in my initial email:
  1- revert the nr_freq optimization
  2- reset hwc->interrupt on all events at each tick

Do you have a better idea?

On Wed, Jan 4, 2012 at 11:02 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Jan 4, 2012 at 10:49 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2012-01-04 at 21:33 +0000, Stephane Eranian wrote:
>>> > I don't think it needs that, I do dislike the unconditional iterate all
>>> > events thing though. Maybe we can set some per-cpu state indicating
>>> > someone got throttled (rare under normal operation -- you'd hope) and
>>> > only iterate to unthrottle when we find this set.
>>> >
>>> Could try that too.
>>>
>>> > I think the event scheduling resulting from migration will already
>>> > re-enable the event, avoiding the loss of unthrottle due to that..
>>> > although it would be good to verify that.
>>> >
>>> Yes, you're not dead forever, but still it is not acceptable as is.
>>
>> Oh for sure, I didn't mean it like that. What I was getting at is a
>> counter getting throttled on one cpu, setting the per-cpu variable,
>> getting migrated and not getting unthrottled due to now living on
>> another cpu which doesn't have the per-cpu thing set.
>>
> Yes, that is true.
> I think that throttled counter needs to live in ctx and not per-cpu.
