Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0JVKiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:38:50 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40672 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab0JVKit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:38:49 -0400
Message-ID: <4CC169C6.6030104@fusionio.com>
Date: Fri, 22 Oct 2010 12:39:02 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] barrier/flush write revamp for 2.6.37-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another topic branch, this one has the barrier rewrite for 2.6.37-rc1.
It's been in for-next for a long time, no surprises seen yet (except for
the xen-blkfront, but that was broken before as well).

This greatly simplifies the barrier support and semantics, as the
diffstat confirms.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-2.6.37/barrier

Christoph Hellwig (17):
      block: simplify queue_next_fseq
      block: update documentation for REQ_FLUSH / REQ_FUA
      block: pass gfp_mask and flags to sb_issue_discard
      xfs: replace barriers with explicit flush / FUA usage
      btrfs: replace barriers with explicit flush / FUA usage
      gfs2: replace barriers with explicit flush / FUA usage
      reiserfs: replace barriers with explicit flush / FUA usage
      nilfs2: replace barriers with explicit flush / FUA usage
      jbd: replace barriers with explicit flush / FUA usage
      jbd2: replace barriers with explicit flush / FUA usage
      ext4: do not send discards as barriers
      fat: do not send discards as barriers
      swap: do not send discards as barriers
      block: remove the WRITE_BARRIER flag
      block: remove the BLKDEV_IFL_BARRIER flag
      block: remove the BH_Eopnotsupp flag
      block: remove BLKDEV_IFL_WAIT

Jan Kara (1):
      jbd2: Modify ASYNC_COMMIT code to not rely on queue draining on barrier

Jens Axboe (3):
      aic7xxx_old: removed unused 'req' variable
      Merge branch 'v2.6.36-rc8' into for-2.6.37/barrier
      xen-blkfront: disable barrier/flush write support

Kiyoshi Ueda (1):
      dm: fix locking context in queue_io()

Mike Snitzer (2):
      dm: convey that all flushes are processed as empty
      Added blk-lib.c and blk-barrier.c was renamed to blk-flush.c

Tejun Heo (23):
      ide: remove unnecessary blk_queue_flushing() test in do_ide_request()
      block/loop: queue ordered mode should be DRAIN_FLUSH
      block: kill QUEUE_ORDERED_BY_TAG
      block: deprecate barrier and replace blk_queue_ordered() with blk_queue_flush()
      block: remove spurious uses of REQ_HARDBARRIER
      block: misc cleanups in barrier code
      block: drop barrier ordering by queue draining
      block: rename blk-barrier.c to blk-flush.c
      block: rename barrier/ordered to flush
      block: implement REQ_FLUSH/FUA based interface for FLUSH/FUA requests
      block: filter flush bio's in __generic_make_request()
      block: initialize flush request with WRITE_FLUSH instead of REQ_FLUSH
      block: kick queue after sequencing REQ_FLUSH/FUA
      block: make sure FSEQ_DATA request has the same rq_disk as the original
      block: use REQ_FLUSH in blkdev_issue_flush()
      block/loop: implement REQ_FLUSH/FUA support
      virtio_blk: drop REQ_HARDBARRIER support
      lguest: replace VIRTIO_F_BARRIER support with VIRTIO_F_FLUSH support
      md: implment REQ_FLUSH/FUA support
      block: make __blk_rq_prep_clone() copy most command flags
      dm: implement REQ_FLUSH/FUA support for bio-based dm
      dm: implement REQ_FLUSH/FUA support for request-based dm
      dm: relax ordering of bio-based flush implementation

 Documentation/DocBook/kernel-api.tmpl           |    3 +-
 Documentation/block/00-INDEX                    |    4 +-
 Documentation/block/barrier.txt                 |  261 ---------------
 Documentation/block/writeback_cache_control.txt |   86 +++++
 Documentation/lguest/lguest.c                   |   29 +--
 block/Makefile                                  |    2 +-
 block/blk-barrier.c                             |  350 --------------------
 block/blk-core.c                                |   72 +++--
 block/blk-flush.c                               |  262 +++++++++++++++
 block/blk-lib.c                                 |   39 +--
 block/blk-settings.c                            |   20 ++
 block/blk.h                                     |    8 +-
 block/elevator.c                                |   79 +----
 block/ioctl.c                                   |    4 +-
 drivers/block/brd.c                             |    1 -
 drivers/block/drbd/drbd_int.h                   |    3 +-
 drivers/block/drbd/drbd_receiver.c              |    2 +-
 drivers/block/loop.c                            |   20 +-
 drivers/block/osdblk.c                          |    5 +-
 drivers/block/pktcdvd.c                         |    1 -
 drivers/block/ps3disk.c                         |    2 +-
 drivers/block/virtio_blk.c                      |   37 +--
 drivers/block/xen-blkfront.c                    |   54 ++--
 drivers/ide/ide-disk.c                          |   13 +-
 drivers/ide/ide-io.c                            |   13 -
 drivers/md/dm-crypt.c                           |    2 +-
 drivers/md/dm-io.c                              |   20 +-
 drivers/md/dm-log.c                             |    2 +-
 drivers/md/dm-raid1.c                           |    8 +-
 drivers/md/dm-region-hash.c                     |   16 +-
 drivers/md/dm-snap-persistent.c                 |    2 +-
 drivers/md/dm-snap.c                            |    6 +-
 drivers/md/dm-stripe.c                          |    2 +-
 drivers/md/dm.c                                 |  398 +++++------------------
 drivers/md/linear.c                             |    4 +-
 drivers/md/md.c                                 |  117 ++------
 drivers/md/md.h                                 |   23 +-
 drivers/md/multipath.c                          |    4 +-
 drivers/md/raid0.c                              |    4 +-
 drivers/md/raid1.c                              |  176 ++++-------
 drivers/md/raid1.h                              |    2 -
 drivers/md/raid10.c                             |    7 +-
 drivers/md/raid5.c                              |   43 ++--
 drivers/md/raid5.h                              |    1 +
 drivers/mmc/card/queue.c                        |    1 -
 drivers/s390/block/dasd.c                       |    1 -
 drivers/scsi/aic7xxx_old.c                      |   22 +--
 drivers/scsi/libsas/sas_scsi_host.c             |   13 +-
 drivers/scsi/sd.c                               |   18 +-
 fs/block_dev.c                                  |    2 +-
 fs/btrfs/disk-io.c                              |   19 +-
 fs/btrfs/extent-tree.c                          |    3 +-
 fs/btrfs/volumes.c                              |    4 -
 fs/btrfs/volumes.h                              |    1 -
 fs/buffer.c                                     |    7 +-
 fs/ext3/fsync.c                                 |    3 +-
 fs/ext4/fsync.c                                 |    5 +-
 fs/ext4/mballoc.c                               |    2 +-
 fs/fat/fatent.c                                 |    3 +-
 fs/fat/misc.c                                   |    5 +-
 fs/gfs2/log.c                                   |   19 +-
 fs/gfs2/rgrp.c                                  |    6 +-
 fs/jbd/commit.c                                 |   30 +--
 fs/jbd2/checkpoint.c                            |    3 +-
 fs/jbd2/commit.c                                |   74 ++---
 fs/nilfs2/super.c                               |   10 +-
 fs/nilfs2/the_nilfs.c                           |    7 +-
 fs/reiserfs/file.c                              |    3 +-
 fs/reiserfs/journal.c                           |  106 ++-----
 fs/xfs/linux-2.6/xfs_buf.c                      |   16 +-
 fs/xfs/linux-2.6/xfs_buf.h                      |   11 +-
 fs/xfs/linux-2.6/xfs_super.c                    |    3 +-
 fs/xfs/linux-2.6/xfs_trace.h                    |    1 -
 fs/xfs/xfs_log.c                                |   13 -
 include/linux/blk_types.h                       |    5 +-
 include/linux/blkdev.h                          |   99 ++-----
 include/linux/buffer_head.h                     |    2 -
 include/linux/fs.h                              |   28 +-
 include/scsi/scsi_tcq.h                         |    6 +-
 mm/swapfile.c                                   |    6 +-
 80 files changed, 844 insertions(+), 1920 deletions(-)
 delete mode 100644 Documentation/block/barrier.txt
 create mode 100644 Documentation/block/writeback_cache_control.txt
 delete mode 100644 block/blk-barrier.c
 create mode 100644 block/blk-flush.c

-- 
Jens Axboe

