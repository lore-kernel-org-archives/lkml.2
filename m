Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0K0K3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:29:34 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34794 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763Ab0K0K0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAO1p8Ex5Lcx2/2dsb2JhbACVCQGOAXK9doVHBIUUhU0
Message-Id: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 21:15:58 +1100
Subject: [PATCH 00/46] rcu-walk and dcache scaling
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working

Here is an new set of vfs patches for review, not that there was much interest
last time they were posted. It is structured like:

* preparation patches
* introduce new locks to take over dcache_lock, then remove it
* cleaning up and reworking things for new locks
* rcu-walk path walking
* start on some fine grained locking steps

Thanks,
Nick


Nick Piggin (46):
  Revert "fs: use RCU read side protection in d_validate"
  fs: d_validate fixes
  kernel: kmem_ptr_validate considered harmful
  fs: dcache documentation cleanup
  fs: change d_delete semantics
  cifs: dont overwrite dentry name in d_revalidate
  jfs: dont overwrite dentry name in d_revalidate
  fs: change d_compare for rcu-walk
  fs: change d_hash for rcu-walk
  hostfs: simplify locking
  fs: dcache scale hash
  fs: dcache scale lru
  fs: dcache scale dentry refcount
  fs: dcache scale d_unhashed
  fs: dcache scale subdirs
  fs: scale inode alias list
  fs: Use rename lock and RCU for multi-step operations
  fs: increase d_name lock coverage
  fs: dcache remove dcache_lock
  fs: dcache avoid starvation in dcache multi-step operations
  fs: dcache reduce dput locking
  fs: dcache reduce locking in d_alloc
  fs: dcache reduce dcache_inode_lock
  fs: dcache rationalise dget variants
  fs: dcache reduce d_parent locking
  fs: dcache reduce prune_one_dentry locking
  fs: reduce dcache_inode_lock width in lru scanning
  fs: use RCU in shrink_dentry_list to reduce lock nesting
  fs: consolidate dentry kill sequence
  fs: icache RCU free inodes
  fs: avoid inode RCU freeing for pseudo fs
  kernel: optimise seqlock
  fs: rcu-walk for path lookup
  fs: fs_struct use seqlock
  fs: dcache remove d_mounted
  fs: dcache reduce branches in lookup path
  fs: cache optimise dentry and inode for rcu-walk
  fs: prefetch inode data in dcache lookup
  fs: d_revalidate_rcu for rcu-walk
  fs: provide rcu-walk aware permission i_ops
  fs: provide simple rcu-walk ACL implementation
  kernel: add bl_list
  bit_spinlock: add required includes
  fs: dcache per-bucket dcache hash locking
  fs: dcache per-inode inode alias locking
  fs: improve scalability of pseudo filesystems

 Documentation/filesystems/Locking            |   23 +-
 Documentation/filesystems/dentry-locking.txt |  174 ----
 Documentation/filesystems/path-lookup.txt    |  247 ++++++
 Documentation/filesystems/porting            |   45 +-
 Documentation/filesystems/vfs.txt            |   54 +-
 arch/ia64/kernel/perfmon.c                   |    4 +-
 arch/powerpc/platforms/cell/spufs/inode.c    |   18 +-
 drivers/infiniband/hw/ipath/ipath_fs.c       |    8 +-
 drivers/infiniband/hw/qib/qib_fs.c           |    5 +-
 drivers/staging/autofs/root.c                |    2 +-
 drivers/staging/pohmelfs/inode.c             |   11 +-
 drivers/staging/pohmelfs/path_entry.c        |   17 +-
 drivers/staging/smbfs/cache.c                |   10 +-
 drivers/usb/core/inode.c                     |   12 +-
 fs/9p/vfs_dentry.c                           |    4 +-
 fs/9p/vfs_inode.c                            |   39 +-
 fs/adfs/dir.c                                |   13 +-
 fs/adfs/super.c                              |   11 +-
 fs/affs/amigaffs.c                           |    4 +-
 fs/affs/namei.c                              |   66 +-
 fs/affs/super.c                              |   11 +-
 fs/afs/dir.c                                 |    6 +-
 fs/afs/super.c                               |   10 +-
 fs/anon_inodes.c                             |    4 +-
 fs/autofs4/autofs_i.h                        |   21 +-
 fs/autofs4/expire.c                          |  143 ++--
 fs/autofs4/inode.c                           |    2 +-
 fs/autofs4/root.c                            |   78 +-
 fs/autofs4/waitq.c                           |   23 +-
 fs/befs/linuxvfs.c                           |   10 +-
 fs/bfs/inode.c                               |    9 +-
 fs/block_dev.c                               |    9 +-
 fs/btrfs/acl.c                               |   19 +-
 fs/btrfs/ctree.h                             |    4 +-
 fs/btrfs/export.c                            |    4 +-
 fs/btrfs/inode.c                             |   27 +-
 fs/ceph/dir.c                                |   21 +-
 fs/ceph/inode.c                              |   27 +-
 fs/ceph/mds_client.c                         |    2 +-
 fs/cifs/cifsfs.c                             |    9 +-
 fs/cifs/dir.c                                |   75 +-
 fs/cifs/inode.c                              |   14 +-
 fs/cifs/link.c                               |    4 +-
 fs/cifs/readdir.c                            |    6 +-
 fs/coda/cache.c                              |    4 +-
 fs/coda/dir.c                                |    8 +-
 fs/coda/inode.c                              |    9 +-
 fs/configfs/configfs_internal.h              |    4 +-
 fs/configfs/dir.c                            |   13 +-
 fs/configfs/inode.c                          |    8 +-
 fs/dcache.c                                  | 1224 ++++++++++++++++++--------
 fs/ecryptfs/dentry.c                         |   15 +-
 fs/ecryptfs/inode.c                          |    8 +-
 fs/ecryptfs/main.c                           |    4 +-
 fs/ecryptfs/super.c                          |   12 +-
 fs/efs/super.c                               |    9 +-
 fs/exofs/super.c                             |    9 +-
 fs/exportfs/expfs.c                          |   14 +-
 fs/ext2/acl.c                                |   11 +-
 fs/ext2/acl.h                                |    8 +-
 fs/ext2/file.c                               |    2 +-
 fs/ext2/namei.c                              |    4 +-
 fs/ext2/super.c                              |    9 +-
 fs/ext3/acl.c                                |   11 +-
 fs/ext3/acl.h                                |    8 +-
 fs/ext3/file.c                               |    2 +-
 fs/ext3/namei.c                              |    4 +-
 fs/ext3/super.c                              |    9 +-
 fs/ext4/acl.c                                |   11 +-
 fs/ext4/acl.h                                |    4 +-
 fs/ext4/file.c                               |    2 +-
 fs/ext4/namei.c                              |    4 +-
 fs/ext4/super.c                              |    9 +-
 fs/fat/inode.c                               |   13 +-
 fs/fat/namei_msdos.c                         |   24 +-
 fs/fat/namei_vfat.c                          |   69 +-
 fs/filesystems.c                             |    3 +
 fs/freevxfs/vxfs_inode.c                     |    9 +-
 fs/fs_struct.c                               |   10 +
 fs/fuse/dir.c                                |    9 +-
 fs/fuse/inode.c                              |   13 +-
 fs/generic_acl.c                             |   20 +
 fs/gfs2/dentry.c                             |    5 +-
 fs/gfs2/export.c                             |    4 +-
 fs/gfs2/ops_fstype.c                         |    2 +-
 fs/gfs2/ops_inode.c                          |    2 +-
 fs/gfs2/super.c                              |    9 +-
 fs/hfs/dir.c                                 |    2 +-
 fs/hfs/hfs_fs.h                              |    7 +-
 fs/hfs/string.c                              |   17 +-
 fs/hfs/super.c                               |   11 +-
 fs/hfsplus/dir.c                             |    2 +-
 fs/hfsplus/hfsplus_fs.h                      |    7 +-
 fs/hfsplus/super.c                           |   12 +-
 fs/hfsplus/unicode.c                         |   17 +-
 fs/hostfs/hostfs_kern.c                      |   37 +-
 fs/hpfs/dentry.c                             |   26 +-
 fs/hpfs/super.c                              |    9 +-
 fs/hppfs/hppfs.c                             |    9 +-
 fs/hugetlbfs/inode.c                         |    9 +-
 fs/inode.c                                   |   16 +-
 fs/isofs/inode.c                             |  127 ++--
 fs/isofs/namei.c                             |    5 +-
 fs/jffs2/super.c                             |    9 +-
 fs/jfs/namei.c                               |   60 +-
 fs/jfs/super.c                               |   12 +-
 fs/libfs.c                                   |   63 +-
 fs/locks.c                                   |    2 +-
 fs/logfs/inode.c                             |    9 +-
 fs/minix/inode.c                             |    9 +-
 fs/minix/namei.c                             |    2 +-
 fs/namei.c                                   |  855 +++++++++++++++----
 fs/namespace.c                               |   29 +-
 fs/ncpfs/dir.c                               |   66 +-
 fs/ncpfs/inode.c                             |   11 +-
 fs/ncpfs/ncplib_kernel.h                     |   16 +-
 fs/nfs/dir.c                                 |   17 +-
 fs/nfs/getroot.c                             |   10 +-
 fs/nfs/inode.c                               |    9 +-
 fs/nfs/namespace.c                           |   17 +-
 fs/nfs/unlink.c                              |    2 +-
 fs/nfsd/vfs.c                                |    5 +-
 fs/nilfs2/super.c                            |   12 +-
 fs/notify/fsnotify.c                         |    8 +-
 fs/ntfs/inode.c                              |    9 +-
 fs/ocfs2/dcache.c                            |   10 +-
 fs/ocfs2/dlmfs/dlmfs.c                       |    9 +-
 fs/ocfs2/export.c                            |    4 +-
 fs/ocfs2/namei.c                             |   10 +-
 fs/ocfs2/super.c                             |    9 +-
 fs/openpromfs/inode.c                        |    9 +-
 fs/pipe.c                                    |   10 +-
 fs/proc/base.c                               |   14 +-
 fs/proc/generic.c                            |    4 +-
 fs/proc/inode.c                              |    9 +-
 fs/proc/proc_sysctl.c                        |   18 +-
 fs/qnx4/inode.c                              |    9 +-
 fs/reiserfs/super.c                          |    9 +-
 fs/reiserfs/xattr.c                          |    2 +-
 fs/romfs/super.c                             |    9 +-
 fs/squashfs/super.c                          |    9 +-
 fs/super.c                                   |    3 +-
 fs/sysfs/dir.c                               |   22 +-
 fs/sysv/inode.c                              |    9 +-
 fs/sysv/namei.c                              |    5 +-
 fs/sysv/super.c                              |    2 +-
 fs/ubifs/super.c                             |   10 +-
 fs/udf/super.c                               |    9 +-
 fs/ufs/super.c                               |    9 +-
 fs/xfs/linux-2.6/xfs_acl.c                   |    8 +-
 fs/xfs/linux-2.6/xfs_iops.c                  |    8 +-
 fs/xfs/xfs_acl.h                             |    4 +-
 fs/xfs/xfs_iget.c                            |   13 +-
 include/linux/bit_spinlock.h                 |    4 +
 include/linux/dcache.h                       |  183 ++--
 include/linux/fs.h                           |   61 +-
 include/linux/fs_struct.h                    |    3 +
 include/linux/fsnotify.h                     |    2 -
 include/linux/fsnotify_backend.h             |   11 +-
 include/linux/generic_acl.h                  |    1 +
 include/linux/list_bl.h                      |  141 +++
 include/linux/namei.h                        |   16 +-
 include/linux/ncp_fs.h                       |    4 +-
 include/linux/posix_acl.h                    |   19 +
 include/linux/rculist_bl.h                   |  128 +++
 include/linux/seqlock.h                      |   67 ++-
 include/linux/slab.h                         |    2 -
 ipc/mqueue.c                                 |    9 +-
 kernel/cgroup.c                              |   29 +-
 mm/filemap.c                                 |    3 -
 mm/shmem.c                                   |   15 +-
 mm/slab.c                                    |   32 +-
 mm/slob.c                                    |    5 -
 mm/slub.c                                    |   40 -
 mm/util.c                                    |   21 -
 net/socket.c                                 |    5 +-
 net/sunrpc/rpc_pipe.c                        |   14 +-
 security/selinux/selinuxfs.c                 |   16 +-
 security/tomoyo/realpath.c                   |    1 +
 179 files changed, 3848 insertions(+), 1711 deletions(-)
 delete mode 100644 Documentation/filesystems/dentry-locking.txt
 create mode 100644 Documentation/filesystems/path-lookup.txt
 create mode 100644 include/linux/list_bl.h
 create mode 100644 include/linux/rculist_bl.h

