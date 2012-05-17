Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778Ab2EQMs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761801Ab2EQMsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:52 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/24] GFS2: Fix sgid propagation when using ACLs
Date: Thu, 17 May 2012 13:23:25 +0100
Message-Id: <1337257411-3173-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the mode setting code when creating inodes. The
SGID bit was being reset by setattr_copy() when the user creating a
subdirectory was not in the owning group. When ACLs are in use this
SGID bit should have been propagated if the ACL allows creation of
a subdirectory. GFS2's behaviour now matches that of the other ACL
supporting filesystems in this regard.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 230eb0f..bd4a589 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -73,12 +73,8 @@ static int gfs2_set_mode(struct inode *inode, umode_t mode)
 	int error = 0;
 
 	if (mode != inode->i_mode) {
-		struct iattr iattr;
-
-		iattr.ia_valid = ATTR_MODE;
-		iattr.ia_mode = mode;
-
-		error = gfs2_setattr_simple(inode, &iattr);
+		inode->i_mode = mode;
+		mark_inode_dirty(inode);
 	}
 
 	return error;
@@ -126,9 +122,7 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct inode *inode)
 		return PTR_ERR(acl);
 	if (!acl) {
 		mode &= ~current_umask();
-		if (mode != inode->i_mode)
-			error = gfs2_set_mode(inode, mode);
-		return error;
+		return gfs2_set_mode(inode, mode);
 	}
 
 	if (S_ISDIR(inode->i_mode)) {
-- 
1.7.4

