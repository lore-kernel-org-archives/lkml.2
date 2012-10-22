Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2JVWcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:32:48 -0400
Received: from condef004-v.nifty.com ([210.131.4.241]:36657 "EHLO
	condef004-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2JVWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:32:47 -0400
X-Nifty-SrcIP: [172.22.201.188]
Message-ID: <28086318.27561350944959337.herumi@nifty.com>
Date: Tue, 23 Oct 2012 07:29:19 +0900 (JST)
From: MITSUNARI Shigeo <herumi@nifty.com>
To: linux-fsdevel@vger.kernel.org
Subject: fs: page cache wrongly left invalidated after revalidate_disk
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

We found that bdev->bd_invalidated was left set once revalidate_disk() 
is called, which results in page cache flush every time that device 
is open. 

Specifically, we found this problem in MD block device.  Once we 
resize a MD device, mdadm --monitor periodically flush all page cache 
for that device every 60 or 1000 seconds when it opens the device. 

This bug lies since at least 3.2.0 till the latest kernel(3.6.2). 
Patch is attached. 

Anyone please review this?  Thanks in advance.

--
>From 4ea0538596b893fe1382c3593efce4514fc4af3a Mon Sep 17 00:00:00 2001

Signed-off-by: MITSUNARI Shigeo <herumi@nifty.com>
---
 fs/block_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38e721b..2577cf4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1047,6 +1047,7 @@ int revalidate_disk(struct gendisk *disk)

    mutex_lock(&bdev->bd_mutex);
    check_disk_size_change(disk, bdev);
+   bdev->bd_invalidated = 0;
    mutex_unlock(&bdev->bd_mutex);
    bdput(bdev);
    return ret;
--
1.7.9.5
--------------
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
--------------

