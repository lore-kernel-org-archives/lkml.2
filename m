Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2K2Lhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:37:54 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56125 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2K2Lhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:37:52 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-5c-50b7490e6c48
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 08/14] perf diff: Change diff command to work over multiple data files
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-9-git-send-email-jolsa@redhat.com>
Date: Thu, 29 Nov 2012 20:37:50 +0900
In-Reply-To: <1354110769-2998-9-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 28 Nov 2012 14:52:43 +0100")
Message-ID: <87mwy0od0x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 14:52:43 +0100, Jiri Olsa wrote:
> Adding diff command the flexibility to specify multiple data
> files on input. If not input file is given the standard behaviour
> stands and diff inspects 'perf.data' and 'perf.data.old' files.
>
> Also changing the processing and output display for data files.
>
> For 'perf diff A B' command:
>
>   - the current way is to iterate over B data and display
>     A (baseline) data (symbol samples) only if found in B
>
>   - this patch iterates over A (baseline) data and display
>     B data (symbol samples) only if found in A
>
> For 'perf diff A B C' command, the diff now iterates the
> A (baseline) data and display B and C data (symbol samples)
> only if they found in A (baseline)
>
> All other standard diff command computation features
> (delta,ratio,wdiff) stays.

This is quite a large change and IMHO can be separated into 3 patches at
least.

 1) change he->pairs from list to array
 2) introduce diff_data__fmt
 3) convert to diff_data__fmt

Thanks,
Namhyung


>  5 files changed, 560 insertions(+), 392 deletions(-)
>
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 6361b55..9f4ef76 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -18,11 +18,49 @@
>  #include "util/util.h"
>  
>  #include <stdlib.h>
> +#include <math.h>
>  
> -static char const *input_old = "perf.data.old",
> -		  *input_new = "perf.data";
> -static char	  diff__default_sort_order[] = "dso,symbol";
> -static bool  force;
> +/* Diff command specific HPP columns. */
> +enum {
> +	PERF_HPP_DIFF__BASELINE,
> +	PERF_HPP_DIFF__PERIOD,
> +	PERF_HPP_DIFF__PERIOD_BASELINE,
> +	PERF_HPP_DIFF__DELTA,
> +	PERF_HPP_DIFF__RATIO,
> +	PERF_HPP_DIFF__WEIGHTED_DIFF,
> +	PERF_HPP_DIFF__DISPL,
> +	PERF_HPP_DIFF__FORMULA,
> +
> +	PERF_HPP_DIFF__MAX_INDEX
> +};
> +
> +struct diff_data__fmt {
> +	struct perf_hpp_fmt	fmt;
> +	int			idx;
> +
> +	char			*header;
> +	int			 header_width;
> +};
> +
> +struct diff_data {
> +	struct perf_session	*session;
> +	const char		*file;
> +	int			 idx;
> +
> +	struct diff_data__fmt	 fmt[PERF_HPP_DIFF__MAX_INDEX];
> +};
> +
> +static struct diff_data *data;
> +static int data_cnt;
> +
> +#define for_each_data(i, d) \
> +	for (i = 0, d = &data[0]; i < data_cnt; i++, d = &data[i])
> +
> +#define for_each_data_new(i, d) \
> +	for (i = 1, d = &data[1]; i < data_cnt; i++, d = &data[i])
> +
> +static const char diff__default_sort_order[] = "dso,symbol";
> +static bool force;
>  static bool show_displacement;
>  static bool show_period;
>  static bool show_formula;
> @@ -39,12 +77,55 @@ enum {
>  	COMPUTE_MAX,
>  };
>  
> +static int compute_2_hpp[COMPUTE_MAX] = {
> +	[COMPUTE_DELTA]		= PERF_HPP_DIFF__DELTA,
> +	[COMPUTE_RATIO]		= PERF_HPP_DIFF__RATIO,
> +	[COMPUTE_WEIGHTED_DIFF]	= PERF_HPP_DIFF__WEIGHTED_DIFF,
> +};
> +
> +
>  const char *compute_names[COMPUTE_MAX] = {
>  	[COMPUTE_DELTA] = "delta",
>  	[COMPUTE_RATIO] = "ratio",
>  	[COMPUTE_WEIGHTED_DIFF] = "wdiff",
>  };
>  
> +static struct header_column {
> +	const char *name;
> +	int width;
> +} columns[PERF_HPP_DIFF__MAX_INDEX] = {
> +	[PERF_HPP_DIFF__BASELINE] = {
> +		.name = "Baseline",
> +	},
> +	[PERF_HPP_DIFF__PERIOD] = {
> +		.name = "Period",
> +	},
> +	[PERF_HPP_DIFF__PERIOD_BASELINE] = {
> +		.name = "Base period",
> +	},
> +	[PERF_HPP_DIFF__DELTA] = {
> +		.name  = "Delta",
> +		.width = 7,
> +	},
> +	[PERF_HPP_DIFF__RATIO] = {
> +		.name  = "Ratio",
> +		.width = 14,
> +	},
> +	[PERF_HPP_DIFF__WEIGHTED_DIFF] = {
> +		.name  = "Weighted diff",
> +		.width = 14,
> +	},
> +	[PERF_HPP_DIFF__DISPL] = {
> +		.name = "Displ",
> +	},
> +	[PERF_HPP_DIFF__FORMULA] = {
> +		.name  = "Formula",
> +		.width = 70,
> +	}
> +};
> +
> +#define MAX_COL_WIDTH 70
> +
>  static int compute;
>  
>  static int setup_compute_opt_wdiff(char *opt)
> @@ -146,7 +227,7 @@ static int setup_compute(const struct option *opt, const char *str,
>  	return -EINVAL;
>  }
>  
> -double perf_diff__period_percent(struct hist_entry *he, u64 period)
> +static double get_period_percent(struct hist_entry *he, u64 period)
>  {
>  	u64 total = he->hists->stats.total_period;
>  	return (period * 100.0) / total;
> @@ -154,34 +235,34 @@ double perf_diff__period_percent(struct hist_entry *he, u64 period)
>  
>  double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
>  {
> -	double new_percent = perf_diff__period_percent(he, he->stat.period);
> -	double old_percent = perf_diff__period_percent(pair, pair->stat.period);
> +	double old_percent = get_period_percent(he, he->stat.period);
> +	double new_percent = get_period_percent(pair, pair->stat.period);
>  
> -	he->diff.period_ratio_delta = new_percent - old_percent;
> -	he->diff.computed = true;
> -	return he->diff.period_ratio_delta;
> +	pair->diff.period_ratio_delta = new_percent - old_percent;
> +	pair->diff.computed = true;
> +	return pair->diff.period_ratio_delta;
>  }
>  
>  double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
>  {
> -	double new_period = he->stat.period;
> -	double old_period = pair->stat.period;
> +	double old_period = he->stat.period ?: 1;
> +	double new_period = pair->stat.period;
>  
> -	he->diff.computed = true;
> -	he->diff.period_ratio = new_period / old_period;
> -	return he->diff.period_ratio;
> +	pair->diff.computed = true;
> +	pair->diff.period_ratio = (new_period / old_period);
> +	return pair->diff.period_ratio;
>  }
>  
>  s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
>  {
> -	u64 new_period = he->stat.period;
> -	u64 old_period = pair->stat.period;
> +	u64 old_period = he->stat.period;
> +	u64 new_period = pair->stat.period;
>  
> -	he->diff.computed = true;
> -	he->diff.wdiff = new_period * compute_wdiff_w2 -
> -			 old_period * compute_wdiff_w1;
> +	pair->diff.computed = true;
> +	pair->diff.wdiff = new_period * compute_wdiff_w1 -
> +			   old_period * compute_wdiff_w2;
>  
> -	return he->diff.wdiff;
> +	return pair->diff.wdiff;
>  }
>  
>  static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
> @@ -197,8 +278,8 @@ static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
>  static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
>  			 char *buf, size_t size)
>  {
> -	double new_period = he->stat.period;
> -	double old_period = pair->stat.period;
> +	double old_period = he->stat.period;
> +	double new_period = pair->stat.period;
>  
>  	return scnprintf(buf, size, "%.0F / %.0F", new_period, old_period);
>  }
> @@ -206,12 +287,12 @@ static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
>  static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
>  			 char *buf, size_t size)
>  {
> -	u64 new_period = he->stat.period;
> -	u64 old_period = pair->stat.period;
> +	u64 old_period = he->stat.period;
> +	u64 new_period = pair->stat.period;
>  
>  	return scnprintf(buf, size,
>  		  "(%" PRIu64 " * " "%" PRId64 ") - (%" PRIu64 " * " "%" PRId64 ")",
> -		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
> +		  new_period, compute_wdiff_w1, old_period, compute_wdiff_w2);
>  }
>  
>  int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
> @@ -356,22 +437,21 @@ static void hists__baseline_only(struct hists *hists)
>  		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
>  
>  		next = rb_next(&he->rb_node);
> -		if (!hist_entry__next_pair(he)) {
> +
> +		if (!he->pairs) {
>  			rb_erase(&he->rb_node, &hists->entries);
>  			hist_entry__free(he);
>  		}
>  	}
>  }
>  
> -static void hists__precompute(struct hists *hists)
> +static void __hists__precompute(struct hist_entry *he)
>  {
> -	struct rb_node *next = rb_first(&hists->entries);
> +	int i;
>  
> -	while (next != NULL) {
> -		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
> -		struct hist_entry *pair = hist_entry__next_pair(he);
> +	for (i = 0; i < data_cnt; i++) {
> +		struct hist_entry *pair = he->pairs[i];
>  
> -		next = rb_next(&he->rb_node);
>  		if (!pair)
>  			continue;
>  
> @@ -391,6 +471,21 @@ static void hists__precompute(struct hists *hists)
>  	}
>  }
>  
> +static void hists__precompute(struct hists *hists)
> +{
> +	struct rb_node *next = rb_first(&hists->entries);
> +
> +	while (next != NULL) {
> +		struct hist_entry *he = rb_entry(next, struct hist_entry,
> +						 rb_node);
> +
> +		next = rb_next(&he->rb_node);
> +
> +		if (he->pairs)
> +			__hists__precompute(he);
> +	}
> +}
> +
>  static int64_t cmp_doubles(double l, double r)
>  {
>  	if (l > r)
> @@ -402,8 +497,8 @@ static int64_t cmp_doubles(double l, double r)
>  }
>  
>  static int64_t
> -hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
> -			int c)
> +__hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
> +			  int c)
>  {
>  	switch (c) {
>  	case COMPUTE_DELTA:
> @@ -434,6 +529,39 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
>  	return 0;
>  }
>  
> +static int64_t
> +hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
> +			int c)
> +{
> +	int i;
> +
> +	for (i = 0; i < data_cnt; i++) {
> +		struct hist_entry **pairs_left  = left->pairs;
> +		struct hist_entry **pairs_right = right->pairs;
> +		struct hist_entry *p_right, *p_left;
> +		static int64_t cmp;
> +
> +		if (!pairs_left || !pairs_right)
> +			return pairs_right - pairs_left;
> +
> +		p_right = pairs_right[i];
> +		p_left  = pairs_left[i];
> +
> +		if (!p_left || !p_right)
> +			return p_right - p_left;
> +
> +		/*
> +		 * If we differ, we are done, otherwise continue until all
> +		 * is processed or we find a difference.
> +		 */
> +		cmp = __hist_entry__cmp_compute(p_left, p_right, c);
> +		if (cmp)
> +			return cmp;
> +	}
> +
> +	return 0;
> +}
> +
>  static void insert_hist_entry_by_compute(struct rb_root *root,
>  					 struct hist_entry *he,
>  					 int c)
> @@ -473,83 +601,112 @@ static void hists__compute_resort(struct hists *hists)
>  }
>  
>  static int match_cb(struct hist_entry *a, struct hist_entry *b,
> -		    void *data __maybe_unused)
> +		    void *_data)
>  {
> -	hist__entry_add_pair(a, b);
> +	intptr_t i = (intptr_t) _data;
> +	struct hist_entry **p;
> +
> +	if (!a->pairs) {
> +		p = zalloc(sizeof(p) * data_cnt);
> +		if (!p)
> +			return -ENOMEM;
> +
> +		a->pairs = p;
> +	}
> +
> +	a->pairs[i] = b;
> +	b->paired = true;
>  	return 0;
>  }
>  
> -static void hists__process(struct hists *old, struct hists *new)
> +static void hists__process(struct hists *hists)
>  {
> -	hists__match(new, old, match_cb, NULL);
> -
>  	if (show_baseline_only)
> -		hists__baseline_only(new);
> -	else
> -		hists__link(new, old, match_cb, NULL);
> +		hists__baseline_only(hists);
>  
>  	if (sort_compute) {
> -		hists__precompute(new);
> -		hists__compute_resort(new);
> +		hists__precompute(hists);
> +		hists__compute_resort(hists);
>  	}
>  
> -	hists__fprintf(new, true, 0, 0, stdout);
> +	hists__fprintf(hists, true, 0, 0, stdout);
>  }
>  
> -static int __cmd_diff(void)
> +static int data_process(void)
>  {
> -	int ret, i;
> -#define older (session[0])
> -#define newer (session[1])
> -	struct perf_session *session[2];
> -	struct perf_evlist *evlist_new, *evlist_old;
> -	struct perf_evsel *evsel;
> +	struct perf_evlist *evlist_base = data[0].session->evlist;
> +	struct perf_evsel *evsel_base;
>  	bool first = true;
>  
> -	older = perf_session__new(input_old, O_RDONLY, force, false,
> -				  &tool);
> -	newer = perf_session__new(input_new, O_RDONLY, force, false,
> -				  &tool);
> -	if (session[0] == NULL || session[1] == NULL)
> -		return -ENOMEM;
> +	list_for_each_entry(evsel_base, &evlist_base->entries, node) {
> +		struct diff_data *d;
> +		int i;
>  
> -	for (i = 0; i < 2; ++i) {
> -		ret = perf_session__process_events(session[i], &tool);
> -		if (ret)
> -			goto out_delete;
> -	}
> -
> -	evlist_old = older->evlist;
> -	evlist_new = newer->evlist;
> +		for_each_data_new(i, d) {
> +			struct perf_evlist *evlist = d->session->evlist;
> +			struct perf_evsel *evsel_new;
>  
> -	perf_evlist__resort_hists(evlist_old, true);
> -	perf_evlist__resort_hists(evlist_new, false);
> +			evsel_new = evsel_match(evsel_base, evlist);
> +			if (!evsel_new)
> +				continue;
>  
> -	list_for_each_entry(evsel, &evlist_new->entries, node) {
> -		struct perf_evsel *evsel_old;
> +			hists__match(&evsel_base->hists, &evsel_new->hists,
> +				     match_cb, (void *) (intptr_t) i);
>  
> -		evsel_old = evsel_match(evsel, evlist_old);
> -		if (!evsel_old)
> -			continue;
> +			if (!show_baseline_only)
> +				hists__link(&evsel_base->hists,
> +					    &evsel_new->hists,
> +					    match_cb, (void *) (intptr_t) i);
> +		}
>  
>  		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
> -			perf_evsel__name(evsel));
> +			perf_evsel__name(evsel_base));
> +
> +		hists__process(&evsel_base->hists);
>  
>  		first = false;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __cmd_diff(void)
> +{
> +	struct diff_data *d;
> +	int ret = -EINVAL, i;
> +
> +	for_each_data(i, d) {
> +		d->session = perf_session__new(d->file, O_RDONLY, force,
> +					       false, &tool);
> +		if (!d->session) {
> +			pr_err("Failed to open %s\n", d->file);
> +			ret = -ENOMEM;
> +			goto out_delete;
> +		}
>  
> -		hists__process(&evsel_old->hists, &evsel->hists);
> +		ret = perf_session__process_events(d->session, &tool);
> +		if (ret) {
> +			pr_err("Failed to process %s\n", d->file);
> +			goto out_delete;
> +		}
> +
> +		/* Sort by name all but baseline. */
> +		perf_evlist__resort_hists(d->session->evlist, i != 0);
>  	}
>  
> +	ret = data_process();
> +
>  out_delete:
> -	for (i = 0; i < 2; ++i)
> -		perf_session__delete(session[i]);
> +	for_each_data(i, d) {
> +		if (d->session)
> +			perf_session__delete(d->session);
> +	}
> +
>  	return ret;
> -#undef older
> -#undef newer
>  }
>  
>  static const char * const diff_usage[] = {
> -	"perf diff [<options>] [old_file] [new_file]",
> +	"perf diff [<options>] <base file> <file1> [file2] ...",
>  	NULL,
>  };
>  
> @@ -589,62 +746,340 @@ static const struct option options[] = {
>  	OPT_END()
>  };
>  
> -static void ui_init(void)
> +static double baseline_percent(struct hist_entry *he)
>  {
> -	/*
> -	 * Display baseline/delta/ratio/displacement/
> -	 * formula/periods columns.
> -	 */
> -	perf_hpp__column_enable(PERF_HPP__BASELINE);
> +	struct hists *hists = he->hists;
> +	u64 total_period = hists->stats.total_period;
> +	u64 base_period  = he->stat.period;
>  
> -	switch (compute) {
> -	case COMPUTE_DELTA:
> -		perf_hpp__column_enable(PERF_HPP__DELTA);
> +	return 100.0 * base_period / total_period;
> +}
> +
> +static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
> +			       struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	double percent = baseline_percent(he);
> +	struct diff_data__fmt *dfmt =
> +		container_of(fmt, struct diff_data__fmt, fmt);
> +	char pfmt[20] = " ";
> +
> +	if (percent) {
> +		scnprintf(pfmt, 20, "%%%d.2f%%%%", dfmt->header_width - 1);
> +		return percent_color_snprintf(hpp->buf, hpp->size,
> +					      pfmt, percent);
> +	} else
> +		return scnprintf(hpp->buf, hpp->size, "%*s",
> +				 dfmt->header_width, pfmt);
> +}
> +
> +static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
> +			       struct hist_entry *he)
> +{
> +	struct diff_data__fmt *dfmt =
> +		container_of(_fmt, struct diff_data__fmt, fmt);
> +	double percent = baseline_percent(he);
> +	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
> +	char buf[32] = " ";
> +
> +	if ((percent && he->pairs) || symbol_conf.field_sep)
> +		return scnprintf(hpp->buf, hpp->size, fmt, percent);
> +	else
> +		return scnprintf(hpp->buf, hpp->size, "%*s",
> +				 dfmt->header_width, buf);
> +}
> +
> +static struct hist_entry *get_pair(struct hist_entry *he,
> +				   struct perf_hpp_fmt *fmt)
> +{
> +	struct hist_entry *pair = NULL;
> +
> +	if (he->pairs) {
> +		struct diff_data *d;
> +		struct diff_data__fmt *dfmt;
> +		void *ptr;
> +
> +		dfmt = container_of(fmt, struct diff_data__fmt, fmt);
> +		ptr  = dfmt - dfmt->idx;
> +		d    = container_of(ptr, struct diff_data, fmt);
> +		pair = he->pairs[d->idx];
> +	}
> +
> +	return pair;
> +}
> +
> +static void
> +hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
> +{
> +	switch (idx) {
> +	case PERF_HPP_DIFF__PERIOD_BASELINE:
> +		scnprintf(buf, size, "%" PRIu64, he->stat.period);
>  		break;
> -	case COMPUTE_RATIO:
> -		perf_hpp__column_enable(PERF_HPP__RATIO);
> +
> +	default:
>  		break;
> -	case COMPUTE_WEIGHTED_DIFF:
> -		perf_hpp__column_enable(PERF_HPP__WEIGHTED_DIFF);
> +	}
> +}
> +
> +static void
> +hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
> +		int idx, char *buf, size_t size)
> +{
> +	long displacement;
> +	double diff;
> +	double ratio;
> +	s64 wdiff;
> +
> +	switch (idx) {
> +	case PERF_HPP_DIFF__DELTA:
> +		if (pair->diff.computed)
> +			diff = pair->diff.period_ratio_delta;
> +		else
> +			diff = perf_diff__compute_delta(he, pair);
> +
> +		if (fabs(diff) >= 0.01)
> +			scnprintf(buf, size, "%+4.2F%%", diff);
> +		break;
> +
> +	case PERF_HPP_DIFF__RATIO:
> +		if (pair->diff.computed)
> +			ratio = pair->diff.period_ratio;
> +		else
> +			ratio = perf_diff__compute_ratio(he, pair);
> +
> +		if (ratio > 0.0)
> +			scnprintf(buf, size, "%14.6F", ratio);
> +		break;
> +
> +	case PERF_HPP_DIFF__WEIGHTED_DIFF:
> +		if (pair->diff.computed)
> +			wdiff = pair->diff.wdiff;
> +		else
> +			wdiff = perf_diff__compute_wdiff(he, pair);
> +
> +		if (wdiff != 0)
> +			scnprintf(buf, size, "%14ld", wdiff);
> +		break;
> +
> +	case PERF_HPP_DIFF__DISPL:
> +		displacement = pair->position - he->position;
> +
> +		if (displacement)
> +			scnprintf(buf, size, "%+4ld", displacement);
>  		break;
> +
> +	case PERF_HPP_DIFF__FORMULA:
> +		perf_diff__formula(he, pair, buf, size);
> +		break;
> +
> +	case PERF_HPP_DIFF__PERIOD:
> +		scnprintf(buf, size, "%" PRIu64, pair->stat.period);
> +		break;
> +
>  	default:
>  		BUG_ON(1);
> -	};
> +	}
> +}
> +
> +static int hpp__entry_global(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
> +			     struct hist_entry *he)
> +{
> +	struct diff_data__fmt *dfmt =
> +		container_of(_fmt, struct diff_data__fmt, fmt);
> +	struct hist_entry *pair;
> +	char buf[MAX_COL_WIDTH] = " ";
> +
> +	pair = get_pair(he, _fmt);
> +
> +	if (pair)
> +		hpp__entry_pair(he, pair, dfmt->idx, buf, MAX_COL_WIDTH);
> +	else
> +		hpp__entry_unpair(he, dfmt->idx, buf, MAX_COL_WIDTH);
> +
> +	if (symbol_conf.field_sep)
> +		return scnprintf(hpp->buf, hpp->size, "%s", buf);
> +	else
> +		return scnprintf(hpp->buf, hpp->size, "%*s",
> +				 dfmt->header_width, buf);
> +}
> +
> +static int diff_hpp__header(struct perf_hpp_fmt *fmt,
> +			    struct perf_hpp *hpp)
> +{
> +	struct diff_data__fmt *dfmt =
> +		container_of(fmt, struct diff_data__fmt, fmt);
> +
> +	BUG_ON(!dfmt->header);
> +
> +	return scnprintf(hpp->buf, hpp->size, dfmt->header);
> +}
> +
> +static int diff_hpp__width(struct perf_hpp_fmt *fmt,
> +			   struct perf_hpp *hpp __maybe_unused)
> +{
> +	struct diff_data__fmt *dfmt =
> +		container_of(fmt, struct diff_data__fmt, fmt);
> +
> +	BUG_ON(dfmt->header_width <= 0);
> +
> +	return dfmt->header_width;
> +}
>  
> -	if (show_displacement)
> -		perf_hpp__column_enable(PERF_HPP__DISPL);
> +static void init_header(struct diff_data *d, struct diff_data__fmt *dfmt)
> +{
> +#define MAX_HEADER_NAME 100
> +	char buf_indent[MAX_HEADER_NAME];
> +	char buf[MAX_HEADER_NAME];
> +	const char *header = NULL;
> +	int width = 0;
> +
> +	BUG_ON(dfmt->idx >= PERF_HPP_DIFF__MAX_INDEX);
> +	header = columns[dfmt->idx].name;
> +	width  = columns[dfmt->idx].width;
> +
> +	/* Only our defined HPP fmts should appear here. */
> +	BUG_ON(!header);
> +
> +	if (data_cnt > 2)
> +		scnprintf(buf, MAX_HEADER_NAME, "%s/%d", header, d->idx);
> +
> +#define NAME (data_cnt > 2 ? buf : header)
> +	dfmt->header_width = width;
> +	width = (int) strlen(NAME);
> +	if (dfmt->header_width < width)
> +		dfmt->header_width = width;
> +
> +	scnprintf(buf_indent, MAX_HEADER_NAME, "%*s",
> +		  dfmt->header_width, NAME);
> +
> +	dfmt->header = strdup(buf_indent);
> +#undef MAX_HEADER_NAME
> +#undef NAME
> +}
>  
> -	if (show_formula)
> -		perf_hpp__column_enable(PERF_HPP__FORMULA);
> +static void data__hpp_register(struct diff_data *d, int idx)
> +{
> +	struct diff_data__fmt *dfmt = &d->fmt[idx];
> +	struct perf_hpp_fmt *fmt = &dfmt->fmt;
>  
> -	if (show_period) {
> -		perf_hpp__column_enable(PERF_HPP__PERIOD);
> -		perf_hpp__column_enable(PERF_HPP__PERIOD_BASELINE);
> +	dfmt->idx = idx;
> +
> +	fmt->header = diff_hpp__header;
> +	fmt->width  = diff_hpp__width;
> +
> +	switch (idx) {
> +#define CASE_COLOR(c, name)				\
> +	case c:						\
> +		fmt->color  = hpp__color_##name;	\
> +		fmt->entry  = hpp__entry_##name;	\
> +		break;
> +
> +#define CASE(c, name)					\
> +	case c:						\
> +		fmt->entry  = hpp__entry_##name;	\
> +		break;
> +
> +	CASE_COLOR(PERF_HPP_DIFF__BASELINE,	baseline)
> +	CASE(PERF_HPP_DIFF__PERIOD_BASELINE,	global)
> +	CASE(PERF_HPP_DIFF__DELTA,		global)
> +	CASE(PERF_HPP_DIFF__RATIO,		global)
> +	CASE(PERF_HPP_DIFF__WEIGHTED_DIFF,	global)
> +	CASE(PERF_HPP_DIFF__DISPL,		global)
> +	CASE(PERF_HPP_DIFF__FORMULA,		global)
> +	CASE(PERF_HPP_DIFF__PERIOD,		global)
> +
> +	default:
> +		BUG_ON(1);
>  	}
> +
> +	perf_hpp__column_register(fmt);
> +
> +	init_header(d, dfmt);
>  }
>  
> -int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
> +static void ui_init(void)
>  {
> -	sort_order = diff__default_sort_order;
> -	argc = parse_options(argc, argv, options, diff_usage, 0);
> +	struct diff_data *d;
> +	int i;
> +
> +	for_each_data(i, d) {
> +
> +		/*
> +		 * Baseline or compute realted columns:
> +		 *
> +		 *   PERF_HPP_DIFF__BASELINE
> +		 *   PERF_HPP_DIFF__DELTA
> +		 *   PERF_HPP_DIFF__RATIO
> +		 *   PERF_HPP_DIFF__WEIGHTED_DIFF
> +		 */
> +		data__hpp_register(d, i ? compute_2_hpp[compute] :
> +					  PERF_HPP_DIFF__BASELINE);
> +
> +		/*
> +		 * And the rest:
> +		 *
> +		 * PERF_HPP_DIFF__DISPL
> +		 * PERF_HPP_DIFF__FORMULA
> +		 * PERF_HPP_DIFF__PERIOD
> +		 * PERF_HPP_DIFF__PERIOD_BASELINE
> +		 */
> +		if (show_displacement && i)
> +			data__hpp_register(d, PERF_HPP_DIFF__DISPL);
> +
> +		if (show_formula && i)
> +			data__hpp_register(d, PERF_HPP_DIFF__FORMULA);
> +
> +		if (show_period)
> +			data__hpp_register(d, i ? PERF_HPP_DIFF__PERIOD :
> +						  PERF_HPP_DIFF__PERIOD_BASELINE);
> +	}
> +}
> +
> +static int data_init(int argc, const char **argv)
> +{
> +	struct diff_data *d;
> +	static const char *defaults[] = {
> +		"perf.data.old",
> +		"perf.data",
> +	};
> +	int i;
> +
> +	if (argc == 1)
> +		usage_with_options(diff_usage, options);
> +
> +	data_cnt = 2;
> +
>  	if (argc) {
> -		if (argc > 2)
> -			usage_with_options(diff_usage, options);
> -		if (argc == 2) {
> -			input_old = argv[0];
> -			input_new = argv[1];
> -		} else
> -			input_new = argv[0];
> +		data_cnt = argc;
>  	} else if (symbol_conf.default_guest_vmlinux_name ||
>  		   symbol_conf.default_guest_kallsyms) {
> -		input_old = "perf.data.host";
> -		input_new = "perf.data.guest";
> +		defaults[0] = "perf.data.host";
> +		defaults[1] = "perf.data.guest";
>  	}
>  
> +	data = zalloc(sizeof(*data) * data_cnt);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	for_each_data(i, d) {
> +		d->file = argc ? argv[i] : defaults[i];
> +		d->idx  = i;
> +	}
> +
> +	return 0;
> +}
> +
> +int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
> +{
> +	sort_order = diff__default_sort_order;
> +	argc = parse_options(argc, argv, options, diff_usage, 0);
>  	symbol_conf.exclude_other = false;
> +
>  	if (symbol__init() < 0)
>  		return -1;
>  
> +	if (data_init(argc, argv) < 0)
> +		return -1;
> +
>  	ui_init();
>  
>  	setup_sorting(diff_usage, options);
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index d6fdb00..a004f57 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -177,57 +177,6 @@ hpp__entry_overhead_guest_us(struct perf_hpp_fmt *_fmt __maybe_unused,
>  	return scnprintf(hpp->buf, hpp->size, fmt, percent);
>  }
>  
> -static int hpp__header_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
> -				struct perf_hpp *hpp)
> -{
> -	return scnprintf(hpp->buf, hpp->size, "Baseline");
> -}
> -
> -static int hpp__width_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
> -			       struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 8;
> -}
> -
> -static double baseline_percent(struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	struct hists *pair_hists = pair ? pair->hists : NULL;
> -	double percent = 0.0;
> -
> -	if (pair) {
> -		u64 total_period = pair_hists->stats.total_period;
> -		u64 base_period  = pair->stat.period;
> -
> -		percent = 100.0 * base_period / total_period;
> -	}
> -
> -	return percent;
> -}
> -
> -static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
> -			       struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	double percent = baseline_percent(he);
> -
> -	if (hist_entry__has_pairs(he))
> -		return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
> -	else
> -		return scnprintf(hpp->buf, hpp->size, "        ");
> -}
> -
> -static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			       struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	double percent = baseline_percent(he);
> -	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
> -
> -	if (hist_entry__has_pairs(he) || symbol_conf.field_sep)
> -		return scnprintf(hpp->buf, hpp->size, fmt, percent);
> -	else
> -		return scnprintf(hpp->buf, hpp->size, "            ");
> -}
> -
>  static int hpp__header_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
>  			       struct perf_hpp *hpp)
>  {
> @@ -272,190 +221,6 @@ static int hpp__entry_period(struct perf_hpp_fmt *_fmt __maybe_unused,
>  	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
>  }
>  
> -static int hpp__header_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
> -				       struct perf_hpp *hpp)
> -{
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, "Period Base");
> -}
> -
> -static int hpp__width_period_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
> -				      struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 12;
> -}
> -
> -static int hpp__entry_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
> -				      struct perf_hpp *hpp,
> -				      struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	u64 period = pair ? pair->stat.period : 0;
> -	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, period);
> -}
> -
> -static int hpp__header_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			     struct perf_hpp *hpp)
> -{
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, "Delta");
> -}
> -
> -static int hpp__width_delta(struct perf_hpp_fmt *fmt __maybe_unused,
> -			    struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 7;
> -}
> -
> -static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			    struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
> -	char buf[32] = " ";
> -	double diff = 0.0;
> -
> -	if (pair) {
> -		if (he->diff.computed)
> -			diff = he->diff.period_ratio_delta;
> -		else
> -			diff = perf_diff__compute_delta(he, pair);
> -	} else
> -		diff = perf_diff__period_percent(he, he->stat.period);
> -
> -	if (fabs(diff) >= 0.01)
> -		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, buf);
> -}
> -
> -static int hpp__header_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			     struct perf_hpp *hpp)
> -{
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, "Ratio");
> -}
> -
> -static int hpp__width_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			    struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 14;
> -}
> -
> -static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			    struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
> -	char buf[32] = " ";
> -	double ratio = 0.0;
> -
> -	if (pair) {
> -		if (he->diff.computed)
> -			ratio = he->diff.period_ratio;
> -		else
> -			ratio = perf_diff__compute_ratio(he, pair);
> -	}
> -
> -	if (ratio > 0.0)
> -		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, buf);
> -}
> -
> -static int hpp__header_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			     struct perf_hpp *hpp)
> -{
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, "Weighted diff");
> -}
> -
> -static int hpp__width_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
> -			    struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 14;
> -}
> -
> -static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			    struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
> -	char buf[32] = " ";
> -	s64 wdiff = 0;
> -
> -	if (pair) {
> -		if (he->diff.computed)
> -			wdiff = he->diff.wdiff;
> -		else
> -			wdiff = perf_diff__compute_wdiff(he, pair);
> -	}
> -
> -	if (wdiff != 0)
> -		scnprintf(buf, sizeof(buf), "%14ld", wdiff);
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, buf);
> -}
> -
> -static int hpp__header_displ(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			     struct perf_hpp *hpp)
> -{
> -	return scnprintf(hpp->buf, hpp->size, "Displ.");
> -}
> -
> -static int hpp__width_displ(struct perf_hpp_fmt *fmt __maybe_unused,
> -			    struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 6;
> -}
> -
> -static int hpp__entry_displ(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			    struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	long displacement = pair ? pair->position - he->position : 0;
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
> -	char buf[32] = " ";
> -
> -	if (displacement)
> -		scnprintf(buf, sizeof(buf), "%+4ld", displacement);
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, buf);
> -}
> -
> -static int hpp__header_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			       struct perf_hpp *hpp)
> -{
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, "Formula");
> -}
> -
> -static int hpp__width_formula(struct perf_hpp_fmt *fmt __maybe_unused,
> -			      struct perf_hpp *hpp __maybe_unused)
> -{
> -	return 70;
> -}
> -
> -static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
> -			      struct perf_hpp *hpp, struct hist_entry *he)
> -{
> -	struct hist_entry *pair = hist_entry__next_pair(he);
> -	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
> -	char buf[96] = " ";
> -
> -	if (pair)
> -		perf_diff__formula(he, pair, buf, sizeof(buf));
> -
> -	return scnprintf(hpp->buf, hpp->size, fmt, buf);
> -}
> -
>  #define HPP__COLOR_PRINT_FNS(_name)			\
>  	{						\
>  		.header	= hpp__header_ ## _name,	\
> @@ -472,7 +237,6 @@ static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
>  	}
>  
>  struct perf_hpp_fmt perf_hpp__format[] = {
> -	HPP__COLOR_PRINT_FNS(baseline),
>  	HPP__COLOR_PRINT_FNS(overhead),
>  	HPP__COLOR_PRINT_FNS(overhead_sys),
>  	HPP__COLOR_PRINT_FNS(overhead_us),
> @@ -480,12 +244,6 @@ struct perf_hpp_fmt perf_hpp__format[] = {
>  	HPP__COLOR_PRINT_FNS(overhead_guest_us),
>  	HPP__PRINT_FNS(samples),
>  	HPP__PRINT_FNS(period),
> -	HPP__PRINT_FNS(period_baseline),
> -	HPP__PRINT_FNS(delta),
> -	HPP__PRINT_FNS(ratio),
> -	HPP__PRINT_FNS(wdiff),
> -	HPP__PRINT_FNS(displ),
> -	HPP__PRINT_FNS(formula)
>  };
>  
>  LIST_HEAD(perf_hpp__list);
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 0c5843b..25f94a4 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -244,8 +244,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>  			he->ms.map->referenced = true;
>  		if (symbol_conf.use_callchain)
>  			callchain_init(he->callchain);
> -
> -		INIT_LIST_HEAD(&he->pairs.node);
>  	}
>  
>  	return he;
> @@ -812,11 +810,11 @@ int hists__link(struct hists *leader, struct hists *other,
>  	for (nd = rb_first(&other->entries); nd && !ret; nd = rb_next(nd)) {
>  		pos = rb_entry(nd, struct hist_entry, rb_node);
>  
> -		if (!hist_entry__has_pairs(pos)) {
> +		if (!pos->paired) {
>  			pair = hists__add_dummy_entry(leader, pos);
>  			if (pair == NULL)
>  				return -1;
> -			ret = cb(pos, pair, data);
> +			ret = cb(pair, pos, data);
>  		}
>  	}
>  
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index eb4dc83..d4f19eb 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -148,7 +148,7 @@ extern struct list_head perf_hpp__list;
>  extern struct perf_hpp_fmt perf_hpp__format[];
>  
>  enum {
> -	PERF_HPP__BASELINE,
> +	/* Matches perf_hpp__format array. */
>  	PERF_HPP__OVERHEAD,
>  	PERF_HPP__OVERHEAD_SYS,
>  	PERF_HPP__OVERHEAD_US,
> @@ -156,12 +156,6 @@ enum {
>  	PERF_HPP__OVERHEAD_GUEST_US,
>  	PERF_HPP__SAMPLES,
>  	PERF_HPP__PERIOD,
> -	PERF_HPP__PERIOD_BASELINE,
> -	PERF_HPP__DELTA,
> -	PERF_HPP__RATIO,
> -	PERF_HPP__WEIGHTED_DIFF,
> -	PERF_HPP__DISPL,
> -	PERF_HPP__FORMULA,
>  
>  	PERF_HPP__MAX_INDEX
>  };
> @@ -237,5 +231,4 @@ double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
>  s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
>  int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
>  		       char *buf, size_t size);
> -double perf_diff__period_percent(struct hist_entry *he, u64 period);
>  #endif	/* __PERF_HIST_H */
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index a884be2..377b144 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -74,18 +74,12 @@ struct hist_entry_diff {
>  struct hist_entry {
>  	struct rb_node		rb_node_in;
>  	struct rb_node		rb_node;
> -	union {
> -		struct list_head node;
> -		struct list_head head;
> -	} pairs;
>  	struct he_stat		stat;
>  	struct map_symbol	ms;
>  	struct thread		*thread;
>  	u64			ip;
>  	s32			cpu;
>  
> -	struct hist_entry_diff	diff;
> -
>  	/* XXX These two should move to some tree widget lib */
>  	u16			row_offset;
>  	u16			nr_rows;
> @@ -98,29 +92,19 @@ struct hist_entry {
>  	struct symbol		*parent;
>  	unsigned long		position;
>  	struct rb_root		sorted_chain;
> +
> +	/* diff related */
> +	union {
> +		struct hist_entry	**pairs;
> +		bool			  paired;
> +	};
> +	struct hist_entry_diff	diff;
> +
>  	struct branch_info	*branch_info;
>  	struct hists		*hists;
>  	struct callchain_root	callchain[0];
>  };
>  
> -static inline bool hist_entry__has_pairs(struct hist_entry *he)
> -{
> -	return !list_empty(&he->pairs.node);
> -}
> -
> -static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
> -{
> -	if (hist_entry__has_pairs(he))
> -		return list_entry(he->pairs.node.next, struct hist_entry, pairs.node);
> -	return NULL;
> -}
> -
> -static inline void hist__entry_add_pair(struct hist_entry *he,
> -					struct hist_entry *pair)
> -{
> -	list_add_tail(&he->pairs.head, &pair->pairs.node);
> -}
> -
>  enum sort_type {
>  	SORT_PID,
>  	SORT_COMM,
