Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1KKV0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:26:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51116 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1KKV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:26:09 -0500
Message-ID: <4EBD92ED.4050701@google.com>
Date: Fri, 11 Nov 2011 13:26:05 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.openvz.devel
To: Andrew Vagin <avagin@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] sched: don't call task_group() many times in set_task_rq()
References: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 06:04 AM, Andrew Vagin wrote:
> It improves perfomance, especially if autogroup enabled.
>
> The size of set_task_rq() was 0x180 and now it is 0xa0.

A slightly more verbose commit message would be helpful here.

>
> Signed-off-by: Andrew Vagin<avagin@openvz.org>

Signed-off-by: Paul Turner <pjt@google.com>

> ---
>   kernel/sched.c |   12 ++++++++----
>   1 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d87c6e5..a740eec 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -766,14 +766,18 @@ static inline struct task_group *task_group(struct task_struct *p)
>   /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
>   static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
>   {
> +#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
> +	struct task_group *tg = task_group(p);
> +#endif
> +
>   #ifdef CONFIG_FAIR_GROUP_SCHED
> -	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
> -	p->se.parent = task_group(p)->se[cpu];
> +	p->se.cfs_rq = tg->cfs_rq[cpu];
> +	p->se.parent = tg->se[cpu];
>   #endif
>
>   #ifdef CONFIG_RT_GROUP_SCHED
> -	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
> -	p->rt.parent = task_group(p)->rt_se[cpu];
> +	p->rt.rt_rq  = tg->rt_rq[cpu];
> +	p->rt.parent = tg->rt_se[cpu];
>   #endif
>   }
>

