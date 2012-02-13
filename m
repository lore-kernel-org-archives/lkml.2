Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2BMSkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:40:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34087 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2BMSkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:40:16 -0500
Date: Mon, 13 Feb 2012 16:40:08 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] perf stat: Use perf_evlist__create_maps
Message-ID: <20120213184008.GI15955@infradead.org>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
 <1329118064-9412-10-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329118064-9412-10-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 13, 2012 at 04:27:41PM +0900, Namhyung Kim escreveu:
> Use same function with perf record and top to share the code
> checks combinations of different switches.

Haven't fully checked, but if equivalent, nice cleanup!

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/builtin-stat.c |   16 ++--------------
>  1 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index d080254a2d0c..be2667236bea 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -196,6 +196,7 @@ static int			output_fd;
>  static struct perf_maps_opts maps = {
>  	.target_pid		= -1,
>  	.target_tid		= -1,
> +	.uid			= UINT_MAX,
>  };
>  
>  static volatile int done = 0;
> @@ -1208,20 +1209,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
>  
>  	check_target_maps(&maps);
>  
> -	evsel_list->threads = thread_map__new(maps.target_pid, maps.target_tid,
> -					      UINT_MAX);
> -	if (evsel_list->threads == NULL) {
> -		pr_err("Problems finding threads of monitor\n");
> -		usage_with_options(stat_usage, options);
> -	}
> -
> -	if (maps.system_wide)
> -		evsel_list->cpus = cpu_map__new(maps.cpu_list);
> -	else
> -		evsel_list->cpus = cpu_map__dummy_new();
> -
> -	if (evsel_list->cpus == NULL) {
> -		perror("failed to parse CPUs map");
> +	if (perf_evlist__create_maps(evsel_list, &maps) < 0) {
>  		usage_with_options(stat_usage, options);
>  		return -1;
>  	}
> -- 
> 1.7.9
