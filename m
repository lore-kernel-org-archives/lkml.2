Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930Ab0J2J3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:29:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53946 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0J2J3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:29:34 -0400
Date: Fri, 29 Oct 2010 10:29:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: fs: break out inode operations from inode_lock V4
Message-ID: <20101029092930.GR19804@ZenIV.linux.org.uk>
References: <1288342803-14957-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288342803-14957-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 07:59:55PM +1100, Dave Chinner wrote:
> Hi Al,
> 
> Another update to the inode_lock splitting patch set. It's still
> based on your merge-stem branch. I'm going to be out all weekend, so
> any further changes will take a couple of days to turn around.
> 
> Version 4:
> - whitespace cleanup
> - moved setting state on new inodes till after the hash search fails
>   in insert_inode_locked
> - made hash insert operations atomic with state changes by holding
>   inode->i_lock while doing hash inserts
> - made inode hash removals atomic with state changes by taking the
>   inode_lock (later inode_hash_lock) and inode->i_lock. Combined
>   with the insert changes, this means the inode_unhashed check in
>   ->drop_inode is safely protected by just holding the
>   inode->i_lock.
> - protect inode_unhashed() checks in insert_inode_locked with
>   inode->i_lock

The last one is not needed at all; look at what's getting done there - we
drop that ->i_lock immediately after the check, so it doesn't buy us anything.
The stuff before that *is* a race fix; namely, the race with BS iget()
triggered by nfsd.  This check is just verifying that it was a race and not
a badly confused filesystem.  IOW, no need to lock anything and no _point_
locking anything.  We are repeating the hash walk anyway; this is just making
sure that we hadn't run into infinite retries.

Other than that I'm OK with that set; could you add "lift ->i_lock from
the beginning of writeback_single_inode()" to the series and post your
current RCU-for-i_hash patch for review?

Nick, can you live with the results of that set as an intermediate point
for merge?  Note that RCU for other lists (sb, wb, lru) is bloody pointless -
all heavy users are going to modify the lists in question anyway, so we'll
need exclusion for them.

And yes, removals from the lists ought to be conditional on presense in the
lists, but that's (a) easy to rediff on top of that and (b) is of somewhat
dubious usefulness - eviction will generally find the inode on lists; the
only likely exception is final iput() of unhashed inode.  I'm not saying
it's not worth doing, just that the benefits will need to be verified...

NOTE: this is obviously not the end of the road; e.g. i_count is still atomic
at that point, RCU is not done, finer splitting of locks is not done, etc.
