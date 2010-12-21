Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab0LUIzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:55:36 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53689 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab0LUIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:55:35 -0500
X-AuditID: b753bd60-a3afaba000000f8d-69-4d106b859781
Message-ID: <4D106B81.6090504@hitachi.com>
Date: Tue, 21 Dec 2010 17:55:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 2/6] perf-probe: rewrite show_one_line() to make it simpler
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com> <1292854685-8230-3-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1292854685-8230-3-git-send-email-fbuihuu@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/20 23:18), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>

Please explain what this patch will do...

> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |   29 +++++++++++------------------
>  1 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 6fa0403..5cc8f6b 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -300,28 +300,21 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
>  static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
>  {
>  	char buf[LINEBUF_SIZE];
> -	const char *color = PERF_COLOR_BLUE;
> +	const char *color = show_num ? "" : PERF_COLOR_BLUE;
> +	const char *prefix = NULL;
>  
> -	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
> -		goto error;
> -	if (!skip) {
> -		if (show_num)
> -			fprintf(stdout, "%7d  %s", l, buf);
> -		else
> -			color_fprintf(stdout, color, "         %s", buf);
> -	}
> -
> -	while (strlen(buf) == LINEBUF_SIZE - 1 &&
> -	       buf[LINEBUF_SIZE - 2] != '\n') {
> +	do {
>  		if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
>  			goto error;
> -		if (!skip) {
> -			if (show_num)
> -				fprintf(stdout, "%s", buf);
> -			else
> -				color_fprintf(stdout, color, "%s", buf);
> +		if (skip)
> +			continue;
> +		if (!prefix) {
> +			prefix = show_num ? "%7d  " : "         ";
> +			fprintf(stdout, prefix, l);

Could you use color_fprintf() here too?
I know currently it's meaningless, but from the view of maintaining,
it's better to use same function.

Thank you,

>  		}
> -	}
> +		color_fprintf(stdout, color, "%s", buf);
> +
> +	} while (strchr(buf, '\n') == NULL);
>  
>  	return 0;
>  error:


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
