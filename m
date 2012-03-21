Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab2CUPff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:35:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33511 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab2CUPfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:35:32 -0400
Date: Wed, 21 Mar 2012 12:35:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ashay Rane <ashay.r@gmail.com>
Cc: linux-perf-users@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf report: Correct display of samples and events
 in header
Message-ID: <20120321153527.GA25820@infradead.org>
References: <1332292828-22656-1-git-send-email-ashay.r@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332292828-22656-1-git-send-email-ashay.r@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 20, 2012 at 08:20:28PM -0500, Ashay Rane escreveu:
> This patch prints the number of samples and the count of performance events separately. This allows comparing performance of different applications with each other. Previously, the sample count was displayed against an 'Events:' heading. With this patch, the header now reads (for example):
> 
> Samples: 5K of event 'instructions'
> Event count (approx.): 2993026545
> 
> The patch covers both the stdio and the browser interface.
> 
> Signed-off-by: Ashay Rane <ashay.r@gmail.com>

Patches that are not bug fixes should be done on tip/perf/core, please
do that and resubmit.

git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
git remote update tip
git checkout -b perf/core tip/perf/core

:-)

- Arnaldo

 ---
>  tools/perf/builtin-report.c         |   11 +++++++----
>  tools/perf/util/ui/browsers/hists.c |    9 ++++++---
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 8e91c6e..2ee7783 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -295,12 +295,15 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
>  {
>  	size_t ret;
>  	char unit;
> -	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
> +	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
> +	u64 nr_events = self->stats.total_period;
>  
> -	nr_events = convert_unit(nr_events, &unit);
> -	ret = fprintf(fp, "# Events: %lu%c", nr_events, unit);
> +	nr_samples = convert_unit(nr_samples, &unit);
> +	ret = fprintf(fp, "# Samples: %lu%c", nr_samples, unit);
>  	if (evname != NULL)
> -		ret += fprintf(fp, " %s", evname);
> +		ret += fprintf(fp, " of event '%s'", evname);
> +
> +	ret += fprintf(fp, "\n# Event count (approx.): %lu", nr_events);
>  	return ret + fprintf(fp, "\n#\n");
>  }
>  
> diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
> index fa530fc..d9ec415 100644
> --- a/tools/perf/util/ui/browsers/hists.c
> +++ b/tools/perf/util/ui/browsers/hists.c
> @@ -837,10 +837,13 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
>  	int printed;
>  	const struct dso *dso = self->dso_filter;
>  	const struct thread *thread = self->thread_filter;
> -	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
> +	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
> +	u64 nr_events = self->stats.total_period;
>  
> -	nr_events = convert_unit(nr_events, &unit);
> -	printed = scnprintf(bf, size, "Events: %lu%c %s", nr_events, unit, ev_name);
> +	nr_samples = convert_unit(nr_samples, &unit);
> +	printed = scnprintf(bf, size,
> +			    "Samples: %lu%c of event '%s', Event count (approx.): %lu",
> +			    nr_samples, unit, ev_name, nr_events);
>  
>  	if (self->uid_filter_str)
>  		printed += snprintf(bf + printed, size - printed,
> -- 
> 1.7.9.3
