Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2C1U35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:29:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60199 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611Ab2C1UY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:24:29 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 01/16] vfs: split do_lookup()
Date: Wed, 28 Mar 2012 22:24:30 +0200
Message-Id: <1332966285-30358-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
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
 fs/namei.c |   56 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d15d0ba..936648c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1142,8 +1142,8 @@ static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
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
@@ -1212,7 +1212,6 @@ unlazy:
 		}
 	}
 
-success:
 	path->mnt = mnt;
 	path->dentry = dentry;
 	err = follow_managed(path, nd);
@@ -1224,6 +1223,17 @@ success:
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
@@ -1232,7 +1242,14 @@ need_lookup:
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	goto success;
+	path->mnt = nd->path.mnt;
+	path->dentry = dentry;
+	err = follow_managed(path, nd);
+	if (unlikely(err)) {
+		path_put_conditional(path, nd);
+		return err;
+	}
+	return 0;
 }
 
 static inline int may_lookup(struct nameidata *nd)
@@ -1304,21 +1321,26 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
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
@@ -1327,6 +1349,12 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
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

