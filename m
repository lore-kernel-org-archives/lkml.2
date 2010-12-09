Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0LIG2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:28:10 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:60662 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab0LIG2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:28:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJMEAE15LdBk/2dsb2JhbACjbHnAAYVJBA
Date: Thu, 9 Dec 2010 17:28:01 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101209062801.GA3749@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209060911.GB8259@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 05:09:11PM +1100, Dave Chinner wrote:
> On Sat, Nov 27, 2010 at 08:44:41PM +1100, Nick Piggin wrote:
> > Add a new lock, dcache_hash_lock, to protect the dcache hash table from
> > concurrent modification. d_hash is also protected by d_lock.
> > 
> > Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> > ---
> >  fs/dcache.c            |   38 +++++++++++++++++++++++++++-----------
> >  include/linux/dcache.h |    3 +++
> >  2 files changed, 30 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 4f9ccbe..50c65c7 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -35,12 +35,27 @@
> >  #include <linux/hardirq.h>
> >  #include "internal.h"
> >  
> > +/*
> > + * Usage:
> > + * dcache_hash_lock protects dcache hash table
> > + *
> > + * Ordering:
> > + * dcache_lock
> > + *   dentry->d_lock
> > + *     dcache_hash_lock
> > + *
> 
> What locking is used to keep DCACHE_UNHASHED/d_unhashed() in check
> with the whether the dentry is on the hash list or not? It looks to
> me that to make any hash modification, you have to hold both the
> dentry->d_lock and the dcache_hash_lock to keep them in step. If
> this is correct, can you add this to the comments above?

No, dcache_lock still does that. d_unhashed is protected with
d_lock a few patches later, which adds to the comment.

 
> > + * if (dentry1 < dentry2)
> > + *   dentry1->d_lock
> > + *     dentry2->d_lock
> > + */
> 
> Perhaps the places where we need to lock two dentries should use a
> wrapper like we do for other objects. Such as:
> 
> void dentry_dlock_two(struct dentry *d1, struct dentry *d2)
> {
> 	if (d1 < d2) {
> 		spin_lock(&d1->d_lock);
> 		spin_lock_nested(&d2->d_lock, DENTRY_D_LOCK_NESTED);
> 	} else {
> 		spin_lock(&d2->d_lock);
> 		spin_lock_nested(&d1->d_lock, DENTRY_D_LOCK_NESTED);
> 	}
> }

It only happens once in rename, so I don't think it's useful.
Nothing outside core code should be locking 2 unrelated dentries.

 
> > @@ -1581,7 +1598,9 @@ void d_rehash(struct dentry * entry)
> >  {
> >  	spin_lock(&dcache_lock);
> >  	spin_lock(&entry->d_lock);
> > +	spin_lock(&dcache_hash_lock);
> >  	_d_rehash(entry);
> > +	spin_unlock(&dcache_hash_lock);
> >  	spin_unlock(&entry->d_lock);
> >  	spin_unlock(&dcache_lock);
> >  }
> 
> Shouldn't we really kill _d_rehash() by replacing all the callers
> with direct calls to __d_rehash() first? There doesn't seem to be much
> sense to keep both methods around....

No. Several filesystems are using it, and it's an exported symbol. I'm
focusing on changed to locking, and keeping APIs the same, where
possible. I don't want just more and more depencendies on pushing
through filesystem changes before this series.

Like I said, there are infinite cleanups or improvements you can make.
It does not particularly matter that they happen before or after the
scaling work, except if there are classes of APIs that the new locking
model can no longer support.

 
> > @@ -1661,8 +1680,6 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
> >   */
> >  static void d_move_locked(struct dentry * dentry, struct dentry * target)
> >  {
> > -	struct hlist_head *list;
> > -
> >  	if (!dentry->d_inode)
> >  		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
> >  
> > @@ -1679,14 +1696,11 @@ static void d_move_locked(struct dentry * dentry, struct dentry * target)
> >  	}
> >  
> >  	/* Move the dentry to the target hash queue, if on different bucket */
> > -	if (d_unhashed(dentry))
> > -		goto already_unhashed;
> > -
> > -	hlist_del_rcu(&dentry->d_hash);
> > -
> > -already_unhashed:
> > -	list = d_hash(target->d_parent, target->d_name.hash);
> > -	__d_rehash(dentry, list);
> > +	spin_lock(&dcache_hash_lock);
> > +	if (!d_unhashed(dentry))
> > +		hlist_del_rcu(&dentry->d_hash);
> > +	__d_rehash(dentry, d_hash(target->d_parent, target->d_name.hash));
> > +	spin_unlock(&dcache_hash_lock);
> >  
> >  	/* Unhash the target: dput() will then get rid of it */
> >  	__d_drop(target);
> > @@ -1883,7 +1897,9 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
> >  found_lock:
> >  	spin_lock(&actual->d_lock);
> >  found:
> > +	spin_lock(&dcache_hash_lock);
> >  	_d_rehash(actual);
> > +	spin_unlock(&dcache_hash_lock);
> >  	spin_unlock(&actual->d_lock);
> >  	spin_unlock(&dcache_lock);
> >  out_nolock:
> > diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> > index 6b5760b..7ce20f5 100644
> > --- a/include/linux/dcache.h
> > +++ b/include/linux/dcache.h
> > @@ -181,6 +181,7 @@ struct dentry_operations {
> >  
> >  #define DCACHE_CANT_MOUNT	0x0100
> >  
> > +extern spinlock_t dcache_hash_lock;
> >  extern spinlock_t dcache_lock;
> >  extern seqlock_t rename_lock;
> >  
> > @@ -204,7 +205,9 @@ static inline void __d_drop(struct dentry *dentry)
> >  {
> >  	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
> >  		dentry->d_flags |= DCACHE_UNHASHED;
> > +		spin_lock(&dcache_hash_lock);
> >  		hlist_del_rcu(&dentry->d_hash);
> > +		spin_unlock(&dcache_hash_lock);
> >  	}
> >  }
> 
> Un-inline __d_drop so you don't need to make the dcache_hash_lock
> visible outside of fs/dcache.c. That happens later in the series
> anyway, so may as well do it now...

Yeah that makes sense.

Thanks,
Nick

