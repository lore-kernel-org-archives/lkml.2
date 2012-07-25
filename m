Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab2GYTEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:04:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61673 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2GYTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:04:03 -0400
Date: Wed, 25 Jul 2012 21:03:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-ID: <20120725190351.GA4143@gmail.com>
References: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
 <20120725071044.GA27535@gmail.com>
 <20120725073503.GB1112@cmpxchg.org>
 <20120725115713.e56239b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725115713.e56239b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Jul 2012 09:35:03 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > As this is unlikely to reappear in this merge window, the conflict
> > resolution is quite simple.  All that's needed is remove the 3 hunks
> > from my patch that converted a user in Peter's patch to a new API.  I
> > can resend the series if needed, but it's probably easier to just
> > remove the hunks against mm/migrate.c::migrate_misplaced_page():
> > 
> > @@ -1519,10 +1512,9 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
> >  {
> >  	struct page *oldpage = page, *newpage;
> >  	struct address_space *mapping = page_mapping(page);
> > -	struct mem_cgroup *mcg;
> > +	struct mem_cgroup *memcg;
> >  	unsigned int gfp;
> >  	int rc = 0;
> > -	int charge = -ENOMEM;
> >  
> >  	VM_BUG_ON(!PageLocked(page));
> >  	VM_BUG_ON(page_mapcount(page));
> > @@ -1556,12 +1548,7 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
> >  	if (!trylock_page(newpage))
> >  		BUG();		/* new page should be unlocked!!! */
> >  
> > -	// XXX hnaz, is this right?
> > -	charge = mem_cgroup_prepare_migration(page, newpage, &mcg, gfp);
> > -	if (charge == -ENOMEM) {
> > -		rc = charge;
> > -		goto out;
> > -	}
> > +	mem_cgroup_prepare_migration(page, newpage, &memcg);
> >  
> >  	newpage->index = page->index;
> >  	newpage->mapping = page->mapping;
> > @@ -1581,11 +1568,9 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
> >  		page = newpage;
> >  	}
> >  
> > +	mem_cgroup_end_migration(memcg, oldpage, newpage, !rc);
> >  out:
> > -	if (!charge)
> > -		mem_cgroup_end_migration(mcg, oldpage, newpage, !rc);
> > -
> > -       if (oldpage != page)
> > +	if (oldpage != page)
> >                 put_page(oldpage);
> >  
> >  	if (rc) {
> 
> Yes, that worked out OK.
> 
> This means that if the above code reappears in linux-next or 
> mainline, the current copy of 
> mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch 
> will no longer update it, and I probably won't notice that 
> omission.

Did you plan to send Johannes's memcg bits to Linus in this 
merge window? If yes then I'll delay pushing out anything that 
might interfere.

Thanks,

	Ingo
