Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0DWI1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:27:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50166 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0DWI1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:27:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 23 Apr 2010 17:23:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][BUGFIX][PATCH 2/2] memcg: fix file mapped underflow at
 migration (v3)
Message-Id: <20100423172341.802c2213.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100423170846.d18c88bd.nishimura@mxp.nes.nec.co.jp>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
	<20100415120516.3891ce46.kamezawa.hiroyu@jp.fujitsu.com>
	<20100415120652.c577846f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100416193143.5807d114.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419124225.91f3110b.nishimura@mxp.nes.nec.co.jp>
	<20100419131817.f263d93c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419170701.3864992e.nishimura@mxp.nes.nec.co.jp>
	<20100419172629.dbf65e18.kamezawa.hiroyu@jp.fujitsu.com>
	<20100420132050.3477a717.nishimura@mxp.nes.nec.co.jp>
	<20100420181925.ed881e7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423170846.d18c88bd.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 17:08:46 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> I'm sorry for my late reply.
> 
> On Tue, 20 Apr 2010 18:19:25 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 20 Apr 2010 13:20:50 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > > It will have no meanings for migrating
> > > > file caches, but it may have some meanings for easy debugging. 
> > > > I think "mark it always but it's used only for anonymous page" is reasonable
> > > > (if it causes no bug.)
> > > > 
> > > Anyway, I don't have any strong objection.
> > > It's all right for me as long as it is well documented or commented.
> > > 
> > Okay, before posting as v4, here is draft version.
> > 
> Thank you for adding good comments about what it does and why we need it.
> I like the direction that we set MIGRATION flags only on the old page.
> And this patch looks good to me, except that checkpatch warns some problems
> about indent :)
> 
(--;

I'm sorry that this patch is delayed. I have to fix migration itself
for testing this. I'd like to post this before long holidayes in the next week.

> I have one question.
> 
> >  /* remove redundant charge if migration failed*/
> >  void mem_cgroup_end_migration(struct mem_cgroup *mem,
> > -		struct page *oldpage, struct page *newpage)
> > +	struct page *oldpage, struct page *newpage)
> >  {
> > -	struct page *target, *unused;
> > +	struct page *used, *unused;
> >  	struct page_cgroup *pc;
> > -	enum charge_type ctype;
> >  
> >  	if (!mem)
> >  		return;
> > +	/* blocks rmdir() */
> >  	cgroup_exclude_rmdir(&mem->css);
> >  	/* at migration success, oldpage->mapping is NULL. */
> >  	if (oldpage->mapping) {
> > -		target = oldpage;
> > -		unused = NULL;
> > +		used = oldpage;
> > +		unused = newpage;
> >  	} else {
> > -		target = newpage;
> > +		used = newpage;
> >  		unused = oldpage;
> >  	}
> > -
> > -	if (PageAnon(target))
> > -		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
> > -	else if (page_is_file_cache(target))
> > -		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
> > -	else
> > -		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> > -
> > -	/* unused page is not on radix-tree now. */
> > -	if (unused)
> > -		__mem_cgroup_uncharge_common(unused, ctype);
> > -
> > -	pc = lookup_page_cgroup(target);
> >  	/*
> > -	 * __mem_cgroup_commit_charge() check PCG_USED bit of page_cgroup.
> > -	 * So, double-counting is effectively avoided.
> > +	 * We disallowed uncharge of pages under migration because mapcount
> > +	 * of the page goes down to zero, temporarly.
> > +	 * Clear the flag and check the page should be charged.
> >  	 */
> > -	__mem_cgroup_commit_charge(mem, pc, ctype);
> > -
> > +	pc = lookup_page_cgroup(unused);
> > +	/* This flag itself is not racy, so, check it before lock */
> > +	if (PageCgroupMigration(pc)) {
> > +		lock_page_cgroup(pc);
> > +		ClearPageCgroupMigration(pc);
> > +		unlock_page_cgroup(pc);
> > +	}
> The reason why "This flag itself is not racy" is that we update the flag only
> while the page is isolated ?
yes and no.
It's not racy because a page is only under a migration thread, not under a few of
migration threads. And only the migration thread mark this MIGRATION.

> Then, we doesn't need page_cgroup lock, do we ? PCG_USED bit will avoid
> double-uncharge.
> 
no. there is a chance to update FILE_MAPPED etc..and any other races. I guess.

Thanks,
-Kame

