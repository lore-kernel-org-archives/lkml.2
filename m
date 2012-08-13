Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2HMLsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab2HMLsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:48:38 -0400
Date: Mon, 13 Aug 2012 13:48:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] sched: fix divide by zero at {thread_group,task}_times
Message-ID: <20120813114820.GA2834@redhat.com>
References: <20120808092714.GA3580@redhat.com>
 <1344455404.2440.35.camel@marge.simpson.net>
 <1344456500.16728.15.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344456500.16728.15.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:08:20PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-08-08 at 21:50 +0200, Mike Galbraith wrote:
> > 32bit built do_div()
> > and div64_u64() both sucked equally compared to 64bit 
> 
> /me peeks at div64_u64 fallback implementation and sees why, it still
> does a single div, it does some neat fls tricks.
> 
> Ok, no point in avoiding this then.. 
> 
> I did the below little edit, no point in mixing the old and new
> primitives.. those __force things annoy me, but I guess otherwise we'll
> upset sparse.

Yeah, __force is needed for sparse, since we marked cputime_t with 
__nocast (by commit 648616343cdbe904c585a6c12e323d3b3c72e46f, which btw
looks like very nice cleanup at whole).

> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -3149,7 +3149,7 @@ static cputime_t scale_utime(cputime_t u
>  	temp *= (__force u64) utime;
>  
>  	if (sizeof(cputime_t) == 4)
> -		do_div(temp, (__force u32) total);
> +		temp = div_u64(temp, (__force u32) total);
>  	else
>  		temp = div64_u64(temp, (__force u64) total);

Is this or will be queued (I do not see it queued anywhere)? Or should
I repost with above change?

Thanks
Stanislaw
