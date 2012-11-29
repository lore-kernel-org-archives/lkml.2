Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2K2MCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:02:04 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50440 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2K2MCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:02:02 -0500
X-AuditID: 9c930179-b7c9dae000000e53-70-50b74eb938fb
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/14] perf diff: Add generic order option for compute sorting
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-15-git-send-email-jolsa@redhat.com>
Date: Thu, 29 Nov 2012 21:02:01 +0900
In-Reply-To: <1354110769-2998-15-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 28 Nov 2012 14:52:49 +0100")
Message-ID: <87a9u0obwm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 14:52:49 +0100, Jiri Olsa wrote:
> Adding option 'o' to allow sorting based on the
> input file number.
[snip]
>  hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
>  			int c)
>  {
> -	int i;
> +	struct hist_entry **pairs_left  = left->pairs;
> +	struct hist_entry **pairs_right = right->pairs;
> +	struct hist_entry *p_right, *p_left;
> +	static int64_t cmp;
>  
> -	for (i = 0; i < data_cnt; i++) {
> -		struct hist_entry **pairs_left  = left->pairs;
> -		struct hist_entry **pairs_right = right->pairs;
> -		struct hist_entry *p_right, *p_left;
> -		static int64_t cmp;
> +	if (!pairs_left || !pairs_right)
> +		return pairs_left ? -1 : 1;
>  
> -		if (!pairs_left || !pairs_right)
> -			return pairs_right - pairs_left;
> +	p_right = pairs_right[sort_compute];
> +	p_left  = pairs_left[sort_compute];
>  
> -		p_right = pairs_right[i];
> -		p_left  = pairs_left[i];
> +	if (!p_left || !p_right)
> +		return p_left ? -1 : 1;

What if both p_left and p_right are NULL?  Shouldn't it be move to the
next pairs?

>  
> -		if (!p_left || !p_right)
> -			return p_right - p_left;
> -
> -		/*
> -		 * If we differ, we are done, otherwise continue until all
> -		 * is processed or we find a difference.
> -		 */
> -		cmp = __hist_entry__cmp_compute(p_left, p_right, c);
> -		if (cmp)
> -			return cmp;
> -	}
> +	/*
> +	 * If we differ, we are done, otherwise continue until all
> +	 * is processed or we find a difference.
> +	 */

I guess this comment is not applied anymore.  Or we need a loop after
checking sort_compute column, right?

Thanks,
Namhyung


> +	cmp = __hist_entry__cmp_compute(p_left, p_right, c);
> +	if (cmp)
> +		return cmp;
>  
>  	return 0;
>  }
> @@ -759,6 +748,7 @@ static const struct option options[] = {
>  		   "columns '.' is reserved."),
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
> +	OPT_UINTEGER('o', "order", &sort_compute, "Specify compute sorting."),
>  	OPT_END()
>  };
>  
> @@ -1087,6 +1077,11 @@ static int data_init(int argc, const char **argv)
>  		d->idx  = i;
>  	}
>  
> +	if (sort_compute >= (unsigned int) data_cnt) {
> +		pr_err("Order option out of limit.\n");
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  }
