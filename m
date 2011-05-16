Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1EPFju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 01:39:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:60754 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1EPFjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 01:39:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="2122656"
Date: Mon, 16 May 2011 13:39:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] writeback: introduce .tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110516053946.GA10776@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140030.759385136@intel.com>
 <20110512224013.GH19446@dastard>
 <20110513025607.GA8016@localhost>
 <20110515234306.GO19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515234306.GO19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 07:43:06AM +0800, Dave Chinner wrote:
> On Fri, May 13, 2011 at 10:56:08AM +0800, Wu Fengguang wrote:
> > On Fri, May 13, 2011 at 06:40:13AM +0800, Dave Chinner wrote:
> > > On Thu, May 12, 2011 at 09:57:07PM +0800, Wu Fengguang wrote:
> > > > sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> > > > WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> > > > livelock prevention for it, too.
> > > > 
> > > > Note that writeback_inodes_sb() is called by not only sync(), they are
> > > > treated the same because the other callers also need livelock prevention.
> > > > 
> > > > Impact:  It changes the order in which pages/inodes are synced to disk.
> > > > Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
> > > > until finished with the current inode.
> > > 
> > > What about all the filesystems that implement their own
> > > .writepages()/write_cache_pages() functions or have
> > > have special code that checks WB_SYNC_ALL in .writepages (e.g. gfs2,
> > > ext4, btrfs and perhaps others). Don't they all need to be aware of
> > > this tagged_sync field?
> > 
> > Right, good point. Currently only ext4 is updated. The other
> > filesystems --- afs, btrfs, cifs, gfs2 --- do not even use
> > PAGECACHE_TAG_TOWRITE for livelock prevention. My plan was to add
> > PAGECACHE_TAG_TOWRITE and tagged_sync code to them as the next step,
> > when tagged_sync is accepted and proved to work fine.
> 
> Where "proved to work fine" can mean "caused regressions for certain
> filesystems"? I mean, for btrfs it means that the bio is submitted
> with WRITE rather than WRITE_SYNC, which causes subtle changes of
> behaviour in the elevator. that could cause strange regressions that
> are very hard to isolate.

Hmm, where is the relevant btrfs code? It seems that you assumed
WB_SYNC_ALL semantics in .tagged_sync, however the latter merely means
"tag all dirty pages with PAGECACHE_TAG_TOWRITE and write them out".

> Hence regardless of whether filesystems use PAGECACHE_TAG_TOWRITE
> or not, filesystems are checking for synchronous writeback for
> a reason. If we now have two different ways of signalling sync
> writeback they need to know about them.

See above, shall we rename .tagged_sync to .tagged_write?

> Which just raised the question in my mind - why did you add a new
> field rather than a new sync_mode definition? After all, this is a
> new sync control, and it seems clumsy to me to have two separate
> control fields for defining sync behaviour...

Yeah I considered that too. The main problem is, it somehow overloads
the sync mode enum and some filesystems already assumed two modes only
by using (sync_mode == WB_SYNC_ALL) and (sync_mode != WB_SYNC_NONE)
interchangeably.

For example, if adding another mode

        WB_SYNC_NONE            // WRITE, don't wait
+       WB_SYNC_NONE_TAGGED     // WRITE, don't wait, use PAGECACHE_TAG_TOWRITE
        WB_SYNC_ALL             // WRITE_SYNC,  wait, use PAGECACHE_TAG_TOWRITE

The btrfs code will unnecessarily wait on WB_SYNC_NONE_TAGGED:

                        if (wbc->sync_mode != WB_SYNC_NONE) {
                                if (PageWriteback(page))
                                        flush_fn(data);
                                wait_on_page_writeback(page);
                        }

We can fix btrfs trivially, however if there are out of tree
filesystems, they'll break silently..

Thanks,
Fengguang
