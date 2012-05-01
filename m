Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2EAInZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 04:43:25 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43905 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab2EAInW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 04:43:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/5] refault distance-based file cache sizing
Date: Tue,  1 May 2012 10:41:48 +0200
Message-Id: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

our file data caching implementation is done by having an inactive
list of pages that have yet to prove worth keeping around and an
active list of pages that already did.  The question is how to balance
those two lists against each other.

On one hand, the space for inactive pages needs to be big enough so
that they have the necessary time in memory to gather the references
required for an activation.  On the other hand, we want an active list
big enough to hold all data that is frequently used, if possible, to
protect it from streams of less frequently used/once used pages.

Our current balancing ("active can't grow larger than inactive") does
not really work too well.  We have people complaining that the working
set is not well protected from used-once file cache, and other people
complaining that we don't adapt to changes in the workingset and
protect stale pages in other cases.

This series stores file cache eviction information in the vacated page
cache radix tree slots and uses it on refault to see if the pages
currently on the active list need to have their status challenged.

A fully activated file set that occupies 85% of memory is successfully
detected as stale when another file set of equal size is accessed for
a few times (4-5).  The old kernel would never adapt to the second
one.  If the new set is bigger than memory, the old set is left
untouched, where the old kernel would shrink the old set to half of
memory and leave it at that.  Tested on a multi-zone single-node
machine.

More testing is obviously required, but I first wanted some opinions
at this point.  Is there fundamental disagreement with the concept?
With the implementation?

Memcg hard limit reclaim is not converted (anymore, ripped it out to
focus on the global case first) and it still does the 50/50 balancing
between lists, but this will be re-added in the next version.

Patches are based on 3.3.

 fs/btrfs/compression.c     |   10 +-
 fs/btrfs/extent_io.c       |    3 +-
 fs/cachefiles/rdwr.c       |   26 +++--
 fs/ceph/xattr.c            |    2 +-
 fs/inode.c                 |    7 +-
 fs/logfs/readwrite.c       |    9 +-
 fs/nilfs2/inode.c          |    6 +-
 fs/ntfs/file.c             |   11 ++-
 fs/splice.c                |   10 +-
 include/linux/mm.h         |    8 ++
 include/linux/mmzone.h     |    7 ++
 include/linux/pagemap.h    |   54 ++++++++---
 include/linux/pagevec.h    |    3 +
 include/linux/radix-tree.h |    4 -
 include/linux/sched.h      |    1 +
 include/linux/shmem_fs.h   |    1 +
 include/linux/swap.h       |    7 ++
 lib/radix-tree.c           |   75 ---------------
 mm/Makefile                |    1 +
 mm/filemap.c               |  222 ++++++++++++++++++++++++++++++++++----------
 mm/memcontrol.c            |    3 +
 mm/mincore.c               |   20 +++-
 mm/page_alloc.c            |    7 ++
 mm/readahead.c             |   51 +++++++++-
 mm/shmem.c                 |   89 +++---------------
 mm/swap.c                  |   23 +++++
 mm/truncate.c              |   73 +++++++++++---
 mm/vmscan.c                |   80 +++++++++-------
 mm/vmstat.c                |    4 +
 mm/workingset.c            |  174 ++++++++++++++++++++++++++++++++++
 net/ceph/messenger.c       |    2 +-
 net/ceph/pagelist.c        |    4 +-
 net/ceph/pagevec.c         |    2 +-
 33 files changed, 682 insertions(+), 317 deletions(-)

Thanks,
Johannes
