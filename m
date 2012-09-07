Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2IGW7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:59:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65402 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2IGW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:59:34 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk
Subject: [PATCH 0/9] Prep work for immutable bio vecs
Date: Fri,  7 Sep 2012 15:59:11 -0700
Message-Id: <1347058760-30794-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random assortment of refactoring and trivial cleanups.

Immutable bio vecs and efficient bio splitting require auditing and removing
pretty much all bi_idx uses, among other things.

The reason is that with immutable bio vecs we can't use the bvec array
directly; if we have a partially completed bvec, that'll be indicated with a
field in struct bvec_iter (which gets embedded in struct bio) - bi_bvec_done.

bio_for_each_segments() will handle this transparently, so code needs to be
converted to use it or some other generic accessor.

Also, bio splitting means that when a driver gets a bio, bi_idx and
bi_bvec_done may both be nonzero. Again, just need to use generic accessors.

Kent Overstreet (9):
  block: Convert integrity to bvec_alloc_bs(), and a bugfix
  block: Add bio_advance()
  block: Refactor blk_update_request()
  md: Convert md_trim_bio() to use bio_advance()
  block: Add bio_end()
  block: Use bio_sectors() more consistently
  block: Don't use bi_idx in bio_split() or require it to be 0
  block: Remove bi_idx references
  block: Remove some unnecessary bi_vcnt usage

 block/blk-core.c                         |  86 ++++-----------------
 block/cfq-iosched.c                      |   7 +-
 block/deadline-iosched.c                 |   2 +-
 drivers/block/aoe/aoeblk.c               |   2 +-
 drivers/block/aoe/aoecmd.c               |   2 +-
 drivers/block/brd.c                      |   3 +-
 drivers/block/drbd/drbd_req.c            |   8 +-
 drivers/block/floppy.c                   |   1 -
 drivers/block/pktcdvd.c                  |   8 +-
 drivers/block/ps3vram.c                  |   2 +-
 drivers/md/dm-raid1.c                    |   2 +-
 drivers/md/dm-stripe.c                   |   2 +-
 drivers/md/dm-verity.c                   |   4 +-
 drivers/md/faulty.c                      |   6 +-
 drivers/md/linear.c                      |   3 +-
 drivers/md/md.c                          |  19 ++---
 drivers/md/raid0.c                       |   9 +--
 drivers/md/raid1.c                       |  21 +++--
 drivers/md/raid10.c                      |  28 +++----
 drivers/md/raid5.c                       |  22 +++---
 drivers/message/fusion/mptsas.c          |   6 +-
 drivers/s390/block/dcssblk.c             |   3 +-
 drivers/scsi/libsas/sas_expander.c       |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  10 +--
 fs/bio-integrity.c                       | 128 ++++++++++---------------------
 fs/bio.c                                 |  48 +++++++++++-
 fs/btrfs/extent_io.c                     |   3 +-
 fs/buffer.c                              |   1 -
 fs/gfs2/lops.c                           |   2 +-
 fs/jfs/jfs_logmgr.c                      |   2 -
 fs/logfs/dev_bdev.c                      |   5 --
 include/linux/bio.h                      |   8 +-
 include/trace/events/block.h             |  10 +--
 mm/page_io.c                             |   1 -
 34 files changed, 192 insertions(+), 278 deletions(-)

-- 
1.7.12

