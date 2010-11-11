Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0KKAsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:48:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:17002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab0KKAsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:48:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,180,1288594800"; 
   d="scan'208";a="676344429"
Date: Thu, 11 Nov 2010 08:40:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>,
        Jan Engelhardt <jengelh@medozas.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: stop background/kupdate works from
 livelocking other works
Message-ID: <20101111004047.GA7879@localhost>
References: <20101108230916.826791396@intel.com>
 <20101108231726.993880740@intel.com>
 <20101109131310.f442d210.akpm@linux-foundation.org>
 <20101109222827.GJ4936@quack.suse.cz>
 <20101109150006.05892241.akpm@linux-foundation.org>
 <20101109235632.GD11214@quack.suse.cz>
 <20101110153729.81ae6b19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110153729.81ae6b19.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 07:37:29AM +0800, Andrew Morton wrote:
> On Wed, 10 Nov 2010 00:56:32 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Tue 09-11-10 15:00:06, Andrew Morton wrote:
> > > On Tue, 9 Nov 2010 23:28:27 +0100
> > > Jan Kara <jack@suse.cz> wrote:
> > > >   New description which should address above questions:
> > > > Background writeback is easily livelockable in a loop in wb_writeback() by
> > > > a process continuously re-dirtying pages (or continuously appending to a
> > > > file). This is in fact intended as the target of background writeback is to
> > > > write dirty pages it can find as long as we are over
> > > > dirty_background_threshold.
> > > 
> > > Well.  The objective of the kupdate function is utterly different.
> > > 
> > > > But the above behavior gets inconvenient at times because no other work
> > > > queued in the flusher thread's queue gets processed. In particular,
> > > > since e.g. sync(1) relies on flusher thread to do all the IO for it,
> > > 
> > > That's fixable by doing the work synchronously within sync_inodes_sb(),
> > > rather than twiddling thumbs wasting a thread resource while waiting
> > > for kernel threads to do it.  As an added bonus, this even makes cpu
> > > time accounting more accurate ;)
> > > 
> > > Please remind me why we decided to hand the sync_inodes_sb() work off
> > > to other threads?
> >   Because when sync(1) does IO on it's own, it competes for the device with
> > the flusher thread running in parallel thus resulting in more seeks.
> 
> Skeptical.  Has that effect been demonstrated?  Has it been shown to be
> a significant problem?  A worse problem than livelocking the machine? ;)
> 
> If this _is_ a problem then it's also a problem for fsync/msync.  But
> see below.

Seriously, I also doubt the value of doing sync() in the flusher thread.
sync() is by definition inefficient. In the block layer, it's served
with less emphasis on throughput. In the VFS layer, it may sleep in
inode_wait_for_writeback() and filemap_fdatawait(). In various FS,
pages won't be skipped at the cost of more lock waiting.

So when a flusher thread is serving sync(), it has difficulties
saturating the storage device.

btw, it seems current sync() does not take advantage of the flusher
threads to sync multiple disks in parallel.

And I guess (concurrent) sync/fsync/msync calls will be rare,
especially for really performance demanding workloads (which will
optimize sync away in the first place).

And I'm still worrying about the sync work (which may take long time
to serve even without livelock) to delay other works considerably --
may not be a problem for now, but it will be a real priority dilemma
when we start writeback works from pageout().

> OT, but: your faith in those time-ordered inode lists is touching ;)
> Put a debug function in there which checks that the lists _are_
> time-ordered, and call that function from every site in the kernel
> which modifies the lists.   I bet there are still gremlins.

I'm more confident on that time orderness ;) But there is a caveat:
redirty_tail() may touch dirtied_when. So it merely keeps the time
orderness of b_dirty on the surface.

Thanks,
Fengguang
