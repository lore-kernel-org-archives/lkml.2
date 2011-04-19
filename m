Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1DSJDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1DSJCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:02:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Don't try to deallocate unlinked inodes when mounted ro
Date: Tue, 19 Apr 2011 09:40:08 +0100
Message-Id: <1303202409-3317-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
References: <1303202409-3317-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a couple of missing tests to avoid read-only nodes
from attempting to deallocate unlinked inodes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Michel Andre de la Porte <madelaporte@ubi.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 3754e3c..25eeb2b 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -385,6 +385,10 @@ static int trans_go_demote_ok(const struct gfs2_glock *gl)
 static void iopen_go_callback(struct gfs2_glock *gl)
 {
 	struct gfs2_inode *ip = (struct gfs2_inode *)gl->gl_object;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+
+	if (sdp->sd_vfs->s_flags & MS_RDONLY)
+		return;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
 	    gl->gl_state == LM_ST_SHARED && ip) {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index a4e23d6..5b2cb81 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1318,12 +1318,13 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 
 static void gfs2_evict_inode(struct inode *inode)
 {
-	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
+	struct super_block *sb = inode->i_sb;
+	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder gh;
 	int error;
 
-	if (inode->i_nlink)
+	if (inode->i_nlink || (sb->s_flags & MS_RDONLY))
 		goto out;
 
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-- 
1.7.4

