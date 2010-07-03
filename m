Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0GCFHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 01:07:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:53614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0GCFHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 01:07:10 -0400
Date: Sat, 3 Jul 2010 15:06:52 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100703050652.GF11732@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
 <20100703034123.GE11732@laptop>
 <20100702213149.f0ca2f72.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702213149.f0ca2f72.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 09:31:49PM -0700, Andrew Morton wrote:
> On Sat, 3 Jul 2010 13:41:23 +1000 Nick Piggin <npiggin@suse.de> wrote:
> > On Fri, Jul 02, 2010 at 07:03:55PM -0700, Andrew Morton wrote:
> > > um, nesting a kernel-wide singleton lock inside a per-inode lock is
> > > plain nutty.
> > 
> > I think it worked out OK. Because the kernel-wide locks are really
> > restricted in where they are to be used (ie. not in filesystems). So
> > they're really pretty constrained to the inode management subsystem.
> > So filesystems still get to really use i_lock as an inner most lock
> > for their purposes.
> > 
> > And filesystems get to take i_lock and stop all manipulation of inode
> > now.  No changing of flags, moving it on/off lists etc behind its back.
> > It really is about locking the data rather than the code.
> > 
> > The final ordering outcome looks like this:
> > 
> >  * inode->i_lock
> >  *   inode_list_lglock
> >  *   zone->inode_lru_lock
> >  *   wb->b_lock
> >  *   inode_hash_bucket lock
> 
> Apart from the conceptual vandalism, it means that any contention times
> and cache transfer times on those singleton locks will increase
> worst-case hold times of our nice, fine-grained i_lock.  

Yes you are quite right about contention times. I'll answer in
two parts. First, why I don't think it should prove to be a big
problem; second, what we can do to improve it if it does.

So a lot of things that previously required the much worse inode_lock
now can use the i_lock (or other fine grained locks above). Also, the
the contention only comes into play if we actually happen to hit the
same i_lock at the same time, so the throughput oriented mainline
should generally be OK, and -rt has priority inheretance that improves
that situation.

IF this proves to be a problem --  I doubt it will, in fact I think that
worst case contention experienced by filesystems and vfs will go down,
significantly -- but if it is a problem, we can easily fix it up.

Because all of those above data structures can be traversed using RCU
(hash list already is). That would make all the locks really only taken
to put an inode on or off a list.

The other thing that can be trivially done is to introduce different
locks. I don't have a problem with that, but like any other data
structure, I just would like to wait and see where we have problems.
The same argument applies to a lot of places that we use a single lock
to lock different properties of an object. We use page_lock to protect
page membership on or off LRU and pagecache lists for example, as well
as various state transitions (eg. to writeback).

In summary, if there is a lock hold problem, it is easy to use RCU to
reduce lock widths, or introduce a new per-inode lock to protect
different parts of the inode structure.


> > And it works like that because when you want to add or remove an inode
> > from various data structures, you take the i_lock
> 
> Well that would be wrong.  i_lock protects things *within* its inode. 
> It's nonsensical to take i_lock when the inode is being added to or
> removed from external containers because i_lock doesn't protect those
> containers!

Membership in a data structure is a property of the item, conceptually
and literally when you're messing with list entries and such. There is
no conceptual vandalism that I can tell.

And it just works better this way when lifting inode_lock (and
dcache_lock). Currently, we do things like:

spin_lock(&inode_lock);
add_to_list1
add_to_list2
inode->blah = something
spin_unlock(&inode_lock);

If you lock list1, list2, and blah seperately, it is no longer an
equivalent transformation: other code could find an inode on list1 that
is now not on list2 and blah is not set.

The real data object of interest in all cases is the inode object.
Other structures are just in aid of finding inode objects that have
a particular property.

So it makes a lot of sense to have a lock to rule the inode (as opposed
to now we have a lock to rule *all* inodes).

It is possible that locking can be reduced if some things are verified
and carefully shown not to matter. I just don't see the need yet and it
would make things overly complicated I think. Introducing any more
complexity will sink this patchset.


> > and then take each
> > of these locks in turn, inside it. The alternative is to build a bigger
> > lock ordering graph, and take all the locks up-front before taking
> > i_lock. I did actaully try that and it ended up being worse, so I went
> > this route.
> > 
> > I think taking a global lock in mark_inode_dirty is nutty (especially
> > when that global lock is shared with hash management, LRU scanning,
> > writeback, i_flags access... :) It's just a question of which is less
> > nutty.
> 
> Yes, inode_lock is bad news.

Hopefully not for long :)

