Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab0FYTIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:08:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab0FYTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:07:25 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 34/38] union-mount: Implement union-aware chmod()/fchmodat()
Date: Fri, 25 Jun 2010 12:05:24 -0700
Message-Id: <1277492728-11446-35-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/open.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3c1ae55..336fe01 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -669,18 +669,32 @@ out:
 SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, mode_t, mode)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
 	struct inode *inode;
+	char *tmp;
 	int error;
 	struct iattr newattrs;
 
-	error = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
+	error = user_path_nd(dfd, filename, LOOKUP_FOLLOW, &nd,
+				     &path, &tmp);
 	if (error)
 		goto out;
-	inode = path.dentry->d_inode;
 
-	error = mnt_want_write(path.mnt);
+	if (IS_DIR_UNIONED(nd.path.dentry))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
+	error = mnt_want_write(mnt);
 	if (error)
 		goto dput_and_out;
+
+	error = union_copyup(&nd, &path);
+	if (error)
+		goto mnt_drop_write_and_out;
+
+	inode = path.dentry->d_inode;
 	mutex_lock(&inode->i_mutex);
 	error = security_path_chmod(path.dentry, path.mnt, mode);
 	if (error)
@@ -692,9 +706,12 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, mode_t, mode)
 	error = notify_change(path.dentry, &newattrs);
 out_unlock:
 	mutex_unlock(&inode->i_mutex);
-	mnt_drop_write(path.mnt);
+mnt_drop_write_and_out:
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

