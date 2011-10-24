Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1JXOTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:19:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49334 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1JXOTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:19:22 -0400
Message-ID: <4EA573E4.3090408@gmail.com>
Date: Mon, 24 Oct 2011 08:19:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Deng-Cheng Zhu <dczhu@mips.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [RFC PATCH 1/2] tools/perf: Don't set attr->disabled when doing
 grouping
References: <1319453820-12992-1-git-send-email-dczhu@mips.com> <1319453820-12992-2-git-send-email-dczhu@mips.com>
In-Reply-To: <1319453820-12992-2-git-send-email-dczhu@mips.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/24/2011 04:56 AM, Deng-Cheng Zhu wrote:
> Events will be created at the state PERF_EVENT_STATE_OFF if attr->disabled
> is set. When these events go to arch level validate_group(), the function
> won't do anything real because they are filtered out by the state check.

Seems like a bug with the group checks. You should be able to enable and
disable events - including creating them disabled.

David


> 
> Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
>  tools/perf/builtin-record.c |    6 +++---
>  tools/perf/builtin-stat.c   |    3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index f4c3fbe..67e8e4c 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -161,7 +161,6 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
>  	struct perf_event_attr *attr = &evsel->attr;
>  	int track = !evsel->idx; /* only the first counter needs these */
>  
> -	attr->disabled		= 1;
>  	attr->inherit		= !no_inherit;
>  	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
>  				  PERF_FORMAT_TOTAL_TIME_RUNNING |
> @@ -222,10 +221,11 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
>  	attr->mmap		= track;
>  	attr->comm		= track;
>  
> -	if (target_pid == -1 && target_tid == -1 && !system_wide) {
> +	if (!group)
>  		attr->disabled = 1;
> +
> +	if (target_pid == -1 && target_tid == -1 && !system_wide)
>  		attr->enable_on_exec = 1;
> -	}
>  }
>  
>  static bool perf_evlist__equal(struct perf_evlist *evlist,
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 5deb17d..ca95475 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -284,7 +284,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
>  		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, group);
>  
>  	if (target_pid == -1 && target_tid == -1) {
> -		attr->disabled = 1;
> +		if (!group)
> +			attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
>  
