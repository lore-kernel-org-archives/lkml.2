Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab2IGGFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:05:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61257 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2IGGFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:05:36 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-6c-50498eae6c96
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
Subject: Re: [PATCH 09/12] perf diff: Add weighted diff computation way to compare hist entries
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	<1346946426-13496-10-git-send-email-jolsa@redhat.com>
Date: Fri, 07 Sep 2012 14:58:19 +0900
In-Reply-To: <1346946426-13496-10-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Thu, 6 Sep 2012 17:47:03 +0200")
Message-ID: <87wr06bchw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Sep 2012 17:47:03 +0200, Jiri Olsa wrote:
> Adding 'wdiff' as new computation way to compare hist entries.
>
> If specified the 'Weighted diff' column is displayed with value 'd'
> computed as:
>
>    d = B->period * WEIGHT-A - A->period * WEIGHT-B
>
>   - A/B being matching hist entry from first/second file specified
>     (or perf.data/perf.data.old) respectively.
>
>   - period being the hist entry period value
>
>   - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
>     behind ':' separator like '-c wdiff:1,2'.
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
>  tools/perf/Documentation/perf-diff.txt | 15 +++++-
>  tools/perf/builtin-diff.c              | 95 +++++++++++++++++++++++++++++++++-
>  tools/perf/ui/stdio/hist.c             | 15 ++++++
>  tools/perf/ui/stdio/hist.h             |  1 +
>  tools/perf/util/hist.h                 |  1 +
>  tools/perf/util/sort.h                 |  3 ++
>  6 files changed, 127 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
> index cff3d9b..fa413ac 100644
> --- a/tools/perf/Documentation/perf-diff.txt
> +++ b/tools/perf/Documentation/perf-diff.txt
> @@ -78,7 +78,7 @@ OPTIONS
>  
>  -c::
>  --compute::
> -        Differential computation selection - delta,ratio (default is delta).
> +        Differential computation selection - delta,ratio,wdiff (default is delta).
>          If '+' is specified as a first character, the output is sorted based
>          on the computation results.
>          See COMPARISON METHODS section for more info.
> @@ -110,6 +110,19 @@ with:
>  
>    - period being the hist entry period value
>  
> +wdiff
> +~~~~~
> +If specified the 'Weighted diff' column is displayed with value 'd' computed as:
> +
> +   d = B->period * WEIGHT-A - A->period * WEIGHT-B
> +
> +  - A/B being matching hist entry from first/second file specified
> +    (or perf.data/perf.data.old) respectively.
> +
> +  - period being the hist entry period value
> +
> +  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
> +    behind ':' separator like '-c wdiff:1,2'.
>  
>  SEE ALSO
>  --------
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index f72a2e4..6d8aba8 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -28,23 +28,79 @@ static bool show_displacement;
>  static bool show_baseline_only;
>  static bool sort_compute;
>  
> +static s64 compute_wdiff_w1;
> +static s64 compute_wdiff_w2;
> +
>  enum {
>  	COMPUTE_DELTA,
>  	COMPUTE_RATIO,
> +	COMPUTE_WEIGHTED_DIFF,
>  	COMPUTE_MAX,
>  };
>  
>  const char *compute_names[COMPUTE_MAX] = {
>  	[COMPUTE_DELTA] = "delta",
>  	[COMPUTE_RATIO] = "ratio",
> +	[COMPUTE_WEIGHTED_DIFF] = "wdiff",
>  };
>  
>  static const char *compute_str;
>  static int compute;
>  
> +static int setup_compute_opt_wdiff(char *opt)
> +{
> +	char *w1_str = opt;
> +	char *w2_str;
> +
> +	int ret = -EINVAL;
> +
> +	do {
> +		if (!opt)
> +			break;
> +
> +		w2_str = strchr(opt, ',');
> +		if (!w2_str)
> +			break;
> +
> +		*w2_str++ = 0x0;
> +		if (!*w2_str)
> +			break;
> +
> +		compute_wdiff_w1 = strtol(w1_str, NULL, 10);
> +		compute_wdiff_w2 = strtol(w2_str, NULL, 10);
> +
> +		if (!compute_wdiff_w1 || !compute_wdiff_w2)
> +			break;
> +
> +		pr_debug("compute wdiff w1(%" PRId64 ") w2(%" PRId64 ")\n",
> +			  compute_wdiff_w1, compute_wdiff_w2);
> +		ret = 0;
> +
> +	} while (0);

I don't see why this do { } while(0) loop is necessary.
How about this?

	w1 = strtol(opt, &tmp, 10);
	if (*tmp != ',')
		goto error;

	opt = tmp + 1;
	w2 = strtol(opt, &tmp, 10);
	if (*tmp != '\0')
		goto error;

	if (!w1 || !w2)
		goto error;

Thanks,
Namhyung


> +
> +	if (ret)
> +		pr_err("Weight parsing failed.");
> +
> +	return ret;
> +}
> +
> +static int setup_compute_opt(char *opt)
> +{
> +	if (compute == COMPUTE_WEIGHTED_DIFF)
> +		return setup_compute_opt_wdiff(opt);
> +
> +	if (opt) {
> +		pr_err("Extra option specified.");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int setup_compute(void)
>  {
>  	unsigned i;
> +	char *opt;
>  
>  	if (!compute_str) {
>  		compute = COMPUTE_DELTA;
> @@ -58,10 +114,14 @@ static int setup_compute(void)
>  			return 0;
>  	}
>  
> +	opt = strchr(compute_str, ':');
> +	if (opt)
> +		*opt++ = 0x0;
> +
>  	for (i = 0; i < COMPUTE_MAX; i++)
>  		if (!strcmp(compute_str, compute_names[i])) {
>  			compute = i;
> -			return 0;
> +			return setup_compute_opt(opt);
>  		}
>  
>  	pr_err("Failed to find valid compute string\n");
> @@ -96,6 +156,23 @@ double perf_diff__compute_ratio(struct hist_entry *he)
>  	return he->diff.period_ratio;
>  }
>  
> +double perf_diff__compute_wdiff(struct hist_entry *he)
> +{
> +	struct hist_entry *pair = he->pair;
> +	u64 new_period = he->period;
> +	u64 old_period = pair ? pair->period : 0;
> +
> +	he->diff.computed = true;
> +
> +	if (!pair)
> +		he->diff.wdiff = 0;
> +	else
> +		he->diff.wdiff = new_period * compute_wdiff_w2 -
> +				 old_period * compute_wdiff_w1;
> +
> +	return he->diff.wdiff;
> +}
> +
>  static int hists__add_entry(struct hists *self,
>  			    struct addr_location *al, u64 period)
>  {
> @@ -277,6 +354,9 @@ static void hists__precompute(struct hists *hists)
>  		case COMPUTE_RATIO:
>  			perf_diff__compute_ratio(he);
>  			break;
> +		case COMPUTE_WEIGHTED_DIFF:
> +			perf_diff__compute_wdiff(he);
> +			break;
>  		default:
>  			BUG_ON(1);
>  		}
> @@ -312,6 +392,13 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
>  
>  		return cmp_doubles(l, r);
>  	}
> +	case COMPUTE_WEIGHTED_DIFF:
> +	{
> +		s64 l = left->diff.wdiff;
> +		s64 r = right->diff.wdiff;
> +
> +		return r - l;
> +	}
>  	default:
>  		BUG_ON(1);
>  	}
> @@ -436,7 +523,8 @@ static const struct option options[] = {
>  		    "Show position displacement relative to baseline"),
>  	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
>  		    "Show only items with match in baseline"),
> -	OPT_STRING('c', "compute", &compute_str, "delta,ratio (default delta)",
> +	OPT_STRING('c', "compute", &compute_str,
> +		   "delta,ratio,wdiff:w1,w2 (default delta)",
>  		   "Entries differential computation selection"),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
> @@ -471,6 +559,9 @@ static void setup_ui_stdio(void)
>  	case COMPUTE_RATIO:
>  		hists_stdio_column__register_idx(HISTC_RATIO);
>  		break;
> +	case COMPUTE_WEIGHTED_DIFF:
> +		hists_stdio_column__register_idx(HISTC_WEIGHTED_DIFF);
> +		break;
>  	default:
>  		BUG_ON(1);
>  	};
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 8c717ab..f580085 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -47,6 +47,20 @@ hists_stdio_column__ratio_snprintf(struct hist_entry *he, char *bf,
>  }
>  
>  static int
> +hists_stdio_column__wdiff_snprintf(struct hist_entry *he, char *bf,
> +				   size_t size, unsigned int width __used)
> +{
> +	u64 wdiff;
> +
> +	if (he->diff.computed)
> +		wdiff = he->diff.wdiff;
> +	else
> +		wdiff = perf_diff__compute_wdiff(he);
> +
> +	return scnprintf(bf, size , "%+13ld", wdiff);
> +}
> +
> +static int
>  hists_stdio_column__baseline_snprintf(struct hist_entry *he, char *bf,
>  				      size_t size, unsigned int width __used)
>  {
> @@ -141,6 +155,7 @@ DEF_COLUMN(nr_samples, HISTC_NR_SAMPLES, 12, "Samples")
>  DEF_COLUMN(total_period, HISTC_TOTAL_PERIOD, 12, "Period")
>  DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
>  DEF_COLUMN(ratio, HISTC_RATIO, 14, "Ratio")
> +DEF_COLUMN(wdiff, HISTC_WEIGHTED_DIFF, 13, "Weighted diff")
>  DEF_COLUMN(displacement, HISTC_DISPLACEMENT, 5, "Displ")
>  };
>  
> diff --git a/tools/perf/ui/stdio/hist.h b/tools/perf/ui/stdio/hist.h
> index c8ac633..f725189 100644
> --- a/tools/perf/ui/stdio/hist.h
> +++ b/tools/perf/ui/stdio/hist.h
> @@ -19,5 +19,6 @@ void hists_stdio_column__set_width(struct hists *hists);
>  
>  double perf_diff__compute_delta(struct hist_entry *he);
>  double perf_diff__compute_ratio(struct hist_entry *he);
> +double perf_diff__compute_wdiff(struct hist_entry *he);
>  
>  #endif /* __PERF_UI_STDIO_HIST_H */
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index b24341d..745e0cc 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -47,6 +47,7 @@ enum hist_column {
>  	HISTC_TOTAL_PERIOD,
>  	HISTC_DELTA,
>  	HISTC_RATIO,
> +	HISTC_WEIGHTED_DIFF,
>  	HISTC_DISPLACEMENT,
>  
>  	/* sorted (hist_entry__sort_list) */
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index 9f707b7..73f1ffe 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -53,6 +53,9 @@ struct hist_entry_diff {
>  
>  	/* HISTC_RATIO */
>  	double	period_ratio;
> +
> +	/* HISTC_WEIGHTED_DIFF */
> +	s64	wdiff;
>  };
>  
>  /**
