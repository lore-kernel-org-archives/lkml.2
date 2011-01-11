Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1AKMOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:14:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41169 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab1AKMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:14:39 -0500
To: linux-fsdevel@vger.kernel.org
CC: npiggin@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fuse: make fuse_permission() RCU aware
Message-Id: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Jan 2011 13:14:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Only bail out of fuse_permission() on IPERM_FLAG_RCU when it is
actually necessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2011-01-11 11:30:03.000000000 +0100
+++ linux-2.6/fs/fuse/dir.c	2011-01-11 12:38:59.000000000 +0100
@@ -971,6 +971,14 @@ static int fuse_access(struct inode *ino
 	return err;
 }
 
+static int fuse_perm_getattr(struct inode *inode, int flags)
+{
+	if (flags & IPERM_FLAG_RCU)
+		return -ECHILD;
+
+	return fuse_do_getattr(inode, NULL, NULL);
+}
+
 /*
  * Check permission.  The two basic access models of FUSE are:
  *
@@ -990,9 +998,6 @@ static int fuse_permission(struct inode
 	bool refreshed = false;
 	int err = 0;
 
-	if (flags & IPERM_FLAG_RCU)
-		return -ECHILD;
-
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
@@ -1001,9 +1006,15 @@ static int fuse_permission(struct inode
 	 */
 	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
-		err = fuse_update_attributes(inode, NULL, NULL, &refreshed);
-		if (err)
-			return err;
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		if (fi->i_time < get_jiffies_64()) {
+			refreshed = true;
+
+			err = fuse_perm_getattr(inode, flags);
+			if (err)
+				return err;
+		}
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
@@ -1013,7 +1024,7 @@ static int fuse_permission(struct inode
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
 		if (err == -EACCES && !refreshed) {
-			err = fuse_do_getattr(inode, NULL, NULL);
+			err = fuse_perm_getattr(inode, flags);
 			if (!err)
 				err = generic_permission(inode, mask,
 							flags, NULL);
@@ -1024,13 +1035,16 @@ static int fuse_permission(struct inode
 		   noticed immediately, only after the attribute
 		   timeout has expired */
 	} else if (mask & (MAY_ACCESS | MAY_CHDIR)) {
+		if (flags & IPERM_FLAG_RCU)
+			return -ECHILD;
+
 		err = fuse_access(inode, mask);
 	} else if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
 		if (!(inode->i_mode & S_IXUGO)) {
 			if (refreshed)
 				return -EACCES;
 
-			err = fuse_do_getattr(inode, NULL, NULL);
+			err = fuse_perm_getattr(inode, flags);
 			if (!err && !(inode->i_mode & S_IXUGO))
 				return -EACCES;
 		}
