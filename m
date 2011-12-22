Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1LVP4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:56:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab1LVP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:56:04 -0500
Date: Thu, 22 Dec 2011 10:20:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-ID: <20111222152009.GB1388@redhat.com>
References: <20111222001800.GL9213@google.com>
 <20111222001939.GM9213@google.com>
 <20111222004629.GO9213@google.com>
 <20111221170919.f7d49fc6.akpm@linux-foundation.org>
 <20111222012312.GP9213@google.com>
 <20111222151529.GA1388@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222151529.GA1388@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:15:29AM -0500, Vivek Goyal wrote:
> On Wed, Dec 21, 2011 at 05:23:12PM -0800, Tejun Heo wrote:
> > Hello, Andrew.
> > 
> > On Wed, Dec 21, 2011 at 05:09:19PM -0800, Andrew Morton wrote:
> > > If the pool is empty and the memory allocator is down into its
> > > emergency reserves then we have:
> > > 
> > > Old behaviour: Wait for someone to return an item, then retry
> > > 
> > > New behaviour: enable page reclaim in gfp_mask, retry a
> > >                single time then wait for someone to return an item.
> > > 
> > > So what we can expect to see is that in this low-memory situation,
> > > mempool_alloc() will perform a lot more page reclaim, and more mempool
> > > items will be let loose into the kernel.
> > > 
> > > I'm not sure what the effects of this will be.  I can't immediately
> > > point at any bad ones.  Probably not much, as the mempool_alloc()
> > > caller will probably be doing other allocations, using the
> > > reclaim-permitting gfp_mask.
> > > 
> > > But I have painful memories of us (me and Jens, iirc) churning this
> > > code over and over again until it stopped causing problems.  Some were
> > > subtle and nasty.  Much dumpster diving into the pre-git changelogs
> > > should be done before changing it, lest we rediscover long-fixed
> > > problems :(
> > 
> > I see.  It just seemed like a weird behavior and looking at the commit
> > log, there was originally code to kick reclaim there, so the sequence
> > made sense - first try w/o reclaim, look at the mempool, kick reclaim
> > and retry w/ GFP_WAIT and then wait for someone else to free.  That
> > part was removed by 20a77776c24 "[PATCH] mempool: simplify alloc" back
> > in 05.  In the process, it also lost retry w/ reclaim before waiting
> > for mempool reserves.
> > 
> > I was trying to add percpu mempool and this bit me as percpu allocator
> > can't to NOIO and the above delayed retry logic ended up adding random
> > 5s delay (or until the next free).
> > 
> 
> Tejun,
> 
> For blkio to use these percpu mempool, I guess we shall have to change this
> notion that an allocated object from mempool is returned to the pool soon.
> We might not be returning these per cpu stat objects to mempool for a very
> long time (These will be returned to pool only when somebody deletes the
> cgroup).

Hi Tejun,

Also mempool expects all the objects to be returned to the pool at the
time of destroy. Given the fact that blkio groups are reference counted,
theoritically they can be freed later.

I was playing a bit with maintaining a pool of blkio group objects. I
ran into the issue of blkio group not having any pointer to request
queue or cfqd as that is required to retrieve the pool pointer to which
this object has to go. Stashing pointer in blkio group then brings back
the issue of reference on queue or cfqd etc. So that makes it no simpler
then my current implementation. So I gave up.

Thanks
Vivek
