Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab0JQBA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:00:28 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:35499 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756905Ab0JQBA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:00:27 -0400
Date: Sun, 17 Oct 2010 12:00:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU
 lists
Message-ID: <20101017010023.GC29677@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
 <20101008074243.GB24089@infradead.org>
 <20101008080018.GV4681@dastard>
 <20101008081816.GA17577@infradead.org>
 <20101016075713.GQ19147@amd>
 <20101016162021.GE16861@infradead.org>
 <20101016171948.GD3240@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016171948.GD3240@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:19:48AM +1100, Nick Piggin wrote:
> On Sat, Oct 16, 2010 at 12:20:21PM -0400, Christoph Hellwig wrote:
> > On Sat, Oct 16, 2010 at 06:57:13PM +1100, Nick Piggin wrote:
> > > > That needs some documentation both in the changelog and in the code
> > > > I think.
> > > 
> > > This is another instance where the irregular i_lock locking is making
> > > these little subtleties to the locking. I think that is actually much
> > > worse for maintainence/complexity than a few trylocks which can be
> > > mostly removed with rcu anyway (which are obvious because of the well
> > > documented lock order).
> > 
> > Care to explain why?
> 
> OK.
> 
> 
> >  The I_FREEING and co checks are how we do things
> > all over the icache for a long time.
> 
> That's missing my point. My point is that the semantics of icache
> concurrency here are changed from the old inode_lock model. With
> my design, holding i_lock on an inode is equivalent (stronger,
> actually) to holding inode_lock which is an important part of
> making small correct steps.

That doesn't necesarily make it better, Nick.

The existing of I_FREEING checks in the writeback code is an
exception rather than the rule - it was the only list traversal
where an inode in the I_FREEING state was unacceptable and it
special cased that with an undocumented BUG_ON(inode->i_state &
I_FREEING).  i only found this and understood it as a result of
tripping over it while testing this patch.

The change I made to allow handling the I_FREEING case in this code
in exactly the same way as every other inode list traversal is a
significant improvement. it also greatly simplified the i_state
locking patches in this area. Any by the end of the series, the
behaviour of setting I_FREEING before disposing of the inode is well
documented, consistently implemented, and protected by a commented
BUG_ON to ensure the rule is always followed in future.

IMO, removing an undocumented special case landmine is a much
better solution than continuing to hide it and hoping no-one treads on
it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
