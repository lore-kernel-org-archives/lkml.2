Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0JOGl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 02:41:59 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:54750 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086Ab0JOGl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 02:41:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAA+Vt0x5Ld+3/2dsb2JhbAChIXK+GIVIBIULijo
Date: Fri, 15 Oct 2010 17:41:50 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015064150.GB7511@amd>
References: <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015034451.GA6827@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 02:44:51PM +1100, Nick Piggin wrote:
> On Fri, Oct 15, 2010 at 02:30:17PM +1100, Nick Piggin wrote:
> > On Fri, Oct 15, 2010 at 02:13:43PM +1100, Dave Chinner wrote:
> > >  You've shown it can be done, and that's great - it shows
> > > us the impact of making those changes, but they need to be analysed
> > > separately and treated on own their merits, not lumped with core
> > > locking changes necessary for store-free path walking.
> > 
> > Actually I didn't see anyone else object to doing this. Everybody
> > else it seems acknowledges that it needs to be done, and it gets
> > done naturally as a side effect of fine grained locking.
> 
> Let's just get back to this part, which seems to be one you have
> the most issues with maybe?

[snip per-zone lru/locking]

And as far as the rest of the work goes, I much prefer to come
to a basic consensus about the overall design of the entire vfs
scale work, and then focus on the exact implementation and patch
series details. When there is a consensus, I think it makes much
more sense to merge it in quite large chunks.

Ie. all of the inode locking, then all of the dcache locking.

I do not want to just cherry pick things here and there and
leave the others because your particular workload doesn't care
about them, you haven't reviewed them yet, etc. Because that
just gets my plan into a mess.

I'm perfectly fine to change the design, drop some aspects of
it, etc. _if_ it is decided that we don't want them with reasonable
arguments and agreement among everybody. On the other hand I prefer
not to just merge a few bits and leave others out because we
_don't_ have a consensus about one aspect or another.

So if you don't agree with something, let's work out why not and
try to come to an agreement, rather than pushing bits and pieces
that you do happen to agree with.

You're worried about mere mortals reviewing and understanding it...
I don't really know. If you understand inode locking today, you
can understand the inode scaling series quite easily. Ditto for
dcache. rcu-walk path walking is trickier, but it is described in
detail in documentation and changelog.

And you can understand the high level approach without exactly
digesting every detail at once. The inode locking work goes to
break up all global locks:

- a single inode object is protected (to the same level as
  inode_lock) with i_lock. This makes it really trivial for
  filesystems to lock down the object without taking a global
  lock.

- inode hash rcuified and insertion/removal made per-bucket

- inode lru lists and locking made per-zone

- inode sb list made per-sb, per-cpu

- inode counters made per-cpu

- inode io lists and locking made per-bdi

So from the highest level snapshot, this is not rocket science.
And the way I've structured the patches, you can take almost
any of the above points and go look in the patch series to see
how it is implemented.

Is this where we want to go? My argument is yes, and I have
been gradually gathering real results and agreement from others.

I've demonstrated performance improvements, although many of them can
only be actually achieved when dcache, vfsmount, files lock etc scaling
is also implemented, which is another reason why it is so important to
keep everything together. And it's actually not always trivial to just
take a single change and document a performance improvement in
isolation.

But you can use your brain with scalability work, and if you're not
convinced about a particular patch, you can now actually take the
full series and revert a single patch (or add an artifical lock in
there to demonstrate the scalability overhead).

What I have done in the series is required to get almost linear
scalability up to the largest POWER7 system IBM has internally on
almost all important basic vfs operations. It should scale to the
largest UV systems from SGI. And it should scale on -rt. Put a
global lock in inode lru creation/destruction/touch/reclaim path,
and scalability is going to go to hell on these workloads on large
systems again.

And large isn't even that large these days. You can see these
problems clear as day on 2 and 4 socket small servers and we know
it is going to get worse for at least a few more doublings of
core count.

