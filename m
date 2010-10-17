Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0JQHFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 03:05:24 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33318 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907Ab0JQHFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 03:05:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAM47ukx5LcB2gWdsb2JhbAChKhYBARYiIsJZhUkEj0w
Date: Sun, 17 Oct 2010 18:05:19 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode
  disposal
Message-ID: <20101017070519.GA24641@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org>
 <20101017024923.GA6453@amd>
 <20101017041313.GJ32255@dastard>
 <20101017043514.GA21802@amd>
 <20101017051310.GA22060@amd>
 <20101017065245.GE29677@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017065245.GE29677@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 05:52:45PM +1100, Dave Chinner wrote:
> On Sun, Oct 17, 2010 at 04:13:10PM +1100, Nick Piggin wrote:
> > On Sun, Oct 17, 2010 at 03:35:14PM +1100, Nick Piggin wrote:
> > > On Sun, Oct 17, 2010 at 03:13:13PM +1100, Dave Chinner wrote:
> > > > On Sun, Oct 17, 2010 at 01:49:23PM +1100, Nick Piggin wrote:
> > > > > On Sat, Oct 16, 2010 at 09:30:47PM -0400, Christoph Hellwig wrote:
> > > > > > >   * inode->i_lock is *always* the innermost lock.
> > > > > > >   *
> > > > > > > + * inode->i_lock is *always* the innermost lock.
> > > > > > > + *
> > > > > > 
> > > > > > No need to repeat, we got it..
> > > > > 
> > > > > Except that I didn't see where you fixed all the places where it is
> > > > > *not* the innermost lock. Like for example places that take dcache_lock
> > > > > inside i_lock.
> > > > 
> > > > I can't find any code outside of ceph where the dcache_lock is used
> > > > within 200 lines of code of the inode->i_lock. The ceph code is not
> > > > nesting them, though.
> > > 
> > > You mustn't have looked very hard? From ceph:
> > > 
> > >        spin_unlock(&dcache_lock);
> > >        spin_unlock(&inode->i_lock);
> > > 
> > > (and yes, acquisition side does go in i_lock->dcache_lock order)
> 
> Sorry, easy to miss with a quick grep when the locks are taken in
> different functions.

Easy to see they're nested when they're dropped in adjacent lines. That
should give you a clue to go and check their lock order.
 
 
> Anyway, this one looks difficult to fix without knowing something
> about Ceph and wtf it is doing there. It's one to punt to the
> maintainer to solve as it's not critical to this patch set.

I thought the raison detre for your starting to write your own vfs
scale branch was because you objected to i_lock not being an "innermost"
lock (not that it was before my patch).

So I don't get it. If your patch mandates it to be an innermost lock,
then you absolutely do need to fix the filesystems before changing the
lock order.

 
> > A really quick grep reveals cifs is using GlobalSMBSeslock inside i_lock
> > too.
> 
> I'm having a grep-fail day. Where is that one?

Uh, inside one of the 6 places that i_lock is taken in cifs. The only
non-trivial one, not surprisingly.

