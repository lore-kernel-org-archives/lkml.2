Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0JPH5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:04 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab0JPH5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIJ3glIE
Date: Sat, 16 Oct 2010 18:56:58 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101016075658.GN19147@amd>
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

I did it this way because we're already holding the lock. But with the
inode and lru lists locked seperately in a subsequent patch, it is
better to check the count, I agree.

