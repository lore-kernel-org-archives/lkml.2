Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1ADL7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:59:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:34830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1ADL7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:59:06 -0500
Subject: Re: [PATCH 7/7] perf: Add load latency monitoring on Intel
 Nehalem/Westmere v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1293464397.2695.109.camel@localhost>
References: <1293464397.2695.109.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 12:59:21 +0100
Message-ID: <1294142361.2016.131.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 23:39 +0800, Lin Ming wrote:

> +/*
> + * Load latency data source encoding
> + */
> +
> +/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached} */
> +#define LD_LAT_L1			0x00
> +#define LD_LAT_L2			0x01
> +#define LD_LAT_L3			0x02
> +#define LD_LAT_RAM			0x03
> +#define LD_LAT_UNKNOWN			0x00
> +#define LD_LAT_IO			0x01
> +#define LD_LAT_UNCACHED			0x02
> +
> +/* Bits(2-3) {not-used, snoop, local, remote} */
> +#define LD_LAT_NOT_USED			(0x00 << 2)
> +#define LD_LAT_SNOOP			(0x01 << 2)
> +#define LD_LAT_LOCAL			(0x02 << 2)
> +#define LD_LAT_REMOTE			(0x03 << 2)
> +
> +/* Bits(4-5) {modified, exclusive, shared, invalid} */
> +#define LD_LAT_MODIFIED			(0x00 << 4)
> +#define LD_LAT_EXCLUSIVE		(0x01 << 4)
> +#define LD_LAT_SHARED			(0x02 << 4)
> +#define LD_LAT_INVALID			(0x03 << 4)
> +
> +#define LD_LAT_RESERVED			0x3F

Hmm, why is that RESREVED? From what I can see that ends up being:
  RAM-remote-invalid

Which brings us to the NOT_USED thing, from what I can see its the value
that toggles between {L1, L2, L3, RAM} and {unknown, IO, uncached},
that's not NOT_USED.

There's still room for a {reserved} value in that alternative set,
making it: {unknown, IO, uncached, reserved}

Which would make

#define EXTRA_SRC_RESERVED 0x03


> @@ -384,6 +387,10 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
>  		if (extra & ~er->valid_mask)
>  			return -EINVAL;
>  		event->hw.extra_config = extra;
> +
> +		/* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
> +		if (er->msr == MSR_PEBS_LD_LAT_THRESHOLD && extra < 3)
> +			event->hw.extra_config = 3;
>  		break;
>  	}
>  	return 0;

I'm not really sure about this, should we silently fix up or bail on
invalid values?

> +/* Indexed by Intel load latency data source encoding value */
> +
> +static u64 intel_load_latency_data[] = {
> +	LD_LAT_UNKNOWN,					/* 0x00: Unknown L3 */
> +	LD_LAT_L1 | LD_LAT_LOCAL,			/* 0x01: L1-local */
> +	LD_LAT_L2 | LD_LAT_SNOOP,			/* 0x02: L2-snoop */

I bet Stephane wants to argue more on this ;-)

> +	LD_LAT_L2 | LD_LAT_LOCAL,			/* 0x03: L2-local */
> +	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_INVALID,	/* 0x04: L3-snoop, no coherency actions */
> +	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_SHARED,	/* 0x05: L3-snoop, found no M */
> +	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_MODIFIED,	/* 0x06: L3-snoop, found M */
> +	LD_LAT_RESERVED,				/* 0x07: reserved */
> +	LD_LAT_RAM | LD_LAT_SNOOP | LD_LAT_SHARED,	/* 0x08: L3-miss, snoop, shared */
> +	LD_LAT_RESERVED,				/* 0x09: reserved */
> +	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_SHARED,	/* 0x0A: L3-miss, local, shared */
> +	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_SHARED,	/* 0x0B: L3-miss, remote, shared */
> +	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_EXCLUSIVE,	/* 0x0C: L3-miss, local, exclusive */
> +	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_EXCLUSIVE,	/* 0x0D: L3-miss, remote, exclusive */
> +	LD_LAT_IO,					/* 0x0E: IO */
> +	LD_LAT_UNCACHED,				/* 0x0F: Uncached */
> +};


> @@ -541,14 +567,10 @@ static int intel_pmu_save_and_restart(struct perf_event *event);
>  static void __intel_pmu_pebs_event(struct perf_event *event,
>  				   struct pt_regs *iregs, void *__pebs)
>  {
> -	/*
> -	 * We cast to pebs_record_core since that is a subset of
> -	 * both formats and we don't use the other fields in this
> -	 * routine.
> -	 */
> -	struct pebs_record_core *pebs = __pebs;
> +	struct pebs_record_nhm *pebs = __pebs;


So you cast to the biggest and make sure you don't peek past the end of
the actual data.. that might want to have a comment.


> @@ -556,6 +578,19 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	perf_sample_data_init(&data, 0);
>  	data.period = event->hw.last_period;
>  
> +	if (event->hw.extra_reg == MSR_PEBS_LD_LAT_THRESHOLD) {

This is what stops us from peeking past the end of the pebs record,
since core would never end up having the LD_LAT extra_reg.

> +		sample_type = event->attr.sample_type;
> +
> +		if (sample_type & PERF_SAMPLE_ADDR)
> +			data.addr = pebs->dla;
> +
> +		if (sample_type & PERF_SAMPLE_LATENCY)
> +			data.latency = pebs->lat;
> +
> +		if (sample_type & PERF_SAMPLE_LATENCY_DATA)
> +			data.latency_data = intel_load_latency_data[pebs->dse];


> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d24d9ab..9428a1b 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -124,9 +124,11 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_CPU				= 1U << 7,
>  	PERF_SAMPLE_PERIOD			= 1U << 8,
>  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
> -	PERF_SAMPLE_RAW				= 1U << 10,
> +	PERF_SAMPLE_LATENCY			= 1U << 10,
> +	PERF_SAMPLE_LATENCY_DATA		= 1U << 11,
> +	PERF_SAMPLE_RAW				= 1U << 12,
>  
> -	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
>  };
>  
>  /*
> @@ -958,6 +960,8 @@ struct perf_sample_data {
>  	}				tid_entry;
>  	u64				time;
>  	u64				addr;
> +	u64				latency;
> +	u64				latency_data;
>  	u64				id;
>  	u64				stream_id;
>  	struct {

Right, so I think I want this in 3 patches, one adding the load-latency
extra reg thing and PERF_SAMPLE_ADDR usage, one adding
PERF_SAMPLE_LATENCY and one adding PERF_SAMPLE_EXTRA, I really dislike
the LATENCY_DATA name since that ties the extra data to the latency
thing, which isn't at all true for other platforms.


