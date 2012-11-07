Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2KGKmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:42:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab2KGKmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:42:03 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Lukas Czerner <lczerner@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/7] GFS2: Require user to provide argument for FITRIM
Date: Wed,  7 Nov 2012 10:15:56 +0000
Message-Id: <1352283359-3314-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
References: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

When the fstrim_range argument is not provided by user in FITRIM ioctl
we should just return EFAULT and not promoting bad behaviour by filling
the structure in kernel. Let the user deal with it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 43d1a20..b6bbf71 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1270,11 +1270,7 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-	if (argp == NULL) {
-		r.start = 0;
-		r.len = ULLONG_MAX;
-		r.minlen = 0;
-	} else if (copy_from_user(&r, argp, sizeof(r)))
+	if (copy_from_user(&r, argp, sizeof(r)))
 		return -EFAULT;
 
 	ret = gfs2_rindex_update(sdp);
@@ -1323,7 +1319,7 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 
 out:
 	r.len = trimmed << 9;
-	if (argp && copy_to_user(argp, &r, sizeof(r)))
+	if (copy_to_user(argp, &r, sizeof(r)))
 		return -EFAULT;
 
 	return ret;
-- 
1.7.4

