Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab0DSHFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:05:12 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:39729 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494Ab0DSHFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:05:09 -0400
Date: Mon, 19 Apr 2010 17:04:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100419070458.GF2520@dastard>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
 <20100408092850.GA20488@quack.suse.cz>
 <20100419013702.GE2520@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419013702.GE2520@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:37:02AM +1000, Dave Chinner wrote:
> On Thu, Apr 08, 2010 at 11:28:50AM +0200, Jan Kara wrote:
> > > SUPERPROXY ~ # cat /proc/1753/stack
> > > [<c019a93c>] bdi_sched_wait+0x8/0xc
> > > [<c019a807>] wait_on_bit+0x20/0x2c
> > > [<c019a9af>] sync_inodes_sb+0x6f/0x10a
> > > [<c019dd53>] __sync_filesystem+0x28/0x49
> > > [<c019ddf3>] sync_filesystems+0x7f/0xc0
> > > [<c019de7a>] sys_sync+0x1b/0x2d
> > > [<c02f7a25>] syscall_call+0x7/0xb
> > > [<ffffffff>] 0xffffffff
> >   Hmm, I guess you are observing the problem reported in
> > https://bugzilla.kernel.org/show_bug.cgi?id=14830
> >   There seem to be several issues in the per-bdi writeback code that
> > cause sync on a busy filesystem to last almost forever. To that bug are
> > attached two patches that fix two issues but apparently it's not all.
> > I'm still looking into it...
> 
> So Jen's writeback tracing shows this for a normal cycle during a
> large dd:
> 
>            <...>-6030  [005] 604446.696454: writeback_sched: work=38c0, task=task
>     flush-253:16-6029  [002] 604446.696492: writeback_exec: work=38c0 pages=9223372036854775807, sb=0, kupdate=0, range_cyclic=-1 for_background=-1
>     flush-253:16-6029  [002] 604446.696493: writeback_clear: work=ffff88011f1a38c0, refs=1
>     flush-253:16-6029  [003] 604446.784240: writeback_pages_written: 1024
> 
> There were 100 of these traces (102400 pages (400MB) which is exactly 10% of
> RAM) before this:
> 
>            <...>-6030  [000] 604462.346329: writeback_sched: work=6c0, task=task
>     flush-253:16-6029  [002] 604462.267098: writeback_exec: work=6c0 pages=9223372036854775807, sb=0, kupdate=0, range_cyclic=-1 for_background=-1
>     flush-253:16-6029  [002] 604462.267101: writeback_clear: work=ffff88011e8006c0, refs=1
>     flush-253:16-6029  [001] 604465.406331: writeback_pages_written: 160771
> 
> which shows 160771 pages written in a single iteration (650MB). I suspect some
> interaction between foreground and background writeout is occurring here.
> 
> The flusher thread appears to be getting stuck on congestion - the wchan
> it is sitting on indicates it is blocking in get_request().  I'm going to
> extend this tracing further down into the writeback code so that what is
> happening is clearer...

Ok, I moved to a VM with less memory (1GB vs 4GB) and slower block
devices (100MB/s vs 500MB/s) and now it's pretty clear what is
happening. i'll go through the traces.

To start with, sync() queues up several tasks to the bdi flush daemon:

SYSCALL_DEFINE0(sync)
{
        wakeup_flusher_threads(0);
        sync_filesystems(0);
        sync_filesystems(1);
        if (unlikely(laptop_mode))
                laptop_sync_completion();
        return 0;
}


First is via wakeup_flusher_threads() - an async flush:

            sync-2499  [000] 616072.710212: writeback_queue: 253:16: pages=13818, sb=0, kupdate=0, range_cyclic=0 for_background=0
            sync-2499  [000] 616072.710217: writeback_sched: work=13c0, task=task
                                                                  ^^^^
second is a per-sb async flush via sync_filesystems(0):

            sync-2499  [000] 616072.717181: writeback_queue: 253:16: pages=15761, sb=1, kupdate=0, range_cyclic=-1 for_background=0
            sync-2499  [000] 616072.717191: writeback_sched: work=3840, task=task
                                                                  ^^^^
And finally there is the sync flush via sync_filesystems(1):

            sync-2499  [000] 616072.737836: writeback_queue: 253:16: pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
            sync-2499  [000] 616072.737840: writeback_sched: work=3e58, task=task
                                                                  ^^^^

The first async flush does:
                                                                 vvvv
    flush-253:16-2497  [000] 616072.897747: writeback_exec: work=13c0 pages=13818, sb=0, kupdate=0, range_cyclic=0 for_background=0
    flush-253:16-2497  [000] 616072.897748: writeback_clear: work=ffff88003d8813c0, refs=1
    flush-253:16-2497  [000] 616072.897753: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
    flush-253:16-2497  [000] 616072.897768: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff

Nothing - it does not write any pages towrt (nr_to_write) is
unchanged by the attempted flush.

The second async flush:
                                                                 vvvv
    flush-253:16-2497  [000] 616072.897769: writeback_exec: work=3840 pages=15761, sb=1, kupdate=0, range_cyclic=-1 for_background=0
    flush-253:16-2497  [000] 616072.897770: writeback_clear: work=ffff88003fb53840, refs=1
    flush-253:16-2497  [000] 616072.897771: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-2497  [000] 616072.897783: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0

Differs in setup only by range_cyclic=1 instead of zero, and it also
fails to write anything.

The third flush - the sync one - does:
                                                                 vvvv
    flush-253:16-2497  [000] 616072.897784: writeback_exec: work=3e58 pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
    flush-253:16-2497  [000] 616072.897785: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff

some 75 seconds later having written only 1024 pages. In the mean
time, the traces show dd blocked in balance_dirty_pages():

              dd-2498  [000] 616072.908675: wbc_balance_dirty_start: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
              dd-2498  [000] 616072.908679: wbc_balance_dirty_wait: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
              dd-2498  [000] 616073.238785: wbc_balance_dirty_start: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
              dd-2498  [000] 616073.238788: wbc_balance_dirty_wait: dev 253:16 wbc=fb68 towrt=1536 skip=0 sb=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0

And it appears to stay blocked there without doing any writeback at
all - there are no wbc_balance_dirty_pages_written traces at all.
That is, it is blocking until the number of dirty pages is dropping
below the dirty threshold, then continuing to write and dirty more
pages.

This continues for another 75 seconds, until the dd completes and
then the sync flush thread completes:

    flush-253:16-2497  [000] 616145.763145: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=0 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=1 older=0x0 start=0x0 end=0x7fffffffffffffff
    flush-253:16-2497  [000] 616145.763148: wbc_writeback_start: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
    flush-253:16-2497  [000] 616145.763160: wbc_writeback_written: dev 253:16 wbc=9d20 towrt=1024 skip=0 sb=1 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 more=0 older=0x0 start=0x0 end=0x7fffffffffffffff
    flush-253:16-2497  [000] 616145.763161: writeback_clear: work=ffff88002e783e58, refs=1
                                                                             ^^^^^

The flush thread does not appear to be cycling through 1024 pages at
a time as the wbc structure says it should - it appears to be doing
all the writeback.  Indeed, it is almost always blocked here:

  task                        PC stack   pid father
flush-253:16  D 00000000ffffffff     0  2511      2 0x00000000
 ffff880038409690 0000000000000046 ffff880038409610 00000000001d42c0
 ffff880038409fd8 00000000001d42c0 ffff880038409fd8 ffff88003840c340
 00000000001d42c0 00000000001d42c0 ffff880038409fd8 00000000001d42c0
Call Trace:
 [<ffffffff81790197>] io_schedule+0x47/0x70
 [<ffffffff8141b637>] get_request_wait+0xc7/0x190
 [<ffffffff8109d880>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81414817>] ? elv_merge+0x47/0x220
 [<ffffffff8141bce3>] __make_request+0x93/0x480
 [<ffffffff8141a359>] generic_make_request+0x1f9/0x510
 [<ffffffff810b41bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8117e462>] ? bvec_alloc_bs+0x62/0x110
 [<ffffffff8141a6ca>] submit_bio+0x5a/0xd0
 [<ffffffff8134f874>] xfs_submit_ioend_bio+0x74/0xa0
 [<ffffffff8134fbb1>] xfs_submit_ioend+0xb1/0x110
 [<ffffffff81350e34>] xfs_page_state_convert+0x3a4/0x730
 [<ffffffff810b416d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8135137c>] xfs_vm_writepage+0x8c/0x160
 [<ffffffff81112cfa>] __writepage+0x1a/0x50
 [<ffffffff81113b17>] write_cache_pages+0x1f7/0x400
 [<ffffffff81112ce0>] ? __writepage+0x0/0x50
 [<ffffffff81113d47>] generic_writepages+0x27/0x30
 [<ffffffff8134f28d>] xfs_vm_writepages+0x5d/0x80
 [<ffffffff81113d74>] do_writepages+0x24/0x40
 [<ffffffff811722f7>] writeback_single_inode+0xe7/0x3b0
 [<ffffffff81172d65>] writeback_inodes_wb+0x2e5/0x550
 [<ffffffff811247fb>] ? ftrace_raw_event_id_wbc_class+0x16b/0x190
 [<ffffffff811730c2>] wb_writeback+0xf2/0x2d0
 [<ffffffff811243aa>] ? ftrace_raw_event_writeback_exec+0xea/0xf0
 [<ffffffff811734c8>] wb_do_writeback+0x108/0x240
 [<ffffffff811733f0>] ? wb_do_writeback+0x30/0x240
 [<ffffffff8117365b>] bdi_writeback_task+0x5b/0x180
 [<ffffffff81125ac0>] ? bdi_start_fn+0x0/0x100
 [<ffffffff81125b46>] bdi_start_fn+0x86/0x100
 [<ffffffff81125ac0>] ? bdi_start_fn+0x0/0x100
 [<ffffffff8109d396>] kthread+0x96/0xa0
 [<ffffffff81036e24>] kernel_thread_helper+0x4/0x10
 [<ffffffff817934d0>] ? restore_args+0x0/0x30
 [<ffffffff8109d300>] ? kthread+0x0/0xa0
 [<ffffffff81036e20>] ? kernel_thread_helper+0x0/0x10

Waiting on block device congestion.

Because I have this in wb_writeback():

 756                 trace_wbc_writeback_start(&wbc);
 757                 writeback_inodes_wb(wb, &wbc);
 758                 trace_wbc_writeback_written(&wbc);

I know that we are stuck in a single iteration of
writeback_inodes_wb(). This also implies that we are stuck in a
single do_writepages() call.

Indeed, looking at write_cache_pages():

 838         long nr_to_write = wbc->nr_to_write;
...
 920                         ret = (*writepage)(page, wbc, data);
...
 940                         if (nr_to_write > 0) {
 941                                 nr_to_write--;
 942                                 if (nr_to_write == 0 &&
 943                                     wbc->sync_mode == WB_SYNC_NONE) {
 944                                         /*
 945                                          * We stop writing back only if we are
 946                                          * not doing integrity sync. In case of
 947                                          * integrity sync we have to keep going
 948                                          * because someone may be concurrently
 949                                          * dirtying pages, and we might have
 950                                          * synced a lot of newly appeared dirty
 951                                          * pages, but have not synced all of the
 952                                          * old dirty pages.
 953                                          */
 954                                         done = 1;
 955                                         break;
 956                                 }
 957                         }
...
 973         if (!wbc->no_nrwrite_index_update) {
 974                 if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
 975                         mapping->writeback_index = done_index;
 976                 wbc->nr_to_write = nr_to_write;
 977         }

It even hides this fact from the higher layers by rewriting
wbc->nr_to_write with what it thinks it did, not what really
happened. So, where did this come from?

<git blame>

commit 89e12190 - fix bug in nr_to_write introduced by dcf6a79d
commit dcf6a79d - fix bug in nr_to_write introduced by 05fe478d
commit 05fe478d - data integrity write fix: ignore nr_to_write for
			WB_SYNC_ALL writes.
		"This change does indeed make the possibility of
		long stalls la[r]ger, and that's not a good thing,
		but lying about data integrity is even worse."

IOWs, the observed sync behaviour is as intended - if you keep
dirtying the file, sync will keep cleaning it because it defaults to
being safe. I'd say "not a bug" then. I agree it's not ideal, but
until Jan's inode sync sweep code is accepted I don't think there's
much that can be done about it.

However, what this is doing to XFS writeback is really, really nasty
- it's effectively causing single page allocation and IO submission
instead of doing it in much, much larger chunks.

Adding a wbc trace to xfs_vm_writepage(), I see:

    flush-253:16-2586  [000] 620402.417931: wbc_writepage: dev 253:16 wbc=3d20 towrt=1024 skip=0 sb=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-2586  [000] 620402.442765: wbc_writepage: dev 253:16 wbc=3d20 towrt=0 skip=0 sb=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-2586  [000] 620402.442899: wbc_writepage: dev 253:16 wbc=3d20 towrt=-1 skip=0 sb=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-2586  [000] 620402.442910: wbc_writepage: dev 253:16 wbc=3d20 towrt=-5 skip=0 sb=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-2586  [000] 620402.442918: wbc_writepage: dev 253:16 wbc=3d20 towrt=-21 skip=0 sb=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-2586  [000] 620402.442927: wbc_writepage: dev 253:16 wbc=3d20 towrt=-85 skip=0 sb=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0

Which shows why XFS is having problems. Basically, if a filesystem
writes more than one page in ->writepage and updates
wbc->nr_to_write to indicate this, write_cache_pages completely
ignores it. IOWs, write_cache_pages() wants to call ->writepage()
nr_to_write times, not write nr_to_write pages.  And by sending a
negative number down to ->writepage, XFs is writing a single page
and then returning, completely defeating all the page clustering
optimisations XFS has in ->writepage....

I'll post some patches for the tracing and the XFS fixes soon, but i
don't have anything for sync except understanding, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
