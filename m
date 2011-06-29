Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1F2SHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:07:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38288 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1F2SHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:07:43 -0400
Message-ID: <4E0B69EC.70009@gmail.com>
Date: Wed, 29 Jun 2011 12:07:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf report/annotate: Add option to specify a CPU range
References: <20110629150739.49b25604@kryten>
In-Reply-To: <20110629150739.49b25604@kryten>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/28/2011 11:07 PM, Anton Blanchard wrote:
> 
> Add an option to perf report and perf annotate to specify which CPUs

What about perf-script?

> to operate on. This enables us to take a single system wide profile
> and analyse each CPU (or group of CPUs) in isolation.
> 
> This was useful when profiling a multiprocess workload where the
> bottleneck was on one CPU but this was hidden in the overall profile.
> Per process and per thread breakdowns didn't help because multiple
> processes were running on each CPU and no single process consumed
> an entire CPU.
> 
> The patch converts the list of CPUs returned by cpu_map__new into a
> bitmap for fast lookup. I wanted to use -C to be consistent with perf
> top/record/stat, but unfortunately perf report already uses -C <comms>.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> I capped it at MAX_NR_CPUS to avoid having to dynamically allocate
> cpu_bitmap, but we could do that if the extra complexity is worth it.
> 
> Index: linux-2.6-tip/tools/perf/builtin-report.c
> ===================================================================
> --- linux-2.6-tip.orig/tools/perf/builtin-report.c	2011-06-29 09:01:46.209676867 +1000
> +++ linux-2.6-tip/tools/perf/builtin-report.c	2011-06-29 14:53:26.131226181 +1000
> @@ -33,6 +33,9 @@
>  #include "util/sort.h"
>  #include "util/hist.h"
>  
> +#include <linux/bitmap.h>
> +#include "util/cpumap.h"
> +
>  static char		const *input_name = "perf.data";
>  
>  static bool		force, use_tui, use_stdio;
> @@ -48,6 +51,9 @@ static const char	*pretty_printing_style
>  static char		callchain_default_opt[] = "fractal,0.5";
>  static symbol_filter_t	annotate_init;
>  
> +static const char	*cpu_list;
> +static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
> +
>  static int perf_session__add_hist_entry(struct perf_session *session,
>  					struct addr_location *al,
>  					struct perf_sample *sample,
> @@ -116,6 +122,9 @@ static int process_sample_event(union pe
>  	if (al.filtered || (hide_unresolved && al.sym == NULL))
>  		return 0;
>  
> +	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
> +		return 0;
> +

Need to check that the SAMPLE_CPU attribute is set for the event for
which the sample is generated; see builtin-script.c,
perf_evsel__check_attr().

>  	if (al.map != NULL)
>  		al.map->dso->hit = 1;
>  
> @@ -455,6 +464,7 @@ static const struct option options[] = {
>  		    "Only display entries resolved to a symbol"),
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
> +	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),

This option should be added to the Documentation file,
Documentation/perf-report.txt

Same comments for perf-annotate changes below.

David


>  	OPT_END()
>  };
>  
> @@ -501,6 +511,23 @@ int cmd_report(int argc, const char **ar
>  
>  	setup_sorting(report_usage, options);
>  
> +	if (cpu_list) {
> +		int i;
> +		struct cpu_map *map = cpu_map__new(cpu_list);
> +
> +		for (i = 0; i < map->nr; i++) {
> +			int cpu = map->map[i];
> +
> +			if (cpu >= MAX_NR_CPUS) {
> +				fprintf(stderr, "Requested CPU %d too large, "
> +					"consider raising MAX_NR_CPUS\n", cpu);
> +				return -1;
> +			}
> +
> +			set_bit(cpu, cpu_bitmap);
> +		}
> +	}
> +
>  	if (parent_pattern != default_parent_pattern) {
>  		if (sort_dimension__add("parent") < 0)
>  			return -1;
> Index: linux-2.6-tip/tools/perf/builtin-annotate.c
> ===================================================================
> --- linux-2.6-tip.orig/tools/perf/builtin-annotate.c	2011-06-29 09:01:46.199676692 +1000
> +++ linux-2.6-tip/tools/perf/builtin-annotate.c	2011-06-29 09:01:56.519857004 +1000
> @@ -28,6 +28,9 @@
>  #include "util/hist.h"
>  #include "util/session.h"
>  
> +#include <linux/bitmap.h>
> +#include "util/cpumap.h"
> +
>  static char		const *input_name = "perf.data";
>  
>  static bool		force, use_tui, use_stdio;
> @@ -38,6 +41,9 @@ static bool		print_line;
>  
>  static const char *sym_hist_filter;
>  
> +static const char	*cpu_list;
> +static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
> +
>  static int perf_evlist__add_sample(struct perf_evlist *evlist,
>  				   struct perf_sample *sample,
>  				   struct perf_evsel *evsel,
> @@ -90,6 +96,9 @@ static int process_sample_event(union pe
>  		return -1;
>  	}
>  
> +	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
> +		return 0;
> +
>  	if (!al.filtered &&
>  	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
>  		pr_warning("problem incrementing symbol count, "
> @@ -252,6 +261,7 @@ static const struct option options[] = {
>  		    "print matching source lines (may be slow)"),
>  	OPT_BOOLEAN('P', "full-paths", &full_paths,
>  		    "Don't shorten the displayed pathnames"),
> +	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>  	OPT_END()
>  };
>  
> @@ -274,6 +284,23 @@ int cmd_annotate(int argc, const char **
>  
>  	setup_sorting(annotate_usage, options);
>  
> +	if (cpu_list) {
> +		int i;
> +		struct cpu_map *map = cpu_map__new(cpu_list);
> +
> +		for (i = 0; i < map->nr; i++) {
> +			int cpu = map->map[i];
> +
> +			if (cpu >= MAX_NR_CPUS) {
> +				fprintf(stderr, "Requested CPU %d too large, "
> +					"consider raising MAX_NR_CPUS\n", cpu);
> +				return -1;
> +			}
> +
> +			set_bit(cpu, cpu_bitmap);
> +		}
> +	}
> +
>  	if (argc) {
>  		/*
>  		 * Special case: if there's an argument left then assume tha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
