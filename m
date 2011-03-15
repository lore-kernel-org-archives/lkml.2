Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1COJeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1COJeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:03 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Nick Piggin <npiggin@gmail.com>
Subject: [PATCH 02/15] GFS2: Post-VFS scale update for RCU path walk
Date: Tue, 15 Mar 2011 09:11:32 +0000
Message-Id: <1300180305-5993-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can allow a few more cases to use RCU path walking than
originally allowed. It should be possible to also enable
RCU path walking when the glock is already cached. Thats
a bit more complicated though, so left for a future patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Nick Piggin <npiggin@gmail.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 7118f1a..cbc0715 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -80,8 +80,11 @@ int gfs2_check_acl(struct inode *inode, int mask, unsigned int flags)
 	struct posix_acl *acl;
 	int error;
 
-	if (flags & IPERM_FLAG_RCU)
-		return -ECHILD;
+	if (flags & IPERM_FLAG_RCU) {
+		if (!negative_cached_acl(inode, ACL_TYPE_ACCESS))
+			return -ECHILD;
+		return -EAGAIN;
+	}
 
 	acl = gfs2_acl_get(GFS2_I(inode), ACL_TYPE_ACCESS);
 	if (IS_ERR(acl))
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index d8b26ac..09e436a 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1026,9 +1026,9 @@ static void gfs2_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
 
 /**
  * gfs2_permission -
- * @inode:
- * @mask:
- * @nd: passed from Linux VFS, ignored by us
+ * @inode: The inode
+ * @mask: The mask to be tested
+ * @flags: Indicates whether this is an RCU path walk or not
  *
  * This may be called from the VFS directly, or from within GFS2 with the
  * inode locked, so we look to see if the glock is already locked and only
@@ -1044,11 +1044,11 @@ int gfs2_permission(struct inode *inode, int mask, unsigned int flags)
 	int error;
 	int unlock = 0;
 
-	if (flags & IPERM_FLAG_RCU)
-		return -ECHILD;
 
 	ip = GFS2_I(inode);
 	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
+		if (flags & IPERM_FLAG_RCU)
+			return -ECHILD;
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
 		if (error)
 			return error;
-- 
1.7.4

