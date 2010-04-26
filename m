Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0DZGu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 02:50:59 -0400
Received: from mga10.intel.com ([192.55.52.92]:17974 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834Ab0DZGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 02:50:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,272,1270450800"; 
   d="scan'208";a="792718607"
Subject: Re: [PATCH] perf: limit memory allocation to number cpus online
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Tony Jones <tonyj@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100330220823.GA16876@suse.de>
References: <20100330220823.GA16876@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 26 Apr 2010 14:51:15 +0800
Message-Id: <1272264675.2078.639.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 15:08 -0700, Tony Jones wrote:
> Subject: perf: limit memory allocation to number cpus online
> From: Tony Jones <tonyj@suse.de>
> Date: Tue, 30 Mar 2010 12:18:08 -0700
> 
> Limit the dynamic allocation of fd, event_array and mmap_array to #cpus online 
> rather than MAX_NR_CPUS.
Acked. Sorry for replying late. There will be a much more valuable patch if it fixes
the cpu hotplug issue. For example, if my machine starts 16 cpu and I hot unplug
some of them by software method (i.e. echo 0 >/sys/devices/system/cpu/cpuXXX/online)
after kernel boots, perf will fail when collecting a system-wide statistics. That's
because sys_perf_event_open fails on removed cpu.

> 
> Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> Signed-off-by: Tony Jones <tonyj@suse.de>
> ---
>  tools/perf/builtin-record.c |   10 +++++++---
>  tools/perf/builtin-stat.c   |    4 ++--
>  tools/perf/builtin-top.c    |   14 +++++++-------
>  3 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 60ecdd3..25b5536 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -560,7 +560,6 @@ static int __cmd_record(int argc, const char **argv)
>  	if ((!system_wide && !inherit) || profile_cpu != -1) {
>  		open_counters(profile_cpu);
>  	} else {
> -		nr_cpus = read_cpu_map();
>  		for (i = 0; i < nr_cpus; i++)
>  			open_counters(cpumap[i]);
>  	}
> @@ -748,7 +747,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  		thread_num = 1;
>  	}
>  
> -	for (i = 0; i < MAX_NR_CPUS; i++) {
> +	if (system_wide && profile_cpu == -1)
> +		nr_cpus = read_cpu_map();
> +	else
> +		nr_cpus = 1;
> +
> +	for (i = 0; i < nr_cpus; i++) {
>  		for (j = 0; j < MAX_COUNTERS; j++) {
>  			fd[i][j] = malloc(sizeof(int)*thread_num);
>  			mmap_array[i][j] = zalloc(
> @@ -758,7 +762,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
>  		}
>  	}
>  	event_array = malloc(
> -		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
> +		sizeof(struct pollfd)*nr_cpus*MAX_COUNTERS*thread_num);
>  	if (!event_array)
>  		return -ENOMEM;
>  
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 1036ca7..d9b672e 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -540,7 +540,7 @@ static const struct option options[] = {
>  int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  {
>  	int status;
> -	int i,j;
> +	unsigned int i,j;
>  
>  	argc = parse_options(argc, argv, options, stat_usage,
>  		PARSE_OPT_STOP_AT_NON_OPTION);
> @@ -577,7 +577,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  		thread_num = 1;
>  	}
>  
> -	for (i = 0; i < MAX_NR_CPUS; i++) {
> +	for (i = 0; i < nr_cpus; i++) {
>  		for (j = 0; j < MAX_COUNTERS; j++) {
>  			fd[i][j] = malloc(sizeof(int)*thread_num);
>  			if (!fd[i][j])
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 4abdd9b..f05d270 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1368,7 +1368,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  		thread_num = 1;
>  	}
>  
> -	for (i = 0; i < MAX_NR_CPUS; i++) {
> +	if (target_tid != -1 || profile_cpu != -1)
> +		nr_cpus = 1;
> +	else
> +		nr_cpus = read_cpu_map();
> +
> +	for (i = 0; i < nr_cpus; i++) {
>  		for (j = 0; j < MAX_COUNTERS; j++) {
>  			fd[i][j] = malloc(sizeof(int)*thread_num);
>  			mmap_array[i][j] = zalloc(
> @@ -1378,7 +1383,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  		}
>  	}
>  	event_array = malloc(
> -		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
> +		sizeof(struct pollfd)*nr_cpus*MAX_COUNTERS*thread_num);
>  	if (!event_array)
>  		return -ENOMEM;
>  
> @@ -1424,11 +1429,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  		attrs[counter].sample_period = default_interval;
>  	}
>  
> -	if (target_tid != -1 || profile_cpu != -1)
> -		nr_cpus = 1;
> -	else
> -		nr_cpus = read_cpu_map();
> -
>  	get_term_dimensions(&winsize);
>  	if (print_entries == 0) {
>  		update_print_entries(&winsize);


