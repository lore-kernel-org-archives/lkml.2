Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0HHPyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:54:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0HHPya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:54:30 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 08/39] whiteout: Allow removal of a directory with whiteouts
Date: Sun,  8 Aug 2010 11:52:25 -0400
Message-Id: <1281282776-5447-9-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
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
 fs/namei.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index cd8b0d0..0b6378e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2250,6 +2250,90 @@ static int vfs_whiteout(struct inode *dir, struct dentry *old_dentry, int isdir)
 }
 
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
+static int directory_is_empty(struct path *path)
+{
+	struct file *file;
+	int err;
+	int is_empty = 1;
+
+	BUG_ON(!S_ISDIR(path->dentry->d_inode->i_mode));
+
+	/* references for the file pointer */
+	path_get(path);
+
+	file = dentry_open(path->dentry, path->mnt, O_RDONLY, current_cred());
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
+	struct path safe = nd->path;
+	struct dentry *dentry = path->dentry;
+	int err;
+
+	path_get(&safe);
+
+	err = may_delete(nd->path.dentry->d_inode, dentry, isdir);
+	if (err)
+		goto out;
+
+	err = -ENOTEMPTY;
+	if (isdir && !directory_is_empty(path))
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

