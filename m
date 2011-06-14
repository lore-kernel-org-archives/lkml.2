Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1FNKlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:41:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48863 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab1FNKlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=s/5UFL06HI+LJxrlLvCeMGTbd5nWRWhvEj9fzV+qbGaXNh+2evXWZ7oKl6JBzhJMJ1
         Oz4SuYbAmdBxoHE9mx+g==
Date: Tue, 14 Jun 2011 03:40:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Robin Holt <holt@sgi.com>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/12] tmpfs: convert from old swap vector to radix tree
Message-ID: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my third patchset for mmotm, completing the series.
Based on 3.0-rc3 plus the 14 in June 5th "mm: tmpfs and trunc changes"
plus the 7 in June 9th "tmpfs: simplify by splice instead of readpage",
which were in preparation for it.

I'm not sure who would really be interested in it: I'm Cc'ing this
header mail as notification to a number of people who might care;
but reluctant to spam you all with the 14+7+12 patches themselves,
I hope you can pick them up from the list if you want (or ask me).

What's it about?  Extending tmpfs to MAX_LFS_FILESIZE by abandoning
its peculiar swap vector, instead keeping a file's swap entries in
the same radix tree as its struct page pointers: thus saving memory,
and simplifying its code and locking.

 1/12 radix_tree: exceptional entries and indices
 2/12 mm: let swap use exceptional entries
 3/12 tmpfs: demolish old swap vector support
 4/12 tmpfs: miscellaneous trivial cleanups
 5/12 tmpfs: copy truncate_inode_pages_range
 6/12 tmpfs: convert shmem_truncate_range to radix-swap
 7/12 tmpfs: convert shmem_unuse_inode to radix-swap
 8/12 tmpfs: convert shmem_getpage_gfp to radix-swap
 9/12 tmpfs: convert mem_cgroup shmem to radix-swap
10/12 tmpfs: convert shmem_writepage and enable swap
11/12 tmpfs: use kmemdup for short symlinks
12/12 mm: a few small updates for radix-swap

 fs/stack.c                 |    5 
 include/linux/memcontrol.h |    8 
 include/linux/radix-tree.h |   36 
 include/linux/shmem_fs.h   |   17 
 include/linux/swapops.h    |   23 
 init/main.c                |    2 
 lib/radix-tree.c           |   29 
 mm/filemap.c               |   74 -
 mm/memcontrol.c            |   66 -
 mm/mincore.c               |   10 
 mm/shmem.c                 | 1515 +++++++++++------------------------
 mm/swapfile.c              |   20 
 mm/truncate.c              |    8 
 13 files changed, 669 insertions(+), 1144 deletions(-)

Hugh
