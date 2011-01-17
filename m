Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1AQAbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 19:31:35 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52816 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1AQAbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 19:31:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 17 Jan 2011 09:25:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>, hannes@cmpxchg.org,
        aarcange@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] [BUGFIX] fix account leak at force_empty, rmdir
 with THP
Message-Id: <20110117092529.0708bc97.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110117091533.7fe2d819.nishimura@mxp.nes.nec.co.jp>
References: <20110114190412.73362cd7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110114191535.309b634c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110117091533.7fe2d819.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011 09:15:33 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi, thank you for your great works!
> 
> I've not read this series in detail, but one quick comment for move_parent.
> 
> > @@ -2245,6 +2253,7 @@ static int mem_cgroup_move_parent(struct
> >  	struct cgroup *cg = child->css.cgroup;
> >  	struct cgroup *pcg = cg->parent;
> >  	struct mem_cgroup *parent;
> > +	int charge_size = PAGE_SIZE;
> >  	int ret;
> >  
> >  	/* Is ROOT ? */
> > @@ -2256,16 +2265,19 @@ static int mem_cgroup_move_parent(struct
> >  		goto out;
> >  	if (isolate_lru_page(page))
> >  		goto put;
> > +	/* The page is isolated from LRU and we have no race with splitting */
> > +	if (PageTransHuge(page))
> > +		charge_size = PAGE_SIZE << compound_order(page);
> >  
> >  	parent = mem_cgroup_from_cont(pcg);
> >  	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false,
> > -				      PAGE_SIZE);
> > +				      charge_size);
> >  	if (ret || !parent)
> >  		goto put_back;
> >  
> > -	ret = mem_cgroup_move_account(pc, child, parent, true);
> > +	ret = mem_cgroup_move_account(pc, child, parent, true, charge_size);
> >  	if (ret)
> > -		mem_cgroup_cancel_charge(parent, PAGE_SIZE);
> > +		mem_cgroup_cancel_charge(parent, charge_size);
> >  put_back:
> >  	putback_lru_page(page);
> >  put:
> I think there is possibility that the page is split after "if (PageTransHuge(page))".
> 
> In RHEL6, this part looks like:
> 
>    1598         if (PageTransHuge(page))
>    1599                 page_size = PAGE_SIZE << compound_order(page);
>    1600
>    1601         ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, page,
>    1602                                       page_size);
>    1603         if (ret || !parent)
>    1604                 return ret;
>    1605
>    1606         if (!get_page_unless_zero(page)) {
>    1607                 ret = -EBUSY;
>    1608                 goto uncharge;
>    1609         }
>    1610
>    1611         ret = isolate_lru_page(page);
>    1612
>    1613         if (ret)
>    1614                 goto cancel;
>    1615
>    1616         compound_lock_irqsave(page, &flags);
>    1617         ret = mem_cgroup_move_account(pc, child, parent, page_size);
>    1618         compound_unlock_irqrestore(page, flags);
>    1619
> 
> In fact, I found a bug of res_counter underflow around here, and I've already send
> a patch to RedHat.
> 

Okay, I'll take care of that in the next version.

Thanks,
-Kame


> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> In mem_cgroup_move_parent(), the page can be split by other context after we
> check PageTransHuge() and before hold the compound_lock of the page later.
> 
> This means a race can happen like:
> 
> 	__split_huge_page_refcount()		mem_cgroup_move_parent()
>     ---------------------------------------------------------------------------
> 						if (PageTransHuge())
> 						-> true
> 						-> set "page_size" to huge page
> 						   size.
> 						__mem_cgroup_try_charge()
> 						-> charge "page_size" to the
> 						   parent.
> 	compound_lock()
> 	mem_cgroup_split_hugepage_commit()
> 	-> commit all the tail pages to the
> 	   "current"(i.e. child) cgroup.
> 	   iow, pc->mem_cgroup of tail pages
> 	   point to the child.
> 	ClearPageCompound()
> 	compound_unlock()
> 						compound_lock()
> 						mem_cgroup_move_account()
> 						-> make pc->mem_cgroup of the
> 						   head page point to the parent.
> 						-> uncharge "page_size" from
> 						   the child.
> 						compound_unlock()
> 
> This can causes at least 2 problems.
> 
> 1. Tail pages are linked to LRU of the child, even though usages(res_counter) of
>    them have been already uncharged from the chilid. This causes res_counter
>    underflow at removing the child directory.
> 2. Usage of the parent is increased by the huge page size at moving charge of
>    the head page, but usage will be decreased only by the normal page size when
>    the head page is uncharged later because it is not PageTransHuge() anymore.
>    This means the parent doesn't have enough pages on its LRU to decrease the
>    usage to 0 and it cannot be rmdir'ed.
> 
> This patch fixes this problem by re-checking PageTransHuge() again under the
> compound_lock.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> diff -uprN linux-2.6.32.x86_64.org/mm/memcontrol.c linux-2.6.32.x86_64/mm/memcontrol.c
> --- linux-2.6.32.x86_64.org/mm/memcontrol.c	2010-07-15 16:44:57.000000000 +0900
> +++ linux-2.6.32.x86_64/mm/memcontrol.c	2010-07-15 17:34:12.000000000 +0900
> @@ -1608,6 +1608,17 @@ static int mem_cgroup_move_parent(struct
>  		goto cancel;
>  
>  	compound_lock_irqsave(page, &flags);
> +	/* re-check under compound_lock because the page might be split */
> +	if (unlikely(page_size != PAGE_SIZE && !PageTransHuge(page))) {
> +		unsigned long extra = page_size - PAGE_SIZE;
> +		/* uncharge extra charges from parent */
> +		if (!mem_cgroup_is_root(parent)) {
> +			res_counter_uncharge(&parent->res, extra);
> +			if (do_swap_account)
> +				res_counter_uncharge(&parent->memsw, extra);
> +		}
> +		page_size = PAGE_SIZE;
> +	}
>  	ret = mem_cgroup_move_account(pc, child, parent, page_size);
>  	compound_unlock_irqrestore(page, flags);
>  
> 

