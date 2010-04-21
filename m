Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0DUByi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:54:38 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:60978 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754833Ab0DUByg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:54:36 -0400
Date: Wed, 21 Apr 2010 11:54:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100421015428.GC23541@dastard>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
 <20100408092850.GA20488@quack.suse.cz>
 <20100419013702.GE2520@dastard>
 <20100419070458.GF2520@dastard>
 <20100421003309.GB4128@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421003309.GB4128@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 02:33:09AM +0200, Jan Kara wrote:
> On Mon 19-04-10 17:04:58, Dave Chinner wrote:
> > The first async flush does:
> >                                                                  vvvv
> >     flush-253:16-2497  [000] 616072.897747: writeback_exec: work=13c0 pages=13818, sb=0, kupdate=0, range_cyclic=0 for_background=0
> >     flush-253:16-2497  [000] 616072.897748: writeback_clear: work=ffff88003d8813c0, refs=1
> >     flush-253:16-2497  [000] 616072.897753: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
> >     flush-253:16-2497  [000] 616072.897768: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
> > 
> > Nothing - it does not write any pages towrt (nr_to_write) is
> > unchanged by the attempted flush.
>   This looks a bit strange. Surly there are plenty of dirty pages. I guess
> we never get to ->writepages for XFS.  But then I wonder how does it
> happen that we return without more_io set. Strange.

more_io not being set implies that we aren't calling requeue_io().
So that means it's not caused by I_SYNC being set. If we get down to
write_cache_pages, it implies that there are no dirty pages
remaining we can write back.

Given a background flush just completed before this queued async
flush was executed (didn't seem relevant, so I didn't include
it), it is entirely possible that there were no dirty pages to
write in the followup async flushes.

> > The third flush - the sync one - does:
> >                                                                  vvvv
> >     flush-253:16-2497  [000] 616072.897784: writeback_exec: work=3e58 pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
> >     flush-253:16-2497  [000] 616072.897785: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
> > 
> > some 75 seconds later having written only 1024 pages. In the mean
> > time, the traces show dd blocked in balance_dirty_pages():
> > 
> >               dd-2498  [000] 616072.908675: wbc_balance_dirty_start: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> >               dd-2498  [000] 616072.908679: wbc_balance_dirty_wait: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> >               dd-2498  [000] 616073.238785: wbc_balance_dirty_start: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> >               dd-2498  [000] 616073.238788: wbc_balance_dirty_wait: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> > And it appears to stay blocked there without doing any writeback at
> > all - there are no wbc_balance_dirty_pages_written traces at all.
> > That is, it is blocking until the number of dirty pages is dropping
> > below the dirty threshold, then continuing to write and dirty more
> > pages.
>   I think this happens because sync writeback is running so I_SYNC is set
> and thus we cannot do any writeout for the inode from balance_dirty_pages.

It's not even calling into writeback so the I_SYNC flag is way out of
scope ;)

> > <git blame>
> > 
> > commit 89e12190 - fix bug in nr_to_write introduced by dcf6a79d
> > commit dcf6a79d - fix bug in nr_to_write introduced by 05fe478d
> > commit 05fe478d - data integrity write fix: ignore nr_to_write for
> > 			WB_SYNC_ALL writes.
> > 		"This change does indeed make the possibility of
> > 		long stalls la[r]ger, and that's not a good thing,
> > 		but lying about data integrity is even worse."
> > 
> > IOWs, the observed sync behaviour is as intended - if you keep
> > dirtying the file, sync will keep cleaning it because it defaults to
> > being safe. I'd say "not a bug" then. I agree it's not ideal, but
> > until Jan's inode sync sweep code is accepted I don't think there's
> > much that can be done about it.
>   Yes, my writeback sweeping patch was aimed exactly to reliably address
> this issue. Anyway, if we could get the async stuff working properly then I
> think livelocks should happen much less often... Need to really find some
> time for this.

I think the async writeback is working correctly. It's just that if
we queue async writeback, and it runs directly after a previous
async writeback command was executed, it's possible it has nothing
to do. The problem is that the sync writeback will wait on pages
under writeback as it finds them, so it's likely to be running while
more pages get dirtied and that's when the the tail-chase in
write_cache_pages() starts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
