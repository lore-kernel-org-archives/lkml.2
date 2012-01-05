Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2AEMQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:16:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab2AEMQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:35 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/16] GFS2: We only need one ACL getting function
Date: Thu,  5 Jan 2012 11:52:01 +0000
Message-Id: <1325764322-10807-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have two versions of this function with
slightly different arguments.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 65978d7..230eb0f 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -38,8 +38,9 @@ static const char *gfs2_acl_name(int type)
 	return NULL;
 }
 
-static struct posix_acl *gfs2_acl_get(struct gfs2_inode *ip, int type)
+struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
 	struct posix_acl *acl;
 	const char *name;
 	char *data;
@@ -67,11 +68,6 @@ static struct posix_acl *gfs2_acl_get(struct gfs2_inode *ip, int type)
 	return acl;
 }
 
-struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
-{
-	return gfs2_acl_get(GFS2_I(inode), type);
-}
-
 static int gfs2_set_mode(struct inode *inode, umode_t mode)
 {
 	int error = 0;
@@ -125,7 +121,7 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct inode *inode)
 	if (S_ISLNK(inode->i_mode))
 		return 0;
 
-	acl = gfs2_acl_get(dip, ACL_TYPE_DEFAULT);
+	acl = gfs2_get_acl(&dip->i_inode, ACL_TYPE_DEFAULT);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (!acl) {
@@ -166,7 +162,7 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 	unsigned int len;
 	int error;
 
-	acl = gfs2_acl_get(ip, ACL_TYPE_ACCESS);
+	acl = gfs2_get_acl(&ip->i_inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (!acl)
@@ -216,7 +212,7 @@ static int gfs2_xattr_system_get(struct dentry *dentry, const char *name,
 	if (type < 0)
 		return type;
 
-	acl = gfs2_acl_get(GFS2_I(inode), type);
+	acl = gfs2_get_acl(inode, type);
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
 	if (acl == NULL)
-- 
1.7.4

