Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab1KDUBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:01:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43046 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KDUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:01:16 -0400
Message-ID: <4EB44488.4040300@kernel.dk>
Date: Fri, 04 Nov 2011 21:01:12 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO core bit for 3.2
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the core bits pull request for 3.2. Executive summary:

- Some cleanups and refactoring of the __make_request() interface from
  Christoph. We used to return 0/1 to control remap or queue behaviour,
  but drivers often got that API wrong and used it for 0/-Exxx instead.

- Fix a bug in loop aops write handling.

- Two stable bug fixes for the block flush logic.

- A cleanup and fixup patchset from Tejun, attempting to really fix our
  reference counting problems.

- Various little bug fixes, comments, cleansup.

Please pull!


  git://git.kernel.dk/linux-block.git for-3.2/core

Andrew Morton (1):
      block/blk-sysfs.c: fix kerneldoc references

Christoph Hellwig (4):
      block: export __make_request
      block: remove support for bio remapping from ->make_request
      block: refactor generic_make_request
      loop: remove the incorrect write_begin/write_end shortcut

David Vrabel (1):
      block: initialize the bounce pool if high memory may be added later

Jeff Moyer (2):
      blk-flush: fix invalid BUG_ON in blk_insert_flush
      blk-flush: move the queue kick into

Jens Axboe (4):
      block: rename __make_request() to blk_queue_bio()
      Merge branch 'v3.1-rc10' into for-3.2/core
      Merge branch 'for-linus' into for-3.2/core
      blk-throttle: use queue_is_locked() instead of lockdep_is_held()

Jie Liu (1):
      block: fix a typo in the blk-cgroup.h file

Suresh Jayaraman (1):
      block: document blk-plug

Tao Ma (2):
      block: Remove the control of complete cpu from bio.
      block: warn if tag is greater than real_max_depth.

Tejun Heo (12):
      block: make gendisk hold a reference to its queue
      block: fix genhd refcounting in blkio_policy_parse_and_set()
      block: move blk_throtl prototypes to block/blk.h
      block: pass around REQ_* flags instead of broken down booleans during request alloc/free
      block: drop unnecessary blk_get/put_queue() in scsi_cmd_ioctl() and blk_get_tg()
      block: reorganize queue draining
      block: reorganize throtl_get_tg() and blk_throtl_bio()
      block: make get_request[_wait]() fail if queue is dead
      block: drop @tsk from attempt_plug_merge() and explain sync rules
      block: fix request_queue lifetime handling by making blk_queue_cleanup() properly shutdown
      block: make gendisk hold a reference to its queue
      block: don't call blk_drain_queue() if elevator is not up

Vivek Goyal (2):
      blk-throttle: Free up policy node associated with deleted rule
      blk-throttle: Take blkcg->lock while traversing blkcg->policy_list

Wang Sheng-Hui (1):
      elevator: use ELV_NAME_MAX instead of magic number 16 for chosen_elevator

 arch/m68k/emu/nfblock.c         |    3 +-
 arch/powerpc/sysdev/axonram.c   |    8 +-
 block/blk-cgroup.c              |  111 ++++++----
 block/blk-cgroup.h              |    2 +-
 block/blk-core.c                |  461 ++++++++++++++++++++++-----------------
 block/blk-flush.c               |    3 +-
 block/blk-sysfs.c               |    7 +-
 block/blk-tag.c                 |    6 +-
 block/blk-throttle.c            |  106 ++++++----
 block/blk.h                     |   20 ++-
 block/elevator.c                |   39 +---
 block/genhd.c                   |    8 +
 block/scsi_ioctl.c              |    3 +-
 drivers/block/aoe/aoeblk.c      |   14 +-
 drivers/block/brd.c             |    4 +-
 drivers/block/drbd/drbd_int.h   |    2 +-
 drivers/block/drbd/drbd_req.c   |    8 +-
 drivers/block/loop.c            |  140 ++----------
 drivers/block/pktcdvd.c         |   11 +-
 drivers/block/ps3vram.c         |    6 +-
 drivers/block/umem.c            |    4 +-
 drivers/md/dm.c                 |   25 +--
 drivers/md/faulty.c             |   14 +-
 drivers/md/linear.c             |   17 +-
 drivers/md/md.c                 |   12 +-
 drivers/md/md.h                 |    2 +-
 drivers/md/multipath.c          |    8 +-
 drivers/md/raid0.c              |   22 +-
 drivers/md/raid1.c              |    9 +-
 drivers/md/raid10.c             |   19 +-
 drivers/md/raid5.c              |    8 +-
 drivers/s390/block/dcssblk.c    |    7 +-
 drivers/s390/block/xpram.c      |    5 +-
 drivers/staging/zram/zram_drv.c |    8 +-
 fs/bio.c                        |    1 -
 fs/block_dev.c                  |   13 +-
 include/linux/bio.h             |    8 -
 include/linux/blk_types.h       |   11 +-
 include/linux/blkdev.h          |   40 ++--
 include/linux/elevator.h        |    6 +
 include/linux/loop.h            |    1 -
 mm/bounce.c                     |    9 +-
 42 files changed, 588 insertions(+), 623 deletions(-)

-- 
Jens Axboe

