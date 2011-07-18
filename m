Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1GRSyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:54:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55056 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1GRSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B3A1D.2050400@fusionio.com>
References: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com>
	<4E1B37B1.9030608@fusionio.com>
	<CAFR8ueetLzSwTEc7D1zW4Yhd8t8iFbKvjJ07onWVQJbhzSOXLQ@mail.gmail.com>
	<4E1B3A1D.2050400@fusionio.com>
Date: Mon, 18 Jul 2011 11:54:05 -0700
Message-ID: <CAFR8ued8s_V0dqxgcFfeXbzm8VrNL5eE90gqHpk-RvW8frL7QA@mail.gmail.com>
Subject: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
 bio_add can make use of it.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,
Here is the diff stats. Its changing more files than I expected. Let
me know what you think... (If this is OK I can also split and send the
patches for review).

FYI:
muthu@sakthi linux-2.6-head]$ wc -l blk-bio-init-rw-before-add-page.patch
1610 blk-bio-init-rw-before-add-page.patch

---------------------------
 block/blk-core.c                    |    2 +-
 block/blk-flush.c                   |    2 +-
 block/blk-lib.c                     |    4 +-
 block/blk-map.c                     |   12 ++++-----
 drivers/block/drbd/drbd_actlog.c    |    3 +-
 drivers/block/drbd/drbd_bitmap.c    |    3 +-
 drivers/block/drbd/drbd_receiver.c  |    3 +-
 drivers/block/floppy.c              |    2 +-
 drivers/block/loop.c                |    2 +-
 drivers/block/osdblk.c              |    2 +-
 drivers/block/pktcdvd.c             |   15 +++++------
 drivers/block/virtio_blk.c          |    2 +-
 drivers/block/xen-blkback/blkback.c |    4 +-
 drivers/md/dm-crypt.c               |    5 +--
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm.c                     |   10 +++-----
 drivers/md/md.c                     |   17 +++++++------
 drivers/md/md.h                     |    2 +-
 drivers/md/raid1.c                  |    7 +++++-
 drivers/md/raid10.c                 |    7 +++++-
 drivers/md/raid5.c                  |    2 +-
 drivers/scsi/osd/osd_initiator.c    |   21 ++++++----------
 drivers/target/target_core_iblock.c |    3 +-
 fs/bio.c                            |   43 ++++++++++++++++++-----------------
 fs/btrfs/compression.c              |   12 +++++-----
 fs/btrfs/extent_io.c                |    8 +++---
 fs/btrfs/extent_io.h                |    2 +-
 fs/btrfs/inode.c                    |   21 +++++++++--------
 fs/btrfs/scrub.c                    |    4 +-
 fs/buffer.c                         |    2 +-
 fs/direct-io.c                      |   12 +++++-----
 fs/exofs/ios.c                      |    6 +++-
 fs/ext4/page-io.c                   |    6 +++-
 fs/gfs2/ops_fstype.c                |    6 +++-
 fs/hfsplus/wrapper.c                |    2 +-
 fs/jfs/jfs_logmgr.c                 |   12 ++++++---
 fs/jfs/jfs_metapage.c               |    4 +-
 fs/logfs/dev_bdev.c                 |   10 ++++----
 fs/mpage.c                          |   11 +++++----
 fs/nfs/objlayout/objio_osd.c        |    8 +++---
 fs/nilfs2/segbuf.c                  |    9 ++++---
 fs/ocfs2/cluster/heartbeat.c        |    9 ++++---
 fs/xfs/linux-2.6/xfs_aops.c         |    8 ++++--
 fs/xfs/linux-2.6/xfs_buf.c          |    2 +-
 include/linux/bio.h                 |   10 ++++----
 kernel/power/block_io.c             |    2 +-
 mm/bounce.c                         |    2 +-
 mm/page_io.c                        |   14 ++++++-----
 48 files changed, 187 insertions(+), 170 deletions(-)
-----------------------------------


On Mon, Jul 11, 2011 at 10:59 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-07-11 19:52, Muthu Kumar wrote:
>>> For this particular case, doing it when the bio is allocated makes more
>>> sense. That will avoid a similar error in there in the future.
>>>
>>
>> Sounds good. Thanks. How about for other cases that alloc a new bio
>> and do bio_add_page() - like blkdev_issue_zeroout() and similar.
>> Should we add there too?
>
> Good question, ideally the allocator should be passed in the rw argument
> since we need it before even submitting it for the merge cases. We don't
> have _that_ many callers of bio_alloc() or bio_kmalloc(), so probably
> the best option is just to bite the bullet and change the prototypes to
> take the 'rw' argument there. Oh, and the bioset variants, too.
> bio_init() should be passed the 'rw' argument from the allcators, so we
> catch any private use of that, too.
>
> --
> Jens Axboe
>
>
