Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790Ab0HEWuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:50:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:59833 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591Ab0HEWur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:50:47 -0400
Date: Fri, 6 Aug 2010 00:50:13 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 12/13] writeback: try more writeback as long as
 something was written
Message-ID: <20100805225013.GC17416@quack.suse.cz>
References: <20100805161051.501816677@intel.com>
 <20100805162434.385571675@intel.com>
 <20100805170016.GE3535@quack.suse.cz>
 <20100805223929.GC5586@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805223929.GC5586@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-08-10 06:39:29, Wu Fengguang wrote:
> On Fri, Aug 06, 2010 at 01:00:16AM +0800, Jan Kara wrote:
> > I'm just afraid that in some
> > pathological cases this could result in bad writeback pattern - like if
> > there is some process which manages to dirty just a few pages while we are
> > doing writeout, this looping could result in writing just a few pages in
> > each round which is bad for fragmentation etc.
> 
> Such inodes will be redirty_tail()ed here:
> 
>                 if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>                         /*
>                          * We didn't write back all the pages.  nfs_writepages()
>                          * sometimes bales out without doing anything.
>                          */
>                         inode->i_state |= I_DIRTY_PAGES;
>                         if (wbc->nr_to_write <= 0) {
>                                 /*
>                                  * slice used up: queue for next turn
>                                  */
>                                 requeue_io(inode);
>                         } else {
>                                 /*
>                                  * Writeback blocked by something other than
>                                  * congestion. Delay the inode for some time to
>                                  * avoid spinning on the CPU (100% iowait)
>                                  * retrying writeback of the dirty page/inode
>                                  * that cannot be performed immediately.
>                                  */
>                                 redirty_tail(inode);
>                         }
  Yes. And then, when there are no inodes in b_more_io, they get queued
again for writeback. So for non-background WB_SYNC_NONE writeback we can
just write a few pages over and over again... Oh, ok we won't because of
my start_time fix I suppose. Maybe a comment about this by the nr_to_write
< MAX_WRITEBACK_PAGES check would be good.

> >   Actually, this comment probably also applies to your patch where you
> > change the queueing logic in writeback_single_inode(), doesn't it?
> 
> Can you elaborate?
  Sorry, my comment only applies to this particular patch. In your change
to writeback_single_inode() you requeue_io() only if nr_to_write <= 0.

								Honza
