Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0KIX4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:56:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:56443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0KIX4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:56:36 -0500
Date: Wed, 10 Nov 2010 00:56:32 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>,
        Jan Engelhardt <jengelh@medozas.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: stop background/kupdate works from
 livelocking other works
Message-ID: <20101109235632.GD11214@quack.suse.cz>
References: <20101108230916.826791396@intel.com>
 <20101108231726.993880740@intel.com>
 <20101109131310.f442d210.akpm@linux-foundation.org>
 <20101109222827.GJ4936@quack.suse.cz>
 <20101109150006.05892241.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109150006.05892241.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-11-10 15:00:06, Andrew Morton wrote:
> On Tue, 9 Nov 2010 23:28:27 +0100
> Jan Kara <jack@suse.cz> wrote:
> >   New description which should address above questions:
> > Background writeback is easily livelockable in a loop in wb_writeback() by
> > a process continuously re-dirtying pages (or continuously appending to a
> > file). This is in fact intended as the target of background writeback is to
> > write dirty pages it can find as long as we are over
> > dirty_background_threshold.
> 
> Well.  The objective of the kupdate function is utterly different.
> 
> > But the above behavior gets inconvenient at times because no other work
> > queued in the flusher thread's queue gets processed. In particular,
> > since e.g. sync(1) relies on flusher thread to do all the IO for it,
> 
> That's fixable by doing the work synchronously within sync_inodes_sb(),
> rather than twiddling thumbs wasting a thread resource while waiting
> for kernel threads to do it.  As an added bonus, this even makes cpu
> time accounting more accurate ;)
> 
> Please remind me why we decided to hand the sync_inodes_sb() work off
> to other threads?
  Because when sync(1) does IO on it's own, it competes for the device with
the flusher thread running in parallel thus resulting in more seeks.

> > sync(1) can hang forever waiting for flusher thread to do the work.
> > 
> > Generally, when a flusher thread has some work queued, someone submitted
> > the work to achieve a goal more specific than what background writeback
> > does. Moreover by working on the specific work, we also reduce amount of
> > dirty pages which is exactly the target of background writeout. So it makes
> > sense to give specific work a priority over a generic page cleaning.
> > 
> > Thus we interrupt background writeback if there is some other work to do. We
> > return to the background writeback after completing all the queued work.
> > 
...
> > > So...  what prevents higher priority works (eg, sync(1)) from
> > > livelocking or seriously retarding background or kudate writeout?
> >   If other work than background or kupdate writeout livelocks, it's a bug
> > which should be fixed (either by setting sensible nr_to_write or by tagging
> > like we do it for WB_SYNC_ALL writeback). Of course, higher priority work
> > can be running when background or kupdate writeout would need to run as
> > well. But the idea here is that the purpose of background/kupdate types of
> > writeout is to get rid of dirty data and any type of writeout does this so
> > working on it we also work on background/kupdate writeout only possibly
> > less efficiently.
> 
> The kupdate function is a data-integrity/quality-of-service sort of
> thing.
> 
> And what I'm asking is whether this change enables scenarios in which
> these threads can be kept so busy that the kupdate function gets
> interrupted so frequently that we can have dirty memory not being
> written back for arbitrarily long periods of time?
  So let me compare:
What kupdate writeback does:
  queue inodes older than dirty_expire_centisecs
  while some inode in the queue
    write MAX_WRITEBACK_PAGES from each inode queued
    break if nr_to_write <= 0

What any other WB_SYNC_NONE writeback (let me call it "normal WB_SYNC_NONE
writeback") does:
  queue all dirty inodes 
  while some inode in the queue
    write MAX_WRITEBACK_PAGES from each inode queued
    break if nr_to_write <= 0


There only one kind of WB_SYNC_ALL writeback - the one which writes
everything.

So after WB_SYNC_ALL writeback (provided all livelocks are fixed ;)
obviously no old data should be unwritten in memory. Normal WB_SYNC_NONE
writeback differs from a kupdate one *only* in the fact that we queue all
inodes instead of only the old ones. We start writing old inodes first and
go inode by inode writing MAX_WRITEBACK_PAGES from each. Now because the
queue can be longer for normal WB_SYNC_NONE writeback, it can take longer
before we return to the old inodes. So if normal writeback interrupts
kupdate one, it can take longer before all data of old inodes get to disk.
But we always get the old data to disk - essentially at the same time at
which kupdate writeback would get them to disk if dirty_expire_centisecs
was 0.

Is this enough? Do you want any of this in the changelog?

Thanks for the inquiry btw. It made me cleanup my thoughts on the subject ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
