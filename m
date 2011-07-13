Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1GMWHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:07:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:40763 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1GMWHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,527,1304319600"; 
   d="scan'208";a="30026951"
Date: Wed, 13 Jul 2011 15:07:08 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
Message-ID: <20110713220708.GA4408@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213854.888623315@intel.com>
 <alpine.LSU.2.00.1107111408060.13830@sister.anvils>
 <20110712062013.GA4654@localhost>
 <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 03:50:31AM +0800, Hugh Dickins wrote:
> On Mon, 11 Jul 2011, Wu Fengguang wrote:
> > On Tue, Jul 12, 2011 at 05:31:50AM +0800, Hugh Dickins wrote:
> > > On Wed, 8 Jun 2011, Wu Fengguang wrote:
> > > > When wbc.more_io was first introduced, it indicates whether there are
> > > > at least one superblock whose s_more_io contains more IO work. Now with
> > > > the per-bdi writeback, it can be replaced with a simple b_more_io test.
> > > 
> > > This commit, b7a2441f9966fe3e1be960a876ab52e6029ea005 in your branch
> > > for linux-next, seems very reasonable to me.
> > > 
> > > But bisection, confirmed on x86_64 and ppc64 by patching the effective
> > > (fs-writeback.c) mods into and out of mmotm with that patch reverted,
> > > show it to be responsible for freezes when running my kernel builds
> > > on ext2 on loop on tmpfs swapping test.
> > > 
> > > flush-7:0 (which is doing writeback to the ext2 filesystem on loop0 on
> > > a 450MB tmpfs file, though I'm using the ext4 driver to run that ext2fs)
> > > seems to get stuck circling around __writeback_inodes_wb(), called from
> > > wb_writeback() from wb_do_writeback() from bdi_writeback_thread().
> > > 
> > > Other tasks then hang trying to get the spinlock in inode_wb_list_del()
> > > (memory pressure is trying to evict inodes) or __mark_inode_dirty().
> > 
> > I created the ext2 on tmpfs loop file and did some simple file copies,
> > however cannot reproduce the problem. It would help if you have happen
> > to have some usable test scripts.
> 
> It takes a while to explain: the sizes need to be tuned to get enough
> memory pressure.  I'll forward you the mail in which I described it two
> years ago, which should be enough to give you the idea, even if it's not
> identical to what I'm using now.

Thank you. I'm able to reproduce the bug with your script. I tried 2
runs on unmodified linux-next and they both hang the test box. Then I
applied the below redirty_tail() patch and it survived 2 new runs.

Combined with your test results, we can safely assume that the bug
is fixed by changing to redirty_tail().

> But from what you say below, I think it's pretty much all (the ext2,
> the loop, the tmpfs) irrelevant: memory pressure and lots of files
> modified, a kernel build in limited memory, that should be enough.

Yeah, that's probably enough to trigger an I_FREEING|I_WILL_FREE dirty
inode that is caught by the flusher thread.

> > Or may I ask for your help to follow
> > the below analyze and perhaps tracing efforts?
> > 
> > > I spent a little while trying to understand why,
> > > but couldn't work it out: hope you can do better!
> > 
> > The patch in theory only makes difference in this case in
> > writeback_sb_inodes():
> > 
> >                 if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
> >                         spin_unlock(&inode->i_lock);
> >                         requeue_io(inode, wb);
> >                         continue;
> >                 }
> > 
> > So if some inode is stuck in the I_NEW, I_FREEING or I_WILL_FREE state,
> > the flusher will get stuck busy retrying that inode.
> 
> Well, if that's the case (it's not obvious to me how removing more_io
> made a difference there) then I think you've already got the answer:
> thank you!  As I mentioned, memory pressure is trying to evict inodes, so
> tasks are hanging trying to acquire wb->list_lock in inode_wb_list_del().
>
> But inodes being evicted are I_FREEING, and the flush thread is
> holding wb->list_lock across all of this (since one of your earlier
> patchs), so if one of the inodes being evicted is on the b_io list,
> then indeed we'll be stuck.

Exactly. Commit e8dfc305 ("writeback: elevate queue_io() into
wb_writeback()") aims to be a cleanup patch, however happen to have
the side effect of keeping wb->list_lock throughout the loop in the
case of an I_NEW|I_FREEING|I_WILL_FREE inode. Without it, only the
flusher thread will be busy looping, other tasks still have the
chances to pass through the lock.

> > 
> > It's relatively easy to confirm, by reusing the below trace event to
> > show the inode (together with its state) being requeued.
> > 
> > If this is the root cause, it may equally be fixed by
> > 
> > -			requeue_io(inode, wb);
> > +			redirty_tail(inode, wb);
> > 
> > which would be useful in case the bug is so deadly that it's no longer
> > possible to do tracing.
> 
> I checked again this morning that I could reproduce it on two machines,
> one went in a few minutes, the other within the hour.  Then I made that
> patch changing the requeue_io to redirty_tail, and left home with them
> running the test with the new kernel: we'll see at the end of the day
> how they fared.

Good, our test results agree up to now :)

> I do have a variant of kdb in (but I think my breakpoints are broken at
> present), so I'd be inclined to use that rather than get into tracing:
> I can easily add a counter in there and see what happens to it, if more
> investigation turns out to be needed.

I also find it impossible to carry out the tracing..

> redirty_tail() instead of requeue_io(): is there any danger that doing
> that could delay some updates indefinitely?

As explained by Jan, I_FREEING|I_WILL_FREE inodes will be wrote out by
the freer, and I_NEW is transitional state. So it looks like a safe fix.

Thanks,
Fengguang
---
Subject: writeback: don't busy retry writeback on new/freeing inodes
Date: Mon Jul 11 23:08:50 PDT 2011

Fix a system hang bug introduced by commit b7a2441f9966 ("writeback:
remove writeback_control.more_io") and e8dfc3058 ("writeback: elevate
queue_io() into wb_writeback()") easily reproducible with high memory
pressure and lots of file creation/deletions, for example, a kernel
build in limited memory.

It hangs when some inode is in the I_NEW, I_FREEING or I_WILL_FREE
state, the flusher will get stuck busy retrying that inode, never
releasing wb->list_lock. The lock in turn blocks all kinds of other
tasks when they are trying to grab it.

As put by Jan, it's a safe change regarding data integrity. I_FREEING or
I_WILL_FREE inodes are written back by iput_final() and it is reclaim
code that is responsible for eventually removing them. So writeback code
can safely ignore them. I_NEW inodes should move out of this state when
they are fully set up and in the writeback round following that, we will
consider them for writeback. So the change makes sense.                                                         

CC: Jan Kara <jack@suse.cz> 
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/fs/fs-writeback.c	2011-07-12 10:06:45.000000000 -0700
+++ linux-next/fs/fs-writeback.c	2011-07-13 14:41:39.000000000 -0700
@@ -725,7 +725,7 @@ static long writeback_sb_inodes(struct s
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
 			spin_unlock(&inode->i_lock);
-			requeue_io(inode, wb);
+			redirty_tail(inode, wb);
 			continue;
 		}
 		__iget(inode);
