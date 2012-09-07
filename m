Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab2IGGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:09:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61934 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2IGGJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:09:54 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-f2-50498fb0714b
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
Subject: Re: [PATCH 11/12] perf diff: Add -F option to display formula for computation
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	<1346946426-13496-12-git-send-email-jolsa@redhat.com>
Date: Fri, 07 Sep 2012 15:02:37 +0900
In-Reply-To: <1346946426-13496-12-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Thu, 6 Sep 2012 17:47:05 +0200")
Message-ID: <87sjaubcaq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Sep 2012 17:47:05 +0200, Jiri Olsa wrote:
> Adding -F option to display the formula for specified computation.
> This is mainly to facilitate debuging, but can be usefull anyway.
>
> Adding this support for weighted diff computation.
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
>  tools/perf/Documentation/perf-diff.txt |  4 ++++
>  tools/perf/builtin-diff.c              | 27 ++++++++++++++++++++++++++-
>  tools/perf/ui/stdio/hist.c             |  8 ++++++++
>  tools/perf/ui/stdio/hist.h             |  1 +
>  tools/perf/util/hist.h                 |  3 ++-
>  5 files changed, 41 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
> index 21cc2ef..4d65407 100644
> --- a/tools/perf/Documentation/perf-diff.txt
> +++ b/tools/perf/Documentation/perf-diff.txt
> @@ -87,6 +87,10 @@ OPTIONS
>  --period::
>          Show period values for both compared hist entries.
>  
> +-F::
> +--formula::
> +        Show formula for given computation (supported: wdiff)
> +
>  COMPARISON METHODS
>  ------------------
>  delta
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 1297a01..9125eee 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -26,6 +26,7 @@ static char	  diff__default_sort_order[] = "dso,symbol";
>  static bool  force;
>  static bool show_displacement;
>  static bool show_period;
> +static bool show_formula;
>  static bool show_baseline_only;
>  static bool sort_compute;
>  
> @@ -174,6 +175,20 @@ double perf_diff__compute_wdiff(struct hist_entry *he)
>  	return he->diff.wdiff;
>  }
>  
> +int perf_diff__formula_wdiff(struct hist_entry *he, char *bf, size_t size)
> +{
> +	struct hist_entry *pair = he->pair;
> +	u64 new_period = he->period;
> +	u64 old_period = pair ? pair->period : 0;
> +	char formula[100];
> +
> +	scnprintf(formula, 100,
> +		  "(%" PRIu64 " * " "%" PRId64 ") - (%" PRIu64 " * " "%" PRId64 ")",
> +		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
> +
> +	return scnprintf(bf, size, "%-50s", formula);
> +}
> +
>  static int hists__add_entry(struct hists *self,
>  			    struct addr_location *al, u64 period)
>  {
> @@ -529,6 +544,8 @@ static const struct option options[] = {
>  		   "Entries differential computation selection"),
>  	OPT_BOOLEAN('p', "period", &show_period,
>  		    "Show period values."),
> +	OPT_BOOLEAN('F', "formula", &show_formula,
> +		    "Show formula."),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
>  	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
> @@ -572,11 +589,19 @@ static void setup_ui_stdio(void)
>  	if (show_displacement)
>  		hists_stdio_column__register_idx(HISTC_DISPLACEMENT);
>  
> +	if (show_formula)
> +		switch (compute) {
> +		case COMPUTE_WEIGHTED_DIFF:
> +			hists_stdio_column__register_idx(HISTC_FORMULA_WEIGHTED_DIFF);
> +			break;
> +		default:
> +			break;
> +	};
> +
>  	if (show_period) {
>  		hists_stdio_column__register_idx(HISTC_BASELINE_TOTAL_PERIOD);
>  		hists_stdio_column__register_idx(HISTC_TOTAL_PERIOD);
>  	}
> -
>  }
>  
>  int cmd_diff(int argc, const char **argv, const char *prefix __used)
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index ab5f27a..8cf4ebd 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -150,6 +150,13 @@ hists_stdio_column__displacement_snprintf(struct hist_entry *he, char *bf,
>  	return scnprintf(bf, size, displ ? "%+5ld" : "     ", displ);
>  }
>  
> +static int
> +hists_stdio_column__formula_wdiff_snprintf(struct hist_entry *he, char *bf,
> +					   size_t size, unsigned int width __used)
> +{
> +	return perf_diff__formula_wdiff(he, bf, size);
> +}
> +
>  LIST_HEAD(hists_stdio_column__list);
>  
>  #define DEF_COLUMN(name, c, w, h)					\
> @@ -175,6 +182,7 @@ DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
>  DEF_COLUMN(ratio, HISTC_RATIO, 14, "Ratio")
>  DEF_COLUMN(wdiff, HISTC_WEIGHTED_DIFF, 13, "Weighted diff")
>  DEF_COLUMN(displacement, HISTC_DISPLACEMENT, 5, "Displ")
> +DEF_COLUMN(formula_wdiff, HISTC_FORMULA_WEIGHTED_DIFF, 50, "Formula")

This fixed 50 column width looks too large to me.  What about make it
dynamic like sort_list?

Thanks,
Namhyung


>  };
>  
>  int hists_stdio_column__register_idx(int idx)
> diff --git a/tools/perf/ui/stdio/hist.h b/tools/perf/ui/stdio/hist.h
> index f725189..4f62224 100644
> --- a/tools/perf/ui/stdio/hist.h
> +++ b/tools/perf/ui/stdio/hist.h
> @@ -21,4 +21,5 @@ double perf_diff__compute_delta(struct hist_entry *he);
>  double perf_diff__compute_ratio(struct hist_entry *he);
>  double perf_diff__compute_wdiff(struct hist_entry *he);
>  
> +int perf_diff__formula_wdiff(struct hist_entry *he, char *bf, size_t size);
>  #endif /* __PERF_UI_STDIO_HIST_H */
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 81e6d20..e1511cc 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -50,6 +50,7 @@ enum hist_column {
>  	HISTC_RATIO,
>  	HISTC_WEIGHTED_DIFF,
>  	HISTC_DISPLACEMENT,
> +	HISTC_FORMULA_WEIGHTED_DIFF,
>  
>  	/* sorted (hist_entry__sort_list) */
>  	HISTC_SYMBOL,
> @@ -67,7 +68,7 @@ enum hist_column {
>  	HISTC_NR_COLS, /* Last entry */
>  
>  	/* Last stdio ui data column */
> -	HISTC_STDIO_NR_COLS = HISTC_DISPLACEMENT + 1,
> +	HISTC_STDIO_NR_COLS = HISTC_FORMULA_WEIGHTED_DIFF + 1,
>  };
>  
>  struct thread;
