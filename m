Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0DOCb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 22:31:56 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52958 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0DOCbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 22:31:55 -0400
Date: Thu, 15 Apr 2010 11:22:49 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][BUGFIX][PATCH] memcg: fix underflow of mapped_file stat
Message-Id: <20100415112249.c02c12ba.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100414144015.0a0d2bd2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
	<20100413151400.cb89beb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414095408.d7b352f1.nishimura@mxp.nes.nec.co.jp>
	<20100414100308.693c5650.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414104010.7a359d04.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414105608.d40c70ab.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414120622.0a5c2983.kamezawa.hiroyu@jp.fujitsu.com>
	<20100414143132.179edc6e.nishimura@mxp.nes.nec.co.jp>
	<20100414144015.0a0d2bd2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -2517,65 +2519,70 @@ int mem_cgroup_prepare_migration(struct 
> > >  		css_get(&mem->css);
> > >  	}
> > >  	unlock_page_cgroup(pc);
> > > -
> > > -	if (mem) {
> > > -		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
> > > -		css_put(&mem->css);
> > > -	}
> > > -	*ptr = mem;
> > > +	/*
> > > +	 * If the page is uncharged before migration (removed from radix-tree)
> > > +	 * we return here.
> > > +	 */
> > > +	if (!mem)
> > > +		return 0;
> > > +	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
> > > +	css_put(&mem->css); /* drop extra refcnt */
> > it should be:
> > 
> > 	*ptr = mem;
> > 	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false);
> > 	css_put(&mem->css);
> > 
> > as Andrea has fixed already.
> > 
> Ah, yes. I'll rebase this onto Andrea's fix.
> 
> 
> 
> > > +	if (ret)
We should check "if (ret || !*ptr)" not to do commit in !*ptr case.

> > > + 	 * Considering ANON pages, we can't depend on lock_page.
> > > + 	 * If a page may be unmapped before it's remapped, new page's
> > > + 	 * mapcount will not increase. (case that mapcount 0->1 never occur.)
> > > + 	 * PageCgroupUsed() and SwapCache checks will be done.
> > > + 	 *
> > > + 	 * Once mapcount goes to 1, our hook to page_remove_rmap will do
> > > + 	 * enough jobs.
> > > + 	 */
> > > +	if (PageAnon(used) && !page_mapped(used))
> > > +		mem_cgroup_uncharge_page(used);
> > mem_cgroup_uncharge_page() does the same check :)
> > 
> Ok. I'll fix.
> 
Considering more, we'd better to check PageAnon() at least not to call
mem_cgroup_uncharge_page() for cache page.


Thanks,
Daisuke Nishimura.
