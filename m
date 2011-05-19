Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab1ESJKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab1ESJKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/32] GFS2: Don't use gfs2_change_nlink in link syscall
Date: Thu, 19 May 2011 09:47:15 +0100
Message-Id: <1305794847-3291-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three users of gfs2_change_nlink which add to the link
count. Two of these are about to be removed in later patches, so
this means that there will no callers, when that happens allowing
removal of that function, also in a later patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1005f9e..acb6f69 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -145,6 +145,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	struct inode *inode = old_dentry->d_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder ghs[2];
+	struct buffer_head *dibh;
 	int alloc_required;
 	int error;
 
@@ -230,12 +231,22 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 			goto out_ipres;
 	}
 
-	error = gfs2_dir_add(dir, &dentry->d_name, ip, IF2DT(inode->i_mode));
+	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
 		goto out_end_trans;
 
-	error = gfs2_change_nlink(ip, +1);
+	error = gfs2_dir_add(dir, &dentry->d_name, ip, IF2DT(inode->i_mode));
+	if (error)
+		goto out_brelse;
+
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	inc_nlink(&ip->i_inode);
+	ip->i_inode.i_ctime = CURRENT_TIME;
+	gfs2_dinode_out(ip, dibh->b_data);
+	mark_inode_dirty(&ip->i_inode);
 
+out_brelse:
+	brelse(dibh);
 out_end_trans:
 	gfs2_trans_end(sdp);
 out_ipres:
-- 
1.7.4

