Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0H3KFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:05:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:59454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab0H3KFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:05:25 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: [PATCHSET 2.6.36-rc2] block, dm: finish REQ_FLUSH/FUA conversion, take#2
Date: Mon, 30 Aug 2010 11:58:11 +0200
Message-Id: <1283162296-13650-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 10:04:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of block-dm-finish-REQ_FLUSH-FUA-conversion.
I've put patches on top of the previous patches for easier review.
The series can be trivially reordered so that the order is more
logical.  Jens, please let me know if you want it to be reordered.

The dm conversion is _lightly_ tested.  Please proceed with caution.
Let's hold off merging these bits until dm people can verify the
conversion is correct.

  0001-block-make-__blk_rq_prep_clone-copy-most-command-fla.patch
  0002-dm-implement-REQ_FLUSH-FUA-support-for-bio-based-dm.patch
  0003-dm-relax-ordering-of-bio-based-flush-implementation.patch
  0004-dm-implement-REQ_FLUSH-FUA-support-for-request-based.patch
  0005-block-remove-the-WRITE_BARRIER-flag.patch

Differences from the previous attempt[1] are,

* bio-based dm and requested-based dm patches are split.  0002-0003
  convert bio-based dm and 0004 converts requested-based dm.

* The previous requested based dm conversion was broken in the way
  requests are sequenced.  This patch rips out special multi-target
  handling for flushes and handles flushes the same way other requests
  are handled.

This patchset is on top of "block, fs: replace HARDBARRIER with
FLUSH/FUA" patchset[2] and available in the following git tree

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

and contains the following changes.

 block/blk-core.c                |    4 
 drivers/md/dm-crypt.c           |    2 
 drivers/md/dm-io.c              |   20 --
 drivers/md/dm-log.c             |    2 
 drivers/md/dm-raid1.c           |    8 
 drivers/md/dm-region-hash.c     |   16 -
 drivers/md/dm-snap-persistent.c |    2 
 drivers/md/dm-snap.c            |    6 
 drivers/md/dm-stripe.c          |    2 
 drivers/md/dm.c                 |  394 ++++++++--------------------------------
 include/linux/blk_types.h       |    1 
 include/linux/fs.h              |    3 
 12 files changed, 104 insertions(+), 356 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.raid/29344
[2] http://thread.gmane.org/gmane.linux.kernel/1022363
