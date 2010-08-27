Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0H0RRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:17:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:41795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab0H0RRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:17:24 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: [PATCHSET 2.6.36-rc2] block, dm: finish REQ_FLUSH/FUA conversion
Date: Fri, 27 Aug 2010 19:10:56 +0200
Message-Id: <1282929060-23663-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 17:16:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset converts dm to REQ_FLUSH/FUA, which was the last
remaining one.  I've put patches on top of the previous patches for
easier review.  The series can be trivially reordered so that the
order is more logical.  Jens, please let me know if you want it to be
reordered.

The dm conversion is _lightly_ tested.  Please proceed with caution.
In particular, I haven't tested dm implementation at all.  So, it
probably is best to hold off merging these bits until dm people can
verify the conversion is correct.

 0001-block-make-__blk_rq_prep_clone-copy-most-command-fla.patch
 0002-dm-implement-REQ_FLUSH-FUA-support.patch
 0003-dm-relax-ordering-of-bio-based-flush-implementation.patch
 0004-block-remove-the-WRITE_BARRIER-flag.patch

Differences from the previous attempt[1] are,

* I was wrong when I wrote that flush retry logic was dropped.  What
  got dropped was -EOPNOTSUPP handling.  The retry behavior used by
  multipath remains the same.  As blindly retrying flushes could be
  dangerous, a FIXME comment is added.

* bio-based dm now also advertises REQ_FLUSH | REQ_FUA capability as
  block layer now filters out REQ_FLUSH if not supported by the queue.

* 0002-dm-implement-REQ_FLUSH-FUA-support.patch added to update
  __blk_rq_prep_clone() to copy most REQ_* flags including FLUSH and
  FUA and request-based dm now advertises REQ_FLUSH | REQ_FUA support.

* dm_request_fn() now explicitly plugs other requests while a flush
  request is in progress.  This is to avoid starving flush sequence
  which uses device draining to check whether each step is complete.

* 0003-block-remove-the-WRITE_BARRIER-flag.patch added to drop
  needless ordering around flush handling.

This patchset is on top of "block, fs: replace HARDBARRIER with
FLUSH/FUA" patchset[2] and available in the following git tree

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

and contains the following changes.

 block/blk-core.c                |    4 
 drivers/md/dm-crypt.c           |    2 
 drivers/md/dm-io.c              |   20 --
 drivers/md/dm-log.c             |    2 
 drivers/md/dm-raid1.c           |    8 -
 drivers/md/dm-region-hash.c     |   16 +-
 drivers/md/dm-snap-persistent.c |    2 
 drivers/md/dm-snap.c            |    6 
 drivers/md/dm-stripe.c          |    2 
 drivers/md/dm.c                 |  277 +++++++++++++++-------------------------
 include/linux/blk_types.h       |    1 
 include/linux/fs.h              |    3 
 12 files changed, 131 insertions(+), 212 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.raid/29100/focus=29104
[2] http://thread.gmane.org/gmane.linux.kernel/1022363
