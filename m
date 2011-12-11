Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1LKXjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 18:39:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54603 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1LKXjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 18:39:48 -0500
Date: Sun, 11 Dec 2011 15:39:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly
To: Hillf Danton <dhillf@gmail.com>
cc: Balbir Singh <bsingharora@gmail.com>, David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg: keep root group unchanged if fail to create
 new
In-Reply-To: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1112111520510.2297@eggly>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Dec 2011, Hillf Danton wrote:

> If the request is not to create root group and we fail to meet it,
> we'd leave the root unchanged.

I didn't understand that at first: please say "we should" rather
than "we'd", which I take to be an abbreviation for "we would".

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Yes indeed, well caught:
Acked-by: Hugh Dickins <hughd@google.com>

I wonder what was going through the author's mind when he wrote it
that way?  I wonder if it's one of those bugs that creeps in when
you start from a perfectly functional patch, then make refinements
to suit feedback from reviewers.

On which topic: wouldn't this patch be better just to move the
"root_mem_cgroup = memcg;" two lines lower down (and of course
remove free_out's "root_mem_cgroup = NULL;" as you already did)?
I can't see mem_cgroup_soft_limit_tree_init() relying on
root_mem_cgroup at all.

Should your patch go to stable, even to 2.6.32-longterm?
Matter of taste, really: while it's not quite impossible for
alloc_mem_cgroup_per_zone_info() to fail, it is very unlikely.

> ---
> 
> --- a/mm/memcontrol.c	Fri Dec  9 21:57:40 2011
> +++ b/mm/memcontrol.c	Sun Dec 11 09:04:48 2011
> @@ -4849,8 +4849,10 @@ mem_cgroup_create(struct cgroup_subsys *
>  		enable_swap_cgroup();
>  		parent = NULL;
>  		root_mem_cgroup = memcg;
> -		if (mem_cgroup_soft_limit_tree_init())
> +		if (mem_cgroup_soft_limit_tree_init()) {
> +			root_mem_cgroup = NULL;
>  			goto free_out;
> +		}
>  		for_each_possible_cpu(cpu) {
>  			struct memcg_stock_pcp *stock =
>  						&per_cpu(memcg_stock, cpu);
> @@ -4888,7 +4890,6 @@ mem_cgroup_create(struct cgroup_subsys *
>  	return &memcg->css;
>  free_out:
>  	__mem_cgroup_free(memcg);
> -	root_mem_cgroup = NULL;
>  	return ERR_PTR(error);
>  }
> 
