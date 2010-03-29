Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0C2UCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:02:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0C2UCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:02:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wSBFlIsbKH4ccxl9QzMzctK4NYITrK+DyQQ7DYu3kqt9LnjFiMOXnunXVKxPSeK30
	r0vsEbt+BPFx5XFslCOHw==
Date: Mon, 29 Mar 2010 13:01:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: anfei <anfei.zhou@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
In-Reply-To: <20100329140633.GA26464@desktop>
Message-ID: <alpine.DEB.2.00.1003291259400.14859@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com>
 <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329140633.GA26464@desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, anfei wrote:

> I think this method is okay, but it's easy to trigger another bug of
> oom.  See select_bad_process():
> 	if (!p->mm)
> 		continue;
> !p->mm is not always an unaccepted condition.  e.g. "p" is killed and
> doing exit, setting tsk->mm to NULL is before releasing the memory.
> And in multi threading environment, this happens much more.
> In __out_of_memory(), it panics if select_bad_process returns NULL.
> The simple way to fix it is as mem_cgroup_out_of_memory() does.
> 

This is fixed by 
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch in 
the -mm tree.

See 
http://userweb.kernel.org/~akpm/mmotm/broken-out/oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index afeab2a..9aae208 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -588,12 +588,8 @@ retry:
>  	if (PTR_ERR(p) == -1UL)
>  		return;
>  
> -	/* Found nothing?!?! Either we hang forever, or we panic. */
> -	if (!p) {
> -		read_unlock(&tasklist_lock);
> -		dump_header(NULL, gfp_mask, order, NULL);
> -		panic("Out of memory and no killable processes...\n");
> -	}
> +	if (!p)
> +		p = current;
>  
>  	if (oom_kill_process(p, gfp_mask, order, points, NULL,
>  			     "Out of memory"))

The reason p wasn't selected is because it fails to meet the criteria for 
candidacy in select_bad_process(), not necessarily because of a race with 
the !p->mm check that the -mm patch cited above fixes.  It's quite 
possible that current has an oom_adj value of OOM_DISABLE, for example, 
where this would be wrong.
