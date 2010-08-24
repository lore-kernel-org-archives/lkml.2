Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0HXHeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:34:08 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41957 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0HXHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:34:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG4Rc0x5Ld90/2dsb2JhbACgPHK5UoU3BA
Date: Tue, 24 Aug 2010 17:33:59 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Chris Mason <chris.mason@oracle.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        npiggin@kernel.dk
Subject: Re: aio: bump i_count instead of using igrab
Message-ID: <20100824073359.GC3948@amd>
References: <20100823144755.GP21975@think>
 <20100823145031.GA1279@infradead.org>
 <20100823150023.GR21975@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823150023.GR21975@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:00:23AM -0400, Chris Mason wrote:
> On Mon, Aug 23, 2010 at 10:50:31AM -0400, Christoph Hellwig wrote:
> > On Mon, Aug 23, 2010 at 10:47:55AM -0400, Chris Mason wrote:
> > > The aio batching code is using igrab to get an extra reference on the
> > > inode so it can safely batch.  igrab will go ahead and take the global
> > > inode spinlock, which can be a bottleneck on large machines doing lots
> > > of AIO.
> > > 
> > > In this case, igrab isn't required because we already have a reference
> > > on the file handle.  It is safe to just bump the i_count directly
> > > on the inode.
> > > 
> > > Benchmarking shows this patch brings IOP/s on tons of flash up by about
> > > 2.5X.
> > 
> > There's some places in XFS where we do the same, and it showed up as a
> > bottle neck before.  Instead of open coding the increment we have
> > a wrapper that includes and assert that the numbers is always positive.
> > 
> > I think we really want a proper helper for general use instead of
> > completly opencoding it.

Yeah igrab isn't nice. Several places are calling it without checking
return code too, which means they are either buggy or should be using
something else.


> Nick, this is about a 1 liner to fs/aio.c replacing igrab with
> atomic_inc directly on the inode reference count.
> 
> I know your scalability tree gets rid of the global, but in this case I
> think it still makes sense to avoid the locking completely when the
> caller knows it is safe.  Do you already have something similar hiding
> in the scalability tree?

Yes of course :) It has just simple refcounting increment helper that
can do some of the assertions.

I am hoping to be able to post the inode stuff soonish and hopefully
get it into Al's tree. It will pop up on fsdevel.


