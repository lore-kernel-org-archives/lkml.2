Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0JQCZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:25:42 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34745 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211Ab0JQCZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:25:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAAL5uUx5LcB2gWdsb2JhbAChKRYBARYiIsILgneCUgQ
Date: Sun, 17 Oct 2010 13:25:39 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101017022539.GA3317@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004610.GB29677@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017004610.GB29677@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 11:46:10AM +1100, Dave Chinner wrote:
> On Sun, Oct 17, 2010 at 04:12:13AM +1100, Nick Piggin wrote:
> > On Sat, Oct 16, 2010 at 12:16:42PM -0400, Christoph Hellwig wrote:
> > > On Sat, Oct 16, 2010 at 06:57:03PM +1100, Nick Piggin wrote:
> > > > > duplicating these helpers in the dcache code aswell.  IMHO they
> > > > > should simple operate directly on the hlist_bl_head, as that's
> > > > > what it was designed for.  I also don't really see any point in
> > > > > wrapping the hlist_bl_head as inode_hash_bucket.  If the bucket naming
> > > > > is important we could rename the hlist_bl stuff to bl_hash, and the
> > > > > hlist_bl_head could become bl_hash_bucket.
> > > > 
> > > > It was done because someone, like -rt, might want more than one bit of
> > > > memory to implement a lock. They would have to make a few other
> > > > changes, granted, but this helps reduce a lot of churn.
> > > > 
> > > > I didn't see the point of a layer of dumb wrappers for hlist_bl_head
> > > > locking. Just reproducing bit spin and wait locks in wrappers when we
> > > > already have good functions for them.
> > > 
> > > With the changes Dave implemented based on my suggestions we now have
> > > an abstract locked hash list data type.  It has the normal hash list
> > > operations plus lock/unlock operations.
> > 
> > That's ugly. It just hides the locking. If a bit of casting bothers
> > you then put it in a function where it is used like I did.
> 
> I much prefer the abstraction from an end-user point of view. Asking
> every developer to understand the intricacies of locking the
> hlist_bl structures is asking them to get it wrong.

Asking them to understand that 0 bit is to be used for locking? If
they don't understand that they shouldn't be doing kernel programming,
let alone trying to implement advanced scalability with bl lists.
Really.


> Providing
> locking wrappers that are exactly what users need so they don't have
> to care about it is, IMO, the right thing to do.

Hiding the type of lock, and hiding the fact that it sets the low bit?
I don't agree. We don't have synchronization in our data structures,
where possible, because it is just restrictive or goes wrong when people
don't think enough about the locking.

