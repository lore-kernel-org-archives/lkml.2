Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2DEO7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60434 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2DEO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:38 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 01/34] vfs: split do_lookup()
Date: Thu,  5 Apr 2012 16:58:27 +0200
Message-Id: <1333637940-31884-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Split do_lookup() into two functions:

  lookup_fast() - does cached lookup without i_mutex
  lookup_slow() - does lookup with i_mutex

Both follow managed dentries.

The new functions are needed by atomic_open.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   59 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1898198..338410a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1138,8 +1138,8 @@ static struct dentry *__lookup_hash(struct qstr *name,
  *  small and for now I'd prefer to have fast path as straight as possible.
  *  It _is_ time-critical.
  */
-static int do_lookup(struct nameidata *nd, struct qstr *name,
-			struct path *path, struct inode **inode)
+static int lookup_fast(struct nameidata *nd, struct qstr *name,
+		       struct path *path, struct inode **inode)
 {
 	struct vfsmount *mnt = nd->path.mnt;
 	struct dentry *dentry, *parent = nd->path.dentry;
@@ -1208,7 +1208,7 @@ unlazy:
 			goto need_lookup;
 		}
 	}
-done:
+
 	path->mnt = mnt;
 	path->dentry = dentry;
 	err = follow_managed(path, nd->flags);
@@ -1222,6 +1222,17 @@ done:
 	return 0;
 
 need_lookup:
+	return 1;
+}
+
+/* Fast lookup failed, do it the slow way */
+static int lookup_slow(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
+{
+	struct dentry *dentry, *parent;
+	int err;
+
+	parent = nd->path.dentry;
 	BUG_ON(nd->inode != parent->d_inode);
 
 	mutex_lock(&parent->d_inode->i_mutex);
@@ -1229,7 +1240,16 @@ need_lookup:
 	mutex_unlock(&parent->d_inode->i_mutex);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-	goto done;
+	path->mnt = nd->path.mnt;
+	path->dentry = dentry;
+	err = follow_managed(path, nd->flags);
+	if (unlikely(err < 0)) {
+		path_put_conditional(path, nd);
+		return err;
+	}
+	if (err)
+		nd->flags |= LOOKUP_JUMPED;
+	return 0;
 }
 
 static inline int may_lookup(struct nameidata *nd)
@@ -1301,21 +1321,26 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 	 */
 	if (unlikely(type != LAST_NORM))
 		return handle_dots(nd, type);
-	err = do_lookup(nd, name, path, &inode);
+	err = lookup_fast(nd, name, path, &inode);
 	if (unlikely(err)) {
-		terminate_walk(nd);
-		return err;
-	}
-	if (!inode) {
-		path_to_nameidata(path, nd);
-		terminate_walk(nd);
-		return -ENOENT;
+		if (err < 0)
+			goto out_err;
+
+		err = lookup_slow(nd, name, path);
+		if (err < 0)
+			goto out_err;
+
+		inode = path->dentry->d_inode;
 	}
+	err = -ENOENT;
+	if (!inode)
+		goto out_path_put;
+
 	if (should_follow_link(inode, follow)) {
 		if (nd->flags & LOOKUP_RCU) {
 			if (unlikely(unlazy_walk(nd, path->dentry))) {
-				terminate_walk(nd);
-				return -ECHILD;
+				err = -ECHILD;
+				goto out_err;
 			}
 		}
 		BUG_ON(inode != path->dentry->d_inode);
@@ -1324,6 +1349,12 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 	path_to_nameidata(path, nd);
 	nd->inode = inode;
 	return 0;
+
+out_path_put:
+	path_to_nameidata(path, nd);
+out_err:
+	terminate_walk(nd);
+	return err;
 }
 
 /*
-- 
1.7.7

