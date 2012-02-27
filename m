Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2B0VT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:19:56 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33327 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2B0VTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:19:55 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
Date: Mon, 27 Feb 2012 15:19:14 -0600
Message-Id: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F4BF37A.00B7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset was begun by Zach Brown and was originally submitted for
review in October, 2009. Feedback was positive, and I have picked up
where he left off, porting his patches to 3.3-rc4 and adding support
for ext4, btrfs, and nfs.

http://www.spinics.net/lists/linux-fsdevel/msg27514.htm

This patch series adds a kernel interface to fs/aio.c so that kernel code can
issue concurrent asynchronous IO to file systems.  It adds an aio command and
file system methods which specify io memory with pages instead of userspace
addresses.

This series was written to reduce the current overhead loop imposes by
performing synchronus buffered file system IO from a kernel thread.  These
patches turn loop into a light weight layer that translates bios into iocbs.

Thanks,
Shaggy

Dave Kleikamp (4):
  fuse: convert fuse to use iov_iter_copy_[to|from]_user
  ext4: add support for read_iter, write_iter, and direct_IO_bvec
  btrfs: add support for read_iter, write_iter, and direct_IO_bvec
  nfs: add support for read_iter, write_iter

Zach Brown (18):
  iov_iter: move into its own file
  iov_iter: add copy_to_user support
  iov_iter: hide iovec details behind ops function pointers
  iov_iter: add bvec support
  iov_iter: add a shorten call
  iov_iter: let callers extract iovecs and bio_vecs
  dio: create a dio_aligned() helper function
  dio: add dio_alloc_init() helper function
  dio: add sdio_init() helper function
  dio: add dio_lock_and_flush() helper
  dio: add dio_post_submission() helper function
  dio: add __blockdev_direct_IO_bdev()
  fs: pull iov_iter use higher up the stack
  aio: add aio_kernel_() interface
  aio: add aio support for iov_iter arguments
  bio: add bvec_length(), like iov_length()
  ext3: add support for .read_iter and .write_iter
  ocfs2: add support for read_iter, write_iter, and direct_IO_bvec

 drivers/block/loop.c    |   55 ++++-
 fs/aio.c                |  156 +++++++++++++++
 fs/btrfs/file.c         |    2 +
 fs/btrfs/inode.c        |  116 +++++++----
 fs/direct-io.c          |  435 ++++++++++++++++++++++++++--------------
 fs/ext3/file.c          |    2 +
 fs/ext3/inode.c         |  149 +++++++++-----
 fs/ext4/ext4.h          |    3 +
 fs/ext4/file.c          |    2 +
 fs/ext4/indirect.c      |  169 ++++++++++++----
 fs/ext4/inode.c         |  206 ++++++++++++-------
 fs/fuse/file.c          |   29 +--
 fs/nfs/direct.c         |  508 ++++++++++++++++++++++++++++++++++++++---------
 fs/nfs/file.c           |   80 ++++++++
 fs/ocfs2/aops.c         |   31 +++
 fs/ocfs2/file.c         |   82 +++++---
 fs/ocfs2/ocfs2_trace.h  |    6 +-
 include/linux/aio.h     |   14 ++
 include/linux/aio_abi.h |    2 +
 include/linux/bio.h     |    8 +
 include/linux/fs.h      |  139 ++++++++++++-
 include/linux/loop.h    |    1 +
 include/linux/nfs_fs.h  |    4 +
 mm/Makefile             |    2 +-
 mm/filemap.c            |  405 +++++++++++++++++--------------------
 mm/iov-iter.c           |  377 +++++++++++++++++++++++++++++++++++
 26 files changed, 2262 insertions(+), 721 deletions(-)
 create mode 100644 mm/iov-iter.c

-- 
1.7.9.2

