Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0LULy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:54:57 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49546 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LULy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:54:56 -0500
X-AuditID: b753bd60-9ed53ba00000044b-fb-4d10958e05e7
Message-ID: <4D10958C.70000@hitachi.com>
Date: Tue, 21 Dec 2010 20:54:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 5/6] perf-probe: don't always consider EOF as an error
 when listing source code
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com> <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
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
> When listing a whole file or a function which is located at the end,
> perf-probe -L output wrongly: "Source file is shorter than expected.".
> 
> This is because show_one_line() always consider EOF as an error.

Right, that was a wrong behavior.

> 
> This patch fixes this by not considering EOF as an error when dumping
> the trailing lines. Otherwise it's still an error and perf-probe still
> outputs its warning.

Thank you for fixing the bug! :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |   38 ++++++++++++++++++++++++++------------
>  1 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 8e5f5ff..1e81936 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -297,7 +297,7 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
>  #define LINEBUF_SIZE 256
>  #define NR_ADDITIONAL_LINES 2
>  
> -static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
> +static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
>  {
>  	char buf[LINEBUF_SIZE];
>  	const char *color = show_num ? "" : PERF_COLOR_BLUE;
> @@ -316,16 +316,30 @@ static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
>  
>  	} while (strchr(buf, '\n') == NULL);
>  
> -	return 0;
> +	return 1;
>  error:
> -	if (feof(fp))
> +	if (ferror(fp)) {
>  		pr_warning("Source file is shorter than expected.\n");
> -	else
> -		pr_warning("File read error: %s\n", strerror(errno));
> +		return -1;
> +	}
> +	return 0;
> +}
>  
> -	return -1;
> +static int _show_one_line(FILE *fp, int l, bool skip, bool show_num)
> +{
> +	int rv = __show_one_line(fp, l, skip, show_num);
> +	if (rv == 0) {
> +		pr_warning("Source file is shorter than expected.\n");
> +		rv = -1;
> +	}
> +	return rv;
>  }
>  
> +#define show_one_line_with_num(f,l)	_show_one_line(f,l,false,true)
> +#define show_one_line(f,l)		_show_one_line(f,l,false,false)
> +#define skip_one_line(f,l)		_show_one_line(f,l,true,false)
> +#define show_one_line_or_eof(f,l)	__show_one_line(f,l,false,false)
> +
>  /*
>   * Show line-range always requires debuginfo to find source file and
>   * line number.
> @@ -384,27 +398,27 @@ int show_line_range(struct line_range *lr, const char *module)
>  	}
>  	/* Skip to starting line number */
>  	while (l < lr->start) {
> -		ret = show_one_line(fp, l++, true, false);
> +		ret = skip_one_line(fp, l++);
>  		if (ret < 0)
>  			goto end;
>  	}
>  
>  	list_for_each_entry(ln, &lr->line_list, list) {
>  		for (; ln->line > l; l++) {
> -			ret = show_one_line(fp, l - lr->offset, false, false);
> +			ret = show_one_line(fp, l - lr->offset);
>  			if (ret < 0)
>  				goto end;
>  		}
> -		ret = show_one_line(fp, l++ - lr->offset, false, true);
> +		ret = show_one_line_with_num(fp, l++ - lr->offset);
>  		if (ret < 0)
>  			goto end;
>  	}
>  
>  	if (lr->end == INT_MAX)
>  		lr->end = l + NR_ADDITIONAL_LINES;
> -	while (l <= lr->end && !feof(fp)) {
> -		ret = show_one_line(fp, l++ - lr->offset, false, false);
> -		if (ret < 0)
> +	while (l <= lr->end) {
> +		ret = show_one_line_or_eof(fp, l++ - lr->offset);
> +		if (ret <= 0)
>  			break;
>  	}
>  end:


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
