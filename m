Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1DUN3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:29:15 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:60656 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1DUN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XKSwdljAjNWrN/hxmYA+VGwYU0JexEnB8hMOlrbZ3SZNjHUze0GQoZ2YxZ07TshCXr
         INgEZwIV5a2nSxojmxGIBjjBCi55thwgAdr5zDil4g88HQEnoIO4DOzpm+ujtlPkCSUy
         FkJaNFspyEdzmjqOlCQhBQH5CJH1IeROl4n6Q=
Date: Thu, 21 Apr 2011 21:29:04 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: deduplicate mm checks in normalize_rt_tasks()
Message-ID: <20110421132904.GA2702@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTi=41=2_QOMOabg1UrwQ2A06fJAY9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTi=41=2_QOMOabg1UrwQ2A06fJAY9w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:15:56PM +0800, Hillf Danton wrote:
> When normalizing realtime tasks, only user tasks are concerned by
> checking their ->mm.
> If the task is not realtime, the -mm is checked again, thus the
> overwork could be removed.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
> +++ b/kernel/sched.c	2011-04-21 20:59:28.000000000 +0800
> @@ -8364,7 +8364,7 @@ void normalize_rt_tasks(void)
>  			 * Renice negative nice level userspace
>  			 * tasks back to 0:
>  			 */
> -			if (TASK_NICE(p) < 0 && p->mm)
> +			if (TASK_NICE(p) < 0)

This looks good.

And we can also move TASK_NICE(p) < 0 to the upper if(),
like:
		if (!rt_task(p) && TASK_NICE(p) < 0) {
			set_user_nice(p, 0);
			continue;
		}

to reduce one level if() to make code cleaner :)

Thanks,
Yong

>  				set_user_nice(p, 0);
>  			continue;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
