Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1ASWua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:50:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab1ASWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:50:27 -0500
Date: Wed, 19 Jan 2011 14:50:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Neaten %pK kptr_restrict, save a bit of code
 space
Message-Id: <20110119145024.353ef8a1.akpm@linux-foundation.org>
In-Reply-To: <1294950072.4114.172.camel@Joe-Laptop>
References: <1294950072.4114.172.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 12:21:12 -0800
Joe Perches <joe@perches.com> wrote:

> If kptr restrictions are on, just set the passed pointer to NULL.
> 
> $ size lib/vsprintf.o.*
>    text	   data	    bss	    dec	    hex	filename
>    8247	      4	      2	   8253	   203d	lib/vsprintf.o.new
>    8282	      4	      2	   8288	   2060	lib/vsprintf.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
>  lib/vsprintf.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index d3023df..070d134 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1047,16 +1047,12 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			if (spec.field_width == -1)
>  				spec.field_width = 2 * sizeof(void *);
>  			return string(buf, end, "pK-error", spec);
> -		} else if ((kptr_restrict == 0) ||
> -			 (kptr_restrict == 1 &&
> -			  has_capability_noaudit(current, CAP_SYSLOG)))
> -			break;
> -
> -		if (spec.field_width == -1) {
> -			spec.field_width = 2 * sizeof(void *);
> -			spec.flags |= ZEROPAD;
>  		}
> -		return number(buf, end, 0, spec);
> +		if (!((kptr_restrict == 0) ||
> +		      (kptr_restrict == 1 &&
> +		       has_capability_noaudit(current, CAP_SYSLOG))))
> +			ptr = NULL;
> +		break;
>  	}
>  	spec.flags |= SMALL;
>  	if (spec.field_width == -1) {

This hurts my brain.   Does it work?
