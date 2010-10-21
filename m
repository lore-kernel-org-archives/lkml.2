Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0JUFE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 01:04:27 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:50759 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750774Ab0JUFE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 01:04:26 -0400
Date: Thu, 21 Oct 2010 16:04:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101021050422.GP32255@dastard>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I just pushed a new version of this patchset which is pretty much a rebase on
2.6.36 out. I'm not going to post all the patches as not much changed - mostly
comments were changed. The changelog for the update is:

Version 7:
- rebase on 2.6.36
- iref() to inode->i_ref++ conversion in fs/nfs/write.c
- removed stray inode hash removal call from patches it didn't
  belong in.
- cleaned up another stale remove_inode_hash comment.
- cleaned up more comments as reported by Christian Stroetmann
  <stroetmann@ontolinux.com>.

--

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git inode-scale

Christoph Hellwig (4):
      fs: Stop abusing find_inode_fast in iunique
      fs: move i_ref increments into find_inode/find_inode_fast
      fs: remove inode_add_to_list/__inode_add_to_list
      fs: do not assign default i_ino in new_inode

Dave Chinner (13):
      fs: switch bdev inode bdi's correctly
      fs: Convert nr_inodes and nr_unused to per-cpu counters
      fs: Clean up inode reference counting
      exofs: use iput() for inode reference count decrements
      fs: rework icount to be a locked variable
      fs: Factor inode hash operations into functions
      fs: Introduce per-bucket inode hash locks
      fs: add a per-superblock lock for the inode list
      fs: split locking of inode writeback and LRU lists
      fs: Protect inode->i_state with the inode->i_lock
      fs: protect wake_up_inode with inode->i_lock
      fs: icache remove inode_lock
      fs: Reduce inode I_FREEING and factor inode disposal

Eric Dumazet (1):
      fs: introduce a per-cpu last_ino allocator

Nick Piggin (3):
      kernel: add bl_list
      fs: Implement lazy LRU updates for inodes
      fs: inode split IO and LRU lists

 Documentation/filesystems/Locking        |    2 +-
 Documentation/filesystems/porting        |   16 +-
 Documentation/filesystems/vfs.txt        |   16 +-
 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 drivers/infiniband/hw/ipath/ipath_fs.c   |    1 +
 drivers/infiniband/hw/qib/qib_fs.c       |    1 +
 drivers/misc/ibmasm/ibmasmfs.c           |    1 +
 drivers/oprofile/oprofilefs.c            |    1 +
 drivers/usb/core/inode.c                 |    1 +
 drivers/usb/gadget/f_fs.c                |    1 +
 drivers/usb/gadget/inode.c               |    1 +
 fs/9p/vfs_inode.c                        |    5 +-
 fs/affs/inode.c                          |    2 +-
 fs/afs/dir.c                             |    2 +-
 fs/anon_inodes.c                         |    8 +-
 fs/autofs4/inode.c                       |    1 +
 fs/bfs/dir.c                             |    2 +-
 fs/binfmt_misc.c                         |    1 +
 fs/block_dev.c                           |   42 +-
 fs/btrfs/inode.c                         |   18 +-
 fs/buffer.c                              |    2 +-
 fs/ceph/mds_client.c                     |    2 +-
 fs/cifs/inode.c                          |    2 +-
 fs/coda/dir.c                            |    2 +-
 fs/configfs/inode.c                      |    1 +
 fs/debugfs/inode.c                       |    1 +
 fs/drop_caches.c                         |   19 +-
 fs/exofs/inode.c                         |    6 +-
 fs/exofs/namei.c                         |    2 +-
 fs/ext2/namei.c                          |    2 +-
 fs/ext3/ialloc.c                         |    4 +-
 fs/ext3/namei.c                          |    2 +-
 fs/ext4/ialloc.c                         |    4 +-
 fs/ext4/mballoc.c                        |    1 +
 fs/ext4/namei.c                          |    2 +-
 fs/freevxfs/vxfs_inode.c                 |    1 +
 fs/fs-writeback.c                        |  235 +++++----
 fs/fuse/control.c                        |    1 +
 fs/gfs2/ops_inode.c                      |    2 +-
 fs/hfs/hfs_fs.h                          |    2 +-
 fs/hfs/inode.c                           |    2 +-
 fs/hfsplus/dir.c                         |    2 +-
 fs/hfsplus/hfsplus_fs.h                  |    2 +-
 fs/hfsplus/inode.c                       |    2 +-
 fs/hpfs/inode.c                          |    2 +-
 fs/hugetlbfs/inode.c                     |    1 +
 fs/inode.c                               |  852 +++++++++++++++++++-----------
 fs/internal.h                            |   11 +
 fs/jffs2/dir.c                           |    4 +-
 fs/jfs/jfs_txnmgr.c                      |    2 +-
 fs/jfs/namei.c                           |    2 +-
 fs/libfs.c                               |    2 +-
 fs/locks.c                               |    2 +-
 fs/logfs/dir.c                           |    2 +-
 fs/logfs/inode.c                         |    2 +-
 fs/logfs/readwrite.c                     |    2 +-
 fs/minix/namei.c                         |    2 +-
 fs/namei.c                               |    2 +-
 fs/nfs/dir.c                             |    2 +-
 fs/nfs/getroot.c                         |    2 +-
 fs/nfs/inode.c                           |    4 +-
 fs/nfs/nfs4state.c                       |    2 +-
 fs/nfs/write.c                           |    2 +-
 fs/nilfs2/gcdat.c                        |    1 +
 fs/nilfs2/gcinode.c                      |   22 +-
 fs/nilfs2/mdt.c                          |    5 +-
 fs/nilfs2/namei.c                        |    2 +-
 fs/nilfs2/segment.c                      |    2 +-
 fs/nilfs2/the_nilfs.h                    |    2 +-
 fs/notify/inode_mark.c                   |   46 +-
 fs/notify/mark.c                         |    1 -
 fs/notify/vfsmount_mark.c                |    1 -
 fs/ntfs/inode.c                          |   10 +-
 fs/ntfs/super.c                          |    6 +-
 fs/ocfs2/dlmfs/dlmfs.c                   |    2 +
 fs/ocfs2/inode.c                         |    2 +-
 fs/ocfs2/namei.c                         |    2 +-
 fs/pipe.c                                |    2 +
 fs/proc/base.c                           |    2 +
 fs/proc/proc_sysctl.c                    |    2 +
 fs/quota/dquot.c                         |   32 +-
 fs/ramfs/inode.c                         |    1 +
 fs/reiserfs/namei.c                      |    2 +-
 fs/reiserfs/stree.c                      |    2 +-
 fs/reiserfs/xattr.c                      |    2 +-
 fs/smbfs/inode.c                         |    2 +-
 fs/super.c                               |    1 +
 fs/sysv/namei.c                          |    2 +-
 fs/ubifs/dir.c                           |    2 +-
 fs/ubifs/super.c                         |    2 +-
 fs/udf/inode.c                           |    2 +-
 fs/udf/namei.c                           |    2 +-
 fs/ufs/namei.c                           |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c               |    1 +
 fs/xfs/linux-2.6/xfs_iops.c              |    6 +-
 fs/xfs/linux-2.6/xfs_trace.h             |    2 +-
 fs/xfs/xfs_inode.h                       |    3 +-
 include/linux/backing-dev.h              |    3 +
 include/linux/fs.h                       |   43 +-
 include/linux/list_bl.h                  |  146 +++++
 include/linux/poison.h                   |    2 +
 include/linux/writeback.h                |    4 -
 ipc/mqueue.c                             |    3 +-
 kernel/cgroup.c                          |    1 +
 kernel/futex.c                           |    2 +-
 kernel/sysctl.c                          |    4 +-
 mm/backing-dev.c                         |   28 +-
 mm/filemap.c                             |    6 +-
 mm/rmap.c                                |    6 +-
 mm/shmem.c                               |    7 +-
 net/socket.c                             |    3 +-
 net/sunrpc/rpc_pipe.c                    |    1 +
 security/inode.c                         |    1 +
 security/selinux/selinuxfs.c             |    1 +
 114 files changed, 1134 insertions(+), 628 deletions(-)
 create mode 100644 include/linux/list_bl.h

-- 
Dave Chinner
david@fromorbit.com
