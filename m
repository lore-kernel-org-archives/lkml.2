Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2I1JGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:06:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63761 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab2I1JGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:06:40 -0400
MIME-Version: 1.0
In-Reply-To: <1348806696-31170-19-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	<1348806696-31170-19-git-send-email-andi@firstfloor.org>
Date: Fri, 28 Sep 2012 11:06:38 +0200
Message-ID: <CABPqkBQPVbobTgaV97E0qvOcfWnK8jMmoyp6NEuMn2+WHZ97HQ@mail.gmail.com>
Subject: Re: [PATCH 18/31] perf, core: Add a concept of a weightened sample
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 6:31 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> For some events it's useful to weight sample with a hardware
> provided number. This expresses how expensive the action the
> sample represent was.  This allows the profiler to scale
> the samples to be more informative to the programmer.
>
> There is already the period which is used similarly, but it means
> something different, so I chose to not overload it. Instead
> a new sample type for WEIGHT is added.
>
> Can be used for multiple things. Initially it is used for TSX abort costs
> and profiling by memory latencies (so to make expensive load appear higher
> up in the histograms)  The concept is quite generic and can be extended
> to many other kinds of events or architectures, as long as the hardware
> provides suitable auxillary values. In principle it could be also
> used for software tracpoints.
>
> This adds the generic glue. A new optional sample format for a 64bit
> weight value.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I came to the conclusion that yes we need something like a weight or cost
as a generic way of reporting that in some modes the period is not really
the right measure to evaluate the "cost" of an event.

I was testing my PEBS Load Latency patch this week, I came to that
conclusion. The way perf report sorts samples based on aggregated
periods per IP does not work for PEBS Load Latency (and possibly other
modes). The sorting needs to be based on some cost that may be distinct
from the period. By default, it would be the period, but for PEBS LL that
would be the latency of the load at a specific IP. That would more reflect
was is going on.

I modified my PEBS-LL patchset to  export a PERF_SAMPLE_COST
value instead of PERF_SAMPLE_LATENCY which is more specific. The
idea is similar to your WEIGHT here. By default it would be equal to the
period, except for some modes. Or it could be equal to 1 by default. It
would then be aggregated by IP by perf report as : he->period += period * cost.

At the perf report level, the changes needed are rather limited.

Will post my PEBS-LL patchset on Monday.

> ---
>  include/linux/perf_event.h |    9 +++++++--
>  kernel/events/core.c       |    6 ++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 5bc0e8b..c488ae2 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -130,8 +130,9 @@ enum perf_event_sample_format {
>         PERF_SAMPLE_STREAM_ID                   = 1U << 9,
>         PERF_SAMPLE_RAW                         = 1U << 10,
>         PERF_SAMPLE_BRANCH_STACK                = 1U << 11,
> +       PERF_SAMPLE_WEIGHT                      = 1U << 12,
>
> -       PERF_SAMPLE_MAX = 1U << 12,             /* non-ABI */
> +       PERF_SAMPLE_MAX = 1U << 13,             /* non-ABI */
>  };
>
>  /*
> @@ -190,8 +191,9 @@ enum perf_event_read_format {
>         PERF_FORMAT_TOTAL_TIME_RUNNING          = 1U << 1,
>         PERF_FORMAT_ID                          = 1U << 2,
>         PERF_FORMAT_GROUP                       = 1U << 3,
> +       PERF_FORMAT_WEIGHT                      = 1U << 4,
>
> -       PERF_FORMAT_MAX = 1U << 4,              /* non-ABI */
> +       PERF_FORMAT_MAX = 1U << 5,              /* non-ABI */
>  };
>
>  #define PERF_ATTR_SIZE_VER0    64      /* sizeof first published struct */
> @@ -533,6 +535,7 @@ enum perf_event_type {
>          *      { u64                   stream_id;} && PERF_SAMPLE_STREAM_ID
>          *      { u32                   cpu, res; } && PERF_SAMPLE_CPU
>          *      { u64                   period;   } && PERF_SAMPLE_PERIOD
> +        *      { u64                   weight;   } && PERF_SAMPLE_WEIGHT
>          *
>          *      { struct read_format    values;   } && PERF_SAMPLE_READ
>          *
> @@ -1144,6 +1147,7 @@ struct perf_sample_data {
>         struct perf_callchain_entry     *callchain;
>         struct perf_raw_record          *raw;
>         struct perf_branch_stack        *br_stack;
> +       u64                             weight;
>  };
>
>  static inline void perf_sample_data_init(struct perf_sample_data *data,
> @@ -1154,6 +1158,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>         data->raw  = NULL;
>         data->br_stack = NULL;
>         data->period    = period;
> +       data->weight = 0;
>  }
>
>  extern void perf_output_sample(struct perf_output_handle *handle,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7fee567..74e4ff4 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -949,6 +949,9 @@ static void perf_event__header_size(struct perf_event *event)
>         if (sample_type & PERF_SAMPLE_PERIOD)
>                 size += sizeof(data->period);
>
> +       if (sample_type & PERF_SAMPLE_WEIGHT)
> +               size += sizeof(data->weight);
> +
>         if (sample_type & PERF_SAMPLE_READ)
>                 size += event->read_size;
>
> @@ -3957,6 +3960,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>         if (sample_type & PERF_SAMPLE_PERIOD)
>                 perf_output_put(handle, data->period);
>
> +       if (sample_type & PERF_SAMPLE_WEIGHT)
> +               perf_output_put(handle, data->weight);
> +
>         if (sample_type & PERF_SAMPLE_READ)
>                 perf_output_read(handle, event);
>
> --
> 1.7.7.6
>
