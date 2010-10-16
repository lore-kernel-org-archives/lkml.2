Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0JPALJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:11:09 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:41168 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842Ab0JPALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:11:08 -0400
Date: Sat, 16 Oct 2010 11:11:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101016001103.GK4681@dastard>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-4-git-send-email-david@fromorbit.com>
 <20101013133213.GC5263@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013133213.GC5263@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:32:13AM -0400, Christoph Hellwig wrote:
> >  			 */
> >  			redirty_tail(inode);
> > -		} else if (atomic_read(&inode->i_count)) {
> > -			/*
> > -			 * The inode is clean, inuse
> > -			 */
> > -			list_move(&inode->i_list, &inode_in_use);
> >  		} else {
> > -			/*
> > -			 * The inode is clean, unused
> > -			 */
> > -			list_move(&inode->i_list, &inode_unused);
> > +			/* The inode is clean */
> > +			list_del_init(&inode->i_list);
> > +			inode_lru_list_add(inode);
> 
> Just noticed this when reviewing a later patch: why do we lose the
> i_count check here?  There's no point in adding an inode that is still
> in use onto the LRU - we'll just remove it again once we find it
> during LRU scanning.

Good catch. iput_final() moves the inode onto the LRU only if
it is clean, so really only clean, unused inodes need to be added to
the LRU here. Fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
