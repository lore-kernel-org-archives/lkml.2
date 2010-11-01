Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0KANpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:45:12 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:46193 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757756Ab0KANpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:45:11 -0400
Date: Tue, 2 Nov 2010 00:44:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] fs: rcu protect inode hash lookups
Message-ID: <20101101134451.GN2715@dastard>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
 <1288589624-15251-4-git-send-email-david@fromorbit.com>
 <1288604287.2660.94.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288604287.2660.94.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 10:38:07AM +0100, Eric Dumazet wrote:
> Le lundi 01 novembre 2010 à 16:33 +1100, Dave Chinner a écrit :
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that inodes are using RCU freeing, we can walk the hash lists
> > using RCU protection during lookups. Convert all the hash list
> > operations to use RCU-based operators and drop the inode_hash_lock
> > around pure lookup operations.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> You probably should copy Paul on this stuff, I added him in Cc, because
> SLAB_DESTROY_BY_RCU is really tricky, and Paul review is a must.
>
> >  repeat:
> > +	rcu_read_lock();
> >  	hlist_for_each_entry(inode, node, head, i_hash) {
> >  		if (inode->i_sb != sb)
> >  			continue;
> >  		if (!test(inode, data))
> >  			continue;
> >  		spin_lock(&inode->i_lock);
> 
> Problem with SLAB_DESTROY_BY_RCU is the inode can be freed, and reused
> immediately (no grace period) by another cpu.
> 
> So you need to recheck test(inode, data) _after_ getting a stable
> reference on the inode (spin_lock() in this case), to make sure you
> indeed found the inode you are looking for, not another one.

Possibly. The test callback is a private callback to determine if,
indeed, it is the inode the caller is looking for. I need to do a
deeper look into what ordering is required for this callback.

> The test on inode->i_sb != sb can be omitted, _if_ each sb has its own
> kmem_cache (but I am not sure, please check if this is the case)

There's a slab cache per filesystem type, not per filesystem, so the
check is necessary.

> Also, you should make sure the allocation of inode is careful of not
> overwriting some fields (the i_lock in particular), since you could
> break a concurrent lookup. This is really tricky, you cannot use
> spin_lock_init(&inode->i_lock) anymore in inode_init_always().

Yes, I missed that one. Good catch.  I'm used to the XFS code where
most locks are initialised only once in the slab constructor....

The other fields of note:

	i_sb: overwritten in inode_init_always(). Should be safe
	simply by rechecking after validating the inode is not in
	the freed state as you suggest.
	i_ino: overwritten just before the inode is re-inserted into
	the hash. redo check like i_sb.
	i_state: initialised atomically with hash insert via i_lock.
	i_hash: inserted into hash list under i_lock

My intent is that the i_state/i_hash atomicity acts as the real
guard against reusing a freed inode, but you are right that the
other fields needs to be rechecked for validity after establishing
that it is not a freed inode.

> You can read Documentation/RCU/rculist_nulls.txt for some doc I wrote
> when adding SLAB_DESTROY_BY_RCU to UDP/TCP sockets. Sockets stable

Perhaps you should rename that file "slab_destroy_by_rcu-tips.txt",
because the current name seems unrelated to the contents. :/

> reference is not a spinlock, but a refcount, so it was easier to init
> this refcount. With a spinlock, I believe you might need to use SLAB
> constructor, to initialize the spinlock only on fresh objects, not on
> reused ones.

Yeah, that is what I intended.

Thanks for the comments, Eric.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
