Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0DOXI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab0DOXHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:38 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 33/35] union-mount: Implement union-aware chmod()/fchmodat()
Date: Thu, 15 Apr 2010 16:04:40 -0700
Message-Id: <1271372682-21225-34-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-33-git-send-email-vaurora@redhat.com>
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
 <1271372682-21225-33-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/open.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index dda1b6f..6ec99e9 100644
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
+	if (IS_UNIONED_DIR(&nd.path))
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

