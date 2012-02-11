Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2BKMLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:11:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:44740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2BKMLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:11:16 -0500
Message-ID: <4F365ADF.7060102@kernel.dk>
Date: Sat, 11 Feb 2012 13:11:11 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 3.3-rc
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Time to push off some of the pending items. I really wanted to wait until
we had the regression nailed, but alas it's not quite there yet. But I'm
very confident that it's "just" a missing expire on exit, so fix from
Tejun should be fairly trivial. I'm headed out for a week on the slopes.

- Killing the barrier part of mtip32xx. It doesn't really support
  barriers, and it doesn't need them (writes are fully ordered).

- A few fixes from Dan Carpenter, preventing overflows of integer
  multiplication.

- A fixup for loop, fixing a previous commit that didn't quite solve the
  partial read problem from Dave Young.

- A bio integer overflow fix from Kent Overstreet.

- Improvement/fix of the door "keep locked" part of the cdrom shared
  code from Paolo Benzini.

- A few cfq fixes from Shaohua Li.

- A fix for bsg sysfs warning when removing a file it did not create
  from Stanislaw Gruszka.

- Two fixes for floppy from Vivek, preventing a crash.

- A few block core fixes from Tejun. One killing the over-optimized ioc
  exit path, cleaning that up nicely. Two others fixing an oops on
  elevator switch, due to calling into the scheduler merge check code
  without holding the queue lock.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

Asai Thambi S P (1):
      mtip32xx: removed the irrelevant argument of mtip_hw_submit_io() and the unused member of struct driver_data

Dan Carpenter (2):
      cdrom: use copy_to_user() without the underscores
      relay: prevent integer overflow in relay_open()

Dave Young (1):
      loop: zero fill bio instead of return -EIO for partial read

Kent Overstreet (1):
      bio: don't overflow in bio_get_nr_vecs()

Paolo Bonzini (1):
      cdrom: move shared static to cdrom_device_info

Shaohua Li (3):
      block,cfq: change code order
      block: fix NULL icq_cache reference
      block: fix ioc locking warning

Stanislaw Gruszka (1):
      bsg: fix sysfs link remove warning

Tejun Heo (4):
      block: strip out locking optimization in put_io_context()
      block: separate out blk_rq_merge_ok() and blk_try_merge() from elevator functions
      block: don't call elevator callbacks for plug merges
      block: fix lockdep warning on io_context release put_io_context()

Vivek Goyal (2):
      floppy: Cleanup disk->queue before caling put_disk() if add_disk() was never called
      floppy: Fix a crash during rmmod

 block/blk-cgroup.c                |    2 +-
 block/blk-core.c                  |   33 ++++++-----
 block/blk-ioc.c                   |  111 ++++++++----------------------------
 block/blk-merge.c                 |   37 ++++++++++++
 block/blk.h                       |    2 +
 block/bsg.c                       |    3 +-
 block/cfq-iosched.c               |   24 +++-----
 block/elevator.c                  |   55 +-----------------
 drivers/block/floppy.c            |   17 +++++-
 drivers/block/loop.c              |   24 ++++----
 drivers/block/mtip32xx/mtip32xx.c |   11 ++--
 drivers/block/mtip32xx/mtip32xx.h |    5 --
 drivers/cdrom/cdrom.c             |   20 ++-----
 fs/bio.c                          |   10 +--
 fs/ioprio.c                       |    2 +-
 include/linux/blkdev.h            |    3 -
 include/linux/cdrom.h             |    3 +-
 include/linux/elevator.h          |    9 +---
 include/linux/iocontext.h         |    5 +-
 kernel/fork.c                     |    2 +-
 kernel/relay.c                    |   10 +++-
 21 files changed, 155 insertions(+), 233 deletions(-)

-- 
Jens Axboe

