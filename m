Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0JAQUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0JAQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:20:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 2/3] blkio-throttle: limit max iops value to UINT_MAX
Date: Fri,  1 Oct 2010 12:20:28 -0400
Message-Id: <1285950029-30205-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
References: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Limit max iops value to UINT_MAX and return error to user if value is more
  than that instead of accepting bigger values and truncating implicitly.
---
 block/blk-cgroup.c |   11 +++++++----
 block/blk-cgroup.h |    3 +++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e863418..b1febd0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -656,10 +656,10 @@ static int blkio_policy_parse_and_set(char *buf,
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp, iops;
+	unsigned long major, minor, temp;
 	int i = 0;
 	dev_t dev;
-	u64 bps;
+	u64 bps, iops;
 
 	memset(s, 0, sizeof(s));
 
@@ -731,13 +731,16 @@ static int blkio_policy_parse_and_set(char *buf,
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			ret = strict_strtoul(s[1], 10, &iops);
+			ret = strict_strtoull(s[1], 10, &iops);
 			if (ret)
 				return -EINVAL;
 
+			if (iops > THROTL_IOPS_MAX)
+				return -EINVAL;
+
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.iops = iops;
+			newpn->val.iops = (unsigned int)iops;
 			break;
 		}
 		break;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 034c355..ea4861b 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -20,6 +20,9 @@ enum blkio_policy_id {
 	BLKIO_POLICY_THROTL,		/* Throttling */
 };
 
+/* Max limits for throttle policy */
+#define THROTL_IOPS_MAX		UINT_MAX
+
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
 
 #ifndef CONFIG_BLK_CGROUP
-- 
1.7.2.3

