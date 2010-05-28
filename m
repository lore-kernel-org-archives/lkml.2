Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0E1PvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:51:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40628 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0E1PvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:51:06 -0400
Date: Fri, 28 May 2010 16:51:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile, part 2
Message-ID: <20100528155102.GK31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Mostly assorted fixes + fsync API change + infrastructure and
simple conversions of "new truncate scheme" series.  BTW, long-standing
abuse of file refcounting by aio.c is gone; now we have a new helper
(fput_atomic(file)) suitable for calling in atomic contexts.  It drops
the reference if it's not the last one (i.e. if nothing potentially
blocking needs to be done) and tells the caller whether it had succeeded
or not (in the latter case you still need to do normal fput() outside of
atomic context, of course).

	Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (5):
      Revert "anon_inode: set S_IFREG on the anon_inode"
      get rid of the magic around f_count in aio
      Fix racy use of anon_inode_getfd() in perf_event.c
      fix fs/sysv s_dirt handling
      remove detritus left by "mm: make read_cache_page synchronous"

Christoph Hellwig (2):
      drop unused dentry argument to ->fsync
      rename the generic fsync implementations

Erik van der Kouwe (1):
      fs/minix: bugfix, number of indirect block ptrs per block depends on block size

Julia Lawall (1):
      fs: Add missing mutex_unlock

Neil Brown (1):
      VFS: fix recent breakage of FS_REVAL_DOT

Nick Piggin (1):
      fs: convert simple fs to new truncate

Randy Dunlap (1):
      fs/super: fix kernel-doc warning

npiggin@suse.de (5):
      fs: introduce new truncate sequence
      kill spurious reference to vmtruncate
      tmpfs: convert to use the new truncate convention
      ext2: convert to use the new truncate convention.
      fat: convert to use the new truncate convention.

Diffstat:
 Documentation/filesystems/Locking         |    2 +-
 Documentation/filesystems/vfs.txt         |    9 ++-
 arch/powerpc/platforms/cell/spufs/file.c  |    3 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 drivers/char/ps3flash.c                   |    3 +-
 drivers/mtd/ubi/cdev.c                    |    3 +-
 drivers/staging/pohmelfs/inode.c          |    2 +-
 drivers/usb/gadget/printer.c              |    2 +-
 drivers/video/fb_defio.c                  |    2 +-
 fs/9p/vfs_file.c                          |    6 +-
 fs/adfs/dir.c                             |    2 +-
 fs/adfs/file.c                            |    2 +-
 fs/adfs/inode.c                           |    3 +-
 fs/affs/affs.h                            |    2 +-
 fs/affs/file.c                            |    4 +-
 fs/afs/internal.h                         |    2 +-
 fs/afs/write.c                            |    3 +-
 fs/aio.c                                  |    6 +-
 fs/anon_inodes.c                          |    2 +-
 fs/attr.c                                 |   50 ++++++++--
 fs/bad_inode.c                            |    3 +-
 fs/bfs/dir.c                              |    2 +-
 fs/block_dev.c                            |   16 +--
 fs/btrfs/ctree.h                          |    2 +-
 fs/btrfs/file.c                           |    3 +-
 fs/buffer.c                               |  123 ++++++++++++++++++-----
 fs/ceph/caps.c                            |    4 +-
 fs/ceph/dir.c                             |    5 +-
 fs/ceph/super.h                           |    2 +-
 fs/cifs/cifsfs.h                          |    2 +-
 fs/cifs/file.c                            |    4 +-
 fs/coda/coda_int.h                        |    3 +-
 fs/coda/file.c                            |    4 +-
 fs/configfs/inode.c                       |    9 +--
 fs/direct-io.c                            |   61 ++++++++----
 fs/ecryptfs/file.c                        |    2 +-
 fs/ecryptfs/inode.c                       |    4 +-
 fs/exofs/file.c                           |    7 +-
 fs/ext2/ext2.h                            |    3 +-
 fs/ext2/file.c                            |    7 +-
 fs/ext2/inode.c                           |  153 ++++++++++++++++++++++-------
 fs/ext3/fsync.c                           |    4 +-
 fs/ext4/ext4.h                            |    2 +-
 fs/ext4/fsync.c                           |    8 +-
 fs/fat/fat.h                              |    6 +-
 fs/fat/file.c                             |   40 ++++++--
 fs/fat/inode.c                            |   35 ++++++-
 fs/file_table.c                           |   21 ++--
 fs/fuse/dir.c                             |    5 +-
 fs/fuse/file.c                            |    9 +-
 fs/fuse/fuse_i.h                          |    3 +-
 fs/gfs2/aops.c                            |    8 ++-
 fs/gfs2/file.c                            |    4 +-
 fs/gfs2/ops_inode.c                       |    5 +-
 fs/hostfs/hostfs_kern.c                   |    4 +-
 fs/hpfs/file.c                            |    4 +-
 fs/hpfs/hpfs_fn.h                         |    2 +-
 fs/hppfs/hppfs.c                          |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/jffs2/file.c                           |    4 +-
 fs/jffs2/fs.c                             |    4 +-
 fs/jffs2/os-linux.h                       |    2 +-
 fs/jfs/file.c                             |    4 +-
 fs/jfs/jfs_inode.h                        |    2 +-
 fs/libfs.c                                |  108 ++++++++++++++++++--
 fs/logfs/file.c                           |    4 +-
 fs/logfs/logfs.h                          |    2 +-
 fs/minix/dir.c                            |    7 +-
 fs/minix/file.c                           |    2 +-
 fs/minix/itree_v2.c                       |   27 +++---
 fs/namei.c                                |    2 +-
 fs/ncpfs/file.c                           |    2 +-
 fs/nfs/dir.c                              |    6 +-
 fs/nfs/file.c                             |    5 +-
 fs/nilfs2/file.c                          |    4 +-
 fs/nilfs2/nilfs.h                         |    2 +-
 fs/ntfs/dir.c                             |    5 +-
 fs/ntfs/file.c                            |    9 +--
 fs/ocfs2/file.c                           |   15 ++-
 fs/omfs/file.c                            |    2 +-
 fs/pipe.c                                 |   13 ++-
 fs/qnx4/dir.c                             |    2 +-
 fs/ramfs/file-mmu.c                       |    3 +-
 fs/ramfs/file-nommu.c                     |    9 +-
 fs/reiserfs/dir.c                         |    8 +-
 fs/reiserfs/file.c                        |    5 +-
 fs/smbfs/file.c                           |    3 +-
 fs/smbfs/inode.c                          |    2 +-
 fs/super.c                                |    4 +-
 fs/sync.c                                 |    8 +-
 fs/sysfs/inode.c                          |    8 +-
 fs/sysv/dir.c                             |    2 +-
 fs/sysv/file.c                            |    2 +-
 fs/sysv/inode.c                           |    1 +
 fs/ubifs/file.c                           |   17 ++--
 fs/ubifs/ubifs.h                          |    4 +-
 fs/udf/dir.c                              |    2 +-
 fs/udf/file.c                             |    2 +-
 fs/ufs/dir.c                              |    2 +-
 fs/ufs/file.c                             |    2 +-
 fs/ufs/truncate.c                         |   10 +-
 fs/xfs/linux-2.6/xfs_file.c               |   10 +-
 include/linux/buffer_head.h               |   11 ++-
 include/linux/ext3_fs.h                   |    2 +-
 include/linux/fb.h                        |    5 +-
 include/linux/file.h                      |    1 -
 include/linux/fs.h                        |   36 ++++++-
 include/trace/events/ext4.h               |    6 +-
 ipc/shm.c                                 |   11 +--
 kernel/perf_event.c                       |   40 ++++----
 mm/shmem.c                                |   45 +++++----
 mm/truncate.c                             |   10 +-
 112 files changed, 782 insertions(+), 415 deletions(-)
