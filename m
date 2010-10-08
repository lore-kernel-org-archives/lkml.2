Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0JHNQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:16:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31075 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0JHNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:16:51 -0400
Date: Fri, 8 Oct 2010 09:14:31 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Message-ID: <20101008131431.GI4804@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
 <20101008093202.GX19804@ZenIV.linux.org.uk>
 <20101008101549.GC4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008101549.GC4681@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 09:15:49PM +1100, Dave Chinner wrote:
> On Fri, Oct 08, 2010 at 10:32:02AM +0100, Al Viro wrote:
> > On Fri, Oct 08, 2010 at 04:21:23PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The inode reference count is currently an atomic variable so that it can be
> > > sampled/modified outside the inode_lock. However, the inode_lock is still
> > > needed to synchronise the final reference count and checks against the inode
> > > state.
> > > 
> > > To avoid needing the protection of the inode lock, protect the inode reference
> > > count with the per-inode i_lock and convert it to a normal variable. To avoid
> > > existing out-of-tree code accidentally compiling against the new method, rename
> > > the i_count field to i_ref. This is relatively straight forward as there
> > > are limited external references to the i_count field remaining.
> > 
> > You are overdoing the information hiding here; _way_ too many small
> > functions that don't buy you anything so far, AFAICS.
> 
> See akpm's comments on the previous version of the series.
> 
> > Moreover, why
> > the hell not make them static inlines and get rid of the exports?
> 
> Yes, that is probably sensible.
> 
> > 
> > > -	if (atomic_add_unless(&inode->i_count, -1, 1))
> > > +	/* XXX: filesystems should not play refcount games like this */
> > > +	spin_lock(&inode->i_lock);
> > > +	if (inode->i_ref > 1) {
> > > +		inode->i_ref--;
> > > +		spin_unlock(&inode->i_lock);
> > >  		return;
> > > +	}
> > > +	spin_unlock(&inode->i_lock);
> > 
> > ... or, perhaps, they needs a helper along the lines of "try to do iput()
> > if it's known to hit easy case".
> > 
> > I really don't like the look of code around -ENOSPC returns, though.
> > What exactly is going on there?  Can it e.g. interfere with that
> > delayed iput stuff?
> 
> I have no idea what the btrfs code is doing, hence I haven't tried
> to clean it up or provide any helpers for it. It looks like a hack
> around a problem in the btrfs reference counting model to me...

The problem is that we're not allowed to do the final iput for one
specific caller because it can deadlock on inode deletion.  That one
specific caller doesn't happen very often.

For the deadlock avoidance case, we do the fast atomic_dec as long as we
aren't the last holder and the slow iput-by-a-thread-at-a-safe-time if
we are.  Lots of different filesystem code dances around avoiding iput
inode deletion, should we make this a more generic setup?

-chris
