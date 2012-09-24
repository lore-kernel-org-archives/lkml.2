Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2IXGMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:12:19 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36571 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2IXGMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:12:17 -0400
Date: Mon, 24 Sep 2012 14:12:05 +0800
From: Guo Chao <yan@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120924061205.GA27244@yanx>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
 <20120921224912.GA20960@dastard>
 <20120924024221.GB7984@yanx>
 <20120924042343.GC20960@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924042343.GC20960@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092406-5564-0000-0000-00000496C1DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:23:43PM +1000, Dave Chinner wrote:
> On Mon, Sep 24, 2012 at 10:42:21AM +0800, Guo Chao wrote:
> > On Sat, Sep 22, 2012 at 08:49:12AM +1000, Dave Chinner wrote:
> > 
> > > On Fri, Sep 21, 2012 at 05:31:02PM +0800, Guo Chao wrote:
> > > > This patchset optimizes several places which take the per inode spin lock.
> > > > They have not been fully tested yet, thus they are marked as RFC. 
> > > 
> > > Inodes are RCU freed. The i_lock spinlock on the i_state field forms
> > > part of the memory barrier that allows the RCU read side to
> > > correctly detect a freed inode during a RCU protected cache lookup
> > > (hash list traversal for the VFS, or a radix tree traversal for XFS).
> > > The i_lock usage around the hahs list operations ensures the hash
> > > list operations are atomic with state changes so that such changes
> > > are correctly detected during RCU-protected traversals...
> > > 
> > > IOWs, removing the i_lock from around the i_state transitions and
> > > inode hash insert/remove/traversal operations will cause races in
> > > the RCU lookups and result in incorrectly using freed inodes instead
> > > of failing the lookup and creating a new one.
> > > 
> > > So I don't think this is a good idea at all...
> > >
> > 
> > Hello, Dave:
> > 
> >   Thanks for your explanation.
> >  
> >   Though I can't fully understand it, your concern seems to be that
> > RCU inode lookup will be bothered by this change. But we do not have 
> > RCU inode lookup in VFS: inode lookup is done by rather a tranditional
> > way. 
> 
> Ah, I'd forgotten that neither of these RCU-based lookups ever got
> merged:
> 
> https://lkml.org/lkml/2010/6/23/397
> http://thread.gmane.org/gmane.linux.kernel/1056494
> 
> That, however, is the approach that the inode caches shoul dbe
> moving towards - RCU lookups to reduce locking, not changing
> i_lock/i_state atomicity that has been designed to facilitate RCU
> safe lookups...
> 
> >   XFS gives me the impression that it implements its own inode cache.
> > There may be such thing there. I have little knowledge on XFS, but I
> > guess it's unlikely impacted by the change of code implementing VFS 
> > inode cache.
> 
> Yeah, I dropped the generic inode hash RCU conversion - the
> SLAB_DESTROY_BY_RCU was proving to be rather complex, and I didn't
> have any motiviation to see it through because I'd already converted
> XFs to avoid the global inode_hash_lock and use RCU lookups on it's
> internal inode cache...
> 
> >   As far as I can see, RCU inode free is for RCU dentry lookup, which
> > seems have nothing to do with 'detect a freed inode'.
> 
> If you know nothing of the history of this, then it might seem that
> way
> 
> > Taking i_lock in these
> > places looks like to me a result of following old lock scheme blindly when 
> > breaking the big global inode lock.
> 
> The i_state/i_hash_list/i_lock relationship was created specifically
> during the inode_lock breakup to allow us to guarantee that certain
> fields of the inode are unchanging without needing to take multiple
> nested locks:
> 
> $ gl -n 1 250df6e
> commit 250df6ed274d767da844a5d9f05720b804240197
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Mar 22 22:23:36 2011 +1100
> 
>     fs: protect inode->i_state with inode->i_lock
>     
>     Protect inode state transitions and validity checks with the
>     inode->i_lock. This enables us to make inode state transitions
>     independently of the inode_lock and is the first step to peeling
>     away the inode_lock from the code.
>     
>     This requires that __iget() is done atomically with i_state checks
>     during list traversals so that we don't race with another thread
>     marking the inode I_FREEING between the state check and grabbing the
>     reference.
>     
>     Also remove the unlock_new_inode() memory barrier optimisation
>     required to avoid taking the inode_lock when clearing I_NEW.
>     Simplify the code by simply taking the inode->i_lock around the
>     state change and wakeup. Because the wakeup is no longer tricky,
>     remove the wake_up_inode() function and open code the wakeup where
>     necessary.
>     
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> The inode hash lookup needs to check i_state atomically during the
> traversal so inodes being freed are skipped (e.g. I_FREEING,
> I_WILL_FREE). those i_state flags are set only with the i_lock held,
> and so inode hash lookups need to take the i_lock to guarantee the
> i_state field is correct. This inode data field synchronisation is
> separate to the cache hash list traversal protection.
> 
> The only way to do this is to have an inner lock (inode->i_lock)
> that protects both the inode->i_hash_list and inode->i_state fields,
> and a lock order that provides outer list traversal protections
> (inode_hash_lock). Whether the outer lock is the inode_hash_lock or
> rcu_read_lock(), the lock order and the data fields the locks are
> protecting are the same....
> 
> > Of course, maybe they are there for something. Could you speak
> > more about the race this change (patch 1,2?) brings up? Thank you.
> 
> When you drop the lock from the i_state initialisation, you end up
> dropping the implicit unlock->lock memory barrier that the
> inode->i_lock provides. i.e. you get this in iget_locked():
> 
> 
> 	thread 1			thread 2
> 
> 	lock(inode_hash_lock)
> 	for_each_hash_item()
> 
> 					inode->i_state = I_NEW
> 					hash_list_insert
> 
> 	<finds newly inserted inode>
> 		lock(inode->i_lock)
> 		unlock(inode->i_lock)
> 	unlock(inode_hash_lock)
> 
> 	wait_on_inode()
> 		<see inode->i_state = 0 >
> 		<uses inode before initialisation
> 		 is complete>
> 
> IOWs, there is no unlock->lock transition occurring on any lock, so
> there are no implicit memory barriers in this code, and so other
> CPUs are not guaranteed to see the "inode->i_state = I_NEW" write
> that thread 2 did. The lock/unlock pair around this I_NEW assignment
> guarantees that thread 1 will see the change to i_state correctly.
> 
> So even without RCU, dropping the i_lock from these
> i_state/hash insert/remove operations will result in races
> occurring...
> 

This interleave can never happen because of inode_hash_lock. I_NEW will 
not be missed by other CPUs in the same sense: though inode is put onto
the hash list, it cannot be accessed by others before inode_hash_lock 
is freed.

> Seriously, if you want to improve the locking of this code, go back
> an resurrect the basic RCU hash traversal patches (i.e. Nick's
> original patch rather than my SLAB_DESTROY_BY_RCU based ones). That
> has much more benefit to many more workloads than just removing a
> non-global, uncontended locks like this patch set does.
> 

Ah, this is intended to be a code clean patchset actually. I thought these
locks are redundant in an obvious and trivial manner. If, on the contrary, 
they are such tricky, then never mind :) Thanks for your patient.

Regards,
Guo Chao


