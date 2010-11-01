Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0KATti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:49:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab0KATth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:49:37 -0400
Date: Tue, 2 Nov 2010 06:49:18 +1100
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com,
        swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org,
        konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCHSET] block: clean up bdev claim/release handling
Message-ID: <20101102064918.4c6037d2@nbeee.brown>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Nov 2010 17:15:24 +0100
Tejun Heo <tj@kernel.org> wrote:

> bdev exclusive access handling is somewhat clumsy.  The primary
> interface is bd_claim() and bd_release() but there also are
> open_bdev_exclusive(), close_bdev_exclusive() and bd_claim_by_disk()
> and bd_release_from_disk().
> 
> Gaining exclusive access as a separate step from open itself also has
> the inherent problem that the block layer doesn't know whether the
> current open attempt is for an exclusive access or not.  The action of
> open itself may affect the existing exclusive access but there's no
> way to prevent it.
> 
> This patchset simplifies the claim/release handling by folding it into
> blkdev_get/put() and making others simple wrappers around them.  This
> simplifies code and removes strange corner cases like the
> non-atomicity of exclusive open described above.

He Tejun,
 This looks like a really nice clean-up!  Thanks.
Definitely
  Acked-by: NeilBrown <neilb@suse.de>
for the md parts.

Thanks,
NeilBrown


> 
> There are five patches in this series.
> 
>  0001-mtd-fix-bdev-exclusive-open-bugs-in-block2mtd-add_de.patch
>  0002-btrfs-close_bdev_exclusive-should-use-the-same-flags.patch
>  0003-block-simplify-holder-symlink-handling.patch
>  0004-block-make-blkdev_get-put-handle-exclusive-access.patch
>  0005-block-reorganize-claim-release-implementation.patch
> 
> 0001-0002 are fixes regarding exclusive bdev opens.  0003 simplifies
> holder/slave symlink handling.  0004 folds bdev claim/release into
> blkdev_get/put().  0005 reorganizes implementation a bit.
> 
> Cleaning up claim/release handling enables implementation of in-kernel
> disk event polling which be posted soon.  Although this patchset
> touches various files including drivers and filesystems, the changes
> there are mostly trivial and I think it would be best to route these
> through the block tree.
> 
> This patchset is on top of 2.6.37-rc1 and available in the following
> git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git
> cleanup-bd_claim
> 
> This patchset reduces about 400 lines of code.
> 
> Thanks.
> 
>  block/ioctl.c                   |    5 
>  drivers/block/drbd/drbd_int.h   |    2 
>  drivers/block/drbd/drbd_main.c  |    7 
>  drivers/block/drbd/drbd_nl.c    |  103 ++-----
>  drivers/block/pktcdvd.c         |   22 -
>  drivers/char/raw.c              |   14 
>  drivers/md/dm-table.c           |   20 -
>  drivers/md/md.c                 |   16 -
>  drivers/mtd/devices/block2mtd.c |   10 
>  drivers/s390/block/dasd_genhd.c |    2 
>  fs/block_dev.c                  |  576
> +++++++++-------------------------------
> fs/btrfs/volumes.c              |   14
> fs/ext3/super.c                 |   12
> fs/ext4/super.c                 |   12
> fs/gfs2/ops_fstype.c            |    4
> fs/jfs/jfs_logmgr.c             |   17 -
> fs/logfs/dev_bdev.c             |    4
> fs/nilfs2/super.c               |    4
> fs/ocfs2/cluster/heartbeat.c    |    2
> fs/partitions/check.c           |    2
> fs/reiserfs/journal.c           |   17 -
> fs/super.c                      |   14
> fs/xfs/linux-2.6/xfs_super.c    |    2
> include/linux/fs.h              |   22 -
> kernel/power/swap.c             |    5
> mm/swapfile.c                   |    7 26 files changed, 260
> insertions(+), 655 deletions(-)
> 
> --
> tejun

