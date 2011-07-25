Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab1GYGFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 02:05:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1GYGFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 02:05:03 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: menage@google.com, lizf@cn.fujitsu.com, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] cgroup:be able to remove the record of unplugged device
Date: Mon, 25 Jul 2011 14:03:54 +0800
Message-Id: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-25 14:04:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-25 14:04:02,
	Serialize complete at 2011-07-25 14:04:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If doing like below:
Write a record like:
"echo 8:0 1000 > blkio.throttle.read_bps_device" to control the bps of the device.
And then unplug this device without doing
"8:0 0 > blkio.throttle.read_bps_device" to remove the record,
it will not be removed until reboot, because if the device is removed,
write some record will return "-ENODEV".

With this patch, when the device is removed, then if we want to remove
the record for this removed device, just write "0" then it'll not check
if it is a present device, just remove the present record.

BTW:If it can support hot-plug, will it be more better?

Thanks

Below is my test:
1. Test native:
[root@test ~]# mount -t cgroup -o blkio nodev /cgroup/
[root@test ~]# cd /cgroup/
[root@test cgroup]# ll /dev/sd*
brw-rw---- 1 root disk 8, 0 Jul 25 13:27 /dev/sda
brw-rw---- 1 root disk 8, 1 Jul 25 13:27 /dev/sda1
[root@test cgroup]# cat blkio.throttle.read_bps_device
[root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	1000
[root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
[root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	1000
[root@test cgroup]# ll /dev/sd*
ls: cannot access /dev/sd*: No such file or directory
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	1000
[root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
-bash: echo: write error: No such device
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	1000

2.Test with this patch:

[root@test ~]# mount -t cgroup -o blkio nodev /cgroup/
[root@test ~]# ll /dev/sd*
brw-rw---- 1 root disk 8, 0 Jul 25 13:11 /dev/sda
brw-rw---- 1 root disk 8, 1 Jul 25 13:11 /dev/sda1
[root@test ~]# cd /cgroup/
[root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	1000
[root@test cgroup]# ll /dev/sd*
brw-rw---- 1 root disk 8, 0 Jul 25 13:11 /dev/sda
brw-rw---- 1 root disk 8, 1 Jul 25 13:11 /dev/sda1
[root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
[root@test cgroup]# ll /dev/sd*
brw-rw---- 1 root disk 8, 0 Jul 25 13:11 /dev/sda
brw-rw---- 1 root disk 8, 1 Jul 25 13:11 /dev/sda1
[root@test cgroup]# echo 8:0 2000 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	2000

[root@test cgroup]# ll /dev/sd*
ls: cannot access /dev/sd*: No such file or directory
[root@test cgroup]# cat blkio.throttle.read_bps_device
8:0	2000
[root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
[root@test cgroup]# cat blkio.throttle.read_bps_device
[root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
-bash: echo: write error: No such device
[root@test cgroup]# echo 8:0 01100 > blkio.throttle.read_bps_device
-bash: echo: write error: No such device
[root@test cgroup]#

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 block/blk-cgroup.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..ea32b01 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -826,15 +826,15 @@ static int blkio_policy_parse_and_set(char *buf,
 
 	dev = MKDEV(major, minor);
 
+	if (s[1] == NULL)
+		return -EINVAL;
+
 	ret = blkio_check_dev_num(dev);
-	if (ret)
+	if (ret && (strcmp(s[1], "0\0")))
 		return ret;
 
 	newpn->dev = dev;
 
-	if (s[1] == NULL)
-		return -EINVAL;
-
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
 		ret = strict_strtoul(s[1], 10, &temp);
-- 
1.7.6

