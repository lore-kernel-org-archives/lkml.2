Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1EMGxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:53:49 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:55564 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab1EMGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:53:48 -0400
Date: Fri, 13 May 2011 02:53:16 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Message-ID: <958295827.17529.1305269596598.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <alpine.DEB.2.00.1105111331480.9346@chino.kir.corp.google.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes
 memory (was Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable())
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Tue, 10 May 2011, CAI Qian wrote:
> 
> > Sure, I saw there were some discussion going on between you and
> > David
> > about your patches. Does it make more sense for me to test those
> > after
> > you have settled down technical arguments?
> >
> 
> Something like the following (untested) patch should fix the issue by
> simply increasing the range of a task's badness from 0-1000 to
> 0-10000.
> 
> There are other things to fix like the tasklist dump output and
> documentation, but this shows how easy it is to increase the
> resolution of
> the scoring. (This patch also includes a change to only give root
> processes a 1% bonus for every 30% of memory they use as proposed
> earlier.)
I have had a chance to test this patch after applied this patch manually
(dd not apply cleanly) on the top of mainline kernel. The test is still
running because it is trying to kill tons of python processes instread
of the parent. Isn't there a way for oom to be smart enough to do
"killall python"?
> 
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -160,7 +160,7 @@ unsigned int oom_badness(struct task_struct *p,
> struct mem_cgroup *mem,
> */
> if (p->flags & PF_OOM_ORIGIN) {
> task_unlock(p);
> - return 1000;
> + return 10000;
> }
> 
> /*
> @@ -177,32 +177,32 @@ unsigned int oom_badness(struct task_struct *p,
> struct mem_cgroup *mem,
> points = get_mm_rss(p->mm) + p->mm->nr_ptes;
> points += get_mm_counter(p->mm, MM_SWAPENTS);
> 
> - points *= 1000;
> + points *= 10000;
> points /= totalpages;
> task_unlock(p);
> 
> /*
> - * Root processes get 3% bonus, just like the __vm_enough_memory()
> - * implementation used by LSMs.
> + * Root processes get 1% bonus per 30% memory used for a total of 3%
> + * possible just like LSMs.
> */
> if (has_capability_noaudit(p, CAP_SYS_ADMIN))
> - points -= 30;
> + points -= 100 * (points / 3000);
> 
> /*
> * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
> * either completely disable oom killing or always prefer a certain
> * task.
> */
> - points += p->signal->oom_score_adj;
> + points += p->signal->oom_score_adj * 10;
> 
> /*
> * Never return 0 for an eligible task that may be killed since it's
> - * possible that no single user task uses more than 0.1% of memory
> and
> + * possible that no single user task uses more than 0.01% of memory
> and
> * no single admin tasks uses more than 3.0%.
> */
> if (points <= 0)
> return 1;
> - return (points < 1000) ? points : 1000;
> + return (points < 10000) ? points : 10000;
> }
> 
> /*
> @@ -314,7 +314,7 @@ static struct task_struct
> *select_bad_process(unsigned int *ppoints,
> */
> if (p == current) {
> chosen = p;
> - *ppoints = 1000;
> + *ppoints = 10000;
> } else {
> /*
> * If this task is not being ptraced on exit,
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org. For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign
> http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
