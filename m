Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1GLTu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:50:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39222 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1GLTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:50:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=aFigkAs7V/jqJDx3jrmPbOpn3SGzEAq0S5msOraE8xaut0P1f9n/n3LiXBJd8l6YB
	FwPX5ce7iU2WV+gWtSl9Q==
Date: Tue, 12 Jul 2011 12:50:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
In-Reply-To: <20110712062013.GA4654@localhost>
Message-ID: <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
References: <20110607213236.634026193@intel.com> <20110607213854.888623315@intel.com> <alpine.LSU.2.00.1107111408060.13830@sister.anvils> <20110712062013.GA4654@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Wu Fengguang wrote:
> On Tue, Jul 12, 2011 at 05:31:50AM +0800, Hugh Dickins wrote:
> > On Wed, 8 Jun 2011, Wu Fengguang wrote:
> > > When wbc.more_io was first introduced, it indicates whether there are
> > > at least one superblock whose s_more_io contains more IO work. Now with
> > > the per-bdi writeback, it can be replaced with a simple b_more_io test.
> > 
> > This commit, b7a2441f9966fe3e1be960a876ab52e6029ea005 in your branch
> > for linux-next, seems very reasonable to me.
> > 
> > But bisection, confirmed on x86_64 and ppc64 by patching the effective
> > (fs-writeback.c) mods into and out of mmotm with that patch reverted,
> > show it to be responsible for freezes when running my kernel builds
> > on ext2 on loop on tmpfs swapping test.
> > 
> > flush-7:0 (which is doing writeback to the ext2 filesystem on loop0 on
> > a 450MB tmpfs file, though I'm using the ext4 driver to run that ext2fs)
> > seems to get stuck circling around __writeback_inodes_wb(), called from
> > wb_writeback() from wb_do_writeback() from bdi_writeback_thread().
> > 
> > Other tasks then hang trying to get the spinlock in inode_wb_list_del()
> > (memory pressure is trying to evict inodes) or __mark_inode_dirty().
> 
> I created the ext2 on tmpfs loop file and did some simple file copies,
> however cannot reproduce the problem. It would help if you have happen
> to have some usable test scripts.

It takes a while to explain: the sizes need to be tuned to get enough
memory pressure.  I'll forward you the mail in which I described it two
years ago, which should be enough to give you the idea, even if it's not
identical to what I'm using now.

But from what you say below, I think it's pretty much all (the ext2,
the loop, the tmpfs) irrelevant: memory pressure and lots of files
modified, a kernel build in limited memory, that should be enough.

> Or may I ask for your help to follow
> the below analyze and perhaps tracing efforts?
> 
> > I spent a little while trying to understand why,
> > but couldn't work it out: hope you can do better!
> 
> The patch in theory only makes difference in this case in
> writeback_sb_inodes():
> 
>                 if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
>                         spin_unlock(&inode->i_lock);
>                         requeue_io(inode, wb);
>                         continue;
>                 }
> 
> So if some inode is stuck in the I_NEW, I_FREEING or I_WILL_FREE state,
> the flusher will get stuck busy retrying that inode.

Well, if that's the case (it's not obvious to me how removing more_io
made a difference there) then I think you've already got the answer:
thank you!  As I mentioned, memory pressure is trying to evict inodes, so
tasks are hanging trying to acquire wb->list_lock in inode_wb_list_del().

But inodes being evicted are I_FREEING, and the flush thread is
holding wb->list_lock across all of this (since one of your earlier
patchs), so if one of the inodes being evicted is on the b_io list,
then indeed we'll be stuck.

> 
> It's relatively easy to confirm, by reusing the below trace event to
> show the inode (together with its state) being requeued.
> 
> If this is the root cause, it may equally be fixed by
> 
> -			requeue_io(inode, wb);
> +			redirty_tail(inode, wb);
> 
> which would be useful in case the bug is so deadly that it's no longer
> possible to do tracing.

I checked again this morning that I could reproduce it on two machines,
one went in a few minutes, the other within the hour.  Then I made that
patch changing the requeue_io to redirty_tail, and left home with them
running the test with the new kernel: we'll see at the end of the day
how they fared.

I do have a variant of kdb in (but I think my breakpoints are broken at
present), so I'd be inclined to use that rather than get into tracing:
I can easily add a counter in there and see what happens to it, if more
investigation turns out to be needed.

redirty_tail() instead of requeue_io(): is there any danger that doing
that could delay some updates indefinitely?

Hugh

> 
> Thanks,
> Fengguang
> ---
> 
> echo 1 > /debug/tracing/events/writeback/writeback_single_inode*
> 
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-07-11 23:07:04.000000000 -0700
> +++ linux-next/fs/fs-writeback.c	2011-07-11 23:08:45.000000000 -0700
> @@ -726,6 +726,7 @@ static long writeback_sb_inodes(struct s
>  		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
>  			spin_unlock(&inode->i_lock);
>  			requeue_io(inode, wb);
> +			trace_writeback_single_inode_requeue(inode, &wbc, 0);
>  			continue;
>  		}
>  		__iget(inode);
