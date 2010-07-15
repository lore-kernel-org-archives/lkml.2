Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab0GOOTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336Ab0GOOTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:19:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/5] GFS2: Fix kernel NULL pointer dereference by dlm_astd
Date: Thu, 15 Jul 2010 14:57:52 +0100
Message-Id: <1279202274-4418-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
References: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a problem in an error path when looking
up dinodes.  There are two sister-functions, gfs2_inode_lookup
and gfs2_process_unlinked_inode.  Both functions acquire and
hold the i_iopen glock for the dinode being looked up. The last
thing they try to do is hold the i_gl glock for the dinode.
If that glock fails for some reason, the error path was
incorrectly calling gfs2_glock_put for the i_iopen glock twice.
This resulted in the glock being prematurely freed.  The
"minimum hold time" usually kept the glock in memory, but the
lock interface to dlm (aka lock_dlm) freed its memory for the
glock.  In some circumstances, it would cause dlm's dlm_astd daemon
to try to call the bast function for the freed lock_dlm memory,
which resulted in a NULL pointer dereference.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index b5612cb..f03afd9 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -169,7 +169,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 {
 	struct inode *inode;
 	struct gfs2_inode *ip;
-	struct gfs2_glock *io_gl;
+	struct gfs2_glock *io_gl = NULL;
 	int error;
 
 	inode = gfs2_iget(sb, no_addr);
@@ -198,6 +198,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 		ip->i_iopen_gh.gh_gl->gl_object = ip;
 
 		gfs2_glock_put(io_gl);
+		io_gl = NULL;
 
 		if ((type == DT_UNKNOWN) && (no_formal_ino == 0))
 			goto gfs2_nfsbypass;
@@ -228,7 +229,8 @@ gfs2_nfsbypass:
 fail_glock:
 	gfs2_glock_dq(&ip->i_iopen_gh);
 fail_iopen:
-	gfs2_glock_put(io_gl);
+	if (io_gl)
+		gfs2_glock_put(io_gl);
 fail_put:
 	if (inode->i_state & I_NEW)
 		ip->i_gl->gl_object = NULL;
@@ -256,7 +258,7 @@ void gfs2_process_unlinked_inode(struct super_block *sb, u64 no_addr)
 {
 	struct gfs2_sbd *sdp;
 	struct gfs2_inode *ip;
-	struct gfs2_glock *io_gl;
+	struct gfs2_glock *io_gl = NULL;
 	int error;
 	struct gfs2_holder gh;
 	struct inode *inode;
@@ -293,6 +295,7 @@ void gfs2_process_unlinked_inode(struct super_block *sb, u64 no_addr)
 
 	ip->i_iopen_gh.gh_gl->gl_object = ip;
 	gfs2_glock_put(io_gl);
+	io_gl = NULL;
 
 	inode->i_mode = DT2IF(DT_UNKNOWN);
 
@@ -319,7 +322,8 @@ void gfs2_process_unlinked_inode(struct super_block *sb, u64 no_addr)
 fail_glock:
 	gfs2_glock_dq(&ip->i_iopen_gh);
 fail_iopen:
-	gfs2_glock_put(io_gl);
+	if (io_gl)
+		gfs2_glock_put(io_gl);
 fail_put:
 	ip->i_gl->gl_object = NULL;
 	gfs2_glock_put(ip->i_gl);
-- 
1.7.1.1

