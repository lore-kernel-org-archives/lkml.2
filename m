Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0LITRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:17:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52645 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0LITRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:17:23 -0500
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291702522.3678.138.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	 <1291702522.3678.138.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 20:17:02 +0100
Message-ID: <1291922222.6803.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 14:15 +0800, Lin Ming wrote:
> On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> > +
> > +static int
> > +uncore_perf_event_set_period(struct perf_event *event)
> > +{
> > +	struct hw_perf_event *hwc = &event->hw;
> > +	s64 left = local64_read(&hwc->period_left);
> > +	s64 period = hwc->sample_period;
> > +	u64 max_period = (1ULL << UNCORE_CNTVAL_BITS) - 1;
> > +	int ret = 0, idx = hwc->idx;
> > +
> > +	/*
> > +	 * If we are way outside a reasonable range then just skip forward:
> > +	 */
> > +	if (unlikely(left <= -period)) {
> > +		left = period;
> > +		local64_set(&hwc->period_left, left);
> > +		hwc->last_period = period;
> > +		ret = 1;
> > +	}
> > +
> > +	if (unlikely(left <= 0)) {
> > +		left += period;
> > +		local64_set(&hwc->period_left, left);
> > +		hwc->last_period = period;
> > +		ret = 1;
> > +	}
> > +
> > +	if (left > max_period)
> > +		left = max_period;
> > +
> > +	/*
> > +	 * The hw event starts counting from this event offset,
> > +	 * mark it to be able to extra future deltas:
> > +	 */
> > +	local64_set(&hwc->prev_count, (u64)-left);
> 
> All uncore pmu interrupts from a socket are routed to one of the four
> cores, so local64_set seems not correct here.
> 
> But hwc->prev_count is defined as local64_t, any idea how to set it
> correctly?
> 
> Or is it OK if local64_set is always executed in the same cpu?

Yes, the local_t bits work as expected when its always accessed by the
same cpu.
