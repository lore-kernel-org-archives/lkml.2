Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2ASX5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:57:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42575 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2ASX5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:57:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Jan 2012 08:55:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH] memcg: remove PCG_CACHE page_cgroup flag
Message-Id: <20120120085542.8056b4d3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120119133035.GO24386@cmpxchg.org>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
	<20120119133035.GO24386@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012 14:30:35 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Thu, Jan 19, 2012 at 06:17:11PM +0900, KAMEZAWA Hiroyuki wrote:
> > @@ -4,7 +4,6 @@
> >  enum {
> >  	/* flags for mem_cgroup */
> >  	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
> > -	PCG_CACHE, /* charged as cache */
> >  	PCG_USED, /* this object is in use. */
> >  	PCG_MIGRATION, /* under page migration */
> >  	/* flags for mem_cgroup and file and I/O status */
> 
> Me gusta.
> 
> > @@ -606,11 +606,16 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
> >  }
> >  
> >  static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
> > -					 bool file, int nr_pages)
> > +					 bool not_rss, int nr_pages)
> >  {
> >  	preempt_disable();
> >  
> > -	if (file)
> > +	/*
> > +	 * Here, RSS means 'mapped anon' and anon's SwapCache. Unlike LRU,
> > +	 * Shmem is not included to Anon. It' counted as 'file cache'
> > +	 * which tends to be shared between memcgs.
> > +	 */
> > +	if (not_rss)
> 
> Could you invert that boolean and call it "anon"?
> 

Sure. I wondered whta name is good other than 'file'.


> > @@ -2343,6 +2348,8 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
> >  				       struct page_cgroup *pc,
> >  				       enum charge_type ctype)
> >  {
> > +	bool not_rss;
> > +
> >  	lock_page_cgroup(pc);
> >  	if (unlikely(PageCgroupUsed(pc))) {
> >  		unlock_page_cgroup(pc);
> > @@ -2362,21 +2369,15 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
> >  	 * See mem_cgroup_add_lru_list(), etc.
> >   	 */
> >  	smp_wmb();
> > -	switch (ctype) {
> > -	case MEM_CGROUP_CHARGE_TYPE_CACHE:
> > -	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
> > -		SetPageCgroupCache(pc);
> > -		SetPageCgroupUsed(pc);
> > -		break;
> > -	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> > -		ClearPageCgroupCache(pc);
> > -		SetPageCgroupUsed(pc);
> > -		break;
> > -	default:
> > -		break;
> > -	}
> >  
> > -	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
> > +	SetPageCgroupUsed(pc);
> > +	if ((ctype == MEM_CGROUP_CHARGE_TYPE_CACHE) ||
> > +	    (ctype == MEM_CGROUP_CHARGE_TYPE_SHMEM))
> > +		not_rss = true;
> > +	else
> > +		not_rss = false;
> > +
> > +	mem_cgroup_charge_statistics(memcg, not_rss, nr_pages);
> 
> 	mem_cgroup_charge_statistics(memcg,
> 				     ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED,
> 				     nr_pages);
> 
> and save even more lines, without sacrificing clarity! :)
> 
> > @@ -2908,9 +2915,15 @@ void mem_cgroup_uncharge_page(struct page *page)
> >  
> >  void mem_cgroup_uncharge_cache_page(struct page *page)
> >  {
> > +	int ctype;
> > +
> >  	VM_BUG_ON(page_mapped(page));
> >  	VM_BUG_ON(page->mapping);
> > -	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
> > +	if (page_is_file_cache(page))
> > +		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
> > +	else
> > +		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> > +	__mem_cgroup_uncharge_common(page, ctype);
> 
> Looks like an unrelated bugfix on one hand, but on the other hand we
> do not differentiate cache from shmem anywhere, afaik, and you do not
> introduce anything that does.  Could you just leave this out?
> 

Ok. I'll remove.
I inserted this just for clarifying what we do.
will post v3.

Thanks,
-Kame




