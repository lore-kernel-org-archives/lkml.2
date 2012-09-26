Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2IZAyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:54:16 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11804 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab2IZAyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:54:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtANABFRYlB5LGEv/2dsb2JhbAA9CIUiuDsCAYEMgQmCIAEBBAEnExwjBQsIAw4KLhQlAyETh38FuWAUiwYWbYFDg3wDiz2KKIZQiVmCeQ
Date: Wed, 26 Sep 2012 10:54:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120926005409.GG29154@dastard>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
 <20120921224912.GA20960@dastard>
 <20120924024221.GB7984@yanx>
 <20120924042343.GC20960@dastard>
 <20120924061205.GA27244@yanx>
 <20120924062812.GD20960@dastard>
 <20120924070852.GA10280@yanx>
 <20120924082654.GG20960@dastard>
 <20120925085955.GA15073@yanx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925085955.GA15073@yanx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:59:55PM +0800, Guo Chao wrote:
> On Mon, Sep 24, 2012 at 06:26:54PM +1000, Dave Chinner wrote:
> > @@ -783,14 +783,19 @@ static void __wait_on_freeing_inode(struct inode *inode);
> >  static struct inode *find_inode(struct super_block *sb,
> >  				struct hlist_head *head,
> >  				int (*test)(struct inode *, void *),
> > -				void *data)
> > +				void *data, bool locked)
> >  {
> >  	struct hlist_node *node;
> >  	struct inode *inode = NULL;
> > 
> >  repeat:
> > -	hlist_for_each_entry(inode, node, head, i_hash) {
> > +	rcu_read_lock();
> > +	hlist_for_each_entry_rcu(inode, node, head, i_hash) {
> >  		spin_lock(&inode->i_lock);
> > +		if (inode_unhashed(inode)) {
> > +			spin_unlock(&inode->i_lock);
> > +			continue;
> > +		}
> 
> Is this check too early? If the unhashed inode happened to be the target
> inode, we are wasting our time to continue the traversal and we do not wait 
> on it.

If the inode is unhashed, then it is already passing through evict()
or has already passed through. If it has already passed through
evict() then it is too late to call __wait_on_freeing_inode() as the
wakeup occurs in evict() immediately after the inode is removed
from the hash. i.e:

        remove_inode_hash(inode);

        spin_lock(&inode->i_lock);
        wake_up_bit(&inode->i_state, __I_NEW);
        BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
        spin_unlock(&inode->i_lock);

i.e. if we get the case:

Thread 1, RCU hash traversal		Thread 2, evicting foo

rcu_read_lock()
found inode foo
					remove_inode_hash(inode);
					spin_lock(&foo->i_lock);
					wake_up(I_NEW)
					spin_unlock(&foo->i_lock);
					destroy_inode()
					......
	spin_lock(foo->i_lock)
	match sb, ino
	I_FREEING
	  rcu_read_unlock()

<rcu grace period can expire at any time now,
 so use after free is guaranteed at some point>

	  wait_on_freeing_inode
	    wait_on_bit(I_NEW)

<will never get woken>

Hence if the inode is unhashed, it doesn't matter what inode it is,
it is never valid to use it any further because it may have already
been freed and the only reason we can safely access here it is that
the RCU grace period will not expire until we call
rcu_read_unlock().

> > @@ -1078,8 +1098,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
> >  		struct inode *old;
> > 
> >  		spin_lock(&inode_hash_lock);
> > -		/* We released the lock, so.. */
> > -		old = find_inode_fast(sb, head, ino);
> > +		old = find_inode_fast(sb, head, ino, true);
> >  		if (!old) {
> >  			inode->i_ino = ino;
> >  			spin_lock(&inode->i_lock);
> 
> Emmmm ... couldn't we use memory barrier API instead of irrelevant spin
> lock on newly allocated inode to publish I_NEW?

Yes, we could.

However, having multiple synchronisation methods for a single
variable that should only be used in certain circumstances is
something that is easy to misunderstand and get wrong. Memory
barriers are much more subtle and harder to understand than spin
locks, and every memory barrier needs to be commented to explain
what the barrier is actually protecting against.

In the case where a spin lock is guaranteed to be uncontended and
the cache line hot in the CPU cache, it makes no sense to replace
the spin lock with a memory barrier, especially when every other
place we modify the i_state/i_hash fields we have to wrap them
with i_lock....

Simple code is good code - save the complexity for something that
needs it.

> I go through many mails of the last trend of scaling VFS. Many patches
> seem quite natural, say RCU inode lookup

Sure, but the implementation in those RCU lookup patches sucked.

> or per-bucket inode hash lock or 

It was a bad idea. At minimum, you can't use lockdep on it. Worse
for the realtime guys is the fact it can't be converted to a
sleeping lock. Worst was the refusal to change it in any way to
address concerns.

And realistically, the fundamental problem is not with the
inode_hash_lock, it's with the fact that the cache is based on a
hash table rather than a more scalable structure like a radix tree
or btree. This is a primary reason for XFS having it's own inode
cache - hashes can only hold a certain number of entries before
performance collapses catastrophically and so don't scale well to
tens or hundreds of millions of entries.....

> per-superblock inode list lock,

Because it isn't a particularly hot lock, and given that
most workloads hit on a single filesystem, scalability is not
improved by making this change. As such, as long as there is a
single linked list used to iterate all inodes in the superblock,
a single lock is as good as scalability will get....

> did not get merged. I wonder what stopped them back then and what
> has changed that (part of) them can be considered again.

A decent RCU inode hash walk implementation is needed, mainly for
NFS servers as filehandle decode is really the only application that
can drive serious lookup concurrency on the inode hash as the dentry
cache handles all other lookup concurrency paths.

Modifying any of the other inode/dentry locking requires profiles
that show the lock is a scalability problem and that the change
makes it go away.

I know that the per-sb inode lru lock is currently the hotest of the
inode cache locks (performance limiting at somewhere in the range of
8-16way workloads on XFS), and I've got work in (slow) progress to
address that.  That work will also the address the per-sb dentry LRU
locks, which are the hotest dentry cache locks as well.

The only other heavily contended lock that I remember for
filesystems other than XFS is the per-bdi writeback list_lock. It is
hot on ext4 under heavy metadata workloads. XFS avoids that problem
by completely avoiding the bdi inode writeback lists for inodes that
are only metadata dirty....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
