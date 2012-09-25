Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2IYFMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:12:02 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54583 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2IYFMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:12:01 -0400
X-AuditID: 9c930197-b7b6dae000000e70-45-50613d1ff0e4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/3] perf ui/browser: Fix stale output of sorted result
References: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
	<1347611729-16994-3-git-send-email-namhyung@kernel.org>
Date: Tue, 25 Sep 2012 14:03:37 +0900
In-Reply-To: <1347611729-16994-3-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Fri, 14 Sep 2012 17:35:29 +0900")
Message-ID: <87lifywv6e.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

It seems it's not merged into your tree as I still can see this issue.
Would you consider applying?

Thanks,
Namhyung


On Fri, 14 Sep 2012 17:35:29 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The hist_entry__sort_snprintf() can return 0 if all of the sort keys
> are elided.  In this case a buffer which used for the function would
> contain old message or a garbage and printed like below:
>
>   $ perf record -g -e cycles:u abc
>   $ perf --report -s comm -c abc
>   (...)
>   + 100.00%100.00%
>
> Fix it by checking return value.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index a21f40bebbac..75b3898ca651 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -664,8 +664,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  		if (!browser->b.navkeypressed)
>  			width += 1;
>  
> -		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
> -		slsmg_write_nstring(s, width);
> +		if (hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists))
> +			slsmg_write_nstring(s, width);
>  		++row;
>  		++printed;
>  	} else
> @@ -981,7 +981,6 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
>  	if (symbol_conf.use_callchain)
>  		folded_sign = hist_entry__folded(he);
>  
> -	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
>  	percent = (he->period * 100.0) / browser->hists->stats.total_period;
>  
>  	if (symbol_conf.use_callchain)
> @@ -995,7 +994,8 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
>  	if (symbol_conf.show_total_period)
>  		printed += fprintf(fp, " %12" PRIu64, he->period);
>  
> -	printed += fprintf(fp, "%s\n", rtrim(s));
> +	if (hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists))
> +		printed += fprintf(fp, "%s\n", rtrim(s));
>  
>  	if (folded_sign == '-')
>  		printed += hist_browser__fprintf_callchain(browser, &he->sorted_chain, 1, fp);
