Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab2D0QUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:20:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758928Ab2D0QUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:20:15 -0400
Date: Fri, 27 Apr 2012 13:19:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, joro@8bytes.org, gleb@redhat.com
Subject: Re: [PATCH] perf stat: fix case where guest/host monitoring is not
 supported by kernel
Message-ID: <20120427161956.GB4820@infradead.org>
References: <20120427124538.GA7230@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427124538.GA7230@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 02:45:38PM +0200, Stephane Eranian escreveu:
> 
> By default, perf stat sets exclude_guest = 1. But when you run perf on a kernel
> which does not support  host/guest filtering, then you get an error saying
> the event in unsupported. This comes from the fact that when the
> perf_event_attr struct passed by the user is larger than the one known to 
> the kernel there is safety check which ensures that all unknown bits are
> zero. But here, exclude_guest is 1 (part of the unknown bits) and thus the
> perf_event_open() syscall return EINVAL.
> 
> To my surprise, running perf record on the same kernel did not exhibit
> the problem. The reason is that perf record handles the problem by
> catching the error and retrying with guest/host excludes set to zero.
> For some reason, this was not done with perf stat. This patch fixes
> this problem.

yeah, I have to sit down and finish perf_evlist__open, i.e. get all this
capability queries.

Thanks, applying to my perf/urgent branch.

- Arnaldo
 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index dde9e17..6e1c1f9 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -283,6 +283,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  {
>  	struct perf_event_attr *attr = &evsel->attr;
>  	struct xyarray *group_fd = NULL;
> +	bool exclude_guest_missing = false;
> +	int ret;
>  
>  	if (group && evsel != first)
>  		group_fd = first->fd;
> @@ -293,16 +295,39 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  
>  	attr->inherit = !no_inherit;
>  
> -	if (system_wide)
> -		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
> +retry:
> +	if (exclude_guest_missing)
> +		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
> +
> +	if (system_wide) {
> +		ret = perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
>  						group, group_fd);
> +		if (ret)
> +			goto check_ret;
> +		return 0;
> +	}
> +
>  	if (!target_pid && !target_tid && (!group || evsel == first)) {
>  		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
>  
> -	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
> -					   group, group_fd);
> +	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads,
> +					  group, group_fd);
> +	if (!ret)
> +		return 0;
> +	/* fall through */
> +check_ret:
> +	if (ret && errno == EINVAL) {
> +		if (!exclude_guest_missing &&
> +		    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
> +			pr_debug("Old kernel, cannot exclude "
> +				 "guest or host samples.\n");
> +			exclude_guest_missing = true;
> +			goto retry;
> +		}
> +	}
> +	return ret;
>  }
>  
>  /*
