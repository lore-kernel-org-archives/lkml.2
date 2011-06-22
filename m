Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab1FVXBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:01:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab1FVXBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DB3mMB90tGLUpsPR4kXRlX7ycLsRaok2aAqBc7ScuWSOPQ3nKkHvZT5iyzI/ynVoFW
         ea4YUZNKzeOFy42X1j/Q==
Date: Wed, 22 Jun 2011 16:01:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, caiqian@redhat.com,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/6] oom: kill younger process first
In-Reply-To: <4E01C84A.60400@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1106221600050.11759@chino.kir.corp.google.com>
References: <4E01C7D5.3060603@jp.fujitsu.com> <4E01C84A.60400@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, KOSAKI Motohiro wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index e4e6d7b..392ff30 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2257,6 +2257,9 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
>  #define next_task(p) \
>  	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
> 
> +#define prev_task(p) \
> +	list_entry((p)->tasks.prev, struct task_struct, tasks)
> +
>  #define for_each_process(p) \
>  	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
> 
> @@ -2269,6 +2272,14 @@ extern bool current_is_single_threaded(void);
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

I've already ack'd the patch, but if there is another version posted as a 
result of our discussion of using euid in the heuristic, I think it would 
be helpful to reiterate in this comment that, like do_each_thread(), 
do_each_thread_reverse() is not break-safe either.  It might end up 
preventing a bug down the road.
