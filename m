Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0JPRe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:34:29 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:47718 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab0JPRe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:34:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQEALp9uUx5LcB2gWdsb2JhbAChMBYBARYiIsBEhUkE
Date: Sun, 17 Oct 2010 04:34:22 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101016173422.GA6840@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-5-git-send-email-david@fromorbit.com>
 <20101016092916.GA32197@amd>
 <20101016165930.GA20626@infradead.org>
 <20101016172924.GA3519@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016172924.GA3519@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:29:24AM +1100, Nick Piggin wrote:
> On Sat, Oct 16, 2010 at 12:59:30PM -0400, Christoph Hellwig wrote:
> > I don't think the pointer check will work either.  By the time we retake
> > the lru lock the inode might already have been reaped through a call
> > to invalidate_inodes.  There's no way we can do anything with it after
> 
> I don't think you're right. If we re take inode_lock, ensure it is on
> the LRU, and call the can_unuse checks, there is no more problem than
> the regular loop taking items from the LRU, AFAIKS.
> 
> > iput.  What we could do is using variant of can_unuse to decide to move
> > the inode to the front of the lru before doing the iput.  That way
> > we'll get to it next after retaking the lru lock if it's still there.
> 
> This might actually be the better approach anyway (even for upstream)
> -- it means we don't have to worry about the "check head element"
> heuristic of the LRU check which could get false negatives if there is
> a lot of concurrency on the LRU.

Oh hmm, but then you do have the double lock of the LRU lock.

if (can_unuse_after_iput(inode)) {
  spin_lock(&inode_lock);
  list_move(inode, list tail)
  spin_unlock(&inode_lock);
}
iput(inode);
spin_lock(&inode_lock);

Is that worth it?

