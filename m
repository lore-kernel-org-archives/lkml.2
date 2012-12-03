Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2LCU7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:59:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49143 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2LCU7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:15 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 00/26] AIO performance improvements/cleanups, v2
Date: Mon,  3 Dec 2012 12:58:16 -0800
Message-Id: <1354568322-29029-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last posting: http://thread.gmane.org/gmane.linux.kernel.aio.general/3169

Changes since the last posting should all be noted in the individual
patch descriptions.

 * Zach pointed out the aio_read_evt() patch was calling functions that
   could sleep in TASK_INTERRUPTIBLE state, that patch is rewritten.
 * Ben pointed out some synchronize_rcu() usage was problematic,
   converted it to call_rcu()
 * The flush_dcache_page() patch is new
 * Changed the "use cancellation list lazily" patch so as to remove
   ki_flags from struct kiocb.

Kent Overstreet (21):
  aio: Kill return value of aio_complete()
  aio: kiocb_cancel()
  aio: Move private stuff out of aio.h
  aio: dprintk() -> pr_debug()
  aio: do fget() after aio_get_req()
  aio: Make aio_put_req() lockless
  aio: Refcounting cleanup
  aio: Convert read_events() to hrtimers
  aio: Make aio_read_evt() more efficient
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

Zach Brown (5):
  mm: remove old aio use_mm() comment
  aio: remove dead code from aio.h
  gadget: remove only user of aio retry
  aio: remove retry-based AIO
  char: add aio_{read,write} to /dev/{null,zero}

 arch/s390/hypfs/inode.c                      |    1 +
 block/scsi_ioctl.c                           |    1 +
 drivers/char/mem.c                           |   36 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     |    2 +-
 drivers/staging/android/logger.c             |    1 +
 drivers/usb/gadget/inode.c                   |   42 +-
 fs/9p/vfs_addr.c                             |    1 +
 fs/afs/write.c                               |    1 +
 fs/aio.c                                     | 1432 ++++++++++----------------
 fs/block_dev.c                               |    1 +
 fs/btrfs/file.c                              |    1 +
 fs/btrfs/inode.c                             |    1 +
 fs/ceph/file.c                               |    1 +
 fs/compat.c                                  |    1 +
 fs/direct-io.c                               |    1 +
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
 include/linux/aio.h                          |  135 +--
 include/linux/cgroup.h                       |    1 +
 include/linux/errno.h                        |    1 -
 include/linux/percpu-refcount.h              |   29 +
 include/linux/sched.h                        |    2 -
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
 61 files changed, 868 insertions(+), 1070 deletions(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

-- 
1.7.12

