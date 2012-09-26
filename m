Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2IZIxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:53:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab2IZIwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:04 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/27] GFS2: Get rid of I_MUTEX_QUOTA usage
Date: Wed, 26 Sep 2012 09:25:44 +0100
Message-Id: <1348647948-3219-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

GFS2 uses i_mutex on its system quota inode to synchronize writes to
quota file. Since this is an internal inode to GFS2 (not part of directory
hiearchy or visible by user) we are safe to define locking rules for it. So
let's just get it its own locking class to make it clear.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e5af9dc..e443966 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/quotaops.h>
+#include <linux/lockdep.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -766,6 +767,7 @@ fail:
 	return error;
 }
 
+static struct lock_class_key gfs2_quota_imutex_key;
 
 static int init_inodes(struct gfs2_sbd *sdp, int undo)
 {
@@ -803,6 +805,12 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 		fs_err(sdp, "can't get quota file inode: %d\n", error);
 		goto fail_rindex;
 	}
+	/*
+	 * i_mutex on quota files is special. Since this inode is hidden system
+	 * file, we are safe to define locking ourselves.
+	 */
+	lockdep_set_class(&sdp->sd_quota_inode->i_mutex,
+			  &gfs2_quota_imutex_key);
 
 	error = gfs2_rindex_update(sdp);
 	if (error)
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 420bc38..4021dec 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -782,7 +782,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 		return -ENOMEM;
 
 	sort(qda, num_qd, sizeof(struct gfs2_quota_data *), sort_qd, NULL);
-	mutex_lock_nested(&ip->i_inode.i_mutex, I_MUTEX_QUOTA);
+	mutex_lock(&ip->i_inode.i_mutex);
 	for (qx = 0; qx < num_qd; qx++) {
 		error = gfs2_glock_nq_init(qda[qx]->qd_gl, LM_ST_EXCLUSIVE,
 					   GL_NOCACHE, &ghs[qx]);
-- 
1.7.4

