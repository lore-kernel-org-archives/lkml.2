Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1A1Ez3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:55:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51487 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab1A1Ez2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:55:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 13:49:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 1/4] memcg: fix limit estimation at reclaim for
 hugepage
Message-Id: <20110128134902.5845b507.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128134019.27abcfe2.nishimura@mxp.nes.nec.co.jp>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122449.e4bb0e5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128134019.27abcfe2.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 13:40:19 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 28 Jan 2011 12:24:49 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Current memory cgroup's code tends to assume page_size == PAGE_SIZE
> > and arrangement for THP is not enough yet.
> > 
> > This is one of fixes for supporing THP. This adds
> > mem_cgroup_check_margin() and checks whether there are required amount of
> > free resource after memory reclaim. By this, THP page allocation
> > can know whether it really succeeded or not and avoid infinite-loop
> > and hangup.
> > 
> > Total fixes for do_charge()/reclaim memory will follow this patch.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch looks good to me, but some nitpicks.
> 
> > ---
> >  include/linux/res_counter.h |   11 +++++++++++
> >  mm/memcontrol.c             |   25 ++++++++++++++++++++++++-
> >  2 files changed, 35 insertions(+), 1 deletion(-)
> > 
> > Index: mmotm-0125/include/linux/res_counter.h
> > ===================================================================
> > --- mmotm-0125.orig/include/linux/res_counter.h
> > +++ mmotm-0125/include/linux/res_counter.h
> > @@ -182,6 +182,17 @@ static inline bool res_counter_check_und
> >  	return ret;
> >  }
> >  
> > +static inline s64 res_counter_check_margin(struct res_counter *cnt)
> > +{
> > +	s64 ret;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&cnt->lock, flags);
> > +	ret = cnt->limit - cnt->usage;
> > +	spin_unlock_irqrestore(&cnt->lock, flags);
> > +	return ret;
> > +}
> > +
> >  static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
> >  {
> >  	bool ret;
> > Index: mmotm-0125/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0125.orig/mm/memcontrol.c
> > +++ mmotm-0125/mm/memcontrol.c
> > @@ -1111,6 +1111,22 @@ static bool mem_cgroup_check_under_limit
> >  	return false;
> >  }
> >  
> > +static s64  mem_cgroup_check_margin(struct mem_cgroup *mem)
> > +{
> > +	s64 mem_margin;
> > +
> > +	if (do_swap_account) {
> > +		s64 memsw_margin;
> > +
> > +		mem_margin = res_counter_check_margin(&mem->res);
> > +		memsw_margin = res_counter_check_margin(&mem->memsw);
> > +		if (mem_margin > memsw_margin)
> > +			mem_margin = memsw_margin;
> > +	} else
> > +		mem_margin = res_counter_check_margin(&mem->res);
> > +	return mem_margin;
> > +}
> > +
> How about
> 
> 	mem_margin = res_counter_check_margin(&mem->res);
> 	if (do_swap_account)
> 		memsw_margin = res_counter_check_margin(&mem->memsw);
> 	else
> 		memsw_margin = RESOURCE_MAX;
> 
> 	return min(mem_margin, memsw_margin);
> 
> ?
> I think using min() makes it more clear what this function does.
> 

Ok.

> >  static unsigned int get_swappiness(struct mem_cgroup *memcg)
> >  {
> >  	struct cgroup *cgrp = memcg->css.cgroup;
> > @@ -1853,7 +1869,14 @@ static int __mem_cgroup_do_charge(struct
> >  	 * Check the limit again to see if the reclaim reduced the
> >  	 * current usage of the cgroup before giving up
> >  	 */
> > -	if (ret || mem_cgroup_check_under_limit(mem_over_limit))
> > +	if (mem_cgroup_check_margin(mem_over_limit) >= csize)
> > +		return CHARGE_RETRY;
> > +
> > +	/*
> > + 	 * If the charge size is a PAGE_SIZE, it's not hopeless while
> > + 	 * we can reclaim a page.
> > + 	 */
> > +	if (csize == PAGE_SIZE && ret)
> >  		return CHARGE_RETRY;
> >  
> >  	/*
> > 
> checkpatch complains some whitespace warnings.
> 
will fix soon.

-Kame

