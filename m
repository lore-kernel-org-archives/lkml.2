Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0DOXGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab0DOXF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:05:56 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 07/35] whiteout: Allow removal of a directory with whiteouts
Date: Thu, 15 Apr 2010 16:04:14 -0700
Message-Id: <1271372682-21225-8-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-7-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

do_whiteout() allows removal of a directory when it has whiteouts but
is logically empty.

XXX - This patch abuses readdir() to check if the union directory is
logically empty - that is, all the entries are whiteouts (or "." or
"..").  Currently, we have no clean VFS interface to ask the lower
file system if a directory is empty.

Fixes:
 - Add ->is_directory_empty() op
 - Add is_directory_empty flag to dentry (ugly dcache populate)
 - Ask underlying fs to remove it and look for an error return
 - (your idea here)

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 956083a..991767b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2307,6 +2307,94 @@ int path_whiteout(struct path *dir_path, struct dentry *dentry, int isdir)
 EXPORT_SYMBOL(path_whiteout);
 
 /*
+ * XXX - We are abusing readdir to check if a union directory is
+ * logically empty.
+ */
+static int filldir_is_empty(void *__buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	int *is_empty = (int *)__buf;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (d_type == DT_WHT)
+		return 0;
+
+	(*is_empty) = 0;
+	return 0;
+}
+
+static int directory_is_empty(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct file *file;
+	int err;
+	int is_empty = 1;
+
+	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
+
+	/* references for the file pointer */
+	dget(dentry);
+	mntget(mnt);
+
+	file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
+	if (IS_ERR(file))
+		return 0;
+
+	err = vfs_readdir(file, filldir_is_empty, &is_empty);
+
+	fput(file);
+	return is_empty;
+}
+
+static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
+{
+	struct path safe = { .dentry = dget(nd->path.dentry),
+			     .mnt = mntget(nd->path.mnt) };
+	struct dentry *dentry = path->dentry;
+	int err;
+
+	err = may_whiteout(nd->path.dentry->d_inode, dentry, isdir);
+	if (err)
+		goto out;
+
+	err = -ENOENT;
+	if (!dentry->d_inode)
+		goto out;
+
+	err = -ENOTEMPTY;
+	if (isdir && !directory_is_empty(path->dentry, path->mnt))
+		goto out;
+
+	if (nd->path.dentry != dentry->d_parent) {
+		dentry = __lookup_hash(&path->dentry->d_name, nd->path.dentry,
+				       nd);
+		err = PTR_ERR(dentry);
+		if (IS_ERR(dentry))
+			goto out;
+
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		path->mnt = nd->path.mnt;
+		path->dentry = dentry;
+	}
+
+	err = vfs_whiteout(nd->path.dentry->d_inode, dentry, isdir);
+
+out:
+	path_put(&safe);
+	return err;
+}
+
+/*
  * We try to drop the dentry early: we should have
  * a usage count of 2 if we're the only user of this
  * dentry, and if that is true (possibly after pruning
-- 
1.6.3.3

