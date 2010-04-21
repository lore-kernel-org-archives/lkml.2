Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0DUAdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:33:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0DUAdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:33:09 -0400
Date: Wed, 21 Apr 2010 02:33:09 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100421003309.GB4128@quack.suse.cz>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
 <20100408092850.GA20488@quack.suse.cz>
 <20100419013702.GE2520@dastard>
 <20100419070458.GF2520@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419070458.GF2520@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-04-10 17:04:58, Dave Chinner wrote:
> On Mon, Apr 19, 2010 at 11:37:02AM +1000, Dave Chinner wrote:
> > On Thu, Apr 08, 2010 at 11:28:50AM +0200, Jan Kara wrote:
> > > > SUPERPROXY ~ # cat /proc/1753/stack
> > > > [<c019a93c>] bdi_sched_wait+0x8/0xc
> > > > [<c019a807>] wait_on_bit+0x20/0x2c
> > > > [<c019a9af>] sync_inodes_sb+0x6f/0x10a
> > > > [<c019dd53>] __sync_filesystem+0x28/0x49
> > > > [<c019ddf3>] sync_filesystems+0x7f/0xc0
> > > > [<c019de7a>] sys_sync+0x1b/0x2d
> > > > [<c02f7a25>] syscall_call+0x7/0xb
> > > > [<ffffffff>] 0xffffffff
> > >   Hmm, I guess you are observing the problem reported in
> > > https://bugzilla.kernel.org/show_bug.cgi?id=14830
> > >   There seem to be several issues in the per-bdi writeback code that
> > > cause sync on a busy filesystem to last almost forever. To that bug are
> > > attached two patches that fix two issues but apparently it's not all.
> > > I'm still looking into it...
> > 
> > So Jen's writeback tracing shows this for a normal cycle during a
> > large dd:
> > 
> >            <...>-6030  [005] 604446.696454: writeback_sched: work=38c0, task=task
> >     flush-253:16-6029  [002] 604446.696492: writeback_exec: work=38c0 pages=9223372036854775807, sb=0, kupdate=0, range_cyclic=-1 for_background=-1
> >     flush-253:16-6029  [002] 604446.696493: writeback_clear: work=ffff88011f1a38c0, refs=1
> >     flush-253:16-6029  [003] 604446.784240: writeback_pages_written: 1024
> > 
> > There were 100 of these traces (102400 pages (400MB) which is exactly 10% of
> > RAM) before this:
> > 
> >            <...>-6030  [000] 604462.346329: writeback_sched: work=6c0, task=task
> >     flush-253:16-6029  [002] 604462.267098: writeback_exec: work=6c0 pages=9223372036854775807, sb=0, kupdate=0, range_cyclic=-1 for_background=-1
> >     flush-253:16-6029  [002] 604462.267101: writeback_clear: work=ffff88011e8006c0, refs=1
> >     flush-253:16-6029  [001] 604465.406331: writeback_pages_written: 160771
> > 
> > which shows 160771 pages written in a single iteration (650MB). I suspect some
> > interaction between foreground and background writeout is occurring here.
> > 
> > The flusher thread appears to be getting stuck on congestion - the wchan
> > it is sitting on indicates it is blocking in get_request().  I'm going to
> > extend this tracing further down into the writeback code so that what is
> > happening is clearer...
> 
> Ok, I moved to a VM with less memory (1GB vs 4GB) and slower block
> devices (100MB/s vs 500MB/s) and now it's pretty clear what is
> happening. i'll go through the traces.
> 
> To start with, sync() queues up several tasks to the bdi flush daemon:
> 
> SYSCALL_DEFINE0(sync)
> {
>         wakeup_flusher_threads(0);
>         sync_filesystems(0);
>         sync_filesystems(1);
>         if (unlikely(laptop_mode))
>                 laptop_sync_completion();
>         return 0;
> }
> 
> 
> First is via wakeup_flusher_threads() - an async flush:
> 
>             sync-2499  [000] 616072.710212: writeback_queue: 253:16: pages=13818, sb=0, kupdate=0, range_cyclic=0 for_background=0
>             sync-2499  [000] 616072.710217: writeback_sched: work=13c0, task=task
>                                                                   ^^^^
> second is a per-sb async flush via sync_filesystems(0):
> 
>             sync-2499  [000] 616072.717181: writeback_queue: 253:16: pages=15761, sb=1, kupdate=0, range_cyclic=-1 for_background=0
>             sync-2499  [000] 616072.717191: writeback_sched: work=3840, task=task
>                                                                   ^^^^
> And finally there is the sync flush via sync_filesystems(1):
> 
>             sync-2499  [000] 616072.737836: writeback_queue: 253:16: pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
>             sync-2499  [000] 616072.737840: writeback_sched: work=3e58, task=task
>                                                                   ^^^^
> 
> The first async flush does:
>                                                                  vvvv
>     flush-253:16-2497  [000] 616072.897747: writeback_exec: work=13c0 pages=13818, sb=0, kupdate=0, range_cyclic=0 for_background=0
>     flush-253:16-2497  [000] 616072.897748: writeback_clear: work=ffff88003d8813c0, refs=1
>     flush-253:16-2497  [000] 616072.897753: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
>     flush-253:16-2497  [000] 616072.897768: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
> 
> Nothing - it does not write any pages towrt (nr_to_write) is
> unchanged by the attempted flush.
  This looks a bit strange. Surly there are plenty of dirty pages. I guess
we never get to ->writepages for XFS.  But then I wonder how does it
happen that we return without more_io set. Strange.

> The second async flush:
>                                                                  vvvv
>     flush-253:16-2497  [000] 616072.897769: writeback_exec: work=3840 pages=15761, sb=1, kupdate=0, range_cyclic=-1 for_background=0
>     flush-253:16-2497  [000] 616072.897770: writeback_clear: work=ffff88003fb53840, refs=1
>     flush-253:16-2497  [000] 616072.897771: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>     flush-253:16-2497  [000] 616072.897783: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> 
> Differs in setup only by range_cyclic=1 instead of zero, and it also
> fails to write anything.
> 
> The third flush - the sync one - does:
>                                                                  vvvv
>     flush-253:16-2497  [000] 616072.897784: writeback_exec: work=3e58 pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
>     flush-253:16-2497  [000] 616072.897785: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
> 
> some 75 seconds later having written only 1024 pages. In the mean
> time, the traces show dd blocked in balance_dirty_pages():
> 
>               dd-2498  [000] 616072.908675: wbc_balance_dirty_start: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>               dd-2498  [000] 616072.908679: wbc_balance_dirty_wait: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>               dd-2498  [000] 616073.238785: wbc_balance_dirty_start: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>               dd-2498  [000] 616073.238788: wbc_balance_dirty_wait: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> And it appears to stay blocked there without doing any writeback at
> all - there are no wbc_balance_dirty_pages_written traces at all.
> That is, it is blocking until the number of dirty pages is dropping
> below the dirty threshold, then continuing to write and dirty more
> pages.
  I think this happens because sync writeback is running so I_SYNC is set
and thus we cannot do any writeout for the inode from balance_dirty_pages.

> This continues for another 75 seconds, until the dd completes and
> then the sync flush thread completes:
> 
>     flush-253:16-2497  [000] 616145.763145: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=0 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=1 older=0x0 start=0x0 end=0x7fffffffffffffff
>     flush-253:16-2497  [000] 616145.763148: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
>     flush-253:16-2497  [000] 616145.763160: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
>     flush-253:16-2497  [000] 616145.763161: writeback_clear: work=ffff88002e783e58, refs=1
>                                                                              ^^^^^
...
> <git blame>
> 
> commit 89e12190 - fix bug in nr_to_write introduced by dcf6a79d
> commit dcf6a79d - fix bug in nr_to_write introduced by 05fe478d
> commit 05fe478d - data integrity write fix: ignore nr_to_write for
> 			WB_SYNC_ALL writes.
> 		"This change does indeed make the possibility of
> 		long stalls la[r]ger, and that's not a good thing,
> 		but lying about data integrity is even worse."
> 
> IOWs, the observed sync behaviour is as intended - if you keep
> dirtying the file, sync will keep cleaning it because it defaults to
> being safe. I'd say "not a bug" then. I agree it's not ideal, but
> until Jan's inode sync sweep code is accepted I don't think there's
> much that can be done about it.
  Yes, my writeback sweeping patch was aimed exactly to reliably address
this issue. Anyway, if we could get the async stuff working properly then I
think livelocks should happen much less often... Need to really find some
time for this.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
