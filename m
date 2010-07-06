Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0GFEfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:35:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:59760 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0GFEe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:34:59 -0400
Date: Tue, 6 Jul 2010 14:34:39 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100706043439.GH11732@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
 <20100630072702.GF24712@dastard>
 <20100630120502.GB21358@laptop>
 <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
 <20100703034123.GE11732@laptop>
 <20100702213149.f0ca2f72.akpm@linux-foundation.org>
 <20100703050652.GF11732@laptop>
 <20100705224106.GZ24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705224106.GZ24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 08:41:06AM +1000, Dave Chinner wrote:
> On Sat, Jul 03, 2010 at 03:06:52PM +1000, Nick Piggin wrote:
> > So it makes a lot of sense to have a lock to rule the inode (as opposed
> > to now we have a lock to rule *all* inodes).
> 
> I don't disagree with this approach - I object to the fact that you
> repurpose an existing lock and change it's locking rules to "rule
> the inode". We don't have any one lock that "rules the inode",

"rule the inode" was in regard to the inode cache / dirty / writeout
handling; ie. what inode_lock is currently for. The idea is that in
these code paths, we tend to want to take an inode, lock it, and then
manipulate it (including putting it on or taking it off data
structures).


> anyway, so adding a new "i_list_lock" for the new VFS level locking
> strategies makes it a lot more self-contained. Fundamentally I'm
> less concerned about the additional memory usage than I am about
> having landmines planted around i_lock...

(it's not just lists, its refcount and i_state too)

I just don't see a problem. _No_ filesystem takes any of the locks
that nest inside i_lock. They may call some inode.c functions, but
shouldn't do so while holding i_lock if they are treating i_lock as
an innermost lock. So they can keep using i_lock. I did go through
and attempt to look at all filesystems.

Within inode.c, lock ordering is 2 levels deep, same as it was when
we had inode_lock and i_lock.

If some filesystem introduces a lock ordering problem from not
reading the newly added documentation, lockdep should catch it pretty
quick.

So I don't see a landmine they don't have (in much larger doses) with
i_mutex, reentrant reclaim, page lock, buffer lock, mmap_sem etc
already.
