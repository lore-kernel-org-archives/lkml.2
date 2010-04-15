Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab0DOXJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996Ab0DOXHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:37 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 32/35] union-mount: Implement union-aware truncate()
Date: Thu, 15 Apr 2010 16:04:39 -0700
Message-Id: <1271372682-21225-33-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-32-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
 <1271372682-21225-23-git-send-email-vaurora@redhat.com>
 <1271372682-21225-24-git-send-email-vaurora@redhat.com>
 <1271372682-21225-25-git-send-email-vaurora@redhat.com>
 <1271372682-21225-26-git-send-email-vaurora@redhat.com>
 <1271372682-21225-27-git-send-email-vaurora@redhat.com>
 <1271372682-21225-28-git-send-email-vaurora@redhat.com>
 <1271372682-21225-29-git-send-email-vaurora@redhat.com>
 <1271372682-21225-30-git-send-email-vaurora@redhat.com>
 <1271372682-21225-31-git-send-email-vaurora@redhat.com>
 <1271372682-21225-32-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/open.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 325852d..dda1b6f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -230,14 +230,17 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 static long do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
 	struct inode *inode;
+	char *tmp;
 	int error;
 
 	error = -EINVAL;
 	if (length < 0)	/* sorry, but loff_t says... */
 		goto out;
 
-	error = user_path(pathname, &path);
+	error = user_path_nd(AT_FDCWD, pathname, 0, &nd, &path, &tmp);
 	if (error)
 		goto out;
 	inode = path.dentry->d_inode;
@@ -251,11 +254,16 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = mnt_want_write(path.mnt);
+	if (IS_UNIONED_DIR(&nd.path))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
+	error = mnt_want_write(mnt);
 	if (error)
 		goto dput_and_out;
 
-	error = inode_permission(inode, MAY_WRITE);
+	error = path_permission(&path, &nd.path, MAY_WRITE);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -263,6 +271,12 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
+	error = union_copyup_len(&nd, &path, length);
+	if (error)
+		goto mnt_drop_write_and_out;
+
+	/* path may have changed after copyup */
+	inode = path.dentry->d_inode;
 	error = get_write_access(inode);
 	if (error)
 		goto mnt_drop_write_and_out;
@@ -284,9 +298,11 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 put_write_and_out:
 	put_write_access(inode);
 mnt_drop_write_and_out:
-	mnt_drop_write(path.mnt);
+	mnt_drop_write(mnt);
 dput_and_out:
 	path_put(&path);
+	path_put(&nd.path);
+	putname(tmp);
 out:
 	return error;
 }
-- 
1.6.3.3

