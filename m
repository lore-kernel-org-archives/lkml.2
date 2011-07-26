Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1GZIjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:39:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:20097 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab1GZIi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,268,1309762800"; 
   d="scan'208";a="30152236"
Date: Tue, 26 Jul 2011 16:38:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] writeback changes for 3.1
Message-ID: <20110726083848.GA8366@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git  for-linus

Besides the less interesting tweaks on writeback queues and
dirty balancing, there are two remarkable changes:

- split the global inode_wb_list_lock (which is highly contented in
  small file writeback) into per-bdi list_lock, which helps JBOD setup

- write bandwidth estimation, based on which the writeback chunk size is
  increased from 4MB to 0.5 seconds worth of data. Note that ext4 already
  use 128MB write chunk size internally, so won't easily see the difference

There will be merge conflicts with commit 12ad3ab661 ("superblock:
move pin_sb_for_writeback() to fs/super.c"). If you want it, I can
resolve the conflicts either by a rebase, or by doing a local merge
into a new local branch:

        git checkout master
        git pull linus master

        git branch for-linus-clean
        git checkout for-linus-clean

        git merge for-linus # and resolve conflicts by myself

I feel sorry for the last minute changes to the last two commits. They
are for doing a trivial variable rename.

Shortlog:

Christoph Hellwig (1):
      writeback: split inode_wb_list_lock into bdi_writeback.list_lock

Jan Kara (2):
      writeback: account per-bdi accumulated written pages
      mm: properly reflect task dirty limits in dirty_exceeded logic

Wu Fengguang (24):
      writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
      writeback: update dirtied_when for synced inode to prevent livelock
      writeback: introduce writeback_control.inodes_written
      writeback: try more writeback as long as something was written
      writeback: the kupdate expire timestamp should be a moving target
      writeback: refill b_io iff empty
      writeback: elevate queue_io() into wb_writeback()
      writeback: avoid extra sync work at enqueue time
      writeback: add bdi_dirty_limit() kernel-doc
      writeback: skip balance_dirty_pages() for in-memory fs
      writeback: remove writeback_control.more_io
      writeback: remove .nonblocking and .encountered_congestion
      writeback: trace event writeback_single_inode
      writeback: trace event writeback_queue_io
      writeback: skip tmpfs early in balance_dirty_pages_ratelimited_nr()
      writeback: make writeback_control.nr_to_write straight
      writeback: bdi write bandwidth estimation
      writeback: show bdi write bandwidth in debugfs
      writeback: consolidate variable names in balance_dirty_pages()
      writeback: introduce smoothed global dirty limit
      writeback: introduce max-pause and pass-good dirty limits
      writeback: trace global_dirty_state
      writeback: scale IO chunk size up to half device bandwidth
      writeback: don't busy retry writeback on new/freeing inodes

Diffstat:

 fs/block_dev.c                   |   16 +-
 fs/btrfs/extent_io.c             |    2 -
 fs/ext4/inode.c                  |    4 +-
 fs/fs-writeback.c                |  373 +++++++++++++++++++++-----------------
 fs/inode.c                       |    5 +-
 fs/nfs/write.c                   |    3 +-
 fs/xfs/linux-2.6/xfs_aops.c      |    2 +-
 include/linux/backing-dev.h      |    8 +
 include/linux/writeback.h        |   55 +++++--
 include/trace/events/btrfs.h     |    6 +-
 include/trace/events/ext4.h      |    6 +-
 include/trace/events/writeback.h |  183 +++++++++++++++++--
 mm/backing-dev.c                 |   82 ++++++---
 mm/filemap.c                     |    6 +-
 mm/page-writeback.c              |  280 +++++++++++++++++++++++++----
 mm/rmap.c                        |    4 +-
 16 files changed, 748 insertions(+), 287 deletions(-)

Thanks,
Fengguang
