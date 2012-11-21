Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2KUIWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:22:24 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:8532 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725Ab2KUIWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:22:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEIAIeOrFB5LbLL/2dsb2JhbABEvE2FeBdzgh4BAQQBJxMcIwULCAMOCi4UJQMhE4gHBb8xFIwghGIDi0uKMoZaiWiDAw
Date: Wed, 21 Nov 2012 19:22:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121121082219.GQ2591@dastard>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
 <20121119194102.GB20532@quack.suse.cz>
 <87a9udtiyk.fsf@devron.myhome.or.jp>
 <20121119212448.GA29498@quack.suse.cz>
 <876251tg3b.fsf@devron.myhome.or.jp>
 <20121121011111.GE10507@quack.suse.cz>
 <20121121014851.GH10507@quack.suse.cz>
 <20121121000533.a0ab9eea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121000533.a0ab9eea.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:05:33AM -0800, Andrew Morton wrote:
> On Wed, 21 Nov 2012 02:48:51 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > +/*
> > + * Add inode to LRU if needed (inode is unused and clean).
> > + *
> > + * Needs inode->i_lock held.
> > + */
> > +void inode_add_lru(struct inode *inode)
> > +{
> > +	if (!(inode->i_state & (I_DIRTY | I_FREEING | I_SYNC)) &&
> > +	    !atomic_read(&inode->i_count) && inode->i_sb->s_flags & MS_ACTIVE)
> > +		inode_lru_list_add(inode);
> > +}
> 
> Is i_lock sufficient to stabilise i_count?
> 
> <looks at the code a bit>
> 
> Is evict_inodes() wrong to test i_count outside i_lock?
> 
> invalidate_inodes() looks better.
> 
> can_unuse() must be called under i_lock, and is.  Apparently this
> requirement was sufficiently obvious to not meed documenting.

It is documented. can_unuse looks at i_state and i_count, and both
are documented as requiring the i_lock at the top of the file in
the locking rules section. Also, see __iget(), also mentioned in
the locking rules....

> prune_icache_sb() gets it right.
> 
> iput() gets it right.
> 
> So to answer my own question: yes, it is sufficient.  But a) the
> comment for inode.i_lock is out of date

If you means the one in fs.h, then yeah, it's way out of date....
>
> and b) evict_inodes() looks
> fishy.

As I understand it, evict_inodes() is special - it's only called
from generic_shutdown_super() after the MS_ACTIVE flag has been
removed from the filesytem, the dcache has been pruned and all the
inodes cleaned. So there should be no new references to the inodes
occurring, and hence we don't need to hold the lock to serialise
against new references being taken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
