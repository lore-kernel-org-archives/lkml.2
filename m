Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0GGOwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:52:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab0GGOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:51:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/7] block: BKL removal, version 4
Date: Wed,  7 Jul 2010 16:51:22 +0200
Message-Id: <1278514289-21054-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V02:K0:Z5nMDBbbDoSUMO/2awxazH8Rl2Mpdw2KACWLkiN1h8J
 5qvfDkWvpcg3pjTbyYb+qhUbgZxjJG1XgMhC8oRze1M+MUlTR7
 3elpKZ9Nfqqjul3pUgGpqsCyWbdWWtEqXuSeNwxr7As/PpgOXM
 sbnYvd4unTsfJhyZl6GC0T3G8bM3dKTamUCVMpIRMQoXe0zX1M
 LkPjqyimgmEsj57WLBYjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes the big kernel lock from the common
block layer code by pushing it into the individual
device drivers.

This version incorporates further changes to address
comments from Christoph Hellwig and Sam Ravnborg,
many thanks for the valuable feedback!

I'd like to get this into 2.6.36 in order to remove
the BKL from all the core kernel code.

Once Christoph is happy with the series, in particular
the third patch, I'd like to add it to linux-next
for broader testing, preferrably though Jens Axboe's
linux-2.6-block.git tree.

Arnd Bergmann (7):
  scsi/i2o_block: cleanup ioctl handling
  block: push down BKL into .locked_ioctl
  block: push down BKL into .open and .release
  block: push BKL into blktrace ioctls
  block: remove BKL from BLKROSET and BLKFLSBUF
  block: remove BKL from partition ioctls
  scsi/sd: remove big kernel lock

 arch/um/drivers/ubd_kern.c          |    7 ++++-
 block/compat_ioctl.c                |   56 -----------------------------------
 block/ioctl.c                       |   21 +------------
 drivers/block/DAC960.c              |   13 +++++--
 drivers/block/amiflop.c             |   29 +++++++++++++++--
 drivers/block/aoe/aoeblk.c          |    4 ++
 drivers/block/ataflop.c             |   32 +++++++++++++++++--
 drivers/block/brd.c                 |    5 ++-
 drivers/block/cciss.c               |   31 +++++++++++++++----
 drivers/block/cpqarray.c            |   40 ++++++++++++++++++++++---
 drivers/block/drbd/drbd_main.c      |    4 ++
 drivers/block/floppy.c              |   22 ++++++++++++-
 drivers/block/loop.c                |    5 +++
 drivers/block/nbd.c                 |    5 ++-
 drivers/block/paride/pcd.c          |   21 +++++++++++--
 drivers/block/paride/pd.c           |    9 +++++-
 drivers/block/paride/pf.c           |   26 ++++++++++++----
 drivers/block/pktcdvd.c             |   18 +++++++++--
 drivers/block/swim.c                |   20 +++++++++++-
 drivers/block/swim3.c               |   32 ++++++++++++++++++--
 drivers/block/ub.c                  |   27 +++++++++++++++--
 drivers/block/viodasd.c             |   19 +++++++++++-
 drivers/block/virtio_blk.c          |   17 +++++++++-
 drivers/block/xd.c                  |   17 +++++++++-
 drivers/block/xen-blkfront.c        |    9 +++++-
 drivers/block/xsysace.c             |    6 ++++
 drivers/block/z2ram.c               |   13 ++++++--
 drivers/cdrom/gdrom.c               |   19 ++++++++++--
 drivers/cdrom/viocd.c               |   21 +++++++++++--
 drivers/ide/ide-cd.c                |   32 +++++++++++++++----
 drivers/ide/ide-disk_ioctl.c        |    9 ++++-
 drivers/ide/ide-floppy_ioctl.c      |   12 +++++--
 drivers/ide/ide-gd.c                |   19 ++++++++++-
 drivers/ide/ide-tape.c              |   19 ++++++++++--
 drivers/md/dm.c                     |    7 ++++
 drivers/md/md.c                     |    6 ++++
 drivers/memstick/core/mspro_block.c |    9 +++++-
 drivers/message/i2o/i2o_block.c     |    4 ++
 drivers/mmc/card/block.c            |    5 +++
 drivers/mtd/mtd_blkdevs.c           |   11 +++++-
 drivers/s390/block/dasd.c           |    6 ++++
 drivers/s390/block/dcssblk.c        |    5 +++
 drivers/s390/char/tape_block.c      |    8 ++++-
 drivers/scsi/sd.c                   |   25 ++++++++++-----
 drivers/scsi/sd.h                   |    2 +-
 drivers/scsi/sr.c                   |   25 ++++++++++++----
 drivers/staging/hv/blkvsc_drv.c     |    5 +++
 fs/block_dev.c                      |   10 +-----
 include/linux/blkdev.h              |    1 -
 include/linux/blktrace_api.h        |   12 +++++++
 kernel/trace/blktrace.c             |   43 ++++++++++++++++++++++++++
 51 files changed, 637 insertions(+), 186 deletions(-)

