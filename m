Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0DAIfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:35:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0DAIfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:35:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qWqJe7CLrbodDnRH6Ksg5L3+9rFpiieIE50Mk8V8FLvlu8W0AbrSQuKKJhzW1A4wq
	mDSKH4YOX1DAr0JCaHdhw==
Date: Thu, 1 Apr 2010 01:35:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
 been killed
In-Reply-To: <20100331204718.GD11635@redhat.com>
Message-ID: <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com>
References: <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com>
 <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Oleg Nesterov wrote:

> Probably something like the patch below makes sense. Note that
> "skip kernel threads" logic is wrong too, we should check PF_KTHREAD.
> Probably it is better to check it in select_bad_process() instead,
> near is_global_init().
> 

is_global_init() will be true for p->flags & PF_KTHREAD.

> The new helper, find_lock_task_mm(), should be used by
> oom_forkbomb_penalty() too.
> 
> dump_tasks() doesn't need it, it does do_each_thread(). Cough,
> __out_of_memory() and out_of_memory() call it without tasklist.
> We are going to panic() anyway, but still.
> 

Indeed, good observation.

> Oleg.
> 
> --- x/mm/oom_kill.c
> +++ x/mm/oom_kill.c
> @@ -129,6 +129,19 @@ static unsigned long oom_forkbomb_penalt
>  				(child_rss / sysctl_oom_forkbomb_thres) : 0;
>  }
>  
> +static find_lock_task_mm(struct task_struct *p)
> +{
> +	struct task_struct *t = p;
> +	do {
> +		task_lock(t);
> +		if (likely(t->mm && !(t->flags & PF_KTHREAD)))
> +			return t;
> +		task_unlock(t);
> +	} while_each_thred(p, t);
> +
> +	return NULL;
> +}
> +
>  /**
>   * oom_badness - heuristic function to determine which candidate task to kill
>   * @p: task struct of which task we should calculate
> @@ -159,13 +172,9 @@ unsigned int oom_badness(struct task_str
>  	if (p->flags & PF_OOM_ORIGIN)
>  		return 1000;
>  
> -	task_lock(p);
> -	mm = p->mm;
> -	if (!mm) {
> -		task_unlock(p);
> +	p = find_lock_task_mm(p);
> +	if (!p)
>  		return 0;
> -	}
> -
>  	/*
>  	 * The baseline for the badness score is the proportion of RAM that each
>  	 * task's rss and swap space use.
> @@ -330,12 +339,6 @@ static struct task_struct *select_bad_pr
>  			*ppoints = 1000;
>  		}
>  
> -		/*
> -		 * skip kernel threads and tasks which have already released
> -		 * their mm.
> -		 */
> -		if (!p->mm)
> -			continue;
>  		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
>  			continue;

You can't do this for the reason I cited in another email, oom_badness() 
returning 0 does not exclude a task from being chosen by 
selcet_bad_process(), it will use that task if nothing else has been found 
yet.  We must explicitly filter it from consideration by checking for 
!p->mm.
