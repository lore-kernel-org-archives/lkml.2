Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab0HFNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:25:26 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:30728 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab0HFNZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:25:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEeqW0x5LdoS/2dsb2JhbACgPXLEB4U6BA
Date: Fri, 6 Aug 2010 23:25:18 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [rfc][patch 0/2] another way to scale mmap_sem?
Message-ID: <20100806132518.GA3132@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry for the late and sorry state of these patches. I had some
interesting offline issues and also had to strike while the iron is hot
with the vfs patches as well.

But anyway, mmap_sem scalability is a topic we'll be talking about at
the MM meetup next week, so I wanted to contribue something here.

I am of the opinion now that a single mmap_sem and global rbtree is
maybe not so great. It's tricky to make it more scalable on the read
side without increasing write side overhead (which we don't want to
do too much). We also have problems with write side scalability too
-- writer versus readers (google's problem) and even multiple writers.

Possibly one way to go is to actually go away from global rbtree for
vmas. We have this beautiful, cache efficient, scalable data structure
that is the page table sitting along side the clunky old rbtree. So
why not put vma extents in the bottom level page tables, like we do
with the page table lock?

We can use the page table locks to protect each tree, so number of
atomics should be reduced from removing mmap_sem. The page tables are
cache hot from the TLB handler and we need to load the bottom level
struct page to get the ptl, and the height of vma trees will be smaller
so smaller cache footprint and smaller chain of dependent cache misses.
And we don't even need any new fancy lock free stuff.

Now, one big issue is that we can't sleep if we're using ptl rather
than mmap_sem. And also, we prefer not to sleep while holding locks
anyway (even if they are more fine grained). So what we could do is
if the fault handler needs to sleep, then it can take a reference on
the inode (or the vma holding the inode open), and then drop the ptl.

After the page is uptodate, just walk the page tables again, take the
ptl and confirm the vma is still correct, and insert the pte.

Another issue is free space allocation. At the moment I am doing just
another global extent tree for this. It is not as bad as it sounds
because the lock hold times are much shorter, and we get the benefit
that mappings are decoupled from allocations, so we don't need to
hold a lock over a complete unmap/tlb flush. But the free space
allocator could easily be changed to have per-cpu or per-thread caches
and start getting more write side parallelism.

Thoughts? Comments?
