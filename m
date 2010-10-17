Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab0JQEfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 00:35:20 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6684 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717Ab0JQEfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 00:35:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAGoYukx5LcB2gWdsb2JhbAChKhYBARYiIsIWhUkEj0w
Date: Sun, 17 Oct 2010 15:35:14 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101017043514.GA21802@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org>
 <20101017024923.GA6453@amd>
 <20101017041313.GJ32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017041313.GJ32255@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 03:13:13PM +1100, Dave Chinner wrote:
> On Sun, Oct 17, 2010 at 01:49:23PM +1100, Nick Piggin wrote:
> > On Sat, Oct 16, 2010 at 09:30:47PM -0400, Christoph Hellwig wrote:
> > > >   * inode->i_lock is *always* the innermost lock.
> > > >   *
> > > > + * inode->i_lock is *always* the innermost lock.
> > > > + *
> > > 
> > > No need to repeat, we got it..
> > 
> > Except that I didn't see where you fixed all the places where it is
> > *not* the innermost lock. Like for example places that take dcache_lock
> > inside i_lock.
> 
> I can't find any code outside of ceph where the dcache_lock is used
> within 200 lines of code of the inode->i_lock. The ceph code is not
> nesting them, though.

You mustn't have looked very hard? From ceph:

       spin_unlock(&dcache_lock);
       spin_unlock(&inode->i_lock);

(and yes, acquisition side does go in i_lock->dcache_lock order)

If you want to start mandating that i_lock *must* be an inner lock,
please establish the lock order, fix existing code that makes use
of nesting it, and provide a justification to merge the patch.

If the justification is compelling and it gets merged, I can happily
use another lock in the inode for my icache state lock. So please
don't make these off hand insinuations about how that makes your code
better and mine worse. If it is better, let's see a proper
justification and upstream patch, and the issue is really not
central to my locking design.

Thanks,
Nick

