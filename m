Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab0JUMW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:22:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0JUMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:22:28 -0400
Date: Thu, 21 Oct 2010 08:22:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] fs: Implement lazy LRU updates for inodes
Message-ID: <20101021122221.GA3236@infradead.org>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-5-git-send-email-david@fromorbit.com>
 <20101021100706.GA9797@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021100706.GA9797@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:07:06PM +1100, Nick Piggin wrote:
> On Thu, Oct 21, 2010 at 11:49:29AM +1100, Dave Chinner wrote:
> >  		} else {
> >  			/*
> > -			 * The inode is clean, unused
> > +			 * The inode is clean. If it is unused, then make sure
> > +			 * that it is put on the LRU correctly as iput_final()
> > +			 * does not move dirty inodes to the LRU and dirty
> > +			 * inodes are removed from the LRU during scanning.
> >  			 */
> > -			list_move(&inode->i_list, &inode_unused);
> > +			list_del_init(&inode->i_list);
> > +			if (!atomic_read(&inode->i_count))
> > +				inode_lru_list_add(inode);
> 
> This "optimisation" is surely wrong. How could we have no reference
> on the inode at this point?

Good question.  iput_final does so for unlinked inodes or umount,
and that should be about it as it's the only place setting I_WILL_FREE
and we require that for a 0 refcount at the beginning of
writeback_single_inode.  But adding it to the LRU case for that
is rather pointless as we will remove it a little bit later.

So I think the assignment can be safely removed, but I'd rather do in
a separate, properly documented patch rather than hiding it somewhere
unrelated.  That patch could however go towards the beggining of the
series to make things easier.
