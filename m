Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0LIISN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:18:13 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:53435 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754197Ab0LIISL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:18:11 -0500
Date: Thu, 9 Dec 2010 19:17:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101209081756.GE8259@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
 <20101209062801.GA3749@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209062801.GA3749@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 05:28:01PM +1100, Nick Piggin wrote:
> On Thu, Dec 09, 2010 at 05:09:11PM +1100, Dave Chinner wrote:
> > On Sat, Nov 27, 2010 at 08:44:41PM +1100, Nick Piggin wrote:
> > > Add a new lock, dcache_hash_lock, to protect the dcache hash table from
> > > concurrent modification. d_hash is also protected by d_lock.
> > > 
> > > Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> > > ---
> > >  fs/dcache.c            |   38 +++++++++++++++++++++++++++-----------
> > >  include/linux/dcache.h |    3 +++
> > >  2 files changed, 30 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/dcache.c b/fs/dcache.c
> > > index 4f9ccbe..50c65c7 100644
> > > --- a/fs/dcache.c
> > > +++ b/fs/dcache.c
> > > @@ -35,12 +35,27 @@
> > >  #include <linux/hardirq.h>
> > >  #include "internal.h"
> > >  
> > > +/*
> > > + * Usage:
> > > + * dcache_hash_lock protects dcache hash table
> > > + *
> > > + * Ordering:
> > > + * dcache_lock
> > > + *   dentry->d_lock
> > > + *     dcache_hash_lock
> > > + *
> > 
> > What locking is used to keep DCACHE_UNHASHED/d_unhashed() in check
> > with the whether the dentry is on the hash list or not? It looks to
> > me that to make any hash modification, you have to hold both the
> > dentry->d_lock and the dcache_hash_lock to keep them in step. If
> > this is correct, can you add this to the comments above?
> 
> No, dcache_lock still does that. d_unhashed is protected with
> d_lock a few patches later, which adds to the comment.

d_unhashed() is just a flag bit in ->d_flags, which is apparently
protected by ->d_lock in the next the LRU patch. I say apparently
because that patch doesn't appear to protect anything to do with
d_flags. I'm struggling to work out what is being protected in each
patch because it is not clearexactly what is being done.

It makes much more sense to me to start by making all access to
d_flags atomic (i.e. protected by ->d_lock) in a separate patch than
to do it hodge-podge across multiple patches as you currently are.
Its hard to follow when things that are intimately related are
separated by mutliple patches doing different things...


> > > + * if (dentry1 < dentry2)
> > > + *   dentry1->d_lock
> > > + *     dentry2->d_lock
> > > + */
> > 
> > Perhaps the places where we need to lock two dentries should use a
> > wrapper like we do for other objects. Such as:
> > 
> > void dentry_dlock_two(struct dentry *d1, struct dentry *d2)
> > {
> > 	if (d1 < d2) {
> > 		spin_lock(&d1->d_lock);
> > 		spin_lock_nested(&d2->d_lock, DENTRY_D_LOCK_NESTED);
> > 	} else {
> > 		spin_lock(&d2->d_lock);
> > 		spin_lock_nested(&d1->d_lock, DENTRY_D_LOCK_NESTED);
> > 	}
> > }
> 
> It only happens once in rename, so I don't think it's useful.

It is self documenting code, which does have value...

> Nothing outside core code should be locking 2 unrelated dentries.

So it is static.

> 
>  
> > > @@ -1581,7 +1598,9 @@ void d_rehash(struct dentry * entry)
> > >  {
> > >  	spin_lock(&dcache_lock);
> > >  	spin_lock(&entry->d_lock);
> > > +	spin_lock(&dcache_hash_lock);
> > >  	_d_rehash(entry);
> > > +	spin_unlock(&dcache_hash_lock);
> > >  	spin_unlock(&entry->d_lock);
> > >  	spin_unlock(&dcache_lock);
> > >  }
> > 
> > Shouldn't we really kill _d_rehash() by replacing all the callers
> > with direct calls to __d_rehash() first? There doesn't seem to be much
> > sense to keep both methods around....
> 
> No. Several filesystems are using it, and it's an exported symbol.

That's __d_rehash().

_d_rehash() (single underscore) is static and only called by
d_rehash() and d_materialise_unique() And is one line of code
calling __d_rehash(). Kill it, please.

> I'm
> focusing on changed to locking, and keeping APIs the same, where
> possible. I don't want just more and more depencendies on pushing
> through filesystem changes before this series.
> 
> Like I said, there are infinite cleanups or improvements you can make.
> It does not particularly matter that they happen before or after the
> scaling work, except if there are classes of APIs that the new locking
> model can no longer support.

We do plenty of cleanups when changing code when the result gives us
simpler and easier to understand code. It's a trivial change that,
IMO, makes the code more consistent and easier to follow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
