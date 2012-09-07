Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2IGFwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:52:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44111 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2IGFwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:52:45 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-78-50498bab889c
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
Subject: Re: [PATCH 07/12] perf diff: Add ratio computation way to compare hist entries
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	<1346946426-13496-8-git-send-email-jolsa@redhat.com>
Date: Fri, 07 Sep 2012 14:45:28 +0900
In-Reply-To: <1346946426-13496-8-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 6 Sep 2012 17:47:01 +0200")
Message-ID: <871uiecrnr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Sep 2012 17:47:01 +0200, Jiri Olsa wrote:
> Adding -c option to select computation method with the current
> 'Delta' computation as default. Current posible values are of
> this option are: 'delta' and 'ratio'.
>
> Adding 'ratio' as new computation way to compare hist entries.
> If specified the 'Ratio' column is displayed with value 'r'
> computed as:
>
>   r = A->period / B->period
>
> with:
>   - A/B being matching hist entry from first/second file specified
>     (or perf.data/perf.data.old) respectively.
>   - period being the hist entry period value
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
>  tools/perf/Documentation/perf-diff.txt | 33 ++++++++++++++++++++++
>  tools/perf/builtin-diff.c              | 51 +++++++++++++++++++++++++++++++++-
>  tools/perf/ui/stdio/hist.c             | 13 +++++++++
>  tools/perf/util/hist.h                 |  1 +
>  4 files changed, 97 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
> index 6ce9585..8fff061 100644
> --- a/tools/perf/Documentation/perf-diff.txt
> +++ b/tools/perf/Documentation/perf-diff.txt
> @@ -76,6 +76,39 @@ OPTIONS
>  --baseline-only::
>          Show only items with match in baseline.
>  
> +-c::
> +--compute::
> +        Differential computation selection - delta,ratio (default is delta).
> +        See COMPARISON METHODS section for more info.
> +
> +COMPARISON METHODS
> +------------------
> +delta
> +~~~~~
> +If specified the 'Delta' column is displayed with value 'd' computed as:
> +
> +  d = A->period_percent - B->period_percent
> +
> +with:
> +  - A/B being matching hist entry from first/second file specified
> +    (or perf.data/perf.data.old) respectively.
> +
> +  - period_percent being the % of the hist entry period value within
> +    single data file
> +
> +ratio
> +~~~~~
> +If specified the 'Ratio' column is displayed with value 'r' computed as:
> +
> +  r = A->period / B->period
> +
> +with:
> +  - A/B being matching hist entry from first/second file specified
> +    (or perf.data/perf.data.old) respectively.
> +
> +  - period being the hist entry period value
> +
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1]
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 46f4a10..cde08d4 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -27,6 +27,39 @@ static bool  force;
>  static bool show_displacement;
>  static bool show_baseline_only;
>  
> +enum {
> +	COMPUTE_DELTA,
> +	COMPUTE_RATIO,
> +	COMPUTE_MAX,
> +};
> +
> +const char *compute_names[COMPUTE_MAX] = {
> +	[COMPUTE_DELTA] = "delta",
> +	[COMPUTE_RATIO] = "ratio",
> +};
> +
> +static const char *compute_str;
> +static int compute;
> +
> +static int setup_compute(void)
> +{
> +	unsigned i;
> +
> +	if (!compute_str) {
> +		compute = COMPUTE_DELTA;
> +		return 0;
> +	}
> +
> +	for (i = 0; i < COMPUTE_MAX; i++)
> +		if (!strcmp(compute_str, compute_names[i])) {
> +			compute = i;
> +			return 0;
> +		}
> +
> +	pr_err("Failed to find valid compute string\n");
> +	return -EINVAL;
> +}
> +
>  static int hists__add_entry(struct hists *self,
>  			    struct addr_location *al, u64 period)
>  {
> @@ -263,6 +296,8 @@ static const struct option options[] = {
>  		    "Show position displacement relative to baseline"),
>  	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
>  		    "Show only items with match in baseline"),
> +	OPT_STRING('c', "compute", &compute_str, "delta,ratio (default delta)",
> +		   "Entries differential computation selection"),

Why not make it OPT_CALLBACK?

Thanks,
Namhyung


>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
>  	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
> @@ -288,7 +323,18 @@ static void setup_ui_stdio(void)
>  {
>  	hists_stdio_column__register_idx(HISTC_BASELINE);
>  	hists_stdio_column__register_global();
> -	hists_stdio_column__register_idx(HISTC_DELTA);
> +
> +	switch (compute) {
> +	case COMPUTE_DELTA:
> +		hists_stdio_column__register_idx(HISTC_DELTA);
> +		break;
> +	case COMPUTE_RATIO:
> +		hists_stdio_column__register_idx(HISTC_RATIO);
> +		break;
> +	default:
> +		BUG_ON(1);
> +	};
> +
>  	if (show_displacement)
>  		hists_stdio_column__register_idx(HISTC_DISPLACEMENT);
>  }
> @@ -315,6 +361,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __used)
>  	if (symbol__init() < 0)
>  		return -1;
>  
> +	if (setup_compute())
> +		usage_with_options(diff_usage, options);
> +
>  	setup_sorting(diff_usage, options);
>  	setup_ui_stdio();
>  	setup_pager();
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 48fb0b3..02ba1c7 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -31,6 +31,18 @@ hists_stdio_column__delta_snprintf(struct hist_entry *he, char *bf,
>  }
>  
>  static int
> +hists_stdio_column__ratio_snprintf(struct hist_entry *he, char *bf,
> +				   size_t size, unsigned int width __used)
> +{
> +	struct hist_entry *pair = he->pair;
> +	double new_period = he->period;
> +	double old_period = pair ? pair->period : 0;
> +	double ratio = pair ? new_period / old_period : 0;
> +
> +	return percent_color_snprintf(bf, size, "%14.3F", ratio);
> +}
> +
> +static int
>  hists_stdio_column__baseline_snprintf(struct hist_entry *he, char *bf,
>  				      size_t size, unsigned int width __used)
>  {
> @@ -124,6 +136,7 @@ DEF_COLUMN(cpu_guest_us, HISTC_CPU_UTILIZATION_GUEST_US, 8, "guest us")
>  DEF_COLUMN(nr_samples, HISTC_NR_SAMPLES, 12, "Samples")
>  DEF_COLUMN(total_period, HISTC_TOTAL_PERIOD, 12, "Period")
>  DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
> +DEF_COLUMN(ratio, HISTC_RATIO, 14, "Ratio")
>  DEF_COLUMN(displacement, HISTC_DISPLACEMENT, 5, "Displ")
>  };
>  
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 36ff4c5..b24341d 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -46,6 +46,7 @@ enum hist_column {
>  	HISTC_NR_SAMPLES,
>  	HISTC_TOTAL_PERIOD,
>  	HISTC_DELTA,
> +	HISTC_RATIO,
>  	HISTC_DISPLACEMENT,
>  
>  	/* sorted (hist_entry__sort_list) */
