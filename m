Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2IXG2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:28:45 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56162 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946Ab2IXG2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:28:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAN78X1B5Lafp/2dsb2JhbABFvSMDgQaBCYIgAQEEAScTHCMQCAMOCi4UJQMhE4d/Bbg6FIsIfIROYAOSNIMwkCSCeQ
Date: Mon, 24 Sep 2012 16:28:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120924062812.GD20960@dastard>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
 <20120921224912.GA20960@dastard>
 <20120924024221.GB7984@yanx>
 <20120924042343.GC20960@dastard>
 <20120924061205.GA27244@yanx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924061205.GA27244@yanx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:12:05PM +0800, Guo Chao wrote:
> On Mon, Sep 24, 2012 at 02:23:43PM +1000, Dave Chinner wrote:
> > On Mon, Sep 24, 2012 at 10:42:21AM +0800, Guo Chao wrote:
> > > On Sat, Sep 22, 2012 at 08:49:12AM +1000, Dave Chinner wrote:
> > > 
> > > > On Fri, Sep 21, 2012 at 05:31:02PM +0800, Guo Chao wrote:
> > > > > This patchset optimizes several places which take the per inode spin lock.
> > > > > They have not been fully tested yet, thus they are marked as RFC. 
> > > > 
> > > > Inodes are RCU freed. The i_lock spinlock on the i_state field forms
> > > > part of the memory barrier that allows the RCU read side to
> > > > correctly detect a freed inode during a RCU protected cache lookup
> > > > (hash list traversal for the VFS, or a radix tree traversal for XFS).
> > > > The i_lock usage around the hahs list operations ensures the hash
> > > > list operations are atomic with state changes so that such changes
> > > > are correctly detected during RCU-protected traversals...
> > > > 
> > > > IOWs, removing the i_lock from around the i_state transitions and
> > > > inode hash insert/remove/traversal operations will cause races in
> > > > the RCU lookups and result in incorrectly using freed inodes instead
> > > > of failing the lookup and creating a new one.
> > > > 
> > > > So I don't think this is a good idea at all...
.....
> > The inode hash lookup needs to check i_state atomically during the
> > traversal so inodes being freed are skipped (e.g. I_FREEING,
> > I_WILL_FREE). those i_state flags are set only with the i_lock held,
> > and so inode hash lookups need to take the i_lock to guarantee the
> > i_state field is correct. This inode data field synchronisation is
> > separate to the cache hash list traversal protection.
> > 
> > The only way to do this is to have an inner lock (inode->i_lock)
> > that protects both the inode->i_hash_list and inode->i_state fields,
> > and a lock order that provides outer list traversal protections
> > (inode_hash_lock). Whether the outer lock is the inode_hash_lock or
> > rcu_read_lock(), the lock order and the data fields the locks are
> > protecting are the same....
> > 
> > > Of course, maybe they are there for something. Could you speak
> > > more about the race this change (patch 1,2?) brings up? Thank you.
> > 
> > When you drop the lock from the i_state initialisation, you end up
> > dropping the implicit unlock->lock memory barrier that the
> > inode->i_lock provides. i.e. you get this in iget_locked():
> > 
> > 
> > 	thread 1			thread 2
> > 
> > 	lock(inode_hash_lock)
> > 	for_each_hash_item()
> > 
> > 					inode->i_state = I_NEW
> > 					hash_list_insert
> > 
> > 	<finds newly inserted inode>
> > 		lock(inode->i_lock)
> > 		unlock(inode->i_lock)
> > 	unlock(inode_hash_lock)
> > 
> > 	wait_on_inode()
> > 		<see inode->i_state = 0 >
> > 		<uses inode before initialisation
> > 		 is complete>
> > 
> > IOWs, there is no unlock->lock transition occurring on any lock, so
> > there are no implicit memory barriers in this code, and so other
> > CPUs are not guaranteed to see the "inode->i_state = I_NEW" write
> > that thread 2 did. The lock/unlock pair around this I_NEW assignment
> > guarantees that thread 1 will see the change to i_state correctly.
> > 
> > So even without RCU, dropping the i_lock from these
> > i_state/hash insert/remove operations will result in races
> > occurring...
>
> This interleave can never happen because of inode_hash_lock.

Ah, sorry, I'm context switching too much right now.

s/lock(inode_hash_lock)/rcu_read_lock.

And that's the race condition the the locking order is *intended* to
avoid. It's just that we haven't done the last piece of the work,
which is replacing the read side inode_hash_lock usage with
rcu_read_lock.

> > Seriously, if you want to improve the locking of this code, go back
> > an resurrect the basic RCU hash traversal patches (i.e. Nick's
> > original patch rather than my SLAB_DESTROY_BY_RCU based ones). That
> > has much more benefit to many more workloads than just removing a
> > non-global, uncontended locks like this patch set does.
> > 
> 
> Ah, this is intended to be a code clean patchset actually. I thought these
> locks are redundant in an obvious and trivial manner. If, on the contrary, 
> they are such tricky, then never mind :) Thanks for your patient.

The RCU conversion is actually trivial - everything is already set
up for it to be done, and is simpler than this patch set. It pretty
much is simply replacing all the read side inode_hash_lock pairs
with rcu_read_lock()/rcu_read_unlock() pairs. Like I said, if you
want to clean up this code, then RCU traversals are the conversion
to make.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
