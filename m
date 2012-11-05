Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2KEU3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab2KEU3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:29:18 -0500
Date: Mon, 5 Nov 2012 17:01:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 03/16] perf, core: Add a concept of a weightened sample
Message-ID: <20121105200147.GB7962@infradead.org>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352123463-7346-4-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 05, 2012 at 02:50:50PM +0100, Stephane Eranian escreveu:
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
>  #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
> @@ -559,6 +562,7 @@ enum perf_event_type {
>  	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
>  	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
>  	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
> +	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
>  	 *
>  	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ

This comes after PERF_SAMPLE_STACK_USER so that perf_evsel__parse_sample
can get it right, isn't it? Or is just the comment wrong?

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index dbccf83..d633581 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -952,6 +952,9 @@ static void perf_event__header_size(struct perf_event *event)
>  	if (sample_type & PERF_SAMPLE_PERIOD)
>  		size += sizeof(data->period);
>  
> +	if (sample_type & PERF_SAMPLE_WEIGHT)
> +		size += sizeof(data->weight);

Here it doesn't matter, we're just computing the sample size, but would
be nice to add this just after the (sample_type &
PERF_SAMPLE_STACK_USER) branch.

> +
>  	if (sample_type & PERF_SAMPLE_READ)
>  		size += event->read_size;
>  
> @@ -4080,6 +4083,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>  	if (sample_type & PERF_SAMPLE_PERIOD)
>  		perf_output_put(handle, data->period);
>  
> +	if (sample_type & PERF_SAMPLE_WEIGHT)
> +		perf_output_put(handle, data->weight);
> +

Yeap, it should go after PERF_SAMPLE_STACK_USER

>  	if (sample_type & PERF_SAMPLE_READ)
>  		perf_output_read(handle, event);
>  
> -- 
> 1.7.9.5
