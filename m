Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab0JZXR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 19:17:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35136 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab0JZXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 19:17:26 -0400
Date: Wed, 27 Oct 2010 00:17:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs, part 1
Message-ID: <20101026231725.GB19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	That should cover most of the misc stuff + beginning of unification
of icache scalability patchsets.  Actual locking changes are _not_ in that
set yet.  Please pull from the usual place (
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git #for-linus
); more to follow.

Shortlog:

Al Viro (10):
      ext2_remount: don't bother with invalidate_inodes()
      gfs2: invalidate_inodes() is no-op there
      ntfs: don't call invalidate_inodes()
      smbfs never retains inodes with zero refcount in the first place
      unexport invalidate_inodes
      new helper: inode_unhashed()
      list.h: new helper - hlist_add_fake()
      switch hfs to hlist_add_fake()
      new helper: ihold()
      split invalidate_inodes()

Chris Mason (1):
      aio: bump i_count instead of using igrab

Christoph Hellwig (23):
      fs: move permission check back into __lookup_hash
      fs: add sync_inode_metadata
      fs: mark destroy_inode static
      fs: kill block_prepare_write
      hfs: use sync_dirty_buffer
      update block_device_operations documentation
      fs: Stop abusing find_inode_fast in iunique
      fs: move i_count increments into find_inode/find_inode_fast
      fs: remove inode_add_to_list/__inode_add_to_list
      fs: do not assign default i_ino in new_inode
      fs: take dcache_lock inside __d_path
      fs: simplify __d_free
      fs: use percpu counter for nr_dentry and nr_dentry_unused
      fs: split __shrink_dcache_sb
      fs: clean up dentry lru modification
      fs: use RCU read side protection in d_validate
      exportfs: use dget_parent
      smbfs: use dget_parent
      fsnotify: use dget_parent
      fs: fix buffer invalidation in invalidate_list
      fs: do not drop inode_lock in dispose_list
      fs: fold invalidate_list into invalidate_inodes
      fs: skip I_FREEING inodes in writeback_sb_inodes

Dan Carpenter (1):
      affs: testing the wrong variable

Dave Chinner (3):
      fs: Convert nr_inodes and nr_unused to per-cpu counters
      fs: Factor inode hash operations into functions
      fs: switch bdev inode bdi's correctly

Eric Dumazet (2):
      fs: allow for more than 2^31 files
      fs: introduce a per-cpu last_ino allocator

Jan Kara (1):
      isofs: Fix isofs_get_blocks for 8TB files

KAMEZAWA Hiroyuki (1):
      vfs: introduce FMODE_UNSIGNED_OFFSET for allowing negative f_pos

Miklos Szeredi (1):
      vfs: fix infinite loop caused by clone_mnt race

Namhyung Kim (3):
      fs/buffer.c: remove duplicated assignment on b_private
      lockdep: fixup checking of dir inode annotation
      fs/buffer.c: call __block_write_begin() if we have page

Nick Piggin (3):
      fs: Implement lazy LRU updates for inodes
      fs: improve DCACHE_REFERENCED usage
      fs: inode split IO and LRU lists

Randy Dunlap (1):
      fs: move exportfs since it is not a networking filesystem

Richard Weinberger (1):
      hostfs: fix UML crash: remove f_spare from hostfs

Valerie Aurora (1):
      Documentation: Fix trivial typo in filesystems/sharedsubtree.txt

Diffstat:
 Documentation/filesystems/Locking           |   31 ++-
 Documentation/filesystems/sharedsubtree.txt |    4 +-
 drivers/char/mem.c                          |    4 +
 drivers/infiniband/hw/ipath/ipath_fs.c      |    1 +
 drivers/infiniband/hw/qib/qib_fs.c          |    1 +
 drivers/misc/ibmasm/ibmasmfs.c              |    1 +
 drivers/oprofile/oprofilefs.c               |    1 +
 drivers/staging/pohmelfs/inode.c            |    6 +-
 drivers/usb/core/inode.c                    |    1 +
 drivers/usb/gadget/f_fs.c                   |    1 +
 drivers/usb/gadget/inode.c                  |    1 +
 fs/9p/vfs_inode.c                           |    5 +-
 fs/Kconfig                                  |    6 +-
 fs/affs/file.c                              |    4 +-
 fs/affs/inode.c                             |    2 +-
 fs/afs/dir.c                                |    2 +-
 fs/aio.c                                    |   14 +-
 fs/anon_inodes.c                            |    6 +-
 fs/autofs4/inode.c                          |    1 +
 fs/bfs/dir.c                                |    2 +-
 fs/binfmt_misc.c                            |    1 +
 fs/block_dev.c                              |   34 ++-
 fs/btrfs/inode.c                            |    4 +-
 fs/buffer.c                                 |   27 +-
 fs/coda/dir.c                               |    2 +-
 fs/configfs/inode.c                         |    1 +
 fs/dcache.c                                 |  277 ++++++++-------
 fs/debugfs/inode.c                          |    1 +
 fs/exofs/file.c                             |    6 +-
 fs/exofs/namei.c                            |    2 +-
 fs/exportfs/expfs.c                         |   17 +-
 fs/ext2/dir.c                               |    2 +-
 fs/ext2/ext2.h                              |    1 -
 fs/ext2/inode.c                             |   11 +-
 fs/ext2/namei.c                             |    2 +-
 fs/ext2/super.c                             |    4 +-
 fs/ext2/xattr.c                             |    2 +-
 fs/ext3/inode.c                             |    4 +-
 fs/ext3/namei.c                             |    2 +-
 fs/ext4/inode.c                             |   11 +-
 fs/ext4/mballoc.c                           |    1 +
 fs/ext4/namei.c                             |    2 +-
 fs/file_table.c                             |   17 +-
 fs/freevxfs/vxfs_inode.c                    |    1 +
 fs/fs-writeback.c                           |   80 +++--
 fs/fuse/control.c                           |    1 +
 fs/gfs2/aops.c                              |    3 +-
 fs/gfs2/ops_fstype.c                        |    1 -
 fs/gfs2/ops_inode.c                         |    8 +-
 fs/gfs2/super.c                             |    1 -
 fs/hfs/hfs_fs.h                             |   13 -
 fs/hfs/inode.c                              |    2 +-
 fs/hfs/mdb.c                                |    4 +-
 fs/hfs/super.c                              |    1 -
 fs/hfsplus/dir.c                            |    2 +-
 fs/hfsplus/inode.c                          |    2 +-
 fs/hostfs/hostfs.h                          |    3 +-
 fs/hostfs/hostfs_kern.c                     |    2 +-
 fs/hostfs/hostfs_user.c                     |    9 +-
 fs/hugetlbfs/inode.c                        |    1 +
 fs/inode.c                                  |  526 +++++++++++++++++----------
 fs/internal.h                               |    7 +
 fs/isofs/inode.c                            |   17 +-
 fs/jffs2/dir.c                              |    4 +-
 fs/jfs/jfs_imap.c                           |    2 +-
 fs/jfs/jfs_txnmgr.c                         |    2 +-
 fs/jfs/namei.c                              |    2 +-
 fs/libfs.c                                  |    8 +-
 fs/logfs/dir.c                              |    2 +-
 fs/minix/namei.c                            |    2 +-
 fs/namei.c                                  |   16 +-
 fs/namespace.c                              |    2 +-
 fs/nfs/dir.c                                |    2 +-
 fs/nfs/getroot.c                            |    3 +-
 fs/nfsd/vfs.c                               |   16 +-
 fs/nilfs2/namei.c                           |    2 +-
 fs/notify/fsnotify.c                        |   33 +--
 fs/notify/inode_mark.c                      |    2 +
 fs/ntfs/super.c                             |   19 +-
 fs/ocfs2/aops.c                             |   19 +-
 fs/ocfs2/aops.h                             |    3 -
 fs/ocfs2/dlmfs/dlmfs.c                      |    2 +
 fs/ocfs2/file.c                             |    9 +-
 fs/ocfs2/namei.c                            |    2 +-
 fs/pipe.c                                   |    2 +
 fs/proc/base.c                              |    4 +
 fs/proc/proc_sysctl.c                       |    2 +
 fs/ramfs/inode.c                            |    1 +
 fs/read_write.c                             |   28 ++-
 fs/reiserfs/inode.c                         |   24 +-
 fs/reiserfs/ioctl.c                         |    6 +-
 fs/reiserfs/namei.c                         |    2 +-
 fs/reiserfs/xattr.c                         |    7 +-
 fs/seq_file.c                               |    2 -
 fs/smbfs/dir.c                              |   16 +-
 fs/smbfs/inode.c                            |    1 -
 fs/smbfs/proc.c                             |   10 +-
 fs/super.c                                  |    8 +-
 fs/sysv/namei.c                             |    2 +-
 fs/ubifs/dir.c                              |    2 +-
 fs/udf/namei.c                              |    2 +-
 fs/ufs/namei.c                              |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c                  |    1 +
 fs/xfs/linux-2.6/xfs_iops.c                 |    6 +-
 fs/xfs/linux-2.6/xfs_super.c                |    2 +-
 fs/xfs/xfs_inode.h                          |    2 +-
 include/linux/buffer_head.h                 |    1 -
 include/linux/fs.h                          |   47 ++-
 include/linux/list.h                        |    6 +
 include/linux/reiserfs_fs.h                 |    2 +
 include/linux/writeback.h                   |    2 -
 ipc/mqueue.c                                |    3 +-
 kernel/cgroup.c                             |    1 +
 kernel/futex.c                              |    2 +-
 kernel/sysctl.c                             |   12 +-
 mm/backing-dev.c                            |    6 +-
 mm/shmem.c                                  |    7 +-
 net/socket.c                                |    3 +-
 net/sunrpc/rpc_pipe.c                       |    1 +
 net/unix/af_unix.c                          |   14 +-
 security/apparmor/path.c                    |    2 -
 security/inode.c                            |    1 +
 security/selinux/selinuxfs.c                |    1 +
 security/tomoyo/realpath.c                  |    2 -
 124 files changed, 879 insertions(+), 727 deletions(-)
