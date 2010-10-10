Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab0JJCCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 22:02:11 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:48908 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752872Ab0JJCCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 22:02:09 -0400
Date: Sun, 10 Oct 2010 13:01:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] fs: Protect inode->i_state with th einode->i_lock
Message-ID: <20101010020159.GN4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-15-git-send-email-david@fromorbit.com>
 <20101008074932.GC24089@infradead.org>
 <20101008080428.GW4681@dastard>
 <20101009145227.GE10421@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009145227.GE10421@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 08:52:27AM -0600, Matthew Wilcox wrote:
> On Fri, Oct 08, 2010 at 07:04:28PM +1100, Dave Chinner wrote:
> > > > @@ -884,9 +897,9 @@ struct inode *new_inode(struct super_block *sb)
> > > >  	inode = alloc_inode(sb);
> > > >  	if (inode) {
> > > >  		spin_lock(&inode_lock);
> > > > -		__inode_add_to_lists(sb, NULL, inode);
> > > >  		inode->i_ino = ++last_ino;
> > > >  		inode->i_state = 0;
> > > > +		__inode_add_to_lists(sb, NULL, inode);
> > > >  		spin_unlock(&inode_lock);
> > > >  	}
> > > >  	return inode;
> > > 
> > > What's the point in doing this move?
> > 
> > hmmmm, let me think on that....
> > 
> > > 
> > > > @@ -953,8 +966,8 @@ static struct inode *get_new_inode(struct super_block *sb,
> > > >  			if (set(inode, data))
> > > >  				goto set_failed;
> > > >  
> > > > -			__inode_add_to_lists(sb, b, inode);
> > > >  			inode->i_state = I_NEW;
> > > > +			__inode_add_to_lists(sb, b, inode);
> > > 
> > > Same here.
> > 
> > Ah, done thinking now! I was so the i_state field had been set
> > before the inode was added to various lists and potentially
> > accessable to other threads. I should probably add a comment to that
> > effect, right?
> 
> If that can happen, don't we need a wmb() between the assignment to
> i_state and the list_add too?  If so, that's a good comment :-)

No, because the locking on the lists will provide the memory
barrier.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
