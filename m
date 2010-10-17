Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0JQCJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:09:54 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:53831 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211Ab0JQCJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:09:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAEL1uUx5LcB2gWdsb2JhbAChKRYBARYiIsF4hUkE
Date: Sun, 17 Oct 2010 13:09:51 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101017020951.GC3162@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-5-git-send-email-david@fromorbit.com>
 <20101016092916.GA32197@amd>
 <20101016165930.GA20626@infradead.org>
 <20101016172924.GA3519@amd>
 <20101017004710.GC1614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017004710.GC1614@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:47:10PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 17, 2010 at 04:29:24AM +1100, Nick Piggin wrote:
> > > I don't think the pointer check will work either.  By the time we retake
> > > the lru lock the inode might already have been reaped through a call
> > > to invalidate_inodes.  There's no way we can do anything with it after
> > 
> > I don't think you're right. If we re take inode_lock, ensure it is on
> > the LRU, and call the can_unuse checks, there is no more problem than
> > the regular loop taking items from the LRU, AFAIKS.
> 
> As long as we have the global inode lock it should indeed be safe.
> But once we have a separate lru lock (global or per-zone, with or
> without i_lock during the addition) there is nothing preventing the
> inode from getting reused and re-added to the lru in the meantime.
> Sure this is an extremly unlikely case, but there is no locking to
> prevent it once inode_lock is gone.

No. There is nothing preventing that exact reuse from happening in
mainline _today_ either, because the inode_lock is dropped there too.

The point is that it is a heuristic that works (apparently) most of the
time but if it gets it wrong then it's not a big deal, it's only the LRU
position anyway. It would work exactly the same with separate global or
per-zone lru locks.

