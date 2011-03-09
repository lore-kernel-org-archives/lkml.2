Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1CIJNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:13:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1CIJNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=GSMQqesASD1pwAFx4AkEVoG7SeUW+8vaTEeDAL4WO4xVxFtPuNvUU36bCQKKCzoHYz
         +aMP6RRWgiy2UG4bm8BP4elzsZB3U0rpyS8Wlyotd2wswL8ligkep2zYBuRbFRPpi77W
         S0NX3ZSaaa/yvwXntIux/eOCbgFKvY/9j7DlA=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: [PATCHSET] block: Convert block drivers to ->check_events(), take#2
Date: Wed,  9 Mar 2011 10:13:20 +0100
Message-Id: <1299662016-7721-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of convert-block-drivers-to-check_events
patchset.  Other than addition of Acked-by's and rebasing on top of
the current block:for-2.6.39/core (df457f845e), nothing really
changed.

This patchset converts all in-kernel block drivers from
->media_changed() to ->check_events().  Most conversions are fairly
mechanical.  The only notable exceptions are,

* 0014-umem: media_changed was dummy.  As ->check_events() can be
  omitted, just drop it.

* 0015-pktcdvd: inherits and forwards ->check_events() instead of
  ->media_changed() from the underlying device.

This patchset contains the following sixteen patches.

 0001-block-Don-t-implicitly-trigger-event-check-on-disk_u.patch
 0002-block-Don-t-check-events-on-close-unless-it-was-bloc.patch
 0003-block-Don-t-check-events-while-open-is-in-progress.patch
 0004-ide-Convert-to-bdops-check_events.patch
 0005-floppy-ami-ata-flop-Convert-to-bdops-check_events.patch
 0006-gdrom-viocd-Convert-to-bdops-check_events.patch
 0007-paride-Convert-to-bdops-check_events.patch
 0008-dac960-Convert-to-bdops-check_events.patch
 0009-swim-3-Convert-to-bdops-check_events.patch
 0010-ub-Convert-to-bdops-check_events.patch
 0011-xsysace-Convert-to-bdops-check_events.patch
 0012-i2o_block-Convert-to-bdops-check_events.patch
 0013-s390-tape_block-Convert-to-bdops-check_events.patch
 0014-umem-Drop-dummy-media_changed.patch
 0015-pktcdvd-Convert-to-bdops-check_events.patch
 0016-staging-Convert-to-bdops-check_events.patch

0001-0003 prepare for further conversions.  Some of the conversions
are not very well behaved in that they may generate spurious events
and allow event polling between event clearing check and the actual
clearing.  These three patches modify the disk event check behavior
such that such faults can be tolerated.

0004-0016 convert all block drivers.  Conversions are mostly
mechanical, all changes except for one of the staging driver are
compile-tested and ide is verified to behave correctly after the
conversion.

This patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git disk-event-convert

HEAD is 7904f29ceb3847e7bb8f3296b406c54b8856de56.  As git.korg may
take some time to sync, if you're seeing an old commit, please pull
from master.korg.

 ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git disk-event-convert
 
diffstat follows.

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

[1] http://thread.gmane.org/gmane.linux.kernel/1081268
