Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1HOVcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:32:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40021 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1HOVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:32:17 -0400
Message-ID: <4E49905C.7060704@gmail.com>
Date: Mon, 15 Aug 2011 15:32:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        peterz@infradead.org
Subject: Re: [PATCH] perf: add -o and --append options to perf stat
References: <20110815202233.GA18535@quad>
In-Reply-To: <20110815202233.GA18535@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 02:22 PM, Stephane Eranian wrote:
> 
> This patch adds an option (-o) to save the output of perf stat
> into a file. You could do this with perf record but not with
> perf stat. Instead, you had to fiddle with stderr to save
> the counts into a separate file.
> 
> The patch also adds the --append option so that results can
> be concatenated into a single file across runs. Each run of
> the tool is clearly separated by a comment line starting with
> a hash mark. The -A option of perf record is already used by
> perf stat, so we only add a long option.
> 
> $ perf stat -o res.txt date

Why not just use redirection to put the output into a file?
perf stat date > res.txt

David

> $ cat res.txt
> # started on Mon Aug 15 19:46:55 2011
> 
> 
>  Performance counter stats for 'date':
> 
>           0.791306 task-clock                #    0.668 CPUs utilized          
>                  2 context-switches          #    0.003 M/sec                  
>                  0 CPU-migrations            #    0.000 M/sec                  
>                197 page-faults               #    0.249 M/sec                  
>            1878143 cycles                    #    2.373 GHz                    
>    <not supported> stalled-cycles-frontend 
>    <not supported> stalled-cycles-backend  
>            1083367 instructions              #    0.58  insns per cycle        
>             193027 branches                  #  243.935 M/sec                  
>               9014 branch-misses             #    4.67% of all branches        
> 
>        0.001184746 seconds time elapsed
> 
> The option can be combined with -x to make the output file
> much easier to parse.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 918cc38..08394c4 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -94,6 +94,13 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
>  corresponding events, i.e., they always refer to events defined earlier on the command
>  line.
>  
> +-o file::
> +-output file::
> +Print the output into the designated file.
> +
> +--append::
> +Append to the output file designated with the -o option. Ignored if -o is not specified.
> +
>  EXAMPLES
>  --------
>  
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 1ad04ce..a22393d 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -193,6 +193,8 @@ static int			big_num_opt			=  -1;
>  static const char		*cpu_list;
>  static const char		*csv_sep			= NULL;
>  static bool			csv_output			= false;
> +static const char		*output_name			= NULL;
> +static FILE			*output				= NULL;
>  
>  static volatile int done = 0;
>  
> @@ -351,7 +353,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
>  		update_stats(&ps->res_stats[i], count[i]);
>  
>  	if (verbose) {
> -		fprintf(stderr, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
> +		fprintf(output, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
>  			event_name(counter), count[0], count[1], count[2]);
>  	}
>  
> @@ -518,9 +520,9 @@ static void print_noise_pct(double total, double avg)
>  		pct = 100.0*total/avg;
>  
>  	if (csv_output)
> -		fprintf(stderr, "%s%.2f%%", csv_sep, pct);
> +		fprintf(output, "%s%.2f%%", csv_sep, pct);
>  	else
> -		fprintf(stderr, "  ( +-%6.2f%% )", pct);
> +		fprintf(output, "  ( +-%6.2f%% )", pct);
>  }
>  
>  static void print_noise(struct perf_evsel *evsel, double avg)
> @@ -545,16 +547,17 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
>  			csv_output ? 0 : -4,
>  			evsel_list->cpus->map[cpu], csv_sep);
>  
> -	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
> +	fprintf(output, fmt, cpustr, msecs, csv_sep, event_name(evsel));
>  
>  	if (evsel->cgrp)
> -		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
> +		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
>  
>  	if (csv_output)
>  		return;
>  
>  	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
> -		fprintf(stderr, " # %8.3f CPUs utilized          ", avg / avg_stats(&walltime_nsecs_stats));
> +		fprintf(output, " # %8.3f CPUs utilized          ",
> +			avg / avg_stats(&walltime_nsecs_stats));
>  }
>  
>  static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -575,9 +578,9 @@ static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __us
>  	else if (ratio > 10.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " frontend cycles idle   ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " frontend cycles idle   ");
>  }
>  
>  static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -598,9 +601,9 @@ static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __use
>  	else if (ratio > 20.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " backend  cycles idle   ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " backend  cycles idle   ");
>  }
>  
>  static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -621,9 +624,9 @@ static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double
>  	else if (ratio > 5.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " of all branches        ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " of all branches        ");
>  }
>  
>  static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -644,9 +647,9 @@ static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, dou
>  	else if (ratio > 5.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " of all L1-dcache hits  ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " of all L1-dcache hits  ");
>  }
>  
>  static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -667,9 +670,9 @@ static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, dou
>  	else if (ratio > 5.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " of all L1-icache hits  ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " of all L1-icache hits  ");
>  }
>  
>  static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -690,9 +693,9 @@ static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, do
>  	else if (ratio > 5.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " of all dTLB cache hits ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " of all dTLB cache hits ");
>  }
>  
>  static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -713,9 +716,9 @@ static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, do
>  	else if (ratio > 5.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " of all iTLB cache hits ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " of all iTLB cache hits ");
>  }
>  
>  static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
> @@ -736,9 +739,9 @@ static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, doub
>  	else if (ratio > 5.0)
>  		color = PERF_COLOR_YELLOW;
>  
> -	fprintf(stderr, " #  ");
> -	color_fprintf(stderr, color, "%6.2f%%", ratio);
> -	fprintf(stderr, " of all LL-cache hits   ");
> +	fprintf(output, " #  ");
> +	color_fprintf(output, color, "%6.2f%%", ratio);
> +	fprintf(output, " of all LL-cache hits   ");
>  }
>  
>  static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
> @@ -761,10 +764,10 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
>  	else
>  		cpu = 0;
>  
> -	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(evsel));
> +	fprintf(output, fmt, cpustr, avg, csv_sep, event_name(evsel));
>  
>  	if (evsel->cgrp)
> -		fprintf(stderr, "%s%s", csv_sep, evsel->cgrp->name);
> +		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
>  
>  	if (csv_output)
>  		return;
> @@ -775,14 +778,14 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
>  		if (total)
>  			ratio = avg / total;
>  
> -		fprintf(stderr, " #   %5.2f  insns per cycle        ", ratio);
> +		fprintf(output, " #   %5.2f  insns per cycle        ", ratio);
>  
>  		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
>  		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
>  
>  		if (total && avg) {
>  			ratio = total / avg;
> -			fprintf(stderr, "\n                                             #   %5.2f  stalled cycles per insn", ratio);
> +			fprintf(output, "\n                                             #   %5.2f  stalled cycles per insn", ratio);
>  		}
>  
>  	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
> @@ -830,7 +833,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
>  		if (total)
>  			ratio = avg * 100 / total;
>  
> -		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
> +		fprintf(output, " # %8.3f %% of all cache refs    ", ratio);
>  
>  	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_FRONTEND)) {
>  		print_stalled_cycles_frontend(cpu, evsel, avg);
> @@ -842,16 +845,16 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
>  		if (total)
>  			ratio = 1.0 * avg / total;
>  
> -		fprintf(stderr, " # %8.3f GHz                    ", ratio);
> +		fprintf(output, " # %8.3f GHz                    ", ratio);
>  	} else if (runtime_nsecs_stats[cpu].n != 0) {
>  		total = avg_stats(&runtime_nsecs_stats[cpu]);
>  
>  		if (total)
>  			ratio = 1000.0 * avg / total;
>  
> -		fprintf(stderr, " # %8.3f M/sec                  ", ratio);
> +		fprintf(output, " # %8.3f M/sec                  ", ratio);
>  	} else {
> -		fprintf(stderr, "                                   ");
> +		fprintf(output, "                                   ");
>  	}
>  }
>  
> @@ -866,7 +869,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
>  	int scaled = counter->counts->scaled;
>  
>  	if (scaled == -1) {
> -		fprintf(stderr, "%*s%s%*s",
> +		fprintf(output, "%*s%s%*s",
>  			csv_output ? 0 : 18,
>  			counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
>  			csv_sep,
> @@ -874,9 +877,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
>  			event_name(counter));
>  
>  		if (counter->cgrp)
> -			fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
> +			fprintf(output, "%s%s", csv_sep, counter->cgrp->name);
>  
> -		fputc('\n', stderr);
> +		fputc('\n', output);
>  		return;
>  	}
>  
> @@ -888,7 +891,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
>  	print_noise(counter, avg);
>  
>  	if (csv_output) {
> -		fputc('\n', stderr);
> +		fputc('\n', output);
>  		return;
>  	}
>  
> @@ -898,9 +901,9 @@ static void print_counter_aggr(struct perf_evsel *counter)
>  		avg_enabled = avg_stats(&ps->res_stats[1]);
>  		avg_running = avg_stats(&ps->res_stats[2]);
>  
> -		fprintf(stderr, " [%5.2f%%]", 100 * avg_running / avg_enabled);
> +		fprintf(output, " [%5.2f%%]", 100 * avg_running / avg_enabled);
>  	}
> -	fprintf(stderr, "\n");
> +	fprintf(output, "\n");
>  }
>  
>  /*
> @@ -917,7 +920,7 @@ static void print_counter(struct perf_evsel *counter)
>  		ena = counter->counts->cpu[cpu].ena;
>  		run = counter->counts->cpu[cpu].run;
>  		if (run == 0 || ena == 0) {
> -			fprintf(stderr, "CPU%*d%s%*s%s%*s",
> +			fprintf(output, "CPU%*d%s%*s%s%*s",
>  				csv_output ? 0 : -4,
>  				evsel_list->cpus->map[cpu], csv_sep,
>  				csv_output ? 0 : 18,
> @@ -927,9 +930,10 @@ static void print_counter(struct perf_evsel *counter)
>  				event_name(counter));
>  
>  			if (counter->cgrp)
> -				fprintf(stderr, "%s%s", csv_sep, counter->cgrp->name);
> +				fprintf(output, "%s%s",
> +					csv_sep, counter->cgrp->name);
>  
> -			fputc('\n', stderr);
> +			fputc('\n', output);
>  			continue;
>  		}
>  
> @@ -942,9 +946,10 @@ static void print_counter(struct perf_evsel *counter)
>  			print_noise(counter, 1.0);
>  
>  			if (run != ena)
> -				fprintf(stderr, "  (%.2f%%)", 100.0 * run / ena);
> +				fprintf(output, "  (%.2f%%)",
> +					100.0 * run / ena);
>  		}
> -		fputc('\n', stderr);
> +		fputc('\n', output);
>  	}
>  }
>  
> @@ -956,21 +961,21 @@ static void print_stat(int argc, const char **argv)
>  	fflush(stdout);
>  
>  	if (!csv_output) {
> -		fprintf(stderr, "\n");
> -		fprintf(stderr, " Performance counter stats for ");
> +		fprintf(output, "\n");
> +		fprintf(output, " Performance counter stats for ");
>  		if(target_pid == -1 && target_tid == -1) {
> -			fprintf(stderr, "\'%s", argv[0]);
> +			fprintf(output, "\'%s", argv[0]);
>  			for (i = 1; i < argc; i++)
> -				fprintf(stderr, " %s", argv[i]);
> +				fprintf(output, " %s", argv[i]);
>  		} else if (target_pid != -1)
> -			fprintf(stderr, "process id \'%d", target_pid);
> +			fprintf(output, "process id \'%d", target_pid);
>  		else
> -			fprintf(stderr, "thread id \'%d", target_tid);
> +			fprintf(output, "thread id \'%d", target_tid);
>  
> -		fprintf(stderr, "\'");
> +		fprintf(output, "\'");
>  		if (run_count > 1)
> -			fprintf(stderr, " (%d runs)", run_count);
> -		fprintf(stderr, ":\n\n");
> +			fprintf(output, " (%d runs)", run_count);
> +		fprintf(output, ":\n\n");
>  	}
>  
>  	if (no_aggr) {
> @@ -983,15 +988,15 @@ static void print_stat(int argc, const char **argv)
>  
>  	if (!csv_output) {
>  		if (!null_run)
> -			fprintf(stderr, "\n");
> -		fprintf(stderr, " %17.9f seconds time elapsed",
> +			fprintf(output, "\n");
> +		fprintf(output, " %17.9f seconds time elapsed",
>  				avg_stats(&walltime_nsecs_stats)/1e9);
>  		if (run_count > 1) {
> -			fprintf(stderr, "                                        ");
> +			fprintf(output, "                                        ");
>  			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
>  					avg_stats(&walltime_nsecs_stats));
>  		}
> -		fprintf(stderr, "\n\n");
> +		fprintf(output, "\n\n");
>  	}
>  }
>  
> @@ -1029,6 +1034,8 @@ static int stat__set_big_num(const struct option *opt __used,
>  	return 0;
>  }
>  
> +static bool append_file;
> +
>  static const struct option options[] = {
>  	OPT_CALLBACK('e', "event", &evsel_list, "event",
>  		     "event selector. use 'perf list' to list available events",
> @@ -1067,6 +1074,9 @@ static const struct option options[] = {
>  	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
>  		     "monitor event in cgroup name only",
>  		     parse_cgroups),
> +	OPT_STRING('o', "output", &output_name, "file",
> +		    "output file name"),
> +	OPT_BOOLEAN(0, "append", &append_file, "append to the output file"),
>  	OPT_END()
>  };
>  
> @@ -1138,6 +1148,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  {
>  	struct perf_evsel *pos;
>  	int status = -ENOMEM;
> +	const char *mode;
>  
>  	setlocale(LC_ALL, "");
>  
> @@ -1148,6 +1159,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	argc = parse_options(argc, argv, options, stat_usage,
>  		PARSE_OPT_STOP_AT_NON_OPTION);
>  
> +	output = stderr;
> +	if (output_name && strcmp(output_name, "-"))
> +		output = NULL;
> +
> +	if (!output) {
> +		struct timespec tm;
> +		mode = append_file ? "a" : "w";
> +
> +		output = fopen(output_name, mode);
> +		if (!output) {
> +			perror("failed to create output file");
> +			exit(-1);
> +		}
> +		clock_gettime(CLOCK_REALTIME, &tm);
> +		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
> +	}
> +
>  	if (csv_sep)
>  		csv_output = true;
>  	else
> @@ -1223,7 +1251,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  	status = 0;
>  	for (run_idx = 0; run_idx < run_count; run_idx++) {
>  		if (run_count != 1 && verbose)
> -			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
> +			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
> +				run_idx + 1);
>  
>  		if (sync_run)
>  			sync();
> diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
> index e191eb9..521c38a 100644
> --- a/tools/perf/util/color.c
> +++ b/tools/perf/util/color.c
> @@ -200,7 +200,7 @@ static int __color_vfprintf(FILE *fp, const char *color, const char *fmt,
>  	 * Auto-detect:
>  	 */
>  	if (perf_use_color_default < 0) {
> -		if (isatty(1) || pager_in_use())
> +		if (isatty(fileno(fp)) || pager_in_use())
>  			perf_use_color_default = 1;
>  		else
>  			perf_use_color_default = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
