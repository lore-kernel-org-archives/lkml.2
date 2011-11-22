Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1KVN7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:59:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:11025 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab1KVN7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:59:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,552,1315206000"; 
   d="scan'208";a="77962593"
Date: Tue, 22 Nov 2011 21:59:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 4/5] writeback: fix dirtied pages accounting on redirty
Message-ID: <20111122135919.GB10545@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131216.032489128@intel.com>
 <20111121135146.0fc7e3a7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121135146.0fc7e3a7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 05:51:46AM +0800, Andrew Morton wrote:
> On Mon, 21 Nov 2011 21:03:46 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > De-account the accumulative dirty counters on page redirty.
> > 
> > Page redirties (very common in ext4) will introduce mismatch between
> > counters (a) and (b)
> > 
> > a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
> > b) NR_WRITTEN, BDI_WRITTEN
> > 
> > This will introduce systematic errors in balanced_rate and result in
> > dirty page position errors (ie. the dirty pages are no longer balanced
> > around the global/bdi setpoints).
> > 
> > ...
> >
> > --- linux-next.orig/mm/page-writeback.c	2011-11-17 20:57:15.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2011-11-17 20:57:16.000000000 +0800
> > @@ -1792,6 +1792,17 @@ int __set_page_dirty_nobuffers(struct pa
> >  }
> >  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
> >  
> > +void account_page_redirty(struct page *page)
> > +{
> > +	struct address_space *mapping = page->mapping;
> > +	if (mapping && mapping_cap_account_dirty(mapping)) {
> > +		current->nr_dirtied--;
> > +		dec_zone_page_state(page, NR_DIRTIED);
> > +		dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
> > +	}
> > +}
> 
> Again, writeback doesn't seem to be the best place to be adding
> undocumented code.

Sorry, hope this comment can explain when to call the function and why.

/*
 * Call this whenever redirtying a page, to de-account the dirty counters
 * (NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied), so that they match the written
 * counters (NR_WRITTEN, BDI_WRITTEN) in long term. The mismatches will lead to
 * systematic errors in balanced_dirty_ratelimit and the dirty pages position
 * control.
 */

> > +EXPORT_SYMBOL(account_page_redirty);
> 
> The export is unneeded?

btrfs will need to call into it. Here is the patch.  I'll include it
in the v2 series.

Thanks,
Fengguang
---

Subject: btrfs: fix dirtied pages accounting on sub-page writes
Date: Mon Aug 08 15:19:47 CST 2011

When doing 1KB sequential writes to the same page,
balance_dirty_pages_ratelimited_nr() should be called once instead of 4
times, the latter makes the dirtier tasks be throttled much too heavy.

Fix it with proper de-accounting on clear_page_dirty_for_io().

CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next.orig/fs/btrfs/file.c	2011-11-17 20:13:47.000000000 +0800
+++ linux-next/fs/btrfs/file.c	2011-11-17 20:18:51.000000000 +0800
@@ -1136,7 +1136,8 @@ again:
 				     GFP_NOFS);
 	}
 	for (i = 0; i < num_pages; i++) {
-		clear_page_dirty_for_io(pages[i]);
+		if (clear_page_dirty_for_io(pages[i]))
+			account_page_redirty(pages[i]);
 		set_page_extent_mapped(pages[i]);
 		WARN_ON(!PageLocked(pages[i]));
 	}
