Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2AOJpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:45:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:34717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2AOJpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:45:12 -0500
Message-ID: <4F12A025.2090207@kernel.dk>
Date: Sun, 15 Jan 2012 10:45:09 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO bits for 3.3-rc
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

See below for the initial 3.3-rc1 git pull request in the block IO area.
Not too much queued up for this round, mostly some code churn to improve
some of the existing functionality.

It has the following changes:

- The big io context cleanup from Tejun.

- Remove duplicated block plug in mpage_readpages(). read_pages()
  already does the plugging, and it's the only call path to
  mpage_readpages().

- ioctl to query rotational nature of a device from Martin.

- Getting rid of the bio integrity macros, use proper functions instead.

- Recursive merging was added and then disabled, it's suspected to be
  our cause for empty cfqq crashes. It'll be re-enabled once we get to
  the bottom of this.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.3/core


Jens Axboe (2):
      block: ioc_cgroup_changed() needs to be exported
      Revert "block: recursive merge requests"

Martin K. Petersen (3):
      block: Introduce blk_set_stacking_limits function
      block: Add BLKROTATIONAL ioctl
      block: Stop using macro stubs for the bio data integrity calls

Namjae Jeon (1):
      fs: remove unneeded plug in mpage_readpages()

Shaohua Li (2):
      block, cfq: fix empty queue crash caused by request merge
      block: recursive merge requests

Stephen Rothwell (1):
      blockdev: convert some macros to static inlines

Tejun Heo (28):
      block, sx8: kill blk_insert_request()
      block: add blk_queue_dead()`
      block: fix drain_all condition in blk_drain_queue()
      block: add missing blk_queue_dead() checks
      block, cfq: move cfqd->cic_index to q->id
      block: misc ioc cleanups
      block: make ioc get/put interface more conventional and fix race on alloction
      block: misc updates to blk_get_queue()
      block, cfq: misc updates to cfq_io_context
      block, cfq: move ioc ioprio/cgroup changed handling to cic
      block, cfq: fix race condition in cic creation path and tighten locking
      block, cfq: fix cic lookup locking
      block, cfq: unlink cfq_io_context's immediately
      block, cfq: remove delayed unlink
      block, cfq: kill ioc_gone
      block, cfq: kill cic->key
      block, cfq: replace current_io_context() with create_io_context()
      block: reorder elevator switch sequence
      block: remove elevator_queue->ops
      block, cfq: reorganize cfq_io_context into generic and cfq specific parts
      block, cfq: move cfqd->icq_list to request_queue and add request->elv.icq
      block, cfq: move io_cq lookup to blk-ioc.c
      block, cfq: move icq cache management to block core
      block, cfq: move io_cq exit/release to blk-ioc.c
      block, cfq: restructure io_cq creation path for io_context interface cleanup
      block, cfq: move icq creation and rq->elv.icq association to block core
      block: an exiting task should be allowed to create io_context
      block: remove WARN_ON_ONCE() in exit_io_context()

 block/blk-cgroup.c        |   11 +-
 block/blk-core.c          |  203 +++++++++------
 block/blk-exec.c          |    8 +-
 block/blk-ioc.c           |  485 +++++++++++++++++++++++++++++------
 block/blk-settings.c      |   32 ++-
 block/blk-sysfs.c         |   12 +-
 block/blk-throttle.c      |    4 +-
 block/blk.h               |   58 ++++-
 block/bsg.c               |    4 +-
 block/cfq-iosched.c       |  619 +++++++++------------------------------------
 block/compat_ioctl.c      |    3 +
 block/deadline-iosched.c  |    4 +-
 block/elevator.c          |  217 ++++++++--------
 block/genhd.c             |    2 +-
 block/ioctl.c             |    2 +
 block/noop-iosched.c      |    4 +-
 drivers/block/sx8.c       |   12 +-
 drivers/md/dm-table.c     |    6 +-
 drivers/md/md.c           |    1 +
 drivers/scsi/scsi_scan.c  |    2 +-
 fs/ioprio.c               |   24 +--
 fs/mpage.c                |    4 -
 include/linux/bio.h       |   66 ++++-
 include/linux/blkdev.h    |  101 ++++++--
 include/linux/elevator.h  |   41 ++--
 include/linux/fs.h        |    1 +
 include/linux/iocontext.h |  136 +++++++---
 kernel/fork.c             |    8 +-
 28 files changed, 1133 insertions(+), 937 deletions(-)

-- 
Jens Axboe

