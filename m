Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0JQCUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:20:16 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37419 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211Ab0JQCUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:20:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAAL5uUx5LcB2gWdsb2JhbAChKRYBARYiIsILhUkEhQw
Date: Sun, 17 Oct 2010 13:20:09 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU
  lists
Message-ID: <20101017022009.GD3162@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
 <20101008074243.GB24089@infradead.org>
 <20101008080018.GV4681@dastard>
 <20101008081816.GA17577@infradead.org>
 <20101016075713.GQ19147@amd>
 <20101016162021.GE16861@infradead.org>
 <20101016171948.GD3240@amd>
 <20101017010023.GC29677@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017010023.GC29677@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 12:00:23PM +1100, Dave Chinner wrote:
> On Sun, Oct 17, 2010 at 04:19:48AM +1100, Nick Piggin wrote:
> > On Sat, Oct 16, 2010 at 12:20:21PM -0400, Christoph Hellwig wrote:
> > > On Sat, Oct 16, 2010 at 06:57:13PM +1100, Nick Piggin wrote:
> > > > > That needs some documentation both in the changelog and in the code
> > > > > I think.
> > > > 
> > > > This is another instance where the irregular i_lock locking is making
> > > > these little subtleties to the locking. I think that is actually much
> > > > worse for maintainence/complexity than a few trylocks which can be
> > > > mostly removed with rcu anyway (which are obvious because of the well
> > > > documented lock order).
> > > 
> > > Care to explain why?
> > 
> > OK.
> > 
> > 
> > >  The I_FREEING and co checks are how we do things
> > > all over the icache for a long time.
> > 
> > That's missing my point. My point is that the semantics of icache
> > concurrency here are changed from the old inode_lock model. With
> > my design, holding i_lock on an inode is equivalent (stronger,
> > actually) to holding inode_lock which is an important part of
> > making small correct steps.
> 
> That doesn't necesarily make it better, Nick.

I argue that it does. Today you protect the icache state of an
inode with inode_lock; in my model you can do it with i_lock.

A single particular inode is most often the thing you are interested in,
so once you take i_lock on it, you safely know that you can lift
inode_lock away.


> The existing of I_FREEING checks in the writeback code is an
> exception rather than the rule - it was the only list traversal
> where an inode in the I_FREEING state was unacceptable and it
> special cased that with an undocumented BUG_ON(inode->i_state &
> I_FREEING).  i only found this and understood it as a result of
> tripping over it while testing this patch.
> 
> The change I made to allow handling the I_FREEING case in this code
> in exactly the same way as every other inode list traversal is a
> significant improvement. it also greatly simplified the i_state
> locking patches in this area. Any by the end of the series, the
> behaviour of setting I_FREEING before disposing of the inode is well
> documented, consistently implemented, and protected by a commented
> BUG_ON to ensure the rule is always followed in future.
> 
> IMO, removing an undocumented special case landmine is a much
> better solution than continuing to hide it and hoping no-one treads on
> it....

You blew up said land mine because your locking model did not provide
the same coverage as the inode_lock that was lifted away.

I'm not saying that particular "landmine" could not go away, I'm saying
that it was exploded because of the irregular locking that your patches
introduce. That is what I don't like.

Now I repeat again. There are some possible upsides of reducing i_lock
coverage (like improving lock ordering). I _never_ said I was totally
against them. I said I want to wait in the series until the inode_lock
is lifted, and they can be proposed as individual, bisectable small
changes rather than being lumped in with lock splitting.

In fact, before I realised that I could make use of RCU-inodes due to
the rcu-walk work going on, I was experimenting exactly with reducing
i_lock widths like you have been doing to reduce the ordering
complexity. You can do it in a few patches of a couple of dozen lines
each. But I decided the complexity and potential for undetected problems
from making the locking less regular is just not worth it when you can
use RCU for mostly the same job.

I would be willing to be proven wrong on that, but I would like to be
proven wrong with a 40 line patch that does nothing but moves i_lock
out of a particular data structure manipulation, and then adds in these
required hunks like the above. That way it is far easier to bisect,
review, and audit the rest of the code for other exposed landmines.

