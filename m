Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987Ab2C3PoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:44:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43689 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2C3PoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:44:17 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 00/21] loop: Issue O_DIRECT aio using bio_vec
Date: Fri, 30 Mar 2012 10:43:27 -0500
Message-Id: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F75D4D0.00C8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize for sending this out so close to the start of the LSF-MM
Summit. I've been trying to get some performance numbers worthy of
sharing, but other work has been getting in the way. Those will follow,
but I wanted everyone to get a chance to see the current state of the
patchset.

This patchset was begun by Zach Brown and was originally submitted for
review in October, 2009. Feedback was positive, and I have picked up
where he left off, porting his patches to 3.3 and adding support more
file systems.

http://www.spinics.net/lists/linux-fsdevel/msg27514.html

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

Changes since version 1:

The biggest change since my first posting is that I took Christoph Hellwig's
advice and changed the direct_IO interface to use struct iov_iter, instead
of duplicating code to handle both struct iovec and struct biovec separately.
This really simplified the patchset, and made support for more filesystems
trivial.

I also reworked the nfs patch to coalesce the bvec pages into larger I/Os,
and fixed a major oversight in btrfs.


Dave Kleikamp (7):
  fuse: convert fuse to use iov_iter_copy_[to|from]_user
  dio: Convert direct_IO to use iov_iter
  dio: add bio_vec support to __blockdev_direct_IO()
  ext4: add support for read_iter and write_iter
  nfs: add support for read_iter, write_iter
  btrfs: add support for read_iter and write_iter
  fs: add read_iter and write_iter to more file systems

Zach Brown (14):
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
  ext3: add support for .read_iter and .write_iter
  ocfs2: add support for read_iter, write_iter, and direct_IO_bvec

 Documentation/filesystems/Locking |    4 +-
 Documentation/filesystems/vfs.txt |    4 +-
 drivers/block/loop.c              |   55 ++++-
 fs/9p/vfs_addr.c                  |    8 +-
 fs/9p/vfs_file.c                  |    4 +
 fs/aio.c                          |  156 +++++++++++++
 fs/block_dev.c                    |    8 +-
 fs/btrfs/file.c                   |   55 +++--
 fs/btrfs/inode.c                  |   70 +++---
 fs/ceph/addr.c                    |    3 +-
 fs/direct-io.c                    |  253 ++++++++++++++-------
 fs/ext2/file.c                    |    2 +
 fs/ext2/inode.c                   |    8 +-
 fs/ext3/file.c                    |    2 +
 fs/ext3/inode.c                   |   15 +-
 fs/ext4/ext4.h                    |    3 +-
 fs/ext4/file.c                    |    2 +
 fs/ext4/indirect.c                |   16 +-
 fs/ext4/inode.c                   |   23 +-
 fs/fat/file.c                     |    2 +
 fs/fat/inode.c                    |   10 +-
 fs/fuse/file.c                    |   29 +--
 fs/gfs2/aops.c                    |    7 +-
 fs/hfs/inode.c                    |    9 +-
 fs/hfsplus/inode.c                |    8 +-
 fs/jfs/file.c                     |    2 +
 fs/jfs/inode.c                    |    7 +-
 fs/nfs/direct.c                   |  454 +++++++++++++++++++++++++++----------
 fs/nfs/file.c                     |   51 +++--
 fs/nilfs2/file.c                  |    2 +
 fs/nilfs2/inode.c                 |    8 +-
 fs/ocfs2/aops.c                   |    8 +-
 fs/ocfs2/file.c                   |   82 +++++--
 fs/ocfs2/ocfs2_trace.h            |    6 +-
 fs/reiserfs/file.c                |    2 +
 fs/reiserfs/inode.c               |    7 +-
 fs/xfs/xfs_aops.c                 |   11 +-
 include/linux/aio.h               |   14 ++
 include/linux/aio_abi.h           |    2 +
 include/linux/bio.h               |    8 +
 include/linux/fs.h                |  131 +++++++++--
 include/linux/loop.h              |    1 +
 include/linux/nfs_fs.h            |    9 +-
 mm/Makefile                       |    2 +-
 mm/filemap.c                      |  388 +++++++++++++------------------
 mm/iov-iter.c                     |  377 ++++++++++++++++++++++++++++++
 46 files changed, 1677 insertions(+), 651 deletions(-)
 create mode 100644 mm/iov-iter.c

-- 
1.7.9.5

