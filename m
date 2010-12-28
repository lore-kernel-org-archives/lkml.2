Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0L1R3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:29:24 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:44628 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0L1R3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=mISF2ZYsA+EM6PvSBmbBeXi5EX6KqLD9WMVbLQOspQRS6vMG89YReyUSqaHuu3XStk
         jOTtue2Mj7Hrc8Eni+9U0tgU5PLMJt79b/2FpWbqujXWwc9r5ox4jXoP66eAfGPZbr6H
         1sNUMRi1ZyYso4edkMSnjN5VMNXVZR92Uem2k=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: [PATCHSET] block: convert block drivers to ->check_events()
Date: Tue, 28 Dec 2010 18:28:56 +0100
Message-Id: <1293557352-10592-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts all in-kernel block drivers from
->media_changed() to ->check_events().  Most conversions are fairly
mechanical.  The only notable exceptions are,

* 0014-umem: media_changed was dummy.  As ->check_events() can be
  omitted, just drop it.

* 0015-pktcdvd: inherits and forwards ->check_events() instead of
  ->media_changed() from the underlying device.

 0001-block-don-t-implicitly-trigger-event-check-on-disk_u.patch
 0002-block-don-t-check-events-on-close-unless-it-was-bloc.patch
 0003-block-don-t-check-events-while-open-is-in-progress.patch
 0004-ide-convert-to-bdops-check_events.patch
 0005-floppy-ami-ata-flop-convert-to-bdops-check_events.patch
 0006-gdrom-viocd-convert-to-bdops-check_events.patch
 0007-paride-convert-to-bdops-check_events.patch
 0008-dac960-convert-to-bdops-check_events.patch
 0009-swim-3-convert-to-bdops-check_events.patch
 0010-ub-convert-to-bdops-check_events.patch
 0011-xsysace-convert-to-bdops-check_events.patch
 0012-i2o_block-convert-to-bdops-check_events.patch
 0013-s390-tape_block-convert-to-bdops-check_events.patch
 0014-umem-drop-dummy-media_changed.patch
 0015-pktcdvd-convert-to-bdops-check_events.patch
 0016-staging-convert-to-bdops-check_events.patch

0001-0003 prepare for further conversions.  Some of the conversions
are not very well behaved in that they may generate spurious events
and allow event polling between event clearing check and the actual
clearing.  These three patches modify the disk event check behavior
such that such faults can be tolerated.

0004-0016 convert all block drivers.  Conversions are mostly
mechanical, all changes except for one of the staging driver are
compile-tested and ide is verified to behave correctly after the
conversion.

We should be able to remove ->media_changed() in the next devel cycle
once the scsi bits and the block branch get merged.

This patchset is on top of the current linux-2.6-block/event-handling
(fcc57045d53edc35bcce456e60ac4aa802712934) and is available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git disk-event-convert

and contains the following changes.

 block/genhd.c                                               |    2 -
 drivers/block/DAC960.c                                      |    8 +++--
 drivers/block/amiflop.c                                     |    9 +++---
 drivers/block/ataflop.c                                     |   14 +++++----
 drivers/block/floppy.c                                      |   10 ++++--
 drivers/block/paride/pcd.c                                  |   18 +++++++-----
 drivers/block/paride/pd.c                                   |    7 ++--
 drivers/block/paride/pf.c                                   |   10 ++++--
 drivers/block/pktcdvd.c                                     |   13 ++++++--
 drivers/block/swim.c                                        |    8 +++--
 drivers/block/swim3.c                                       |   11 ++++---
 drivers/block/ub.c                                          |   10 ++++--
 drivers/block/umem.c                                        |   10 ------
 drivers/block/xsysace.c                                     |    9 +++---
 drivers/cdrom/gdrom.c                                       |   16 ++++++----
 drivers/cdrom/viocd.c                                       |   17 ++++++-----
 drivers/ide/ide-cd.c                                        |   10 ++++--
 drivers/ide/ide-cd.h                                        |    3 +-
 drivers/ide/ide-cd_ioctl.c                                  |    8 ++---
 drivers/ide/ide-gd.c                                        |   14 +++++----
 drivers/message/i2o/i2o_block.c                             |   11 ++++---
 drivers/s390/char/tape_block.c                              |   11 ++++---
 drivers/staging/hv/blkvsc_drv.c                             |   11 ++++---
 drivers/staging/westbridge/astoria/block/cyasblkdev_block.c |   11 ++++---
 fs/block_dev.c                                              |   11 ++++---
 25 files changed, 152 insertions(+), 110 deletions(-)

Thanks.

--
tejun
