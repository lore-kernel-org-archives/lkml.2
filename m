Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2CMGV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:21:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab2CMGV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:21:27 -0400
Date: Tue, 13 Mar 2012 07:21:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf report: Treat an argument as a symbol filter
Message-ID: <20120313062105.GB24357@elte.hu>
References: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
 <1331619294-29162-4-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331619294-29162-4-git-send-email-namhyung.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung.kim@lge.com> wrote:

> As Ingo requested, it'd be better off treating first (and the only)
> argument as a symbol filter, so that user doesn't need to input the
> symbol on the dialog window.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/builtin-report.c |   19 ++++++++++++++-----
>  1 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 25d34d483e49..62c4a11bcf3e 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -50,6 +50,7 @@ struct perf_report {
>  	const char		*pretty_printing_style;
>  	symbol_filter_t		annotate_init;
>  	const char		*cpu_list;
> +	const char		*symbol_filter_str;
>  	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>  };
>  
> @@ -315,6 +316,9 @@ static int __cmd_report(struct perf_report *rep)
>  	list_for_each_entry(pos, &session->evlist->entries, node) {
>  		struct hists *hists = &pos->hists;
>  
> +		if (pos->idx == 0)
> +			hists->symbol_filter_str = rep->symbol_filter_str;
> +
>  		hists__collapse_resort(hists);
>  		hists__output_resort(hists);
>  		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
> @@ -586,11 +590,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  	} else
>  		symbol_conf.exclude_other = false;
>  
> -	/*
> -	 * Any (unrecognized) arguments left?
> -	 */
> -	if (argc)
> -		usage_with_options(report_usage, options);
> +	if (argc) {
> +		/*
> +		 * Special case: if there's an argument left then assume tha

s/tha/that

> +		 * it's a symbol filter:
> +		 */
> +		if (argc > 1)
> +			usage_with_options(report_usage, options);
> +
> +		report.symbol_filter_str = argv[0];
> +	}

Are people fine with this special case?

To play the devil's advocate it uses up valuable perf report 
command line real estate and we probably cannot change this 
workflow in the future, once people get used to it.

For example doing this would preclude us from adding subsystem 
subcommands to perf report in the future, such as:

 $ perf report sched
 $ perf report kvm
 ...

OTOH have 'perf sched' and 'perf kvm' and maybe those are better 
provided as:

 $ perf kvm report
 $ perf sched report

:-)

Thanks,

	Ingo
