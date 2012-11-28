Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2K1QoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:01 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34402 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2K1Qn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:43:57 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 00/25] AIO performance improvements/cleanups
Date: Wed, 28 Nov 2012 08:43:24 -0800
Message-Id: <1354121029-1376-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bunch of performance improvements and cleanups Zach Brown and I have
been working on. The code should be pretty solid at this point, though
it could of course use more review and testing.

The results in my testing are pretty impressive, particularly when an
ioctx is being shared between multiple threads. In my crappy synthetic
benchmark, with 4 threads submitting and one thread reaping completions,
I saw overhead in the aio code go from ~50% (mostly ioctx lock
contention) to low single digits. Performance with ioctx per thread
improved too, but I'd have to rerun those benchmarks.

The reason I've been focused on performance when the ioctx is shared is
that for a fair number of real world completions, userspace needs the
completions aggregated somehow - in practice people just end up
implementing this aggregation in userspace today, but if it's done right
we can do it much more efficiently in the kernel.

Performance wise, the end result of this patch series is that submitting
a kiocb writes to _no_ shared cachelines - the penalty for sharing an
ioctx is gone there. There's still going to be some cacheline contention
when we deliver the completions to the aio ringbuffer (at least if you
have interrupts being delivered on multiple cores, which for high end
stuff you do) but I have a couple more patches not in this series that
implement coalescing for that (by taking advantage of interrupt
coalescing). With that, there's basically no bottlenecks or performance
issues to speak of in the aio code.

Real world benchmarks are still lacking, I've just been focused on
profiles. I'll try and post some actual benchmarks/profiles later.

The patch series is on top of v3.7-rc7, git repo is at
http://evilpiepirate.org/git/linux-bcache.git aio-upstream

Kent Overstreet (20):
  aio: Kill return value of aio_complete()
  aio: kiocb_cancel()
  aio: Move private stuff out of aio.h
  aio: dprintk() -> pr_debug()
  aio: do fget() after aio_get_req()
  aio: Make aio_put_req() lockless
  aio: Refcounting cleanup
  aio: Convert read_events() to hrtimers
  aio: Make aio_read_evt() more efficient
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
 fs/aio.c                                     | 1362 +++++++++-----------------
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
 include/linux/aio.h                          |  129 +--
 include/linux/cgroup.h                       |    1 +
 include/linux/errno.h                        |    1 -
 include/linux/percpu-refcount.h              |   29 +
 include/linux/sched.h                        |    2 -
 kernel/fork.c                                |    1 +
 kernel/printk.c                              |    1 +
 kernel/ptrace.c                              |    1 +
 lib/Makefile                                 |    2 +-
 lib/percpu-refcount.c                        |  164 ++++
 mm/mmu_context.c                             |    3 -
 mm/page_io.c                                 |    1 +
 mm/shmem.c                                   |    1 +
 mm/swap.c                                    |    1 +
 security/keys/internal.h                     |    2 +
 security/keys/keyctl.c                       |    1 +
 sound/core/pcm_native.c                      |    2 +-
 61 files changed, 820 insertions(+), 1042 deletions(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

-- 
1.7.12

