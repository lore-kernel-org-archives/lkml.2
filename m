Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0JXTRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 15:17:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53080 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0JXTRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 15:17:40 -0400
Date: Sun, 24 Oct 2010 20:17:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101024191735.GU19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
 <20101023213752.GR19804@ZenIV.linux.org.uk>
 <20101024141310.GA21513@infradead.org>
 <20101024162131.GA23677@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024162131.GA23677@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 12:21:31PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 24, 2010 at 10:13:10AM -0400, Christoph Hellwig wrote:
> > On Sat, Oct 23, 2010 at 10:37:52PM +0100, Al Viro wrote:
> > > 	* invalidate_inodes() - collect I_FREEING/I_WILL_FREE on a separate
> > > list, then (after we'd evicted the stuff we'd decided to evict) wait until
> > > they get freed by whatever's freeing them already.
> > 
> > Note that we would only have to do this for the umount case.  For others
> > it's pretty pointless.
> 
> Now that I've looked into it I think we basically fine right now.
> 
> If we're in umount there should be no other I_FREEING inodes.
> 
>  - concurrent prune_icache is prevented by iprune_sem.
>  - concurrent other invalidate_inodes should not happen because we're
>    in unmount and the filesystem should not be reachable any more,
>    and even if it did iprune_sem would protect us.
>  - how could a concurrent iput_final happen?  filesystem is not
>    accessible anymore, and iput of fs internal inodes is single-threaded
>    with the rest of the actual umount process.
> 
> So just skipping over I_FREEING inodes here should be fine for
> non-umount callers, and for umount we could even do a WARN_ON.

FWIW, I think we should kill most of invalidate_inodes() callers.  Look:
	* call in generic_shutdown_super() is legitimate.  The first one,
that is.  The second should be replaced with check for ->s_list being
non-empty.  Note that after the first pass we should have kicked out
everything with zero i_count.  Everything that gets dropped to zero
i_count after that (i.e. during ->put_super()) will be evicted immediately
and won't stay.  I.e. the second call will evict *nothing*; it's just
an overblown way to check if there are any inodes left.
	* call in ext2_remount() is hogwash - we do that with at least
root inode pinned down, so it will fail, along with the remount attempt.
	* ntfs_fill_super() call - no-op.  MS_ACTIVE hasn't been set
yet, so there will be no inodes with zero i_count sitting around.
	* gfs2 calls - same story (no MS_ACTIVE yet in fill_super(),
MS_ACTIVE already removed *and* invalidate_inodes() already called
in gfs2_put_super())
	* smb reconnect logics.  AFAICS, that's complete crap; we *never*
retain inodes on smbfs.  IOW, nothing for invalidate_inodes() to do, other
than evict fsnotify marks.  Which is to say, we are calling the wrong
function there, even assuming that fsnotify should try to work there.
	* finally, __invalidate_device().  Which has a slew of callers of
its own and is *very* different from normal situation.  Here we have
underlying device gone bad.

So I'm going to do the following:
	1) split evict_inodes() off invalidate_inodes() and simplify it.
	2) switch generic_shutdown_super() to that sucker, called once.
	3) kill all calls of invalidate_inodes() except __invalidate_device()
one.
	4) think hard about __invalidate_device() situation.

	evict_inodes() should *not* see any inodes with
I_NEW/I_FREEING/I_WILL_FREE.  Just skip.  It might see I_DIRTY/I_SYNC,
but that's OK - evict_inode() will wait for that.

	OTOH, invalidate_inodes() from __invalidate_device() can run in
parallel with e.g. final iput().  Currently it's not a problem, but
we'll need to start skipping I_FREEING/I_WILL_FREE ones there if we want
to change iput() locking.

	And yes, iprune_sem is a trouble waiting to happen - one fs stuck
in e.g. truncate_inode_pages() and we are seriously fucked; any non-lazy
umount() will get stuck as well.
