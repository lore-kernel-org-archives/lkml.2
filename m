Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0JHKPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:15:55 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:52724 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757065Ab0JHKPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:15:54 -0400
Date: Fri, 8 Oct 2010 21:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Message-ID: <20101008101549.GC4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
 <20101008093202.GX19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008093202.GX19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:32:02AM +0100, Al Viro wrote:
> On Fri, Oct 08, 2010 at 04:21:23PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode reference count is currently an atomic variable so that it can be
> > sampled/modified outside the inode_lock. However, the inode_lock is still
> > needed to synchronise the final reference count and checks against the inode
> > state.
> > 
> > To avoid needing the protection of the inode lock, protect the inode reference
> > count with the per-inode i_lock and convert it to a normal variable. To avoid
> > existing out-of-tree code accidentally compiling against the new method, rename
> > the i_count field to i_ref. This is relatively straight forward as there
> > are limited external references to the i_count field remaining.
> 
> You are overdoing the information hiding here; _way_ too many small
> functions that don't buy you anything so far, AFAICS.

See akpm's comments on the previous version of the series.

> Moreover, why
> the hell not make them static inlines and get rid of the exports?

Yes, that is probably sensible.

> 
> > -	if (atomic_add_unless(&inode->i_count, -1, 1))
> > +	/* XXX: filesystems should not play refcount games like this */
> > +	spin_lock(&inode->i_lock);
> > +	if (inode->i_ref > 1) {
> > +		inode->i_ref--;
> > +		spin_unlock(&inode->i_lock);
> >  		return;
> > +	}
> > +	spin_unlock(&inode->i_lock);
> 
> ... or, perhaps, they needs a helper along the lines of "try to do iput()
> if it's known to hit easy case".
> 
> I really don't like the look of code around -ENOSPC returns, though.
> What exactly is going on there?  Can it e.g. interfere with that
> delayed iput stuff?

I have no idea what the btrfs code is doing, hence I haven't tried
to clean it up or provide any helpers for it. It looks like a hack
around a problem in the btrfs reference counting model to me...

> 
> >  void iref(struct inode *inode)
> >  {
> >  	spin_lock(&inode_lock);
> > +	spin_lock(&inode->i_lock);
> >  	iref_locked(inode);
> > +	spin_unlock(&inode->i_lock);
> >  	spin_unlock(&inode_lock);
> >  }
> 
> *cringe*
> 
> >  int iref_read(struct inode *inode)
> >  {
> > -	return atomic_read(&inode->i_count);
> > +	int ref;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	ref = inode->i_ref;
> > +	spin_unlock(&inode->i_lock);
> > +	return ref;
> 
> What's the point of locking here?

It can be replaced with a memory barrier, right?

> > @@ -1324,8 +1359,16 @@ void iput(struct inode *inode)
> >  	if (inode) {
> >  		BUG_ON(inode->i_state & I_CLEAR);
> >  
> > -		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
> > +		spin_lock(&inode_lock);
> > +		spin_lock(&inode->i_lock);
> > +		inode->i_ref--;
> > +		if (inode->i_ref == 0) {
> > +			spin_unlock(&inode->i_lock);
> >  			iput_final(inode);
> > +			return;
> > +		}
> 
> *UGH*  So you take inode_lock on every damn iput()?

Only until the inode_lock is removed completely.

> >  		state->owner = owner;
> >  		atomic_inc(&owner->so_count);
> >  		list_add(&state->inode_states, &nfsi->open_states);
> > -		state->inode = igrab(inode);
> >  		spin_unlock(&inode->i_lock);
> > +		state->inode = igrab(inode);
> 
> Why is that safe?

Why wouldn't it be?  This is code inherited from Nick's patches, so
I haven't looked this particular hunk in great detail. I've made the
assumption that if the inode passed in doesn't already have a
reference, then that code is already broken.

Instead, it probably should be converted to a iref_locked() call
instead of igrab().

> 
> > --- a/fs/notify/inode_mark.c
> > +++ b/fs/notify/inode_mark.c
> > @@ -257,7 +257,8 @@ void fsnotify_unmount_inodes(struct list_head *list)
> >  		 * actually evict all unreferenced inodes from icache which is
> >  		 * unnecessarily violent and may in fact be illegal to do.
> >  		 */
> > -		if (!iref_read(inode))
> > +		spin_lock(&inode->i_lock);
> > +		if (!inode->i_ref)
> >  			continue;
> 
> Really?

Good catch. It looks like a change split across 2 patches - it is correct when
all patches are applied. Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
