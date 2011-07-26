Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1GZAiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:38:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1GZAip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:38:45 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, lizf@cn.fujitsu.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Subject: [PATCH v2] cgroup:be able to remove the record of unplugged device
Date: Tue, 26 Jul 2011 08:37:26 +0800
Message-Id: <1311640646-12587-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 08:37:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 08:37:50,
	Serialize complete at 2011-07-26 08:37:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul:
How about this version?
Thanks

Write a record like:
echo 8:0 1000 > blkio.throttle.read_bps_device
to control the bps of the device.
And then unplug this device without doing
"8:0 0 > blkio.throttle.read_bps_device" to remove the record,
it will not be removed until reboot, because if the device is removed,
write some record will return "-ENODEV".

With this patch, when the device is removed, then if we want to remove
the record for this removed device, just write "0" then it'll not check
if it is a present device, just remove the present record.

Below is my test:
1. Test native.
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
 block/blk-cgroup.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..4e81170 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -826,19 +826,19 @@ static int blkio_policy_parse_and_set(char *buf,
 
 	dev = MKDEV(major, minor);
 
-	ret = blkio_check_dev_num(dev);
+	ret = strict_strtoul(s[1], 10, &temp);
 	if (ret)
+		return -EINVAL;
+
+	ret = blkio_check_dev_num(dev);
+	if (ret && (temp != 0))
 		return ret;
 
 	newpn->dev = dev;
 
-	if (s[1] == NULL)
-		return -EINVAL;
-
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+		if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
 			temp > BLKIO_WEIGHT_MAX)
 			return -EINVAL;
 
-- 
1.7.6

