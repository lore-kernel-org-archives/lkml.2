Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0HCNpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:45:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:46347 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab0HCNpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:45:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,309,1278313200"; 
   d="scan'208";a="592441475"
Date: Tue, 3 Aug 2010 21:44:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/5] writeback: stop periodic/background work on seeing
 sync works
Message-ID: <20100803134431.GA32173@localhost>
References: <20100729115142.102255590@intel.com>
 <20100729121423.332557547@intel.com>
 <20100729162027.GF12690@quack.suse.cz>
 <20100730040306.GA5694@localhost>
 <20100802205152.GL3278@quack.suse.cz>
 <20100803030125.GA12070@localhost>
 <20100803105520.GA3322@quack.suse.cz>
 <20100803123922.GC3322@quack.suse.cz>
 <20100803125924.GA31827@localhost>
 <20100803132216.GA31893@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803132216.GA31893@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 09:22:16PM +0800, Wu Fengguang wrote:
> > >   Fengguang, how about merging also the attached simple patch together with
> > > my fix? With these two patches, I'm not able to trigger any sync livelock
> > > while without one of them I hit them quite easily...
> > 
> > This looks OK. However note that redirty_tail() can modify
> > dirtied_when unexpectedly. So the more we rely on wb_start, the more
> > possibility an inode is (wrongly) skipped by sync. I have a bunch of
> > patches to remove redirty_tail(). However they may not be good
> > candidates for 2.6.36..
> 
> It looks that setting wb_start at the beginning of
> writeback_inodes_wb() won't be easily affected by redirty_tail().

Except for this redirty_tail(), which may mess up the dirtied_when
ordering in b_dirty and later on break the assumption of
inode_dirtied_after(inode, wbc->wb_start).

It can be replaced by a requeue_io() for now.  Christoph mentioned a
patchset to introduce sb->s_wb, which should be a better solution.

Thanks,
Fengguang

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a178828..e56e68b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -457,12 +457,7 @@ int generic_writeback_sb_inodes(struct super_block *sb,
 
 		if (inode->i_sb != sb) {
 			if (only_this_sb) {
-				/*
-				 * We only want to write back data for this
-				 * superblock, move all inodes not belonging
-				 * to it back onto the dirty list.
-				 */
-				redirty_tail(inode);
+				requeue_io(inode);
 				continue;
 			}
 
