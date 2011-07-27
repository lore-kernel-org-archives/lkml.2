Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1G0ANc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:13:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1G0ANa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:13:30 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        lizf@cn.fujitsu.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        wanlong.gao@gmail.com
Subject: [PATCH v5] blk-cgroup:be able to remove the record of unplugged device
Date: Wed, 27 Jul 2011 08:11:48 +0800
Message-Id: <1311725508-4419-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20110726192441.GD13780@redhat.com>
References: <20110726192441.GD13780@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 08:12:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 08:12:29,
	Serialize complete at 2011-07-27 08:12:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is we're not able to remove the device from blkio cgroup's
per-device control files if it gets unplugged.

To reproduce the bug:

  # mount -t cgroup -o blkio xxx /cgroup
  # cd /cgroup
  # echo "8:0 1000" > blkio.throttle.read_bps_device
  # unplug the device
  # cat blkio.throttle.read_bps_device
  8:0	1000
  # echo "8:0 0" > blkio.throttle.read_bps_device
  -bash: echo: write error: No such device

After patching, the device removal will succeed.

Thanks for the comments of Paul, Zefan, and Vivek.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 block/blk-cgroup.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..b596e54 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -785,10 +785,10 @@ static int blkio_policy_parse_and_set(char *buf,
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp;
+	unsigned long major, minor;
 	int i = 0;
 	dev_t dev;
-	u64 bps, iops;
+	u64 temp;
 
 	memset(s, 0, sizeof(s));
 
@@ -826,20 +826,23 @@ static int blkio_policy_parse_and_set(char *buf,
 
 	dev = MKDEV(major, minor);
 
-	ret = blkio_check_dev_num(dev);
+	ret = strict_strtoull(s[1], 10, &temp);
 	if (ret)
-		return ret;
+		return -EINVAL;
 
-	newpn->dev = dev;
+	/* For rule removal, do not check for device presence. */
+	if (temp) {
+		ret = blkio_check_dev_num(dev);
+		if (ret)
+			return ret;
+	}
 
-	if (s[1] == NULL)
-		return -EINVAL;
+	newpn->dev = dev;
 
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-			temp > BLKIO_WEIGHT_MAX)
+		if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+		     temp > BLKIO_WEIGHT_MAX)
 			return -EINVAL;
 
 		newpn->plid = plid;
@@ -850,26 +853,18 @@ static int blkio_policy_parse_and_set(char *buf,
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			ret = strict_strtoull(s[1], 10, &bps);
-			if (ret)
-				return -EINVAL;
-
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.bps = bps;
+			newpn->val.bps = temp;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			ret = strict_strtoull(s[1], 10, &iops);
-			if (ret)
-				return -EINVAL;
-
-			if (iops > THROTL_IOPS_MAX)
+			if (temp > THROTL_IOPS_MAX)
 				return -EINVAL;
 
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.iops = (unsigned int)iops;
+			newpn->val.iops = (unsigned int)temp;
 			break;
 		}
 		break;
-- 
1.7.6

