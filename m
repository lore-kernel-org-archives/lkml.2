Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031075Ab1EWWVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:21:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab1EWWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=c4Iq2xByisEnqWiRnSc6jizdGSCb1TvvUGD0yhA2hC0/p1qFDOwDQZrPJM7s3OqpQN
         TR1nqHdkUpX4GViuxiXw==
Date: Mon, 23 May 2011 15:20:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 2/5] oom: kill younger process first
In-Reply-To: <4DD62007.6020600@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105231516420.17840@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD62007.6020600@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, KOSAKI Motohiro wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 013314a..3698379 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2194,6 +2194,9 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
>  #define next_task(p) \
>  	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
> 
> +#define prev_task(p) \
> +	list_entry((p)->tasks.prev, struct task_struct, tasks)
> +
>  #define for_each_process(p) \
>  	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
> 
> @@ -2206,6 +2209,14 @@ extern bool current_is_single_threaded(void);
>  #define do_each_thread(g, t) \
>  	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
> 
> +/*
> + * Similar to do_each_thread(). but two difference are there.
> + *  - traverse tasks reverse order (i.e. younger to older)
> + *  - caller must hold tasklist_lock. rcu_read_lock isn't enough
> +*/
> +#define do_each_thread_reverse(g, t) \
> +	for (g = t = &init_task ; (g = t = prev_task(g)) != &init_task ; ) do
> +
>  #define while_each_thread(g, t) \
>  	while ((t = next_thread(t)) != g)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 43d32ae..e6a6c6f 100644
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

Same response as when you initially proposed this patch: the comment needs 
to explicitly state that it is not break-safe just like do_each_thread().  
See http://marc.info/?l=linux-mm&m=130507027312785

A comment such as

	/*
	 * Reverse of do_each_thread(); still not break-safe.
	 * Must hold tasklist_lock.
	 */

would suffice.  There are no "callers" to a macro.

After that:

	Acked-by: David Rientjes <rientjes@google.com>
