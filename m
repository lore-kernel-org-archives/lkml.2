Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0GLPY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:24:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:40518 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0GLPY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,188,1278313200"; 
   d="scan'208";a="817226906"
Date: Mon, 12 Jul 2010 23:24:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Myklebust Trond <Trond.Myklebust@netapp.com>,
        "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
        Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 31/45] writeback: sync old inodes first in background
 writeback
Message-ID: <20100712152417.GA30222@localhost>
References: <20091007073818.318088777@intel.com>
 <20091007074905.131727024@intel.com>
 <20100712030129.GA22769@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712030129.GA22769@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 11:01:29AM +0800, Christoph Hellwig wrote:
> On Wed, Oct 07, 2009 at 03:38:49PM +0800, Wu Fengguang wrote:
> > A background flush work may run for ever. So it's reasonable for it to
> > mimic the kupdate behavior of syncing old/expired inodes first.
> 
> I've looked at this a bit again after you pointed to this thread in
> the direct reclaim thread, and I think we should be even more aggressive
> in pushing out old inodes.

Agreed.

> We basically have two types of I/O done from wb_do_writeback:
> 
>  - either we want to write all inodes for a given bdi/superblock.  That
>    includes all WB_SYNC_ALL callers, but also things like
>    writeback_inodes_sb and the wakeup_flusher_threads call from
>    sys_sync.
>  - or we have a specific goal, like for the background writeback or
>    the wakeup_flusher_threads from free_more_memory.
> 
> For the first case there's obviously no point in doing any
> older_than_this processing as we write out all inodes anyway.

We may also do older_than_this even for the sync-the-whole-world case,
as long as this simplifies wb_writeback() and/or other code. This may
make a difference for slow devices.

> For the second case we should always do a older_than_this pass _first_.

Agree in general.

> Rationale: we really should get the old inodes out ASAP, so that we
> keep the amount of changes lost on a crash in the boundaries.
> Furthermore the callers only need N pages cleaned, and they don't care
> where from.  So if we can reach our goal with the older_than_this
> writeback we're fine.  If the writeback loop is long enough we can
> keep doing more of these later on as well.

Right.

> Doing this should also help cleaning the code up a bit by moving the
> wb_check_old_data_flush logic into wb_writeback and getting rid of the
> for_kupdate paramter in struct wb_writeback_work.  I'm not even sure
> it's worth keeping it in struct writeback_control.

I'd also like to see less for_kupdate tests. Whether or not we can
totally get rid of the explicit for_kupdate case, there are always
four main writeback goals/semantics:
- periodic      stop when all 30s-old inodes are written
- background    stop when background threshold is reached
- nr_pages      stop when nr_pages written (or when all clean)
- sync          stop when all older-than-sync-time inodes are written

Note that
- the "sync" goal is obviously a superset of the "periodic" goal
- the "background" goal may be expanded to include the "periodic" goal
- the latter three goals may all do some "periodic" goal loops, with
  a moving "old" criterion.

Thanks,
Fengguang
