Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab1GYIQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:16:15 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33397 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GYIQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:16:06 -0400
X-ASG-Debug-ID: 1311581759-01de280c1eec990001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E2D263C.1060807@fusionio.com>
Date: Mon, 25 Jul 2011 10:15:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Core block IO bits for 3.1
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Core block IO bits for 3.1
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1311581759
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.69905
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing big and major this time, this will be a relaxed cycle on the IO
side.

- Removal of the fs_excl from the task_struct. Gets rid of an IO member
  in there, which is a good thing. It was never utilized to the intent
  that it was supposed to be, so lets kill it.

- Removal of CFQ special treatment of requests marked as meta data IO.
  This enables us to expand the scope of what is labelled as meta data
  IO, giving us better tracing on the IO side.

- Fix for a potential starvation issue of aliases requests.

- Conservative handling of discard limits, potentially preventing an
  infinite loop for a driver that doesn't set all (or buggy) limits.

- Expedited RCU grace period on device removal. Greatly speeds up
  removal of lots of devices.

- Auto-flush of the on-stack plug list if we reach a certain depth.

- Various little fixes or cosmetic tweaks.

Please pull.


  git://git.kernel.dk/linux-block.git for-3.1/core

Dan Williams (1):
      block: strict rq_affinity

H Hartley Sweeten (1):
      fs/partitions/check.c: make local symbols static

Jeff Moyer (1):
      iosched: prevent aliased requests from starving other I/O

Jens Axboe (3):
      cfq-iosched: fix locking around ioc->ioc_data assignment
      Merge branch 'for-linus' into for-3.1/core
      block: fix patch import error in max_discard_sectors check

Joe Perches (2):
      block: Add __attribute__((format(printf...) and fix fallout
      blk-throttle: Make total_nr_queued unsigned

Johannes Stezenbach (2):
      compat_ioctl: fix warning caused by qemu
      compat_ioctl: fix make headers_check regression

Justin TerAvest (2):
      cfq: Remove special treatment for metadata rqs.
      fixlet: Remove fs_excl from struct task.

Mike Snitzer (1):
      block: eliminate potential for infinite loop in blkdev_issue_discard

Mikulas Patocka (1):
      backing-dev: use synchronize_rcu_expedited instead of synchronize_rcu

Paul Bolle (2):
      CFQ: make two functions static
      block: rename the return of two functions

Richard Kennedy (1):
      block: reorder request_queue to remove 64 bit alignment padding

Shaohua Li (5):
      block: avoid building too big plug list
      block: document blk_plug list access
      CFQ: move think time check variables to a separate struct
      CFQ: add think time check for service tree
      CFQ: add think time check for group

Tejun Heo (1):
      block: flush MEDIA_CHANGE from drivers on close(2)

Wanlong Gao (2):
      block:fix the comment error in blkdev.h
      block:remove some spare spaces in genhd.c

 Documentation/block/queue-sysfs.txt |   10 ++-
 block/blk-core.c                    |   11 ++-
 block/blk-ioc.c                     |   40 +++++-----
 block/blk-lib.c                     |    5 +-
 block/blk-softirq.c                 |   11 ++-
 block/blk-sysfs.c                   |   13 ++-
 block/blk-throttle.c                |    8 +-
 block/cfq-iosched.c                 |  152 +++++++++++++++++-----------------
 block/compat_ioctl.c                |   14 ---
 block/deadline-iosched.c            |    4 +-
 block/elevator.c                    |    7 +-
 block/genhd.c                       |   28 ++++---
 fs/block_dev.c                      |   23 +++--
 fs/compat_ioctl.c                   |    5 +
 fs/partitions/check.c               |   12 ++--
 fs/reiserfs/journal.c               |   13 ---
 fs/super.c                          |    4 -
 include/linux/blkdev.h              |   27 ++++--
 include/linux/elevator.h            |    2 +-
 include/linux/fd.h                  |   22 +++++
 include/linux/fs.h                  |    4 -
 include/linux/genhd.h               |    2 +-
 include/linux/init_task.h           |    1 -
 include/linux/iocontext.h           |   14 ++-
 include/linux/sched.h               |    1 -
 kernel/exit.c                       |    1 -
 kernel/fork.c                       |    1 -
 mm/backing-dev.c                    |    2 +-
 28 files changed, 229 insertions(+), 208 deletions(-)

-- 
Jens Axboe

