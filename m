Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1DRUBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:01:31 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:41526 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1DRUB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:01:28 -0400
X-ASG-Debug-ID: 1303156858-01de284cf8160f10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC9876.6020004@fusionio.com>
Date: Mon, 18 Apr 2011 22:00:54 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.39-rc3
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block fixes for 2.6.39-rc3
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303156858
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61245
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

With this in, I believe the only regression there's left is the one in
IDE which seems to be due to endless media events being generated. In
this round:

- Removal of the ->unplugged_fn(), as MD could not really use it. This
  adds a callback list instead, which MD can use to get notification on
  the level it requires.

- Neils MD fixes to fix with write intent bitmap hanging.

- Small fixup to use kblockd workqueue for the delay work, that was an
  oversight (it used the system workqueue instead).

- Small improvement to drop the queue lock before doing the async
  kblockd wakeup.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (1):
      block: add blk_run_queue_async

Jens Axboe (3):
      Revert "block: add callback function for unplug notification"
      block: drop queue lock before calling __blk_run_queue() for kblockd punt
      block: blk_delay_queue() should use kblockd workqueue

NeilBrown (7):
      block: Enhance new plugging support to support general callbacks
      md: use new plugging interface for RAID IO.
      md/dm - remove remains of plug_fn callback.
      md - remove old plugging code.
      md: provide generic support for handling unplug callbacks.
      md: incorporate new plugging into raid5.
      md: fix up raid1/raid10 unplugging.

 block/blk-core.c                 |   83 ++++++++++++++++++++++++++++--------
 block/blk-exec.c                 |    2 +-
 block/blk-flush.c                |    4 +-
 block/blk-settings.c             |   16 -------
 block/blk.h                      |    1 +
 block/cfq-iosched.c              |    6 +-
 block/elevator.c                 |    4 +-
 drivers/md/dm-raid.c             |    8 ----
 drivers/md/md.c                  |   87 ++++++++++++++++++++------------------
 drivers/md/md.h                  |   26 ++----------
 drivers/md/raid1.c               |   29 ++++++-------
 drivers/md/raid10.c              |   27 ++++++------
 drivers/md/raid5.c               |   61 +++++++++++---------------
 drivers/md/raid5.h               |    2 -
 drivers/scsi/scsi_lib.c          |    2 +-
 drivers/scsi/scsi_transport_fc.c |    2 +-
 include/linux/blkdev.h           |   12 +++--
 include/linux/device-mapper.h    |    1 -
 18 files changed, 186 insertions(+), 187 deletions(-)

-- 
Jens Axboe

