Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0I2MVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:21:47 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:50489 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623Ab0I2MT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:29 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/17] fs: Inode cache scalability
Date: Wed, 29 Sep 2010 22:18:32 +1000
Message-Id: <1285762729-17928-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is derived from Nick Piggin's VFS scalability tree.
There doesn't appear to be any push to get that tree into shape for
.37, so this is an attempt to start the process of finer grained
review of the series for upstream inclusion. I'm hitting VFS lock
contention problems with XFS on 8-16p machines now, so I need to get
this stuff moving.

This patch set is just the basic inode_lock breakup patches plus a
few more simple changes to the inode code. It stops short of
introducing RCU inode freeing because those changes are not
completely baked yet. It also stops short of changing the way inodes
are tracked for writeback because I'd like not to spend my week
after -rc1 is released fixing writeback again....

As a result, the full inode handling improvements of Nick's patch
set are not realised with this short series. However, my own testing
indicates that the amount of lock traffic and contention is down by
an order of magnitude on an 8-way box for parallel inode create and
unlink workloads, so there is still significant improvements in
scalability from just this patch set.

I've only ported the patches so far, without changing anything
significant other than the comit descriptions. One thing that has
stood out as I've done this is that the ordering of the patches is
not ideal, and some things (like the inode counters) are modified
multiple times through the patch set.  I'm quite happy to
reorder/rework the series to fix these problems if that is desired.

Basically I'm trying to get this patchset ready for .37 (merge
window is not really that far off now), and I'm aiming to have the
rest of the inode changes (RCU freeing, writeback, etc) ready for
.38. I may even look to some of the dcache changes for .38 depending
on how much I can get tested and reviewed in that time frame.

Comments are welcome.

The current patchset is also available at the following location.

The following changes since commit b30a3f6257ed2105259b404d419b4964e363928c:

  Linux 2.6.36-rc5 (2010-09-20 16:56:53 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git inode-scale

Eric Dumazet (2):
      fs: inode per-cpu last_ino allocator
      fs: Convert nr_inodes to a per-cpu counter

Nick Piggin (15):
      kernel: add bl_list
      fs: icache lock s_inodes list
      fs: icache lock inode hash
      fs: icache lock i_state
      fs: icache lock i_count
      fs: icache lock lru/writeback lists
      fs: icache atomic inodes_stat
      fs: icache protect inode state
      fs: Make last_ino, iunique independent of inode_lock
      fs: icache remove inode_lock
      fs: Factor inode hash operations into functions
      fs: Introduce per-bucket inode hash locks
      fs: Implement lazy LRU updates for inodes.
      fs: Inode counters do not need to be atomic.
      fs: Clean up inode reference counting

 Documentation/filesystems/Locking        |    2 +-
 Documentation/filesystems/porting        |   10 +-
 Documentation/filesystems/vfs.txt        |    2 +-
 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 drivers/staging/pohmelfs/inode.c         |   14 +-
 fs/9p/vfs_inode.c                        |    4 +-
 fs/affs/inode.c                          |    2 +-
 fs/afs/dir.c                             |    4 +-
 fs/anon_inodes.c                         |    2 +-
 fs/bfs/dir.c                             |    2 +-
 fs/block_dev.c                           |    7 +-
 fs/btrfs/inode.c                         |   23 +-
 fs/buffer.c                              |    2 +-
 fs/ceph/mds_client.c                     |    2 +-
 fs/cifs/inode.c                          |    2 +-
 fs/coda/dir.c                            |    2 +-
 fs/drop_caches.c                         |   19 +-
 fs/exofs/inode.c                         |   10 +-
 fs/exofs/namei.c                         |    2 +-
 fs/ext2/namei.c                          |    2 +-
 fs/ext3/ialloc.c                         |    4 +-
 fs/ext3/namei.c                          |    2 +-
 fs/ext4/ialloc.c                         |    4 +-
 fs/ext4/namei.c                          |    2 +-
 fs/fs-writeback.c                        |  156 +++++---
 fs/gfs2/ops_inode.c                      |    2 +-
 fs/hfs/hfs_fs.h                          |    2 +-
 fs/hfs/inode.c                           |    2 +-
 fs/hfsplus/dir.c                         |    2 +-
 fs/hfsplus/hfsplus_fs.h                  |    2 +-
 fs/hfsplus/inode.c                       |    2 +-
 fs/hpfs/inode.c                          |    2 +-
 fs/inode.c                               |  603 ++++++++++++++++++++----------
 fs/jffs2/dir.c                           |    4 +-
 fs/jfs/jfs_txnmgr.c                      |    2 +-
 fs/jfs/namei.c                           |    2 +-
 fs/libfs.c                               |    2 +-
 fs/locks.c                               |    2 +-
 fs/logfs/dir.c                           |    2 +-
 fs/logfs/inode.c                         |    2 +-
 fs/logfs/readwrite.c                     |    6 +-
 fs/minix/namei.c                         |    2 +-
 fs/namei.c                               |    2 +-
 fs/nfs/dir.c                             |    2 +-
 fs/nfs/getroot.c                         |    4 +-
 fs/nfs/inode.c                           |    4 +-
 fs/nfs/nfs4state.c                       |    2 +-
 fs/nfs/write.c                           |    2 +-
 fs/nilfs2/gcdat.c                        |    1 +
 fs/nilfs2/gcinode.c                      |   22 +-
 fs/nilfs2/mdt.c                          |    2 +-
 fs/nilfs2/namei.c                        |    2 +-
 fs/nilfs2/segment.c                      |    2 +-
 fs/nilfs2/the_nilfs.h                    |    2 +-
 fs/notify/inode_mark.c                   |   46 ++-
 fs/notify/mark.c                         |    1 -
 fs/notify/vfsmount_mark.c                |    1 -
 fs/ntfs/inode.c                          |    4 +-
 fs/ntfs/super.c                          |    2 +-
 fs/ocfs2/inode.c                         |    2 +-
 fs/ocfs2/namei.c                         |    2 +-
 fs/quota/dquot.c                         |   36 +-
 fs/reiserfs/namei.c                      |    2 +-
 fs/reiserfs/stree.c                      |    2 +-
 fs/reiserfs/xattr.c                      |    2 +-
 fs/sysv/namei.c                          |    2 +-
 fs/ubifs/dir.c                           |    2 +-
 fs/ubifs/super.c                         |    2 +-
 fs/udf/namei.c                           |    2 +-
 fs/ufs/namei.c                           |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c              |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h             |    2 +-
 fs/xfs/xfs_inode.h                       |    4 +-
 include/linux/fs.h                       |   54 ++-
 include/linux/list_bl.h                  |  127 +++++++
 include/linux/rculist_bl.h               |  128 +++++++
 include/linux/writeback.h                |    4 +-
 ipc/mqueue.c                             |    2 +-
 kernel/futex.c                           |    2 +-
 kernel/sysctl.c                          |    4 +-
 mm/backing-dev.c                         |    8 +-
 mm/filemap.c                             |    6 +-
 mm/rmap.c                                |    6 +-
 mm/shmem.c                               |    6 +-
 net/socket.c                             |    2 +-
 85 files changed, 1001 insertions(+), 437 deletions(-)
 create mode 100644 include/linux/list_bl.h
 create mode 100644 include/linux/rculist_bl.h
