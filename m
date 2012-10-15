Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2JOUSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:18:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2JOUK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:29 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 00/26] Prep work for immutable bio vecs
Date: Mon, 15 Oct 2012 13:09:03 -0700
Message-Id: <1350331769-14856-30-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random assortment of refactoring and trivial cleanups;

Immutable bio vecs and efficient bio splitting require auditing and
removing pretty much all bi_idx uses, among other things.

The reason is that with immutable bio vecs we can't use the bvec array
directly; if we have a partially completed bvec, that'll be indicated
with a field in struct bvec_iter (which gets embedded in struct bio) -
bi_bvec_done.

bio_for_each_segments() will handle this transparently, so code needs to
be converted to use it or some other generic accessor.

Also, bio splitting means that when a driver gets a bio, bi_idx and
bi_bvec_done may both be nonzero. Again, just need to use generic
accessors.

v2: Patch series now has all the prep work to be done before abstracting
out the bio iterator, I think.

Kent Overstreet (26):
  block: Convert integrity to bvec_alloc_bs(), and a bugfix
  block: Add bio_advance()
  block: Refactor blk_update_request()
  md: Convert md_trim_bio() to use bio_advance()
  block: Add bio_end()
  block: Use bio_sectors() more consistently
  block: Don't use bi_idx in bio_split() or require it to be 0
  block: Remove bi_idx references
  block: Remove some unnecessary bi_vcnt usage
  block: Add submit_bio_wait(), remove from md
  raid10: Use bio_reset()
  raid1: use bio_reset()
  raid5: use bio_reset()
  raid1: Refactor narrow_write_error() to not use bi_idx
  block: Add bio_copy_data()
  pktcdvd: use bio_copy_data()
  pktcdvd: Use bio_reset() in disabled code to kill bi_idx usage
  raid1: use bio_copy_data()
  bounce: Refactor __blk_queue_bounce to not use bi_io_vec
  block: Add bio_for_each_segment_all()
  block: Convert some code to bio_for_each_segment_all()
  block: Add bio_alloc_pages()
  raid1: use bio_alloc_pages()
  block: Add an explicit bio flag for bios that own their bvec
  bio-integrity: Add explicit field for owner of bip_buf
  block: Add BIO_SUBMITTED flag, kill BIO_CLONED

 block/blk-core.c                         |  88 +++---------
 block/cfq-iosched.c                      |   7 +-
 block/deadline-iosched.c                 |   2 +-
 drivers/block/aoe/aoeblk.c               |   2 +-
 drivers/block/aoe/aoecmd.c               |   2 +-
 drivers/block/brd.c                      |   3 +-
 drivers/block/drbd/drbd_req.c            |   8 +-
 drivers/block/floppy.c                   |   1 -
 drivers/block/pktcdvd.c                  | 102 ++++----------
 drivers/block/ps3vram.c                  |   2 +-
 drivers/md/dm-crypt.c                    |   3 +-
 drivers/md/dm-raid1.c                    |   2 +-
 drivers/md/dm-stripe.c                   |   2 +-
 drivers/md/dm-verity.c                   |   4 +-
 drivers/md/dm.c                          |   1 -
 drivers/md/faulty.c                      |   6 +-
 drivers/md/linear.c                      |   3 +-
 drivers/md/md.c                          |  19 +--
 drivers/md/raid0.c                       |   9 +-
 drivers/md/raid1.c                       | 131 ++++++------------
 drivers/md/raid10.c                      |  78 +++--------
 drivers/md/raid5.c                       |  50 +++----
 drivers/message/fusion/mptsas.c          |   6 +-
 drivers/s390/block/dcssblk.c             |   3 +-
 drivers/scsi/libsas/sas_expander.c       |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  10 +-
 fs/bio-integrity.c                       | 134 ++++++------------
 fs/bio.c                                 | 226 +++++++++++++++++++++++++++----
 fs/btrfs/extent_io.c                     |   3 +-
 fs/buffer.c                              |   1 -
 fs/direct-io.c                           |   8 +-
 fs/exofs/ore.c                           |   2 +-
 fs/exofs/ore_raid.c                      |   2 +-
 fs/gfs2/lops.c                           |   2 +-
 fs/jfs/jfs_logmgr.c                      |   2 -
 fs/logfs/dev_bdev.c                      |   5 -
 include/linux/bio.h                      |  34 +++--
 include/linux/blk_types.h                |   3 +-
 include/trace/events/block.h             |  10 +-
 mm/bounce.c                              |  75 +++-------
 mm/page_io.c                             |   1 -
 41 files changed, 471 insertions(+), 587 deletions(-)

-- 
1.7.12

