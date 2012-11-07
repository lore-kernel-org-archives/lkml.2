Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2KGKmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:42:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab2KGKmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:42:04 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Lukas Czerner <lczerner@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/7] GFS2: Fix FITRIM argument handling
Date: Wed,  7 Nov 2012 10:15:57 +0000
Message-Id: <1352283359-3314-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

Currently implementation in gfs2 uses FITRIM arguments as it were in
file system blocks units which is wrong. The FITRIM arguments
(fstrim_range.start, fstrim_range.len and fstrim_range.minlen) are
actually in bytes.

Moreover, check for start argument beyond the end of file system, len
argument being smaller than file system block and minlen argument being
bigger than biggest resource group were missing.

This commit converts the code to convert FITRIM argument to file system
blocks and also adds appropriate checks mentioned above.

All the problems were recognised by xfstests 251 and 260.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b6bbf71..38fe18f 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1262,7 +1262,9 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	int ret = 0;
 	u64 amt;
 	u64 trimmed = 0;
+	u64 start, end, minlen;
 	unsigned int x;
+	unsigned bs_shift = sdp->sd_sb.sb_bsize_shift;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1277,8 +1279,18 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	if (ret)
 		return ret;
 
-	rgd = gfs2_blk2rgrpd(sdp, r.start, 0);
-	rgd_end = gfs2_blk2rgrpd(sdp, r.start + r.len, 0);
+	start = r.start >> bs_shift;
+	end = start + (r.len >> bs_shift);
+	minlen = max_t(u64, r.minlen,
+		       q->limits.discard_granularity) >> bs_shift;
+
+	rgd = gfs2_blk2rgrpd(sdp, start, 0);
+	rgd_end = gfs2_blk2rgrpd(sdp, end - 1, 0);
+
+	if (end <= start ||
+	    minlen > sdp->sd_max_rg_data ||
+	    start > rgd_end->rd_data0 + rgd_end->rd_data)
+		return -EINVAL;
 
 	while (1) {
 
@@ -1290,7 +1302,9 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 			/* Trim each bitmap in the rgrp */
 			for (x = 0; x < rgd->rd_length; x++) {
 				struct gfs2_bitmap *bi = rgd->rd_bits + x;
-				ret = gfs2_rgrp_send_discards(sdp, rgd->rd_data0, NULL, bi, r.minlen, &amt);
+				ret = gfs2_rgrp_send_discards(sdp,
+						rgd->rd_data0, NULL, bi, minlen,
+						&amt);
 				if (ret) {
 					gfs2_glock_dq_uninit(&gh);
 					goto out;
-- 
1.7.4

