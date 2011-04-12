Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1DLMlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:41:40 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57932 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1DLMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:41:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscDAPhFpE15LHHJgWdsb2JhbACmKxUBARYmJYh6uSUOgnOCbQQ
Date: Tue, 12 Apr 2011 22:41:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110412124134.GD31057@dastard>
References: <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110411223623.4278fad1@notabene.brown>
 <4DA2F8AD.1060605@fusionio.com>
 <20110412011255.GA29236@infradead.org>
 <4DA40F0E.1070903@fusionio.com>
 <20110412122248.GC31057@dastard>
 <4DA4456F.3070301@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA4456F.3070301@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 02:28:31PM +0200, Jens Axboe wrote:
> On 2011-04-12 14:22, Dave Chinner wrote:
> > On Tue, Apr 12, 2011 at 10:36:30AM +0200, Jens Axboe wrote:
> >> On 2011-04-12 03:12, hch@infradead.org wrote:
> >>> On Mon, Apr 11, 2011 at 02:48:45PM +0200, Jens Axboe wrote:
> >>>> Great, once you do that and XFS kills the blk_flush_plug() calls too,
> >>>> then we can remove that export and make it internal only.
> >>>
> >>> Linus pulled the tree, so they are gone now.  Btw, there's still some
> >>> bits in the area that confuse me:
> >>
> >> Great!
> >>
> >>>  - what's the point of the queue_sync_plugs?  It has a lot of comment
> >>>    that seem to pre-data the onstack plugging, but except for that
> >>>    it's trivial wrapper around blk_flush_plug, with an argument
> >>>    that is not used.
> >>
> >> There's really no point to it anymore. It's existance was due to the
> >> older revision that had to track write requests for serializaing around
> >> a barrier. I'll kill it, since we don't do that anymore.
> >>
> >>>  - is there a good reason for the existance of __blk_flush_plug?  You'd
> >>>    get one additional instruction in the inlined version of
> >>>    blk_flush_plug when opencoding, but avoid the need for chained
> >>>    function calls.
> >>>  - Why is having a plug in blk_flush_plug marked unlikely?  Note that
> >>>    unlikely is the static branch prediction hint to mark the case
> >>>    extremly unlikely and is even used for hot/cold partitioning.  But
> >>>    when we call it we usually check beforehand if we actually have
> >>>    plugs, so it's actually likely to happen.
> >>
> >> The existance and out-of-line is for the scheduler() hook. It should be
> >> an unlikely event to schedule with a plug held, normally the plug should
> >> have been explicitly unplugged before that happens.
> > 
> > Though if it does, haven't you just added a significant amount of
> > depth to the worst case stack usage? I'm seeing this sort of thing
> > from io_schedule():
> > 
> >         Depth    Size   Location    (40 entries)
> >         -----    ----   --------
> >   0)     4256      16   mempool_alloc_slab+0x15/0x20
> >   1)     4240     144   mempool_alloc+0x63/0x160
> >   2)     4096      16   scsi_sg_alloc+0x4c/0x60
> >   3)     4080     112   __sg_alloc_table+0x66/0x140
> >   4)     3968      32   scsi_init_sgtable+0x33/0x90
> >   5)     3936      48   scsi_init_io+0x31/0xc0
> >   6)     3888      32   scsi_setup_fs_cmnd+0x79/0xe0
> >   7)     3856     112   sd_prep_fn+0x150/0xa90
> >   8)     3744      48   blk_peek_request+0x6a/0x1f0
> >   9)     3696      96   scsi_request_fn+0x60/0x510
> >  10)     3600      32   __blk_run_queue+0x57/0x100
> >  11)     3568      80   flush_plug_list+0x133/0x1d0
> >  12)     3488      32   __blk_flush_plug+0x24/0x50
> >  13)     3456      32   io_schedule+0x79/0x80
> > 
> > (This is from a page fault on ext3 that is doing page cache
> > readahead and blocking on a locked buffer.)
> > 
> > I've seen traces where mempool_alloc_slab enters direct reclaim
> > which adds another 1.5k of stack usage to this path. So I'm
> > extremely concerned that you've just reduced the stack available to
> > every thread by at least 2.5k of space...
> 
> Yeah, that does not look great. If this turns out to be problematic, we
> can turn the queue runs from the unlikely case into out-of-line from
> kblockd.
> 
> But this really isn't that new, you could enter the IO dispatch path
> when doing IO already (when submitting it). So we better be able to
> handle that.

The problem I see is that IO is submitted when there's plenty of
stack available whould have previously been fine. However now it
hits the plug, and then later on after the thread consumes a lot
more stack it, say, waits for a completion. We then schedule, it
unplugs the queue and we add the IO stack to a place where there
isn't much space available.

So effectively we are moving the places where stack is consumed
about, and it's complete unpredictable where that stack is going to
land now.

> If it's a problem from the schedule()/io_schedule() path, then
> lets ensure that those are truly unlikely events so we can punt
> them to kblockd.

Rather than wait for an explosion to be reported before doing this,
why not just punt unplugs to kblockd unconditionally?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
