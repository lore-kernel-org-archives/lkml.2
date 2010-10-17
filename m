Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0JQCDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:03:50 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:59295 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602Ab0JQCDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:03:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAEL1uUx5LcB2gWdsb2JhbAChKRYBARYiIsF4hUkEj0w
Date: Sun, 17 Oct 2010 13:03:44 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] fs: icache lock s_inodes list
Message-ID: <20101017020344.GA3162@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-3-git-send-email-david@fromorbit.com>
 <20101001054909.GB32349@infradead.org>
 <20101016075411.GA19147@amd>
 <20101016161210.GA16861@infradead.org>
 <20101016170911.GA3240@amd>
 <20101017004257.GA1614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017004257.GA1614@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:42:57PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 17, 2010 at 04:09:11AM +1100, Nick Piggin wrote:
> > If you want it to be scalable within a single sb, it needs to be
> > per cpu. If it is per-cpu it does not need to be per-sb as well
> > which just adds bloat.
> 
> Right now the patches split up the inode lock and do not add
> per-cpu magic.  It's not any more work to move from per-sb lists
> to per-cpu locking if we eventually do it than moving from global
> to per-cpu.

But it's more work to do per-sb lists than a global list, and as
I'm going to a per-cpu locking anyway it's a strange transition
to go from per-sb to per-cpu (rather than per-sb, per-cpu). In short,
the fact that I build up the locking transformations starting with
global locks is just not something that can be held against my
patch set (unless you really disagree with the whole concept of
how the series is structured).

>
> I'm not entirely convinced moving s_inodes to a per-cpu list is a good
> idea.  For now per-sb is just fine for disk filesystems as they have
> much more fs-wide cachelines they touch for inode creatation/deletion
> anyway, and for sockets/pipes a variant of your patch to not ever
> add them to s_inodes sounds like the better approach.

Traditional filesystems on slow spinning disk are not the main
problem. It's very fast ssds and storage servers. XFS actually with
its per-AG lock splitting can already have problems on small servers
with not-incredibly-fast storage with per-sb scalability bottlenecks.

And if the VFS is not scalable, then the contention doesn't even
get pushed into the filesystem so the fs developers never even _see_
the locking problems to fix them.

I'm telling you it will be increasingly a problem because cores and
storage speeds continue to increase, and also people want to manage
more storage with fewer filesystems. It's obvious that it will be a
problem.

I've already got per cpu locking in vfsmounts and files lock, so it's
not magic.

 
> If we eventually hit the limit for disk filesystems I have some better
> ideas to solve this.  One is to abuse whatever data sturcture we use
> for the inode hash also for iterating over all inodes - we only
> iterate over them in very few places, and none of them is a fast path.

Doing your handwaving about changing data types and better ideas
is just not helpful. _If_ you do have some better ideas, and _if_ we
change the data structure, _then_ it's trivial to change from percpu
locking to your better idea. It just doesn't work as an argument to
slow progress.

