Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1LSLF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:05:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1LSLF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:05:56 -0500
Date: Mon, 19 Dec 2011 11:05:51 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/11] mm: compaction: Determine if dirty pages can be
 migrated without blocking within ->migratepage
Message-ID: <20111219110551.GJ3487@suse.de>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de>
 <1323877293-15401-6-git-send-email-mgorman@suse.de>
 <20111216152054.f7445e98.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111216152054.f7445e98.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 03:20:54PM -0800, Andrew Morton wrote:
> On Wed, 14 Dec 2011 15:41:27 +0000
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > Asynchronous compaction is used when allocating transparent hugepages
> > to avoid blocking for long periods of time. Due to reports of
> > stalling, there was a debate on disabling synchronous compaction
> > but this severely impacted allocation success rates. Part of the
> > reason was that many dirty pages are skipped in asynchronous compaction
> > by the following check;
> > 
> > 	if (PageDirty(page) && !sync &&
> > 		mapping->a_ops->migratepage != migrate_page)
> > 			rc = -EBUSY;
> > 
> > This skips over all mapping aops using buffer_migrate_page()
> > even though it is possible to migrate some of these pages without
> > blocking. This patch updates the ->migratepage callback with a "sync"
> > parameter. It is the responsibility of the callback to fail gracefully
> > if migration would block.
> > 
> > ...
> >
> > @@ -259,6 +309,19 @@ static int migrate_page_move_mapping(struct address_space *mapping,
> >  	}
> >  
> >  	/*
> > +	 * In the async migration case of moving a page with buffers, lock the
> > +	 * buffers using trylock before the mapping is moved. If the mapping
> > +	 * was moved, we later failed to lock the buffers and could not move
> > +	 * the mapping back due to an elevated page count, we would have to
> > +	 * block waiting on other references to be dropped.
> > +	 */
> > +	if (!sync && head && !buffer_migrate_lock_buffers(head, sync)) {
> 
> Once it has been established that "sync" is true, I find it clearer to
> pass in plain old "true" to buffer_migrate_lock_buffers().  Minor point.
> 

Later in the series, sync changes to "mode" to distinguish between
async, sync-light and sync compaction. At that point, this becomes

        if (mode == MIGRATE_ASYNC && head &&
                        !buffer_migrate_lock_buffers(head, mode)) {

Passing true in here would be fine, but it would just end up being
changed back later in the series so it can be left alone.

> I hadn't paid a lot of attention to buffer_migrate_page() before. 
> Scary function.  I'm rather worried about its interactions with ext3
> journal commit which locks buffers then plays with them while leaving
> the page unlocked.  How vigorously has this been whitebox-tested?
> 

Blackbox testing only AFAIK. This has been tested recently with ext3
and nothing unusual was reported. The list of events for migration
looks like

isolate page from LRU
  migrate_pages
    unmap_and_move
      lock_page(src_page)
      if page under writeback, either bail or wait on writeback
      try_to_unmap
      move_to_new_page
      lock_page(dst_page)
      buffer_migrate_page
        migrate_page_move_mapping
          spin_lock_irq(&mapping->tree_lock)
          lookup in radix tree
          check reference counts to make sure no one else has references
          lock buffers if async mode
          replace page in radix tree with new page
          spin_unlock_irq
        lock buffers if !async mode
        copy buffers
        unlock buffers
      unlock_page(dst_page)

The critical part is that the copying of buffer data is happening with
both page and buffer locks held and no other references to the page
exists - it has already been unmapped for example.

Journal commit minimally acquires the buffer lock. If migration is
in the process of copying the buffers, the buffer lock will prevent
journal commit starting at the same time buffers are being copied.

block_write_full_page and friends should be taking the buffer lock so
they should also be ok.

For other accessors, the mapping tree_lock should prevent other users
looking up the page in the radix tree in the first place while the radix
tree replacement is taking place.

Racing against try_to_free_buffer should also be a problem.
According to buffer.c, exclusion from try_to_free_buffer "may
be obtained by either locking the page or holding the mappings
private_lock". Migration is holding the page lock.

Taking private_lock would give additional protection but I haven't heard
or seen a case where it is necessary.

-- 
Mel Gorman
SUSE Labs
