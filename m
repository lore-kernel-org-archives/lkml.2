Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab2DYMKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:10:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48089 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab2DYMKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:10:47 -0400
Message-ID: <1335355827.28150.263.camel@twins>
Subject: Re: [PATCH] fix oops in updating thread cputime and task time
From: Peter Zijlstra <peterz@infradead.org>
To: Fawzi Mohamed <fmohamed@me.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Dargel <td@chemie.hu-berlin.de>,
        Hillf Danton <dhillf@gmail.com>, Paul Turner <pjt@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Wed, 25 Apr 2012 14:10:27 +0200
In-Reply-To: <301628B7-B058-4C01-9A65-F2A4AAF05EE6@me.com>
References: <A4012A3B-7FF6-4ED8-8E00-51661D11CF4C@gmx.ch>
	 <301628B7-B058-4C01-9A65-F2A4AAF05EE6@me.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-21 at 09:23 +0200, Fawzi Mohamed wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4603b9d..03a2d89 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2966,7 +2966,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
>                 u64 temp = (__force u64) rtime;
>  
>                 temp *= (__force u64) utime;
> -               do_div(temp, (__force u32) total);
> +               temp = div64_u64(temp, total);
>                 utime = (__force cputime_t) temp;
>         } else
>                 utime = rtime;
> @@ -2999,7 +2999,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
>                 u64 temp = (__force u64) rtime;
>  
>                 temp *= (__force u64) cputime.utime;
> -               do_div(temp, (__force u32) total);
> +               temp = div64_u64(temp, total);
>                 utime = (__force cputime_t) temp;
>         } else
>                 utime = rtime; 

I'm not entirely sure why it takes 19 days, suppose we have HZ=1000 and
your app never idles, it still takes 2^32/1000 seconds ~50 days to
overflow that u32.

Anyway, yes your patch avoids the /0 issue, but it leaves the other
problem with that code..

  rtime * utime / total

The multiplication can overflow the u64 at which point you're staring at
complete rubbish, this happens at about that same point.

So I figure we need to use the shiny new mult_frac() primitive.

32bit platforms are going to be staring at crap either way though, since
their entire time accounting (cputime_t) will start warping at that
point,.. not sure what if anything we should do about that though..
anybody?
