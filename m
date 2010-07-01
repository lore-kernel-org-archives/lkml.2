Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0GACgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:36:35 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:59453 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752551Ab0GACgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:36:33 -0400
Date: Thu, 1 Jul 2010 12:36:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100701023618.GQ24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630120502.GB21358@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 10:05:02PM +1000, Nick Piggin wrote:
> On Wed, Jun 30, 2010 at 05:27:02PM +1000, Dave Chinner wrote:
> > On Thu, Jun 24, 2010 at 01:02:41PM +1000, npiggin@suse.de wrote:
> > > Protect inode->i_count with i_lock, rather than having it atomic.
> > > Next step should also be to move things together (eg. the refcount increment
> > > into d_instantiate, which will remove a lock/unlock cycle on i_lock).
> > .....
> > > Index: linux-2.6/fs/inode.c
> > > ===================================================================
> > > --- linux-2.6.orig/fs/inode.c
> > > +++ linux-2.6/fs/inode.c
> > > @@ -33,14 +33,13 @@
> > >   * inode_hash_lock protects:
> > >   *   inode hash table, i_hash
> > >   * inode->i_lock protects:
> > > - *   i_state
> > > + *   i_state, i_count
> > >   *
> > >   * Ordering:
> > >   * inode_lock
> > >   *   sb_inode_list_lock
> > >   *     inode->i_lock
> > > - * inode_lock
> > > - *   inode_hash_lock
> > > + *       inode_hash_lock
> > >   */
> > 
> > I thought that the rule governing the use of inode->i_lock was that
> > it can be used anywhere as long as it is the innermost lock.
> > 
> > Hmmm, no references in the code or documentation. Google gives a
> > pretty good reference:
> > 
> > http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg02584.html
> > 
> > Perhaps a different/new lock needs to be used here?
> 
> Well I just changed the order (and documented it to boot :)). It's
> pretty easy to verify that LOR is no problem. inode hash is only
> taken in a very few places so other code outside inode.c is fine to
> use i_lock as an innermost lock.

It's not just the inode_hash_lock - you move four or five other
locks under inode->i_lock as the series progresses. IOWs, there's
now many paths and locking orders where the i_lock is not innermost.
If we go forward with this, it's only going to get more complex and
eventually somewhere we'll need a new lock for an innermost
operation because inode->i_lock is no longer safe to use....

Seriously: use a new lock for high level inode operations you are
optimising - don't repurpose an existing lock with different usage
rules just because it's convenient.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
