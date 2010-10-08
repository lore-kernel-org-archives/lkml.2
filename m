Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0JHHqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:46:49 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:49375 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628Ab0JHHqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:46:48 -0400
Date: Fri, 8 Oct 2010 18:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] fs: Clean up inode reference counting
Message-ID: <20101008074643.GS4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-7-git-send-email-david@fromorbit.com>
 <20101008072051.GE23595@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008072051.GE23595@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:20:51AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 04:21:20PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Lots of filesystem code open codes the act of getting a reference to
> > an inode.  Factor the open coded inode lock, increment, unlock into
> > a function iref().  Then rename __iget to iref_locked so that nothing
> > is directly incrementing the inode reference count for trivial
> > operations.
> > 
> > Originally based on a patch from Nick Piggin.
> 
> > +++ b/fs/anon_inodes.c
> > @@ -111,10 +111,9 @@ struct file *anon_inode_getfile(const char *name,
> >  	path.mnt = mntget(anon_inode_mnt);
> >  	/*
> >  	 * We know the anon_inode inode count is always greater than zero,
> > -	 * so we can avoid doing an igrab() and we can use an open-coded
> > -	 * atomic_inc().
> > +	 * so we can avoid doing an igrab() by using iref().
> 
> I don't think there's a point keeping this comment.

OK.

> 
> > @@ -297,7 +297,7 @@ static void inode_wait_for_writeback(struct inode *inode)
> >  
> >  /*
> >   * Write out an inode's dirty pages.  Called under inode_lock.  Either the
> > - * caller has ref on the inode (either via __iget or via syscall against an fd)
> > + * caller has ref on the inode (either via iref_locked or via syscall against an fd)
> 
> I'd say just drop the mentioning of how we got a reference to the inode,

OK.

> it's just too confusing in this context.
> 
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -313,11 +313,20 @@ static void init_once(void *foo)
> >  
> >  	inode_init_once(inode);
> >  }
> > +EXPORT_SYMBOL_GPL(iref_locked);
> 
> I think the export is placed incorrectly here.

Fmeh - guilt has an annoying habit of applying patches silently
when there are context mismatches. I've fixed this mismatch about 5
times in the past 2 days, and it keeps creeping back in as I update
patches earlier in the series. I'll fix it up in the next pass.

> > +
> > +void iref(struct inode *inode)
> > +{
> > +	spin_lock(&inode_lock);
> > +	iref_locked(inode);
> > +	spin_unlock(&inode_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(iref);
> 
> 
> > +void iref_locked(struct inode *inode)
> >  {
> >  	atomic_inc(&inode->i_count);
> >  }
> 
> Please add a kerneldoc comment for both exported functions.

OK.

> Also what's the point of taking inode_lock in iref when the only thing
> we do is an atomic_in?  It's probably better only having iref for now
> and only introduce iref_locked once the non-atomic increment needs
> i_lock.

Because in the next couple of patches the atomic-ness goes away, and
the inode lock keeps everything "sane" until all the locking
conversion is completed.

> Also any chance to get an assert under a debug option the the reference
> count really is non-zero?

For iref()? Sure, but I think WARN_ON_ONCE() is better for the moment,
though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
