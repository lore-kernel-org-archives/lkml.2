Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0GCDld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 23:41:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab0GCDlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 23:41:32 -0400
Date: Sat, 3 Jul 2010 13:41:23 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100703034123.GE11732@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 07:03:55PM -0700, Andrew Morton wrote:
> On Wed, 30 Jun 2010 22:05:02 +1000 Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Wed, Jun 30, 2010 at 05:27:02PM +1000, Dave Chinner wrote:
> > > On Thu, Jun 24, 2010 at 01:02:41PM +1000, npiggin@suse.de wrote:
> > > > Protect inode->i_count with i_lock, rather than having it atomic.
> > > > Next step should also be to move things together (eg. the refcount increment
> > > > into d_instantiate, which will remove a lock/unlock cycle on i_lock).
> > > .....
> > > > Index: linux-2.6/fs/inode.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/fs/inode.c
> > > > +++ linux-2.6/fs/inode.c
> > > > @@ -33,14 +33,13 @@
> > > >   * inode_hash_lock protects:
> > > >   *   inode hash table, i_hash
> > > >   * inode->i_lock protects:
> > > > - *   i_state
> > > > + *   i_state, i_count
> > > >   *
> > > >   * Ordering:
> > > >   * inode_lock
> > > >   *   sb_inode_list_lock
> > > >   *     inode->i_lock
> > > > - * inode_lock
> > > > - *   inode_hash_lock
> > > > + *       inode_hash_lock
> > > >   */
> > > 
> > > I thought that the rule governing the use of inode->i_lock was that
> > > it can be used anywhere as long as it is the innermost lock.
> > > 
> > > Hmmm, no references in the code or documentation. Google gives a
> > > pretty good reference:
> > > 
> > > http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg02584.html
> > > 
> > > Perhaps a different/new lock needs to be used here?
> > 
> > Well I just changed the order (and documented it to boot :)). It's
> > pretty easy to verify that LOR is no problem. inode hash is only
> > taken in a very few places so other code outside inode.c is fine to
> > use i_lock as an innermost lock.
> 
> um, nesting a kernel-wide singleton lock inside a per-inode lock is
> plain nutty.

I think it worked out OK. Because the kernel-wide locks are really
restricted in where they are to be used (ie. not in filesystems). So
they're really pretty constrained to the inode management subsystem.
So filesystems still get to really use i_lock as an inner most lock
for their purposes.

And filesystems get to take i_lock and stop all manipulation of inode
now.  No changing of flags, moving it on/off lists etc behind its back.
It really is about locking the data rather than the code.

The final ordering outcome looks like this:

 * inode->i_lock
 *   inode_list_lglock
 *   zone->inode_lru_lock
 *   wb->b_lock
 *   inode_hash_bucket lock

And it works like that because when you want to add or remove an inode
from various data structures, you take the i_lock and then take each
of these locks in turn, inside it. The alternative is to build a bigger
lock ordering graph, and take all the locks up-front before taking
i_lock. I did actaully try that and it ended up being worse, so I went
this route.

I think taking a global lock in mark_inode_dirty is nutty (especially
when that global lock is shared with hash management, LRU scanning,
writeback, i_flags access... :) It's just a question of which is less
nutty.

