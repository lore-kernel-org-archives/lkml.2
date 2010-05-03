Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0ECXRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:17:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab0ECXOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:14:06 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 34/39] union-mount: Implement union-aware truncate()
Date: Mon,  3 May 2010 16:12:33 -0700
Message-Id: <1272928358-20854-35-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/open.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 808d32a..fa3ecae 100644
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

