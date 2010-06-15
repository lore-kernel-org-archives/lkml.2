Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab0FOSmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406Ab0FOSmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:03 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 33/38] union-mount: Implement union-aware truncate()
Date: Tue, 15 Jun 2010 11:40:03 -0700
Message-Id: <1276627208-17242-34-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/open.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 68c97dd..3c1ae55 100644
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

