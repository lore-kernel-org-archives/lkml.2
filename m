Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0JNJLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:11:19 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11347 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062Ab0JNJLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:11:17 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2010 05:11:16 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD1jtkx5Lc/f/2dsb2JhbAChInK7bYJ+gkoEj0A
Date: Thu, 14 Oct 2010 20:06:09 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101014090609.GB3144@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013232319.GZ4681@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:23:19AM +1100, Dave Chinner wrote:
> On Wed, Oct 13, 2010 at 11:30:08PM +1100, Nick Piggin wrote:
> > On Wed, Oct 13, 2010 at 07:25:52AM -0400, Christoph Hellwig wrote:
> > > On Wed, Oct 13, 2010 at 06:20:58PM +1100, Nick Piggin wrote:
> > > > Unfortunate timing that everybody is suddenly interested in the
> > > > scalability work :)
> > > 
> > > People have been interested for a long time.  It's just that we finally
> > > made forward progress to get parts of it shape for merging, which should
> > > have been done long time ago.
> > 
> > It has been pretty close, IMO, it just needed some more reviewers, which
> > it only just got really.
> 
> Going back a couple of weeks, it seemed as far away from inclusion
> as when you first posted the series - there had been no substanital
> review and nobody wanting to review it in it's current form. Then
> I'd heard you were travelling indefinitely.....

Well it was a few weeks. Not great timing, but as I said, I didn't
want to dump the latest patches and then disappear.

There were actually several (google and intel) people testing things.
Last I heard from you (from the first constructive review I had), you
were skeptical about performance and scalability required and thought
it would be a better idea to reduce lock widths and things incrementally
(which I believe will lead to much more overall churn and confusion for
maintaining between different kernel versions).

Anyway, no real harm done and I thank you for picking things up, so
I'm still working through what you've done atm.

>
> There is stuff in the vfs-scale tree that is somewhat controversial
> and had not been discussed satisfactorily - the lock ordering
> (resulting in trylocks everywhere), the shrinker API change, the
> writeback LRU changes, the zone reclaim changes, etc - and some of
> them even have alternative proposals for fixing the algorithmic
> deficiencies.  Nobody was going to review or accept that as one big
> lump.

I think what is absolutely needed is a final(ish) "lump", so we can
actually see what we're working towards and whether it is the right
approach.

Shrinker and zone reclaim is definitely needed. It is needed for NUMA
scalability and locality of reclaim, and also for container and directed
dentry/inode reclaim. Google have a very similar patch and they've said
this is needed (and I already know it is needed for scalability on
large NUMA -- SGI were complaining about this nearly 5 years ago IIRC).
So that is _definitely_ going to be needed.

Store-free path walking is definitely needed, so we need to do RCU inodes.
With RCU inodes, the optimal locking protocols change quite a bit --

Trylocks are a side effect of my conservative approach to establishing
a lock order, and making incremental changes in locking protocol which
are supposed to be easy to follow and verify. Then comes optimisation
of the locking after the "correctness" part of it. It can be taken even
further and *most* of the icache trylocks removed using RCU on a few
more of the lists.

Now I don't want to necessarily merge it all at once, but I do need an
overview of it, most certainly.

A few trylocks confined to core inode handling (and the other inode
locks are not exposed to filesystems at all -- unlike inode_lock today)
is not what I'd call a maintainence nightmare. In fact, IMO it is
cleaner locking especially for filesystems than today.

With a structure like icache, where icache can be accessed down, via
the cache management structures or up, via references to inodes,
trylocks are not unusual unless RCU is extensively used. As long as
I'm careful, I don't see a problem at all -- XFS similarly has some
trylocks.

 
> There's been review now because I went and did what the potential
> reviewers were asking for - break the series into smaller, more
> easily reviewable and verifiable chunks. As a result, I think we're
> close to the end of the review cycle for the inode_lock breakup now.
> I think the code is now much cleaner and more maintainable than what I
> originally pulled from the vfs-scale tree, and it still provides the
> same gains and ability to be converted to RCU algorithms in the
> future.
> 
> Hence, IMO, the current vfs-scale tree needs to be treated as a
> prototype, not as a finished product. It demonstrates the the path
> we need to follow to move forward, as well as the gains we will get
> as we move in that direction, but the code in that tree is not
> guaranteed a free pass into the mainline tree.

It is really pretty close, and while *you* have some disagreements,
it has had some reviews from other people (including Linus) who actually
agree with most of it and agree that scalability is needed.

I am fine with continuing to take suggestions that I agree with, and
integrating them into the tree and begin to start pushing chunks out
the bottom of the stack, but I would like to keep things together in
my upstream tree.


> > etc. I had to really learn most of the code from scratch to get this far
> > and got quite little constructive review really until recently.
> 
> Which seems to be another good reason for treating the tree as prototype
> code.

It's much past a prototype. While the patches need some more cleanup
and review still, the final end result gives a tree with almost no
global cachelines in the entire vfs, including path walking. Things
like path walks are nearly 50% faster single threaded, and perfectly
scalable. Linus actually wants the store-free path walk stuff
_before_ any of the other things, if that gives you an idea of where
other people are putting the priority of the patches.

Thanks,
Nick

