Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1DWOLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:11:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab1DWOLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mZyzLH68OSCM0D7oFPT0E86VLRp8lImJfGIeptFjRGimA+F5tgXf7yQFbgl8P0yroz
         tTmd/SOCldCLiWfcIljYRfx70mkVZXNkMm96QMnd7erRFmxY1wEzZqQtmaYtnVVTFKHF
         JRmy1ln5L2lG6HxbrL9fCvDKDLJl2HplFn9Gk=
Date: Sat, 23 Apr 2011 22:11:13 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: try to rewrite tg_has_rt_tasks()
Message-ID: <20110423141113.GA7747@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTimyN49J0UTo69Rabppeow9Fz-LcfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTimyN49J0UTo69Rabppeow9Fz-LcfQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 09:39:40PM +0800, Hillf Danton wrote:
> It is reshuffled not based upon scanning the list of existing threads
> but upon the relevant info carried by the input task group. Compared
> with the original, it is simpler, and nothing important is missed.

Oh, no.

There may be sleep task which is attach this group.

Thanks,
Yong

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
> +++ b/kernel/sched.c	2011-04-23 21:48:14.000000000 +0800
> @@ -8756,13 +8756,11 @@ static unsigned long to_ratio(u64 period
>  /* Must be called with tasklist_lock held */
>  static inline int tg_has_rt_tasks(struct task_group *tg)
>  {
> -	struct task_struct *g, *p;
> -
> -	do_each_thread(g, p) {
> -		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
> +	int cpu;
> +	for_each_online_cpu(cpu) {
> +		if (tg->rt_rq[cpu]->rt_nr_running != 0)
>  			return 1;
> -	} while_each_thread(g, p);
> -
> +	}
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
