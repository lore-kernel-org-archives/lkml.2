Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0KKN5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:57:18 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:47335 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0KKN5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:57:17 -0500
X-ASG-Debug-ID: 1289483835-6b65fcc40001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CDBF633.8040806@fusionio.com>
Date: Thu, 11 Nov 2010 14:57:07 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.37-rc1
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block bits for 2.6.37-rc1
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289483835
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0155 1.0000 -1.9201
X-Barracuda-Spam-Score: -1.92
X-Barracuda-Spam-Status: No, SCORE=-1.92 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46327
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are the fixes that have been collected since the initial push.
It's a bit larger than I would have liked, but the majority of the code
churn there is simply finishing the conversion away from the previous
REQ_HARDBARRIER. In summary:

- Two fixes for RCU locking around io priority support from Sergey and
  Daniel.

- Four fixes from me to report issues around missing validation of parts
  of the iov interface inside the block layer. All of these were
  reported by Dan Rosenberg.

- Removal of copy_io_context(), it's been unused since the AS io
  scheduler was killed from me.

- Documentational pruning of the AS io scheduler from Randy Dunlap.

- An kernel stack leak to userspace has been fixed up, missing a memset,
  from Vasiliy.

- Some fixes for cciss, mostly from HP but a fixup from me as well.

- Correct use of i_size_read() in various places instead of direct read
  of the inode size from Mike Snitzer.

- A drbd fix, and three patches to finish the transition to the new
  barrier scheme.

- Killing of REQ_HARDBARRIER in the block core from Christoph.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (1):
      block: remove REQ_HARDBARRIER

Daniel J Blueman (1):
      ioprio: fix RCU locking around task dereference

Jens Axboe (8):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-2.6.37/drivers
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      block: take care not to overflow when calculating total iov length
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      bio: take care not overflow page count when mapping/copying user data
      cciss: fix proc warning on attempt to remove non-existant directory
      Merge branch 'for-2.6.37/drivers' into for-linus
      block: remove unused copy_io_context()

Lars Ellenberg (6):
      drbd: consolidate explicit drbd_md_sync into drbd_create_new_uuid
      drbd: tag a few error messages with "assert failed"
      drbd: fix potential deadlock on detach
      drbd: fix potential data divergence after multiple failures
      drbd: fix a misleading printk
      drbd: rate limit an error message

Mike Snitzer (1):
      block: read i_size with i_size_read()

Philipp Reisner (4):
      drbd: Silenced an assert
      drbd: Removed the BIO_RW_BARRIER support form the receiver/epoch code
      drbd: REQ_HARDBARRIER -> REQ_FUA transition for meta data accesses
      drbd: Removed checks for REQ_HARDBARRIER on incomming BIOs

Randy Dunlap (1):
      Documentation: remove anticipatory scheduler info

Sergey Senozhatsky (1):
      ioprio: rcu_read_lock/unlock protect find_task_by_vpid call (V2)

Stephen M. Cameron (5):
      cciss: fix board status waiting code
      cciss: Use kernel provided PCI state save and restore functions
      cciss: limit commands allocated on reset_devices
      cciss: use usleep_range not msleep for small sleeps
      cciss: remove controllers supported by hpsa

Vasiliy Kulikov (1):
      block: ioctl: fix information leak to userland

 Documentation/block/switching-sched.txt |    8 +-
 Documentation/kernel-parameters.txt     |    2 +-
 Documentation/rbtree.txt                |    4 +-
 block/blk-core.c                        |   11 +--
 block/blk-ioc.c                         |   14 --
 block/blk-map.c                         |    2 +
 block/compat_ioctl.c                    |    4 +-
 block/elevator.c                        |    4 +-
 block/ioctl.c                           |    7 +-
 block/scsi_ioctl.c                      |   34 ++++--
 drivers/block/aoe/aoeblk.c              |    3 -
 drivers/block/cciss.c                   |  131 +++++++++----------
 drivers/block/cciss.h                   |    4 +
 drivers/block/drbd/drbd_actlog.c        |   42 ++++---
 drivers/block/drbd/drbd_int.h           |   52 ++++----
 drivers/block/drbd/drbd_main.c          |  148 ++++++++++++---------
 drivers/block/drbd/drbd_nl.c            |   25 +++-
 drivers/block/drbd/drbd_proc.c          |    1 -
 drivers/block/drbd/drbd_receiver.c      |  217 +++++--------------------------
 drivers/block/drbd/drbd_req.c           |   38 +++---
 drivers/block/drbd/drbd_worker.c        |   23 +---
 drivers/block/loop.c                    |    6 -
 drivers/block/xen-blkfront.c            |    2 -
 drivers/md/md.c                         |   20 ++--
 drivers/scsi/scsi_error.c               |   18 +--
 drivers/usb/storage/uas.c               |    5 +-
 fs/bio.c                                |   23 +++-
 fs/ioprio.c                             |   18 +++-
 include/linux/bio.h                     |    4 -
 include/linux/blk_types.h               |    6 +-
 include/linux/blkdev.h                  |    3 +-
 include/linux/drbd.h                    |    2 +-
 include/linux/iocontext.h               |    1 -
 kernel/trace/blktrace.c                 |    4 -
 34 files changed, 367 insertions(+), 519 deletions(-)

-- 
Jens Axboe

