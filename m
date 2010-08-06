Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935630Ab0HFWhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:37:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935564Ab0HFWhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:37:12 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 31/38] union-mount: Implement union-aware writable open()
Date: Fri,  6 Aug 2010 15:35:17 -0700
Message-Id: <1281134124-17041-32-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy up a file when opened with write permissions.  Does not copy up
the file data when O_TRUNC is specified.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 67ebf4a..88d1a79 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1911,6 +1911,24 @@ exit:
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
 			    int mode, const char *pathname)
@@ -1962,6 +1980,11 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			if (!path->dentry->d_inode->i_op->lookup)
 				goto exit_dput;
 		}
+		if (acc_mode & MAY_WRITE) {
+			error = open_union_copyup(nd, path, open_flag);
+			if (error)
+				goto exit_dput;
+		}
 		path_to_nameidata(path, nd);
 		audit_inode(pathname, nd->path.dentry);
 		goto ok;
@@ -2033,6 +2056,11 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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

