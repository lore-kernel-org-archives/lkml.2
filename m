Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0JOLdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:33:52 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:57815 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754288Ab0JOLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:33:51 -0400
Date: Fri, 15 Oct 2010 22:33:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015113336.GH4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015040406.GA6930@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101015040406.GA6930@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 03:04:06PM +1100, Nick Piggin wrote:
> On Thu, Oct 14, 2010 at 10:41:59AM -0400, Christoph Hellwig wrote:
> > > Things
> > > like path walks are nearly 50% faster single threaded, and perfectly
> > > scalable. Linus actually wants the store-free path walk stuff
> > > _before_ any of the other things, if that gives you an idea of where
> > > other people are putting the priority of the patches.
> > 
> > Different people have different priorities.  In the end the person
> > doing the work of actually getting it in a mergeable shape is setting
> > the pace.  If you had started splitting out the RCU pathwalk bits half a
> > year ago there's we already have it in now.  But that's now how it
> > worked.
> 
> Also, I appreciate that you have run into some lock scaling on these XFS
> workloads. But the right way to do it is not to quickly solve your own
> issues and then sort out the rest, leaving my tree in wreckage.

I think you're misrepresenting both my motives and intentions with
the work I've been doing.  I've already told you that I have no
intention of just breaking up the inode_lock, but that I intend to
work towards getting all of your work merged into mainline.  That
is, I do not intend to leave your tree in a stage of wreckage - I
intend to make it redundant.

I started with breaking up the inode_lock because it was the easiest
to tackle and it was what the VFS people indicated they wanted to be
tackled first. I didn't make that decision myself - I accepted
guidance that it was the most appropriate way to proceed.

That doesn't mean that I don't consider the dcache_lock to be a
problem, nor does it mean that it's not a problem for the workloads
I'm running. In fact, it's more heavily contended than the
inode_lock, but I can only tackle one at a time.

It also does not mean that I'm only pulling the bits appropriate for
XFS - if that was the case then I wouldn't have pulled in the
last_ino changes nor the per-cpu inode counters, nor the iunique
changes, nor the iget cleanups, nor Christoph's cleanups, nor added
cleanups of my own. I've taken this on with the expectation I would
be following it through to the end, where-ever that may be.

A couple of weeks after I started on the inode_lock, Christoph
started looking at the dcache_lock part of your series and started
to clean it up. That's one less thing for me to worry about, and so I
will concentrate next on the inode cache RCU changes.

IOWs, there's more than one person actively trying to get your code
into mergable shape, and we are not stepping on each other's toes
because we know which bits each other is trying to address.  That
will get the work done faster, which is a good thing.

You have been gone quite a long while, and right now you're the only
one arguing and stepping on the toes of those progressing the code
towards a mainline merge. Please stop doing that so we can keep
making progress.

> So rather than taking a few bits that you particularly want solved right
> now and not bothering to look at the rest because you claim they're
> weird or not needed or controversial is really not helping the way I
> want to merge this.

"the way I want to merge this"

This process is not about how you want to merge the code - it's
about how the VFS maintainers want to review and merge the code. You
want the code merged - you jump through their hoops and _you like
it_.  I _had_ been enjoying jumping through those hoops over the past
few weeks. I don't enjoy writing emails likes this.

> _I_ have actually been talking to people, running tests on big machines,
> working with -rt guys, socket/networking people, etc. I've worked
> through the store-free lookup design with Linus, we've agreed on RCU
> inodes and contingency to manage unexpected regressions.

Yes, that's all great work and everyone recognises that you deserve
the credit for it.  You've blasted a path through the wilds and
demonstrated to us how to fix this longstanding problem. Nobody can
take that from you - all I ever hear about is "Nick Piggin's VFS
scalability patch set" and I don't want to change that.  Nobody
cares that it's you or me or Christoph or someone else that is doing
the grunt work to get it merged - it is still your work and
inspiration that has got us to this point and that is what people
will remember.

Still, you've done everything _except_ what the VFS maintainers have
asked you to do to get it reviewed and merged. From the start
they've been asking you to split up the patch series into smaller
chunks for review and stage the inclusion over a couple of kernel
releases, and you have not yet shown any sign you are willing to do
that.

Now other people have stepped up to do what the VFS maintainers have
asked.  Consider this an acknowledgement of the great work you have
done - there is enough desire to get your work completed that people
are willing to do it in your absence. If nobody valued your work,
then it would still be sitting there in a cold, decrepid git tree
growing cobwebs full of dead flies.

So, Nick, please, either help us get the code into a form acceptible
to the VFS maintainers and into mainline, or stay out of the way
while we go through the process as quickly as we can. This requireѕ
a co-ordinated group effort, so arguing is really quite
counter-productive. I'd prefer that you help us get through the
process by being constructive and reviewing and testing and keeping
us honest.

IMO, right now the best thing you could is rebase your tree on my work
and Christoph's prep dcache_lock patchset and tell us if we've
screwed anything up so far. I don't think we have, but that's no
guarantee.

I'm not going to try to convince you about the validity of what we
have been doing in your absence anymore; I've got better things to
do with my time. Instead I'm just going to continue to refine the
inode-scale series I have and address review comments until it is
acceptable for incluѕion and then move on to the next piece of the
puzzle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
