Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab1EYNDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:03:36 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:34746 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab1EYNDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:03:35 -0400
X-ASG-Debug-ID: 1306328612-01de28096b664e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCFE21.80003@fusionio.com>
Date: Wed, 25 May 2011 15:03:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Core block bits for 2.6.40
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Core block bits for 2.6.40
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306328612
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A real pull request this time. These are the core bits for the next
kernel. Nothing exciting in here in this round, with the churn in
the last release, this release will be mellow.

- Optimizations for queue flushing on SATA devices, where we
  can't queue a FLUSH command. This fixes up a performance regression
  caused by a bug fix to prevent potential live lock on adding
  FLUSH commands at the head of the queue.

- Make stats lockless for blk-cgroup.

- Various bug fixes for blk-cgroup.

- Various little fixes and improvements to CFQ.

- Last round of media event changes.

- Fixes for discard topology reporting and sysfs documentation update
  for the same.

- Add support for batched discards. This greatly speeds up discarding
  an entire device.

- Fix for bad return value in the discard ioctl.

- Remove request plug state debug checks. Haven't triggered even during
  the 2.6.39-rc devel cycle, so get rid of them.


Please pull!


  git://git.kernel.dk/linux-2.6-block.git for-2.6.40/core

Gustavo F. Padovan (1):
      backing-dev: Kill set but not used var in  bdi_debug_stats_show()

James Bottomley (1):
      block: add proper state guards to __elv_next_request

Jens Axboe (4):
      fs: fixup warning part_discard_alignment_show()
      Merge commit 'v2.6.39' into for-2.6.40/core
      Merge branch 'for-linus' into for-2.6.40/core
      block: get rid of on-stack plugging debug checks

Kees Cook (1):
      iosched: remove redundant sprintf

Lukas Czerner (3):
      blkdev: Submit discard bio in batches in blkdev_issue_discard()
      blkdev: Simple cleanup in blkdev_issue_zeroout()
      blkdev: Do not return -EOPNOTSUPP if discard is supported

Martin K. Petersen (2):
      block: Fix discard topology stacking and reporting
      block: Add sysfs documentation for the discard topology parameters

Namhyung Kim (4):
      cfq-iosched: algebraic simplification in cfq_prio_to_maxrq()
      cfq-iosched: reduce bit operations in cfq_choose_req()
      cfq-iosched: remove unused 'group_changed' in cfq_service_tree_add()
      cfq-iosched: free cic_index if cfqd allocation fails

Tao Ma (2):
      block: Remove 'plug/unplug' comment in blk_execute_rq_nowait
      block: Remove extra discard_alignment from hd_struct.

Tejun Heo (4):
      cdrom: always check_disk_change() on open
      block: rescan partitions on invalidated devices on -ENOMEDIA too
      block: don't block events on excl write for non-optical devices
      block: move bd_set_size() above rescan_partitions() in __blkdev_get()

Vivek Goyal (17):
      blk-throttle: Do the new group initialization with the help of a function
      blk-cgroup: move some fields of unaccounted_time file under right config option
      cfq-iosched: Get rid of redundant function parameter "create"
      cfq-iosched: Fix a possible race with cfq cgroup removal code
      blk-cgroup: Allow sleeping while dynamically allocating a group
      blk-throttle: Dynamically allocate root group
      blk-throttle: Introduce a helper function to fill in device details
      blk-throttle: Use helper function to add root throtl group to lists
      blk-throttle: Free up a group only after one rcu grace period
      blk-throttle: Make dispatch stats per cpu
      blk-cgroup: Make 64bit per cpu stats safe on 32bit arch
      blk-cgroup: Make cgroup stat reset path blkg->lock free for dispatch stats
      blk-throttle: Make no throttling rule group processing lockless
      cfq-iosched: Fix a memory leak of per cpu stats for root group
      cfq-iosched: Make IO merge related stats per cpu
      block: call elv_bio_merged() when merged
      blk-cgroup: Initialize ioc->cgroup_changed at ioc creation time

shaohua.li@intel.com (3):
      block: add a non-queueable flush flag
      block: hold queue if flush is running for non-queueable flush drive
      SATA: enable non-queueable flush flag

 Documentation/ABI/testing/sysfs-block |   64 +++++++
 block/blk-cgroup.c                    |  200 +++++++++++++++++----
 block/blk-cgroup.h                    |   40 +++--
 block/blk-core.c                      |   32 +---
 block/blk-exec.c                      |    2 +-
 block/blk-flush.c                     |   16 ++-
 block/blk-ioc.c                       |    3 +
 block/blk-lib.c                       |   82 +++------
 block/blk-settings.c                  |    9 +-
 block/blk-sysfs.c                     |    3 +-
 block/blk-throttle.c                  |  313 +++++++++++++++++++++++++--------
 block/blk.h                           |   23 +++-
 block/cfq-iosched.c                   |  232 ++++++++++++++++++-------
 block/elevator.c                      |   11 +-
 drivers/ata/libata-scsi.c             |   13 +-
 drivers/block/paride/pcd.c            |    2 +
 drivers/cdrom/viocd.c                 |    4 +-
 drivers/ide/ide-cd.c                  |    3 +-
 drivers/scsi/sr.c                     |    2 +-
 fs/block_dev.c                        |   34 ++--
 fs/partitions/check.c                 |    8 +-
 include/linux/blk_types.h             |    2 -
 include/linux/blkdev.h                |   15 ++-
 include/linux/genhd.h                 |    2 +-
 mm/backing-dev.c                      |    4 +-
 25 files changed, 794 insertions(+), 325 deletions(-)

-- 
Jens Axboe

