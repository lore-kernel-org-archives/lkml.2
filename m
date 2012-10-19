Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2JSDZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:25:20 -0400
Received: from condef004-v.nifty.com ([210.131.4.241]:52318 "EHLO
	condef004-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab2JSDZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:25:08 -0400
X-Nifty-SrcIP: [61.204.25.121]
From: MITSUNARI Shigeo <herumi@nifty.com>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, MITSUNARI Shigeo <herumi@nifty.com>
Subject: [PATCH 0/2] bd_invalidated shoud be cleared in revalidate_disk
Date: Fri, 19 Oct 2012 12:16:40 +0900
Message-Id: <1350616602-6892-1-git-send-email-herumi@nifty.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescan_partitions() and invalidate_partitions() in block/partition-generic.c
set bdev->bd_invalidated = 0 after calling check_disk_size_change().
But revalidate_disk() in fs/block_dev.c does not clear it.

If bdev->bd_invalidated = 1 then rescan_partitions() is called when
__blkdev_get() is called.
So if revalidate_disk() is once called, all buffer cache pages will be
cleared whenever the device is opened.

This bug causes the following problem.

mdadm monitor will clear file cache every 1000 seconds
after mdadm resize is executed once.
mdadm monitor only openes the device with O_RDONLY.

We verified the problem occurred at kernel 3.6.2 and mdadm v3.2.5 on
ubuntu 12.04LTS x86_64 and the patch worked well.
--- 
The following steps will reproduce the problem.

1. prepair a block device(ex. /dev/sdb).
2. create two partitions.

sudo parted /dev/sdb
mklabel gpt
mkpart primary 0% 50%
mkpart primary 50% 100% 

3. create a md device.

sudo mdadm -C /dev/md/hoge -l 1 -n 2 -e 1.2 --assume-clean --auto=md \
 --symlink=no /dev/sdb1 /dev/sdb2

4. create file system and mount it

sudo mkfs.ext3 /dev/md/hoge
sudo mkdir /mnt/test
sudo mount /dev/md/hoge /mnt/test

5. try to resize the device

sudo mdadm -G /dev/md/hoge --size=max

6. create a file to fill file cache.

sudo dd if=/dev/urandom of=/mnt/test/data bs=1M count=10
and verity the current status of file by free command.

7. mdadm monitor will open the md device every 1000 seconds
and you will find all file cache on the device are cleared.

The timing can be reduced by the following steps.

a) kill mdadm and restart it with --delay option
/sbin/mdadm --monitor --delay=30 --pid-file /var/run/mdadm/monitor.pid \
 --daemonise --scan --syslog

or open the md device directly.

sudo dd if=/dev/md/hoge of=/dev/null bs=4096 count=1

MITSUNARI Shigeo (2):
  block: fs: bd_invalidated should be cleared in revalidate_disk
  block: fs: move 'bdev->bd_invalidated = 0' into
    check_disk_size_change() instead of putting the code every time
    after check_disk_size_change().

 block/partition-generic.c |    2 --
 fs/block_dev.c            |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
1.7.9.5

