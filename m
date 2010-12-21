Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab0LUNLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:11:06 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58093 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0LUNLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:11:04 -0500
X-AuditID: b753bd60-a4ba2ba000003e7d-c1-4d10a765f397
Message-ID: <4D10A763.4080209@hitachi.com>
Date: Tue, 21 Dec 2010 22:10:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 6/6] perf-probe: handle gracefully some stupid and buggy
 line syntaxes
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com> <1292854685-8230-7-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1292854685-8230-7-git-send-email-fbuihuu@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/20 23:18), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Currently perf-probe doesn't handle those incorrect syntaxes
> 
>    $ perf probe -L sched.c:++13
>    $ perf probe -L sched.c:-+13
>    $ perf probe -L sched.c:10000000000000000000000000000+13
> 
> This patches rewrites parse_line_range_desc() to handle them.

OK, without this patch, perf probe accepted that as "0+13".
With this, perf probe rejects it as an invalid input.

Thank you!

> 
> As a bonus side, it reports more usefull error messages instead of:
> "Tailing with invalid character...".
> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  tools/perf/util/probe-event.c |   92 ++++++++++++++++++++++++++--------------
>  1 files changed, 60 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 1e81936..469ad35 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -539,6 +539,19 @@ int show_available_vars(struct perf_probe_event *pevs __unused,
>  }
>  #endif
>  
> +static int parse_line_num(char **ptr, int *val, const char *what)
> +{
> +	const char *start = *ptr;
> +
> +	errno = 0;
> +	*val = strtol(*ptr, ptr, 0);
> +	if (errno || *ptr == start) {
> +		semantic_error("'%s' is not a valid number.\n", what);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Stuff 'lr' according to the line range described by 'arg'.
>   * The line range syntax is described by:
> @@ -548,50 +561,65 @@ int show_available_vars(struct perf_probe_event *pevs __unused,
>   */
>  int parse_line_range_desc(const char *arg, struct line_range *lr)
>  {
> -	const char *ptr;
> -	char *tmp;
> +	char *range, *name = strdup(arg);
> +	int err;
> +
> +	if (!name)
> +		return -ENOMEM;
> +
> +	lr->start = 0;
> +	lr->end = INT_MAX;
> +
> +	range = strchr(name, ':');
> +	if (range) {
> +		*range++ = '\0';
> +
> +		err = parse_line_num(&range, &lr->start, "start line");
> +		if (err)
> +			goto err;
> +
> +		if (*range == '+' || *range == '-') {
> +			const char c = *range++;
> +
> +			err = parse_line_num(&range, &lr->end, "end line");
> +			if (err)
> +				goto err;
> +
> +			if (c == '+') {
> +				lr->end += lr->start;
> +				/*
> +				 * Adjust the number of lines here.
> +				 * If the number of lines == 1, the
> +				 * the end of line should be equal to
> +				 * the start of line.
> +				 */
> +				lr->end--;
> +			}
> +		}
>  
> -	ptr = strchr(arg, ':');
> -	if (ptr) {
> -		lr->start = (int)strtoul(ptr + 1, &tmp, 0);
> -		if (*tmp == '+') {
> -			lr->end = lr->start + (int)strtoul(tmp + 1, &tmp, 0);
> -			lr->end--;	/*
> -					 * Adjust the number of lines here.
> -					 * If the number of lines == 1, the
> -					 * the end of line should be equal to
> -					 * the start of line.
> -					 */
> -		} else if (*tmp == '-')
> -			lr->end = (int)strtoul(tmp + 1, &tmp, 0);
> -		else
> -			lr->end = INT_MAX;
>  		pr_debug("Line range is %d to %d\n", lr->start, lr->end);
> +
> +		err = -EINVAL;
>  		if (lr->start > lr->end) {
>  			semantic_error("Start line must be smaller"
>  				       " than end line.\n");
> -			return -EINVAL;
> +			goto err;
>  		}
> -		if (*tmp != '\0') {
> -			semantic_error("Tailing with invalid character '%d'.\n",
> -				       *tmp);
> -			return -EINVAL;
> +		if (*range != '\0') {
> +			semantic_error("Tailing with invalid str '%s'.\n", range);
> +			goto err;
>  		}
> -		tmp = strndup(arg, (ptr - arg));
> -	} else {
> -		tmp = strdup(arg);
> -		lr->end = INT_MAX;
>  	}
>  
> -	if (tmp == NULL)
> -		return -ENOMEM;
> -
> -	if (strchr(tmp, '.'))
> -		lr->file = tmp;
> +	if (strchr(name, '.'))
> +		lr->file = name;
>  	else
> -		lr->function = tmp;
> +		lr->function = name;
>  
>  	return 0;
> +err:
> +	free(name);
> +	return err;
>  }
>  
>  /* Check the name is good for event/group */


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
