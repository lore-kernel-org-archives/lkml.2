Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0LZOaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 09:30:30 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37135 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0LZOa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 09:30:29 -0500
X-AuditID: b753bd60-a30f9ba000000f8d-43-4d175182a669
Message-ID: <4D17517F.6060701@hitachi.com>
Date: Sun, 26 Dec 2010 23:30:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: fix perf-probe(1)'s report
References: <m31v588r9k.fsf@gmail.com>
In-Reply-To: <m31v588r9k.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/24 0:04), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> After adding probes, perf-probe(1) reports the probes locations which
> include filenames for certain cases.
> 
> But for short file names (whose length < 32), perf-probe didn't display
> the name correctly. It actually skipped the first character.
> 
> Here's an example where 'icmp.c' was screwed:
> 
>    $ perf probe -n -a "icmp.c;sk=*"
>    Add new events:
>      probe:icmp_push_reply (on @cmp.c)
>      probe:icmp_reply     (on @cmp.c)
>      probe:icmp_reply_1   (on @cmp.c)
>      probe:icmp_send      (on @cmp.c)
>      probe:icmp_send_1    (on @cmp.c)
>      probe:icmp_error     (on @cmp.c)
>      probe:icmp_error_1   (on @cmp.c)
>      probe:icmp_error_2   (on @cmp.c)
>      probe:icmp_error_3   (on @cmp.c)
> 
> This patch fixes this bug in synthesize_perf_probe_point().

Oops, I've missed that.
Thanks! that's really good catch!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 10ad1ad..adc2620 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1077,13 +1077,13 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
>  			goto error;
>  	}
>  	if (pp->file) {
> -		len = strlen(pp->file) - 31;
> -		if (len < 0)
> -			len = 0;
> -		tmp = strchr(pp->file + len, '/');
> -		if (!tmp)
> -			tmp = pp->file + len;
> -		ret = e_snprintf(file, 32, "@%s", tmp + 1);
> +		tmp = pp->file;
> +		len = strlen(tmp);
> +		if (len > 30) {
> +			tmp = strchr(pp->file + len - 30, '/');
> +			tmp = tmp ? tmp + 1 : pp->file + len - 30;
> +		}
> +		ret = e_snprintf(file, 32, "@%s", tmp);
>  		if (ret <= 0)
>  			goto error;
>  	}
> @@ -1099,7 +1099,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
>  
>  	return buf;
>  error:
> -	pr_debug("Failed to synthesize perf probe point: %s",
> +	pr_debug("Failed to synthesize perf probe point: %s\n",
>  		 strerror(-ret));
>  	if (buf)
>  		free(buf);


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
