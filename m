Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1GLGWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:22:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:63578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab1GLGWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:22:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,519,1304319600"; 
   d="scan'208";a="24762027"
Date: Mon, 11 Jul 2011 23:20:13 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
Message-ID: <20110712062013.GA4654@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213854.888623315@intel.com>
 <alpine.LSU.2.00.1107111408060.13830@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107111408060.13830@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Tue, Jul 12, 2011 at 05:31:50AM +0800, Hugh Dickins wrote:
> On Wed, 8 Jun 2011, Wu Fengguang wrote:
> > When wbc.more_io was first introduced, it indicates whether there are
> > at least one superblock whose s_more_io contains more IO work. Now with
> > the per-bdi writeback, it can be replaced with a simple b_more_io test.
> 
> This commit, b7a2441f9966fe3e1be960a876ab52e6029ea005 in your branch
> for linux-next, seems very reasonable to me.
> 
> But bisection, confirmed on x86_64 and ppc64 by patching the effective
> (fs-writeback.c) mods into and out of mmotm with that patch reverted,
> show it to be responsible for freezes when running my kernel builds
> on ext2 on loop on tmpfs swapping test.
> 
> flush-7:0 (which is doing writeback to the ext2 filesystem on loop0 on
> a 450MB tmpfs file, though I'm using the ext4 driver to run that ext2fs)
> seems to get stuck circling around __writeback_inodes_wb(), called from
> wb_writeback() from wb_do_writeback() from bdi_writeback_thread().
> 
> Other tasks then hang trying to get the spinlock in inode_wb_list_del()
> (memory pressure is trying to evict inodes) or __mark_inode_dirty().

I created the ext2 on tmpfs loop file and did some simple file copies,
however cannot reproduce the problem. It would help if you have happen
to have some usable test scripts. Or may I ask for your help to follow
the below analyze and perhaps tracing efforts?

> I spent a little while trying to understand why,
> but couldn't work it out: hope you can do better!

The patch in theory only makes difference in this case in
writeback_sb_inodes():

                if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
                        spin_unlock(&inode->i_lock);
                        requeue_io(inode, wb);
                        continue;
                }

So if some inode is stuck in the I_NEW, I_FREEING or I_WILL_FREE state,
the flusher will get stuck busy retrying that inode.

It's relatively easy to confirm, by reusing the below trace event to
show the inode (together with its state) being requeued.

If this is the root cause, it may equally be fixed by

-			requeue_io(inode, wb);
+			redirty_tail(inode, wb);

which would be useful in case the bug is so deadly that it's no longer
possible to do tracing.

Thanks,
Fengguang
---

echo 1 > /debug/tracing/events/writeback/writeback_single_inode*


--- linux-next.orig/fs/fs-writeback.c	2011-07-11 23:07:04.000000000 -0700
+++ linux-next/fs/fs-writeback.c	2011-07-11 23:08:45.000000000 -0700
@@ -726,6 +726,7 @@ static long writeback_sb_inodes(struct s
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
 			spin_unlock(&inode->i_lock);
 			requeue_io(inode, wb);
+			trace_writeback_single_inode_requeue(inode, &wbc, 0);
 			continue;
 		}
 		__iget(inode);
