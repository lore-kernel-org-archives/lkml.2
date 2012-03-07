Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031759Ab2CGBJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:09:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031747Ab2CGBJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:09:21 -0500
Date: Tue, 6 Mar 2012 22:09:04 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: paulus@samba.org, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        fweisbec@gmail.com, yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307010904.GE5656@infradead.org>
References: <20120307114249.44275ca3@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307114249.44275ca3@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 07, 2012 at 11:42:49AM +1100, Anton Blanchard escreveu:
> 
> I have a workload where perf top scribbles over the stack and we
> SEGV. What makes it interesting is that an snprintf is causing this.
> 
> The workload is a c++ gem that has method names over 3000 characters
> long, but snprintf is designed to avoid overrunning buffers. So what
> went wrong?
> 
> The problem is we assume snprintf returns the number of characters
> written:
> 
>     ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
> ...
>     ret += repsep_snprintf(bf + ret, size - ret, "%s", self->ms.sym->name);
> 
> Unfortunately this is not how snprintf works. snprintf returns the
> number of characters that would have been written if there was enough
> space. In the above case, if the first snprintf returns a value larger
> than size, we pass a negative size into the second snprintf and
> happily scribble over the stack. If you have 3000 character c++
> methods thats a lot of stack to trample.
> 
> This patch fixes repsep_snprintf by clamping the value at size - 1
> which is the maximum snprintf can write before adding the NULL
> terminator.
> 
> I get the sinking feeling that there are a lot of other uses of
> snprintf that have this same bug, we should audit them all.

Indeed, I wonder what kind of crack pipe I was smoking when I read the
snprintf man page.

Or what kind of such pipe the people who designed snprintf were using
:-(

> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Cc: stable@kernel.org
> ---
> 
> Index: linux-build/tools/perf/util/sort.c
> ===================================================================
> --- linux-build.orig/tools/perf/util/sort.c	2012-03-07 10:58:57.502318907 +1100
> +++ linux-build/tools/perf/util/sort.c	2012-03-07 11:00:58.812423271 +1100
> @@ -33,6 +33,9 @@ static int repsep_snprintf(char *bf, siz
>  		}
>  	}
>  	va_end(ap);
> +
> +	if (n >= (int)size)
> +		return size - 1;
>  	return n;
>  }
>  
