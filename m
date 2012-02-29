Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2B2F4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:56:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37191 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2B2Fz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:55:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 14:54:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH next] memcg: remove PCG_CACHE page_cgroup flag fix
Message-Id: <20120229145425.df27eaec.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202282128500.4875@eggly.anvils>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
	<alpine.LSU.2.00.1202282128500.4875@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 21:30:17 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Swapping tmpfs loads show absurd wrapped rss and wrong cache in memcg's
> memory.stat statistics: __mem_cgroup_uncharge_common() is failing to
> distinguish the anon and tmpfs cases.
> 
I thought I tested this..maybe my test was wrong, sorry.


> Mostly we can decide between them by PageAnon, which is reliable once
> it has been set; but there are several callers who need to uncharge a
> MEM_CGROUP_CHARGE_TYPE_MAPPED page before it was fully initialized,
> so allow that case to override the PageAnon decision.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It seems I should revisit these and consinder some cleanup...

_OFF TOPIC_
To be honest, I don't like to have anon/rss counter in memory.stat because
we have LRU statistics. It seems enough.. If shmem counter is required,
I think we should have shmem counter rather than anon/rss.


> 
>  mm/memcontrol.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- 3.3-rc5-next/mm/memcontrol.c	2012-02-25 10:06:52.496035568 -0800
> +++ linux/mm/memcontrol.c	2012-02-26 10:44:32.146365398 -0800
> @@ -2944,13 +2944,16 @@ __mem_cgroup_uncharge_common(struct page
>  	if (!PageCgroupUsed(pc))
>  		goto unlock_out;
>  
> +	anon = PageAnon(page);
> +
>  	switch (ctype) {
>  	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> +		anon = true;
> +		/* fallthrough */
>  	case MEM_CGROUP_CHARGE_TYPE_DROP:
>  		/* See mem_cgroup_prepare_migration() */
>  		if (page_mapped(page) || PageCgroupMigration(pc))
>  			goto unlock_out;
> -		anon = true;
>  		break;
>  	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
>  		if (!PageAnon(page)) {	/* Shared memory */
> @@ -2958,10 +2961,8 @@ __mem_cgroup_uncharge_common(struct page
>  				goto unlock_out;
>  		} else if (page_mapped(page)) /* Anon */
>  				goto unlock_out;
> -		anon = true;
>  		break;
>  	default:
> -		anon = false;
>  		break;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

