Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab0DOXIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975Ab0DOXH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:28 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 30/35] union-mount: Implement union-aware writable open()
Date: Thu, 15 Apr 2010 16:04:37 -0700
Message-Id: <1271372682-21225-31-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-30-git-send-email-vaurora@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy up a file when opened with write permissions.  Does not copy up
the file data when O_TRUNC is specified.
---
 fs/namei.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a6f7d5d..85a5451 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1929,6 +1929,24 @@ exit:
 	return ERR_PTR(error);
 }
 
+static int open_union_copyup(struct nameidata *nd, struct path *path,
+			     int open_flag)
+{
+	struct vfsmount *oldmnt = path->mnt;
+	int error;
+
+	if (open_flag & O_TRUNC)
+		error = union_copyup_len(nd, path, 0);
+	else
+		error = union_copyup(nd, path);
+	if (error)
+		return error;
+	if (oldmnt != path->mnt)
+		mntput(nd->path.mnt);
+
+	return error;
+}
+
 static struct file *do_last(struct nameidata *nd, struct path *path,
 			    int open_flag, int acc_mode,
 			    int mode, const char *pathname,
@@ -1979,6 +1997,11 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		error = -ENOTDIR;
 		if (*want_dir && !path->dentry->d_inode->i_op->lookup)
 			goto exit_dput;
+		if (acc_mode & MAY_WRITE) {
+			error = open_union_copyup(nd, path, open_flag);
+			if (error)
+				goto exit_dput;
+		}
 		path_to_nameidata(path, nd);
 		audit_inode(pathname, nd->path.dentry);
 		goto ok;
@@ -2050,6 +2073,11 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (path->dentry->d_inode->i_op->follow_link)
 		return NULL;
 
+	if (acc_mode & MAY_WRITE) {
+		error = open_union_copyup(nd, path, open_flag);
+		if (error)
+			goto exit_dput;
+	}
 	path_to_nameidata(path, nd);
 	error = -EISDIR;
 	if (S_ISDIR(path->dentry->d_inode->i_mode))
-- 
1.6.3.3

