Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1BEOVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1BEOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sLMutW5e3lhTLAV5OnclI0goaYyh+BIm2RuJeS7yJGQjBgLu+ISPr95x8nngTKRP2J
         kzGBumBHJYGvC7upDI3U+1ya2Y4DhRerGnOpBMUuZDFpvN1aIQGV/NNvS/W8THcwGR18
         S7BiAeWmwZRf03h2EfTW4XKajpnzxAFIV/pH0=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 05/52] kstrtox: convert block/
Date: Sat,  5 Feb 2011 16:20:08 +0200
Message-Id: <1296915654-7458-5-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 block/blk-cgroup.c |   47 ++++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 455768a..d94110e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -656,10 +656,9 @@ static int blkio_policy_parse_and_set(char *buf,
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp;
+	unsigned int major, minor;
 	int i = 0;
 	dev_t dev;
-	u64 bps, iops;
 
 	memset(s, 0, sizeof(s));
 
@@ -687,15 +686,15 @@ static int blkio_policy_parse_and_set(char *buf,
 	if (!minor_s)
 		return -EINVAL;
 
-	ret = strict_strtoul(major_s, 10, &major);
-	if (ret)
-		return -EINVAL;
-
-	ret = strict_strtoul(minor_s, 10, &minor);
+	ret = kstrtouint(major_s, 10, &major);
+	if (ret < 0)
+		return ret;
+	ret = kstrtouint(minor_s, 10, &minor);
 	if (ret)
-		return -EINVAL;
-
+		return ret;
 	dev = MKDEV(major, minor);
+	if (MAJOR(dev) != major || MINOR(dev) != minor)
+		return -EINVAL;
 
 	ret = blkio_check_dev_num(dev);
 	if (ret)
@@ -707,40 +706,42 @@ static int blkio_policy_parse_and_set(char *buf,
 		return -EINVAL;
 
 	switch (plid) {
+		unsigned int weigth;
+
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-			temp > BLKIO_WEIGHT_MAX)
+		ret = kstrtouint(s[1], 10, &weigth);
+		if (ret < 0)
+			return ret;
+		if (weigth < BLKIO_WEIGHT_MIN || weigth > BLKIO_WEIGHT_MAX)
 			return -EINVAL;
 
 		newpn->plid = plid;
 		newpn->fileid = fileid;
-		newpn->val.weight = temp;
+		newpn->val.weight = weigth;
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
+			unsigned int iops;
+
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			ret = strict_strtoull(s[1], 10, &bps);
-			if (ret)
-				return -EINVAL;
-
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.bps = bps;
+			ret = kstrtou64(s[1], 10, &newpn->val.bps);
+			if (ret < 0)
+				return ret;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			ret = strict_strtoull(s[1], 10, &iops);
-			if (ret)
-				return -EINVAL;
-
+			ret = kstrtouint(s[1], 10, &iops);
+			if (ret < 0)
+				return ret;
 			if (iops > THROTL_IOPS_MAX)
 				return -EINVAL;
 
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.iops = (unsigned int)iops;
+			newpn->val.iops = iops;
 			break;
 		}
 		break;
-- 
1.7.3.4

