Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1GHEO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:14:57 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32854 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731Ab1GHEOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:14:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwHAIiCFk55LCkBgWdsb2JhbABTmE2OdBUBARYmJc0NhjgEoyI
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/14] Per superblock cache reclaim
Date: Fri,  8 Jul 2011 14:14:32 +1000
Message-Id: <1310098486-6453-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts the VFS cache shrinkers to a per-superblock
shrinker, and provides a callout from the superblock shrinker to
allow the filesystem to shrink internal caches proportionally to the
amount of reclaim done to the VFS caches.

The original posting contains the motiviation, benefits, performance,
etc, and rather than repeat it all, just look here:

https://lkml.org/lkml/2011/6/2/42

The version has been rebased onto the untested branch in Al's VFS
git tree, fixes the review comments from the first version, and
has had much more testing under different workloads.

---

Version 2:
o rebase onto Al's #untested branch
o fix build problem in Al's untested branch
o move all slab shrinker modifications tracepoints into a single
  patch.
o renames some of the tracepoint variables to be more obvious as to
  what they are recording.
o move pin_sb_for_writeback() to fs/super.c and rename it to
  grab_super_passive() so the shrinker and writeback use the same
  passive reference counting and unmount detection
o rework per-superblock shrinker to use grab_super_passive()
o minor typo fixes in commit messages, documentation and commit
  messages

---

When the git mirror updates, this patchset will also be available in
the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git per-sb-shrinker

If you get a version based on the current Linus tree, then it hasn't
updated yet....

Dave Chinner (14):
      dcache: fix __d_alloc prototype to use const
      vmscan: add shrink_slab tracepoints
      vmscan: shrinker->nr updates race and go wrong
      vmscan: reduce wind up shrinker->nr when shrinker can't do work
      vmscan: add customisable shrinker batch size
      inode: convert inode_stat.nr_unused to per-cpu counters
      inode: Make unused inode LRU per superblock
      inode: move to per-sb LRU locks
      superblock: move pin_sb_for_writeback() to fs/super.c
      superblock: introduce per-sb cache shrinker infrastructure
      inode: remove iprune_sem
      superblock: add filesystem shrinker operations
      vfs: increase shrinker batch size
      xfs: make use of new shrinker callout for the inode cache

 Documentation/filesystems/vfs.txt |   22 +++++++
 fs/dcache.c                       |  121 ++++--------------------------------
 fs/fs-writeback.c                 |   28 +--------
 fs/inode.c                        |  124 ++++++++++++-------------------------
 fs/internal.h                     |    3 +-
 fs/libfs.c                        |    2 +
 fs/super.c                        |  109 ++++++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_super.c      |   26 +++++---
 fs/xfs/linux-2.6/xfs_sync.c       |   71 ++++++++-------------
 fs/xfs/linux-2.6/xfs_sync.h       |    5 +-
 include/linux/fs.h                |   14 ++++
 include/linux/mm.h                |    1 +
 include/trace/events/vmscan.h     |   71 +++++++++++++++++++++
 mm/vmscan.c                       |   71 +++++++++++++++++-----
 14 files changed, 374 insertions(+), 294 deletions(-)

