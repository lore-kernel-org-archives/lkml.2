Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0JHIEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:04:34 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:55373 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490Ab0JHIEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:04:32 -0400
Date: Fri, 8 Oct 2010 19:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] fs: Protect inode->i_state with th einode->i_lock
Message-ID: <20101008080428.GW4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-15-git-send-email-david@fromorbit.com>
 <20101008074932.GC24089@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008074932.GC24089@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:49:32AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 04:21:28PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently protect the per-inode state flags with the inode_lock.
> > Using a global lock to protect per-object state is overkill when we
> > coul duse a per-inode lock to protect the state.  Use the
> > inode->i_lock for this, and wrap all the state changes and checks
> > with the inode->i_lock.
> > 
> > Based on work originally written by Nick Piggin.
> 
> > @@ -884,9 +897,9 @@ struct inode *new_inode(struct super_block *sb)
> >  	inode = alloc_inode(sb);
> >  	if (inode) {
> >  		spin_lock(&inode_lock);
> > -		__inode_add_to_lists(sb, NULL, inode);
> >  		inode->i_ino = ++last_ino;
> >  		inode->i_state = 0;
> > +		__inode_add_to_lists(sb, NULL, inode);
> >  		spin_unlock(&inode_lock);
> >  	}
> >  	return inode;
> 
> What's the point in doing this move?

hmmmm, let me think on that....

> 
> > @@ -953,8 +966,8 @@ static struct inode *get_new_inode(struct super_block *sb,
> >  			if (set(inode, data))
> >  				goto set_failed;
> >  
> > -			__inode_add_to_lists(sb, b, inode);
> >  			inode->i_state = I_NEW;
> > +			__inode_add_to_lists(sb, b, inode);
> 
> Same here.

Ah, done thinking now! I was so the i_state field had been set
before the inode was added to various lists and potentially
accessable to other threads. I should probably add a comment to that
effect, right?

> Otherwise it looks good.  But all this moving around of i_lock really
> hurts my brain.  I guess I'll need to review the placement on a tree
> with the fully applied series again.

Probably best - I didn't get it right the first time, either, when
doing it patch by patch. I had to take that step back to analyse
where i'd screwed it up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
