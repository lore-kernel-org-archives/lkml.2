Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2JVPPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:15:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33878 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2JVPPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:15:41 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v3 00/22] loop: Issue O_DIRECT aio using bio_vec
Date: Mon, 22 Oct 2012 10:15:00 -0500
Message-Id: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the current version of the patchset I presented at the LSF-MM
Summit in San Francisco in April. I apologize for letting it go so
long before re-submitting.

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

The downside of this is that in its current implementation, performance takes
a big hit for non-synchonous I/O, since the underlying page cache is bypassed.
The tradeoff is that all writes to the loop device make it to the underlying
media, making loop-mounted file systems recoverable.

These patches apply to 3.7-rc1 and are also available at:
git://github.com/kleikamp/linux-shaggy.git loop_2012_10_18

Asias He (1):
  block_dev: add support for read_iter, write_iter

Dave Kleikamp (8):
  iov_iter: iov_iter_copy_from_user() should use non-atomic copy
  fuse: convert fuse to use iov_iter_copy_[to|from]_user
  dio: Convert direct_IO to use iov_iter
  dio: add bio_vec support to __blockdev_direct_IO()
  fs: add read_iter and write_iter to several file systems
  ext4: add support for read_iter and write_iter
  nfs: add support for read_iter, write_iter
  btrfs: add support for read_iter and write_iter

From: Zach Brown (2):
  aio: add aio support for iov_iter arguments
  loop: use aio to perform io on the underlying file

Zach Brown (11):
  iov_iter: move into its own file
  iov_iter: add copy_to_user support
  iov_iter: hide iovec details behind ops function pointers
  iov_iter: add bvec support
  iov_iter: add a shorten call
  iov_iter: let callers extract iovecs and bio_vecs
  dio: create a dio_aligned() helper function
  fs: pull iov_iter use higher up the stack
  aio: add aio_kernel_() interface
  bio: add bvec_length(), like iov_length()
  ocfs2: add support for read_iter, write_iter, and direct_IO_bvec

 Documentation/filesystems/Locking |   4 +-
 Documentation/filesystems/vfs.txt |   4 +-
 drivers/block/loop.c              | 129 +++++++++----
 fs/9p/vfs_addr.c                  |   8 +-
 fs/9p/vfs_file.c                  |   4 +
 fs/aio.c                          | 156 +++++++++++++++
 fs/block_dev.c                    |  44 ++++-
 fs/btrfs/file.c                   |  55 +++---
 fs/btrfs/inode.c                  |  61 +++---
 fs/ceph/addr.c                    |   3 +-
 fs/cifs/file.c                    |   4 +-
 fs/direct-io.c                    | 253 ++++++++++++++++--------
 fs/ext2/file.c                    |   2 +
 fs/ext2/inode.c                   |   8 +-
 fs/ext3/file.c                    |   2 +
 fs/ext3/inode.c                   |  15 +-
 fs/ext4/ext4.h                    |   3 +-
 fs/ext4/file.c                    |  49 +++--
 fs/ext4/indirect.c                |  16 +-
 fs/ext4/inode.c                   |  27 ++-
 fs/fat/file.c                     |   2 +
 fs/fat/inode.c                    |  10 +-
 fs/fuse/file.c                    |  40 ++--
 fs/gfs2/aops.c                    |   7 +-
 fs/hfs/inode.c                    |   9 +-
 fs/hfsplus/inode.c                |   8 +-
 fs/jfs/file.c                     |   2 +
 fs/jfs/inode.c                    |   7 +-
 fs/nfs/direct.c                   | 176 +++++++++++------
 fs/nfs/file.c                     |  48 +++--
 fs/nfs/internal.h                 |   2 +
 fs/nfs/nfs4file.c                 |   4 +
 fs/nilfs2/file.c                  |   2 +
 fs/nilfs2/inode.c                 |   8 +-
 fs/ocfs2/aops.c                   |   8 +-
 fs/ocfs2/file.c                   |  82 +++++---
 fs/ocfs2/ocfs2_trace.h            |   6 +-
 fs/reiserfs/file.c                |   2 +
 fs/reiserfs/inode.c               |   7 +-
 fs/udf/file.c                     |   3 +-
 fs/udf/inode.c                    |  10 +-
 fs/xfs/xfs_aops.c                 |  13 +-
 include/linux/aio.h               |  18 ++
 include/linux/bio.h               |   8 +
 include/linux/fs.h                | 135 +++++++++++--
 include/linux/nfs_fs.h            |   9 +-
 include/uapi/linux/aio_abi.h      |   2 +
 include/uapi/linux/loop.h         |   1 +
 mm/Makefile                       |   2 +-
 mm/filemap.c                      | 395 ++++++++++++++++----------------------
 mm/iov-iter.c                     | 383 ++++++++++++++++++++++++++++++++++++
 mm/page_io.c                      |   8 +-
 52 files changed, 1609 insertions(+), 655 deletions(-)
 create mode 100644 mm/iov-iter.c

-- 
1.7.12.3

