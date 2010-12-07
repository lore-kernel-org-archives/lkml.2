Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab0LGGMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:12:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:50261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab0LGGMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:12:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,309,1288594800"; 
   d="scan'208";a="684608221"
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1291267223.2405.314.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 14:15:22 +0800
Message-ID: <1291702522.3678.138.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 13:20 +0800, Lin Ming wrote:
> +
> +static int
> +uncore_perf_event_set_period(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +	s64 left = local64_read(&hwc->period_left);
> +	s64 period = hwc->sample_period;
> +	u64 max_period = (1ULL << UNCORE_CNTVAL_BITS) - 1;
> +	int ret = 0, idx = hwc->idx;
> +
> +	/*
> +	 * If we are way outside a reasonable range then just skip forward:
> +	 */
> +	if (unlikely(left <= -period)) {
> +		left = period;
> +		local64_set(&hwc->period_left, left);
> +		hwc->last_period = period;
> +		ret = 1;
> +	}
> +
> +	if (unlikely(left <= 0)) {
> +		left += period;
> +		local64_set(&hwc->period_left, left);
> +		hwc->last_period = period;
> +		ret = 1;
> +	}
> +
> +	if (left > max_period)
> +		left = max_period;
> +
> +	/*
> +	 * The hw event starts counting from this event offset,
> +	 * mark it to be able to extra future deltas:
> +	 */
> +	local64_set(&hwc->prev_count, (u64)-left);

All uncore pmu interrupts from a socket are routed to one of the four
cores, so local64_set seems not correct here.

But hwc->prev_count is defined as local64_t, any idea how to set it
correctly?

Or is it OK if local64_set is always executed in the same cpu?



