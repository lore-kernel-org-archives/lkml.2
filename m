Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1EJXbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:31:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1EJXbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=J+3a2Xt6EIxsATv02TfhOZVFOqU1EWBk02wyF63D7844Hod/Xu9hJLingHdSQpnyfB
         WTqdq08dea8cE0ZkL0Xw==
Date: Tue, 10 May 2011 16:31:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] oom: kill younger process first
In-Reply-To: <20110510171641.16AF.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105101629590.12477@chino.kir.corp.google.com>
References: <20110509182110.167F.A69D9226@jp.fujitsu.com> <20110510171335.16A7.A69D9226@jp.fujitsu.com> <20110510171641.16AF.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, KOSAKI Motohiro wrote:

> This patch introduces do_each_thread_reverse() and
> select_bad_process() uses it. The benefits are two,
> 1) oom-killer can kill younger process than older if
> they have a same oom score. Usually younger process
> is less important. 2) younger task often have PF_EXITING
> because shell script makes a lot of short lived processes.
> Reverse order search can detect it faster.
> 

I like this change, thanks!  I'm suprised we haven't needed a 
do_each_thread_reverse() in the past somewhere else in the kernel.

Could you update the comment about do_each_thread() not being break-safe 
in the second version, though?

After that:

	Acked-by: David Rientjes <rientjes@google.com>

> Reported-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/sched.h |    6 ++++++
>  mm/oom_kill.c         |    2 +-
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 013314a..a0a8339 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2194,6 +2194,9 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
>  #define next_task(p) \
>  	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
>  
> +#define prev_task(p) \
> +	list_entry_rcu((p)->tasks.prev, struct task_struct, tasks)
> +
>  #define for_each_process(p) \
>  	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
>  
> @@ -2206,6 +2209,9 @@ extern bool current_is_single_threaded(void);
>  #define do_each_thread(g, t) \
>  	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
>  
> +#define do_each_thread_reverse(g, t) \
> +	for (g = t = &init_task ; (g = t = prev_task(g)) != &init_task ; ) do
> +
>  #define while_each_thread(g, t) \
>  	while ((t = next_thread(t)) != g)
>  
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 118d958..0cf5091 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -282,7 +282,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  	struct task_struct *chosen = NULL;
>  	*ppoints = 0;
>  
> -	do_each_thread(g, p) {
> +	do_each_thread_reverse(g, p) {
>  		unsigned int points;
>  
>  		if (!p->mm)
