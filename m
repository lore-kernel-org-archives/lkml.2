Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2CZKyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:54:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51418 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab2CZKyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:54:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 5/6] vfs: reorganize do_lookup
Date: Mon, 26 Mar 2012 12:54:23 +0200
Message-Id: <1332759264-23533-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

do_lookup's uncached lookup part basically open codes __lookup_hash so use that
instead.

This also eliminates the weird retry loop, that could, in theory, retry the
cached lookup any number of times (very unlikely scenario: needs two parallel
do_lookups and d_revalidate always returning zero).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |  136 +++++++++++++++++++++++++----------------------------------
 1 files changed, 58 insertions(+), 78 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 482992e..d500cb0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1112,6 +1112,46 @@ static struct dentry *d_inode_lookup(struct dentry *parent, struct dentry *dentr
 	return dentry;
 }
 
+static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
+				    struct nameidata *nd)
+{
+	struct dentry *dentry;
+
+	dentry = d_lookup(base, name);
+
+	if (dentry && d_need_lookup(dentry)) {
+		/*
+		 * __lookup_hash is called with the parent dir's i_mutex already
+		 * held, so we are good to go here.
+		 */
+		return d_inode_lookup(base, dentry, nd);
+	}
+
+	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE)) {
+		int status = d_revalidate(dentry, nd);
+		if (unlikely(status <= 0)) {
+			/*
+			 * The dentry failed validation.
+			 * If d_revalidate returned 0 attempt to invalidate
+			 * the dentry otherwise d_revalidate is asking us
+			 * to return a fail status.
+			 */
+			if (status < 0) {
+				dput(dentry);
+				return ERR_PTR(status);
+			} else if (!d_invalidate(dentry)) {
+				dput(dentry);
+				dentry = NULL;
+			}
+		}
+	}
+
+	if (!dentry)
+		dentry = d_alloc_and_lookup(base, name, nd);
+
+	return dentry;
+}
+
 /*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
@@ -1167,37 +1207,12 @@ unlazy:
 		dentry = __d_lookup(parent, name);
 	}
 
-	if (dentry && unlikely(d_need_lookup(dentry))) {
-		dput(dentry);
-		dentry = NULL;
-	}
-retry:
-	if (unlikely(!dentry)) {
-		struct inode *dir = parent->d_inode;
-		BUG_ON(nd->inode != dir);
+	if (unlikely(!dentry))
+		goto need_lookup;
 
-		mutex_lock(&dir->i_mutex);
-		dentry = d_lookup(parent, name);
-		if (likely(!dentry)) {
-			dentry = d_alloc_and_lookup(parent, name, nd);
-			if (IS_ERR(dentry)) {
-				mutex_unlock(&dir->i_mutex);
-				return PTR_ERR(dentry);
-			}
-			/* known good */
-			need_reval = 0;
-			status = 1;
-		} else if (unlikely(d_need_lookup(dentry))) {
-			dentry = d_inode_lookup(parent, dentry, nd);
-			if (IS_ERR(dentry)) {
-				mutex_unlock(&dir->i_mutex);
-				return PTR_ERR(dentry);
-			}
-			/* known good */
-			need_reval = 0;
-			status = 1;
-		}
-		mutex_unlock(&dir->i_mutex);
+	if (unlikely(d_need_lookup(dentry))) {
+		dput(dentry);
+		goto need_lookup;
 	}
 	if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE) && need_reval)
 		status = d_revalidate(dentry, nd);
@@ -1208,12 +1223,11 @@ retry:
 		}
 		if (!d_invalidate(dentry)) {
 			dput(dentry);
-			dentry = NULL;
-			need_reval = 1;
-			goto retry;
+			goto need_lookup;
 		}
 	}
 
+success:
 	path->mnt = mnt;
 	path->dentry = dentry;
 	err = follow_managed(path, nd);
@@ -1223,6 +1237,17 @@ retry:
 	}
 	*inode = path->dentry->d_inode;
 	return 0;
+
+need_lookup:
+	BUG_ON(nd->inode != parent->d_inode);
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	dentry = __lookup_hash(name, parent, nd);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	goto success;
 }
 
 static inline int may_lookup(struct nameidata *nd)
@@ -1725,51 +1750,6 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 	return err;
 }
 
-static struct dentry *__lookup_hash(struct qstr *name,
-		struct dentry *base, struct nameidata *nd)
-{
-	struct dentry *dentry;
-
-	/*
-	 * Don't bother with __d_lookup: callers are for creat as
-	 * well as unlink, so a lot of the time it would cost
-	 * a double lookup.
-	 */
-	dentry = d_lookup(base, name);
-
-	if (dentry && d_need_lookup(dentry)) {
-		/*
-		 * __lookup_hash is called with the parent dir's i_mutex already
-		 * held, so we are good to go here.
-		 */
-		return d_inode_lookup(base, dentry, nd);
-	}
-
-	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE)) {
-		int status = d_revalidate(dentry, nd);
-		if (unlikely(status <= 0)) {
-			/*
-			 * The dentry failed validation.
-			 * If d_revalidate returned 0 attempt to invalidate
-			 * the dentry otherwise d_revalidate is asking us
-			 * to return a fail status.
-			 */
-			if (status < 0) {
-				dput(dentry);
-				return ERR_PTR(status);
-			} else if (!d_invalidate(dentry)) {
-				dput(dentry);
-				dentry = NULL;
-			}
-		}
-	}
-
-	if (!dentry)
-		dentry = d_alloc_and_lookup(base, name, nd);
-
-	return dentry;
-}
-
 /*
  * Restricted form of lookup. Doesn't follow links, single-component only,
  * needs parent already locked. Doesn't follow mounts.
-- 
1.7.7

