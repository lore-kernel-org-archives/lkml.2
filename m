Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0I2Nkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:40:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57274 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0I2Nkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=p1AlhmLFlnS+eD8tQ0e4MWcoUulGfLxlcHfSv6iLR2g4KBpY3mnIvw0CyyTOIDYkZo
         qsRWbVO9Yz7tSrq/BpGBhXZzugEiWhhGETzJUhkh+QUYBZW324bgEDuwSnyT9myFLIP1
         dZ5VVL9SJQJXH6m5ENq+4K/OkDWS2aFl5ontY=
Date: Wed, 29 Sep 2010 15:40:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v1.2] trace/function-graph: Fix build warning on 32-bit
Message-ID: <20100929133927.GB5602@nowhere>
References: <20100929073853.GA13264@liondog.tnic> <20100929080823.GA13595@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100929080823.GA13595@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:08:23AM +0200, Borislav Petkov wrote:
> > Fix
> > 
> > kernel/trace/trace_functions_graph.c: In function ‘trace_print_graph_duration’:
> > kernel/trace/trace_functions_graph.c:652: warning: comparison of distinct pointer types lacks a cast
> 
> sh*t, I got completely carried away with all that typechecking, take
> this one instead:
> 
> --


Queued, thanks!



> From: Borislav Petkov <bp@alien8.de>
> Date: Wed, 29 Sep 2010 08:39:43 +0200
> Subject: [PATCH] trace/function-graph: Fix build warning on 32-bit
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Fix
> 
> kernel/trace/trace_functions_graph.c: In function ‘trace_print_graph_duration’:
> kernel/trace/trace_functions_graph.c:652: warning: comparison of distinct pointer types lacks a cast
> 
> when building 36-rc6 on a 32-bit due to the strict type check failing in
> the min() macro.
> 
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  kernel/trace/trace_functions_graph.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 6f23369..82306cc 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -649,8 +649,9 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
>  
>  	/* Print nsecs (we don't want to exceed 7 numbers) */
>  	if (len < 7) {
> -		snprintf(nsecs_str, min(sizeof(nsecs_str), 8UL - len), "%03lu",
> -			 nsecs_rem);
> +		size_t slen = min_t(size_t, sizeof(nsecs_str), 8UL - len);
> +
> +		snprintf(nsecs_str, slen, "%03lu", nsecs_rem);
>  		ret = trace_seq_printf(s, ".%s", nsecs_str);
>  		if (!ret)
>  			return TRACE_TYPE_PARTIAL_LINE;
> -- 
> 1.7.2.3
> 
> -- 
> Regards/Gruss,
>     Boris.

