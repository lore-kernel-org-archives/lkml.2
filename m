Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0JOAOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 20:14:51 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44914 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab0JOAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 20:14:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPI5t0x5Lc/f/2dsb2JhbAChInLAfoVIBI9F
Date: Fri, 15 Oct 2010 11:14:43 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015001443.GA3146@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014144159.GA11972@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:41:59AM -0400, Christoph Hellwig wrote:
> On Thu, Oct 14, 2010 at 08:06:09PM +1100, Nick Piggin wrote:
> > Shrinker and zone reclaim is definitely needed. It is needed for NUMA
> > scalability and locality of reclaim, and also for container and directed
> > dentry/inode reclaim. Google have a very similar patch and they've said
> > this is needed (and I already know it is needed for scalability on
> > large NUMA -- SGI were complaining about this nearly 5 years ago IIRC).
> > So that is _definitely_ going to be needed.
> 
> I'm sitll not sold on the per-zone shrinkers.  For one per-zone is
> a really weird concept.  per-node might make a lot more sense, but
> what we really need for doing things usefully is per-sb.  If that's
> not scalable we might have to for sb x zone.

Well I don't know what it means that you're "not sold" on them, and
then come up with ridiculous things like per-node might make a lot
more sense, or per-sb; and that per-zone is a really weird concept.

Per-zone is the right way to drive reclaim, and it will allow locality
to work properly, as well as zone reclaim and zone targetted shortages
and policies, and it will also give good scalability. People need it for
all these reasons.

If you're not "sold" on something, you don't have carte blanche power
to obstruct and delay it either, you have to voice reasonable objections
and be prepared to be shown you're wrong. Saying they're "weird" is just
not productive.


> Either way it's not needed for a lot of workloads, and it's very
> controversial.  Trying to beat it though with a take all or everthing
> attitude is not helpful, and your constant insistance on it is probably
> the biggest factor for delaying all this work so long.

How is it very controversial? The only controversy came from Dave, when
he a) totally misunderstood how zone based reclaim works, and b)
objected about lazy LRU.

As far as b) went, I said it was a valid point and that I can change a
few lines so it is no longer lazy for the first merge, or we can just
merge it and change it back if needed. I didn't hear back about that at
the time when I replied, so it appeared that the answer satisfied him.

> 
> Someone is going to do VFS scaling in pieces and if you're not willing
> to help it's going to be someone else.  We'll still build ontop of your
> great initial work, though.
> 
> > Store-free path walking is definitely needed, so we need to do RCU inodes.
> > With RCU inodes, the optimal locking protocols change quite a bit --
> 
> I don't think anyone disagrees with that.  How we do the RCU locking
> in detail is however still open.

Well I didn't think it was, because I have the _entire_ stack here and
working and so we can see exactly how it is working and how it all fits
together. Surely you agree it is better to have the end goal visible,
testable, and reviewable, even if pices are merged at a time?


>  I'd for example really like to see
> inodes use slab rcu freeing from the beginning.

I have gone over this in a couple of threads (with Linus and Dave
actually). I found that, outside a microbenchmark, I hadn't yet found
a real workload that suffered from it; due to how it works, it hopefully
won't be too common to find one; and I also sketched a design for slab
RCU freeing that adds a little more complexity but can be used to fix
regressions if it is needed.

We have gone over all this and it is not "controversial" any more,
unless you actually have a reasonable objection other than handwaving
or bringing up red herrings as you keep doing (like replacing the global
hashes).

> 
> > It is really pretty close, and while *you* have some disagreements,
> > it has had some reviews from other people (including Linus) who actually
> > agree with most of it and agree that scalability is needed.
> 
> Again, I've not seen anyone arguing against the scalability.  But as

Well you have been.

 "Either way [per zone shrinker patch] is not needed for a lot of workloads,
  and it's very controversial."

If you spent 5 minutes looking at the VM reclaim design, you would know
that per-zone reclaim is actually the natural and correct way to do it,
for a large range of reasons. In fact, a global shrinker or a per-node
shirnker is far more weird by comparison.


> you might have noticed there's some very different opinions on how
> to go there.

Very different opinions? Outside obstructionist handwaving? Well then
don't you agree we should sort out those opinions and get a good idea
of the overall picture of where we will end up?


> > It's much past a prototype. While the patches need some more cleanup
> > and review still, the final end result gives a tree with almost no
> > global cachelines in the entire vfs, including path walking.
> 
> It's a nice prototype, no diagreement.  But we'll need to change a lot
> of the VFS things as we go to do things properly.

I don't see much has changed so far, just omitted. Which will need to
be changed again doubly to get where we need.


> > Things
> > like path walks are nearly 50% faster single threaded, and perfectly
> > scalable. Linus actually wants the store-free path walk stuff
> > _before_ any of the other things, if that gives you an idea of where
> > other people are putting the priority of the patches.
> 
> Different people have different priorities.  In the end the person
> doing the work of actually getting it in a mergeable shape is setting
> the pace.  If you had started splitting out the RCU pathwalk bits half a
> year ago there's we already have it in now.  But that's now how it
> worked.

No way it would not have. It wasn't even finished and tested to a degree
that it could be posted for serious review by someone like Al and Linus
until a few months ago.

But you missed my point about that. My point is that we _know_ that
store free path walks are going to be merged, it is one of the more
desirable pieces of the series. So we _know_ RCU inodes are needed, so
we can happily use RCU work earlier in the series to make locking
better in the icache.

If you handwave and say "Oh but RCU is controversial and it's disputed
blah blah so let's not do it yet", then you are being obstructionist,
or haven't kept up with the big picture.


