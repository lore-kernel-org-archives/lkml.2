Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030941Ab2ERDAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:00:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43831 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030707Ab2ERDAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:06 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 00/13] Block cleanups (for bcache)
Date: Thu, 17 May 2012 22:59:47 -0400
Message-Id: <cover.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Couple related things in this patch series. This is mostly stuff I did for
bcache, polished/expanded up a bit:

 * Bio pool freeing. This moves freeing of bios allocated from bio pools into
   generic code.

 * Kill bi_destructor. That was Tejun's idea, but it turned out to be easier
   than I expected.

 * Improved bio splitting. This was originally part of bcache, but I pulled it
   out and replaced the existing bio splitting code with it.

 * Closures - this is from bcache. I didn't really need to use it for the next
   patch, but IMO it makes the code a bit more elegant.

 * Make generic_make_request() handle arbitrary size bios. I think this is
   going to enable a lot of cleanups in the future.

   The idea here isn't for generic_make_request() to be doing the splitting in
   practice long term, it's more just an intermediate stage. If this goes in, I
   think a lot of driver code - certainly a lot of virtual block drivers -
   could easily be made to handle arbitrary sized bios, and splitting will only
   happen when a bio is being redirected to two different devices or something
   like that. But this should enable a lot of cleanups without having to change
   every block driver first.

Kent Overstreet (13):
  block: Generalized bio pool freeing
  dm: kill dm_rq_bio_destructor
  block: Add bio_clone_bioset()
  block: Add bio_clone_kmalloc()
  block: Only clone bio vecs that are in use
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Add an explicit bio flag for bios that own their bvec
  block: Rework bio splitting
  Closures
  Make generic_make_request handle arbitrarily large bios
  Gut bio_add_page()

 Documentation/block/biodoc.txt      |    5 -
 block/blk-core.c                    |  119 +++++++-
 drivers/block/drbd/drbd_req.c       |   18 +-
 drivers/block/osdblk.c              |    3 +-
 drivers/block/pktcdvd.c             |  121 +++-----
 drivers/block/rbd.c                 |   12 +-
 drivers/md/dm-crypt.c               |    9 -
 drivers/md/dm-io.c                  |   11 -
 drivers/md/dm.c                     |   48 +--
 drivers/md/linear.c                 |    6 +-
 drivers/md/md.c                     |   42 +---
 drivers/md/raid0.c                  |    8 +-
 drivers/md/raid10.c                 |   23 +-
 drivers/target/target_core_iblock.c |    9 -
 fs/bio-integrity.c                  |   44 ---
 fs/bio.c                            |  407 ++++++++++++-----------
 fs/exofs/ore.c                      |    5 +-
 include/linux/bio.h                 |   37 ++-
 include/linux/blk_types.h           |    9 +-
 include/linux/blkdev.h              |    3 +
 include/linux/closure.h             |  614 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |    8 +
 lib/Makefile                        |    2 +-
 lib/closure.c                       |  363 +++++++++++++++++++++
 24 files changed, 1419 insertions(+), 507 deletions(-)
 create mode 100644 include/linux/closure.h
 create mode 100644 lib/closure.c

-- 
1.7.9.rc2

