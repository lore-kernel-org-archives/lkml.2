Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0HHPz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:55:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab0HHPzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:55:50 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 34/39] union-mount: Implement union-aware truncate()
Date: Sun,  8 Aug 2010 11:52:51 -0400
Message-Id: <1281282776-5447-35-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/open.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 8588b31..e4fc8e5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -64,14 +64,17 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
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
@@ -85,11 +88,16 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = mnt_want_write(path.mnt);
+	if (IS_DIR_UNIONED(nd.path.dentry))
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
 
@@ -97,6 +105,12 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
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
@@ -118,9 +132,11 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
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

