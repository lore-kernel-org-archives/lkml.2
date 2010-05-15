Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0EOSKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:10:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:40259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab0EOSKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:10:17 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net,
       bzolnier@gmail.com
Subject: [PATCHSET] block,libata: implement ->unlock_native_capacity()
Date: Sat, 15 May 2010 20:09:26 +0200
Message-Id: <1273946974-29131-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 15 May 2010 18:09:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the evolved version of the implement-set_capacity patchset[L]
and contains the following patches.

 0001-buffer-make-invalidate_bdev-drain-all-percpu-LRU-add.patch
 0002-block-restart-partition-scan-after-resizing-a-device.patch
 0003-block-ide-simplify-bdops-set_capacity-to-unlock_nati.patch
 0004-block-use-struct-parsed_partitions-state-universally.patch
 0005-block-improve-automatic-native-capacity-unlocking.patch
 0006-SCSI-implement-sd_unlock_native_capacity.patch
 0007-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
 0008-libata-implement-on-demand-HPA-unlocking.patch

0001-0005 fix and update partition check related code and make the
existing automatic native capacity unlocking mechanism simpler and
more robust.

0001 fixes invalidate_bdev() which seems to have been somewhat broken
for quite some time since percpu LRU add cache was introduced.

0002 makes partition code to restart from beginning after native
capacity is locked so that resize and all other stuff can be dealt
with in the usual revalidation path.

0003 renames ->set_capacity() to ->unlock_native_capacity() and drops
the spurious new capacity parameter and return value.

0004 updates partition check API for the next patch.

0005 improves automatic native capacity unlocking code so that it
covers all partition misdetection cases which can be caused by limited
disk capacity.

0006-0008 add ->unlock_native_capacity() support to libata.  0001-0005
are probably best routed through block tree if David is okay with it
(0003 modifies ide), and 0006-0008 through libata if James is okay
with the SCSI part.  What do you guys think?

This patchset is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git unlock-native-capa

diffstat follows.

 drivers/ata/libata-core.c |    6 +--
 drivers/ata/libata-scsi.c |   29 ++++++++++++++
 drivers/ide/ide-disk.c    |   40 ++++++++------------
 drivers/ide/ide-gd.c      |   11 ++---
 drivers/scsi/sd.c         |   22 +++++++++++
 fs/buffer.c               |    1 
 fs/partitions/acorn.c     |   68 ++++++++++++++++------------------
 fs/partitions/acorn.h     |   10 ++---
 fs/partitions/amiga.c     |   13 +++---
 fs/partitions/amiga.h     |    2 -
 fs/partitions/atari.c     |    8 ++--
 fs/partitions/atari.h     |    2 -
 fs/partitions/check.c     |   84 ++++++++++++++++++++++++++++++------------
 fs/partitions/check.h     |   12 ++++++
 fs/partitions/efi.c       |   91 +++++++++++++++++++++-------------------------
 fs/partitions/efi.h       |    2 -
 fs/partitions/ibm.c       |   21 +++++-----
 fs/partitions/ibm.h       |    2 -
 fs/partitions/karma.c     |    4 +-
 fs/partitions/karma.h     |    2 -
 fs/partitions/ldm.c       |   89 ++++++++++++++++++++++----------------------
 fs/partitions/ldm.h       |    2 -
 fs/partitions/mac.c       |   11 +++--
 fs/partitions/mac.h       |    2 -
 fs/partitions/msdos.c     |   85 ++++++++++++++++++------------------------
 fs/partitions/msdos.h     |    2 -
 fs/partitions/osf.c       |    4 +-
 fs/partitions/osf.h       |    2 -
 fs/partitions/sgi.c       |    6 +--
 fs/partitions/sgi.h       |    2 -
 fs/partitions/sun.c       |    6 +--
 fs/partitions/sun.h       |    2 -
 fs/partitions/sysv68.c    |    6 +--
 fs/partitions/sysv68.h    |    2 -
 fs/partitions/ultrix.c    |    4 +-
 fs/partitions/ultrix.h    |    2 -
 include/linux/blkdev.h    |    3 -
 include/linux/ide.h       |    2 -
 include/linux/libata.h    |    2 +
 include/scsi/scsi_host.h  |    8 ++++
 40 files changed, 375 insertions(+), 297 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.scsi/58925
