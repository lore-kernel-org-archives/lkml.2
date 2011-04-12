Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1DLOfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:35:05 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32805 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199Ab1DLOfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:35:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscDABpipE15LHHJgWdsb2JhbACmKhUBARYmJYh6uUEOhWAE
Date: Wed, 13 Apr 2011 00:34:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110412143452.GH31057@dastard>
References: <20110411223623.4278fad1@notabene.brown>
 <4DA2F8AD.1060605@fusionio.com>
 <20110412011255.GA29236@infradead.org>
 <4DA40F0E.1070903@fusionio.com>
 <20110412122248.GC31057@dastard>
 <4DA4456F.3070301@fusionio.com>
 <20110412124134.GD31057@dastard>
 <4DA44C86.3090305@fusionio.com>
 <20110412133117.GE31057@dastard>
 <4DA45790.2010109@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA45790.2010109@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 03:45:52PM +0200, Jens Axboe wrote:
> On 2011-04-12 15:31, Dave Chinner wrote:
> > On Tue, Apr 12, 2011 at 02:58:46PM +0200, Jens Axboe wrote:
> >> On 2011-04-12 14:41, Dave Chinner wrote:
> >> Isn't that example fairly contrived?
> > 
> > I don't think so. e.g. in the XFS allocation path we do btree block
> > readahead, then go do the real work. The real work can end up with a
> > deeper stack before blocking on locks or completions unrelated to
> > the readahead, leading to schedule() being called and an unplug
> > being issued at that point.  You might think it contrived, but if
> > you can't provide a guarantee that it can't happen then I have to
> > assume it will happen.
> 
> If you ended up in lock_page() somewhere along the way, the path would
> have been pretty much the same as it is now:
> 
> lock_page()
>         __lock_page()
>                 __wait_on_bit_lock()
>                         sync_page()
>                                 aops->sync_page();
>                                         block_sync_page()
>                                                 __blk_run_backing_dev()
> 
> and the dispatch follows after that. If your schedules are only due to,
> say, blocking on a mutex, then yes it'll be different. But is that
> really the case?

XFS metadata IO does not use the page cache anymore, so won't take
that path - no page locks are taken during read or write. Even
before that change contending on page locks was extremely rare as
XFs uses the buffer container for synchronisation.

AFAICT, we have nothing that will cause plugs to be flushed until
scheduling occurs. In many cases it will be at the same points as
before (the explicit flushes XFS had), but there are going to be new
ones....

Like this:

  0)     5360      40   zone_statistics+0xad/0xc0
  1)     5320     288   get_page_from_freelist+0x2cf/0x840
  2)     5032     304   __alloc_pages_nodemask+0x121/0x930
  3)     4728      48   kmem_getpages+0x62/0x160
  4)     4680      96   cache_grow+0x308/0x330
  5)     4584      80   cache_alloc_refill+0x21c/0x260
  6)     4504      16   __kmalloc+0x230/0x240
  7)     4488     176   virtqueue_add_buf_gfp+0x1f9/0x3e0
  8)     4312     144   do_virtblk_request+0x1f3/0x400
  9)     4168      32   __blk_run_queue+0x57/0x100
 10)     4136      80   flush_plug_list+0x133/0x1d0
 11)     4056      32   __blk_flush_plug+0x24/0x50
 12)     4024     160   schedule+0x867/0x9f0
 13)     3864     208   schedule_timeout+0x1f5/0x2c0
 14)     3656     144   wait_for_common+0xe7/0x190
 15)     3512      16   wait_for_completion+0x1d/0x20
 16)     3496      48   xfs_buf_iowait+0x36/0xb0
 17)     3448      32   _xfs_buf_read+0x98/0xa0
 18)     3416      48   xfs_buf_read+0xa2/0x100
 19)     3368      80   xfs_trans_read_buf+0x1db/0x680
......

This path adds roughly 500 bytes to the previous case of
immediate dispatch of the IO down through _xfs_buf_read()...

> I bet that worst case stack usage is exactly the same as before, and
> that's the only metric we really care about.

I've already demonstrated much worse stack usage with ext3 through
the page fault path via io_schedule(). io_schedule() never used to
dispatch IO and now it does. Similarly there are changes and
increases in XFS stack usage like above. IMO, worst case stack
usage is definitely increased by these changes.

> > My concern is that we're already under stack space stress in the
> > writeback path, so anything that has the potential to increase it
> > significantly is a major worry from my point of view...
> 
> I agree on writeback being a worry, and that's why I made the change
> (since it makes sense for other reasons, too). I just don't think we are
> worse of than before.

We certainly are.

Hmmm, I just noticed a new cumulative stack usage path through
direct reclaim - via congestion_wait() -> io_schedule()....

> >> If we ended up doing the IO
> >> dispatch before, then the only difference now is the stack usage of
> >> schedule() itself. Apart from that, as far as I can tell, there should
> >> not be much difference.
> > 
> > There's a difference between IO submission and IO dispatch. IO
> > submission is submit_bio thru to the plug; IO dispatch is from the
> > plug down to the disk. If they happen at the same place, there's no
> > problem. If IO dispatch is moved to schedule() via a plug....
> 
> The IO submission can easily and non-deterministically turn into an IO
> dispatch, so there's no real difference for the submitter. That was the
> case before. With the explicit plug now, you _know_ that the IO
> submission is only that and doesn't include IO dispatch.

You're violently agreeing with me that you've changed where the IO
dispatch path is run from. ;)

> Not until you
> schedule() or call blk_finish_plug(), both of which are events that you
> can control.

Well, not really - now taking any sleeping lock or waiting on
anything can trigger a plug flush where previously you had to
explicitly issue them. I'm not saying what we had is better, just
that there are implicit flushes with your changes that are
inherently uncontrollable...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
