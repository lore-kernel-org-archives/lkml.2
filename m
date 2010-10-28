Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771Ab0J1Vrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:47:53 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:50419 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477Ab0J1Vrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:47:48 -0400
Date: Fri, 29 Oct 2010 08:47:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] fs: move i_wb_list out from under inode_lock
Message-ID: <20101028214744.GF2715@dastard>
References: <1288266161-28897-1-git-send-email-david@fromorbit.com>
 <1288266161-28897-3-git-send-email-david@fromorbit.com>
 <20101028141949.GB19174@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101028141949.GB19174@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:19:49AM -0400, Christoph Hellwig wrote:
> > + * Write out an inode's dirty pages.  Called under inode_wb_list_lock.  Either
> > + * the caller has ref on the inode (either via __iget or via syscall against an
> > + * fd) or the inode has I_WILL_FREE set.
> 
> Just drop mentioning of how we got the reference ,it's rather pointless.

OK.

> >  writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> > @@ -354,7 +368,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> >  	inode->i_state |= I_SYNC;
> >  	inode->i_state &= ~I_DIRTY_PAGES;
> >  	spin_unlock(&inode->i_lock);
> > -	spin_unlock(&inode_lock);
> > +	spin_unlock(&inode_wb_list_lock);
> 
> We don't actually need inode_wb_list_lock here.  But I guess we can
> fix this later and be conservative for now.

Hmmm - I think you are right. However, there are lots of
opportunities for cleaning up the locking in this areaş so leaving
it for later is probably best.

> > @@ -963,63 +976,62 @@ void __mark_inode_dirty(struct inode *inode, int flags)
> 
> I think the __mark_inode_dirty cleanup should be a separate patch,
> it's rather confusing in the current form.

Ok. I'll leave it out for now - there's various other cleanups
needed here now as well (e.g. the unlocked flags check is not needed
to avoid a global lock anymore) so I'll leave that for later, too.

> > +	if (was_dirty) {
> > +out_unlock_inode:
> >  		spin_unlock(&inode->i_lock);
> > +		return;
> > +	}
> 
> Please just move the label to the end of the function and add another
> goto here.

Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
