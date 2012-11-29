Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab2K2HpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:45:04 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57237 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2HpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:45:03 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-6a-50b7127c243a
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/14] perf tool: Introduce perf_hpp__list for period related columns
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-2-git-send-email-jolsa@redhat.com>
Date: Thu, 29 Nov 2012 16:44:59 +0900
In-Reply-To: <1354110769-2998-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 28 Nov 2012 14:52:36 +0100")
Message-ID: <87d2ywq2dg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, 28 Nov 2012 14:52:36 +0100, Jiri Olsa wrote:
> Adding perf_hpp__list list to register and contain all period
> related columns the command is interested in.
>
> This way we get rid of static array holding all possible
> columns and enable commands to register their own columns.

But it seems you didn't get rid of the array? :)

>
> It'll be handy for diff command in future to process and display
> data for multiple files.
[snip]
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 8b091a5..a935a60 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -126,13 +126,19 @@ struct perf_hpp {
>  };
>  
>  struct perf_hpp_fmt {
> -	bool cond;
>  	int (*header)(struct perf_hpp *hpp);
>  	int (*width)(struct perf_hpp *hpp);
>  	int (*color)(struct perf_hpp *hpp, struct hist_entry *he);
>  	int (*entry)(struct perf_hpp *hpp, struct hist_entry *he);
> +
> +	struct list_head list;
>  };
>  
> +extern struct list_head perf_hpp__list;
> +
> +#define perf_hpp__for_each_format(format) \
> +	list_for_each_entry(format, &perf_hpp__list, list)
> +
>  extern struct perf_hpp_fmt perf_hpp__format[];

Instead of using new perf_hpp__list, how about this?

#define perf_hpp__for_each_format(fmt) \
        for (fmt = &perf_hpp__format[0]; fmt < &perf_hpp__format[PERF_HPP__MAX_INDEX]; fmt++) \
                if (fmt->cond)

Thanks,
Namhyung

>  
>  enum {
> @@ -155,7 +161,8 @@ enum {
>  };
>  
>  void perf_hpp__init(void);
> -void perf_hpp__column_enable(unsigned col, bool enable);
> +void perf_hpp__column_register(struct perf_hpp_fmt *format);
> +void perf_hpp__column_enable(unsigned col);
>  int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
>  				bool color);
