Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1CXNnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:43:45 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:54981 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab1CXNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:43:43 -0400
X-ASG-Debug-ID: 1300974221-01de284cf8b3810001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8B4A89.80608@fusionio.com>
Date: Thu, 24 Mar 2011 14:43:37 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Core block IO bits for 2.6.39
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Core block IO bits for 2.6.39
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300974221
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.75
X-Barracuda-Spam-Status: No, SCORE=0.75 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE_7580E
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58834
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.75 BSF_RULE_7580E         Custom Rule 7580E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the main pull request for the block IO layer and friends for
2.6.39.

There are two major things in this tree:

- The removal of the per-device plugging state for disks. On fast
  devices, it ended up hammering the queue lock quite hard. The new
  scheme puts the plugging state on the stack and allows an IO submitter
  to finish his batch of IO before pushing it to the queue. Once that
  push starts, we'll insert/merge with the existing queue.

  A pointer to this plugging context is stored in the task structure. If
  a task ends up blocking before it has submitted it's IO (usual cause
  would be memory allocation of some sort), the plugged list is
  auto-submitted before the task goes to sleep.

  While reducing the queue lock frequency, this patch also provides the
  nice benefit of getting rid of the aops->sync_page() callback. We used
  to use this for auto-unplugging the below device if we needed to wait
  on page IO. This is also the reason the diffstat looks so tasty, we
  end up removing a lot more lines of code than we add.

  Another nice benefit is that the API is now explicit. You call
  blk_start_plug() before starting an IO sequence, and blk_finish_plug()
  when that sequence is done and you want to flush it out. No more 'hey
  I'll plug behind his back, hope he remembers to unplug' games need to
  be played.

  I did not go overboard with adding plugging calls, so it may very well
  be that there are cases where we need to add this during the 2.6.39-rc
  cycle. I'd encourage everyone to test their favorite workload and keep
  an eye out for regressions.

- Final conversion of drivers to the new ->check_events() interface. So
  this work is now complete.

Other notable features/changes:

- Various fixes and improvements to the cfq-ioscheduled.

- Merging of FLUSH/FUA requests to speed up workloads that are intensive
  on durable writes.

- Updates and fixes to the block IO throttler.


Note that you'll have to do a trivial merge when pulling this in. I left
that as an exercise for you, since you've expressed interest in seeing
and doing those kinds of merges.

Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-2.6.39/core




Dan Carpenter (1):
      block: NULL dereference on error path in __blkdev_get()

Gui Jianfeng (1):
      cfq-iosched: Fix update_vdisktime logic

Jens Axboe (20):
      Merge commit 'v2.6.38-rc6' into for-2.6.39/core
      cfq-iosched: fix race in cfq_set_request()
      Merge branch 'block-for-2.6.39-core' of ssh://master.kernel.org/.../tj/misc into for-2.6.39/core
      block: add API for delaying work/request_fn a little bit
      ide-cd: convert to blk_delay_queue() for a short pause
      scsi: convert to blk_delay_queue()
      block: initial patch for on-stack per-task plugging
      block: remove per-queue plugging
      fs: make generic file read/write functions plug
      read-ahead: use plugging
      fs: make mpage read/write_pages() plug
      aio: remove request submission batching
      block: kill off REQ_UNPLUG
      Merge branch 'for-2.6.39/stack-plug' into for-2.6.39/core
      block: fixup plugging stubs for !CONFIG_BLOCK
      fs: make fsync_buffers_list() plug
      jbd: finish conversion from WRITE_SYNC_PLUG to WRITE_SYNC and explicit plugging
      jbd2: finish conversion from WRITE_SYNC_PLUG to WRITE_SYNC and explicit plugging
      fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away
      block: attempt to merge with existing requests on plug flush

Justin TerAvest (7):
      cfq-iosched: Always provide group isolation.
      blk-cgroup: Lower minimum weight from 100 to 10.
      blk-cgroup: Add unaccounted time to timeslice_used.
      cfq-iosched: Don't update group weights when on service tree
      cfq-iosched: Don't set active queue in preempt
      blk-cgroup: Only give unaccounted_time under debug
      cfq-iosched: Don't clear queue stats when preempt.

Li, Shaohua (1):
      cfq-iosched: removing unnecessary think time checking

Liu Yuan (1):
      block/genhd: Change some numerals into macros

Martin K. Petersen (2):
      block: biovec_slab vs. CONFIG_BLK_DEV_INTEGRITY
      block: Require subsystems to explicitly allocate bio_set integrity mempool

Mike Snitzer (2):
      block: skip elevator data initialization for flush requests
      block: share request flush fields with  elevator_private

Randy Dunlap (1):
      Documentation/iostats.txt: bit-size reference etc.

Shaohua Li (4):
      cfq-iosched: give busy sync queue no dispatch limit
      fs: make aio plug
      mm: make generic_writepages() use plugging
      block: fix non-atomic access to genhd inflight structures

Tao Ma (2):
      blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.
      block: remove obsolete comments for blkdev_issue_zeroout.

Tejun Heo (20):
      block: add REQ_FLUSH_SEQ
      block: improve flush bio completion
      block: reimplement FLUSH/FUA to support merge
      Merge branch 'for-linus' of ../linux-2.6-block into block-for-2.6.39/core
      block: Don't implicitly trigger event check on disk_unblock_events()
      block: Don't check events on close unless it was blocked
      block: Don't check events while open is in progress
      ide: Convert to bdops->check_events()
      floppy,{ami|ata}flop: Convert to bdops->check_events()
      gdrom,viocd: Convert to bdops->check_events()
      paride: Convert to bdops->check_events()
      dac960: Convert to bdops->check_events()
      swim[3]: Convert to bdops->check_events()
      ub: Convert to bdops->check_events()
      xsysace: Convert to bdops->check_events()
      i2o_block: Convert to bdops->check_events()
      s390/tape_block: Convert to bdops->check_events()
      umem: Drop dummy ->media_changed()
      pktcdvd: Convert to bdops->check_events()
      staging: Convert to bdops->check_events()

Vivek Goyal (7):
      block: Initialize ->queue_lock to internal lock at queue allocation time
      loop: No need to initialize ->queue_lock explicitly before calling blk_cleanup_queue()
      block: Move blk_throtl_exit() call to blk_cleanup_queue()
      blk-throttle: process limit change only through one function
      blk-throttle: Some cleanups and race fixes in limit  update code
      blk-throttle: Use blk_plug in throttle dispatch
      blk-throttle: Reset group slice when limits are changed

 Documentation/block/biodoc.txt                     |    5 -
 Documentation/cgroups/blkio-controller.txt         |   30 +-
 Documentation/iostats.txt                          |   17 +-
 block/blk-cgroup.c                                 |   16 +-
 block/blk-cgroup.h                                 |   14 +-
 block/blk-core.c                                   |  646 ++++++++++++--------
 block/blk-exec.c                                   |    4 +-
 block/blk-flush.c                                  |  439 +++++++++----
 block/blk-lib.c                                    |    2 -
 block/blk-merge.c                                  |    6 +
 block/blk-settings.c                               |   15 -
 block/blk-sysfs.c                                  |    2 -
 block/blk-throttle.c                               |  139 +++--
 block/blk.h                                        |   16 +-
 block/cfq-iosched.c                                |  163 +++---
 block/cfq.h                                        |    6 +-
 block/deadline-iosched.c                           |    9 -
 block/elevator.c                                   |  108 ++--
 block/genhd.c                                      |   18 +-
 block/noop-iosched.c                               |    8 -
 drivers/block/DAC960.c                             |    8 +-
 drivers/block/amiflop.c                            |    9 +-
 drivers/block/ataflop.c                            |   14 +-
 drivers/block/cciss.c                              |    6 -
 drivers/block/cpqarray.c                           |    3 -
 drivers/block/drbd/drbd_actlog.c                   |    4 +-
 drivers/block/drbd/drbd_bitmap.c                   |    1 -
 drivers/block/drbd/drbd_int.h                      |   16 +-
 drivers/block/drbd/drbd_main.c                     |   36 +-
 drivers/block/drbd/drbd_receiver.c                 |   29 +-
 drivers/block/drbd/drbd_req.c                      |    4 -
 drivers/block/drbd/drbd_worker.c                   |    1 -
 drivers/block/drbd/drbd_wrappers.h                 |   18 -
 drivers/block/floppy.c                             |   11 +-
 drivers/block/loop.c                               |   16 -
 drivers/block/paride/pcd.c                         |   18 +-
 drivers/block/paride/pd.c                          |    7 +-
 drivers/block/paride/pf.c                          |   10 +-
 drivers/block/pktcdvd.c                            |   15 +-
 drivers/block/swim.c                               |    8 +-
 drivers/block/swim3.c                              |   11 +-
 drivers/block/ub.c                                 |   10 +-
 drivers/block/umem.c                               |   26 +-
 drivers/block/xsysace.c                            |    9 +-
 drivers/cdrom/gdrom.c                              |   16 +-
 drivers/cdrom/viocd.c                              |   17 +-
 drivers/ide/ide-atapi.c                            |    3 +-
 drivers/ide/ide-cd.c                               |   23 +-
 drivers/ide/ide-cd.h                               |    3 +-
 drivers/ide/ide-cd_ioctl.c                         |    8 +-
 drivers/ide/ide-gd.c                               |   14 +-
 drivers/ide/ide-io.c                               |    4 -
 drivers/ide/ide-park.c                             |    2 +-
 drivers/md/bitmap.c                                |    5 +-
 drivers/md/dm-crypt.c                              |    9 +-
 drivers/md/dm-io.c                                 |    2 +-
 drivers/md/dm-kcopyd.c                             |   55 +--
 drivers/md/dm-raid.c                               |    2 +-
 drivers/md/dm-raid1.c                              |    2 -
 drivers/md/dm-table.c                              |   31 +-
 drivers/md/dm.c                                    |   52 +-
 drivers/md/dm.h                                    |    2 +-
 drivers/md/linear.c                                |   20 +-
 drivers/md/md.c                                    |   20 +-
 drivers/md/multipath.c                             |   38 +-
 drivers/md/raid0.c                                 |   19 +-
 drivers/md/raid1.c                                 |   91 +---
 drivers/md/raid10.c                                |   97 +---
 drivers/md/raid5.c                                 |   63 +--
 drivers/md/raid5.h                                 |    2 +-
 drivers/message/i2o/i2o_block.c                    |   17 +-
 drivers/mmc/card/queue.c                           |    3 +-
 drivers/s390/block/dasd.c                          |    2 +-
 drivers/s390/char/tape_block.c                     |   12 +-
 drivers/scsi/scsi_lib.c                            |   44 +-
 drivers/scsi/scsi_transport_fc.c                   |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |    6 +-
 drivers/staging/hv/blkvsc_drv.c                    |   11 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |   11 +-
 drivers/target/target_core_iblock.c                |    7 +-
 fs/adfs/inode.c                                    |    1 -
 fs/affs/file.c                                     |    2 -
 fs/aio.c                                           |   77 +---
 fs/befs/linuxvfs.c                                 |    1 -
 fs/bfs/file.c                                      |    1 -
 fs/bio-integrity.c                                 |    3 +
 fs/bio.c                                           |   10 +-
 fs/block_dev.c                                     |   27 +-
 fs/btrfs/disk-io.c                                 |   79 ---
 fs/btrfs/extent_io.c                               |    2 +-
 fs/btrfs/inode.c                                   |    1 -
 fs/btrfs/volumes.c                                 |   91 +---
 fs/buffer.c                                        |   51 +--
 fs/cifs/file.c                                     |   30 -
 fs/direct-io.c                                     |    7 +-
 fs/efs/inode.c                                     |    1 -
 fs/exofs/inode.c                                   |    1 -
 fs/ext2/inode.c                                    |    2 -
 fs/ext3/inode.c                                    |    3 -
 fs/ext4/inode.c                                    |    4 -
 fs/ext4/page-io.c                                  |    3 +-
 fs/fat/inode.c                                     |    1 -
 fs/freevxfs/vxfs_subr.c                            |    1 -
 fs/fuse/inode.c                                    |    1 -
 fs/gfs2/aops.c                                     |    3 -
 fs/gfs2/log.c                                      |    4 +-
 fs/gfs2/lops.c                                     |   12 +-
 fs/gfs2/meta_io.c                                  |    3 +-
 fs/hfs/inode.c                                     |    2 -
 fs/hfsplus/inode.c                                 |    2 -
 fs/hpfs/file.c                                     |    1 -
 fs/isofs/inode.c                                   |    1 -
 fs/jbd/commit.c                                    |   22 +-
 fs/jbd2/commit.c                                   |   22 +-
 fs/jfs/inode.c                                     |    1 -
 fs/jfs/jfs_metapage.c                              |    1 -
 fs/logfs/dev_bdev.c                                |    2 -
 fs/minix/inode.c                                   |    1 -
 fs/mpage.c                                         |    8 +
 fs/nilfs2/btnode.c                                 |    7 +-
 fs/nilfs2/gcinode.c                                |    1 -
 fs/nilfs2/inode.c                                  |    1 -
 fs/nilfs2/mdt.c                                    |    9 +-
 fs/nilfs2/page.c                                   |    5 +-
 fs/nilfs2/page.h                                   |    3 +-
 fs/nilfs2/segbuf.c                                 |    2 +-
 fs/ntfs/aops.c                                     |    4 -
 fs/ntfs/compress.c                                 |    3 +-
 fs/ocfs2/aops.c                                    |    1 -
 fs/ocfs2/cluster/heartbeat.c                       |    4 -
 fs/omfs/file.c                                     |    1 -
 fs/partitions/check.c                              |    3 +-
 fs/qnx4/inode.c                                    |    1 -
 fs/reiserfs/inode.c                                |    1 -
 fs/super.c                                         |    2 +
 fs/sync.c                                          |    4 +-
 fs/sysv/itree.c                                    |    1 -
 fs/ubifs/super.c                                   |    1 -
 fs/udf/file.c                                      |    1 -
 fs/udf/inode.c                                     |    1 -
 fs/ufs/inode.c                                     |    1 -
 fs/ufs/truncate.c                                  |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c                        |    4 +-
 fs/xfs/linux-2.6/xfs_buf.c                         |   13 +-
 include/linux/backing-dev.h                        |   16 -
 include/linux/bio.h                                |    1 -
 include/linux/blk_types.h                          |    6 +-
 include/linux/blkdev.h                             |  101 +++-
 include/linux/buffer_head.h                        |    1 -
 include/linux/device-mapper.h                      |    5 -
 include/linux/elevator.h                           |   10 +-
 include/linux/fs.h                                 |   29 +-
 include/linux/genhd.h                              |   12 +-
 include/linux/pagemap.h                            |   12 -
 include/linux/sched.h                              |    6 +
 include/linux/swap.h                               |    2 -
 kernel/exit.c                                      |    1 +
 kernel/fork.c                                      |    3 +
 kernel/power/block_io.c                            |    2 +-
 kernel/sched.c                                     |   12 +
 kernel/trace/blktrace.c                            |   15 +-
 mm/backing-dev.c                                   |    8 +-
 mm/filemap.c                                       |   74 +--
 mm/memory-failure.c                                |    8 +-
 mm/nommu.c                                         |    4 -
 mm/page-writeback.c                                |   10 +-
 mm/page_io.c                                       |    2 +-
 mm/readahead.c                                     |   18 +-
 mm/shmem.c                                         |    1 -
 mm/swap_state.c                                    |    5 +-
 mm/swapfile.c                                      |   37 --
 mm/vmscan.c                                        |    2 +-
 172 files changed, 1520 insertions(+), 2112 deletions(-)

-- 
Jens Axboe

