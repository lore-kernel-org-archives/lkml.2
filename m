Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab2BMSl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:41:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45335 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab2BMSl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:41:29 -0500
Date: Mon, 13 Feb 2012 16:41:21 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] perf stat: Fix event grouping on forked task
Message-ID: <20120213184121.GJ15955@infradead.org>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
 <1329118064-9412-11-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329118064-9412-11-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 13, 2012 at 04:27:42PM +0900, Namhyung Kim escreveu:
> When event group is enabled for forked task (i.e. no target task was
> specified) all events were disabled and marked ->enable_on_exec.
> However they are not counted at all since only group leader will be
> enabled on exec actually. So the result looked like below:
> 
>  $ perf stat --group sleep 1

This one is a bugfix and would be better if we have it isolated from
this patchset, not needing the cleanups, so that we can send it to
perf/urgent and stable@
 
>  Performance counter stats for 'sleep 1':
> 
>           0.530891 task-clock                #    0.001 CPUs utilized
>      <not counted> context-switches
>      <not counted> CPU-migrations
>      <not counted> page-faults
>      <not counted> cycles
>    <not supported> stalled-cycles-frontend
>    <not supported> stalled-cycles-backend
>      <not counted> instructions
>      <not counted> branches
>      <not counted> branch-misses
> 
>        1.001140177 seconds time elapsed
> 
> Fix it by disabling group leader only.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/builtin-stat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index be2667236bea..2a592e52eaee 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -297,7 +297,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  	if (maps.system_wide)
>  		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
>  						group, group_fd);
> -	if (no_target_task(&maps)) {
> +	if (no_target_task(&maps) && (!group || evsel == first)) {
>  		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
> -- 
> 1.7.9
