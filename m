Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab0ECXX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759861Ab0ECXNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:13:21 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 08/39] whiteout: Allow removal of a directory with whiteouts
Date: Mon,  3 May 2010 16:12:07 -0700
Message-Id: <1272928358-20854-9-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
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
index ce32e66..7e2c31f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2309,6 +2309,94 @@ int path_whiteout(struct path *dir_path, struct dentry *dentry, int isdir)
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

