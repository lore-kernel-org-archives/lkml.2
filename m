Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2L0CA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:00:28 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61254 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2L0CA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:00:26 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 00/32] AIO performance improvements/cleanups, v3
Date: Wed, 26 Dec 2012 17:59:37 -0800
Message-Id: <1356573611-18590-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last posting: http://article.gmane.org/gmane.linux.kernel.aio.general/3242

As before, changes should mostly be noted in the patch descriptions. 

Some random bits:
 * flush_dcache_page() patch is new
 * Rewrote the aio_read_evt() stuff again
 * Fixed a few comments
 * Included some more patches, notably the batch completion stuff

My git repo has Jens' aio/dio patches on top of this stuff. As of the
latest version, I'm seeing a couple percent better throughput with the
ring buffer, and I think Jens was seeing a couple percent better with
his linked list approach - at this point I think the difference is
noise, we're both testing with fairly crappy drivers.

Patch series is on top of v3.7, git repo is at
http://evilpiepirate.org/git/linux-bcache.git aio-upstream


Kent Overstreet (27):
  aio: Kill return value of aio_complete()
  aio: kiocb_cancel()
  aio: Move private stuff out of aio.h
  aio: dprintk() -> pr_debug()
  aio: do fget() after aio_get_req()
  aio: Make aio_put_req() lockless
  aio: Refcounting cleanup
  wait: Add wait_event_hrtimeout()
  aio: Make aio_read_evt() more efficient, convert to hrtimers
  aio: Use flush_dcache_page()
  aio: Use cancellation list lazily
  aio: Change reqs_active to include unreaped completions
  aio: Kill batch allocation
  aio: Kill struct aio_ring_info
  aio: Give shared kioctx fields their own cachelines
  aio: reqs_active -> reqs_available
  aio: percpu reqs_available
  Generic dynamic per cpu refcounting
  aio: Percpu ioctx refcount
  aio: use xchg() instead of completion_lock
  aio: Don't include aio.h in sched.h
  aio: Kill ki_key
  aio: Kill ki_retry
  block, aio: Batch completion for bios/kiocbs
  virtio-blk: Convert to batch completion
  mtip32xx: Convert to batch completion
  aio: Smoosh struct kiocb

Zach Brown (5):
  mm: remove old aio use_mm() comment
  aio: remove dead code from aio.h
  gadget: remove only user of aio retry
  aio: remove retry-based AIO
  char: add aio_{read,write} to /dev/{null,zero}

 arch/s390/hypfs/inode.c                      |    1 +
 block/blk-core.c                             |   34 +-
 block/blk-flush.c                            |    2 +-
 block/blk.h                                  |    3 +-
 block/scsi_ioctl.c                           |    1 +
 drivers/block/mtip32xx/mtip32xx.c            |   68 +-
 drivers/block/mtip32xx/mtip32xx.h            |    8 +-
 drivers/block/swim3.c                        |    2 +-
 drivers/block/virtio_blk.c                   |   31 +-
 drivers/char/mem.c                           |   36 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     |    2 +-
 drivers/md/dm.c                              |    2 +-
 drivers/staging/android/logger.c             |    1 +
 drivers/usb/gadget/inode.c                   |   42 +-
 fs/9p/vfs_addr.c                             |    1 +
 fs/afs/write.c                               |    1 +
 fs/aio.c                                     | 1766 +++++++++++---------------
 fs/bio.c                                     |   52 +-
 fs/block_dev.c                               |    1 +
 fs/btrfs/file.c                              |    1 +
 fs/btrfs/inode.c                             |    1 +
 fs/ceph/file.c                               |    1 +
 fs/compat.c                                  |    1 +
 fs/direct-io.c                               |   21 +-
 fs/ecryptfs/file.c                           |    1 +
 fs/ext2/inode.c                              |    1 +
 fs/ext3/inode.c                              |    1 +
 fs/ext4/file.c                               |    1 +
 fs/ext4/indirect.c                           |    1 +
 fs/ext4/inode.c                              |    1 +
 fs/ext4/page-io.c                            |    1 +
 fs/fat/inode.c                               |    1 +
 fs/fuse/dev.c                                |    1 +
 fs/fuse/file.c                               |    1 +
 fs/gfs2/aops.c                               |    1 +
 fs/gfs2/file.c                               |    1 +
 fs/hfs/inode.c                               |    1 +
 fs/hfsplus/inode.c                           |    1 +
 fs/jfs/inode.c                               |    1 +
 fs/nilfs2/inode.c                            |    2 +-
 fs/ntfs/file.c                               |    1 +
 fs/ntfs/inode.c                              |    1 +
 fs/ocfs2/aops.h                              |    2 +
 fs/ocfs2/dlmglue.c                           |    2 +-
 fs/ocfs2/inode.h                             |    2 +
 fs/pipe.c                                    |    1 +
 fs/read_write.c                              |   35 +-
 fs/reiserfs/inode.c                          |    1 +
 fs/ubifs/file.c                              |    1 +
 fs/udf/inode.c                               |    1 +
 fs/xfs/xfs_aops.c                            |    1 +
 fs/xfs/xfs_file.c                            |    1 +
 include/linux/aio.h                          |  242 +---
 include/linux/bio.h                          |   36 +-
 include/linux/blk_types.h                    |   11 +-
 include/linux/blkdev.h                       |   12 +-
 include/linux/cgroup.h                       |    1 +
 include/linux/errno.h                        |    1 -
 include/linux/percpu-refcount.h              |   29 +
 include/linux/sched.h                        |    2 -
 include/linux/wait.h                         |   86 ++
 kernel/fork.c                                |    1 +
 kernel/printk.c                              |    1 +
 kernel/ptrace.c                              |    1 +
 lib/Makefile                                 |    2 +-
 lib/percpu-refcount.c                        |  164 +++
 mm/mmu_context.c                             |    3 -
 mm/page_io.c                                 |    1 +
 mm/shmem.c                                   |    1 +
 mm/swap.c                                    |    1 +
 security/keys/internal.h                     |    2 +
 security/keys/keyctl.c                       |    1 +
 sound/core/pcm_native.c                      |    2 +-
 74 files changed, 1350 insertions(+), 1396 deletions(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

-- 
1.7.12

