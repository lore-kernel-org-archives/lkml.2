Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0JIIFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 04:05:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0JIIFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 04:05:41 -0400
Date: Sat, 9 Oct 2010 04:05:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] fs: Protect inode->i_state with th einode->i_lock
Message-ID: <20101009080537.GA15724@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-15-git-send-email-david@fromorbit.com>
 <20101008074932.GC24089@infradead.org>
 <20101008080428.GW4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008080428.GW4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 07:04:28PM +1100, Dave Chinner wrote:
> > >  		inode->i_ino = ++last_ino;
> > >  		inode->i_state = 0;
> > > +		__inode_add_to_lists(sb, NULL, inode);
> > >  		spin_unlock(&inode_lock);
> > >  	}
> > >  	return inode;
> > 
> > What's the point in doing this move?
> 
> hmmmm, let me think on that....
> 
> > 
> > > @@ -953,8 +966,8 @@ static struct inode *get_new_inode(struct super_block *sb,
> > >  			if (set(inode, data))
> > >  				goto set_failed;
> > >  
> > > -			__inode_add_to_lists(sb, b, inode);
> > >  			inode->i_state = I_NEW;
> > > +			__inode_add_to_lists(sb, b, inode);
> > 
> > Same here.
> 
> Ah, done thinking now! I was so the i_state field had been set
> before the inode was added to various lists and potentially
> accessable to other threads. I should probably add a comment to that
> effect, right?

In addition to the comment get_new_inode_fast also needs the same
treatment.  I also wonder if we need to set I_NEW in new_inode and
then later call unlock_new_inode on it.  It's not on the hash at that
point, but it is on the per-sbi list which we use for a few things.
With current callers it seems safe, but the whole thing also is rather
fragile.  Better left for another patch, though.
