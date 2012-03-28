Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab2C1Wzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:55:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975Ab2C1Wvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:51:51 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/21] blkcg: blkg_conf_prep()
Date: Wed, 28 Mar 2012 15:51:18 -0700
Message-Id: <1332975091-10950-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkg_conf_prep() implements "MAJ:MIN VAL" parsing manually, which is
unnecessary.  Just use sscanf("%u:%u %llu").  This might not reject
some malformed input (extra input at the end) but we don't care.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c |   64 ++++++++-------------------------------------------
 1 files changed, 10 insertions(+), 54 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0d4f21e..3d933b0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -987,57 +987,16 @@ static int blkg_conf_prep(struct blkio_cgroup *blkcg, const char *input,
 {
 	struct gendisk *disk;
 	struct blkio_group *blkg;
-	char *buf, *s[4], *p, *major_s, *minor_s;
-	unsigned long major, minor;
-	int i = 0, ret = -EINVAL;
-	int part;
-	dev_t dev;
-	u64 temp;
+	unsigned int major, minor;
+	unsigned long long v;
+	int part, ret;
 
-	buf = kstrdup(input, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	memset(s, 0, sizeof(s));
-
-	while ((p = strsep(&buf, " ")) != NULL) {
-		if (!*p)
-			continue;
-
-		s[i++] = p;
-
-		/* Prevent from inputing too many things */
-		if (i == 3)
-			break;
-	}
-
-	if (i != 2)
-		goto out;
-
-	p = strsep(&s[0], ":");
-	if (p != NULL)
-		major_s = p;
-	else
-		goto out;
-
-	minor_s = s[0];
-	if (!minor_s)
-		goto out;
-
-	if (strict_strtoul(major_s, 10, &major))
-		goto out;
-
-	if (strict_strtoul(minor_s, 10, &minor))
-		goto out;
-
-	dev = MKDEV(major, minor);
-
-	if (strict_strtoull(s[1], 10, &temp))
-		goto out;
+	if (sscanf(input, "%u:%u %llu", &major, &minor, &v) != 3)
+		return -EINVAL;
 
-	disk = get_gendisk(dev, &part);
+	disk = get_gendisk(MKDEV(major, minor), &part);
 	if (!disk || part)
-		goto out;
+		return -EINVAL;
 
 	rcu_read_lock();
 
@@ -1059,16 +1018,13 @@ static int blkg_conf_prep(struct blkio_cgroup *blkcg, const char *input,
 			msleep(10);
 			ret = restart_syscall();
 		}
-		goto out;
+		return ret;
 	}
 
 	ctx->disk = disk;
 	ctx->blkg = blkg;
-	ctx->v = temp;
-	ret = 0;
-out:
-	kfree(buf);
-	return ret;
+	ctx->v = v;
+	return 0;
 }
 
 /**
-- 
1.7.7.3

