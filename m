Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab1F0NbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:31:24 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:37095 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab1F0NaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:30:11 -0400
From: Andrea Righi <andrea@betterlinux.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Shaohua Li <shaohua.li@intel.com>,
        =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/2] fadvise: move active pages to inactive list with POSIX_FADV_DONTNEED
Date: Mon, 27 Jun 2011 15:29:19 +0200
Message-Id: <1309181361-14633-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some reported problems in the past about trashing page cache when a
backup software (i.e., rsync) touches a huge amount of pages (see for example
[1]).
    
This problem has been almost fixed by the Minchan Kim's patch [2] and a proper
use of fadvise() in the backup software. For example this patch set [3] has
been proposed for inclusion in rsync.
    
However, there can be still other similar trashing problems: when the backup
software reads all the source files, some of them may be part of the actual
working set of the system. When a POSIX_FADV_DONTNEED is performed _all_ pages
are evicted from pagecache, both the working set and the use-once pages touched
only by the backup software.
    
With the following solution when POSIX_FADV_DONTNEED is called for an active
page instead of removing it from the page cache it is added to the tail of the
inactive list. Otherwise, if it's already in the inactive list the page is
removed from the page cache. Pages mapped by other processes or unevictable
pages are not touched at all.

In this way if the backup was the only user of a page, that page will be
immediately removed from the page cache by calling POSIX_FADV_DONTNEED.  If the
page was also touched by other processes it'll be moved to the inactive list,
having another chance of being re-added to the working set, or simply reclaimed
when memory is needed.
    
Previous discussion about this topic can be found in [4].
    
Testcase:

  - create a 1GB file called "zero"
  - run md5sum zero to read all the pages in page cache (this is to
    simulate the user activity on this file)
  - run rsync zero zero_copy
  - re-run md5sum zero (user activity on the working set) and measure
    the time to complete this command

The test has been performed using 3.0.0-rc4 vanilla and with this patch applied
(3.0.0-rc4-fadvise); rsync has been patched with [3].

Results:

 - after the backup run:
   # perf stat -e block:block_bio_queue md5sum zero

                  avg elapsed time      block:block_bio_queue
 3.0.0-rc4             4.20s                      8,228
 3.0.0-rc4-fadvise     2.19s                          0

[1] http://marc.info/?l=rsync&m=128885034930933&w=2
[2] https://lkml.org/lkml/2011/2/20/57
[3] http://lists.samba.org/archive/rsync/2010-November/025827.html
[4] http://marc.info/?l=linux-kernel&m=130877950220314&w=2

ChangeLog v3 -> v4:
 - map the "drop if page was used once" policy to POSIX_FADV_DONTNEED, like the
   first implementation (POSIX_FADV_NOREUSE is designed to apply a drop-behind
   invalidation, not after data access, so it's not suitable to represent this
   logic)
 - do not change the behavior of other invalidate_mapping_pages() usage (only
   POSIX_FADV_DONTNEED is changed)
 - change the name of the additional __invalidate_mapping_pages() parameter
   from "force" to "invalidate" (as suggested by Rik)

[PATCH v4 1/2] mm: introduce __invalidate_mapping_pages()
[PATCH v4 2/2] fadvise: move active pages to inactive list with POSIX_FADV_DONTNEED

 include/linux/fs.h |    8 ++++++--
 mm/fadvise.c       |   13 ++++++++++---
 mm/swap.c          |    2 +-
 mm/truncate.c      |   42 +++++++++++++++++++++++++++++++-----------
 4 files changed, 48 insertions(+), 17 deletions(-)
