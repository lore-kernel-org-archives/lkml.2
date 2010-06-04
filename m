Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0FDMxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:53:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39212 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab0FDMxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:53:47 -0400
Message-ID: <4C08F758.7070009@fusionio.com>
Date: Fri, 04 Jun 2010 14:53:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block/IO bits for 2.6.35-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are a bunch of updates for 2.6.35-rc1. The major components:

- Revert of the two writeback fixes that made WB_SYNC_NONE
  writeback from umount actually work. They apparently cause
  problems for Christoph, so revert them until we figure this
  out.

- Updates to the pipe fcntl F_{GET,SET}PIPE_SZ interface to
  reflect the discussion with Michael. The major bits there
  are allowing for just 1 page in the pipe, change of capability
  required to enlarge a pipe beyond the system setting, and
  change of the /proc/sys/fs/pipe-max-pages to be in bytes
  like the fcntl API. The latter also renames the file to
  pipe-max-size to reflect that.

- A drbd update.

- The rest are minor fixes, like discard support for brd to
  ease testing of that and some memory consumption improvements
  for CFQ.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Andrea Gelmini (1):
      drbd: removed duplicated #includes

Dan Carpenter (1):
      cciss: call BUG() earlier

Jens Axboe (9):
      pipe: F_SETPIPE_SZ should return -EPERM for non-root
      pipe: make F_{GET,SET}PIPE_SZ deal with byte sizes
      Revert "writeback: ensure that WB_SYNC_NONE writeback with sb pinned is sync"
      Revert "writeback: fix WB_SYNC_NONE writeback from umount"
      block: disable preemption before using sched_clock()
      Merge branch 'master' into for-linus
      pipe: adjust minimum pipe size to 1 page
      pipe: change the privilege required for growing a pipe beyond system max
      pipe: change /proc/sys/fs/pipe-max-pages to byte sized interface

Konstantin Khlebnikov (2):
      cfq-iosched: remove dead_key from cfq_io_context
      cfq-iosched: compact io_context radix_tree

Lars Ellenberg (5):
      drbd: improve network latency, TCP_QUICKACK
      drbd: need to set socket bufsize early to take effect
      drbd: improve usage of MSG_MORE
      drbd: fix hang on local read errors while disconnected
      drbd: use drbd specific ratelimit instead of global printk_ratelimit

Mike Snitzer (3):
      block: Adjust elv_iosched_show to return "none" for bio-based DM
      block: avoid unconditionally freeing previously allocated request_queue
      block: make blk_init_free_list and elevator_init idempotent

Nick Piggin (2):
      fs/splice.c: fix mapping_gfp_mask usage
      brd: support discard

Philipp Reisner (4):
      drbd: Revert "drbd: Create new current UUID as late as possible"
      drbd: Removed the now empty w_io_error() function
      drbd: Reduce verbosity
      Preparing 8.3.8rc2

Shaohua Li (1):
      cfq-iosched: fix an oops caused by slab leak

 block/blk-core.c                   |   20 +++++--
 block/cfq-iosched.c                |  101 ++++++++++++++++++++++++++++--------
 block/elevator.c                   |    8 ++-
 drivers/block/brd.c                |   53 ++++++++++++++++++-
 drivers/block/cciss_scsi.c         |    2 +-
 drivers/block/drbd/drbd_int.h      |   14 +----
 drivers/block/drbd/drbd_main.c     |   68 +++++++++---------------
 drivers/block/drbd/drbd_receiver.c |   45 ++++++++--------
 drivers/block/drbd/drbd_req.c      |   54 +++++--------------
 drivers/block/drbd/drbd_req.h      |    1 +
 drivers/block/drbd/drbd_worker.c   |   24 +--------
 fs/fs-writeback.c                  |   64 ++++++-----------------
 fs/pipe.c                          |   77 +++++++++++++++++++---------
 fs/splice.c                        |    2 +-
 fs/sync.c                          |    2 +-
 include/linux/backing-dev.h        |    2 +-
 include/linux/blkdev.h             |    9 +++
 include/linux/drbd.h               |    2 +-
 include/linux/iocontext.h          |    1 -
 include/linux/pipe_fs_i.h          |    4 +-
 include/linux/writeback.h          |   10 ----
 kernel/sysctl.c                    |    8 ++--
 mm/page-writeback.c                |    4 +-
 23 files changed, 311 insertions(+), 264 deletions(-)

-- 
Jens Axboe

