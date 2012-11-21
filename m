Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2KVTdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:33:41 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:41808 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab2KVTdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:33:39 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 00/31] loop: Issue O_DIRECT aio using bio_vec
Date: Wed, 21 Nov 2012 16:40:40 -0600
Message-Id: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset was begun by Zach Brown and was originally submitted for
review in October, 2009. Feedback was positive, and I have picked up
where he left off, porting his patches to the latest mainline kernel
and adding support more file systems.

This patch series adds a kernel interface to fs/aio.c so that kernel code can
issue concurrent asynchronous IO to file systems.  It adds an aio command and
file system methods which specify io memory with pages instead of userspace
addresses.

This series was written to reduce the current overhead loop imposes by
performing synchronus buffered file system IO from a kernel thread.  These
patches turn loop into a light weight layer that translates bios into iocbs.

It introduces new file ops, read_iter() and write_iter(), that replace the
aio_read() and aio_write() operations. The iov_iter structure can now contain
either a user-space iovec or a kernel-space bio_vec. Since it would be
overly complicated to replace every instance of aio_read() and aio_write(),
the old operations are not removed, but file systems implementing the new
ones need not keep the old ones.

The biggest change since the last posting is that the vfs will now call
read/write_iter() instead of aio_read/write() whenever the former is
defined. This eliminates the need for the  file system having to support
both the old and new interfaces. I have also added support to more
filesystems, and simplified swap over nfs.

These patches apply to 3.7-rc6 and are also available at:
git://github.com/kleikamp/linux-shaggy.git loop_v4

Asias He (1):
  block_dev: add support for read_iter, write_iter

Dave Kleikamp (17):
  iov_iter: iov_iter_copy_from_user() should use non-atomic copy
  fuse: convert fuse to use iov_iter_copy_[to|from]_user
  dio: Convert direct_IO to use iov_iter
  dio: add bio_vec support to __blockdev_direct_IO()
  fs: create file_readable() and file_writable() functions
  fs: use read_iter and write_iter rather than aio_read and aio_write
  fs: add read_iter and write_iter to several file systems
  ext4: add support for read_iter and write_iter
  nfs: add support for read_iter, write_iter
  nfs: simplify swap
  btrfs: add support for read_iter and write_iter
  xfs: add support for read_iter and write_iter
  gfs2: Convert aio_read/write ops to read/write_iter
  udf: convert file ops from aio_read/write to read/write_iter
  afs: add support for read_iter and write_iter
  ecrpytfs: Convert aio_read/write ops to read/write_iter
  ubifs: convert file ops from aio_read/write to read/write_iter

Zach Brown (13):
  iov_iter: move into its own file
  iov_iter: add copy_to_user support
  iov_iter: hide iovec details behind ops function pointers
  iov_iter: add bvec support
  iov_iter: add a shorten call
  iov_iter: let callers extract iovecs and bio_vecs
  dio: create a dio_aligned() helper function
  fs: pull iov_iter use higher up the stack
  aio: add aio_kernel_() interface
  aio: add aio support for iov_iter arguments
  bio: add bvec_length(), like iov_length()
  loop: use aio to perform io on the underlying file
  ocfs2: add support for read_iter, write_iter, and direct_IO_bvec

 Documentation/filesystems/Locking    |   6 +-
 Documentation/filesystems/vfs.txt    |  12 +-
 drivers/block/loop.c                 | 136 +++++++++---
 drivers/char/raw.c                   |   4 +-
 drivers/mtd/nand/nandsim.c           |   4 +-
 drivers/staging/ccg/storage_common.c |   4 +-
 drivers/usb/gadget/storage_common.c  |   4 +-
 fs/9p/vfs_addr.c                     |  12 +-
 fs/9p/vfs_file.c                     |   8 +-
 fs/adfs/file.c                       |   4 +-
 fs/affs/file.c                       |   4 +-
 fs/afs/file.c                        |   4 +-
 fs/afs/internal.h                    |   3 +-
 fs/afs/write.c                       |   9 +-
 fs/aio.c                             | 170 ++++++++++++++-
 fs/bad_inode.c                       |  14 ++
 fs/bfs/file.c                        |   4 +-
 fs/block_dev.c                       |  26 ++-
 fs/btrfs/file.c                      |  42 ++--
 fs/btrfs/inode.c                     |  61 +++---
 fs/ceph/addr.c                       |   3 +-
 fs/cifs/file.c                       |   4 +-
 fs/compat.c                          |  10 +-
 fs/direct-io.c                       | 253 +++++++++++++++-------
 fs/ecryptfs/file.c                   |  15 +-
 fs/exofs/file.c                      |   4 +-
 fs/ext2/file.c                       |   4 +-
 fs/ext2/inode.c                      |   8 +-
 fs/ext3/file.c                       |   4 +-
 fs/ext3/inode.c                      |  15 +-
 fs/ext4/ext4.h                       |   3 +-
 fs/ext4/file.c                       |  34 +--
 fs/ext4/indirect.c                   |  16 +-
 fs/ext4/inode.c                      |  27 ++-
 fs/fat/file.c                        |   4 +-
 fs/fat/inode.c                       |  10 +-
 fs/fuse/file.c                       |  40 ++--
 fs/gfs2/aops.c                       |   7 +-
 fs/gfs2/file.c                       |  21 +-
 fs/hfs/inode.c                       |  11 +-
 fs/hfsplus/inode.c                   |  10 +-
 fs/hostfs/hostfs_kern.c              |   4 +-
 fs/hpfs/file.c                       |   4 +-
 fs/jffs2/file.c                      |   8 +-
 fs/jfs/file.c                        |   4 +-
 fs/jfs/inode.c                       |   7 +-
 fs/logfs/file.c                      |   4 +-
 fs/minix/file.c                      |   4 +-
 fs/nfs/direct.c                      | 294 +++++++++++++++++---------
 fs/nfs/file.c                        |  33 ++-
 fs/nfs/internal.h                    |   4 +-
 fs/nfs/nfs4file.c                    |   4 +-
 fs/nilfs2/file.c                     |   4 +-
 fs/nilfs2/inode.c                    |   8 +-
 fs/ocfs2/aops.c                      |   8 +-
 fs/ocfs2/aops.h                      |   2 +-
 fs/ocfs2/file.c                      |  53 ++---
 fs/ocfs2/inode.h                     |   2 -
 fs/ocfs2/ocfs2_trace.h               |   6 +-
 fs/omfs/file.c                       |   4 +-
 fs/ramfs/file-mmu.c                  |   4 +-
 fs/ramfs/file-nommu.c                |   4 +-
 fs/read_write.c                      |  66 +++++-
 fs/read_write.h                      |   4 +
 fs/reiserfs/file.c                   |   4 +-
 fs/reiserfs/inode.c                  |   7 +-
 fs/romfs/mmap-nommu.c                |   2 +-
 fs/sysv/file.c                       |   4 +-
 fs/ubifs/file.c                      |  12 +-
 fs/udf/file.c                        |  13 +-
 fs/udf/inode.c                       |  10 +-
 fs/ufs/file.c                        |   4 +-
 fs/xfs/xfs_aops.c                    |  13 +-
 fs/xfs/xfs_file.c                    |  51 ++---
 include/linux/aio.h                  |  18 ++
 include/linux/bio.h                  |   8 +
 include/linux/fs.h                   | 155 ++++++++++++--
 include/linux/nfs_fs.h               |  13 +-
 include/uapi/linux/aio_abi.h         |   2 +
 include/uapi/linux/loop.h            |   1 +
 mm/Makefile                          |   2 +-
 mm/filemap.c                         | 395 +++++++++++++++--------------------
 mm/iov-iter.c                        | 384 ++++++++++++++++++++++++++++++++++
 mm/page_io.c                         |  15 +-
 84 files changed, 1789 insertions(+), 893 deletions(-)
 create mode 100644 mm/iov-iter.c

-- 
1.8.0

