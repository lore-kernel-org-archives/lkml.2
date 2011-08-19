Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1HSNQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:16:48 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:46708 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab1HSNQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:16:44 -0400
X-ASG-Debug-ID: 1313759803-03d6a510a62f6310001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E4E6238.3080808@fusionio.com>
Date: Fri, 19 Aug 2011 15:16:40 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 3.1-rc
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block bits for 3.1-rc
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313759803
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72216
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a lot larger than it usually would be at this time. The
reason is mostly the expedited merge window overlapping with
my vacation. That said, the traffic in this branch in the last
few weeks has only been fixes and it's continually been in linux-next
and run on my various machines. So I'm quite confident that it's sound.

So what's in here:

- A few fixes for some cdrom corner cases.
- Flush fixing for stacked devices
- Revert of the CFQ meta data special treatment patch, it's been shown
  to regress a kernel build workload by about 10%. More investigation
  is needed, for 3.1 lets just back it out.
- bsg helper library, moving the FC class code into the block layer
  for proper sharing with eg iscsi/SAS.
- Nicer loop multi device handling code, and loop deadlock fix.
- Two fixups for xen-blkfront, one for xen-blkback.
- Fixups for rq_affinity changes that went into 3.1-rc1.
- Fixup for CFQ
- Support for properly tracing FLUSH and FUA commands with blktrace.

Diffstat looks large because of the bsg-lib addition, apart from that
it's mostly smallish stuff.

Please pull.


  git://git.kernel.dk/linux-block.git for-linus

Andrew Morton (1):
      drivers/cdrom/cdrom.c: relax check on dvd manufacturer value

Axel Lin (1):
      block: swim3: fix unterminated of_device_id table

H Hartley Sweeten (1):
      drivers/block/drbd/drbd_nl.c: use bitmap_parse instead of __bitmap_parse

Herbert Poetzl (1):
      block/genhd.c: remove useless cast in diskstats_show()

Jeff Moyer (2):
      allow blk_flush_policy to return REQ_FSEQ_DATA independent of *FLUSH
      block: fix flush machinery for stacking drivers with differring flush flags

Jens Axboe (3):
      bsg-lib: add module.h include
      Merge branch 'stable/for-jens' of git://git.kernel.org/.../konrad/xen into for-linus
      Revert "cfq: Remove special treatment for metadata rqs."

Kay Sievers (4):
      loop: replace linked list of allocated devices with an idr index
      loop: add management interface for on-demand device allocation
      loop: add BLK_DEV_LOOP_MIN_COUNT=%i to allow distros 0 pre-allocated loop devices
      loop: fix deadlock when sysfs and LOOP_CLR_FD race against each other

Konrad Rzeszutek Wilk (1):
      xen/blkback: Make description more obvious.

Matthew Wilcox (1):
      Move some REQ flags to the common bio/request area

Mike Christie (1):
      block: add bsg helper library

Namhyung Kim (1):
      blktrace: add FLUSH/FUA support

Shaohua Li (2):
      blk-throttle: correctly determine sync bio
      block: improve rq_affinity placement

Stefan Bader (2):
      xen-blkfront: Drop name and minor adjustments for emulated scsi devices
      xen-blkfront: Fix one off warning about name clash

Tao Ma (1):
      block: Make rq_affinity = 1 work as expected

Vivek Goyal (2):
      cfq-iosched: Reduce linked group count upon group destruction
      cfq-iosched: Add documentation about idling

 Documentation/block/cfq-iosched.txt |   71 +++++++++
 Documentation/kernel-parameters.txt |    9 +-
 block/Kconfig                       |   10 ++
 block/Makefile                      |    1 +
 block/blk-core.c                    |    8 +-
 block/blk-flush.c                   |   25 +++-
 block/blk-softirq.c                 |    8 +
 block/blk-throttle.c                |    4 +-
 block/blk.h                         |    2 +
 block/bsg-lib.c                     |  298 +++++++++++++++++++++++++++++++++++
 block/cfq-iosched.c                 |   21 +++
 block/genhd.c                       |    8 +-
 drivers/block/Kconfig               |   17 ++-
 drivers/block/drbd/drbd_nl.c        |    4 +-
 drivers/block/loop.c                |  297 ++++++++++++++++++++++++-----------
 drivers/block/swim3.c               |    1 +
 drivers/block/xen-blkfront.c        |    6 +-
 drivers/cdrom/cdrom.c               |    8 +-
 include/linux/blk_types.h           |    7 +-
 include/linux/blkdev.h              |    5 +
 include/linux/blktrace_api.h        |    5 +-
 include/linux/bsg-lib.h             |   73 +++++++++
 include/linux/loop.h                |    5 +-
 include/linux/miscdevice.h          |    1 +
 include/trace/events/block.h        |   20 ++-
 kernel/trace/blktrace.c             |   21 ++-
 26 files changed, 800 insertions(+), 135 deletions(-)
 create mode 100644 block/bsg-lib.c
 create mode 100644 include/linux/bsg-lib.h

-- 
Jens Axboe

