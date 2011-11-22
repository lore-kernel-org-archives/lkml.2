Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1KVD4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:56:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:63080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1KVD4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:56:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,551,1315206000"; 
   d="scan'208";a="77810085"
Date: Tue, 22 Nov 2011 11:56:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [3.2-rc2] loop device balance_dirty_pages_nr throttling hang
Message-ID: <20111122035629.GE20982@localhost>
References: <20111121142056.GF2386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121142056.GF2386@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Nov 21, 2011 at 10:20:56PM +0800, Dave Chinner wrote:
> Hi Fengguang,
> 
> I just found a way of hanging a system and taking it down. I haven't
> tried to narrow down the test case - it's pretty simple - because it
> time for sleep here.

Yeah, once the global dirty limit is exceeded, the system would appear
hang because many applications will block in balance_dirty_pages().

I created a script for this case, however cannot reproduce it..

The test box has 32GB memory and 110GB /dev/sda7, so I lowered
the dirty_bytes=400MB and xfs "-b size=10g" explicitly in the script.

During the test run on 3.2.0-rc1, I find the dirty pages rarely exceed
the background dirty threshold (200MB).

Would you try run this and see if this it's a problem of the test script?

root@snb /home/wfg# cat ./test-loop-fallocate.sh
#!/bin/sh

# !!!change and uncomment this before run!!!
# DEV=/dev/sda7

echo 1 > /debug/tracing/events/writeback/balance_dirty_pages/enable
echo 1 > /debug/tracing/events/writeback/global_dirty_state/enable

echo $((400<<20)) > /proc/sys/vm/dirty_bytes
mkfs.xfs -f -d size=10g $DEV
mount $DEV /mnt/scratch
xfs_io -f -c "truncate 20T" /mnt/scratch/scratch.img
losetup /dev/loop0 /mnt/scratch/scratch.img
mkfs.ext4 /dev/loop0
mkdir /mnt/scratch/scratch
mount /dev/loop0 /mnt/scratch/scratch
time xfs_io -f -F -c "truncate 15T " -c "falloc 0 15T" /mnt/scratch/scratch/foo
umount /mnt/scratch/scratch
losetup -d /dev/loop0
umount /mnt/scratch

root@snb /home/wfg# ./test-loop-fallocate.sh
meta-data=/dev/sda7              isize=256    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mke2fs 1.42-WIP (16-Oct-2011)
Discarding device blocks: done
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
335544320 inodes, 5368709120 blocks
268435456 blocks (5.00%) reserved for the super user
First data block=0
163840 block groups
32768 blocks per group, 32768 fragments per group
2048 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
        2560000000, 3855122432

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done


real    0m38.323s
user    0m0.000s
sys     0m25.203s

Thanks,
Fengguang
