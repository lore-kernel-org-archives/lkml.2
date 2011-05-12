Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1ELAN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:13:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52506 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1ELANz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KxjMJaiRvRd9m/GtUupj4ahrhZpkOE5lXmKvTJjZSuopPL4e+1NxnuFhZ788nvhjIl
         SjHYXG0PUu2ApV57v7uKbY2HrlE/69brF/UySVTr8rbnBzC1bgXs4yyxf5q8N0XVSF7V
         PdkfnY6mfRcGR7ml9GXQuxdtRAthHLJqS8ntw=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105111331480.9346@chino.kir.corp.google.com>
References: <1889981320.330808.1305081044822.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<alpine.DEB.2.00.1105111331480.9346@chino.kir.corp.google.com>
Date: Thu, 12 May 2011 09:13:54 +0900
Message-ID: <BANLkTi=fNtPZQk5Mp7rbZJFpA1tzBh+VcA@mail.gmail.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes
 memory (was Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable())
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: CAI Qian <caiqian@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 5:34 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 10 May 2011, CAI Qian wrote:
>
>> Sure, I saw there were some discussion going on between you and David
>> about your patches. Does it make more sense for me to test those after
>> you have settled down technical arguments?
>>
>
> Something like the following (untested) patch should fix the issue by
> simply increasing the range of a task's badness from 0-1000 to 0-10000.
>
> There are other things to fix like the tasklist dump output and
> documentation, but this shows how easy it is to increase the resolution of
> the scoring.  (This patch also includes a change to only give root

It does make sense.
I think raising resolution should be a easy way to fix the problem.

> processes a 1% bonus for every 30% of memory they use as proposed
> earlier.)

I didn't follow earlier your suggestion.
But it's not formal patch so I expect if you send formal patch to
merge, you would write down the rationale.

>
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -160,7 +160,7 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>         */
>        if (p->flags & PF_OOM_ORIGIN) {
>                task_unlock(p);
> -               return 1000;
> +               return 10000;
>        }
>
>        /*
> @@ -177,32 +177,32 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>        points = get_mm_rss(p->mm) + p->mm->nr_ptes;
>        points += get_mm_counter(p->mm, MM_SWAPENTS);
>
> -       points *= 1000;
> +       points *= 10000;
>        points /= totalpages;
>        task_unlock(p);
>
>        /*
> -        * Root processes get 3% bonus, just like the __vm_enough_memory()
> -        * implementation used by LSMs.
> +        * Root processes get 1% bonus per 30% memory used for a total of 3%
> +        * possible just like LSMs.
>         */
>        if (has_capability_noaudit(p, CAP_SYS_ADMIN))
> -               points -= 30;
> +               points -= 100 * (points / 3000);
>
>        /*
>         * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
>         * either completely disable oom killing or always prefer a certain
>         * task.
>         */
> -       points += p->signal->oom_score_adj;
> +       points += p->signal->oom_score_adj * 10;
>
>        /*
>         * Never return 0 for an eligible task that may be killed since it's
> -        * possible that no single user task uses more than 0.1% of memory and
> +        * possible that no single user task uses more than 0.01% of memory and
>         * no single admin tasks uses more than 3.0%.
>         */
>        if (points <= 0)
>                return 1;
> -       return (points < 1000) ? points : 1000;
> +       return (points < 10000) ? points : 10000;
>  }
>
>  /*
> @@ -314,7 +314,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>                         */
>                        if (p == current) {
>                                chosen = p;
> -                               *ppoints = 1000;
> +                               *ppoints = 10000;

Scattering constant value isn't good.
You are proving it now.
I think you did it since this is not a formal patch.
I expect you will define new value (ex, OOM_INTERNAL_MAX_SCORE or whatever)


-- 
Kind regards,
Minchan Kim
