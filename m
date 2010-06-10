Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab0FJMiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:38:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab0FJMis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:38:48 -0400
Date: Thu, 10 Jun 2010 08:45:53 -0400
From: Josef Bacik <josef@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [RFC, PATCH 0/5] fsfreeze: fix sb vs bdev freeze/thaw b0rkage
Message-ID: <20100610124553.GB29772@dhcp231-156.rdu.redhat.com>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276154395-24766-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:19:49PM +1000, Dave Chinner wrote:
> The following series is for to address bugs in the emergency thawing code, as
> well as mismatcheѕ with freezing at the block layer and the superblock that
> break the freeze/thaw nesting order.
> 
> The first two patches fix the emergency thaw infinite loop reported by Jeff
> Merkey and the deadlock on sb->s_umount that the infinite loop hid. These may
> be stable kernel candidates.
> 
> The remainder of the patches address the bdev/sb mismatch and the fact that sb
> level freezing does not nest correctly. For all the places that the bdev
> interfaces are used, we need a superblock anyway so we may as well make
> freeze/thaw work only at the sb level. As such, this series moves all the
> nesting code to the sb from the bdev level and removes the
> freeze_bdev/thaw_bdev interfaces completely. It also converts the emergency
> thaw to work at the superblock level such that it will now thaw manually frozen
> filesystems.
> 
> A *big* outstanding problem still exists - freezing takes an active reference
> to the superblock, so unmounting an frozen filesystem has some nasty and
> unexpected side effects. The existing code results in an unmountable block
> device:
> 
> # mount /dev/vda /mnt/test
> # xfs_freeze -f /mnt/test
> # umount /mnt/test
> # grep test /proc/mounts
> # mkfs.xfs -f -l size=128m /dev/vda
> mkfs.xfs: /dev/vda contains a mounted filesystem
> Usage: mkfs.xfs
> ....
> # mount /dev/vda /mnt/test
> mount: /dev/vda already mounted or /mnt/test busy
> #
> 
> At this point I can't get access to /dev/vda and needs a reboot to
> get it and /mnt/test back.
> 
> This patch series results in the block device being mountable, but
> remains frozen across unmount/mount:
> 
> # mount /dev/vda /mnt/test
> # xfs_freeze -f /mnt/test
> # umount /mnt/test
> # grep test /proc/mounts
> # mkfs.xfs -f -l size=128m /dev/vda
> mkfs.xfs: /dev/vda contains a mounted filesystem
> Usage: mkfs.xfs
> ....
> # mount /dev/vda /mnt/test
> # touch /mnt/test/foo &
> [1] 2647
> #
> # xfs_freeze -u /mnt/test
> [1]+  Done                    sudo touch /mnt/test/foo
> # umount /mnt/test
> # mkfs.xfs -f -l size=128m /dev/vda
> meta-data=/dev/vda               isize=256    agcount=4, agsize=262144 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=1048576, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> #
> 
> This behaviour is only marginally better than the existing behaviour
> (at least you can release the references). However, I don't really
> like either option - we used to disallow umount on a frozen
> filesystems to avoid this problem.
> 
> So What is really supposed to happen when we unmount a frozen
> superblock? Should unmount return EBUSY?  Should it be automatically
> thawed so it doesn't affect block device behaviour after unmount?
> Something else?
>

My vote is for EBUSY, that way we don't get this weird unexpected behavior
thing.  Plus if dm is doing a snapshot or whatever, unfreezing the fs to let it
unmount in the middle of it doing its thing could be unfun.  Thanks,

Josef
