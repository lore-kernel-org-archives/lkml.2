Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab2IGDCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:02:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47586 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab2IGDCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:02:20 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-bd-504963bacb15
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	<1346946426-13496-6-git-send-email-jolsa@redhat.com>
Date: Fri, 07 Sep 2012 11:55:02 +0900
In-Reply-To: <1346946426-13496-6-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 6 Sep 2012 17:46:59 +0200")
Message-ID: <878vcmczjt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

On Thu,  6 Sep 2012 17:46:59 +0200, Jiri Olsa wrote:
> Currently for any of the data columns (like Overhead/Period..) in
> stdio ui, there's separate code to print header/dots/value scattered
> along the display code path.
>
> Adding hists_stdio_column struct to centralize all info needed
> to print column header/dots/value.
>
> This change eases up addition for new columns, which is now mostly
> matter only of adding new hists_stdio_column struct.

As you may know, I submitted a similar patchset few days ago for the
same reason and it handles TUI/GTK cases as well.  I'm waiting for
reviews.

Thanks,
Namhyung


>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/builtin-diff.c   |  14 +-
>  tools/perf/builtin-report.c |   6 +-
>  tools/perf/builtin-top.c    |   6 +-
>  tools/perf/ui/stdio/hist.c  | 506 +++++++++++++++++++++++++-------------------
>  tools/perf/ui/stdio/hist.h  |  19 ++
>  tools/perf/util/hist.c      |   5 +-
>  tools/perf/util/hist.h      |  19 +-
>  7 files changed, 345 insertions(+), 230 deletions(-)
>  create mode 100644 tools/perf/ui/stdio/hist.h
>
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 4e63979..282fd5e 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -16,6 +16,7 @@
>  #include "util/sort.h"
>  #include "util/symbol.h"
>  #include "util/util.h"
> +#include "ui/stdio/hist.h"
>  
>  #include <stdlib.h>
>  
> @@ -214,8 +215,7 @@ static int __cmd_diff(void)
>  		first = false;
>  
>  		hists__match(&evsel_old->hists, &evsel->hists);
> -		hists__fprintf(&evsel->hists, &evsel_old->hists,
> -			       show_displacement, true, 0, 0, stdout);
> +		hists__fprintf(&evsel->hists, true, 0, 0, stdout);
>  	}
>  
>  out_delete:
> @@ -257,6 +257,15 @@ static const struct option options[] = {
>  	OPT_END()
>  };
>  
> +static void setup_ui_stdio(void)
> +{
> +	hists_stdio_column__register_idx(HISTC_BASELINE);
> +	hists_stdio_column__register_global();
> +	hists_stdio_column__register_idx(HISTC_DELTA);
> +	if (show_displacement)
> +		hists_stdio_column__register_idx(HISTC_DISPLACEMENT);
> +}
> +
>  int cmd_diff(int argc, const char **argv, const char *prefix __used)
>  {
>  	sort_order = diff__default_sort_order;
> @@ -280,6 +289,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __used)
>  		return -1;
>  
>  	setup_sorting(diff_usage, options);
> +	setup_ui_stdio();
>  	setup_pager();
>  
>  	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", NULL);
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index d618253..c855c9a 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -33,6 +33,7 @@
>  #include "util/thread.h"
>  #include "util/sort.h"
>  #include "util/hist.h"
> +#include "ui/stdio/hist.h"
>  
>  #include <linux/bitmap.h>
>  
> @@ -315,12 +316,15 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
>  {
>  	struct perf_evsel *pos;
>  
> +	hists_stdio_column__register_idx(HISTC_OVERHEAD);
> +	hists_stdio_column__register_global();
> +
>  	list_for_each_entry(pos, &evlist->entries, node) {
>  		struct hists *hists = &pos->hists;
>  		const char *evname = perf_evsel__name(pos);
>  
>  		hists__fprintf_nr_sample_events(hists, evname, stdout);
> -		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
> +		hists__fprintf(hists, true, 0, 0, stdout);
>  		fprintf(stdout, "\n\n");
>  	}
>  
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 0513aaa..26da442 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -41,6 +41,7 @@
>  #include "util/intlist.h"
>  
>  #include "util/debug.h"
> +#include "ui/stdio/hist.h"
>  
>  #include <assert.h>
>  #include <elf.h>
> @@ -315,7 +316,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
>  	hists__output_recalc_col_len(&top->sym_evsel->hists,
>  				     top->winsize.ws_row - 3);
>  	putchar('\n');
> -	hists__fprintf(&top->sym_evsel->hists, NULL, false, false,
> +	hists__fprintf(&top->sym_evsel->hists, false,
>  		       top->winsize.ws_row - 4 - printed, win_width, stdout);
>  }
>  
> @@ -607,6 +608,9 @@ static void *display_thread(void *arg)
>  	struct perf_top *top = arg;
>  	int delay_msecs, c;
>  
> +	hists_stdio_column__register_idx(HISTC_OVERHEAD);
> +	hists_stdio_column__register_global();
> +
>  	tcgetattr(0, &save);
>  	tc = save;
>  	tc.c_lflag &= ~(ICANON | ECHO);
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 4ae9ee5..48fb0b3 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -1,10 +1,180 @@
>  #include <stdio.h>
>  #include <math.h>
>  
> +#include "hist.h"
>  #include "../../util/util.h"
>  #include "../../util/hist.h"
>  #include "../../util/sort.h"
>  
> +static double get_period_percent(struct hist_entry *he, u64 period)
> +{
> +	u64 total  = he->hists->stats.total_period;
> +	return (period * 100.0) / total;
> +}
> +
> +static int
> +hists_stdio_column__delta_snprintf(struct hist_entry *he, char *bf,
> +				   size_t size, unsigned int width __used)
> +{
> +	struct hist_entry *pair = he->pair;
> +	double new_percent = get_period_percent(he, he->period);
> +	double old_percent = pair ? get_period_percent(pair, pair->period) : 0.0;
> +	double diff = new_percent - old_percent;
> +	int ret;
> +
> +	if (fabs(diff) >= 0.01)
> +		ret = percent_color_snprintf(bf, size, "%+7.2F%%", diff);
> +	else
> +		ret = scnprintf(bf, size, "%8s", " ");
> +
> +	return ret;
> +}
> +
> +static int
> +hists_stdio_column__baseline_snprintf(struct hist_entry *he, char *bf,
> +				      size_t size, unsigned int width __used)
> +{
> +	struct hist_entry *pair = he->pair;
> +	double percent = pair ? get_period_percent(pair, pair->period) : 0.0;
> +
> +	return percent_color_snprintf(bf, size, "%7.2F%%", percent);
> +}
> +
> +static int
> +hists_stdio_column__overhead_snprintf(struct hist_entry *he, char *bf,
> +				      size_t size, unsigned int width __used)
> +{
> +	double percent = get_period_percent(he, he->period);
> +	return percent_color_snprintf(bf, size, "%7.2f%%", percent);
> +}
> +
> +static int
> +hists_stdio_column__nr_samples_snprintf(struct hist_entry *he, char *bf,
> +					size_t size, unsigned int width __used)
> +{
> +	return scnprintf(bf, size, "%12" PRIu64, he->nr_events);
> +}
> +
> +static int
> +hists_stdio_column__total_period_snprintf(struct hist_entry *he, char *bf,
> +					  size_t size, unsigned int width __used)
> +{
> +	return scnprintf(bf, size , "%12" PRIu64, he->period);
> +}
> +
> +static int
> +hists_stdio_column__cpu_sys_snprintf(struct hist_entry *he, char *bf,
> +				     size_t size, unsigned int width __used)
> +{
> +	double percent = get_period_percent(he, he->period_sys);
> +	return percent_color_snprintf(bf, size, "%7.2f%%", percent);
> +}
> +
> +static int
> +hists_stdio_column__cpu_us_snprintf(struct hist_entry *he, char *bf,
> +				    size_t size, unsigned int width __used)
> +{
> +	double percent = get_period_percent(he, he->period_us);
> +	return percent_color_snprintf(bf, size, "%7.2f%%", percent);
> +}
> +
> +static int
> +hists_stdio_column__cpu_guest_sys_snprintf(struct hist_entry *he, char *bf,
> +					   size_t size, unsigned int width __used)
> +{
> +	double percent = get_period_percent(he, he->period_guest_sys);
> +	return percent_color_snprintf(bf, size, "%8.2f%%", percent);
> +}
> +
> +static int
> +hists_stdio_column__cpu_guest_us_snprintf(struct hist_entry *he, char *bf,
> +					  size_t size, unsigned int width __used)
> +{
> +	double percent = get_period_percent(he, he->period_guest_us);
> +	return percent_color_snprintf(bf, size, "%7.2f%%", percent);
> +}
> +
> +static int
> +hists_stdio_column__displacement_snprintf(struct hist_entry *he, char *bf,
> +					  size_t size, unsigned int width __used)
> +{
> +	struct hist_entry *pair = he->pair;
> +	unsigned long displ = pair ? pair->position - he->position : 0;
> +	return scnprintf(bf, size, displ ? "%+5ld" : "     ", displ);
> +}
> +
> +LIST_HEAD(hists_stdio_column__list);
> +
> +#define DEF_COLUMN(name, c, w, h)					\
> +[ c ] = {									\
> +	.list		= LIST_HEAD_INIT((hists_stdio_column__array[ c ]).list),\
> +	.header		= h,						\
> +	.snprintf	= hists_stdio_column__ ## name ## _snprintf,	\
> +	.col_idx	= c,						\
> +	.col_width	= w,						\
> +},
> +
> +struct hists_stdio_column hists_stdio_column__array[HISTC_STDIO_NR_COLS] = {
> +DEF_COLUMN(overhead, HISTC_OVERHEAD, 8, "Overhead")
> +DEF_COLUMN(baseline, HISTC_BASELINE, 8, "Baseline")
> +DEF_COLUMN(cpu_sys, HISTC_CPU_UTILIZATION_SYS, 8, "sys")
> +DEF_COLUMN(cpu_us, HISTC_CPU_UTILIZATION_US, 8, "us")
> +DEF_COLUMN(cpu_guest_sys, HISTC_CPU_UTILIZATION_GUEST_SYS, 8, "guest sys")
> +DEF_COLUMN(cpu_guest_us, HISTC_CPU_UTILIZATION_GUEST_US, 8, "guest us")
> +DEF_COLUMN(nr_samples, HISTC_NR_SAMPLES, 12, "Samples")
> +DEF_COLUMN(total_period, HISTC_TOTAL_PERIOD, 12, "Period")
> +DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
> +DEF_COLUMN(displacement, HISTC_DISPLACEMENT, 5, "Displ")
> +};
> +
> +int hists_stdio_column__register_idx(int idx)
> +{
> +	struct hists_stdio_column *col;
> +
> +	if (idx >= HISTC_STDIO_NR_COLS)
> +		return -EINVAL;
> +
> +	col = &hists_stdio_column__array[idx];
> +
> +	if (!list_empty(&col->list))
> +		return -EBUSY;
> +
> +	list_add_tail(&col->list, &hists_stdio_column__list);
> +	return 0;
> +}
> +
> +void hists_stdio_column__set_width(struct hists *hists)
> +{
> +	struct hists_stdio_column *col;
> +	unsigned i;
> +
> +	for (i = 0; i < HISTC_STDIO_NR_COLS; i++) {
> +		col = &hists_stdio_column__array[i];
> +		hists__set_col_len(hists, i, col->col_width);
> +	}
> +}
> +
> +void hists_stdio_column__register_global(void)
> +{
> +#define reg(idx) hists_stdio_column__register_idx(idx)
> +
> +	if (symbol_conf.show_cpu_utilization) {
> +		reg(HISTC_CPU_UTILIZATION_SYS);
> +		reg(HISTC_CPU_UTILIZATION_US);
> +	}
> +
> +	if (perf_guest) {
> +		reg(HISTC_CPU_UTILIZATION_GUEST_SYS);
> +		reg(HISTC_CPU_UTILIZATION_GUEST_US);
> +	}
> +
> +	if (symbol_conf.show_nr_samples)
> +		reg(HISTC_NR_SAMPLES);
> +
> +	if (symbol_conf.show_total_period)
> +		reg(HISTC_TOTAL_PERIOD);
> +#undef reg
> +}
>  
>  static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
>  {
> @@ -291,114 +461,20 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
>  	return 0;
>  }
>  
> -static int hist_entry__period_snprintf(struct hist_entry *he, char *s,
> -				     size_t size, struct hists *pair_hists,
> -				     bool show_displacement, long displacement,
> -				     bool color, u64 total_period)
> +static int
> +hists_stdio_column__snprintf(struct hist_entry *he, char *s, size_t size,
> +			    struct hists *hists)
>  {
> -	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
> -	u64 nr_events;
>  	const char *sep = symbol_conf.field_sep;
> -	int ret;
> -
> -	if (symbol_conf.exclude_other && !he->parent)
> -		return 0;
> -
> -	if (pair_hists) {
> -		period = he->pair ? he->pair->period : 0;
> -		nr_events = he->pair ? he->pair->nr_events : 0;
> -		total = pair_hists->stats.total_period;
> -		period_sys = he->pair ? he->pair->period_sys : 0;
> -		period_us = he->pair ? he->pair->period_us : 0;
> -		period_guest_sys = he->pair ? he->pair->period_guest_sys : 0;
> -		period_guest_us = he->pair ? he->pair->period_guest_us : 0;
> -	} else {
> -		period = he->period;
> -		nr_events = he->nr_events;
> -		total = total_period;
> -		period_sys = he->period_sys;
> -		period_us = he->period_us;
> -		period_guest_sys = he->period_guest_sys;
> -		period_guest_us = he->period_guest_us;
> -	}
> -
> -	if (total) {
> -		if (color)
> -			ret = percent_color_snprintf(s, size,
> -						     sep ? "%.2f" : "   %6.2f%%",
> -						     (period * 100.0) / total);
> -		else
> -			ret = scnprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
> -				       (period * 100.0) / total);
> -		if (symbol_conf.show_cpu_utilization) {
> -			ret += percent_color_snprintf(s + ret, size - ret,
> -					sep ? "%.2f" : "   %6.2f%%",
> -					(period_sys * 100.0) / total);
> -			ret += percent_color_snprintf(s + ret, size - ret,
> -					sep ? "%.2f" : "   %6.2f%%",
> -					(period_us * 100.0) / total);
> -			if (perf_guest) {
> -				ret += percent_color_snprintf(s + ret,
> -						size - ret,
> -						sep ? "%.2f" : "   %6.2f%%",
> -						(period_guest_sys * 100.0) /
> -								total);
> -				ret += percent_color_snprintf(s + ret,
> -						size - ret,
> -						sep ? "%.2f" : "   %6.2f%%",
> -						(period_guest_us * 100.0) /
> -								total);
> -			}
> -		}
> -	} else
> -		ret = scnprintf(s, size, sep ? "%" PRIu64 : "%12" PRIu64 " ", period);
> -
> -	if (symbol_conf.show_nr_samples) {
> -		if (sep)
> -			ret += scnprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
> -		else
> -			ret += scnprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
> -	}
> -
> -	if (symbol_conf.show_total_period) {
> -		if (sep)
> -			ret += scnprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
> -		else
> -			ret += scnprintf(s + ret, size - ret, " %12" PRIu64, period);
> -	}
> -
> -	if (pair_hists) {
> -		char bf[32];
> -		double old_percent = 0, new_percent = 0, diff;
> -
> -		if (total > 0)
> -			old_percent = (period * 100.0) / total;
> -		if (total_period > 0)
> -			new_percent = (he->period * 100.0) / total_period;
> -
> -		diff = new_percent - old_percent;
> -
> -		if (fabs(diff) >= 0.01)
> -			scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
> -		else
> -			scnprintf(bf, sizeof(bf), " ");
> -
> -		if (sep)
> -			ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
> -		else
> -			ret += scnprintf(s + ret, size - ret, "%11.11s", bf);
> +	struct hists_stdio_column *col;
> +	int ret = 0;
>  
> -		if (show_displacement) {
> -			if (displacement)
> -				scnprintf(bf, sizeof(bf), "%+4ld", displacement);
> -			else
> -				scnprintf(bf, sizeof(bf), " ");
> +	ret = snprintf(s, size, "  ");
>  
> -			if (sep)
> -				ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
> -			else
> -				ret += scnprintf(s + ret, size - ret, "%6.6s", bf);
> -		}
> +	list_for_each_entry(col, &hists_stdio_column__list, list) {
> +		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
> +		ret += col->snprintf(he, s + ret, size - ret,
> +				       hists__col_len(hists, col->col_idx));
>  	}
>  
>  	return ret;
> @@ -440,9 +516,8 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
>  }
>  
>  static int hist_entry__fprintf(struct hist_entry *he, size_t size,
> -			       struct hists *hists, struct hists *pair_hists,
> -			       bool show_displacement, long displacement,
> -			       u64 total_period, FILE *fp)
> +			       struct hists *hists, u64 total_period,
> +			       FILE *fp)
>  {
>  	char bf[512];
>  	int ret;
> @@ -450,9 +525,8 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
>  	if (size == 0 || size > sizeof(bf))
>  		size = sizeof(bf);
>  
> -	ret = hist_entry__period_snprintf(he, bf, size, pair_hists,
> -					  show_displacement, displacement,
> -					  true, total_period);
> +	ret = hists_stdio_column__snprintf(he, bf, size, hists);
> +
>  	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
>  
>  	ret = fprintf(fp, "%s\n", bf);
> @@ -464,138 +538,117 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
>  	return ret;
>  }
>  
> -size_t hists__fprintf(struct hists *hists, struct hists *pair,
> -		      bool show_displacement, bool show_header, int max_rows,
> -		      int max_cols, FILE *fp)
> +static void fprintf_header(FILE *fp, struct hists *hists,
> +			   const char *header, int col)
>  {
> -	struct sort_entry *se;
> -	struct rb_node *nd;
> -	size_t ret = 0;
> -	u64 total_period;
> -	long displacement = 0;
> -	unsigned int width;
> -	const char *sep = symbol_conf.field_sep;
>  	const char *col_width = symbol_conf.col_width_list_str;
> -	int nr_rows = 0;
> -
> -	init_rem_hits();
> -
> -	if (!show_header)
> -		goto print_entries;
> +	const char *sep = symbol_conf.field_sep;
> +	unsigned int width;
>  
> -	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
> +	if (sep) {
> +		fprintf(fp, "%c%s", *sep, header);
> +		return;
> +	}
>  
> -	if (symbol_conf.show_cpu_utilization) {
> -		if (sep) {
> -			ret += fprintf(fp, "%csys", *sep);
> -			ret += fprintf(fp, "%cus", *sep);
> -			if (perf_guest) {
> -				ret += fprintf(fp, "%cguest sys", *sep);
> -				ret += fprintf(fp, "%cguest us", *sep);
> -			}
> -		} else {
> -			ret += fprintf(fp, "     sys  ");
> -			ret += fprintf(fp, "      us  ");
> -			if (perf_guest) {
> -				ret += fprintf(fp, "  guest sys  ");
> -				ret += fprintf(fp, "  guest us  ");
> -			}
> +	width = strlen(header);
> +	if (symbol_conf.col_width_list_str) {
> +		if (col_width) {
> +			hists__set_col_len(hists, col,
> +					   atoi(col_width));
> +			col_width = strchr(col_width, ',');
> +			if (col_width)
> +				++col_width;
>  		}
>  	}
>  
> -	if (symbol_conf.show_nr_samples) {
> -		if (sep)
> -			fprintf(fp, "%cSamples", *sep);
> -		else
> -			fputs("  Samples  ", fp);
> -	}
> +	if (!hists__new_col_len(hists, col, width))
> +		width = hists__col_len(hists, col);
>  
> -	if (symbol_conf.show_total_period) {
> -		if (sep)
> -			ret += fprintf(fp, "%cPeriod", *sep);
> -		else
> -			ret += fprintf(fp, "   Period    ");
> -	}
> +	fprintf(fp, "  %*s", width, header);
> +}
>  
> -	if (pair) {
> -		if (sep)
> -			ret += fprintf(fp, "%cDelta", *sep);
> -		else
> -			ret += fprintf(fp, "  Delta    ");
> +static void fprintf_dots(FILE *fp, struct hists *hists,
> +			 const char *header, int col)
> +{
> +	unsigned int width;
> +	unsigned int i;
>  
> -		if (show_displacement) {
> -			if (sep)
> -				ret += fprintf(fp, "%cDisplacement", *sep);
> -			else
> -				ret += fprintf(fp, " Displ");
> -		}
> -	}
> +	fprintf(fp, "  ");
> +	width = hists__col_len(hists, col);
> +
> +	if (width == 0)
> +		width = strlen(header);
> +
> +	for (i = 0; i < width; i++)
> +		fprintf(fp, ".");
> +}
> +
> +static int hists__fprintf_header(struct hists *hists, FILE *fp,
> +				 int max_rows, int max_cols __used)
> +{
> +	struct sort_entry *se;
> +	struct hists_stdio_column *col;
> +	int nr_rows = 0;
> +
> +	/*
> +	 * TODO Both fprintf_header and fprintf_dots should take
> +	 * max_cols and output data appropriatelly. Seems there was
> +	 * no need so far ;)
> +	 */
> +
> +	/* First line - headers */
> +	fprintf(fp, "# ");
> +
> +	list_for_each_entry(col, &hists_stdio_column__list, list)
> +		fprintf_header(fp, hists, col->header, col->col_idx);
>  
>  	list_for_each_entry(se, &hist_entry__sort_list, list) {
>  		if (se->elide)
>  			continue;
> -		if (sep) {
> -			fprintf(fp, "%c%s", *sep, se->se_header);
> -			continue;
> -		}
> -		width = strlen(se->se_header);
> -		if (symbol_conf.col_width_list_str) {
> -			if (col_width) {
> -				hists__set_col_len(hists, se->se_width_idx,
> -						   atoi(col_width));
> -				col_width = strchr(col_width, ',');
> -				if (col_width)
> -					++col_width;
> -			}
> -		}
> -		if (!hists__new_col_len(hists, se->se_width_idx, width))
> -			width = hists__col_len(hists, se->se_width_idx);
> -		fprintf(fp, "  %*s", width, se->se_header);
> +
> +		fprintf_header(fp, hists, se->se_header, se->se_width_idx);
>  	}
>  
>  	fprintf(fp, "\n");
> +
>  	if (max_rows && ++nr_rows >= max_rows)
> -		goto out;
> +		return nr_rows;
>  
> -	if (sep)
> -		goto print_entries;
> +	if (symbol_conf.field_sep)
> +		return nr_rows;
>  
> -	fprintf(fp, "# ........");
> -	if (symbol_conf.show_cpu_utilization)
> -		fprintf(fp, "   .......   .......");
> -	if (symbol_conf.show_nr_samples)
> -		fprintf(fp, " ..........");
> -	if (symbol_conf.show_total_period)
> -		fprintf(fp, " ............");
> -	if (pair) {
> -		fprintf(fp, " ..........");
> -		if (show_displacement)
> -			fprintf(fp, " .....");
> -	}
> -	list_for_each_entry(se, &hist_entry__sort_list, list) {
> -		unsigned int i;
> +	/* Second line - dots */
> +	fprintf(fp, "# ");
> +
> +	list_for_each_entry(col, &hists_stdio_column__list, list)
> +		fprintf_dots(fp, hists, col->header, col->col_idx);
>  
> +	list_for_each_entry(se, &hist_entry__sort_list, list) {
>  		if (se->elide)
>  			continue;
>  
> -		fprintf(fp, "  ");
> -		width = hists__col_len(hists, se->se_width_idx);
> -		if (width == 0)
> -			width = strlen(se->se_header);
> -		for (i = 0; i < width; i++)
> -			fprintf(fp, ".");
> +		fprintf_dots(fp, hists, se->se_header, se->se_width_idx);
>  	}
>  
>  	fprintf(fp, "\n");
>  	if (max_rows && ++nr_rows >= max_rows)
> -		goto out;
> +		return nr_rows;
>  
>  	fprintf(fp, "#\n");
> -	if (max_rows && ++nr_rows >= max_rows)
> -		goto out;
> +	if (max_rows)
> +		 ++nr_rows;
>  
> -print_entries:
> -	total_period = hists->stats.total_period;
> +	return nr_rows;
> +}
> +
> +static size_t
> +hists__fprint_data(struct hists *hists, FILE *fp, int nr_rows,
> +		   int max_rows, int max_cols)
> +{
> +	struct rb_node *nd;
> +	size_t ret = 0;
> +
> +	init_rem_hits();
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> @@ -603,18 +656,12 @@ print_entries:
>  		if (h->filtered)
>  			continue;
>  
> -		if (show_displacement) {
> -			if (h->pair != NULL)
> -				displacement = ((long)h->pair->position -
> -					        (long)h->position);
> -			else
> -				displacement = 0;
> -		}
> -		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
> -					   displacement, total_period, fp);
> +		ret += hist_entry__fprintf(h, max_cols, hists,
> +					   hists->stats.total_period,
> +					   fp);
>  
>  		if (max_rows && ++nr_rows >= max_rows)
> -			goto out;
> +			break;
>  
>  		if (h->ms.map == NULL && verbose > 1) {
>  			__map_groups__fprintf_maps(&h->thread->mg,
> @@ -622,12 +669,25 @@ print_entries:
>  			fprintf(fp, "%.10s end\n", graph_dotted_line);
>  		}
>  	}
> -out:
> -	free(rem_sq_bracket);
>  
> +	free(rem_sq_bracket);
>  	return ret;
>  }
>  
> +size_t hists__fprintf(struct hists *hists, bool show_header,
> +		      int max_rows, int max_cols, FILE *fp)
> +{
> +	int nr_rows = 0;
> +
> +	if (show_header)
> +		nr_rows = hists__fprintf_header(hists, fp, max_rows, max_cols);
> +
> +	if (max_rows && nr_rows >= max_rows)
> +		return 0;
> +
> +	return hists__fprint_data(hists, fp, nr_rows, max_rows, max_cols);
> +}
> +
>  size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
>  {
>  	int i;
> diff --git a/tools/perf/ui/stdio/hist.h b/tools/perf/ui/stdio/hist.h
> new file mode 100644
> index 0000000..8e15d88
> --- /dev/null
> +++ b/tools/perf/ui/stdio/hist.h
> @@ -0,0 +1,19 @@
> +#ifndef __PERF_UI_STDIO_HIST_H
> +#define __PERF_UI_STDIO_HIST_H
> +
> +#include <linux/list.h>
> +#include "../../util/hist.h"
> +
> +struct hists_stdio_column {
> +	struct list_head list;
> +	const char	*header;
> +	int		 col_idx;
> +	int		 col_width;
> +	int		(*snprintf)(struct hist_entry *self, char *bf,
> +				    size_t size, unsigned int width);
> +};
> +
> +int hists_stdio_column__register_idx(int idx);
> +void hists_stdio_column__register_global(void);
> +void hists_stdio_column__set_width(struct hists *hists);
> +#endif /* __PERF_UI_STDIO_HIST_H */
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 0ed0683..5fb5cd8 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -5,6 +5,7 @@
>  #include "session.h"
>  #include "sort.h"
>  #include <math.h>
> +#include "../ui/stdio/hist.h"
>  
>  static bool hists__filter_entry_by_dso(struct hists *hists,
>  				       struct hist_entry *he);
> @@ -49,7 +50,9 @@ void hists__reset_col_len(struct hists *hists)
>  {
>  	enum hist_column col;
>  
> -	for (col = 0; col < HISTC_NR_COLS; ++col)
> +	hists_stdio_column__set_width(hists);
> +
> +	for (col = HISTC_SYMBOL; col < HISTC_NR_COLS; ++col)
>  		hists__set_col_len(hists, col, 0);
>  }
>  
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 2e650ff..36ff4c5 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -36,6 +36,19 @@ struct events_stats {
>  };
>  
>  enum hist_column {
> +	/* stdio (hists_stdio_column__list) */
> +	HISTC_OVERHEAD,
> +	HISTC_BASELINE,
> +	HISTC_CPU_UTILIZATION_SYS,
> +	HISTC_CPU_UTILIZATION_US,
> +	HISTC_CPU_UTILIZATION_GUEST_SYS,
> +	HISTC_CPU_UTILIZATION_GUEST_US,
> +	HISTC_NR_SAMPLES,
> +	HISTC_TOTAL_PERIOD,
> +	HISTC_DELTA,
> +	HISTC_DISPLACEMENT,
> +
> +	/* sorted (hist_entry__sort_list) */
>  	HISTC_SYMBOL,
>  	HISTC_DSO,
>  	HISTC_THREAD,
> @@ -49,6 +62,9 @@ enum hist_column {
>  	HISTC_DSO_TO,
>  	HISTC_SRCLINE,
>  	HISTC_NR_COLS, /* Last entry */
> +
> +	/* Last stdio ui data column */
> +	HISTC_STDIO_NR_COLS = HISTC_DISPLACEMENT + 1,
>  };
>  
>  struct thread;
> @@ -98,8 +114,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
>  void hists__inc_nr_events(struct hists *self, u32 type);
>  size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
>  
> -size_t hists__fprintf(struct hists *self, struct hists *pair,
> -		      bool show_displacement, bool show_header,
> +size_t hists__fprintf(struct hists *self, bool show_header,
>  		      int max_rows, int max_cols, FILE *fp);
>  
>  int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
