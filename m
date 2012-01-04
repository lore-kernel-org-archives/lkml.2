Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2ADVXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:23:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:45626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2ADVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:23:34 -0500
Subject: Re: perf_events: proposed fix for broken intr throttling (repost)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, gleb@redhat.com,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
In-Reply-To: <20120104143945.GA4783@quad>
References: <20120104143945.GA4783@quad>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 22:24:58 +0100
Message-ID: <1325712298.3084.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 15:39 +0100, Stephane Eranian wrote:

> In running some tests with 3.2.0-rc7-tip, I noticed unexpected throttling
> notification samples. I was using fixed period with a long enough period
> that I could not possibly hit the default limit of 100000 samples/sec/cpu.
> 
> I investigated the matter and discovered that the following commit
> is the culprit:
> 
> commit 0f5a2601284237e2ba089389fd75d67f77626cef
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Nov 16 14:38:16 2011 +0100
> 
>     perf: Avoid a useless pmu_disable() in the perf-tick
> 
> 
> The throttling mechanism REQUIRES that the hwc->interrupt counter be reset
> at EACH timer tick. This is regardless of the fact that the counter is in fixed
> period or frequency mode. The optimization introduced in this patch breaks this
> by avoiding calling perf_ctx_adjust_freq() at each timer tick. For events with
> fixed period, it would not adjust any period at all BUT it would reset the
> throttling counter.
> 
> Given the way the throttling mechanism is implemented we cannot avoid doing
> some work at each timer tick. Otherwise we loose many samples for no good
> reasons.
> 
> One may also question the motivation behind checking the interrupt rate at
> each timer tick rather than every second, i.e., average it out over a longer
> period.

That also allows your system to be dead for longer..

> I see two solutions short term:
>    1 - revert the commit above
>    2 - special case the situation with no frequency-based sampling event
> 
> I have implemented solution 2 with the draft fix below. It does not invoke
> perf_pmu_enable()/perf_pmu_disable().  I am not clear on whether or not this
> is really needed in this case. Please advise.

I don't think it needs that, I do dislike the unconditional iterate all
events thing though. Maybe we can set some per-cpu state indicating
someone got throttled (rare under normal operation -- you'd hope) and
only iterate to unthrottle when we find this set.

I think the event scheduling resulting from migration will already
re-enable the event, avoiding the loss of unthrottle due to that..
although it would be good to verify that.

