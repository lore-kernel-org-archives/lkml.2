Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1IIBoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:44:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47403 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab1IIBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:44:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Sep 2011 10:43:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, minchan.kim@gmail.com,
        nishimura@mxp.nes.nec.co.jp, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: add replace_page_cache_page() function
Message-Id: <20110909104337.e5a1a492.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110908165222.18875260.akpm@linux-foundation.org>
References: <E1Pf9Zj-0002td-Ct@pomaz-ex.szeredi.hu>
	<20110118152844.88cfdc2c.akpm@linux-foundation.org>
	<20110908165222.18875260.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 16:52:22 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 18 Jan 2011 15:28:44 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 18 Jan 2011 12:18:11 +0100
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> > > +{
> > > +	int error;
> > > +	struct mem_cgroup *memcg = NULL;
> > 
> > I'm suspecting that the unneeded initialisation was added to suppress a
> > warning?
> > 
> > I removed it, and didn't get a warning.  I expected to.
> > 
> > Really, uninitialized_var() is better.  It avoids adding extra code
> > and, unlike "= 0" it is self-documenting.
> > 
> > > +	VM_BUG_ON(!PageLocked(old));
> > > +	VM_BUG_ON(!PageLocked(new));
> > > +	VM_BUG_ON(new->mapping);
> > > +
> > > +	/*
> > > +	 * This is not page migration, but prepare_migration and
> > > +	 * end_migration does enough work for charge replacement.
> > > +	 *
> > > +	 * In the longer term we probably want a specialized function
> > > +	 * for moving the charge from old to new in a more efficient
> > > +	 * manner.
> > > +	 */
> > > +	error = mem_cgroup_prepare_migration(old, new, &memcg, gfp_mask);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> > > +	if (!error) {
> > > +		struct address_space *mapping = old->mapping;
> > > +		pgoff_t offset = old->index;
> > > +
> > > +		page_cache_get(new);
> > > +		new->mapping = mapping;
> > > +		new->index = offset;
> > > +
> > > +		spin_lock_irq(&mapping->tree_lock);
> > > +		__remove_from_page_cache(old);
> > > +		error = radix_tree_insert(&mapping->page_tree, offset, new);
> > > +		BUG_ON(error);
> > > +		mapping->nrpages++;
> > > +		__inc_zone_page_state(new, NR_FILE_PAGES);
> > > +		if (PageSwapBacked(new))
> > > +			__inc_zone_page_state(new, NR_SHMEM);
> > > +		spin_unlock_irq(&mapping->tree_lock);
> > > +		radix_tree_preload_end();
> > > +		page_cache_release(old);
> > > +		mem_cgroup_end_migration(memcg, old, new, true);
> > 
> > This is all pretty ugly and inefficient.
> > 
> > We call __remove_from_page_cache() which does a radix-tree lookup and
> > then fiddles a bunch of accounting things.
> > 
> > Then we immediately do the same radix-tree lookup and then undo the
> > accounting changes which we just did.  And we do it in an open-coded
> > fashion, thus giving the kernel yet another code site where various
> > operations need to be kept in sync.
> > 
> > Would it not be better to do a single radix_tree_lookup_slot(),
> > overwrite the pointer therein and just leave all the ancilliary
> > accounting unaltered?
> > 
> 
> Poke?

Sorry, I didn't read this mail.

The codes around __remove_from_page_cache and radix_tree_insert,
I agree you. 

About counters, the page may be in different zone and related statistics
should be changed. About memcg, this function does page replacement. 
Then, information in old page_cgroup should be moved to the new
page_cgroup. So, I advised to use migration code which is used
in many situation(now) rather than adding new something strange.

Hmm, in quick thinking, we can reuse migration function core
rather than using this new one ? Hmm..but page_count() check
may fail....

Thanks,
-Kame














