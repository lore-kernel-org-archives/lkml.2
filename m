Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2J2KoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:44:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54468 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2J2KoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:44:19 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-7e-508e5e02d727
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, eranian@google.com, mingo@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 16/33] perf, tools: Add support for weight v2
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
	<1351283415-13170-17-git-send-email-andi@firstfloor.org>
Date: Mon, 29 Oct 2012 19:44:17 +0900
In-Reply-To: <1351283415-13170-17-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 26 Oct 2012 13:29:58 -0700")
Message-ID: <87vcdt7e2m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012 13:29:58 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> perf record has a new option -W that enables weightened sampling.
>
> Add sorting support in top/report for the average weight per sample and the
> total weight sum. This allows to both compare relative cost per event
> and the total cost over the measurement period.

I expected the weight is used for scaling a sample period somehow - and
wondered the *somehow* part - when reading previous patch descriptions
but you just added sort keys.  Is it what you intended originally?


>
> Add the necessary glue to perf report, record and the library.
>
> v2: Merge with new hist refactoring.
> Rename global_weight to weight and weight to local_weight.

But I think (total_)weight and avg_weight looks more natural.


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
[snip]
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 618d411..3800fb5 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -445,6 +445,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>  		attr->mmap_data = track;
>  	}
>  
> +	if (opts->sample_weight)
> +		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
> +
>  	if (opts->call_graph) {
>  		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
>  
> @@ -870,6 +873,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  	data->cpu = data->pid = data->tid = -1;
>  	data->stream_id = data->id = data->time = -1ULL;
>  	data->period = 1;
> +	data->weight = 0;

Why not set it to 1 at first and ...

>  
>  	if (event->header.type != PERF_RECORD_SAMPLE) {
>  		if (!evsel->attr.sample_id_all)
> @@ -941,6 +945,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  		array++;
>  	}
>  
> +	data->weight = 0;

(It seems unnecessary)

> +	if (type & PERF_SAMPLE_WEIGHT) {
> +		data->weight = *array;
> +		array++;
> +	}
> +
>  	if (type & PERF_SAMPLE_READ) {
>  		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
>  		return -1;
[snip]
> @@ -268,13 +272,17 @@ static u8 symbol__parent_filter(const struct symbol *parent)
>  static struct hist_entry *add_hist_entry(struct hists *hists,
>  				      struct hist_entry *entry,
>  				      struct addr_location *al,
> -				      u64 period)
> +				      u64 period,
> +				      u64 weight)
>  {
>  	struct rb_node **p;
>  	struct rb_node *parent = NULL;
>  	struct hist_entry *he;
>  	int cmp;
>  
> +	if (weight == 0)
> +		weight = 1;
> +

... get rid of the above?


>  	pthread_mutex_lock(&hists->lock);
>  
>  	p = &hists->entries_in->rb_node;
> @@ -286,7 +294,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
>  		cmp = hist_entry__cmp(entry, he);
>  
>  		if (!cmp) {
> -			he_stat__add_period(&he->stat, period);
> +			he_stat__add_period(&he->stat, period, weight);
>  
>  			/* If the map of an existing hist_entry has
>  			 * become out-of-date due to an exec() or
> @@ -314,6 +322,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
>  
>  	rb_link_node(&he->rb_node_in, parent, p);
>  	rb_insert_color(&he->rb_node_in, hists->entries_in);
> +	he->stat.weight += weight;

I'd suggest that the weight should be set to the 'entry' so that it can
be added when hist_entry__new() called.

Thanks,
Namhyung


>  out:
>  	hist_entry__add_cpumode_period(he, al->cpumode, period);
>  out_unlock:
