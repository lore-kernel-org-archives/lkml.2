Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2LUWrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:47:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2LUWrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:47:00 -0500
Date: Fri, 21 Dec 2012 22:46:50 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: [git pull] 3.8 device-mapper updates
Message-ID: <20121221224649.GA3228@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.8-fixes
 
to get the following device-mapper updates:

----------------------------------------------------------------
Miscellaneous device-mapper fixes, cleanups and performance improvements.

Of particular note:
- Disable broken WRITE SAME support in all targets except linear and striped.
  Use it when kcopyd is zeroing blocks.
- Remove several mempools from targets by moving the data into the bio's new
  front_pad area(which dm calls 'per_bio_data').
- Fix a race in thin provisioning if discards are misused.
- Prevent userspace from interfering with the ioctl parameters and
  use kmalloc for the data buffer if it's small instead of vmalloc.
- Throttle some annoying error messages when I/O fails.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size

Joe Thornber (7):
      dm thin: replace dm_cell_release_singleton with cell_defer_except
      dm thin: fix race between simultaneous io and discards to same block
      dm thin: wake worker when discard is prepared
      dm persistent data: fix nested btree deletion
      dm thin: rename cell_defer_except to cell_defer_no_holder
      dm thin: cleanup dead code
      dm persistent data: improve improve space map block alloc failure message

Jonathan Brassow (1):
      dm raid: round region_size to power of two

Mike Snitzer (10):
      dm: disable WRITE SAME
      dm thin: emit ignore_discard in status when discards disabled
      dm block manager: reinstate message when validator fails
      dm persistent data: use DMERR_LIMIT for errors
      dm thin: use DMERR_LIMIT for errors
      dm: prepare to support WRITE SAME
      dm: add WRITE SAME support
      dm linear: add WRITE SAME support
      dm kcopyd: add WRITE SAME support to dm_kcopyd_zero
      dm stripe: add WRITE SAME support

Mikulas Patocka (17):
      dm persistent data: rename node to btree_node
      dm raid1: remove impossible mempool_alloc error test
      dm raid: use DM_ENDIO_INCOMPLETE
      dm snapshot: optimize track_chunk
      dm ioctl: remove PF_MEMALLOC
      dm ioctl: use kmalloc if possible
      dm: introduce per_bio_data
      dm raid1: use per_bio_data
      dm verity: use per_bio_data
      dm snapshot: use per_bio_data
      dm: move target request nr to dm_target_io
      dm raid1: rename read_record to bio_record
      dm flakey: dont use map_context
      dm raid1: dont use map_context
      dm thin: dont use map_context
      dm snapshot: do not use map_context
      dm: remove map_info

 drivers/md/dm-bio-prison.c                         |   25 ---
 drivers/md/dm-bio-prison.h                         |    1 -
 drivers/md/dm-crypt.c                              |    5 +-
 drivers/md/dm-delay.c                              |    5 +-
 drivers/md/dm-flakey.c                             |   21 +-
 drivers/md/dm-io.c                                 |   23 +-
 drivers/md/dm-ioctl.c                              |   64 ++++--
 drivers/md/dm-kcopyd.c                             |   18 +-
 drivers/md/dm-linear.c                             |    6 +-
 drivers/md/dm-raid.c                               |    8 +-
 drivers/md/dm-raid1.c                              |   75 ++-----
 drivers/md/dm-snap.c                               |   90 +++-----
 drivers/md/dm-stripe.c                             |   20 +-
 drivers/md/dm-table.c                              |   41 +++-
 drivers/md/dm-target.c                             |    5 +-
 drivers/md/dm-thin-metadata.c                      |    2 +-
 drivers/md/dm-thin.c                               |  234 ++++++++++----------
 drivers/md/dm-verity.c                             |   25 +--
 drivers/md/dm-zero.c                               |    5 +-
 drivers/md/dm.c                                    |   84 ++++---
 drivers/md/dm.h                                    |    2 +-
 drivers/md/persistent-data/dm-block-manager.c      |   12 +-
 drivers/md/persistent-data/dm-btree-internal.h     |   16 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   50 ++---
 drivers/md/persistent-data/dm-btree-spine.c        |   20 +-
 drivers/md/persistent-data/dm-btree.c              |   31 +--
 drivers/md/persistent-data/dm-space-map-common.c   |   16 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |    2 +-
 include/linux/device-mapper.h                      |   55 ++++-
 include/uapi/linux/dm-ioctl.h                      |    4 +-
 30 files changed, 522 insertions(+), 443 deletions(-)
