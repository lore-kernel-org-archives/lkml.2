Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab1ATNlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:41:19 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42896 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab1ATNlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:41:16 -0500
Date: Thu, 20 Jan 2011 14:41:08 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] memcg: fix rmdir, force_empty with THP
Message-ID: <20110120134108.GO2232@cmpxchg.org>
References: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
 <20110118114348.9e1dba9b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118114348.9e1dba9b.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 11:43:48AM +0900, KAMEZAWA Hiroyuki wrote:
> 
> Now, when THP is enabled, memcg's rmdir() function is broken
> because move_account() for THP page is not supported.
> 
> This will cause account leak or -EBUSY issue at rmdir().
> This patch fixes the issue by supporting move_account() THP pages.
> 
> Changelog:
>  - style fix.
>  - add compound_lock for avoiding races.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> Index: mmotm-0107/mm/memcontrol.c
> ===================================================================
> --- mmotm-0107.orig/mm/memcontrol.c
> +++ mmotm-0107/mm/memcontrol.c

> @@ -2267,6 +2274,8 @@ static int mem_cgroup_move_parent(struct
>  	struct cgroup *cg = child->css.cgroup;
>  	struct cgroup *pcg = cg->parent;
>  	struct mem_cgroup *parent;
> +	int charge = PAGE_SIZE;

No need to initialize, you assign it unconditionally below.

It's also a bit unfortunate that the parameter/variable with this
meaning appears under a whole bunch of different names.  page_size,
charge_size, and now charge.  Could you stick with page_size?

> @@ -2278,17 +2287,23 @@ static int mem_cgroup_move_parent(struct
>  		goto out;
>  	if (isolate_lru_page(page))
>  		goto put;
> +	/* The page is isolated from LRU and we have no race with splitting */
> +	charge = PAGE_SIZE << compound_order(page);

Why is LRU isolation preventing the splitting?

I think we need the compound lock to get a stable read, like
compound_trans_order() does.

	Hannes

>  	parent = mem_cgroup_from_cont(pcg);
> -	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false,
> -				      PAGE_SIZE);
> +	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
>  	if (ret || !parent)
>  		goto put_back;
>  
> -	ret = mem_cgroup_move_account(pc, child, parent, true);
> +	if (charge > PAGE_SIZE)
> +		flags = compound_lock_irqsave(page);
> +
> +	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
>  	if (ret)
> -		mem_cgroup_cancel_charge(parent, PAGE_SIZE);
> +		mem_cgroup_cancel_charge(parent, charge);
>  put_back:
> +	if (charge > PAGE_SIZE)
> +		compound_unlock_irqrestore(page, flags);
>  	putback_lru_page(page);
>  put:
>  	put_page(page);
