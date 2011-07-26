Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1GZDCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 23:02:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1GZDCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 23:02:16 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v4] blk-cgroup:be able to remove the record of unplugged device
Date: Tue, 26 Jul 2011 11:00:58 +0800
Message-Id: <1311649258-24070-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <4E2E251D.6040108@cn.fujitsu.com>
References: <4E2E251D.6040108@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 11:01:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 11:01:10,
	Serialize complete at 2011-07-26 11:01:10
Cc: gaowanlong@cn.fujitsu.com, menage@google.com, vgoyal@redhat.com,
        axboe@kernel.dk, lizf@cn.fujitsu.com, wanlong.gao@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments of Paul and Li Zefan.

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

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 block/blk-cgroup.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..9825094 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -785,7 +785,7 @@ static int blkio_policy_parse_and_set(char *buf,
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp;
+	unsigned long major, minor, weight;
 	int i = 0;
 	dev_t dev;
 	u64 bps, iops;
@@ -826,25 +826,25 @@ static int blkio_policy_parse_and_set(char *buf,
 
 	dev = MKDEV(major, minor);
 
-	ret = blkio_check_dev_num(dev);
+	ret = strict_strtoul(s[1], 10, &weight);
 	if (ret)
+		return -EINVAL;
+
+	ret = blkio_check_dev_num(dev);
+	if (ret && !weight)
 		return ret;
 
 	newpn->dev = dev;
 
-	if (s[1] == NULL)
-		return -EINVAL;
-
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-			temp > BLKIO_WEIGHT_MAX)
+		if ((weight < BLKIO_WEIGHT_MIN && weight > 0) ||
+			weight > BLKIO_WEIGHT_MAX)
 			return -EINVAL;
 
 		newpn->plid = plid;
 		newpn->fileid = fileid;
-		newpn->val.weight = temp;
+		newpn->val.weight = weight;
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
-- 
1.7.6

