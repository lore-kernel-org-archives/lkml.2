Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2IXWfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:35:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43938 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2IXWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:35:30 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v3 00/26] Prep work for immutable bio vecs
Date: Mon, 24 Sep 2012 15:34:40 -0700
Message-Id: <1348526106-17074-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random assortment of refactoring and trivial cleanups;

Previous posting: http://thread.gmane.org/gmane.linux.kernel.bcache.devel/1055

No big changes since v2 - incorporated review feedback - mostly documentation,
did more testing, and fixed the deadlock Vivek noticed in my "convert integrity
to bvec_alloc_bs()" patch.

Patch series is on top of my patches for fixing a bio allocation deadlock with
stacked blocked devices, which is on top of Jens' tree.

Git tree is at:
http://evilpiepirate.org/git/linux-bcache.git block_stuff

v2: Patch series now has all the prep work to be done before abstracting
out the bio iterator, I think.

Kent Overstreet (26):
  block: Fix a buffer overrun in bio_integrity_split()
  block: Convert integrity to bvec_alloc_bs()
  block: Add bio_advance()
  block: Refactor blk_update_request()
  md: Convert md_trim_bio() to use bio_advance()
  block: Add bio_end_sector()
  block: Use bio_sectors() more consistently
  block: Change bio_split() to respect the current value of bi_idx
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
  block: Add an explicit bio flag for bios that own their bvec
  bio-integrity: Add explicit field for owner of bip_buf
  block: Add BIO_SUBMITTED flag, kill BIO_CLONED

 block/blk-core.c                         |  84 ++--------
 block/cfq-iosched.c                      |   7 +-
 block/deadline-iosched.c                 |   2 +-
 drivers/block/aoe/aoeblk.c               |   2 +-
 drivers/block/aoe/aoecmd.c               |   2 +-
 drivers/block/brd.c                      |   3 +-
 drivers/block/drbd/drbd_req.c            |   8 +-
 drivers/block/floppy.c                   |   1 -
 drivers/block/pktcdvd.c                  | 102 +++---------
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
 drivers/md/raid1.c                       | 133 +++++-----------
 drivers/md/raid10.c                      |  78 +++-------
 drivers/md/raid5.c                       |  49 +++---
 drivers/message/fusion/mptsas.c          |   6 +-
 drivers/s390/block/dcssblk.c             |   3 +-
 drivers/scsi/libsas/sas_expander.c       |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  10 +-
 fs/bio-integrity.c                       | 143 +++++++----------
 fs/bio.c                                 | 260 +++++++++++++++++++++++++------
 fs/btrfs/extent_io.c                     |   3 +-
 fs/buffer.c                              |   1 -
 fs/direct-io.c                           |   8 +-
 fs/exofs/ore.c                           |   2 +-
 fs/exofs/ore_raid.c                      |   2 +-
 fs/gfs2/lops.c                           |   2 +-
 fs/jfs/jfs_logmgr.c                      |   2 -
 fs/logfs/dev_bdev.c                      |   5 -
 include/linux/bio.h                      |  48 +++---
 include/linux/blk_types.h                |   3 +-
 include/trace/events/block.h             |  10 +-
 mm/bounce.c                              |  75 +++------
 mm/page_io.c                             |   1 -
 41 files changed, 499 insertions(+), 613 deletions(-)

-- 
1.7.12

