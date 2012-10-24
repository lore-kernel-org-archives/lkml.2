Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2JXHtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab2JXHts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:49:48 -0400
Date: Wed, 24 Oct 2012 09:49:42 +0200
From: Andrew Jones <drjones@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf tools: Fix strbuf_addf() when the buffer needs
 to grow
Message-ID: <20121024074941.GB2227@turtle.usersys.redhat.com>
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
 <1350999890-6920-1-git-send-email-namhyung@kernel.org>
 <1350999890-6920-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350999890-6920-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:44:50PM +0900, Namhyung Kim wrote:
> This was found during chasing down the header output regression.
> The strbuf_addf() was checking buffer length with a result of
> vscnprintf() which cannot be greater than that of strbuf_avail().
> 
> Since numa topology and pmu mapping info in header were converted
> to use strbuf, it sometimes caused uninteresting behaviors with the
> broken strbuf.
> 
> Fix it by using vsnprintf() which returns desired output string
> length regardless of the available buffer size and grow the buffer
> if needed.
> 
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/strbuf.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
> index 2eeb51baf077..cfa906882e2c 100644
> --- a/tools/perf/util/strbuf.c
> +++ b/tools/perf/util/strbuf.c
> @@ -90,17 +90,17 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
>  	if (!strbuf_avail(sb))
>  		strbuf_grow(sb, 64);
>  	va_start(ap, fmt);
> -	len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
> +	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
>  	va_end(ap);
>  	if (len < 0)
> -		die("your vscnprintf is broken");
> +		die("your vsnprintf is broken");
>  	if (len > strbuf_avail(sb)) {
>  		strbuf_grow(sb, len);
>  		va_start(ap, fmt);
> -		len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
> +		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
>  		va_end(ap);
>  		if (len > strbuf_avail(sb)) {
> -			die("this should not happen, your snprintf is broken");
> +			die("this should not happen, your vsnprintf is broken");
>  		}
>  	}
>  	strbuf_setlen(sb, sb->len + len);
> -- 
> 1.7.9.2
>

Tested-by: Andrew Jones <drjones@redhat.com> 
